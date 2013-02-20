package flat2d.utils
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.utils.Dictionary;
	import flat2d.entities.FlatEntity;
	import org.osflash.signals.Signal;
	
	/**
	 * ContactManager.as
	 * Created On:	13/02/2013 11:14
	 * Author:		Joshua Barnett
	 */
	
	public class ContactManager extends b2ContactListener
	{
		private static var _listenerFunctions:Dictionary;
		private static var _beginContactSignal:Signal;
		private static var _endContactSignal:Signal;
		
		public function ContactManager():void
		{
			_listenerFunctions	= new Dictionary();
			_beginContactSignal	= new Signal();
			_endContactSignal	= new Signal();
		}
		
		public static function beginContact(groupA:String, groupB:String, listener:Function):void
		{
			var onBeginContact:Function		= function(contact:b2Contact):void
			{
				if ((contact.GetFixtureA().GetBody().GetUserData().group == groupA && contact.GetFixtureB().GetBody().GetUserData().group == groupB) ||
					(contact.GetFixtureA().GetBody().GetUserData().group == groupB && contact.GetFixtureB().GetBody().GetUserData().group == groupA))
				{
					listener.call();
				}	
			};
			
			_listenerFunctions[listener]	= onBeginContact;
			_beginContactSignal.add(onBeginContact);
		}
		
		public static function endContact(groupA:String, groupB:String, listener:Function):void
		{
			var onEndContact:Function		= function(contact:b2Contact):void
			{
				if ((contact.GetFixtureA().GetBody().GetUserData().group == groupA && contact.GetFixtureB().GetBody().GetUserData().group == groupB) ||
					(contact.GetFixtureA().GetBody().GetUserData().group == groupB && contact.GetFixtureB().GetBody().GetUserData().group == groupA))
				{
					listener.call();
				}	
			};
			
			_listenerFunctions[listener]	= onEndContact;
			_endContactSignal.add(onEndContact);
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			_beginContactSignal.dispatch(contact);
		}
		
		override public function EndContact(contact:b2Contact):void
		{
			_endContactSignal.dispatch(contact);
		}
		
		public static function removeListener(listener:Function):void
		{
			_beginContactSignal.remove(_listenerFunctions[listener]);
			_endContactSignal.remove(_listenerFunctions[listener]);
		}
	}
}