package 
{
	import flat2d.utils.BodyAtlas;
	import nape.geom.Vec2List;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * Bottle.as
	 * Created On:	01/05/2013 09:36
	 * Author:		Joshua Barnett
	 */
	
	public class Bottle extends Fragile
	{
		//	PHYSICS:
		[Embed(source = "../assets/beers/beersPhysics.xml", mimeType="application/octet-stream")]
		static private const _beersPhysicsXML	:Class;
		
		//	TEXTURES:
		[Embed(source = "../assets/beers/images/becks.png")]
		static private const _becksPNG		:Class;
		[Embed(source = "../assets/beers/images/budweiser.png")]
		static private const _budweiserPNG	:Class;
		[Embed(source = "../assets/beers/images/crabbies.png")]
		static private const _crabbiesPNG	:Class;
		[Embed(source = "../assets/beers/images/heineken.png")]
		static private const _heinekenPNG	:Class;
		[Embed(source = "../assets/beers/images/magners.png")]
		static private const _magnersPNG	:Class;
		[Embed(source = "../assets/beers/images/sol.png")]
		static private const _solPNG		:Class;
		[Embed(source = "../assets/beers/images/stella.png")]
		static private const _stellaPNG		:Class;
		
		//	BRANDS:
		static public var BECKS			:String				= "becks";
		static public var BUDWEISER		:String				= "budweiser";
		static public var CRABBIES		:String				= "crabbies";
		static public var HEINEKEN		:String				= "heineken";
		static public var MAGNERS		:String				= "magners";
		static public var SOL			:String				= "sol";
		static public var STELLA		:String				= "stella";
		static public var BRANDS		:Vector.<String>	= new <String>[BECKS, BUDWEISER, CRABBIES, HEINEKEN, MAGNERS, SOL, STELLA];
		
		private static var _bodyAtlas		:BodyAtlas	= new BodyAtlas(XML(new _beersPhysicsXML));
		
		public function Bottle
		(
			x		:Number,
			y		:Number,
			brand	:String
		)
		{
			var hull:Vec2List	= _bodyAtlas.getBody(brand, 1).shapes.at(0).castPolygon.localVerts;
			var view:Image		= new Image(Texture.fromBitmap(new Bottle["_" + brand.toLowerCase() + "PNG"], true, false, 1));
			view.pivotX			= view.width / 2;
			view.pivotY			= view.height / 2;
			super(x, y, hull, view);
		}
	}
}