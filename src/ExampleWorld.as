package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flat2d.core.FlatEngine;
	import flat2d.core.FlatGame;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatCircle;
	import flat2d.entities.FlatEntity;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import flat2d.utils.PhysicsAtlas;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	/**
	 * ExampleWorld.as
	 * Created On:	22/01/2013 20:26
	 * Author:		Joshua Barnett
	 */
	
	public class ExampleWorld extends FlatWorld 
	{
		[Embed(source="../assets/logo_inverted.png")]
		private var logoPNG:Class;
		
		[Embed(source = "../assets/landscape.xml", mimeType="application/octet-stream")]
		private var landscapeXML:Class;
		
		[Embed(source = "../assets/landscape.png")]
		private var landscapePNG:Class;
		
		private var _player:ExamplePlayer;
		private var _objects:Vector.<FlatEntity>;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, new b2Vec2(0, 10));
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			createInfo();
			createLandscape();
			createFrame();
			createRandomObjects(10);
			createPlayer();
			
			KeyManager.pressed(Key.A, function():void { addEntity(_player) } );
			KeyManager.pressed(Key.R, function():void { removeEntity(_player) } );
			KeyManager.pressed(Key.P, togglePause);
			KeyManager.pressed(Key.T, toggleType);
			KeyManager.pressed(Key.D, toggleDebug);
		}
		
		private function createInfo():void 
		{
			var logo:Image				= new Image(Texture.fromBitmap(new logoPNG));
			logo.x						= stage.stageWidth  / 2 - logo.width  / 2;
			logo.y						= stage.stageHeight / 2 - logo.height / 2;
			addChild(logo);
			
			var infoText:String			=
			"A = Add Player\n"			+
			"R = Remove Player\n"		+
			"P = Pause\n"				+
			"T = Toggle Body Type\n"	+
			"D = Debug Draw\n"			+
			"Left/Right = Movement\n"	+
			"Up = Jump";
			
			var infoField:TextField		= new TextField(250, 150, infoText, "Verdana", 18, 0xFFFFFF);
			infoField.x					= 20;
			infoField.y					= 20;
			infoField.hAlign			= HAlign.LEFT;
			addChild(infoField);
		}
		
		private function createLandscape():void 
		{
			var physicsAtlas:PhysicsAtlas		= new PhysicsAtlas(XML(new landscapeXML));
			
			var entities:Vector.<FlatEntity>	= physicsAtlas.getEntities(1 / FlatGame.PTM);
			entities[0].x						= stage.stageWidth  * 0.5;
			entities[0].y						= stage.stageHeight * 0.65;
			entities[0].view					= new Image(Texture.fromBitmap(new landscapePNG));
			entities[0].view.pivotX				= entities[0].view.width / 2;
			entities[0].view.pivotY				= entities[0].view.height / 2;
			
			var level:FlatEntity				= addEntity(entities[0], true);
		}
		
		private function createFrame():void
		{
			var size:Number			= 10;
			
			var left:FlatBox		= new FlatBox(size / 2, stage.stageHeight / 2, size, stage.stageHeight);
			var right:FlatBox		= new FlatBox(stage.stageWidth - size / 2, stage.stageHeight / 2, size, stage.stageHeight);
			var up:FlatBox			= new FlatBox(stage.stageWidth / 2, size / 2, stage.stageWidth, size);
			var down:FlatBox		= new FlatBox(stage.stageWidth / 2, stage.stageHeight - size / 2, stage.stageWidth, size);
			
			var frame:Vector.<FlatBox>	= Vector.<FlatBox>([left, right, up, down]);
			
			for each(var side:FlatBox in frame)
			{
				side.bodyDef.type	= b2Body.b2_staticBody;
				addEntity(side);
			}
		}
		
		private function createPlayer():void
		{
			_player	= new ExamplePlayer(stage.stageWidth / 2, 100);
			addEntity(_player, true);
		}
		
		private function toggleType():void 
		{
			for each(var object:FlatEntity in _objects)
			{
				object.body.SetType(object.body.GetType() == b2Body.b2_staticBody ? b2Body.b2_dynamicBody : b2Body.b2_staticBody);
				removeEntity(object);
				addEntity(object);
			}
		}
		
		private function toggleDebug():void 
		{
			FlatEngine.debug	= !FlatEngine.debug;
		}
		
		private function createRandomObjects(num:int = 10, min:Number = 20, max:Number = 40):void 
		{
			_objects	= new Vector.<FlatEntity>();
			
			for (var i:int = 0; i < num; ++i)
			{
				if ((Math.random() > .5) ? true : false)
				{
					_objects.push(addEntity(new FlatBox(100 + Math.random() * 600, 40 + Math.random() * 100, min + Math.random() * (max - min), min + Math.random() * (max - min), Math.random() * 0xFFFFFF), true));
				} else {
					_objects.push(addEntity(new FlatCircle(100 + Math.random() * 600, 40 + Math.random() * 100, min + Math.random() * (max - min), Math.random() * 0xFFFFFF), true));
				}
			}
		}
	}
}