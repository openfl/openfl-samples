package;
import openfl._legacy.display.BitmapData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.Shader;
import openfl.events.KeyboardEvent;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.filters.ShaderFilter;
import openfl.geom.ColorTransform;
#if !flash
import shaders.DotShader;
import shaders.RGBShiftShader;
#end
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

class FilterExample extends Sprite {

	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(_) {
		
		var bitmapData = Assets.getBitmapData("assets/openfl.png");
		var left = new Sprite();
		var right = new Sprite();
		addChild(left);
		addChild(right);
		left.addChild(new Bitmap(bitmapData));
		right.addChild(new Bitmap(bitmapData));
		left.y = right.y = stage.stageHeight / 2 - bitmapData.height / 2;
		right.x = left.x + left.width;
		
		var text = new TextField();
		text.defaultTextFormat = new TextFormat('_sans', 32, 0xFFFFFF);
		text.text = "OpenFL with filters!";
		text.x = 100;
		text.y = 100;
		text.width = 600;
		text.filters = [new DropShadowFilter(), new GlowFilter(),];
		addChild(text);
		
		var shape = new Shape();
		shape.graphics.beginFill(0xEE00EE);
		shape.graphics.drawCircle(100, 100, 100);
		shape.x = 200;
		shape.y = 200;
		shape.filters = [new DropShadowFilter()];
		addChild(shape);
		
		var normal:Array<Float> = [ 
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0
		];
		var sepia:Array<Float> = [
			0.393, 0.7689999, 0.18899999, 0, 0,
			0.349, 0.6859999, 0.16799999, 0, 0,
			0.272, 0.5339999, 0.13099999, 0, 0,
			0,0,0,1,0
		];
		var invert:Array<Float> = [ 
			-1, 0, 0, 0, 255,
			0, -1, 0, 0, 255,
			0, 0, -1, 0, 255,
			0, 0, 0, 1, 0
		];
		var grayscale:Array<Float> = [
			0.5, 0.5, 0.5, 0, 0,
			0.5, 0.5, 0.5, 0, 0,
			0.5, 0.5, 0.5, 0, 0,
			0, 0, 0, 1, 0
		];
		
		var colors = [normal, sepia, invert, grayscale];
		var randColors = function() {
			return colors[Std.int(colors.length * Math.random())];
		};
		
		var blurFilter = new BlurFilter();
		var colorMatrixFilter = new ColorMatrixFilter(randColors());
		
		#if flash
		var filterArray:Array<BitmapFilter> = [blurFilter, colorMatrixFilter];
		#else
		
		var rgbShader = new RGBShiftShader();
		var rgbFilter = new ShaderFilter(rgbShader);
		// this filter needs to extend the cached bitmap
		rgbFilter.topExtension = rgbFilter.bottomExtension = 4;
		rgbFilter.leftExtension = rgbFilter.rightExtension = 4;
		
		var filterArray:Array<BitmapFilter> = [rgbFilter, blurFilter, colorMatrixFilter];
		#end
		
		this.filters = filterArray;
		
		var removeFilters = false;
		var added = true;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
			switch(e.keyCode) {
				case Keyboard.C:
					colorMatrixFilter.matrix = randColors();
				case Keyboard.S:
					if(added)
						removeChild(shape);
					else
						addChild(shape);
					added = !added;
				case _:
					removeFilters = !removeFilters;
			}
			
			this.filters = removeFilters ? null : filterArray;
		});
		
		
		addEventListener(Event.ENTER_FRAME, function(_) {
			#if !flash
			rgbShader.angle += 0.05;
			
			// We need to re-apply the filters to signal the cached bitmap to update.
			this.filters = removeFilters ? null : filterArray;
			#end
		});
	}
	
}


