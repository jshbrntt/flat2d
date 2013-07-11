package  
{
	import flat2d.core.FlatGame;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	
	/**
	 * BottlesGame.as
	 * Created On:	22/01/2013 20:25
	 * Author:		Joshua Barnett
	 */
	
	public class BottlesGame extends FlatGame
	{
		public function BottlesGame() 
		{
			super(false);
			state	= new BottlesWorld(this);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			KeyManager.pressed(Key.R, resetWorld);
			KeyManager.pressed(Key.BACK, resetWorld);
		}
		
		private function resetWorld():void 
		{
			destroyWorld();
			createWorld();
		}
		
		private function createWorld():void
		{
			if(state == null)
				state	= new BottlesWorld(this);
		}
		
		private function destroyWorld():void
		{
			if(state != null)
				state	= null;
		}
	}
}