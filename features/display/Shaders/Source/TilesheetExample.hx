package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import shaders.RGBShiftShader;

class TilesheetExample extends Sprite {

	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(_) {
		// Our usual setup
		var sprite = new Sprite();
		addChild(sprite);
		
		var bitmapData = Assets.getBitmapData("assets/openfl.png");
		var sy = stage.stageHeight / 2 - bitmapData.height / 2;
		// the tilesheet array
		var tsArray = [0, sy, 0, bitmapData.width, sy, 0];
		// we create the tilesheet object
		var tilesheet = new Tilesheet(bitmapData);
		tilesheet.addTileRect(bitmapData.rect);
		
		var rgbShader = new RGBShiftShader();
		rgbShader.amount += 0.05;
		
		// The matrix we will apply to the cached bitmap
		var m = new Matrix();
		m.scale(0.4, 0.4);
		m.rotate(45);
		// we assign the matrix
		sprite.cacheAsBitmapMatrix = m;
		sprite.cacheAsBitmap = true;
		// and disable smooth on the cached bitmap
		sprite.cacheAsBitmapSmooth = false;
		
		sprite.graphics.drawTiles(tilesheet, tsArray, rgbShader);
		
		var swapShader = false;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e) {
			switch(e.keyCode) {
				case Keyboard.C:
					sprite.cacheAsBitmap = !sprite.cacheAsBitmap;
					trace("The sprite " + (sprite.cacheAsBitmap ? "is cached" : "isn't cached"));
				case Keyboard.S:
					sprite.cacheAsBitmapSmooth = !sprite.cacheAsBitmapSmooth;
					trace("The cached sprite " + (sprite.cacheAsBitmapSmooth ? "is smooth" : "isn't smooth"));
				case Keyboard.SPACE:
					swapShader = !swapShader;
					sprite.shader = swapShader ? rgbShader : null;
					sprite.graphics.drawTiles(tilesheet, tsArray, swapShader ? null : rgbShader);
					// we need to reassign the value so that the cached bitmap can be updated
					sprite.cacheAsBitmap = sprite.cacheAsBitmap;
					trace("The shader is applied to " + (swapShader ? "the sprite" : "the drawTiles function"));
			}
		});
	}
	
}