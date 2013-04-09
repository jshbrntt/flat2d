package  
{
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
		private var _handJoint:FlatHandJoint;
		
		public function ExampleWorld(game:FlatGame)
		{
			super(game, Vec2.weak(0, 0));
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_handJoint	= new FlatHandJoint(this);
			
			createObjects(500, 8, 14);
		}
		
		private function reset():void
		{
			game.state	= null;
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
		}
		
		private function randLim(min:Number, max:Number):Number
		{
			return min + Math.random() * (max - min);
		}
		
		override public function dispose():void 
		{
			if (_handJoint)
				_handJoint.dispose();
			_handJoint	= null;
			super.dispose();
		}
	}
}