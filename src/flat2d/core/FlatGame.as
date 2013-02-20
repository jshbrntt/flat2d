package flat2d.core
{
	import flat2d.utils.KeyManager;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
		private var _debug:Boolean;
		private var _state:FlatState;
		private var _frameRate:Number;
		private var _totalTime:Number;
		private var _frameCount:int;
		private var _bitmapDebug:Debug;
		
		public function FlatGame(debug:Boolean = false) 
		{
			_debug	= debug;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			initialize();
		}
		
		protected function initialize():void 
		{
			KeyManager.enable(true, Starling.current.nativeStage);
			_frameRate		= Starling.current.nativeStage.frameRate;
			_bitmapDebug	= new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
			updateBitmapDebug();
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
		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
			updateBitmapDebug();
		}
		
		public function get debug():Boolean
		{
			return _debug;
		}
		
		public function get bitmapDebug():Debug
		{
			return _bitmapDebug;
		}
		
		private function updateBitmapDebug():void
		{	
			if (_debug)
			{
				if (!Starling.current.nativeStage.contains(_bitmapDebug.display))
					Starling.current.nativeStage.addChild(_bitmapDebug.display);
			} else {
				if (Starling.current.nativeStage.contains(_bitmapDebug.display))
					Starling.current.nativeStage.removeChild(_bitmapDebug.display);
			}
		}
	}
}