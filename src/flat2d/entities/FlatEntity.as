package flat2d.entities 
{
	import flat2d.core.FlatWorld;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.space.Space;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	import starling.display.Sprite;
	
	/**
	 * FlatEntity.as
	 * Created On:	23/06/2012 15:28
	 * Author:		Joshua Barnett
	 */
	
	public class FlatEntity extends Sprite
	{
<<<<<<< HEAD
		protected var _view		:DisplayObject;
		protected var _body		:Body;
		protected var _group	:String;
		protected var _shape	:Shape;
		protected var _world	:FlatWorld;
=======
		protected var _view:DisplayObject;
		protected var _body:Body;
		protected var _group:String;
		protected var _shape:Shape;
>>>>>>> no message
		
		public function FlatEntity
		(
			x		:Number			= 0,
			y		:Number			= 0,
			view	:DisplayObject	= null
		)
		{
			this.x				= x;
			this.y				= y;
			_view				= view;
			_body				= new Body(BodyType.DYNAMIC, new Vec2(x, y));
			_body.userData.root	= this;
			_group				= "blank";
			
			if (_view != null)
			{
				addChild(_view);
			}
			
			update();
		}
		
		public function addBody(space:Space):void
		{
			_body.space	= space;
		}
		
		public function removeBody():void
		{
<<<<<<< HEAD
			if (_body)
			{
				while (!_body.constraints.empty())
				{
					_body.constraints.at(0).active	= false;
					_body.constraints.at(0).space	= null;
				}
				_body.space = null;
			}
=======
			while (!_body.constraints.empty())
			{
				_body.constraints.at(0).active	= false;
				_body.constraints.at(0).space	= null;
			}
			_body.space = null;
>>>>>>> no message
		}
		
		public function update():void
		{
			if (_body && _body.space && !_body.isSleeping)
			{
				x			= _body.position.x;
				y			= _body.position.y;
				rotation	= _body.rotation;
			}
		}
		
		public function get body():Body 
		{
			return _body;
		}
		
		public function set body(value:Body):void 
		{
			_body = value;
			_body.position.x	= x;
			_body.position.y	= y;
			_body.rotation		= rotation;
		}
		
		public function get view():DisplayObject 
		{
			return _view;
		}
		
		public function set view(value:DisplayObject):void 
		{
			if (contains(_view))
			{
				removeChild(_view);
<<<<<<< HEAD
			}
			if (_view)
			{
				_view.dispose();
			}
=======
			}
			_view.dispose();
>>>>>>> no message
			_view	= null;
			if (!value)
			{
				return;
			}
			_view	= value;
			addChild(_view);
		}
		
		public function align():void
		{
			var diff:Vec2	= _body.localCOM.copy();
			_body.align();
			diff.subeq(_body.localCOM.copy());
			_view.pivotX	+= diff.x;
			_view.pivotY	+= diff.y;
		}
		
		public function get group():String 
		{
			return _group;
		}
		
		public function set group(value:String):void 
		{
			_group = value;
		}
		
		public function get world():FlatWorld 
		{
			return _world;
		}
		
		public function set world(value:FlatWorld):void 
		{
			_world = value;
		}
		
		override public function dispose():void
		{
			if (_view)
			{
				if (_view is Shape)
				{
					Shape(_view).graphics.clear();
				}
				if (contains(_view))
				{
					removeChild(_view);
				}
				_view.dispose();
				_view	= null;
			}
			if (_body)
			{
				removeBody();
				_body	= null;
			}
			_group	= null;
			super.dispose();
		}
	}
}