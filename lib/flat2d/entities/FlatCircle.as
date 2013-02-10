package flat2d.entities 
{
	import nape.shape.Circle;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	
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
			color:uint			= 0xFFFFFF,
			view:DisplayObject	= null,
			scale:Boolean		= false
		) 
		{
			if (view != null)
			{
				view.x	= -r;
				view.y	= -r;
				
				if (scale)
				{
					view.width	= (r * 2);
					view.height	= (r * 2);
				}
			} else {
				var circle:Shape	= new Shape();
				circle.graphics.beginFill(color);
				circle.graphics.drawCircle(0, 0, r);
				circle.graphics.endFill();
				view	= circle;
			}
			
			super(x, y, view);
			_body.shapes.add(new Circle(r));
		}
	}
}