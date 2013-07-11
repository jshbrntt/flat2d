package flat2d.utils 
{	
	import flash.ui.Keyboard;
	/**
	 * Key.as
	 * Created On:	22/01/2013 23:43
	 * Author:		Joshua Barnett
	 */
	
	public class Key 
	{

		public static const LEFT					:uint	= 37;
		public static const UP						:uint	= 38;
		public static const RIGHT					:uint	= 39;
		public static const DOWN					:uint	= 40;
		
		public static const MENU					:uint	= 0x01000012;
		public static const BACK					:uint	= 0x01000016;
		
		public static const ENTER					:uint	= 13;
		public static const COMMAND					:uint	= 15;
		public static const CONTROL					:uint	= 17;
		public static const SPACE					:uint	= 32;
		public static const SHIFT					:uint	= 16;
		public static const BACKSPACE				:uint	= 8;
		public static const CAPS_LOCK				:uint	= 20;
		public static const DELETE					:uint	= 46;
		public static const END						:uint	= 35;
		public static const ESCAPE					:uint	= 27;
		public static const HOME					:uint	= 36;
		public static const INSERT					:uint	= 45;
		public static const TAB						:uint	= 9;
		public static const PAGE_DOWN				:uint	= 34;
		public static const PAGE_UP					:uint	= 33;
		public static const LEFT_SQUARE_BRACKET		:uint	= 219;
		public static const RIGHT_SQUARE_BRACKET	:uint	= 221;
		
		public static const A						:uint	= 65;
		public static const B						:uint	= 66;
		public static const C						:uint	= 67;
		public static const D						:uint	= 68;
		public static const E						:uint	= 69;
		public static const F						:uint	= 70;
		public static const G						:uint	= 71;
		public static const H						:uint	= 72;
		public static const I						:uint	= 73;
		public static const J						:uint	= 74;
		public static const K						:uint	= 75;
		public static const L						:uint	= 76;
		public static const M						:uint	= 77;
		public static const N						:uint	= 78;
		public static const O						:uint	= 79;
		public static const P						:uint	= 80;
		public static const Q						:uint	= 81;
		public static const R						:uint	= 82;
		public static const S						:uint	= 83;
		public static const T						:uint	= 84;
		public static const U						:uint	= 85;
		public static const V						:uint	= 86;
		public static const W						:uint	= 87;
		public static const X						:uint	= 88;
		public static const Y						:uint	= 89;
		public static const Z						:uint	= 90;
		
		public static const F1						:uint	= 112;
		public static const F2						:uint	= 113;
		public static const F3						:uint	= 114;
		public static const F4						:uint	= 115;
		public static const F5						:uint	= 116;
		public static const F6						:uint	= 117;
		public static const F7						:uint	= 118;
		public static const F8						:uint	= 119;
		public static const F9						:uint	= 120;
		public static const F10						:uint	= 121;
		public static const F11						:uint	= 122;
		public static const F12						:uint	= 123;
		public static const F13						:uint	= 124;
		public static const F14						:uint	= 125;
		public static const F15						:uint	= 126;
		
		public static const DIGIT_0					:uint	= 48;
		public static const DIGIT_1					:uint	= 49;
		public static const DIGIT_2					:uint	= 50;
		public static const DIGIT_3					:uint	= 51;
		public static const DIGIT_4					:uint	= 52;
		public static const DIGIT_5					:uint	= 53;
		public static const DIGIT_6					:uint	= 54;
		public static const DIGIT_7					:uint	= 55;
		public static const DIGIT_8					:uint	= 56;
		public static const DIGIT_9					:uint	= 57;
		
		public static const NUMPAD_0				:uint	= 96;
		public static const NUMPAD_1				:uint	= 97;
		public static const NUMPAD_2				:uint	= 98;
		public static const NUMPAD_3				:uint	= 99;
		public static const NUMPAD_4				:uint	= 100;
		public static const NUMPAD_5				:uint	= 101;
		public static const NUMPAD_6				:uint	= 102;
		public static const NUMPAD_7				:uint	= 103;
		public static const NUMPAD_8				:uint	= 104;
		public static const NUMPAD_9				:uint	= 105;
		public static const NUMPAD_ADD				:uint	= 107;
		public static const NUMPAD_DECIMAL			:uint	= 110;
		public static const NUMPAD_DIVIDE			:uint	= 111;
		public static const NUMPAD_ENTER			:uint	= 108;
		public static const NUMPAD_MULTIPLY			:uint	= 106;
		public static const NUMPAD_SUBTRACT			:uint	= 109;
		
		public static function name(code:int):String
		{
			if (code >= A  && code <= Z)	return String.fromCharCode(code);
			if (code >= F1 && code <= F15)	return "F" + String(code - 111);
			if (code >= 96 && code <= 105)	return "NUMPAD " + String(code - 96);
			switch (code)
			{
				case LEFT:				return "LEFT";
				case UP:				return "UP";
				case RIGHT:				return "RIGHT";
				case DOWN:				return "DOWN";
				case MENU:				return "MENU";
				case ENTER:				return "ENTER";
				case CONTROL:			return "CONTROL";
				case SPACE:				return "SPACE";
				case SHIFT:				return "SHIFT";
				case BACKSPACE:			return "BACKSPACE";
				case CAPS_LOCK:			return "CAPS LOCK";
				case DELETE:			return "DELETE";
				case END:				return "END";
				case ESCAPE: 			return "ESCAPE";
				case HOME: 				return "HOME";
				case INSERT: 			return "INSERT";
				case TAB: 				return "TAB";
				case PAGE_DOWN:			return "PAGE DOWN";
				case PAGE_UP: 			return "PAGE UP";
				case NUMPAD_ADD:		return "NUMPAD ADD";
				case NUMPAD_DECIMAL:	return "NUMPAD DECIMAL";
				case NUMPAD_DIVIDE:		return "NUMPAD DIVIDE";
				case NUMPAD_ENTER:		return "NUMPAD ENTER";
				case NUMPAD_MULTIPLY:	return "NUMPAD MULTIPLY";
				case NUMPAD_SUBTRACT:	return "NUMPAD SUBTRACT";
				default:				return String.fromCharCode(code);
			}
		}
	}
}
