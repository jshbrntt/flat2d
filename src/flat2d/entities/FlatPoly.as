package flat2d.entities 
{
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.shape.Polygon;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	
	/**
	 * FlatPoly.as
	 * Created On:	29/03/2013 18:50
	 * Author:		Joshua Barnett
	 */
	
	public class FlatPoly extends FlatEntity 
	{
		public function FlatPoly
		(
			x:Number			= 0,
			y:Number			= 0,
			verts:*				= null,
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
			} else if (verts && verts.length > 0) {
				var poly:Shape	= new Shape();
				view			= poly;
				if(border)		poly.graphics.lineStyle(1, borderColor);
				poly.graphics.beginFill(color);
				if(verts is Vec2List)	poly.graphics.moveTo(verts.at(0).x, verts.at(0).y);
				else 					poly.graphics.moveTo(verts[0].x, verts[0].y);
				for (var i:int = 1; i < verts.length + 1; ++i)
				{
					var vert:Vec2	= (verts is Vec2List) ? verts.at(i % verts.length) : verts[i % verts.length];
					poly.graphics.lineTo(vert.x, vert.y);
				}
				poly.graphics.endFill();
			}
			
			super(x, y, view);
			if (verts)
			{
				_body.shapes.add(new Polygon(verts));
				_body.align();
			}
		}
	}
}