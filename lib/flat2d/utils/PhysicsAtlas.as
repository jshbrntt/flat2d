package flat2d.utils 
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import flat2d.entities.FlatEntity;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	
	/**
	 * PhysicAtlas.as
	 * Created On:	12/01/2013 15:22
	 * Author:		Joshua Barnett
	 */
	
	public class PhysicsAtlas 
	{
		private var _xml:XML;
		
		public function PhysicsAtlas(xml:XML) 
		{
			_xml	= xml;
		}
		
		public function getEntities(scale:Number = 1):Vector.<FlatEntity>
		{
			var entities:Vector.<FlatEntity>	= new Vector.<FlatEntity>();
			var bodies:XMLList					= _xml.descendants("body");
			
			for each(var body:XML in bodies)
			{
				var name:String								= String(body.@name);
				var type:uint								= String(body.@dynamic) == "true" ? b2Body.b2_dynamicBody : b2Body.b2_staticBody;
				var numFixtures:int							= int(body.@numFixtures);
				var fixtureDefs:Vector.<b2FixtureDef>		= new Vector.<b2FixtureDef>();
				var fixtureShapes:Vector.<Vector.<b2Shape>>	= new Vector.<Vector.<b2Shape>>();
				
				var entity:FlatEntity	= new FlatEntity(0, 0);
				entity.body.type		= String(body.@dynamic) == "true" ? BodyType.DYNAMIC : BodyType.STATIC;
				
				for each(var fixture:XML in body.children())
				{
					var fixtureDef:b2FixtureDef		= new b2FixtureDef();
					fixtureDef.density				= Number(fixture.@density);
					fixtureDef.friction				= Number(fixture.@friction);
					fixtureDef.restitution			= Number(fixture.@restitution);
					fixtureDef.filter.categoryBits	= uint(fixture.@filter_categoryBits);
					fixtureDef.filter.groupIndex	= int(fixture.@filter_groupIndex);
					fixtureDef.filter.maskBits		= uint(fixture.@filter_maskBits);
					fixtureDef.isSensor				= String(fixture.@isSensor) == "true" ? true : false;
					
					var shapes:Vector.<b2Shape>		= new Vector.<b2Shape>();
					
					for each(var shape:XML in fixture.children())
					{
						switch(String(shape.name()))
						{
							case "polygon":
								var vertices:Array	= new Array();
								for each(var vertex:XML in shape.children())
									vertices.push(Vec2.weak(Number(vertex.@x) * scale, Number(vertex.@y) * scale));
								entity.body.shapes.add(new Polygon(vertices));
								break;
							case "circle":
								entity.body.shapes.add(new Circle(Number(shape.@r) * scale));
								break;
						}
					}
					fixtureDefs.push(fixtureDef);
					fixtureShapes.push(shapes);
				}
				entities.push(entity);
			}
			return entities;
		}
	}
}