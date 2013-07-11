package flat2d.entities 
{
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
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
		protected var _hull:Vec2List;
		
		public function FlatPoly
		(
			x:Number			= 0,
			y:Number			= 0,
			hull:Vec2List		= null,
			view:DisplayObject	= null,
			scale:Boolean		= false,
			color:uint			= 0xFFFFFF,
			border:Boolean		= false,
			borderColor:uint	= 0xBBBBBB
		) 
		{
			_hull	= hull;
			if (view != null)
			{
				if (scale)
				{
					view.width	= width;
					view.height	= height;
				}
			}
			else if (_hull && _hull.length > 0)
			{
				var poly:Shape	= new Shape();
				view			= poly;
				if (border)
				{
					poly.graphics.lineStyle(1, borderColor);
				}
				poly.graphics.beginFill(color);
				poly.graphics.moveTo(_hull.at(0).x, _hull.at(0).y);
				for (var i:int = 1; i < _hull.length + 1; ++i)
				{
					var vert:Vec2	= _hull.at(i % _hull.length);
					poly.graphics.lineTo(vert.x, vert.y);
				}
				poly.graphics.endFill();
			}
			super(x, y, view);
			if (_hull)
			{
				if (GeomPoly.get(_hull).isConvex())
				{
					_body.shapes.add(new Polygon(_hull));
				}
				else
				{
					var convexHulls:GeomPolyList	= GeomPoly.get(_hull).convexDecomposition(true);
					convexHulls.foreach( function(convexHull:GeomPoly):void { _body.shapes.add(new Polygon(convexHull)) } );
				}
			}
		}
	}
}