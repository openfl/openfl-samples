package;


import openfl.display.Sprite;
import openfl.external.ExternalInterface;
import openfl.text.TextField;
import openfl.text.TextFormat;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var label = new TextField ();
		label.defaultTextFormat = new TextFormat ("_sans", 18);
		label.autoSize = LEFT;
		label.selectable = false;
		label.x = 4;
		label.y = 4;
		addChild (label);
		
		if (ExternalInterface.available) {
			
			ExternalInterface.addCallback ("helloFromBrowser", function (message) {
				
				label.text = message;
				
			});
			
			ExternalInterface.call ("helloFromOpenFL", "Hello from OpenFL");
			
		} else {
			
			label.text = "ExternalInterface not supported";
			
		}
		
	}
	
	
}