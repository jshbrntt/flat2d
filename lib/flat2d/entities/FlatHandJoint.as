package flat2d.entities
{
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.space.Space;
	import starling.core.Starling;
	import starling.display.Sprite;
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
		private var _state:Sprite;
		private var _hand:PivotJoint;
		
		public function FlatHandJoint(space:Space, state:Sprite)
		{
			super();
			_space				= space;
			_state				= state;
			_hand				= new PivotJoint(_space.world, null, Vec2.weak(), Vec2.weak());
			_hand.space	= _space;
			_hand.active	= false;
			_hand.stiff	= false;
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
		}
		
		private function handleTouch(e:TouchEvent):void 
		{
			var touch:Touch	= e.getTouch(Starling.current.stage);
			if (touch == null)	return;
			
			switch(touch.phase)
			{
				case TouchPhase.BEGAN:	touchBegan(touch.globalX, touch.globalY);	break;
				case TouchPhase.ENDED:	touchEnded(touch.globalX, touch.globalY);	break;
				case TouchPhase.HOVER:	touchHover(touch.globalX, touch.globalY);	break;
				case TouchPhase.MOVED:	touchMoved(touch.globalX, touch.globalY);	break;
			}
		}
		
		private function touchBegan(globalX:Number, globalY:Number):void 
		{
			var mouse:Vec2	= Vec2.get(globalX, globalY);
            var bodies:BodyList	= _space.bodiesUnderPoint(mouse);
			
            for (var i:int = 0; i < bodies.length; ++i)
			{
                var body:Body = bodies.at(i);
                if (!body.isDynamic())	continue;
                _hand.body2 = body;
                _hand.anchor2.set(body.worldPointToLocal(mouse, true));
                _hand.active = true;
                break;
            }
            mouse.dispose();
			
			/*var handBody:Body	= _space.bodiesUnderPoint(Vec2.weak(globalX, globalY)).at(0);
			trace("[Joshua Barnett]:", handBody);
			_hand.body2			= handBody;
			_hand.anchor2		= handBody.worldPointToLocal(Vec2.weak(globalX, globalY), true);
			_hand.active		= true;*/
		}
		
		private function touchEnded(globalX:Number, globalY:Number):void 
		{
			_hand.active	= false;
		}
		
		private function touchHover(globalX:Number, globalY:Number):void 
		{
			_hand.anchor1.setxy(globalX, globalY);
		}
		
		private function touchMoved(globalX:Number, globalY:Number):void 
		{
			_hand.anchor1.setxy(globalX, globalY);
		}
		
		public function destroy():void
		{
		}
	}
}