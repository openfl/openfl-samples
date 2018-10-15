package;

import openfl.Assets;
import openfl.display.Bitmap;
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
	
	private var alpha_step:Float = 0.25;
	private var comparison:Bitmap;
	private var label:TextField;
	
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
			else if (e.keyCode == 49) { // 1
				compare("flash");
			}
			else if (e.keyCode == 50) { // 2
				compare("legacy");
			}
			else if (e.keyCode == 51) { // 3
				compare("html5");
			}
			else if (e.keyCode == 38) { // Up
				changeAlpha(-1);
			}
			else if (e.keyCode == 40) { // Down
				changeAlpha(1);
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
	
	function getID():String
	{
		return
		#if flash
			"Flash";
		#elseif html5
			"HTML5";
		#elseif openfl_legacy
			"Legacy";
		#else
			"Next";
		#end
	}
	
	function identify():Void
	{
		var t:TextField = new TextField();
		t.text = getID();
		addChild(t);
		label = t;
	}
	
	function compare(str:String):Void
	{
		label.text = getID() + " vs " + str;
		
		if (comparison == null)
		{
			comparison = new Bitmap();
		}
		if (Assets.exists("assets/img/" + str + demo + ".png"))
		{
			comparison.bitmapData = Assets.getBitmapData("assets/img/" + str + demo + ".png");
			if (!contains(comparison))
			{
				addChildAt(comparison, 0);
			}
		}
	}
	
	function changeAlpha(i:Int):Void
	{
		if (comparison == null) return;
		var a = comparison.alpha + alpha_step * i;
		     if (a > 1.0) a = 0.0;
		else if (a < 0.0) a = 1.0;
		comparison.alpha = a;
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
		t.width = 800;
		t.y = 20;
		
		t.text = "Showing demo (" + i + "). Left/Right: Change demo; 1/2: Compare to Flash/Legacy; Up/Down: Change comparison alphas";
		addChild(t);
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
		var f = "Liberation Serif Regular";
		makeText(50, 50, TextFormatAlign.CENTER, 24, f, true);
		makeText(50, 175, TextFormatAlign.LEFT, 24, f, true);
		makeText(50, 300, TextFormatAlign.RIGHT, 24, f, true);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 24, f, true);
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
		var f = "Liberation Serif Regular";
		makeText(50, 50, TextFormatAlign.CENTER, 12, f, true);
		makeText(50, 175, TextFormatAlign.LEFT, 12, f, true);
		makeText(50, 300, TextFormatAlign.RIGHT, 12, f, true);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 12, f, true);
	}
	
	function demo4():Void
	{
		var f = "Nokia Cellphone FC Small";
		makeText(50, 50, TextFormatAlign.CENTER, 8, f, true);
		makeText(50, 175, TextFormatAlign.LEFT, 8, f, true);
		makeText(50, 300, TextFormatAlign.RIGHT, 8, f, true);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 8, f, true);
	}
	
	function demo5():Void
	{
		var f = "Nokia Cellphone FC Small";
		makeText(50, 50, TextFormatAlign.CENTER, 16, f, true);
		makeText(50, 175, TextFormatAlign.LEFT, 16, f, true);
		makeText(50, 300, TextFormatAlign.RIGHT, 16, f, true);
		makeText(50, 425, TextFormatAlign.JUSTIFY, 16, f, true);
	}
	
	function makeText(X:Float, Y:Float, align, size:Int, ?font:String, ?embed:Bool=false)
	{
		var textField = new TextField();
		textField.embedFonts = embed;
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