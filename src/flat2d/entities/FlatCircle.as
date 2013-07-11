package flat2d.entities 
{
	import nape.phys.BodyType;
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
			radius:Number,
			view:DisplayObject	= null,
			scale:Boolean		= false,
			color:uint			= 0xFFFFFF,
			border:Boolean		= false,
			borderColor:uint	= 0xBBBBBB
		) 
		{
			if (view != null)
			{
				view.x	= -radius;
				view.y	= -radius;
				
				if (scale)
				{
					view.width	= (radius * 2);
					view.height	= (radius * 2);
				}
			} else {
				var circle:Shape	= new Shape();
				view				= circle;
				if(border)			circle.graphics.lineStyle(2, borderColor);
				circle.graphics.beginFill(color);
				circle.graphics.drawCircle(0, 0, radius);
				circle.graphics.endFill();
			}
			
			super(x, y, view);
			_body.shapes.add(new Circle(radius));
		}
	}
}