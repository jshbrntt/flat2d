package flat2d.utils
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * SoundManager.as
	 * Created On:	24/05/2013 21:14
	 * Author:		Joshua Barnett
	 */
	
	public class SoundManager
	{
		static private var _sounds:Dictionary;
		
		public static function initialize():void
		{
			_sounds	= new Dictionary(true);
		}
		
		public static function importSound(label:String, filePath:String):void
		{
			_sounds[label]	= new Sound(new URLRequest(filePath));
		}
		
		public static function playSound(label:String):void
		{
			if (_sounds[label] != undefined)
			{
				_sounds[label].play();
			}
		}
	}
}