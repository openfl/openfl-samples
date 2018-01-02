package piratepig;


import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetManifest;
import openfl.utils.Assets;
import piratepig.PiratePig;


class Main extends Sprite {
	
	
	static function main () {
		
		var manifest = new AssetManifest ();
		
		for (image in [ "background_tile.png", "center_bottom.png", "cursor_highlight.png", "cursor.png", "game_bear.png", "game_bunny_02.png", "game_carrot.png", "game_lemon.png", "game_panda.png", "game_piratePig.png", "logo.png"]) {
			
			manifest.addBitmapData ("images/" + image);
			
		}
		
		for (sound in [ "3", "4", "5", "theme" ]) {
			
			var id = "sound" + sound.charAt (0).toUpperCase () + sound.substr (1);
			manifest.addSound ([ "sounds/" + sound + ".ogg", "sounds/" + sound + ".mp3", "sounds/" + sound + ".wav" ], id);
			
		}
		
		manifest.addFont ("Freebooter", "fonts/FreebooterUpdated.ttf");
		
		AssetLibrary.loadFromManifest (manifest).onComplete (function (library) {
			
			Assets.registerLibrary ("default", library);
			
			var stage = new Stage ();
			js.Browser.document.getElementById ("openfl-content").appendChild (stage.element);
			stage.addChild (new PiratePig ());
			
		}).onError (function (e) {
			
			trace (e);
			
		});
		
	}
	
	
}