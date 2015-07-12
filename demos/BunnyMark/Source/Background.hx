package;


import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
#if !html5
import flash.Vector;
#end


class Background extends Sprite {
	
	
	public var cols:Int;
	public var rows:Int;
	public var texture:BitmapData;
	
	#if !html5
	private var indices:Vector<Int>;
	private var uvt:Vector<Float>;
	private var vertices:Vector<Float>;
	#end
	private var _width:Int;
	private var _height:Int;
	
	
	public function new () {
		
		super ();
		
		cols = 1;
		rows = 1;
		
		addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
		
	}
	
	
	private function build ():Void {
		
		#if !html5
		var sw = _width;
		var sh = _height;
		var uw = sw / texture.width;
		var uh = sh / texture.height;
		
		var kx:Float, ky:Float;
		var ci:Int, ci2:Int, ri:Int;
		
		vertices = new Vector<Float> ();
		uvt = new Vector<Float> ();
		indices = new Vector<Int> ();
		
		for (j in 0...(rows + 1)) {
			
			ri = j * (cols + 1) * 2;
			ky = j / rows;
			
			for (i in 0...(cols + 1)) {
				
				ci = ri + i * 2;
				kx = i / cols;
				vertices[ci] = sw * kx; 
				vertices[ci + 1] = sh * ky; 
				uvt[ci] = uw * kx; 
				uvt[ci + 1] = uh * ky;
				
			}
			
		}
		
		for (j in 0...rows) {
			
			ri = j * (cols + 1);
			
			for (i in 0...cols) {
				
				ci = i + ri;
				ci2 = ci + cols + 1;
				indices.push (ci);
				indices.push (ci + 1);
				indices.push (ci2);
				indices.push (ci + 1);
				indices.push (ci2 + 1);
				indices.push (ci2);
				
			}
			
		}
		#end
		
	}
	
	
	private function paint ():Void {
		
		graphics.clear ();
		graphics.beginBitmapFill (texture);
		
		#if !html5
		graphics.drawTriangles (vertices, indices, uvt);
		#else
		graphics.drawRect (0, 0, stage.stageWidth * 1.2, stage.stageHeight * 1.2); // flat
		#end
		
		graphics.endFill ();
		
	}
	
	
	public function setSize (width:Int, height:Int):Void {
		
		_width = width;
		_height = height;
		
		build ();
		
		if (parent != null) paint ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onAddedToStage (event:Event):Void {
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		paint ();
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		#if html5
		return;
		#else
		
		if (_width == 0 || _height == 0) return;
		
		var t = Lib.getTimer () / 1000.0;
		var sw = _width;
		var sh = _height;
		
		var kx:Float, ky:Float;
		var ci:Int, ri:Int;
		
		for (j in 0...(rows + 1)) {
			
			ri = j * (cols + 1) * 2;
			
			for (i in 0...(cols + 1)) {
				
				ci = ri + i * 2;
				kx = i / cols + Math.cos (t + i) * 0.02;
				ky = j / rows + Math.sin (t + j + i) * 0.02;
				vertices[ci] = sw * kx; 
				vertices[ci + 1] = sh * ky;
				
			}
			
		}
		
		paint ();
		
		#end
		
	}
	
	
}