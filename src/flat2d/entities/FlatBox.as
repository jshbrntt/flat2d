package flat2d.entities 
{
	import nape.shape.Polygon;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	
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
			view:DisplayObject	= null,
			scale:Boolean		= false,
			color:uint			= 0xFFFFFF,
			border:Boolean		= false,
			borderColor:uint	= 0xBBBBBB
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
				view			= box;
				if(border)		box.graphics.lineStyle(2, borderColor);
				box.graphics.beginFill(color);
				box.graphics.drawRect(width / -2, height / -2, width, height);
				box.graphics.endFill();
			}
			
			super(x, y, view);
			_body.shapes.add(new Polygon(Polygon.rect(width / -2, height / -2, width, height)));
		}
	}
}