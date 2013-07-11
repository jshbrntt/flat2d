package  
{
	import flat2d.core.FlatEngine;
	
	/**
	 * BottlesMobile.as
	 * Created On:	22/01/2013 19:54
	 * Author:		Joshua Barnett
	 */
	
	[SWF(width="1280", height="720", backgroundColor="0x000000", frameRate="60")]
	public class BottlesMobile extends FlatEngine
	{
		public function BottlesMobile() 
		{
			super(BottlesGame);
			starling.showStatsAt("right", "top", 2);
		}
	}
} 