package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;


class Main extends Sprite {
	
	private var demo:Int = 0;
	private static inline var MAX_DEMO:Int = 5;
	
	public function new () {
		
		super ();
		
		stage.color = 0xA0A0A0;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
			if (e.keyCode == 39) {		//Right Arrow
				demo++;
				if (demo > MAX_DEMO) {
					demo = 0;
				}
				showDemo(demo);
			}
			else if (e.keyCode == 37) { //Left Arrow
				demo--;
				if (demo < 0) {
					demo = MAX_DEMO;
				}
				showDemo(demo);
			}
		});
		
		showDemo(demo);
	}
	
	function clear():Void
	{
		while (numChildren > 0)
		{
			removeChild(getChildAt(0));
		}
	}
	
	function identify():Void
	{
		var t:TextField = new TextField();
		#if flash
			t.text = "Flash";
		#elseif html5
			t.text = "HTML5";
		#elseif openfl_legacy
			t.text = "Legacy";
		#else
			t.text = "Next";
		#end
		addChild(t);
	}
	
	function showDemo(i:Int):Void
	{
		clear();
		identify();
		
		switch(i) {
			case 0: demo0();
			case 1: demo1();
			case 2: demo2();
			case 3: demo3();
			case 4: demo4();
			case 5: demo5();
		}
		
		var t:TextField = new TextField();
		t.width = 400;
		t.y = 20;
		
		t.text = "Showing demo (" + i + "), press Left or Right to change";
		addChild(t);
	}
	
	function font(str:String):String
	{
		var f = Assets.getFont(str);
		if (f != null)
		{
			return f.fontName;
		}
		return str;
	}
	
	//Demos
	
	function demo0():Void
	{
		makeText(50, 50, TextFormatAlign.CENTER, 24);
		makeText(50, 175, TextFormatAlign.LEFT, 24);
		makeText(50, 300, TextFormatAlign.RIGHT, 24);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 24);
	}
	
	function demo1():Void
	{
		var f = font("LIBERATIONSERIF-REGULAR.TTF");
		makeText(50, 50, TextFormatAlign.CENTER, 24, f);
		makeText(50, 175, TextFormatAlign.LEFT, 24, f);
		makeText(50, 300, TextFormatAlign.RIGHT, 24, f);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 24, f);
	}
	
	function demo2():Void
	{
		makeText(50, 50, TextFormatAlign.CENTER, 12);
		makeText(50, 175, TextFormatAlign.LEFT, 12);
		makeText(50, 300, TextFormatAlign.RIGHT, 12);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 12);
	}
	
	function demo3():Void
	{
		var f = font("LIBERATIONSERIF-REGULAR.TTF");
		makeText(50, 50, TextFormatAlign.CENTER, 12, f);
		makeText(50, 175, TextFormatAlign.LEFT, 12, f);
		makeText(50, 300, TextFormatAlign.RIGHT, 12, f);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 12, f);
	}
	
	function demo4():Void
	{
		var f = font("nokiafc22.ttf");
		makeText(50, 50, TextFormatAlign.CENTER, 8, f);
		makeText(50, 175, TextFormatAlign.LEFT, 8, f);
		makeText(50, 300, TextFormatAlign.RIGHT, 8, f);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 8, f);
	}
	
	function demo5():Void
	{
		var f = font("nokiafc22.ttf");
		makeText(50, 50, TextFormatAlign.CENTER, 16, f);
		makeText(50, 175, TextFormatAlign.LEFT, 16, f);
		makeText(50, 300, TextFormatAlign.RIGHT, 16, f);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 16, f);
	}
	
	function makeText(X:Float, Y:Float, align, size:Int, ?font:String)
	{
		var textField = new TextField();
		textField.defaultTextFormat = new TextFormat(font, size, 0x000000, null, null, null, null, null, align, null, null, null, 20);
		
		textField.selectable = false;
		textField.border = true;
		textField.borderColor = 0x000000;
		
		textField.width = 700;
		textField.multiline = true;
		textField.wordWrap = true;
		
		textField.autoSize = TextFieldAutoSize.NONE;
		
		textField.x = X;
		textField.y = Y;
		
		textField.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
		
		addChild (textField);
		
		/*
		var lineWidth0 = textField.getLineMetrics(0).width;
		var lineWidth1 = textField.getLineMetrics(1).width;
		var lineX0 = textField.getLineMetrics(0).x;
		var lineX1 = textField.getLineMetrics(1).x;
		
		trace("textField.width = " + textField.width);
		trace("lineWidth 0 = " + lineWidth0);
		trace("lineWidth 1 = " + lineWidth1);
		trace("lineX 0 = " + lineX0);
		trace("lineX 1 = " + lineX1);
		*/
	}
}