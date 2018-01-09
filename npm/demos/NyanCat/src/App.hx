import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.utils.AssetLibrary;


class App extends Sprite {
	
	
	public function new () {
		
		super ();
		
		AssetLibrary.loadFromFile ("library.bundle").onComplete (function (library:AssetLibrary) {
			
			var cat = library.getMovieClip ("NyanCatAnimation");
			addChild (cat);
			
		}).onError (function (e) trace (e));
		
	}
	
	
	static function main () {
		
		var stage = new Stage (550, 400, 0xFFFFFF, App);
		js.Browser.document.body.appendChild (stage.element);
		
	}
	
	
}