package flat2d.entities 
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flat2d.core.FlatGame;
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
		public var _bBody:b2Body;
		public var _bBodyDef:b2BodyDef;
		public var _bFixtureDef:b2FixtureDef;
		protected var _bShape:*;
		protected var _bShapes:Vector.<b2Shape>;
		protected var _bCentroid:b2Vec2;
		protected var _bMassData:b2MassData;
		protected var _image:Image;
		
		public function FlatEntity
		(
			x:Number,
			y:Number,
			image:Image	= null
		)
		{	
			this.x	= x;
			this.y	= y;
			_image	= image;
			if(_image != null)	addChild(_image);
			
			_bBodyDef					= new b2BodyDef();
			_bShapes					= new Vector.<b2Shape>();
			_bFixtureDef				= new b2FixtureDef();
			_bCentroid					= new b2Vec2();
			_bBody						= null;
			_bMassData					= new b2MassData();
			
			_bBodyDef.type				= b2Body.b2_dynamicBody;
			_bFixtureDef.density		= 1.0;
			_bFixtureDef.friction		= 0.6;
			_bFixtureDef.restitution	= 0.3;
		}
		public function addBody(bWorld:b2World):void
		{
			if (_bBody == null)
			{
				_bBody = bWorld.CreateBody(_bBodyDef);
				for each(var _bShape:b2Shape in _bShapes)
				{
					_bFixtureDef.shape = _bShape;
					_bBody.CreateFixture(_bFixtureDef);
				}
				
				if (_bShapes.length != 1)
				{
					_bBody.GetMassData(_bMassData);
					_bMassData.center = _bCentroid;
					_bBody.SetMassData(_bMassData);
				}
				
				_bBody.SetPosition(new b2Vec2(x / FlatGame.PTM, y / FlatGame.PTM));
			}
		}
		public function removeBody(bWorld:b2World):void
		{
			if (_bBody != null)
			{
				_bBodyDef.linearVelocity		= _bBody.GetLinearVelocity();
				_bBodyDef.angularVelocity		= _bBody.GetAngularVelocity();
				_bBodyDef.angle					= _bBody.GetAngle();
				bWorld.DestroyBody(_bBody);
				_bBody = null;
			}
		}
		public function update():void
		{
			if (_bBody != null && _bBody.IsAwake())
			{
				var bPosition:b2Vec2	= _bBody.GetPosition();
				x						= bPosition.x * FlatGame.PTM;
				y						= bPosition.y * FlatGame.PTM;
				rotation				=  _bBody.GetAngle();
			}
		}
	}
}