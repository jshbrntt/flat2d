package flat2d.utils 
{
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	
	/**
	 * BodyAtlas.as
	 * Created On:	12/01/2013 15:22
	 * Author:		Joshua Barnett
	 */
	
	public class BodyAtlas 
	{
		private var _json:Object;
		
		public function BodyAtlas(json:String)
		{
			_json	= JSON.parse(json);
		}
		
		public function getHull(name:String, scale:Number = 1):Vec2List
		{
			for (var $body:String in _json)
			{
				if ($body != name)
				{
					continue;
				}
				for (var $shape:String in _json[$body].shapes)
				{
					switch($shape)
					{
						case "circle":
							return null;
							break;
						case "polygon":
							var hull:Array	= new Array();
							for each(var point:Object in _json[$body].shapes[$shape].hull)
							{
								hull.push(new Vec2(point.x * scale, point.y * scale));
							}
							return Vec2List.fromArray(hull);
							break;
					}
				}
			}
			return null;
		}
		
		public function getBody(name:String, scale:Number = 1):Body
		{
			for (var $body:String in _json)
			{
				if ($body != name)
				{
					continue;
				}
				var body:Body		= new Body();
				body.allowMovement	= _json[$body].allowMovement;
				body.allowRotation	= _json[$body].allowRotation;
				body.isBullet		= _json[$body].isBullet;
				switch(_json[$body].type)
				{
					case 0:	body.type	= BodyType.DYNAMIC;		break;
					case 1:	body.type	= BodyType.KINEMATIC;	break;
					case 2:	body.type	= BodyType.STATIC;		break;
				}
				for (var $shape:String in _json[$body].shapes)
				{
					var material:Material		= new Material();
					material.density			= _json[$body].shapes[$shape].material.density;
					material.dynamicFriction	= _json[$body].shapes[$shape].material.dynamicFriction;
					material.elasticity			= _json[$body].shapes[$shape].material.elasticity;
					material.rollingFriction	= _json[$body].shapes[$shape].material.rollingFriction;
					material.staticFriction		= _json[$body].shapes[$shape].material.staticFriction;
					switch($shape)
					{
						case "circle":
							body.shapes.add(new Circle(_json[$body].shapes[$shape].radius * scale, null, material));
							break;
						case "polygon":
							var hull:Array	= new Array();
							for each(var point:Object in _json[$body].shapes[$shape].hull)
							{
								hull.push(new Vec2(point.x * scale, point.y * scale));
							}
							if (GeomPoly.get(hull).isConvex())
							{
								body.shapes.add(new Polygon(hull, material));
							}
							else
							{
								var convexHulls:GeomPolyList	= GeomPoly.get(hull).convexDecomposition(true);
								convexHulls.foreach( function(convexHull:GeomPoly):void { body.shapes.add(new Polygon(convexHull)) } );
							}
							break;
					}
				}
				return body;
			}
			return null;
		}
		
		public function getBodies(scale:Number = 1):Vector.<Body>
		{
			var bodies:Vector.<Body>	= new Vector.<Body>();
			for (var $body:String in _json)
			{
				var body:Body		= new Body();
				body.allowMovement	= _json[$body].allowMovement;
				body.allowRotation	= _json[$body].allowRotation;
				body.isBullet		= _json[$body].isBullet;
				switch(_json[$body].type)
				{
					case 0:	body.type	= BodyType.DYNAMIC;		break;
					case 1:	body.type	= BodyType.KINEMATIC;	break;
					case 2:	body.type	= BodyType.STATIC;		break;
				}
				for (var $shape:String in _json[$body].shapes)
				{
					var material:Material		= new Material();
					material.density			= _json[$body].shapes[$shape].material.density;
					material.dynamicFriction	= _json[$body].shapes[$shape].material.dynamicFriction;
					material.elasticity			= _json[$body].shapes[$shape].material.elasticity;
					material.rollingFriction	= _json[$body].shapes[$shape].material.rollingFriction;
					material.staticFriction		= _json[$body].shapes[$shape].material.staticFriction;
					switch($shape)
					{
						case "circle":
							body.shapes.add(new Circle(_json[$body].shapes[$shape].radius * scale, null, material));
							break;
						case "polygon":
							var hull:Array	= new Array();
							for each(var point:Object in _json[$body].shapes[$shape].hull)
							{
								hull.push(new Vec2(point.x * scale, point.y * scale));
							}
							if (GeomPoly.get(hull).isConvex())
							{
								body.shapes.add(new Polygon(hull, material));
							}
							else
							{
								var convexHulls:GeomPolyList	= GeomPoly.get(hull).convexDecomposition(true);
								convexHulls.foreach( function(convexHull:GeomPoly):void { body.shapes.add(new Polygon(convexHull)) } );
							}
							break;
					}
				}
				bodies.push(body);
			}
			return bodies;
		}
		
		public function dispose():void
		{
			_json = null;
		}
	}
}