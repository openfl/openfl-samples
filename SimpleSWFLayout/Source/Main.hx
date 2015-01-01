package;


import layout.LayoutItem;
import layout.LayoutManager;
import layout.LayoutType;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.ByteArray;
import openfl.Assets;


class Main extends Sprite {
	
	
	private var layout:MovieClip;
	private var layoutManager:LayoutManager;
	
	
	public function new () {
		
		super ();
		
		var layout = Assets.getMovieClip ("layout:Layout");
		addChild (layout);
		
		layoutManager = new LayoutManager (800, 600);
		
		layoutManager.addItem (new LayoutItem (layout.getChildByName ("Background"), LayoutType.STRETCH, LayoutType.STRETCH, false, false));
		layoutManager.addItem (new LayoutItem (layout.getChildByName ("Header"), LayoutType.STRETCH, LayoutType.TOP, false));
		layoutManager.addItem (new LayoutItem (layout.getChildByName ("Column"), LayoutType.LEFT, LayoutType.STRETCH, true, false));
		
		layoutManager.resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		layoutManager.resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}