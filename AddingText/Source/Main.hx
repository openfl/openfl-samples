package;


import flash.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import openfl.Assets;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var font = Assets.getFont ("assets/KatamotzIkasi.ttf");
		var format = new TextFormat (font.fontName, 30, 0x7A0026);
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