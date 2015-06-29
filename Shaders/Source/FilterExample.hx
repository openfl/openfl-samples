package;
import openfl._legacy.display.BitmapData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.Shader;
import openfl.events.KeyboardEvent;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.ShaderFilter;
import openfl.geom.ColorTransform;
#if !flash
import shaders.DotShader;
import shaders.RGBShiftShader;
#end
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
		// this filter needs to extend the texture
		rgbFilter.topExtension = rgbFilter.bottomExtension = 4;
		rgbFilter.leftExtension = rgbFilter.rightExtension = 4;
		
		var filterArray:Array<BitmapFilter> = [rgbFilter, blurFilter, colorMatrixFilter];
		#end
		
		this.filters = filterArray;
		
		var removeFilters = false;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
			switch(e.keyCode) {
				case Keyboard.C:
					colorMatrixFilter.matrix = randColors();
				case _:
					removeFilters = !removeFilters;
			}
			
			this.filters = removeFilters ? null : filterArray;
		});
		
		
		addEventListener(Event.ENTER_FRAME, function(_) {
			#if !flash
			rgbShader.angle += 0.05;
			this.filters = removeFilters ? null : filterArray;
			#end
		});
	}
	
}


