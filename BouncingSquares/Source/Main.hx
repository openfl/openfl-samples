package;

import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;


class Main extends Sprite {

	private var _stageW:Int;
	private var _stageH:Int;
	private var _squares:Array<BouncingSquare>;	//holder of our squares
	private var _amount:Int = 100;	//amount of squars to generate and display.
	
	public function new() {

		super();
		
		haxe.Timer.delay( init, 100 );	//wait for 100 milliseconds before init

	}

	private function init():Void {
	
		this.mouseEnabled = false;
        	this.mouseChildren = false;

		//gather stage dimensions to work with
		_stageW = Lib.current.stage.stageWidth;
		_stageH = Lib.current.stage.stageHeight;
		
		_squares = [];	//init squares holder
		
		//prepare boucing squares
		for ( i in 0..._amount ) {
			var n:BouncingSquare = new BouncingSquare( randomNumber( 200, _stageW-200 ), randomNumber( 200, _stageH-200 ),randomNumber( 1, 10 )*( randomNumber( 0, 1 ) > 0 ?1:-1), randomNumber( 1, 10 ) * ( randomNumber( 0, 1 ) > 0?1:-1 ), randomNumber( 0, 0xffffff ) );
			addChild( n );
			_squares.push( n );
		}

		//add onEnterFrame listener
		Lib.current.stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );		
	}
	
	private function onEnterFrame( e:Event ):Void {
		//handle move logic, loop through every square and move them
		for ( i in 0..._amount ) {
			var n:BouncingSquare = _squares[i];
			if ( n.x < 0 || n.x + n.width > _stageW ) n.sx *= -1; //constraint horizontal translation
			if ( n.y < 0 || n.y + n.height > _stageH ) n.sy *= -1; //constraint vertical translation
			n.x += n.sx;
			n.y += n.sy;
		}
	}

	private function randomNumber( low:Int, high:Int ):Int {
		//return a random integer
		return Math.round( Math.random() * ( high - low ) + low );
	}

}

class BouncingSquare extends Sprite {
	
	public var sx:Int;	//horizontal translation
	public var sy:Int;	//vertical translation
	public var col:Int;	//color
	
	public function new ( _x:Int, _y:Int, _sx:Int, _sy:Int, _col:Int ) {
    	
    		super();
    	
    		x = _x;		//as BouncingSquare extends Sprite, x is already a defined Sprite property... 
    		y = _y;		//and y as well.
    		sx = _sx;
    		sy = _sy;
    		col = _col;
    	
    		init();
    	}
    	
    	private function init():Void {
    		this.addChild( new Bitmap( new BitmapData(10, 10, false, col) ) );
    		this.mouseEnabled = false;
    		this.mouseChildren = false;
    	}

}
