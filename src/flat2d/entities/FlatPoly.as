package flat2d.entities 
{
<<<<<<< HEAD
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
=======
>>>>>>> no message
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
<<<<<<< HEAD
		protected var _hull:Vec2List;
		
=======
>>>>>>> no message
		public function FlatPoly
		(
			x:Number			= 0,
			y:Number			= 0,
<<<<<<< HEAD
			hull:Vec2List		= null,
=======
			verts:*				= null,
>>>>>>> no message
			view:DisplayObject	= null,
			scale:Boolean		= false,
			color:uint			= 0xFFFFFF,
			border:Boolean		= false,
			borderColor:uint	= 0xBBBBBB
		) 
		{
<<<<<<< HEAD
			_hull	= hull;
			if (view != null)
			{
=======
			if (view != null)
			{
				view.x	= -width/2;
				view.y	= -height/2;
>>>>>>> no message
				if (scale)
				{
					view.width	= width;
					view.height	= height;
				}
<<<<<<< HEAD
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
=======
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
>>>>>>> no message
					poly.graphics.lineTo(vert.x, vert.y);
				}
				poly.graphics.endFill();
			}
<<<<<<< HEAD
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
=======
			
			super(x, y, view);
			if (verts)
			{
				_body.shapes.add(new Polygon(verts));
				_body.align();
>>>>>>> no message
			}
		}
	}
}