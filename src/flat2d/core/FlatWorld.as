package flat2d.core 
{
	import flash.utils.getTimer;
	import flat2d.entities.FlatEntity;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	/**
	 * FlatWorld.as
	 * Created On:	22/01/2013 20:28
	 * Author:		Joshua Barnett
	 */
	
	public class FlatWorld extends FlatState 
	{
		private var _gravity:Vec2;
		private var _pause:Boolean;
		private var _world:Sprite;
		private var _space:Space;
		private var _entities:Vector.<FlatEntity>;
		private var _debug:Debug;
		
        private var prevTimeMS:int;
        private var simulationTime:Number;
		
		public function FlatWorld(game:FlatGame, gravity:Vec2) 
		{
			super(game);
			_gravity	= gravity;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_pause					= false;
			_world					= new Sprite();
			_space					= new Space(_gravity);
			_entities				= new Vector.<FlatEntity>();
			_debug					= game.bitmapDebug;
			_debug.drawConstraints	= true;
			
            prevTimeMS				= getTimer();
            simulationTime			= 0.0;
			
			addChild(_world);
		}
		
		protected function toggleDebug():void
		{
			game.debug	= !game.debug;
		}
		
		protected function togglePause():void
		{
			_pause	= !_pause;
		}
		
		protected function addEntity(entity:FlatEntity, createBody:Boolean = true):FlatEntity
		{
			if (_entities.indexOf(entity) == -1)
			{
				_entities.push(entity);
				if (createBody)	entity.addBody(_space);
				_world.addChild(entity);
			}
			return entity;
		}
		
		protected function removeEntity(entity:FlatEntity, destroyBody:Boolean = true):FlatEntity
		{
			if (_entities.indexOf(entity) != -1)
			{
				_entities.splice(_entities.indexOf(entity), 1);
				if (destroyBody) entity.removeBody(_space);
				_world.removeChild(entity);
			}
			return entity;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!_pause)
			{
				var curTimeMS:uint				= getTimer();
				if (curTimeMS == prevTimeMS)	return;
				var deltaTime:Number			= (curTimeMS - prevTimeMS) / 1000;
				if (deltaTime > 0.05)			deltaTime = 0.05;
				prevTimeMS						= curTimeMS;
				simulationTime					+= deltaTime;
				while (space.elapsedTime < simulationTime)	_space.step((game.frameRate > 0) ? (1 / game.frameRate) : (1 / 60));
				
				if (game.debug)
				{
					game.bitmapDebug.clear();
					game.bitmapDebug.draw(_space);
					game.bitmapDebug.flush();
				}
				
				for each(var entity:FlatEntity in _entities)	entity.update();
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_gravity.dispose();
			while (_world.numChildren)	_world.removeChildAt(0, true);
			removeChild(_world);
			_space.clear();
			while (_entities.length)	removeEntity(_entities[0]).destroy();
			_debug.clear();
			
			_gravity	= null;
			_world		= null;
			_space		= null;
			_entities	= null;
			_debug		= null;
			
			while (numChildren)	removeChildAt(0, true);
		}
		
		public function get world():Sprite					{	return _world;		}
		public function get space():Space 					{	return _space;		}
		public function get entities():Vector.<FlatEntity>	{	return _entities;	}
	}
}