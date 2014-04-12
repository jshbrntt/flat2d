package flat2d.effects 
{
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import starling.display.DisplayObject;
	
	/**
	 * Explode.as
	 * Created On:	11/07/2013 23:24
	 * Author:		Joshua Barnett
	 */
	
	public class Explode extends Fragile 
	{
		public function Explode
		(
			x			:Number			= 0,
			y			:Number			= 0,
			hull		:Vec2List		= null,
			view		:DisplayObject	= null,
			scale		:Boolean		= false,
			color		:uint			= 0xFFFFFF,
			border		:Boolean		= false,
			borderColor	:uint			= 0xBBBBBB
		) 
		{
			super(x, y, hull, view, scale, color, border, borderColor);
		}
		override public function fracture(origin:Vec2, numPieces:uint):Vector.<Fragile> 
		{
			var pieces:Vector.<Fragile>	= super.fracture(origin, numPieces);
			for each(var piece:Fragile in pieces)
			{
				piece.body.velocity.subeq(Vec2.get(x - piece.body.position.x, y - piece.body.position.y).mul(4));
			}
			return pieces;
		}
	}
}