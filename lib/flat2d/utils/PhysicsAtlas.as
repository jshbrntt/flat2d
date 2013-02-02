package flat2d.utils 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import flat2d.entities.FlatEntity;
	
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
		
		public function getEntities(scale:Number):Vector.<FlatEntity>
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
								var polygon:b2PolygonShape		= new b2PolygonShape();
								var vertices:Vector.<b2Vec2>	= new Vector.<b2Vec2>();
								for each(var vertex:XML in shape.children())
									vertices.push(new b2Vec2(Number(vertex.@x) * scale, Number(vertex.@y) * scale));
								polygon.SetAsVector(vertices);
								//polygon.ScaleBy(scale);
								shapes.push(polygon);
								break;
							case "circle":
								var circle:b2CircleShape		= new b2CircleShape(Number(shape.@r) * scale);
								circle.SetLocalPosition(new b2Vec2(Number(shape.@x) * scale, Number(shape.@y) * scale));
								//circle.ScaleBy(scale);
								shapes.push(circle);
								break;
						}
					}
					fixtureDefs.push(fixtureDef);
					fixtureShapes.push(shapes);
				}
				var entity:FlatEntity	= new FlatEntity(0, 0);
				entity.bodyDef.type		= type;
				entity.fixtureDefs		= fixtureDefs;
				entity.fixtureShapes	= fixtureShapes;
				entities.push(entity);
			}
			return entities;
		}
	}
}