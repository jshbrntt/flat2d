package  
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import flat2d.core.FlatGame;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatHandJoint;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.InteractionManager;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import flat2d.utils.SoundManager;
	import nape.callbacks.InteractionCallback;
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
	import nape.dynamics.Contact;
	import nape.dynamics.ContactList;
	import nape.geom.GeomPoly;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	/**
	 * BottlesWorld.as
	 * Created On:	22/01/2013 20:26
	 * Author:		Joshua Barnett
	 */
	
	public class BottlesWorld extends FlatWorld
	{
		[Embed(source = "../assets/background.jpg")]
		static public const backgroundJPG	:Class;
		static public const FRAGILE			:String = "fragile";
		static public const WALLS			:String = "walls";
		static public var test				:Shape;
		
		private var _handJoint				:FlatHandJoint;
		private var _textField				:TextField;
		private var _accelerometer			:Accelerometer;
		private var _gravityDelta			:Number;
		private var _background				:Image;
		
		public function BottlesWorld(game:FlatGame)
		{
			super(game, new Vec2(0, 900));
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_background	= new Image(Texture.fromBitmap(new backgroundJPG, false));
			addChildAt(_background,0);
			
			KeyManager.pressed(Key.E, togglePause);
			KeyManager.pressed(Key.D, toggleDebug);
			KeyManager.pressed(Key.C, clearTest);
			KeyManager.pressed(Key.SPACE, createBottle);
			KeyManager.pressed(Key.MENU, createBottle);
			
			setupAccelerometer();
			setupSounds();
			setupInteractions();
			
			createWalls();
			createHandJoint();
			
			_textField			= new TextField(400, 100, "RESET = [R]\nPAUSE = [E]\nSPAWN BOTTLE = [SPACE]\nDEBUG DRAW = [D]");
			_textField.hAlign	= HAlign.LEFT;
			_textField.x		= 15;
			_textField.y		= 5;
			_textField.color	= 0xFFFFFF;
			_textField.fontSize	= 16;
			addChild(_textField);
			
			test	= new Shape();
			addChild(test);
		}
		
		private function clearTest():void 
		{
			test.graphics.clear();
		}
		
		private function setupAccelerometer():void 
		{
			_gravityDelta	= 2000;
			_accelerometer	= new Accelerometer();
			_accelerometer.setRequestedUpdateInterval(1000 / 60);
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, updateGravity);
		}
		
		private function updateGravity(e:AccelerometerEvent):void 
		{
			space.gravity.setxy(-e.accelerationX * _gravityDelta, e.accelerationY * _gravityDelta);
		}
		
		private function setupSounds():void 
		{
			SoundManager.initialize();
			//SoundManager.importSound("0", "../assets/sounds/0.mp3");
			//SoundManager.importSound("1", "../assets/sounds/1.mp3");
			//SoundManager.importSound("3", "../assets/sounds/3.mp3");
			//SoundManager.importSound("5", "../assets/sounds/5.mp3");
			//SoundManager.importSound("7", "../assets/sounds/7.mp3");
			//SoundManager.importSound("10", "../assets/sounds/10.mp3");
		}
		
		private function createBottle():void 
		{
			var brand:String	= Bottle.BRANDS[Math.floor(Math.random() * Bottle.BRANDS.length)];
			var bottle:Bottle	= new Bottle(stage.stageWidth / 2, stage.stageHeight / 2, brand);
			bottle.body.velocity.setxy(Math.random() * 1000 - 500, Math.random() * 1000 - 500);
			bottle.body.angularVel	= Math.random() * (Math.PI * 2) - Math.PI;
			InteractionManager.addToGroup(bottle.body, FRAGILE);
			addEntity(bottle);
		}
		
		private function setupInteractions():void 
		{
			InteractionManager.initialize(space);
			InteractionManager.createGroup(FRAGILE);
			InteractionManager.beginContact(FRAGILE, InteractionManager.ANY_BODY, bottleBreak);
		}
		
		private function bottleBreak(collision:InteractionCallback):void 
		{
			//	CONTACT POINT
			function averageContactPoint(arbs:ArbiterList):Vec2
			{
				const single_point_scale:Number	= 0.1;
				var ret:Vec2					= new Vec2(0, 0);
				var total:Number				= 0;
				arbs.foreach(function(a:Arbiter):void
					{
						if (!a.isCollisionArbiter())
						{
							return;
						}
						var contacts:ContactList = a.collisionArbiter.contacts;
						var c1:Contact = contacts.at(0);
						if (contacts.length == 1)
						{
							ret.addeq(c1.position.mul(single_point_scale, true));
							total += single_point_scale;
						}
						else
						{
							var c2:Contact = contacts.at(1);
							var del:Vec2 = c1.position.sub(c2.position);
							var dist:Number = Math.max(del.length, single_point_scale);
							ret.addeq(c1.position.add(c2.position, true).muleq(dist * 0.5));
							total += dist;
							del.dispose();
						}
					});
				if (total == 0)
				{
					ret.dispose();
					return null;
				}
				else
				{
					return ret.muleq(1 / total);
				}
			}
			var collisionPoint:Vec2	= averageContactPoint(collision.arbiters);
			
			//	FRAGILE BODY
			var fragile:Fragile;
			if (collision.int1.castBody.userData.root is Fragile)
			{
				fragile	= collision.int1.castBody.userData.root as Fragile;
			} else if(collision.int2.castBody.userData.root is Fragile) {
				fragile	= collision.int2.castBody.userData.root as Fragile;
			}
			if (!fragile || !fragile.body)
			{
				return;
			}
			
			//	IMPACT FORCE
			var impactForce:Number	= 0;
			for (var i:int = 0; i < collision.arbiters.length; ++i)
			{
				impactForce	+= collision.arbiters.at(i).collisionArbiter.normalImpulse(fragile.body).length;
			}
			var numPieces:int	= Math.round(impactForce / (fragile.body.mass * 30000));
			
			//	FRACTURE
			if (numPieces != 0)
			{
				var pieces:Vector.<Fragile>	= fragile.fracture(new Vec2(collisionPoint.x, collisionPoint.y), numPieces);
				removeEntity(fragile);
				//addEntity(fragile);
				for each(var piece:Fragile in pieces)
				{
					addEntity(piece);
				}
			}
			
			//	SOUND
			if (numPieces >= 10)
			{
				SoundManager.playSound("10");
				return;
			}
			if (numPieces >= 7)
			{
				SoundManager.playSound("7");
				return;
			}
			if (numPieces >= 5)
			{
				SoundManager.playSound("5");
				return;
			}
			if (numPieces >= 3)
			{
				SoundManager.playSound("3");
				return;
			}
			if (numPieces >= 1)
			{
				SoundManager.playSound("1");
				return;
			}
			if (numPieces >= 0)
			{
				SoundManager.playSound("0");
				return;
			}
		}
		
		private function createWalls():void 
		{
			var size:Number			= 10;
			var left:FlatBox		= new FlatBox(size / 2, stage.stageHeight / 2, size, stage.stageHeight);
			var right:FlatBox		= new FlatBox(stage.stageWidth - size / 2, stage.stageHeight / 2, size, stage.stageHeight);
			var up:FlatBox			= new FlatBox(stage.stageWidth / 2, size / 2, stage.stageWidth, size);
			var down:FlatBox		= new FlatBox(stage.stageWidth / 2, stage.stageHeight - size / 2, stage.stageWidth, size);
			
			var walls:Vector.<FlatBox>	= Vector.<FlatBox>([left, right, up, down]);
			
			for each(var wall:FlatBox in walls)
			{
				wall.body.type		= BodyType.STATIC;
				InteractionManager.addToGroup(wall.body, WALLS);
				addEntity(wall);
			}
		}
		
		private function createHandJoint():void 
		{
			_handJoint	= new FlatHandJoint(space);
		}
		
		override public function dispose():void 
		{
			KeyManager.removePressed(Key.E, togglePause);
			KeyManager.removePressed(Key.D, toggleDebug);
			KeyManager.removePressed(Key.C, clearTest);
			KeyManager.removePressed(Key.SPACE, createBottle);
			KeyManager.removePressed(Key.MENU, createBottle);
			_accelerometer.removeEventListener(AccelerometerEvent.UPDATE, updateGravity);
			InteractionManager.dispose();
			super.dispose();
		}
	}
}