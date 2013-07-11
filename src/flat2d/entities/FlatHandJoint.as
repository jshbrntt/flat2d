package flat2d.entities
{
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.space.Space;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * FlatHandJoint.as
	 * Created On:	10/02/2013 09:06
	 * Author:		Joshua Barnett
	 */
	
	public class FlatHandJoint extends FlatEntity
	{
		private var _space:Space;
		private var _hand:PivotJoint;
		
		public function FlatHandJoint(space:Space)
		{
			super();
			_space			= space;
			_hand			= new PivotJoint(_space.world, null, new Vec2(), new Vec2());
			_hand.active	= false;
			_hand.stiff		= false;
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
		}
		
		private function handleTouch(e:TouchEvent):void 
		{
			var touch:Touch	= e.getTouch(Starling.current.stage);
			if (touch == null || _hand == null)
			{
				return;
			}
			switch(touch.phase)
			{
				case TouchPhase.BEGAN:	touchBegan(touch.globalX, touch.globalY);	break;
				case TouchPhase.ENDED:	touchEnded(touch.globalX, touch.globalY);	break;
				case TouchPhase.MOVED:	touchMoved(touch.globalX, touch.globalY);	break;
			}
		}
		
		private function touchBegan(globalX:Number, globalY:Number):void 
		{
			var mouse:Vec2		= new Vec2(globalX, globalY);
			var bodies:BodyList	= _space.bodiesUnderPoint(mouse);
			for (var i:int = 0; i < bodies.length; ++i)
			{
				var body:Body	= bodies.at(i);
				if (!body.isDynamic())
				{
					continue;
				}
				_hand.space		= body.space;
				_hand.anchor1.setxy(globalX, globalY);
				_hand.anchor2.set(body.worldPointToLocal(mouse, true));
				_hand.body2		= body;
				_hand.active	= true;
				break;
			}
		}
		
		private function touchMoved(globalX:Number, globalY:Number):void 
		{
			_hand.anchor1.setxy(globalX, globalY);
		}
		
		private function touchEnded(globalX:Number, globalY:Number):void 
		{
			_hand.active	= false;
		}
		
		override public function dispose():void 
		{
			_space		= null;
			_hand.space	= null;
			_hand		= null;
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
			super.dispose();
		}
	}
}