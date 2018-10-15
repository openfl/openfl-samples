package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import openfl.Lib;

class Main extends Sprite {
	
	private var buffer:Int = 64;
	private var gutter:Int = 2;
	private var box:Point;
	private var field:Point;
	private var out:TextField;
	
	public function new () {
		
		super ();
		
		Lib.current.stage.color = 0xA0A0A0;
		
		box = new Point(354, 354);
		field = new Point(box.x - gutter*2, box.y - gutter*2);
		
		var offset = new Point(300, 100);
		
		var font = Assets.getFont("assets/LiberationSerif-Regular.ttf");
		
		var format = new TextFormat(font.fontName, 120, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, 20);
		var textField = new TextField();
		
		textField.defaultTextFormat = format;
		textField.embedFonts = true;
		textField.selectable = false;
		
		textField.border = true;
		textField.borderColor = 0x000000;
		
		textField.x = offset.x;
		textField.y = offset.y;
		textField.autoSize = TextFieldAutoSize.NONE;
		
		textField.multiline = true;
		textField.text = "Wqx\nWqx";
		
		textField.width = field.x;
		textField.height = field.y;
		
		addChild (textField);
		
		var tlm = textField.getLineMetrics(0);
		
		var bmp:Bitmap = new Bitmap(new BitmapData(cast box.x + buffer*2, cast box.y + buffer*2,true,0xFFE0E0E0));
		bmp.x = textField.x - buffer;
		bmp.y = textField.y - buffer; 
		
		addChild(bmp);
		
		out = new TextField();
		out.width = 400;
		out.height = 1000;
		addChild(out);
		
		var white = new Bitmap(new BitmapData(200, 100, false));
		addChild(white);
		white.x = 0;
		white.y = 250;
		
		var text2 = new TextField();
		text2.wordWrap = true;
		text2.width = 200;
		text2.y = 250;
		text2.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
		
		addChild(text2);
		
		traceLineMetrics(textField, out);
		drawLineMetrics(bmp.bitmapData, textField);
	}
	
	private function traceLineMetrics(text:TextField, out:TextField):Void
	{
		var str = "";
		str += ("x/y = " + text.x + " / " + text.y);
		str += "\n" + ("width/height = " + text.width + " / " + text.height);
		str += "\n" + ("textWidth/textHeight = " + text.textWidth + " / " + text.textHeight);
		
		for (i in 0...text.numLines)
		{
			var tlm = text.getLineMetrics(i);
			str += "\n" + ("line("+i+") x = " + tlm.x);
			str += "\n" + ("line("+i+") width = " + tlm.width);
			str += "\n" + ("line("+i+") height = " + tlm.height);
			str += "\n" + ("line("+i+") ascent = " + tlm.ascent);
			str += "\n" + ("line("+i+") descent = " + tlm.descent);
			str += "\n" + ("line("+i+") leading = " + tlm.leading);
		}
		
		out.text = str;
	}
	
	private function drawLineMetrics(bmp:BitmapData, text:TextField):Void
	{
		var tlm = text.getLineMetrics(0);
		
		var rect = new Rectangle();
		
		rect.x = 0;
		rect.y = 0;
		rect.width = bmp.width;
		rect.height = bmp.height;
		
		bmp.fillRect(rect, 0x00FFFFFF);
		
		var green = 0xFF00FF00;
		var red = 0xFFFF0000;
		
		rect.x = buffer;
		rect.height = 1;
		
		//text.width
		
		rect.y = buffer / 2;
		rect.width = text.width;
		bmp.fillRect(rect, green);
		
			//left line
			
			rect.y = 0;
			rect.width = 1;
			rect.height = bmp.height;
			bmp.fillRect(rect, red);
			
			//right line
			
			rect.x = buffer + text.width;
			bmp.fillRect(rect, red);
			
			rect.x = buffer;
			rect.height = 1;
		
		//text.textWidth
		
		rect.x = buffer + gutter + tlm.x;
		rect.y = bmp.height - buffer / 2;
		rect.width = text.textWidth;
		bmp.fillRect(rect, green);
		
			//left line
			
			rect.y = 0;
			rect.width = 1;
			rect.height = bmp.height;
			bmp.fillRect(rect, red);
			
			//right line
			
			rect.x = buffer + gutter + tlm.x + text.textWidth;
			bmp.fillRect(rect, red);
			
			rect.x = buffer + tlm.x;
			rect.height = 1;
			
		//text.height
		
		rect.x = buffer * 1/4;
		rect.y = buffer;
		rect.width = 1;
		rect.height = text.height;
		bmp.fillRect(rect, green);
		
			//top line
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			//bottom line
			rect.y = rect.y+text.height;
			bmp.fillRect(rect, red);
		
			rect.width = 1;
			
		//text.height - gutter
		
		rect.x = buffer * 2 / 4;
		rect.y = buffer + gutter;
		rect.height = text.height - gutter * 2;
		bmp.fillRect(rect, green);
		
			//top line
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			//bottom line
			rect.y = rect.y + text.height - gutter * 2;
			bmp.fillRect(rect, red);
			
			rect.width = 1;
		
		//line height
		
		rect.x = buffer * 3 / 4;
		rect.y = buffer + gutter;
		rect.height = tlm.height;
		bmp.fillRect(rect, green);
		
			//top line
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			//bottom line
			rect.y = rect.y + tlm.height;
			bmp.fillRect(rect, red);
			
			rect.width = 1;
		
		//textHeight
		
		rect.x =  buffer * 1 / 8;
		rect.y = buffer + gutter;
		rect.height = text.textHeight;
		bmp.fillRect(rect, green);
		
			//top line
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			rect.y = rect.y + text.textHeight;
			bmp.fillRect(rect, red);
			
			rect.width = 1;
			
		//ascent
		
		rect.x = bmp.width - (buffer * 3 / 4);
		rect.y = buffer + gutter;
		rect.height = tlm.ascent;
		bmp.fillRect(rect, green);
		
			//top line
			rect.x = buffer * 3 / 4;
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			//bottom line
			rect.y = rect.y + tlm.ascent;
			bmp.fillRect(rect, red);
			
			rect.width = 1;
		
		//descent
		
		rect.x = bmp.width - (buffer * 2 / 4);
		rect.y = buffer + gutter + tlm.ascent;
		rect.height = tlm.descent;
		bmp.fillRect(rect, green);
		
			//top line
			rect.x = buffer * 3 / 4;
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			//bottomline
			rect.y = rect.y + tlm.descent;
			bmp.fillRect(rect, red);
			
			rect.width = 1;
		
		//leading
		
		rect.x = bmp.width - (buffer * 1 / 4);
		rect.y = buffer + gutter + tlm.height;
		rect.height = tlm.leading;
		
		bmp.fillRect(rect, green);
		
			//top line
			rect.x = buffer * 3 / 4;
			rect.width = bmp.width - gutter * 2;
			rect.height = 1;
			bmp.fillRect(rect, red);
			
			//bottom line
			rect.y = rect.y + tlm.leading;
			bmp.fillRect(rect, red);
			
			rect.width = 1;
		
		//margin
		
		rect.x = buffer + gutter + tlm.x + text.textWidth;
		rect.y = bmp.height - gutter - buffer * 2;
		rect.width = text.width - (gutter*2 + tlm.x + text.textWidth);
		
		bmp.fillRect(rect, green);
		
			//left line
			rect.y = buffer * 2;
			rect.height = bmp.height - (buffer * 4);
			rect.width = 1;
			bmp.fillRect(rect, red);
			
			//right line
			rect.x = rect.x + (text.width - (gutter * 2 + tlm.x + text.textWidth));
			bmp.fillRect(rect, red);
			
			rect.height = 1;
	}
	
}
