package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatCircle;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
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
		
		private var _player:ExamplePlayer;
		
		public function ExampleWorld() 
		{
			super(new b2Vec2(0, 10));
		}
		
		override protected function onAdded(e:Event):void 
		{
			super.onAdded(e);
			createInfo();
			createFrame();
			createRandomObjects();
			createPlayer();
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
			"D = Toggle Debug Draw\n"	+
			"Left/Right	= Movement\n"	+
			"Up = Jump";
			
			var infoField:TextField		= new TextField(250, 130, infoText, "Verdana", 18, 0xFFFFFF);
			infoField.x					= 20;
			infoField.y					= 20;
			infoField.hAlign			= HAlign.LEFT;
			addChild(infoField);
		}
		
		
		private function createPlayer():void
		{
			_player	= new ExamplePlayer(stage.stageWidth / 2, stage.stageHeight / 2);
			addEntity(_player, true);
			KeyManager.pressed(Key.A, function():void { addEntity(_player) } );
			KeyManager.pressed(Key.R, function():void { removeEntity(_player) } );
			KeyManager.pressed(Key.P, function():void { togglePause() } );
		}
		
		private function createRandomObjects():void 
		{
			for (var i:int = 0; i < 10; ++i)
			{
				if ((Math.random() > .5) ? true : false)
				{
					addEntity(new FlatBox(100 + Math.random() * stage.stageWidth - 200, 100 + Math.random() * stage.stageHeight, 20 + Math.random() * 40, 20 + Math.random() * 40), true);
				} else {
					addEntity(new FlatCircle(100 + Math.random() * stage.stageWidth - 200, 100 + Math.random() * stage.stageHeight, 10 + Math.random() * 20), true);
				}
			}
		}
		
		private function createFrame():void
		{
			var size:Number			= 10;
			
			var left:FlatBox		= new FlatBox(size / 2, stage.stageHeight / 2, size, stage.stageHeight);
			var right:FlatBox		= new FlatBox(stage.stageWidth - size / 2, stage.stageHeight / 2, size, stage.stageHeight);
			var up:FlatBox			= new FlatBox(stage.stageWidth / 2, size / 2, stage.stageWidth, size);
			var down:FlatBox		= new FlatBox(stage.stageWidth / 2, stage.stageHeight - size / 2, stage.stageWidth, size);
			
			left._bBodyDef.type		= b2Body.b2_staticBody;
			right._bBodyDef.type	= b2Body.b2_staticBody;
			up._bBodyDef.type		= b2Body.b2_staticBody;
			down._bBodyDef.type		= b2Body.b2_staticBody;
			
			addEntity(left, true);
			addEntity(right, true);
			addEntity(up, true);
			addEntity(down, true);
		}
	}
}