package  
{
	import flat2d.core.FlatGame;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatCircle;
	import flat2d.entities.FlatEntity;
	import flat2d.entities.FlatHandJoint;
	import flat2d.utils.BodyAtlas;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import starling.display.Image;
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
		[Embed(source = "../assets/logo_trans_inverted.png")]
		private var logoPNG:Class;
		
		[Embed(source = "../assets/landscape.xml", mimeType="application/octet-stream")]
		private var landscapeXML:Class;
		
		[Embed(source = "../assets/landscape.png")]
		private var landscapePNG:Class;
		
		private var _player:ExamplePlayer;
		private var _landscape:FlatEntity;
		private var _objects:Vector.<FlatEntity>;
		private var _handJoint:FlatHandJoint;
		private var _bodyAtlas:BodyAtlas;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, Vec2.weak(0, 600));
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			createInfo();
			createPlayer();
			createLandscape();
			createRandomObjects(100, 8, 14);
			createFrame();
			
			_handJoint	= new FlatHandJoint(space, this);
			
			//ContactManager.beginContact("player", "ground", function():void { _player.canJump = true } );
			
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
		
		private function createPlayer():void
		{
			_player			= new ExamplePlayer(stage.stageWidth / 2, 100);
			_player.group	= "player";
			addEntity(_player, true);
		}
		
		private function createLandscape():void 
		{
			_bodyAtlas			= new BodyAtlas(XML(new landscapeXML));
			_landscape			= new FlatEntity();
			_landscape.view		= new Image(Texture.fromBitmap(new landscapePNG));
			_landscape.body		= _bodyAtlas.getBody("landscape");
			_landscape.group	= "ground";
			_landscape.x		= stage.stageWidth / 2;
			_landscape.y		= stage.stageHeight - _landscape.height / 2;
			addEntity(_landscape);
		}
		
		private function createRandomObjects(num:int = 10, min:Number = 20, max:Number = 40):void 
		{
			_objects	= new Vector.<FlatEntity>();
			
			for (var i:int = 0; i < num; ++i)
			{
				if ((Math.random() > .5) ? true : false)
				{
					_objects.push(addEntity(new FlatBox(100 + Math.random() * 600, 40 + Math.random() * 100, min + Math.random() * (max - min), min + Math.random() * (max - min), null, false, Math.random() * 0xFFFFFF), true));
				} else {
					_objects.push(addEntity(new FlatCircle(100 + Math.random() * 600, 40 + Math.random() * 100, min + Math.random() * (max - min), null, false, Math.random() * 0xFFFFFF), true));
				}
				_objects[_objects.length - 1].group = "ground";
			}
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
				side.body.type	= BodyType.STATIC;
				addEntity(side);
			}
		}
		
		private function toggleType():void 
		{
			for each(var object:FlatEntity in _objects)
			{
				object.body.type = (object.body.type == BodyType.STATIC) ? BodyType.DYNAMIC : BodyType.STATIC;
			}
		}
	}
}