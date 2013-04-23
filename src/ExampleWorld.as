package  
{
	import flash.utils.getTimer;
	import flat2d.core.FlatEngine;
	import flat2d.core.FlatGame;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatCircle;
	import flat2d.entities.FlatEntity;
	import flat2d.entities.FlatHandJoint;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.BodyAtlas;
	import flat2d.utils.InteractionManager;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.phys.Body;
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
		[Embed(source = "../assets/logo/logo_trans_inverted.png")]
		private const _logoPNG:Class;
		[Embed(source = "../assets/landscape/landscape.xml", mimeType="application/octet-stream")]
		private const _landscapeXML:Class
		[Embed(source = "../assets/landscape/landscape.png")]
		private const _landscapePNG:Class;
		[Embed(source = "../assets/bounceBox.png")]
		private const _bounceBoxPNG:Class;
		
		private var _player:ExamplePlayer;
		private var _landscape:FlatEntity;
		private var _bounceBox:FlatBox;
		private var _objects:Vector.<FlatEntity>;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, new Vec2(0, 600));
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			KeyManager.pressed(Key.D, toggleDebug);
			
			createInfo();
			createHandJoint();
			createObjects(6, 20, 40);
			createPlayer();
			createLandscape();
			createBounceBox();
			createFrame();
			createInteractions();
		}
		
		private function createInfo():void 
		{
			var logo:Image				= new Image(Texture.fromBitmap(new _logoPNG));
			logo.x						= stage.stageWidth  / 2 - logo.width  / 2;
			logo.y						= stage.stageHeight / 2 - logo.height / 2;
			addChildAt(logo, 0);
			
			var infoText:String			=
			"P = Pause\n"				+
			"D = Debug Draw\n"			+
			"Left/Right = Movement\n"	+
			"Up = Jump";
			
			var infoField:TextField		= new TextField(250, 100, infoText, "Verdana", 18, 0xFFFFFF);
			infoField.x					= 20;
			infoField.y					= 20;
			infoField.hAlign			= HAlign.LEFT;
			addChild(infoField);
		}
		
		private function createBounceBox():void 
		{
			_bounceBox				= new FlatBox(580, 576, 100, 20, new Image(Texture.fromBitmap(new _bounceBoxPNG)));
			_bounceBox.body.type	= BodyType.STATIC;
			addEntity(_bounceBox);
		}
		
		private function createInteractions():void 
		{
			InteractionManager.init(space);
			InteractionManager.createGroup("player");
			InteractionManager.createGroup("landscape");
			InteractionManager.createGroup("objects");
			for each(var object:FlatEntity in _objects)
			{
				InteractionManager.addToGroup(object.body, "objects");
			}
			InteractionManager.createGroup("bounceBox");
			InteractionManager.addToGroup(_player.body, "player");
			InteractionManager.addToGroup(_landscape.body, "landscape");
			InteractionManager.addToGroup(_bounceBox.body, "bounceBox");
			InteractionManager.beginContact("player", "bounceBox", bouncePlayer);
			InteractionManager.beginContact("player", "landscape", addRedGlow);
			InteractionManager.beginContact("player", "objects", addGreenGlow);
			InteractionManager.endContact("player",	"landscape", removeGlow);
			InteractionManager.endContact("player",	"objects", removeGlow);
			
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
		}
		
		private function createHandJoint():void 
		{
			var handJoint:FlatHandJoint	= new FlatHandJoint(this);
		}
		
		private function createObjects(num:int = 10, min:Number = 20, max:Number = 40):void 
		{
			_objects	= new Vector.<FlatEntity>();
			
			for (var i:int = 0; i < num; ++i)
			{
				if ((Math.random() > .5) ? true : false)
				{
					_objects.push(addEntity(new FlatBox(randLim(100, 700), randLim(100, 500), randLim(min, max), randLim(min, max), null, false, Math.random() * 0xFFFFFF), true));
				} else {
					_objects.push(addEntity(new FlatCircle(randLim(100, 700), randLim(100, 500), randLim(min, max), null, false, Math.random() * 0xFFFFFF), true));
				}
			}
			function randLim(min:Number, max:Number):Number
			{
				return min + Math.random() * (max - min);
			}
		}
		
		private function createPlayer():void
		{
			_player	= new ExamplePlayer(stage.stageWidth / 2, stage.stageHeight / 2);
			addEntity(_player);
		}
		
		private function createLandscape():void 
		{
			var bodyAtlas:BodyAtlas		= new BodyAtlas(XML(new _landscapeXML));
			_landscape					= new FlatEntity(stage.stageWidth / 2, stage.stageHeight / 2, new Image(Texture.fromBitmap(new _landscapePNG)));
			_landscape.body				= bodyAtlas.getBody("landscape");
			_landscape.view.pivotX		= _landscape.view.width / 2;
			_landscape.view.pivotY		= _landscape.view.height / 2;
			addEntity(_landscape);
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
				side.body.type		= BodyType.STATIC;
				addEntity(side);
			}
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function dispose():void 
		{
			KeyManager.removePressed(Key.D, toggleDebug);
			InteractionManager.dispose();
			_player			= null;
			_landscape		= null;
			_bounceBox		= null;
			_objects.length	= 0;
			_objects		= null
			super.dispose();
		}
	}
}