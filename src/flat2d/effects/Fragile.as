package flat2d.effects
{
	import flash.geom.Matrix;
	import flat2d.entities.FlatPoly;
	import flat2d.utils.InteractionManager;
	import nape.callbacks.InteractionCallback;
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
	import nape.dynamics.Contact;
	import nape.dynamics.ContactList;
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
	
	/**
	 * Fragile.as
	 * Created On:	27/05/2013 11:22
	 * Author:		Joshua Barnett
	 */
	
	public class Fragile extends FlatPoly
	{
		static private const FRAGILE:String = "fragile";
		
		private var _rootImage	:Image;
		private var _massDelta	:Number;
		
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
			
			if (!_massDelta)
			{
				_massDelta	= 30000;
				InteractionManager.beginContact(FRAGILE, InteractionManager.ANY_BODY, smash);
			}
			InteractionManager.addToGroup(_body, FRAGILE);
		}
		
		private static function smash(collision:InteractionCallback):Vector.<Fragile>
		{
			var fragile:Fragile;
			if (collision.int1.castBody.userData.root is Fragile)
			{
				fragile	= collision.int1.castBody.userData.root as Fragile;
			}
			else if (collision.int2.castBody.userData.root is Fragile)
			{
				fragile = collision.int2.castBody.userData.root as Fragile;
			}
			if (!fragile || !fragile.body)
			{
				return null;
			}
			var force:Number	= fragile.getContactForce(collision.arbiters);
			var point:Vec2		= getContactPoint(collision.arbiters);
			var cuts:uint		= Math.round(force / (fragile.body.mass * fragile.massDelta));
			if (cuts)
			{
				var pieces:Vector.<Fragile>	= fragile.fracture(point, cuts);
				fragile.world.removeEntity(fragile);
				for each(var piece:Fragile in pieces)
				{
					fragile.world.addEntity(piece);
				}
				fragile.dispose();
				return pieces;
			}
			return null;
		}
		
		private function getContactForce(arbs:ArbiterList):Number
		{
			var force:Number	= 0;
			arbs.foreach(function (a:Arbiter):void
			{
				force	+= a.collisionArbiter.normalImpulse(_body).length;
			});
			return force;
		}
		
		private static function getContactPoint(arbs:ArbiterList):Vec2
		{
			var single_point_scale:Number	= 0.1;
			var ret:Vec2					= Vec2.get(0,0);
			var total:Number				= 0;
			arbs.foreach(function (a:Arbiter):void
			{
				if(!a.isCollisionArbiter())
				{
					return;
				}
				var contacts:ContactList	= a.collisionArbiter.contacts;
				var c1:Contact				= contacts.at(0);
				if (contacts.length == 1)
				{
					ret.addeq(c1.position.mul(single_point_scale, true));
					total += single_point_scale;
				}
				else
				{
					var c2:Contact	= contacts.at(1);
					var del:Vec2	= c1.position.sub(c2.position);
					var dist:Number	= Math.max(del.length,single_point_scale);
					ret.addeq(c1.position.add(c2.position, true).muleq(dist * 0.5));
					total += dist;
					del.dispose();
				}
			});
			if (total == 0)
			{
				ret.dispose();
				return null;
			}
			else
			{
				return ret.muleq(1 / total);
			}
		}
		
		public function fracture(origin:Vec2, cuts:uint):Vector.<Fragile>
		{
			if (!_body)	
			{
				return null;
			}
			
			if (!_rootImage && _view is Image)
			{
				_rootImage	= Image(_view);
			}
			
			var pieceList:GeomPolyList	= new GeomPolyList();
			var cutList:GeomPolyList	= new GeomPolyList();
			var cutMatrix:Mat23			= Mat23.rotation(_body.rotation).concat(Mat23.translation(_body.position.x, _body.position.y));
			
			pieceList.push(new GeomPoly(_hull));
			
			for (var i:int = 1; i <= cuts; ++i)
			{
				var cutStart:Vec2		= new Vec2(origin.x, origin.y);
				var cutEnd:Vec2			= cutStart.copy().add(new Vec2((Math.random() * 2) - 1, (Math.random() * 2) - 1));
				
				cutStart	= cutMatrix.inverse().transform(cutStart);
				cutEnd		= cutMatrix.inverse().transform(cutEnd);
				
				pieceList.foreach(performCut);
				function performCut(pieceGeom:GeomPoly):void
				{
					cutList.merge(pieceGeom.cut(cutStart, cutEnd, false, false));
				}
				pieceList	= cutList.copy();
				cutList.clear();
			}
			
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
				
				if (_rootImage)
				{
					var pieceView:Shape			= new Shape();
					pieceView.graphics.beginTextureFill(_rootImage.texture, pieceMatrix);
					pieceView.graphics.moveTo(pieceVerts.at(0).x, pieceVerts.at(0).y);
					for (i = 1; i < pieceVerts.length + 1; ++i)
					{
						vert	= pieceVerts.at(i % pieceVerts.length);
						pieceView.graphics.lineTo(vert.x, vert.y);
					}
					pieceView.graphics.endFill();
				}
				
				var piece:Fragile		= new Fragile(_body.position.x, _body.position.y, pieceVerts, pieceView);
				piece.body.rotation		= _body.rotation;
				piece.body.velocity		= _body.velocity;
				piece.body.angularVel	= _body.angularVel;
				piece.rootImage			= _rootImage;
				piece.align();
				pieces.push(piece);
			}
			
			if (pieces.length != 0)
			{
				_world.removeEntity(this);
				for each(var piece:Fragile in pieces)
				{
					_world.addEntity(piece);
				}
			}
			
			return pieces;
		}
		
		public function set rootImage(value:Image):void 
		{
			_rootImage = value;
		}
		
		public function get massDelta():Number 
		{
			return _massDelta;
		}
	}
}