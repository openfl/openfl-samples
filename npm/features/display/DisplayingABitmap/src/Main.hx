import openfl.display.Application;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.net.URLRequest;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var loader = new Loader ();
		loader.contentLoaderInfo.addEventListener (Event.COMPLETE, loader_onComplete);
		loader.load (new URLRequest ("openfl.png"));
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function loader_onComplete (event:Event):Void {
		
		var bitmap = cast (event.target.loader.content, Bitmap);
		bitmap.x = (stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (stage.stageHeight - bitmap.height) / 2;
		addChild (bitmap);
		
	}
	
	
	
	
	// Entry point
	
	
	
	
	static function main () {
		
		var div = js.Browser.document.createElement ("div");
		js.Browser.document.body.appendChild (div);
		
		var app = new Application ();
		app.create ({
			windows: [{
				width: 550,
				height: 400,
				element: div
			}]
		});
		app.exec ();
		
		var stage = app.window.stage;
		stage.addChild (new Main ());
		
	}
	
	
}