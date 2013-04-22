package;


import flash.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;

@:font("KatamotzIkasi.ttf") class DefaultFont extends Font {}


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		Font.registerFont (DefaultFont);
		
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