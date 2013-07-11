package flat2d.entities
{
	import flat2d.core.FlatWorld;
	import flat2d.utils.Key;
	import flat2d.utils.KeyManager;
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
		private var _world:FlatWorld;
		private var _space:Space;
		private var _hand:PivotJoint;
		
<<<<<<< HEAD
		public function FlatHandJoint(space:Space)
		{
			super();
			_space			= space;
			_hand			= new PivotJoint(_space.world, null, new Vec2(), new Vec2());
=======
		public function FlatHandJoint(world:FlatWorld)
		{
			super();
			_world			= world;
			_space			= _world.space;
			_hand			= new PivotJoint(_space.world, null, Vec2.weak(), Vec2.weak());
			_hand.space		= _space;
>>>>>>> no message
			_hand.active	= false;
			_hand.stiff		= false;
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
		}
		
		private function handleTouch(e:TouchEvent):void 
		{
			var touch:Touch	= e.getTouch(Starling.current.stage);
<<<<<<< HEAD
			if (touch == null || _hand == null)
			{
				return;
			}
=======
			if (touch == null || _hand == null)	return;
			
>>>>>>> no message
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
<<<<<<< HEAD
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
=======
                var body:Body = bodies.at(i);
                if (!body.isDynamic())	continue;
				
				if (KeyManager.held(Key.F))
				{
					if (body.userData.root is Shatter)
					{
						var pieces:Vector.<FlatPoly>	= Shatter(body.userData.root).shatter(_world, mouse.x, mouse.y, ExampleWorld.numSlices);
						_world.removeEntity(Shatter(body.userData.root));
						for each(var piece:FlatPoly in pieces)
							_world.addEntity(piece);
					}
				} else {
					_hand.body2 = body;
					_hand.anchor2.set(body.worldPointToLocal(mouse, true));
					_hand.active = true;
				}
                break;
            }
			
            mouse.dispose();
		}
		
		private function touchEnded(globalX:Number, globalY:Number):void 
		{
			_hand.active	= false;
		}
		
		private function touchHover(globalX:Number, globalY:Number):void 
		{
			_hand.anchor1.setxy(globalX, globalY);
>>>>>>> no message
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
<<<<<<< HEAD
=======
			_world		= null;
>>>>>>> no message
			_space		= null;
			_hand.space	= null;
			_hand		= null;
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
			super.dispose();
		}
	}
}