package  
{
	import flat2d.core.FlatGame;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	
	/**
	 * ExampleGame.as
	 * Created On:	22/01/2013 20:25
	 * Author:		Joshua Barnett
	 */
	
	public class ExampleGame extends FlatGame 
	{
		public function ExampleGame() 
		{
			super(false);
			state	= new ExampleWorld(this);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			KeyManager.pressed(Key.INSERT, createWorld);
			KeyManager.pressed(Key.DELETE, destroyWorld);
		}
		
		private function createWorld():void
		{
			state	= new ExampleWorld(this);
		}
		
		private function destroyWorld():void
		{
			state	= null;
		}
	}
}