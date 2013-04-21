package flat2d.utils
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * KeyManager.as
	 * Created On:	20/04/2013 21:10
	 * Author:		Joshua Barnett
	 */
	
	public class KeyManager
	{
		private static var _initialized:Boolean;
		private static var _stage:Stage;
		private static var _keys:Dictionary;
		private static var _pressedFunctions:Dictionary;
		private static var _releasedFunctions:Dictionary;
		private static var _pressedSignal:NativeSignal;
		private static var _releasedSignal:NativeSignal;
		
		public static function init(stage:Stage):void
		{
			if (_initialized)	return;
			_initialized		= true;
			_stage				= stage;
			_keys				= new Dictionary(true);
			_pressedFunctions	= new Dictionary(true);
			_releasedFunctions	= new Dictionary(true);
			_pressedSignal		= new NativeSignal(_stage, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			_releasedSignal		= new NativeSignal(_stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			
			_pressedSignal.add(onKeyDown);
			_releasedSignal.add(onKeyUp);
		}
		
		public static function dispose():void
		{
			_initialized		= false;
			_stage				= null;
			_keys				= null;
			_pressedFunctions	= null;
			_releasedFunctions	= null;
			_pressedSignal.removeAll();
			_releasedSignal.removeAll();
			_pressedSignal		= null;
			_releasedSignal		= null;
		}
		
		private static function onKeyDown(e:KeyboardEvent):void 
		{
			e.preventDefault();
			if (_keys[e.keyCode] == undefined)
			{
				_keys[e.keyCode]	= false;
			}
			if (!_keys[e.keyCode])
			{
				_keys[e.keyCode]	= true;
				for each (var pressedFunction:Function in _pressedFunctions[e.keyCode])
					pressedFunction.call();
			}
		}
		
		public static function held(keyCode:uint):Boolean
		{
			if (_keys[keyCode] == undefined)
				return false;
			return _keys[keyCode];
		}
		
		private static function onKeyUp(e:KeyboardEvent):void 
		{
			if (_keys[e.keyCode] == undefined)
				_keys[e.keyCode]	= true;
			if (_keys[e.keyCode])
			{
				_keys[e.keyCode]	= false;
				for each (var releasedFunction:Function in _releasedFunctions[e.keyCode])
					releasedFunction.call();
			}
		}
		
		public static function pressed(keyCode:uint, listener:Function):void
		{
			if (_pressedFunctions[keyCode] == undefined)
			{
				_pressedFunctions[keyCode]	= new <Function>[listener];
			} else {
				_pressedFunctions[keyCode].push(listener);
			}
		}
		
		public static function removePressed(keyCode:uint, listener:Function):void
		{
			if (_pressedFunctions[keyCode] != undefined)
			{
				_pressedFunctions[keyCode].splice(_pressedFunctions[keyCode].indexOf(listener), 1);
				if (_pressedFunctions[keyCode].length == 0)
					delete _pressedFunctions[keyCode];
			}
		}
		
		public static function released(keyCode:uint, listener:Function):void
		{
			if (_releasedFunctions[keyCode] == undefined)
			{
				_releasedFunctions[keyCode]	= new <Function>[listener];
			} else {
				_releasedFunctions[keyCode].push(listener);
			}
		}
		
		public static function removeReleased(keyCode:uint, listener:Function):void
		{
			if (_releasedFunctions[keyCode] != undefined)
			{
				_releasedFunctions[keyCode].splice(_releasedFunctions[keyCode].indexOf(listener), 1);
				if (_releasedFunctions[keyCode].length == 0)
					delete _releasedFunctions[keyCode];
			}
		}
	}
}