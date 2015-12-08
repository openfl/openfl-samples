package;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author larsiusprime
 */
class GamepadControlVisual extends Sprite
{

	public var type:String;
	public var id:Int = 0;
	public var value(default, set):Float = 0;
	public var label:String = "";
	
	public function new(size:Int, type_:String,id_:Int,label_:String) 
	{
		super();
		
		type = type_;
		id = id_;
		label = label_;
		
		switch(type)
		{
			case "button": make(size, 0xFF00FF00);
			case "axis"  : make(size, 0xFF00FFFF);
			case "hat"   : make(size, 0xFFFF00FF);
			case "ball"  : make(size, 0xFFFFFF00);
		}
		
		value = 0;
	}
	
	private function set_value(f:Float):Float
	{
		value = f;
		
		if (valTxt != null) valTxt.text = pretty(f);
		
		var v = Math.abs(f);
		if (v > 1) v = 1;
		if (v < 0) v = 0;
		
		if (bmp != null) bmp.alpha = (v * 0.75) + 0.25;
		if (invBmp != null) invBmp.alpha = (v * 0.75) + 0.25;
		
		bmp.visible    = (f >= 0);
		invBmp.visible = (f < 0);
		
		return f;
	}
	
	private function pretty(f:Float):String
	{
		var s = Std.string(Std.int(f*100)/100);
		if (f > 0) s = " " + s;
		return s;
		
	}
	
	private var invBmp:Bitmap;
	private var bmp:Bitmap;
	private var valTxt:TextField;
	
	private function make(size:Int, color:Int):Void
	{
		bmp = new Bitmap(new BitmapData(1, 1, true, color));
		bmp.width = size;
		bmp.height = size;
		
		var col = 0x00FFFFFF & color;
		var r = (0xFF0000 & col) >> 16;
		var g = (0x00FF00 & col) >>  8;
		var b = (0x0000FF & col);
		
		var ri = 0xFF - r;
		var gi = 0xFF - g;
		var bi = 0xFF - b;
		
		var icol = 0xFF000000 | ri << 16 | gi << 8 | bi;
		
		invBmp = new Bitmap(new BitmapData(1, 1, true, icol));
		invBmp.width = size;
		invBmp.height = size;
		
		var txt = new TextField();
		txt.width = bmp.width;
		txt.height = bmp.height;
		txt.text = label;
		
		valTxt = new TextField();
		valTxt.width = bmp.width;
		txt.height = bmp.height;
		valTxt.text = "?";
		
		addChild(bmp);
		addChild(invBmp);
		addChild(txt);
		addChild(valTxt);
		
		valTxt.y = txt.y + txt.textHeight;
		invBmp.visible = false;
	}
	
}