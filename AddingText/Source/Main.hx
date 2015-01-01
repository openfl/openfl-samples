package;


import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;


class Main extends Sprite {
	
	
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
	
	
}