package piratepig;


import openfl.display.Application;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.AssetLibrary;
import openfl.utils.Assets;
import piratepig.PiratePig;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		// TODO: Add support for asset manifests
		
		var images = [
			{ path: "images/background_tile.png" },
			{ path: "images/center_bottom.png" },
			{ path: "images/cursor_highlight.png" },
			{ path: "images/cursor.png" },
			{ path: "images/game_bear.png" },
			{ path: "images/game_bunny_02.png" },
			{ path: "images/game_carrot.png" },
			{ path: "images/game_lemon.png" },
			{ path: "images/game_panda.png" },
			{ path: "images/game_piratePig.png" },
			{ path: "images/logo.png" }
		];
		
		var sounds = [
			{ paths: [ "sounds/3.ogg", "sounds/3.mp3", "sounds/3.wav" ], id: "sound3" },
			{ paths: [ "sounds/4.ogg", "sounds/4.mp3", "sounds/4.wav" ], id: "sound4" },
			{ paths: [ "sounds/5.ogg", "sounds/5.mp3", "sounds/5.wav" ], id: "sound5" },
			{ paths: [ "sounds/theme.ogg", "sounds/theme.mp3", "sounds/theme.wav" ], id: "soundTheme" }
		];
		
		var fonts = [
			{ name: "Freebooter", id: "fonts/FreebooterUpdated.ttf" }
		];
		
		// Hack, since the default asset library (usually) always exists
		var library = new AssetLibrary ();
		Assets.registerLibrary ("default", library);
		
		var total = images.length + sounds.length + fonts.length;
		var loaded = 0;
		
		var checkLoaded = function () {
			
			loaded++;
			if (loaded == total) {
				addChild (new PiratePig ());
			}
			
		}
		
		for (asset in images) {
			
			BitmapData.loadFromFile (asset.path).onComplete (function (bitmapData) {
				
				Assets.cache.setBitmapData (asset.path, bitmapData);
				checkLoaded ();
				
			}).onError (function (e) {
				trace (e);
			});
			
		}
		
		for (asset in sounds) {
			
			Sound.loadFromFiles (asset.paths).onComplete (function (sound) {
				
				Assets.cache.setSound (asset.id, sound);
				checkLoaded ();
				
			}).onError (function (e) {
				trace (e);
			});
			
		}
		
		for (asset in fonts) {
			
			Font.loadFromName (asset.name).onComplete (function (font) {
				
				Assets.cache.setFont (asset.id, font);
				checkLoaded ();
				
			}).onError (function (e) {
				trace (e);
			});
			
		}
		
	}
	
	
	
	// Entry point
	
	
	
	
	static function main () {
		
		var app = new Application ();
		app.create ({
			windows: [{
				width: 0,
				height: 0,
				element: js.Browser.document.getElementById ("openfl-content"),
				resizable: true
			}]
		});
		app.exec ();
		
		var stage = app.window.stage;
		stage.addChild (new Main ());
		
	}
	
	
}