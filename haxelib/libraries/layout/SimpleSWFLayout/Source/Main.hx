package;


import layout.Layout;
import layout.LayoutItem;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.ByteArray;
import openfl.Assets;


class Main extends Sprite {
	
	
	private var clip:MovieClip;
	private var layout:Layout;
	
	
	public function new () {
		
		super ();
		
		clip = Assets.getMovieClip ("layout:Layout");
		addChild (clip);
		
		layout = new Layout ();
		
		layout.addItem (new LayoutItem (clip.getChildByName ("Background"), STRETCH, STRETCH, false, false));
		layout.addItem (new LayoutItem (clip.getChildByName ("Header"), TOP, STRETCH, true, false));
		layout.addItem (new LayoutItem (clip.getChildByName ("Column"), STRETCH, LEFT, false, true));
		
		layout.resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		layout.resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}