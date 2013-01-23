package flat2d.core
{
	import flash.events.KeyboardEvent;
	import flat2d.utils.KeyManager;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	/**
	 * FlatGame.as
	 * Created On:	22/01/2013 19:55
	 * Author:		Joshua Barnett
	 */
	
	public class FlatGame extends Sprite
	{
		public static const PTM:int	= 32;
		
		private var _state:FlatState;
		
		public function FlatGame() 
		{
			KeyManager.enable(true, Starling.current.nativeStage);
		}
		
		public function get state():FlatState 
		{
			return _state;
		}
		
		public function set state(value:FlatState):void 
		{
			if (_state != null)
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, _state.update);
				removeChild(_state);
			}
			_state	= value;
			addChild(_state);
			addEventListener(EnterFrameEvent.ENTER_FRAME, _state.update);
		}
	}
}