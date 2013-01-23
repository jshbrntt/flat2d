package flat2d.entities 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flat2d.core.FlatGame;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * FlatCircle.as
	 * Created On:	23/06/2012 16:18
	 * Author:		Joshua Barnett
	 */
	
	public class FlatCircle extends FlatEntity 
	{
		public function FlatCircle
		(
			x:Number,
			y:Number,
			r:Number,
			image:Image		= null,
			scale:Boolean	= false
		) 
		{
			if (image != null)
			{
				if (scale)
				{
					image.width		= (r * 2);
					image.height	= (r * 2);
				}
			} else {
				var sprite:Sprite	= new Sprite();
				sprite.graphics.beginFill(0xFFFFFF);
				sprite.graphics.drawCircle(r, r, r);
				var bitmapData:BitmapData = new BitmapData(r * 2, r * 2, true, 0);
				bitmapData.draw(sprite);
				image	= new Image(Texture.fromBitmapData(bitmapData));
			}
			
			image.pivotX	= image.width  / 2;
			image.pivotY	= image.height / 2;
			
			super(x, y, image);
			
			_bShapes.push(new b2CircleShape(r / FlatGame.PTM));
		}
	}
}