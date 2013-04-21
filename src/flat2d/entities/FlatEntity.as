package flat2d.entities 
{
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
		protected var _view:DisplayObject;
		protected var _body:Body;
		protected var _group:String;
		
		public function FlatEntity
		(
			x:Number			= 0,
			y:Number			= 0,
			view:DisplayObject	= null
		)
		{	
			this.x				= x;
			this.y				= y;
			_view				= view;
			_body				= new Body(BodyType.DYNAMIC, Vec2.weak(x, y));
			_body.userData.root	= this;
			_group				= "blank";
			
			if (_view != null)
				addChild(_view);
		}
		
		public function addBody(space:Space):void
		{
			if (_body != null)
			{
				_body.position.setxy(x, y);
				_body.space	= space;
			}
		}
		
		public function removeBody(space:Space, save:Boolean = true):void
		{
			if (_body != null)
				_body.space	= null;
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
				_view.dispose();
				_view	= null;
			}
			if (!value)
				return;
			_view			= value;
			_view.pivotX	= _view.width / 2;
			_view.pivotY	= _view.height / 2;
			addChild(_view);
		}
		
		public function get group():String 
		{
			return _group;
		}
		
		public function set group(value:String):void 
		{
			_group = value;
		}
		
		override public function dispose():void
		{
			if (_view)
			{
				if (_view is Shape)
					Shape(_view).graphics.clear();
				if (contains(_view))
					removeChild(_view);
				_view.dispose();
				_view		= null;
			}
			if (_body)
			{
				_body.space	= null;
				_body		= null;
			}
			_group	= null;
			super.dispose();
		}
	}
}