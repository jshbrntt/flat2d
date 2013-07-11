package  
{
<<<<<<< HEAD
	import flash.geom.Matrix;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.InteractionManager;
=======
	import flash.display.ShaderParameter;
	import flat2d.core.FlatWorld;
	import flat2d.entities.FlatEntity;
	import flat2d.entities.FlatPoly;
	import nape.dynamics.InteractionFilter;
>>>>>>> no message
	import nape.geom.Ray;
	import nape.geom.RayResultList;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.phys.Body;
<<<<<<< HEAD
=======
	import nape.phys.BodyList;
>>>>>>> no message
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import starling.display.DisplayObject;
<<<<<<< HEAD
	import starling.display.Image;
	import starling.display.Shape;
	import starling.textures.Texture;
=======
>>>>>>> no message
	
	/**
	 * Shatter.as
	 * Created On:	29/03/2013 16:41
	 * Author:		Joshua Barnett
	 */
	
	public class Shatter extends FlatPoly 
	{
<<<<<<< HEAD
		private var _image		:Image;
		private var _pieces		:Vector.<FlatPoly>;
		private var _slices		:Vector.<Body>;
		private var _sliceSpace	:Space;
		
		public function Shatter
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
		
		public function shatter(originX:Number, originY:Number, slices:int):Vector.<FlatPoly>
		{
			//	PARSING INITIAL TEXTURE:
			if (_image == null && _view is Image)
			{
				_image	= Image(_view);
			}
			
			//	INITIALIZING VECTORS:
			_pieces		= new Vector.<FlatPoly>();
			
			//var body:Body	= new Body(_body.type, _body.position);
			//body.rotation	= _body.rotation;
			//body.shapes.add(new Polygon(_hull));
			
			//	MOVING BODY TO ISLOATED SPACE:
			_sliceSpace	= new Space();
			_body.space	= _sliceSpace;
			
			//	GETTING POLYGON:
			_slices		= new Vector.<Body>();
			_slices.push(_body);
			
			//	PERFORM SLICING:
			for (var j:int = 1; j <= slices; ++j)
			{
				var sliceOffset:Number			= Math.max(_body.bounds.max.x, _body.bounds.max.y);
				var sliceAngle:Number			= Math.random() * Math.PI * 2;
				var slicePoint:Vec2				= new Vec2((originX - sliceOffset * Math.cos(sliceAngle)), (originY - sliceOffset * Math.sin(sliceAngle)));
				var sliceRay:Ray				= new Ray(slicePoint, Vec2.fromPolar(1, sliceAngle));
				var sliceResults:RayResultList	= _sliceSpace.rayMultiCast(sliceRay, true);
				slicePoly(sliceResults, sliceRay);
			}
			
			//	PARSING SLICES TO ENTITES:
			for each(var slice:Body in _slices)
			{
				//	REMOVING SLICE FROM SHATTER SPACE:
				slice.space	= null;
				
				//	GETTING VERTS:
				var piecePolygon:Polygon		= slice.shapes.at(0).castPolygon;
				var pieceVerts:Vec2List			= piecePolygon.localVerts;
				
				//	DRAWING SKIN:
				var pieceMatrix:Matrix  = new Matrix();
				pieceMatrix.translate(0.5, 0.5);
				var rotateMatrix:Matrix  = new Matrix();
				rotateMatrix.rotate(_body.rotation);
				var translateMatrix:Matrix = new Matrix();
				translateMatrix.translate((_body.position.x - slice.position.x) / _image.width, (_body.position.y - slice.position.y) / _image.height);
				
				pieceMatrix.concat(rotateMatrix);
				pieceMatrix.concat(translateMatrix);
				
				pieceMatrix.invert();
				var pieceView:Shape			= new Shape();
				pieceView.graphics.beginTextureFill(_image.texture, pieceMatrix);
				pieceView.graphics.moveTo(pieceVerts.at(0).x, pieceVerts.at(0).y);
				for (var k:int = 1; k < pieceVerts.length + 1; ++k)
				{
					var vert:Vec2	= pieceVerts.at(k % pieceVerts.length);
					pieceView.graphics.lineTo(vert.x, vert.y);
				}
				pieceView.graphics.endFill();
				
				//	INSTANTIAING THE PIECE:
				var piece:Shatter	= new Shatter(slice.position.x, slice.position.y, pieceVerts, pieceView);
				piece.image			= _image;
				
				//	SETUP PROPERTIES:
				piece.body.shapes.at(0).castPolygon.material	= Material.glass();
				
				//	EXPLOSION:
				var explosionForce:Number	= 2;
				
				piece.body.velocity.setxy(_body.velocity.x, _body.velocity.y);
				//piece.body.velocity.setxy(explosionForce * (piece.x - originX) + _body.velocity.y, explosionForce * (piece.y - originY) + _body.velocity.x);
				_pieces.push(piece);
			}
			
			return _pieces;
		}
		
		private function slicePoly(sliceResults:RayResultList, sliceRay:Ray):void
=======
		private var _gibs:Vector.<Body>;
		private var _pieces:Vector.<FlatPoly>;
		private var _spaceOrigin:Space;
		private var _originFilter:InteractionFilter;
		private var _world:FlatWorld;
		
		public function Shatter
		(
			x:Number			= 0,
			y:Number			= 0,
			verts:*				= null,
			view:DisplayObject	= null,
			scale:Boolean		= false,
			color:uint			= 0xFFFFFF,
			border:Boolean		= false,
			borderColor:uint	= 0xBBBBBB
		) 
		{
			super(x, y, verts, view, scale, color, border, borderColor);
			_gibs	= new Vector.<Body>();
			_pieces	= new Vector.<FlatPoly>();
		}
		
		public function shatter(world:FlatWorld, originX:Number, originY:Number, slices:int):Vector.<FlatPoly>
		{
			_world			= world;
			_spaceOrigin	= _world.space;
			
			if (_body && _body.space && _body.shapes.length == 1)
			{
				_originFilter				= _body.shapes.at(0).filter;
				_body.shapes.at(0).filter	= new InteractionFilter(32, 32);
				_gibs.push(_body);
				
				for (var i:int = 1; i <= slices; ++i)
				{
					var offset:Number				= Math.max(_body.shapes.at(0).castPolygon.bounds.max.x, _body.shapes.at(0).castPolygon.bounds.max.y);
					var sliceAngle:Number			= Math.random() * Math.PI * 2;
					var slicePoint:Vec2				= new Vec2(((originX + Math.random() * 100) - offset * Math.cos(sliceAngle)), ((originY + Math.random() * 100) - offset * Math.sin(sliceAngle)));
					var sliceRay:Ray				= new Ray(slicePoint, Vec2.fromPolar(1, sliceAngle));
					var sliceResults:RayResultList	= _spaceOrigin.rayMultiCast(sliceRay, true, new InteractionFilter(32, 32));
					slice(sliceResults, sliceRay);
				}
				
				var scale:Number	= 10;
				
				for each(var gib:Body in _gibs)
				{
					gib.space			= null;
					var piece:Shatter	= new Shatter(gib.position.x, gib.position.y, gib.shapes.at(0).castPolygon.localVerts, null, false, Math.random() * 0xFFFFFF, false, 0xFFFFFF);
					piece.body.shapes.at(0).castPolygon.material	= Material.glass();
					piece.body.velocity.setxy(scale * (piece.x - originX), scale * (piece.y - originY));
					_pieces.push(piece);
				}
				
				return _pieces;
			}
			
			return null;
		}
		
		private function slice(sliceResults:RayResultList, sliceRay:Ray):void
>>>>>>> no message
		{
			if (sliceResults.length > 1)
			{
				var polygon:Polygon	= sliceResults.at(0).shape as Polygon;
				var body:Body		= sliceResults.at(0).shape.body;
				
				if (polygon != null && sliceResults.at(0).shape.body.isDynamic())
				{
					//	THE POINTS THAT LIE ON THE EDGE OF THE WHOLE BODY ALONG THE SLICE VECTOR:
					var pt0:Vec2	= sliceRay.at(sliceResults.at(0).distance);
					var pt1:Vec2	= null;
					
					//	GETTING THE SECOND POINT:
					for (var i:int = 1; i < sliceResults.length; ++i)
					{
						if (sliceResults.at(i).shape == polygon)
						{
							pt1 = sliceRay.at(sliceResults.at(i).distance);
							break;
						}
					}
					
					if (pt1 != null)
					{
						//	GETTING THE NORMAL TO THE POINTS:
						var normal:Vec2		= new Vec2(-(pt1.y - pt0.y), pt1.x - pt0.x);
						var numVerts:int	= polygon.worldVerts.length;
						
						//	UTILITY FUNCTION:
						function side(n:int):Boolean
						{
							return normal.dot(polygon.worldVerts.at(n).sub(pt0)) > 0;
						}
						
						i = 0;
						while (side(i) == true)		i = (i + 1) % numVerts;
						while (side(i) == false)	i = (i + 1) % numVerts;
						
						var distPt0:Number	= Math.abs(polygon.worldVerts.at(i).sub(pt0).dot(polygon.edges.at((i - 1 + numVerts) % numVerts).worldNormal));
						var distPt1:Number	= Math.abs(polygon.worldVerts.at(i).sub(pt1).dot(polygon.edges.at((i - 1 + numVerts) % numVerts).worldNormal));
						var intersection0:Vec2;
						var intersection1:Vec2;
						
						if (distPt0 < distPt1)
						{
							intersection0	= pt0;
							intersection1	= pt1;
						} else {
							intersection0	= pt1;
							intersection1	= pt0;
						}
						
						//	CREATING THE TWO HALVES OF THE WHOLE BODY:
						for (var n:int = 0; n < 2; ++n)
						{
							var verts:Array			= [n == 0 ? intersection0 : intersection1];
							var locVerts:Vec2List	= new Vec2List();
							locVerts.push(n == 0 ? body.worldPointToLocal(intersection0) : body.worldPointToLocal(intersection1))
							
							while (side(i) == (n == 0))
							{
								verts.push(polygon.worldVerts.at(i));
								locVerts.push(polygon.localVerts.at(i));
								i	= (i + 1) % numVerts;
							}
							
							verts.push(n == 0 ? intersection1 : intersection0);
							locVerts.push(n == 0 ? body.worldPointToLocal(intersection1) : body.worldPointToLocal(intersection0));
							
							var newBody:Body	= new Body(BodyType.DYNAMIC);
							newBody.shapes.add(new Polygon(verts, polygon.material, polygon.filter));
							
							var worldVerts:Vec2List	= newBody.shapes.at(0).castPolygon.worldVerts;
							var localVerts:Vec2List	= newBody.shapes.at(0).castPolygon.localVerts;
							var vecs:Array			= new Array();
							newBody.align();
							
							for (var k:int = 0; k < worldVerts.length; k++) 
							{
								var v:Vec2 = localVerts.at(k);								
								vecs.push(v)
							}
							
<<<<<<< HEAD
							newBody.space = _sliceSpace;
							_slices.push(newBody);
						}
						body.space = null;
						_slices.splice(_slices.indexOf(body), 1);
=======
							newBody.space = _spaceOrigin;
							_gibs.push(newBody);
						}
						body.space = null;
						_gibs.splice(_gibs.indexOf(body), 1);
>>>>>>> no message
					}
				}
			}
		}
<<<<<<< HEAD
		
		public function get image():Image 
		{
			return _image;
		}
		
		public function set image(value:Image):void 
		{
			_image = value;
		}
=======
>>>>>>> no message
	}
}