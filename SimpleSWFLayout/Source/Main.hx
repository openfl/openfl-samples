package;


import layout.LayoutGroup;
import layout.LayoutItem;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.ByteArray;
import openfl.Assets;


class Main extends Sprite {
	
	
	private var layout:MovieClip;
	private var layoutGroup:LayoutGroup;
	
	
	public function new () {
		
		super ();
		
		var layout = Assets.getMovieClip ("layout:Layout");
		addChild (layout);
		
		layoutGroup = new LayoutGroup (800, 600);
		
		layoutGroup.addItem (new LayoutItem (layout.getChildByName ("Background"), STRETCH, STRETCH, false, false));
		layoutGroup.addItem (new LayoutItem (layout.getChildByName ("Header"), STRETCH, TOP, false));
		layoutGroup.addItem (new LayoutItem (layout.getChildByName ("Column"), LEFT, STRETCH, true, false));
		
		layoutGroup.resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		layoutGroup.resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}