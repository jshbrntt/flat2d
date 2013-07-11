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
		private static var _starling:Starling;
		
		public function FlatEngine(game:Class, viewPort:Rectangle = null):void 
		{
			_stage			= stage;
			_game			= game;
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
		
		public function dispose():void
		{
			_stage		= null;
			_game		= null;
<<<<<<< HEAD
			if(_starling != null)
=======
			if(_starling)
>>>>>>> no message
				_starling.dispose();
			_starling	= null;
		}
	}
}