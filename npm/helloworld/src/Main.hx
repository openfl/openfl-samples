import openfl.display.BitmapData;
import openfl.geom.Rectangle;


class Main {
	
	
	static function main () {
		
		var bitmapData = new BitmapData (200, 200, true, 0xFF24AFC4);
		
		var rect = new Rectangle (50, 50, 100, 100);
		bitmapData.fillRect (rect, 0xFFCCCCCC);
		
		js.Browser.document.body.appendChild (bitmapData.image.src);
		trace ("Hello World");
		
	}
	
	
}