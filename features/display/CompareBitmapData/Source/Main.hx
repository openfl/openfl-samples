package;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.errors.Error;
import openfl.errors.TypeError;
import openfl.geom.Point;
import openfl.Lib;


class Main extends Sprite {
	
	
	private var size:Int = 0;
	
	public function new () {
		
		super ();
		
		Lib.current.stage.color = 0x808080;
		
		test(32);
		
	}
	
	private function test(size:Int):Void {
		
		this.size = size;
		
		var checkers = (Assets.getBitmapData("assets/"+size+"/checkers.png"));
		var checkers_alpha = (Assets.getBitmapData("assets/"+size+"/checkers_alpha.png"));
		var noise1 = (Assets.getBitmapData("assets/"+size+"/noise1.png"));
		var noise2 = (Assets.getBitmapData("assets/"+size+"/noise2.png"));
		var red_ball = (Assets.getBitmapData("assets/"+size+"/red_ball.png"));
		var red_ball_alpha = (Assets.getBitmapData("assets/"+size+"/red_ball_alpha.png"));
		var red_ball_half_alpha = (Assets.getBitmapData("assets/"+size+"/red_ball_half_alpha.png"));
		var yellow_ball = (Assets.getBitmapData("assets/"+size+"/yellow_ball.png"));
		var rectangle = (Assets.getBitmapData("assets/"+size+"/rectangle.png"));
		var rectangle2 = (Assets.getBitmapData("assets/"+size+"/rectangle2.png"));
		
		var nullBmp = null;
		var disposedBmp = checkers.clone();
		disposedBmp.dispose();
		
		var list = [checkers, checkers_alpha, noise1, noise2, red_ball, red_ball_alpha, red_ball_half_alpha, yellow_ball, rectangle, rectangle2 , nullBmp, disposedBmp];
		
		addColumn(10, checkers.height + 20, list);
		addRow(checkers.width + 20, 10, list);
		
		var xx:Int = 20 + checkers.width;
		var yy:Int = 20 + checkers.height;
		
		for (i in 0...list.length)
		{
			addColumn(xx, yy, compare(list[i], list));
			xx += checkers.width + 10;
		}
		
	}
	
	private function compare(bmp:BitmapData, list:Array<BitmapData>):Array<BitmapData> {
		
		var result:Dynamic = -5;
		var resultBmps = [];
		
		for (other in list) {
			
			if (bmp == null) {
				
				if (other != null) {
					
					try { 
					
						result = other.compare(bmp);
						
					}
					catch (e:Error) {
						
						result = -5;
						
					}
				}
				else {
					
					result = -5;	//error, both are null, no comparison could be done
					
				}
				
			}
			else {
				
				try {
					
					result = bmp.compare(other);
					
				}
				catch (e:Error) {
					
					result = -5;
					
				}
				
			}
			
			if (Std.is(result, BitmapData)) {
				
				resultBmps.push(cast result);
				
			}
			else if (Std.is(result, Int)) {
				
				var i:Int = cast result;
				var bmp = switch(i)
				{
					case -1: Assets.getBitmapData("assets/"+size+"/minus1.png");
					case -2: Assets.getBitmapData("assets/"+size+"/minus2.png");
					case -3: Assets.getBitmapData("assets/"+size+"/minus3.png");
					case -4: Assets.getBitmapData("assets/"+size+"/minus4.png");
					case  0: Assets.getBitmapData("assets/"+size+"/0.png");
					default: Assets.getBitmapData("assets/"+size+"/error.png");
				}
				resultBmps.push(bmp);
			}
			else {
				
				resultBmps.push(Assets.getBitmapData("assets/"+size+"/error.png"));
				
			}
			
		}
		
		return resultBmps;
	}
	
	@:access(openfl.display.BitmapData)
	private function isDisposed(bmp:BitmapData):Bool
	{
		if (bmp == null) return false;
		var isDisposed = false;
		#if flash
		try {
			
			bmp.getPixel(0, 0);
			
		}
		catch (d:Dynamic) {
			
			isDisposed = true;
			
		}
		#else
		isDisposed = bmp.__isValid == false;
		#end
		return isDisposed;
	}
	
	private function getBmp(bmp:BitmapData):BitmapData
	{
		if (bmp == null) return Assets.getBitmapData("assets/"+size+"/null.png");
		if (isDisposed(bmp)) return Assets.getBitmapData("assets/"+size+"/disposed.png");
		return (bmp);
	}
	
	private function addColumn(xx:Int, yy:Int, list:Array<BitmapData>)
	{
		for (bmp in list)
		{
			var b:Bitmap = new Bitmap(getBmp(bmp));
			b.x = xx;
			b.y = yy;
			yy += Std.int(list[0].height + 10);
			addChild(b);
		}
	}
	
	private function addRow(xx:Int, yy:Int, list:Array<BitmapData>)
	{
		for (bmp in list)
		{
			var b:Bitmap = new Bitmap(getBmp(bmp));
			b.x = xx;
			b.y = yy;
			xx += Std.int(list[0].width + 10);
			addChild(b);
		}
	}
}