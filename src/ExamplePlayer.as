package  
{
	import Box2D.Common.Math.b2Vec2;
	import flat2d.core.FlatEngine;
	import flat2d.entities.FlatCircle;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	
	/**
	 * ExamplePlayer.as
	 * Created On:	22/01/2013 23:43
	 * Author:		Joshua Barnett
	 */
	
	public class ExamplePlayer extends FlatCircle 
	{
		private var _speed:Number;
		private var _jumpHeight:Number;
		
		public function ExamplePlayer(x:Number, y:Number, size:Number = 30, speed:Number = 40, jumpHeight:Number = 20)
		{
			super(x, y, size);
			_speed					= speed;
			_jumpHeight				= jumpHeight;
			_bFixtureDef.friction	= 2.0;
			KeyManager.pressed(Key.UP, jump);
			KeyManager.pressed(Key.D, toggleDebug);
		}
		
		private function toggleDebug():void 
		{
			FlatEngine.debug	= !FlatEngine.debug;
		}
		
		private function jump():void 
		{
			_bBody.ApplyImpulse(new b2Vec2(0, -_jumpHeight), _bBody.GetPosition());
		}
		
		override public function update():void 
		{
			super.update();
			if (KeyManager.held(Key.LEFT))
			{
				_bBody.ApplyTorque( -_speed);
			}
			if (KeyManager.held(Key.RIGHT))
			{
				_bBody.ApplyTorque(_speed);
			}
		}
	}
}