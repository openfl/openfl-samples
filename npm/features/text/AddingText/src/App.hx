import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetManifest;


class App extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var format = new TextFormat ("Katamotz Ikasi", 30, 0x7A0026);
		var textField = new TextField ();
		
		textField.defaultTextFormat = format;
		textField.embedFonts = true;
		textField.selectable = false;
		
		textField.x = 50;
		textField.y = 50;
		textField.width = 200;
		
		textField.text = "Hello World";
		
		addChild (textField);
		
	}
	
	
	static function main () {
		
		var manifest = new AssetManifest ();
		manifest.addFont ("Katamotz Ikasi");
		
		AssetLibrary.loadFromManifest (manifest).onComplete (function (library) {
			
			//Assets.registerLibrary ("default", library);
			
			var stage = new Stage (550, 400, 0xFFFFFF, App);
			js.Browser.document.body.appendChild (stage.element);
			
		}).onError (function (e) {
			
			trace (e);
			
		});
		
	}
	
	
}