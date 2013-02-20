package flat2d.core
{
	import flat2d.utils.KeyManager;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	/**
	 * FlatGame.as
	 * Created On:	22/01/2013 19:55
	 * Author:		Joshua Barnett
	 */
	
	public class FlatGame extends Sprite
	{
		public static const PTM:int	= 32;
		
		private var _frameRate:Number;
		private var _totalTime:Number;
		private var _frameCount:int;
		private var _state:FlatState;
		
		public function FlatGame() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			initialize();
		}
		
		protected function initialize():void 
		{
			_frameRate	= Starling.current.nativeStage.frameRate;
			KeyManager.enable(true, Starling.current.nativeStage);
		}
		
		public function update(e:EnterFrameEvent):void
		{
			_totalTime += e.passedTime;
			if (++_frameCount % 60 == 0)
			{
				_frameRate	= _frameCount / _totalTime;
				_frameCount = _totalTime = 0;
			}
			if(_state != null && !_state.destroying)	_state.update();
		}
		
		public function get state():FlatState 
		{
			return _state;
		}
		
		public function set state(value:FlatState):void 
		{
			if (_state != null)
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, update);
				removeChild(_state);
				_state.destroy();
			}
			_state	= value;
			addChild(_state);
			addEventListener(EnterFrameEvent.ENTER_FRAME, update);
		}
		
		public function get frameRate():Number 
		{
			return _frameRate;
		}
	}
}