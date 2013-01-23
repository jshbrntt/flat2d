package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flat2d.core.FlatState;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatBox;
	import flat2d.entities.FlatCircle;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import starling.events.Event;
	
	/**
	 * ExampleWorld.as
	 * Created On:	22/01/2013 20:26
	 * Author:		Joshua Barnett
	 */
	
	public class ExampleWorld extends FlatWorld 
	{
		private var _player:ExamplePlayer;
		
		public function ExampleWorld() 
		{
			super(new b2Vec2(0, 9));
		}
		
		override protected function onAdded(e:Event):void 
		{
			super.onAdded(e);
			createFrame();
			createRandomObjects();
			createPlayer();
		}
		
		private function createPlayer():void
		{
			_player	= new ExamplePlayer(stage.stageWidth / 2, stage.stageHeight / 2);
			addEntity(_player, true);
			KeyManager.pressed(Key.Q, function():void { removeEntity(_player) } );
			KeyManager.pressed(Key.W, function():void { addEntity(_player) } );
		}
		
		private function createRandomObjects():void 
		{
			for (var i:int = 0; i < 20; ++i)
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