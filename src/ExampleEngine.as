package  
{
	import flash.display.Sprite;
	import flat2d.core.FlatEngine;
	
	/**
	 * ExampleEngine.as
	 * Created On:	22/01/2013 19:54
	 * Author:		Joshua Barnett
	 */
	
	[SWF(width="800", height="600", backgroundColor="0x000000", frameRate="60")]
	public class ExampleEngine extends FlatEngine
	{
		public function ExampleEngine() 
		{
			super(ExampleGame, false);
			starling.showStats	= true;
		}
	}
}