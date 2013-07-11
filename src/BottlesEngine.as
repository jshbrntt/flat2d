package  
{
	import flat2d.core.FlatEngine;
	import starling.core.Starling;
	
	/**
	 * BottlesEngine.as
	 * Created On:	22/01/2013 19:54
	 * Author:		Joshua Barnett
	 */
	
<<<<<<< HEAD:src/ExampleEngine.as
	[SWF(width="800", height="600", backgroundColor="0xFFFFFF", frameRate="60")]
	public class ExampleEngine extends FlatEngine
=======
	[SWF(width="800", height="600", backgroundColor="0x000000", frameRate="60")]
	public class BottlesEngine extends FlatEngine
>>>>>>> no message:src/BottlesEngine.as
	{
		public function BottlesEngine() 
		{
			super(BottlesGame);
			starling.showStatsAt("right", "top", 2);
		}
	}
} 