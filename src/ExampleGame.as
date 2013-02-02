package  
{
	import flat2d.core.FlatGame;
	
	/**
	 * ExampleGame.as
	 * Created On:	22/01/2013 20:25
	 * Author:		Joshua Barnett
	 */
	
	public class ExampleGame extends FlatGame 
	{
		public function ExampleGame() 
		{
			super();
			state	= new ExampleWorld(this);
		}
	}
}