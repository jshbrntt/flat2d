package  
{
	import flash.utils.ByteArray;
	import flat2d.core.FlatGame;
	import flat2d.core.FlatWorld;
	import flat2d.effects.Explode;
	import flat2d.effects.Fragile;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatEntity;
	import flat2d.entities.FlatHandJoint;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.BodyAtlas;
	import flat2d.utils.InteractionManager;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
<<<<<<< HEAD
=======
	import nape.phys.Body;
>>>>>>> no message
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import starling.display.Image;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ExampleWorld.as
	 * Created On:	22/01/2013 20:26
	 * Author:		Joshua Barnett
	 */
	
	public class ExampleWorld extends FlatWorld
	{
		[Embed(source = "../assets/logo/logo_trans2.png")]
		private const _logoPNG		:Class;
		[Embed(source = "../assets/physics.json", mimeType="application/octet-stream")]
		private const _physicsJSON	:Class
		[Embed(source = "../assets/landscape.png")]
		private const _landscapePNG	:Class;
		[Embed(source = "../assets/bounceBox.png")]
		private const _bounceBoxPNG	:Class;
		[Embed(source = "../assets/button.png")]
		private const _buttonPNG	:Class;
		[Embed(source = "../assets/cradle.png")]
		private const _cradlePNG	:Class;
		
<<<<<<< HEAD
		private var _player		:ExamplePlayer;
		private var _landscape	:FlatEntity;
		private var _bounceBox	:FlatEntity;
		private var _button		:FlatEntity;
		private var _objects	:Vector.<FlatEntity>;
		private var _handJoint	:FlatHandJoint;
		private var _bodyAtlas	:BodyAtlas;
		private var _pentagon	:Explode;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, new Vec2(0, 600));
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function dispose():void 
		{
			KeyManager.removePressed(Key.P, togglePause);
			KeyManager.removePressed(Key.D, toggleDebug);
			InteractionManager.dispose();
			_player			= null;
			_landscape		= null;
			_bounceBox		= null;
			_objects.length	= 0;
			_objects		= null
			super.dispose();
=======
		private var _player:ExamplePlayer;
		private var _landscape:FlatEntity;
		private var _objects:Vector.<FlatEntity>;
		private var _frame:Vector.<FlatEntity>;
		private var _handJoint:FlatHandJoint;
		private var _bodyAtlas:BodyAtlas;
		public static var numSlices:int;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, Vec2.weak(0, 0));
>>>>>>> no message
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
<<<<<<< HEAD
			_bodyAtlas	= new BodyAtlas(ByteArray(new _physicsJSON).toString());
			
			KeyManager.pressed(Key.P, togglePause);
			KeyManager.pressed(Key.D, toggleDebug);
			
			_pentagon				= new Explode(stage.stageWidth / 2, stage.stageHeight / 2, _bodyAtlas.getHull("cradle"), null, false, 0x00FF00);
			_pentagon.body.type		= BodyType.STATIC;
			_pentagon.view			= new Image(Texture.fromBitmap(new _cradlePNG));
			_pentagon.view.pivotX	= _pentagon.view.width / 2;
			_pentagon.view.pivotY	= _pentagon.view.height / 2;
			addEntity(_pentagon);
			
			createInfo();
			createHandJoint();
			createObjects(5, 20, 40);
			createLandscape();
			createPlayer();
			createBounceBox();
			createButton();
			createFrame();
			createInteractions();
=======
			numSlices	= 100;
			
			createInfo();
			//createPlayer();
			//createLandscape();
			
			
			var glass:Shatter	= new Shatter(stage.stageWidth / 2, stage.stageHeight / 2, Polygon.regular(200, 200, 5));
			addEntity(glass);
			
			//createGlass();
			//createRandomObjects(500, 8, 14);
			createFrame();
			
			//addEntity(new FlatPoly(300, 300, Polygon.regular(100, 50, 5)));
			
			_handJoint	= new FlatHandJoint(this);
			
			KeyManager.pressed(Key.DELETE, toggleDebug);
			KeyManager.pressed(Key.D, toggleDebug);
			KeyManager.pressed(Key.P, togglePause);
			KeyManager.pressedOnce(Key.R, function():void { game.state	= new ExampleWorld(game); } );
			KeyManager.pressed(Key.DIGIT_1, function():void { numSlices = 1; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_2, function():void { numSlices = 2; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_3, function():void { numSlices = 3; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_4, function():void { numSlices = 4; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_5, function():void { numSlices = 5; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_6, function():void { numSlices = 6; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_7, function():void { numSlices = 7; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_8, function():void { numSlices = 8; updateInfoText() } );
			KeyManager.pressed(Key.DIGIT_9, function():void { numSlices = 9; updateInfoText() } );
		}
		
		private function createGlass(num:int = 10, min:Number = 50, max:Number = 90):void 
		{
			_objects	= new Vector.<FlatEntity>();
			
			for (var i:int = 0; i < num; ++i)
			{
				var glass:Shatter = new Shatter
				(
					randLim(50, stage.stageWidth - 50),
					randLim(50, stage.stageHeight - 50),
					Polygon.regular
					(
						randLim(min, max),
						randLim(min, max),
						int(randLim(3, 7))
					),
					null, false, 0x0099FF, true, 0xFF0000
				);
				
				addEntity(glass, true);
			}
		}
		
		private function randLim(min:Number, max:Number):Number
		{
			return min + Math.random() * (max - min);
		}
		
		private var _logo:Image;
		private var _infoText:String;
		private var _infoField:TextField;
		
		private function updateInfoText():void
		{
			_infoText			=
			"P = Pause\n"						+
			"R = Reset\n"						+
			"D = Debug Draw\n"					+
			"F + Click = Shatter Entity\n"		+
			"1-9 = Select Slices\n"	+
			"Slices = " + numSlices;
			_infoField.text	= _infoText;
>>>>>>> no message
		}
		
		private function createInfo():void 
		{
<<<<<<< HEAD
			var logo:Image				= new Image(Texture.fromBitmap(new _logoPNG));
			logo.x						= stage.stageWidth  / 2 - logo.width  / 2;
			logo.y						= stage.stageHeight / 2 - logo.height / 2;
			addChildAt(logo, 0);
			
			var infoText:String			=
			"P = Pause\n"				+
			"D = Debug Draw\n"			+
			"Left/Right = Movement\n"	+
			"Up = Jump";
			
			var infoField:TextField		= new TextField(300, 200, infoText, "Verdana", 18, 0x000000);
			infoField.x					= 20;
			infoField.y					= 20;
			infoField.hAlign			= HAlign.LEFT;
			infoField.vAlign			= VAlign.TOP;
			addChild(infoField);
=======
			_logo			= new Image(Texture.fromBitmap(new logoPNG));
			_logo.x			= stage.stageWidth  / 2 - _logo.width  / 2;
			_logo.y			= stage.stageHeight / 2 - _logo.height / 2;
			addChildAt(_logo, 0);
			
			_infoText			=
			"P = Pause\n"						+
			"R = Reset\n"						+
			"D = Debug Draw\n"					+
			"F + Click = Shatter Entity\n"		+
			"1-9 = Select Slices\n"	+
			"Slices = " + numSlices;
			
			_infoField			= new TextField(stage.stageWidth, stage.stageHeight, _infoText, "Verdana", 18, 0xFFFFFF);
			_infoField.x		= 20;
			_infoField.y		= 20;
			_infoField.vAlign	= VAlign.TOP;
			_infoField.hAlign	= HAlign.LEFT;
			addChild(_infoField);
>>>>>>> no message
		}
		
		private function createHandJoint():void 
		{
			_handJoint	= new FlatHandJoint(space);
		}
		
		private function createObjects(num:int = 10, min:Number = 20, max:Number = 40):void 
		{
			_objects	= new Vector.<FlatEntity>();
			
			for (var i:int = 0; i < num; ++i)
			{
				_objects.push(addEntity(new Fragile(randLim(100, 700), 100, Vec2List.fromArray(Polygon.regular(randLim(min, max), randLim(min, max), int(randLim(3, 9)))), null, false, Math.random() * 0xFFFFFF)));
			}
			
			function randLim(min:Number, max:Number):Number
			{
				return min + Math.random() * (max - min);
			}
		}
		
<<<<<<< HEAD
		private function createLandscape():void 
		{
			_landscape					= new FlatEntity(stage.stageWidth / 2, stage.stageHeight / 2, null);
			_landscape.body				= _bodyAtlas.getBody("landscape");
			_landscape.view				= new Image(Texture.fromBitmap(new _landscapePNG))
			_landscape.view.pivotX		= _landscape.view.width / 2;
			_landscape.view.pivotY		= _landscape.view.height / 2;
			addEntity(_landscape);
		}
		
		private function createPlayer():void
		{
			_player	= new ExamplePlayer(stage.stageWidth / 2, stage.stageHeight / 2);
			_player.worldView	= view;
			addEntity(_player);
		}
		
		private function createBounceBox():void 
		{
			_bounceBox				= new FlatEntity(380, 580, new Image(Texture.fromBitmap(new _bounceBoxPNG)));
			_bounceBox.body			= _bodyAtlas.getBody("bounceBox");
			_bounceBox.view.pivotX	= _bounceBox.view.width / 2;
			_bounceBox.view.pivotY	= _bounceBox.view.height / 2;
			addEntity(_bounceBox);
		}
		
		private function createButton():void 
		{
			_button					= new FlatEntity(16, 400, new Image(Texture.fromBitmap(new _buttonPNG)));
			_button.body			= _bodyAtlas.getBody("button");
			_button.view.pivotX		= _button.view.width / 2;
			_button.view.pivotY		= _button.view.height / 2;
			addEntity(_button);
		}
		
		private function createFrame():void 
		{
			var size:Number			= 10;
			var left:FlatBox		= new FlatBox(size / 2, stage.stageHeight / 2, size, stage.stageHeight, null, true, 0x000000);
			var right:FlatBox		= new FlatBox(stage.stageWidth - size / 2, stage.stageHeight / 2, size, stage.stageHeight, null, true, 0x000000);
			var up:FlatBox			= new FlatBox(stage.stageWidth / 2, size / 2, stage.stageWidth, size, null, true, 0x000000);
			var down:FlatBox		= new FlatBox(stage.stageWidth / 2, stage.stageHeight - size / 2, stage.stageWidth, size, null, true, 0x000000);
			
			var frame:Vector.<FlatBox>	= Vector.<FlatBox>([left, right, up, down]);
			
			for each(var side:FlatBox in frame)
=======
		private function createFrame(size:Number = 10):void
		{
			_frame	= new Vector.<FlatEntity>();
			_frame.push(new FlatBox(size / 2, stage.stageHeight / 2, size, stage.stageHeight));						// LEFT
			_frame.push(new FlatBox(stage.stageWidth - size / 2, stage.stageHeight / 2, size, stage.stageHeight));	// RIGHT
			_frame.push(new FlatBox(stage.stageWidth / 2, size / 2, stage.stageWidth, size));						// UP
			_frame.push(new FlatBox(stage.stageWidth / 2, stage.stageHeight - size / 2, stage.stageWidth, size));	// DOWN
			
			for each(var side:FlatBox in _frame)
>>>>>>> no message
			{
				side.body.type		= BodyType.STATIC;
				addEntity(side);
			}
		}
		
		private function createInteractions():void 
		{
			InteractionManager.initialize(space);
			
			InteractionManager.createGroup("player");
			InteractionManager.addToGroup(_player.body, "player");
			
			InteractionManager.createGroup("landscape");
			InteractionManager.addToGroup(_landscape.body, "landscape");
			
			InteractionManager.createGroup("objects");
			for each(var object:FlatEntity in _objects)
<<<<<<< HEAD
			{
				InteractionManager.addToGroup(object.body, "objects");
			}
			
			InteractionManager.createGroup("bounceBox");
			InteractionManager.addToGroup(_bounceBox.body, "bounceBox");
			
			InteractionManager.createGroup("button");
			InteractionManager.addToGroup(_button.body, "button");
			
			InteractionManager.beginContact("player", "button", breakPentagon);
			InteractionManager.beginContact("player", "bounceBox", bouncePlayer);
			InteractionManager.beginContact("player", "landscape", addRedGlow);
			InteractionManager.beginContact("player", "objects", addGreenGlow);
			InteractionManager.endContact("player",	"landscape", removeGlow);
			InteractionManager.endContact("player",	"objects", removeGlow);
			
			function breakPentagon():void 
			{
				if (_pentagon.body)
				{
					_pentagon.fracture(_pentagon.body.position, 5);
				}
			}
			
			function addRedGlow():void
			{
				_player.view.filter	= BlurFilter.createGlow(0xFF0000);
			}
			
			function addGreenGlow():void
			{
				_player.view.filter	= BlurFilter.createGlow(0x00FF00);
			}
			
			function removeGlow():void
			{
				_player.view.filter	= null;
			}
			
			function bouncePlayer():void
			{
				_player.body.applyImpulse(new Vec2(0, -2000));
			}
=======
				object.body.type = (object.body.type == BodyType.STATIC) ? BodyType.DYNAMIC : BodyType.STATIC;
		}
		
		override public function dispose():void 
		{
			KeyManager.remove(toggleDebug);
			if(_player)
				removeEntity(_player, true, true);
			_player		= null;
			if (_landscape)
				removeEntity(_landscape, true, true);
			_landscape	= null;
			while (_frame.length)
				removeEntity(_frame.pop(), true, true);
			_frame.length	= 0;
			/*while (_objects.length)
				removeEntity(_objects.pop(), true, true);
			_objects.length	= 0;*/
			if (_handJoint)
				_handJoint.dispose();
			_handJoint	= null;
			if (_bodyAtlas)
				_bodyAtlas.dispose();
			_bodyAtlas	= null;
			super.dispose();
>>>>>>> no message
		}
	}
}