package  
{
	import flat2d.core.FlatEngine;
	import flat2d.core.FlatGame;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatCircle;
	import flat2d.entities.FlatEntity;
	import flat2d.entities.FlatHandJoint;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.BodyAtlas;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import starling.display.Image;
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
		[Embed(source = "../assets/landscape/landscape.xml", mimeType="application/octet-stream")]
		private const _landscapeXML:Class
		[Embed(source = "../assets/landscape/landscape.png")]
		private const _landscapePNG:Class;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, new Vec2(0, 600));
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			KeyManager.pressed(Key.D, toggleDebug);
			
			createHandJoint();
			createObjects(40, 20, 40);
			createPlayer();
			createLandscape();
			createFrame();
		}
		
		private function createHandJoint():void 
		{
			var handJoint:FlatHandJoint	= new FlatHandJoint(this);
		}
		
		private function createObjects(num:int = 10, min:Number = 20, max:Number = 40):void 
		{
			for (var i:int = 0; i < num; ++i)
			{
				if ((Math.random() > .5) ? true : false)
				{
					addEntity(new FlatBox(randLim(100, 700), randLim(100, 500), randLim(min, max), randLim(min, max), null, false, Math.random() * 0xFFFFFF), true);
				} else {
					addEntity(new FlatCircle(randLim(100, 700), randLim(100, 500), randLim(min, max), null, false, Math.random() * 0xFFFFFF), true);
				}
			}
			function randLim(min:Number, max:Number):Number
			{
				return min + Math.random() * (max - min);
			}
		}
		
		private function createPlayer():void
		{
			var player:ExamplePlayer	= new ExamplePlayer(stage.stageWidth / 2, stage.stageHeight / 2);
			addEntity(player);
		}
		
		private function createLandscape():void 
		{
			var bodyAtlas:BodyAtlas		= new BodyAtlas(XML(new _landscapeXML));
			var landscape:FlatEntity	= new FlatEntity(stage.stageWidth / 2, stage.stageHeight / 2, new Image(Texture.fromBitmap(new _landscapePNG)));
			landscape.body				= bodyAtlas.getBody("landscape");
			landscape.view.pivotX		= landscape.view.width / 2;
			landscape.view.pivotY		= landscape.view.height / 2;
			addEntity(landscape);
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
			super.dispose();
		}
	}
}