package 
{
	import flash.geom.Matrix;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.InteractionManager;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.Mat23;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.shape.Polygon;
	import nape.shape.ValidationResult;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.filters.BlurFilter;
	
	/**
	 * Fragile.as
	 * Created On:	27/05/2013 11:22
	 * Author:		Joshua Barnett
	 */
	
	public class Fragile extends FlatPoly
	{
		static private const FRAGILE:String = "fragile";
		
		private var _rootImage		:Image;
		
		public function Fragile
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
		
		public function fracture(origin:Vec2, numPieces:int):Vector.<Fragile>
		{
			removeBody();
			
			if (_rootImage == null && _view is Image)
			{
				_rootImage	= Image(_view);
			}
			
			var pieceList:GeomPolyList	= new GeomPolyList();
			var cutList:GeomPolyList	= new GeomPolyList();
			var cutMatrix:Mat23			= Mat23.rotation(_body.rotation).concat(Mat23.translation(_body.position.x, _body.position.y));
			
			pieceList.push(new GeomPoly(_hull));
			
			for (var i:int = 1; i <= numPieces; ++i)
			{
				var cutStart:Vec2		= new Vec2(origin.x, origin.y);
				var cutAngle:Number		= Math.random() * (Math.PI / 4) - (Math.PI / 8);
				var cutEnd:Vec2			= Mat23.rotation(cutAngle).transform(_body.position.copy().sub(new Vec2(origin.x, origin.y))).add(new Vec2(origin.x, origin.y));
				
				cutStart	= cutMatrix.inverse().transform(cutStart);
				cutEnd		= cutMatrix.inverse().transform(cutEnd);
				
				pieceList.foreach(performCut);
				function performCut(pieceGeom:GeomPoly):void
				{
					cutList.merge(pieceGeom.cut(cutStart, cutEnd));
				}
				pieceList	= cutList.copy();
				cutList.clear();
			}
			
			//pieceList.foreach(function(geomPoly:GeomPoly):void { drawGeomPoly(geomPoly, cutMatrix); } );
			
			var pieces:Vector.<Fragile>	= new Vector.<Fragile>();
			
			pieceList.foreach(constructPiece);
			function constructPiece(pieceGeom:GeomPoly):void
			{
				var piecePoly:Polygon	= new Polygon(pieceGeom);
				var pieceVerts:Vec2List	= piecePoly.localVerts;
				var vert:Vec2;
				
				if (piecePoly.validity() == ValidationResult.DEGENERATE)
				{
					return;
				}
				
				var pieceMatrix:Matrix  = new Matrix();
				pieceMatrix.translate(0.5, 0.5);
				
				var pieceView:Shape			= new Shape();
				pieceView.graphics.beginTextureFill(_rootImage.texture, pieceMatrix);
				pieceView.graphics.moveTo(pieceVerts.at(0).x, pieceVerts.at(0).y);
				for (i = 1; i < pieceVerts.length + 1; ++i)
				{
					vert	= pieceVerts.at(i % pieceVerts.length);
					pieceView.graphics.lineTo(vert.x, vert.y);
				}
				pieceView.graphics.endFill();
				
				var piece:Fragile		= new Fragile(_body.position.x, _body.position.y, pieceVerts, pieceView);
				piece.body.rotation		= _body.rotation;
				piece.body.velocity		= _body.velocity;
				piece.body.angularVel	= _body.angularVel;
				piece.rootImage			= _rootImage;
				piece.align();
				//InteractionManager.addToGroup(piece.body, FRAGILE);
				pieces.push(piece);
			}
			return pieces;
		}
		
		private function drawGeomPoly(geomPoly:GeomPoly, transform:Mat23):void
		{
			var hull:Vec2List	= new Polygon(geomPoly.copy().transform(transform)).localVerts;
			BottlesWorld.test.graphics.lineStyle(2, 0xFF0000);
			BottlesWorld.test.graphics.beginFill(Math.random() * 0xFFFFFF, 0.2);
			BottlesWorld.test.graphics.moveTo(hull.at(0).x, hull.at(0).y);
			for (var i:int = 1; i < hull.length + 1; ++i)
			{
				var vert:Vec2	= hull.at(i % hull.length);
				BottlesWorld.test.graphics.lineTo(vert.x, vert.y);
			}
			BottlesWorld.test.graphics.endFill();
		}
		
		public function set rootImage(value:Image):void 
		{
			_rootImage = value;
		}
	}
}