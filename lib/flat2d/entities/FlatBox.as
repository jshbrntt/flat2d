package flat2d.entities 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flat2d.core.FlatGame;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * FlatBox.as
	 * Created On:	23/06/2012 16:34
	 * Author:		Joshua Barnett
	 */
	
	public class FlatBox extends FlatEntity 
	{
		public function FlatBox
		(
			x:Number,
			y:Number,
			width:Number,
			height:Number,
			image:Image		= null,
			scale:Boolean	= false
		) 
		{
			if (image != null)
			{
				image.width		= width;
				image.height	= height;
			} else {
				var sprite:Sprite	= new Sprite();
				sprite.graphics.beginFill(0xFFFFFF, 1);
				sprite.graphics.drawRect(0, 0, width, height);
				sprite.graphics.endFill();
				var bitmapData:BitmapData	= new BitmapData(width, height, true, 0);
				bitmapData.draw(sprite);
				image	= new Image(Texture.fromBitmapData(bitmapData));
			}
			
			image.pivotX	= image.width  / 2;
			image.pivotY	= image.height / 2;
			
			super(x, y, image);
			
			_bShape	= new b2PolygonShape();
			_bShape.SetAsBox((width / FlatGame.PTM) / 2, (height / FlatGame.PTM) / 2);
			_bShapes.push(_bShape);
		}
	}
}