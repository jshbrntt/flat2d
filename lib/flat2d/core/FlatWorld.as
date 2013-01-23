package flat2d.core 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flat2d.entities.FlatEntity;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * FlatWorld.as
	 * Created On:	22/01/2013 20:28
	 * Author:		Joshua Barnett
	 */
	
	public class FlatWorld extends FlatState 
	{
		private var _gravity:b2Vec2;
		private var _world:b2World;
		private var _entities:Vector.<FlatEntity>;
		private var _debugDraw:b2DebugDraw;
		
		public function FlatWorld(gravity:b2Vec2) 
		{
			super();
			
			_gravity	= gravity;
			_world		= new b2World(_gravity, true);
			_entities	= new Vector.<FlatEntity>();
			
			if (FlatEngine.debug)
			{
				_debugDraw	= new b2DebugDraw();
				_debugDraw.SetSprite(FlatEngine.debugView);
				_debugDraw.SetDrawScale(FlatGame.PTM);
				_debugDraw.SetFillAlpha(0.3);
				_debugDraw.SetLineThickness(1.0);
				_debugDraw.SetFlags
				(
					//b2DebugDraw.e_aabbBit |
					b2DebugDraw.e_centerOfMassBit |
					//b2DebugDraw.e_controllerBit |
					b2DebugDraw.e_jointBit |
					//b2DebugDraw.e_pairBit |
					b2DebugDraw.e_shapeBit
				);
				
				_world.SetDebugDraw(_debugDraw);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function addEntity(entity:FlatEntity, createBody:Boolean = true):FlatEntity
		{
			if (_entities.indexOf(entity) == -1)
			{
				_entities.push(entity);
				if (createBody)	entity.addBody(_world);
				addChild(entity);
			}
			return entity;
		}
		
		protected function removeEntity(entity:FlatEntity, destroyBody:Boolean = true):FlatEntity
		{
			if (_entities.indexOf(entity) != -1)
			{
				_entities.splice(_entities.indexOf(entity), 1);
				if (destroyBody) entity.removeBody(_world);
				removeChild(entity);
			}
			return entity;
		}
		
		override public function update():void 
		{
			super.update();
			
			_world.Step(1 / 60, 10, 10);
			_world.ClearForces();
			if (FlatEngine.debug)	_world.DrawDebugData();
			
			for each(var entity:FlatEntity in _entities)	entity.update();
		}
	}
}