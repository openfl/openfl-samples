package tests;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

#if !flash
typedef UInt = Int;
#end

/**
 * @author Joshua Granick
 * @author Philippe Elsass
 */
class DrawTrianglesTest extends Sprite 
{
	var tf:TextField;	
	var numBunnies:Int;
	var incBunnies:Int;
	var smooth:Bool;
	var gravity:Float;
	var bunnies:Array <Bunny>;
	var maxX:Int;
	var minX:Int;
	var maxY:Int;
	var minY:Int;
	var bunnyAsset:BitmapData;
	var pirate:Bitmap;
	var tilesheet:Tilesheet;
	var drawList:Array<Float>;
	
	public function new() 
	{
		super ();

		gravity = 0.5;
		incBunnies = 100;
		#if flash
		smooth = false;
		numBunnies = 100;
		Lib.current.stage.quality = StageQuality.LOW;
		#else
		smooth = true;
		numBunnies = 500;
		#end

		bunnyAsset = Assets.getBitmapData("assets/wabbit_alpha.png");
		pirate = new Bitmap(Assets.getBitmapData("assets/pirate.png"), PixelSnapping.AUTO, true);
		pirate.scaleX = pirate.scaleY = Env.height / 768;
		addChild(pirate);
		
		bunnies = new Array<Bunny>();
		drawList = new Array<Float>();
		tilesheet = new Tilesheet(bunnyAsset);
		tilesheet.addTileRect(
			new Rectangle (0, 0, bunnyAsset.width, bunnyAsset.height));
		
		var bunny; 
		for (i in 0...numBunnies) 
		{
			bunny = new Bunny();
			bunny.position = new Point();
			bunny.speedX = Math.random() * 5;
			bunny.speedY = (Math.random() * 5) - 2.5;
			bunny.scale = 0.3 + Math.random();
			bunny.rotation = 15 - Math.random() * 30;
			bunnies.push(bunny);
		}
		
		createCounter();
		
		addEventListener(Event.ENTER_FRAME, enterFrame);
		Lib.current.stage.addEventListener(Event.RESIZE, stage_resize);
		stage_resize(null);
	}

	function createCounter()
	{
		var format = new TextFormat("_sans", 20, 0, true);
		format.align = TextFormatAlign.RIGHT;

		tf = new TextField();
		tf.selectable = false;
		tf.defaultTextFormat = format;
		tf.width = 200;
		tf.height = 60;
		tf.x = maxX - tf.width - 10;
		tf.y = 10;
		addChild(tf);

		tf.addEventListener(MouseEvent.CLICK, counter_click);
	}

	function counter_click(e)
	{
		if (numBunnies >= 1500) incBunnies = 250;
		var more = numBunnies + incBunnies;

		var bunny; 
		for (i in numBunnies...more)
		{
			bunny = new Bunny();
			bunny.position = new Point();
			bunny.speedX = Math.random() * 5;
			bunny.speedY = (Math.random() * 5) - 2.5;
			bunny.scale = 0.3 + Math.random();
			bunny.rotation = 15 - Math.random() * 30;
			bunnies.push (bunny);
		}
		numBunnies = more;

		stage_resize(null);
	}
	
	function stage_resize(e) 
	{
		maxX = Env.width;
		maxY = Env.height;
		tf.text = "Bunnies:\n" + numBunnies;
		tf.x = maxX - tf.width - 10;
	}
	
	function enterFrame(e) 
	{	
		graphics.clear ();

		var TILE_FIELDS = 6; // x+y+index+scale+rotation+alpha
		var bunny;
	 	for (i in 0...numBunnies)
		{
			bunny = bunnies[i];
			bunny.position.x += bunny.speedX;
			bunny.position.y += bunny.speedY;
			bunny.speedY += gravity;
			bunny.alpha = 0.3 + 0.7 * bunny.position.y / maxY;
			
			if (bunny.position.x > maxX)
			{
				bunny.speedX *= -1;
				bunny.position.x = maxX;
			}
			else if (bunny.position.x < minX)
			{
				bunny.speedX *= -1;
				bunny.position.x = minX;
			}
			if (bunny.position.y > maxY)
			{
				bunny.speedY *= -0.8;
				bunny.position.y = maxY;
				if (Math.random() > 0.5) bunny.speedY -= 3 + Math.random() * 4;
			} 
			else if (bunny.position.y < minY)
			{
				bunny.speedY = 0;
				bunny.position.y = minY;
			}
			
			var index = i * TILE_FIELDS;
			drawList[index] = bunny.position.x;
			drawList[index + 1] = bunny.position.y;
			//drawList[index + 2] = 0; // sprite index
			drawList[index + 3] = bunny.scale;
			drawList[index + 4] = bunny.rotation;
			drawList[index + 5] = bunny.alpha;
		}
		
		tilesheet.drawTiles(graphics, drawList, smooth, 
			Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA);

		var t = Lib.getTimer();
		pirate.x = Std.int((Env.width - pirate.width) * (0.5 + 0.5 * Math.sin(t / 3000)));
		pirate.y = Std.int(Env.height - pirate.height + 70 - 30 * Math.sin(t / 100));
	}
	
	
}



import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Loader;
import nme.Vector;


class Tilesheet
{
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	
	// Will ignore scale and rotation....
	// (not supported right now)
	public static inline var TILE_TRANS_2x2 = 0x0010;
	
	
	public static inline var TILE_BLEND_NORMAL   = 0x00000000;
	public static inline var TILE_BLEND_ADD      = 0x00010000;
	
	/**
	 * @private
	 */
	public var nmeBitmap:BitmapData;
	
	static private var defaultRatio:Point = new Point(0, 0);
	private var bitmapHeight:Int;
	private var bitmapWidth:Int;
	private var tilePoints:Array<Point>;
	private var tiles:Array<Rectangle>;
	private var tileUVs:Array<Rectangle>;
	private var _ids:Vector<Int>;
	private var _vertices:Vector<Float>;
	private var _indices:Vector<Int>;
	private var _uvs:Vector<Float>;
	
	
	public function new(inImage:BitmapData)
	{
		nmeBitmap = inImage;
		
		bitmapWidth = nmeBitmap.width;
		bitmapHeight = nmeBitmap.height;
		
		tilePoints = new Array<Point>();
		tiles = new Array<Rectangle>();
		tileUVs = new Array<Rectangle>();
		_ids = new Vector<Int>();
		_vertices = new Vector<Float>();
		_indices = new Vector<Int>();
		_uvs = new Vector<Float>();
		
	}
	
	
	public function addTileRect(rectangle:Rectangle, centerPoint:Point = null)
	{
		tiles.push(rectangle);
		if (centerPoint == null) tilePoints.push(defaultRatio);
		else tilePoints.push(new Point(centerPoint.x / rectangle.width, centerPoint.y / rectangle.height));	
		tileUVs.push(new Rectangle(rectangle.left / bitmapWidth, rectangle.top / bitmapHeight, rectangle.right / bitmapWidth, rectangle.bottom / bitmapHeight));
	}
	
	
	private function adjustIDs(vec:Vector<Int>, len:UInt)
	{
		if (vec.length != len)
		{
			var prevLen = vec.length;
			#if flash
			vec.fixed = false;
			vec.length = len;
			vec.fixed = true;
			#end
			for(i in prevLen...len)
				vec[i] = -1;
		}
		return vec;
	}
	
	
	private function adjustIndices(vec:Vector<Int>, len:UInt)
	{
		if (vec.length != len)
		{
			#if flash
			vec.fixed = false;
			#end
			if (vec.length > len)
			{
				#if flash
				vec.length = len;
				vec.fixed = true;
				#end
			}
			else 
			{
				var offset6 = vec.length;
				var offset4 = cast(4 * offset6 / 6, Int);
				#if flash
				vec.length = len;
				vec.fixed = true;
				#end
				while (offset6 < len)
				{
					vec[offset6] = 0 + offset4;
					vec[offset6 + 1] = vec[offset6 + 3] = 1 + offset4;
					vec[offset6 + 2] = vec[offset6 + 5] = 2 + offset4;
					vec[offset6 + 4] = 3 + offset4;
					offset4 += 4;
					offset6 += 6;
				}
			}
		}
		return vec;
	}
	
	
	private function adjustLen(vec:Vector<Float>, len:UInt)
	{
		if (vec.length != len)
		{
			#if flash
			vec.fixed = false;
			vec.length = len;
			vec.fixed = true;
			#end
		}
		return vec;
	}
	
	
	/**
	 * Fast method to draw a batch of tiles using a Tilesheet
	 * 
	 * The input array accepts the x, y and tile ID for each tile you wish to draw.
	 * For example, an array of [ 0, 0, 0, 10, 10, 1 ] would draw tile 0 to (0, 0) and
	 * tile 1 to (10, 10)
	 * 
	 * You can also set flags for TILE_SCALE, TILE_ROTATION, TILE_RGB and
	 * TILE_ALPHA.
	 * 
	 * Depending on which flags are active, this is the full order of the array:
	 * 
	 * [ x, y, tile ID, scale, rotation, red, green, blue, alpha, x, y ... ]
	 * 
	 * @param	graphics		The neash.display.Graphics object to use for drawing
	 * @param	tileData		An array of all position, ID and optional values for use in drawing
	 * @param	smooth		(Optional) Whether drawn tiles should be smoothed (Default: false)
	 * @param	flags		(Optional) Flags to enable scale, rotation, RGB and/or alpha when drawing (Default: 0)
	 */
	public function drawTiles (graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void
	{
		var useScale = (flags & TILE_SCALE) > 0;
		var useRotation = (flags & TILE_ROTATION) > 0;
		var useRGB = (flags & TILE_RGB) > 0;
		var useAlpha = (flags & TILE_ALPHA) > 0;
		
		if (useScale || useRotation || useRGB || useAlpha)
		{
			var scaleIndex = 0;
			var rotationIndex = 0;
			var rgbIndex = 0;
			var alphaIndex = 0;
			var numValues = 3;
			
			if (useScale)
			{
				scaleIndex = numValues;
				numValues ++;
			}
			
			if (useRotation)
			{
				rotationIndex = numValues;
				numValues ++;
			}
			
			if (useRGB)
			{
				rgbIndex = numValues;
				numValues += 3;
			}
			
			if (useAlpha)
			{
				alphaIndex = numValues;
				numValues ++;
			}
			
			var totalCount = tileData.length;
			var itemCount = Std.int (totalCount / numValues);
			
			var ids = adjustIDs(_ids, itemCount);
			var vertices = adjustLen(_vertices, itemCount * 8); 
			var indices = adjustIndices(_indices, itemCount * 6); 
			var uvtData = adjustLen(_uvs, itemCount * 8); 
			
			var index = 0;
			var offset8 = 0;
			var tileIndex:Int = 0;
			var tileID:Int = 0;
			var cacheID:Int = -1;
			
			var tile:Rectangle = null;
			var tileUV:Rectangle = null;
			var tilePoint:Point = null;
			var tileHalfHeight:Float = 0;
			var tileHalfWidth:Float = 0;
			var tileHeight:Float = 0;
			var tileWidth:Float = 0;

			while (index < totalCount)
			{
				var x = tileData[index];
				var y = tileData[index + 1];
				var tileID = Std.int(tileData[index + 2]);
				var scale = 1.0;
				var rotation = 0.0;
				var alpha = 1.0;
				
				if (useScale)
				{
					scale = tileData[index + scaleIndex];
				}
				
				if (useRotation)
				{
					rotation = tileData[index + rotationIndex];
				}
				
				if (useRGB)
				{
					//ignore for now
				}
				
				if (useAlpha)
				{
					alpha = tileData[index + alphaIndex];
				}
				
				if (cacheID != tileID)
				{
					cacheID = tileID;
					tile = tiles[tileID];
					tileUV = tileUVs[tileID];
					tilePoint = tilePoints[tileID];
				}
				
				var tileWidth = tile.width * scale;
				var tileHeight = tile.height * scale;
				
				if (rotation != 0)
				{
					var kx = tilePoint.x * tileWidth;
					var ky = tilePoint.y * tileHeight;
					var akx = (1 - tilePoint.x) * tileWidth;
					var aky = (1 - tilePoint.y) * tileHeight;
					var ca = Math.cos(rotation);
					var sa = Math.sin(rotation);
					var xc = kx * ca, xs = kx * sa, yc = ky * ca, ys = ky * sa;
					var axc = akx * ca, axs = akx * sa, ayc = aky * ca, ays = aky * sa;
					vertices[offset8] = x - (xc + ys);
					vertices[offset8 + 1] = y - (-xs + yc);
					vertices[offset8 + 2] = x + axc - ys;
					vertices[offset8 + 3] = y - (axs + yc);
					vertices[offset8 + 4] = x - (xc - ays);
					vertices[offset8 + 5] = y + xs + ayc;
					vertices[offset8 + 6] = x + axc + ays;
					vertices[offset8 + 7] = y + (-axs + ayc);
				}
				else 
				{
					x -= tilePoint.x * tileWidth;
					y -= tilePoint.y * tileHeight;
					vertices[offset8] = vertices[offset8 + 4] = x;
					vertices[offset8 + 1] = vertices[offset8 + 3] = y;
					vertices[offset8 + 2] = vertices[offset8 + 6] = x + tileWidth;
					vertices[offset8 + 5] = vertices[offset8 + 7] = y + tileHeight;
				}
				
				if (ids[tileIndex] != tileID)
				{
					ids[tileIndex] = tileID;
					uvtData[offset8] = uvtData[offset8 + 4] = tileUV.left;
					uvtData[offset8 + 1] = uvtData[offset8 + 3] = tileUV.top;
					uvtData[offset8 + 2] = uvtData[offset8 + 6] = tileUV.width;
					uvtData[offset8 + 5] = uvtData[offset8 + 7] = tileUV.height;
				}
				
				offset8 += 8;
				index += numValues;
				tileIndex++;
			}
			
			graphics.beginBitmapFill (nmeBitmap, null, false, smooth);
			graphics.drawTriangles (vertices, indices, uvtData);
			
		}
		else
		{
			
			var index = 0;
			var matrix = new Matrix ();
			
			while (index < tileData.length)
			{
				var x = tileData[index];
				var y = tileData[index + 1];
				var tileID = Std.int (tileData[index + 2]);
				index += 3;
				
				var tile = tiles[tileID];
				var centerPoint = tilePoints[tileID];
				var ox = centerPoint.x * tile.width, oy = centerPoint.y * tile.height;
				
				var scale = 1.0;
				var rotation = 0.0;
				var alpha = 1.0;
				
				if (useScale)
				{
					scale = tileData[index];
					index ++;
				}
				
				if (useRotation)
				{
					rotation = tileData[index];
					index ++;
				}
				
				if (useRGB)
				{
					//ignore for now
					index += 3;
				}
				
				if (useAlpha)
				{
					alpha = tileData[index];
					index++;
				}
				
				matrix.tx = x - tile.x - ox;
				matrix.ty = y - tile.y - oy;
				
				// need to add support for rotation, alpha, scale and RGB
				
				graphics.beginBitmapFill (nmeBitmap, matrix, false, smooth);
				graphics.drawRect (x - ox, y - oy, tile.width, tile.height);
			}
			
		}
		
		graphics.endFill ();
	}
	
}