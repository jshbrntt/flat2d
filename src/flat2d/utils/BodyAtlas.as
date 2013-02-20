package flat2d.utils 
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	
	/**
	 * BodyAtlas.as
	 * Created On:	12/01/2013 15:22
	 * Author:		Joshua Barnett
	 */
	
	public class BodyAtlas 
	{
		private var _xml:XML;
		
		public function BodyAtlas(xml:XML) 
		{
			_xml	= xml;
		}
		
		public function getBody(label:String, scale:Number = 1):Body
		{
			var bodiesXML:XMLList		= _xml.descendants("body");
			
			for each(var bodyXML:XML in bodiesXML)
			{
				if (bodyXML.@name != label)	continue;
				
				var body:Body	= new Body(String(bodyXML.@dynamic) == "true" ? BodyType.DYNAMIC : BodyType.STATIC);
				
				for each(var fixtureXML:XML in bodyXML.children())
				{
					for each(var shapeXML:XML in fixtureXML.children())
					{
						switch(String(shapeXML.name()))
						{
							case "polygon":
								var vertices:Array	= new Array();
								for each(var vertexXML:XML in shapeXML.children())
									vertices.push(Vec2.weak(Number(vertexXML.@x) * scale, Number(vertexXML.@y) * scale));
								body.shapes.add(new Polygon(vertices));
								break;
							case "circle":
								body.shapes.add(new Circle(Number(shapeXML.@r) * scale));
								break;
						}
					}
				}
				
				return body;
			}
			
			return null;
		}
		
		public function getBodies(scale:Number = 1):Vector.<Body>
		{
			var bodies:Vector.<Body>	= new Vector.<Body>();
			var bodiesXML:XMLList		= _xml.descendants("body");
			
			for each(var bodyXML:XML in bodiesXML)
			{
				var body:Body	= new Body(String(bodyXML.@dynamic) == "true" ? BodyType.DYNAMIC : BodyType.STATIC);
				
				for each(var fixtureXML:XML in bodyXML.children())
				{
					for each(var shapeXML:XML in fixtureXML.children())
					{
						switch(String(shapeXML.name()))
						{
							case "polygon":
								var vertices:Array	= new Array();
								for each(var vertexXML:XML in shapeXML.children())
									vertices.push(Vec2.weak(Number(vertexXML.@x) * scale, Number(vertexXML.@y) * scale));
								body.shapes.add(new Polygon(vertices));
								break;
							case "circle":
								body.shapes.add(new Circle(Number(shapeXML.@r) * scale));
								break;
						}
					}
				}
				
				bodies.push(body);
			}
			
			return bodies;
		}
	}
}