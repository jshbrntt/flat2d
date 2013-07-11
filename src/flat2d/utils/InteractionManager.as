package flat2d.utils
{
	import flash.utils.Dictionary;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.phys.Body;
	import nape.space.Space;
	
	/**
	 * InteractionManager.as
	 * Created On:	13/02/2013 11:14
	 * Author:		Joshua Barnett
	 */
	
	public class InteractionManager
	{
		static public const ANY_BODY		:String	= "anyBody";
		static public const ANY_COMPOUND	:String	= "anyCompound";
		static public const ANY_CONSTRAINT	:String	= "anyConstraint";
		static public const ANY_SHAPE		:String	= "anyShape";
		
		static private var _space			:Space;
		static private var _groups			:Dictionary;
		static private var _interactions	:Dictionary;
		
		public static function initialize(space:Space):void
		{
			_space					= space;
			_groups					= new Dictionary(true);
			_interactions			= new Dictionary(true);
			
			_groups[ANY_BODY]		= CbType.ANY_BODY;
			_groups[ANY_COMPOUND]	= CbType.ANY_COMPOUND;
			_groups[ANY_CONSTRAINT]	= CbType.ANY_CONSTRAINT;
			_groups[ANY_SHAPE]		= CbType.ANY_SHAPE;
		}
		
		public static function beginContact(groupA:String, groupB:String, listener:Function):void
		{
			if (_groups[groupA] != undefined && _groups[groupB] != undefined && _interactions[listener] == undefined)
			{
				_interactions[listener]	= new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, _groups[groupA], _groups[groupB], listener);
				_space.listeners.add(_interactions[listener]);
			}
		}
		
		public static function removeBeginContact(groupA:String, groupB:String, listener:Function):void
		{
			if (_groups[groupA] != undefined && _groups[groupB] != undefined && _interactions[listener] != undefined)
			{
				for (var key:Object in _interactions)
				{
					if (_interactions[key].options1 == _groups[groupA] && _interactions[key].options2 == _groups[groupB])
					{
						_space.listeners.remove(_interactions[key]);
						delete _interactions[key];
					}
				}
			}
		}
		
		public static function endContact(groupA:String, groupB:String, listener:Function):void
		{
			if (_groups[groupA] != undefined && _groups[groupB] != undefined && _interactions[listener] == undefined)
			{
				_interactions[listener]	= new InteractionListener(CbEvent.END, InteractionType.COLLISION, _groups[groupA], _groups[groupB], listener);
				_space.listeners.add(_interactions[listener]);
			}
		}
		
		public static function removeEndContact(groupA:String, groupB:String, listener:Function):void
		{
			if (_groups[groupA] != undefined && _groups[groupB] != undefined && _interactions[listener] != undefined)
			{
				for (var key:Object in _interactions)
				{
					if (_interactions[key].options1 == _groups[groupA] && _interactions[key].options2 == _groups[groupB])
					{
						_space.listeners.remove(_interactions[key]);
						delete _interactions[key];
					}
				}
			}
		}
		
		public static function addToGroup(body:Body, group:String):void
		{
			if (_groups[group] != undefined)
			{
				body.cbTypes.add(_groups[group]);
			}
		}
		
		public static function removeFromGroup(body:Body, group:String):void
		{
			if (_groups[group] != undefined)
			{
				body.cbTypes.remove(_groups[group]);
			}
		}
		
		public static function createGroup(name:String):void
		{
			if (_groups[name] == undefined)
			{
				_groups[name]	= new CbType();
			}
		}
		
		public static function deleteGroup(name:String):void
		{
			if (_groups[name] != undefined)
			{
				delete _groups[name];
			}
		}
		
		public static function dispose():void
		{
			_space			= null;
			_groups			= null;
			_interactions	= null;
		}
	}
}