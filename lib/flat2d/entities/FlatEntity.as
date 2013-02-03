package flat2d.entities 
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flat2d.core.FlatGame;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * FlatEntity.as
	 * Created On:	23/06/2012 15:28
	 * Author:		Joshua Barnett
	 */
	
	public class FlatEntity extends Sprite
	{
		//	BOX2D FIELDS:
		protected var _view:DisplayObject;
		protected var _body:b2Body;
		protected var _bodyDef:b2BodyDef;
		protected var _fixtureDefs:Vector.<b2FixtureDef>;
		protected var _fixtureShapes:Vector.<Vector.<b2Shape>>;
		protected var _center:b2Vec2;
		protected var _massData:b2MassData;
		protected var _world:b2World;
		protected var _group:String;
		
		public function FlatEntity
		(
			x:Number,
			y:Number,
			view:DisplayObject	= null
		)
		{	
			this.x							= x;
			this.y							= y;
			this.view						= view;
			
			_body							= null;
			_bodyDef						= new b2BodyDef();
			_fixtureDefs					= new Vector.<b2FixtureDef>();
			_fixtureShapes					= new Vector.<Vector.<b2Shape>>();
			_center							= new b2Vec2();
			_massData						= new b2MassData();
			
			_bodyDef.userData				= this;
			_bodyDef.type					= b2Body.b2_dynamicBody;
			var bFixtureDef:b2FixtureDef	= new b2FixtureDef();
			bFixtureDef.density				= 1.0;
			bFixtureDef.friction			= 0.6;
			bFixtureDef.restitution			= 0.3;
			
			_fixtureDefs.push(bFixtureDef);
			if (_view != null)	addChild(_view);
		}
		
		public function addBody(world:b2World):void
		{
			_world	= world;
			
			if (_body == null)
			{
				_body = world.CreateBody(_bodyDef);
				
				for (var i:int = 0; i < _fixtureDefs.length; ++i)
				{	
					for each(var bShape:b2Shape in _fixtureShapes[i])
					{
						_fixtureDefs[i].shape = bShape;
						_body.CreateFixture(_fixtureDefs[i]);
					}
				}
				
				if (_fixtureShapes.length != 1)
				{
					_body.GetMassData(_massData);
					_massData.center	= _center;
					_body.SetMassData(_massData);
				}
				
				_body.SetPosition(new b2Vec2(x / FlatGame.PTM, y / FlatGame.PTM));
			}
		}
		
		public function removeBody(bWorld:b2World, save:Boolean	= true):void
		{
			if (_body != null)
			{
				if (save)
				{
					_bodyDef.active				= _body.IsActive();
					_bodyDef.allowSleep			= _body.IsSleepingAllowed();
					_bodyDef.angle				= _body.GetAngle();
					_bodyDef.angularDamping		= _body.GetAngularDamping();
					_bodyDef.angularVelocity	= _body.GetAngularVelocity();
					_bodyDef.awake				= _body.IsAwake();
					_bodyDef.bullet				= _body.IsBullet();
					_bodyDef.fixedRotation		= _body.IsFixedRotation();
					_bodyDef.inertiaScale		= _body.GetInertia();
					_bodyDef.linearDamping		= _body.GetLinearDamping();
					_bodyDef.linearVelocity		= _body.GetLinearVelocity();
					_bodyDef.position			= _body.GetPosition();
					_bodyDef.type				= _body.GetType();
					_bodyDef.userData			= _body.GetUserData();
				}
				bWorld.DestroyBody(_body);
				_body = null;
			}
		}
		
		public function update():void
		{
			if (_body != null && _body.IsAwake())
			{
				var position:b2Vec2	= _body.GetPosition();
				x					= position.x * FlatGame.PTM;
				y					= position.y * FlatGame.PTM;
				rotation			= _body.GetAngle();
			}
		}
		
		public function get body():b2Body 
		{
			return _body;
		}
		
		public function set body(value:b2Body):void 
		{
			_body = value;
		}
		
		public function get bodyDef():b2BodyDef 
		{
			return _bodyDef;
		}
		
		public function set bodyDef(value:b2BodyDef):void 
		{
			_bodyDef = value;
		}
		
		public function get fixtureDefs():Vector.<b2FixtureDef> 
		{
			return _fixtureDefs;
		}
		
		public function set fixtureDefs(value:Vector.<b2FixtureDef>):void 
		{
			_fixtureDefs = value;
		}
		
		public function get fixtureShapes():Vector.<Vector.<b2Shape>> 
		{
			return _fixtureShapes;
		}
		
		public function set fixtureShapes(value:Vector.<Vector.<b2Shape>>):void 
		{
			_fixtureShapes = value;
		}
		
		public function get view():DisplayObject 
		{
			return _view;
		}
		
		public function set view(value:DisplayObject):void 
		{
			if (contains(_view))	removeChild(_view);
			_view	= value;
			if(_view != null)		addChild(_view);
		}
		
		public function get group():String 
		{
			return _group;
		}
		
		public function set group(value:String):void 
		{
			_group = value;
		}
	}
}