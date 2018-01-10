import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.utils.AssetLibrary;
import js.Lib.require;


class App extends Sprite {
	
	
	private var columnOffsetHeight:Float;
	private var headerOffsetWidth:Float;
	private var layout:MovieClip;
	
	
	public function new () {
		
		super ();
		
		AssetLibrary.loadFromFile (require ("./assets/layout.swf")).onComplete (function (library:AssetLibrary) {
			
			layout = library.getMovieClip ("Layout");
			addChild (layout);
			
			columnOffsetHeight = (layout.Column.height - layout.height);
			headerOffsetWidth = (layout.Header.width - layout.width);
			
			resize ();
			stage.addEventListener (Event.RESIZE, resize);
			
		});
		
	}
	
	
	private function resize (event:Event = null):Void {
		
		var background = cast (layout.Background, MovieClip);
		var column = cast (layout.Column, MovieClip);
		var header =cast (layout.Header, MovieClip);
		
		background.width = stage.stageWidth;
		background.height = stage.stageHeight;
		
		var columnHeight = stage.stageHeight + columnOffsetHeight;
		column.height = (columnHeight > 0 ? columnHeight : 0);
		
		var headerWidth = stage.stageWidth + headerOffsetWidth;
		header.width = (headerWidth > 0 ? headerWidth : 0);
		
	}
	
	
	static function main () {
		
		var stage = new Stage (0, 0, 0xFFFFFF, App);
		js.Browser.document.body.appendChild (stage.element);
		
	}
	
	
}