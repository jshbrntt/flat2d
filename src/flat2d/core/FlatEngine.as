package flat2d.core
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	import starling.core.Starling;
	
	/**
	 * FlatEngine.as
	 * Created On:	22/01/2013 19:55
	 * Author:		Joshua Barnett
	 */
	
	public class FlatEngine extends Sprite
	{
		private static var _stage:Stage;
		private static var _game:Class;
		private static var _debug:Boolean;
		private static var _bitmapDebug:Debug;
		private static var _starling:Starling;
		
		public function FlatEngine(game:Class, debug:Boolean = false, viewPort:Rectangle = null):void 
		{
			_stage			= stage;
			_game			= game;
			
			_debug			= debug;
			_bitmapDebug	= new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
			updateBitmapDebug();
			
			_starling		= new Starling(_game, _stage, viewPort);
			_starling.start();
		}
		
		public static function get starling():Starling 
		{
			return _starling;
		}
		
		public static function set starling(value:Starling):void 
		{
			_starling = value;
		}
		
		public static function get stage():Stage 
		{
			return _stage;
		}
		
		public static function updateBitmapDebug():void
		{	
			if (_debug)
			{
				if (!stage.contains(_bitmapDebug.display))	stage.addChild(_bitmapDebug.display);
			} else {
				if (stage.contains(_bitmapDebug.display))	stage.removeChild(_bitmapDebug.display);
			}
		}
		
		public static function set debug(value:Boolean):void 
		{
			_debug = value;
			updateBitmapDebug();
		}
		
		public static function get debug():Boolean
		{
			return _debug;
		}
		
		public static function get bitmapDebug():Debug
		{
			return _bitmapDebug;
		}
	}
}