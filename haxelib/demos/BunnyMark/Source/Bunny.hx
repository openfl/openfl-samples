package;


import openfl.display.Tile;


#if (flash || use_tilemap)


class Bunny extends Tile {
	
	
	public var speedX:Float;
	public var speedY:Float;
	
	
	public function new () {
		
		super (0);
		
	}
	
	
}


#else


class Bunny {
	
	
	public var id:Int;
	public var speedX:Float;
	public var speedY:Float;
	public var x:Float;
	public var y:Float;
	
	
	public function new () {
		
		id = 0;
		
	}
	
	
}


#end