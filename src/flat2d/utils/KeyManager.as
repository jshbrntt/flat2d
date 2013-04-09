package flat2d.utils 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * KeyManager.as
	 * Created On:	22/01/2013 19:55
	 * Author:		Joshua Barnett
	 */
	
	public class KeyManager
	{
		private static var _destroying			:Boolean;
		private static var _enabled				:Boolean;
		private static var _keys				:Vector.<Boolean>;
		private static var _stage				:Stage;
		private static var _pressedSignal		:NativeSignal;
		private static var _releasedSignal		:NativeSignal;
		private static var _pressedFunctions	:Dictionary;
		private static var _releasedFunctions	:Dictionary;
		
		public static function enable(enabled:Boolean = true, stage:Stage = null):void
		{
			if (_enabled && enabled || !_enabled && !enabled)	return;
			
			_destroying	= false;
			_enabled	= enabled;
			
			if (_keys == null)						_keys	= new Vector.<Boolean>(256);
			if (_stage == null && stage != null)	_stage	= stage;
			if (_pressedSignal == null)				_pressedSignal		= new NativeSignal(_stage, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			if (_releasedSignal == null)			_releasedSignal		= new NativeSignal(_stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			if (_pressedFunctions == null)			_pressedFunctions	= new Dictionary(true);
			if (_releasedFunctions == null)			_releasedFunctions	= new Dictionary(true);
			
			if (_enabled)
			{
				_pressedSignal.add(keyPressed);
				_releasedSignal.add(keyReleased);
			} else {
				_pressedSignal.remove(keyPressed);
				_releasedSignal.remove(keyReleased);
			}
		}
		
		private static function keyPressed(e:KeyboardEvent = null):void 
		{
			e.preventDefault();
			if (e.keyCode < 0 || e.keyCode > _keys.length - 1)	return;
			_keys[e.keyCode]	= true;
		}
		
		private static function keyReleased(e:KeyboardEvent = null):void 
		{
			if (e.keyCode < 0 || e.keyCode > _keys.length - 1)	return;
			_keys[e.keyCode]	= false;
		}
		
		public static function pressedOnce(keyCode:uint, listener:Function):void
		{
			var onPress:Function			= function(e:KeyboardEvent):void { if (e.keyCode == keyCode && _enabled) { _pressedSignal.remove(onPress); listener.call(); } };
			_pressedFunctions[listener]		= onPress;
			_pressedSignal.add(onPress);
		}
		
		public static function pressed(keyCode:uint, listener:Function):void
		{
			var onPress:Function			= function(e:KeyboardEvent):void { if (e.keyCode == keyCode && _enabled){ _pressedSignal.remove(onPress); released(keyCode, listener); listener.call(); } };
			_pressedFunctions[listener]		= onPress;
			_pressedSignal.add(onPress);
		}
		
		private static function released(keyCode:uint, listener:Function):void
		{
			var onRelease:Function			= function(e:KeyboardEvent):void { if (e.keyCode == keyCode && enabled) { _releasedSignal.remove(onRelease); pressed(keyCode, listener); } };
			_releasedFunctions[listener]	= onRelease;
			_releasedSignal.add(onRelease);
		}
		
		public static function remove(listener:Function):void
		{
			_pressedSignal.remove(_pressedFunctions[listener]);
			_releasedSignal.remove(_releasedFunctions[listener]);
		}
		
		public static function held(keyCode:uint):Boolean
		{
			if (keyCode > _keys.length - 1)	return false;
			return _keys[keyCode];
		}
		
		public static function dispose():void 
		{
			if (_destroying)	return;
			_destroying			= true;
			
			_pressedSignal.removeAll();
			_releasedSignal.removeAll();
			
			_stage				= null;
			_enabled			= false;
			
			_keys.length		= 0;
			
			_pressedSignal		= null;
			_releasedSignal		= null;
			
			_pressedFunctions	= null;
			_releasedFunctions	= null;
		}
		
		public static function get enabled()	:Boolean	{	return _enabled;	}
		public static function get destroying()	:Boolean	{	return _destroying;	}
	}
}