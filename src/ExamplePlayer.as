package  
{
	import flat2d.entities.FlatCircle;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
	import nape.geom.Vec2;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ExamplePlayer.as
	 * Created On:	22/01/2013 23:43
	 * Author:		Joshua Barnett
	 */
	
	public class ExamplePlayer extends FlatCircle 
	{
		[Embed(source="../assets/player.png")]
		private var playerPNG:Class;
		
		private var _speed:Number;
		private var _jumpHeight:Number;
		private var _canJump:Boolean;
		
		public function ExamplePlayer(x:Number, y:Number, size:Number = 30, speed:Number = 600, jumpHeight:Number = 1000)
		{
			super(x, y, size, new Image(Texture.fromBitmap(new playerPNG)), true);
			_speed						= speed;
			_jumpHeight					= jumpHeight;
			_canJump					= true;
			KeyManager.pressed(Key.UP, jump);
		}
		
		private function jump():void 
		{
			if (_canJump)
			{
				_body.applyImpulse(Vec2.weak(0, -_jumpHeight));
				//_canJump = false;
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (KeyManager.held(Key.LEFT))
			{
				_body.applyAngularImpulse(-_speed);
			}
			if (KeyManager.held(Key.RIGHT))
			{
				_body.applyAngularImpulse(_speed);
			}
		}
		
		public function set canJump(value:Boolean):void 
		{
			_canJump = value;
		}
	}
}