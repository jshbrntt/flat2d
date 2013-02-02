package flat2d.entities 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import flat2d.core.FlatGame;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
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
			color:uint			= 0xFFFFFF,
			view:DisplayObject	= null,
			scale:Boolean		= false
		) 
		{
			if (view != null)
			{
				view.x	= -width/2;
				view.y	= -height/2;
				
				if (scale)
				{
					view.width	= width;
					view.height	= height;
				}
			} else {
				var box:Shape	= new Shape();
				box.graphics.beginFill(color);
				box.graphics.drawRect(-width, -height, width * 2, height * 2);
				box.graphics.endFill();
				view	= box;
			}
			
			super(x, y, view);
			
			var boxShape:b2PolygonShape	= new b2PolygonShape();
			boxShape.SetAsBox(width / FlatGame.PTM, height / FlatGame.PTM);
			_fixtureShapes.push(Vector.<b2Shape>([boxShape]));
		}
	}
}