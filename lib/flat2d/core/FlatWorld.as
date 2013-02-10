package flat2d.core 
{
	import flat2d.entities.FlatEntity;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.Debug;
	
	/**
	 * FlatWorld.as
	 * Created On:	22/01/2013 20:28
	 * Author:		Joshua Barnett
	 */
	
	public class FlatWorld extends FlatState 
	{
		private var _gravity:Vec2;
		private var _pause:Boolean;
		private var _space:Space;
		private var _entities:Vector.<FlatEntity>;
		private var _debug:Debug;
		
		public function FlatWorld(game:FlatGame, gravity:Vec2) 
		{
			super(game);
			_gravity	= gravity;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_pause					= false;
			_space					= new Space(_gravity);
			_entities				= new Vector.<FlatEntity>();
			_debug					= FlatEngine.bitmapDebug;
			_debug.drawConstraints	= true;
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
				addChild(entity);
			}
			return entity;
		}
		
		protected function removeEntity(entity:FlatEntity, destroyBody:Boolean = true):FlatEntity
		{
			if (_entities.indexOf(entity) != -1)
			{
				_entities.splice(_entities.indexOf(entity), 1);
				if (destroyBody) entity.removeBody(_space);
				removeChild(entity);
			}
			return entity;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!_pause)
			{
				_space.step((game.frameRate > 0) ? (1 / game.frameRate) : (1 / 60));
				
				if (FlatEngine.debug)
				{
					FlatEngine.bitmapDebug.clear();
					FlatEngine.bitmapDebug.draw(_space);
					FlatEngine.bitmapDebug.flush();
				}
				
				for each(var entity:FlatEntity in _entities)	entity.update();
			}
		}
		
		public function get space():Space 
		{
			return _space;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			_gravity	= null;
			_pause		= false;
			_space		= null;
			if (numChildren)		removeChildAt(0, true);
			if (_entities.length)	_entities.pop();
			_debug	= null;
		}
	}
}