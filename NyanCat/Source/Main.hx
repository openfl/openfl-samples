package;

import flash.display.Sprite;
import flash.utils.ByteArray;
import openfl.Assets;

class Main extends Sprite 
{	
	public function new () 
	{		
		super ();
		
		var cat = Assets.getMovieClip ("library:NyanCatAnimation");
		addChild (cat);		
	}	
}