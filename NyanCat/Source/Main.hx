package;
#if !html5


import flash.display.Sprite;
import flash.utils.ByteArray;
import format.SWF;

@:file("library.swf") class Library extends ByteArray { }


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var swf = new SWF (new Library ());
		var cat = swf.createMovieClip ("NyanCatAnimation");
		addChild (cat);
		
	}
	
	
}


#else // HTML5 does not support the above pattern yet


import flash.display.Sprite;
import flash.utils.ByteArray;
import openfl.Assets;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var cat = Assets.getMovieClip ("library:NyanCatAnimation");
		addChild (cat);
		
	}
	
	
}


#end