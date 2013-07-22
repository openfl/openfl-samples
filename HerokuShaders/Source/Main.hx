package;


import flash.display.Sprite;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.Lib;
import openfl.display.OpenGLView;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.Assets;


class Main extends Sprite {
	
	
	private static var fragmentShaders = [ #if mobile "6284.1", "6238", "6147.1", "5891.5", "5805.18", "5492", "5398.8" #else "6286", "6288.1", "6284.1", "6238", "6223.2", "6175", "6162", "6147.1", "6049", "6043.1", "6022", "5891.5", "5805.18", "5812", "5733", "5454.21", "5492", "5359.8", "5398.8", "4278.1" #end ];
	private static var maxTime = 7000;
	
	private var backbufferUniform:GLUniformLocation;
	private var buffer:GLBuffer;
	private var currentIndex:Int;
	private var currentProgram:GLProgram;
	private var mouseUniform:GLUniformLocation;
	private var positionAttribute:Int;
	private var resolutionUniform:GLUniformLocation;
	private var startTime:Int;
	private var surfaceSizeUniform:GLUniformLocation;
	private var timeUniform:GLUniformLocation;
	private var vertexPosition:Int;
	private var view:OpenGLView;
	
	
	public function new () {
		
		super ();
		
		if (OpenGLView.isSupported) {
			
			view = new OpenGLView ();
			
			fragmentShaders = randomizeArray (fragmentShaders);
			currentIndex = 0;
			
			buffer = GL.createBuffer ();
			GL.bindBuffer (GL.ARRAY_BUFFER, buffer);
			GL.bufferData (GL.ARRAY_BUFFER, new Float32Array ([ -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0 ]), GL.STATIC_DRAW);
			GL.bindBuffer (GL.ARRAY_BUFFER, null);
			
			compile ();
			
			view.render = renderView;
			addChild (view);
			
		}
		
	}
	
	
	private function compile ():Void {
		
		var program = GL.createProgram ();
		var vertex = Assets.getText ("assets/heroku.vert");
		
		#if desktop
		var fragment = "";
		#else
		var fragment = "precision mediump float;";
		#end
		
		fragment += Assets.getText ("assets/" + fragmentShaders[currentIndex] + ".frag");
		
		var vs = createShader (vertex, GL.VERTEX_SHADER);
		var fs = createShader (fragment, GL.FRAGMENT_SHADER);
		
		if (vs == null || fs == null) return;
		
		GL.attachShader (program, vs);
		GL.attachShader (program, fs);
		
		GL.deleteShader (vs);
		GL.deleteShader (fs);
		
		GL.linkProgram (program);
		
		if (GL.getProgramParameter (program, GL.LINK_STATUS) == 0) {
			
			trace (GL.getProgramInfoLog (program));
			trace ("VALIDATE_STATUS: " + GL.getProgramParameter (program, GL.VALIDATE_STATUS));
			trace ("ERROR: " + GL.getError ());
			return;
			
		}
		
		if (currentProgram != null) {
			
			GL.deleteProgram (currentProgram);
			
		}
		
		currentProgram = program;
		
		positionAttribute = GL.getAttribLocation (currentProgram, "surfacePosAttrib");
		GL.enableVertexAttribArray (positionAttribute);
		
		vertexPosition = GL.getAttribLocation (currentProgram, "position");
		GL.enableVertexAttribArray (vertexPosition);
		
		timeUniform = GL.getUniformLocation (program, "time");
		mouseUniform = GL.getUniformLocation (program, "mouse");
		resolutionUniform = GL.getUniformLocation (program, "resolution");
		backbufferUniform = GL.getUniformLocation (program, "backbuffer");
		surfaceSizeUniform = GL.getUniformLocation (program, "surfaceSize");
		
		startTime = Lib.getTimer ();
		
	}
	
	
	private function createShader (source:String, type:Int):GLShader {
		
		var shader = GL.createShader (type);
		GL.shaderSource (shader, source);
		GL.compileShader (shader);
		
		if (GL.getShaderParameter (shader, GL.COMPILE_STATUS) == 0) {
			
			trace (GL.getShaderInfoLog (shader));
			return null;
			
		}
		
		return shader;
		
	}
	
	
	private function randomizeArray<T> (array:Array<T>):Array<T> {
		
		var arrayCopy = array.copy ();
		var randomArray = new Array<T> ();
		
		while (arrayCopy.length > 0) {
			
			var randomIndex = Math.round (Math.random () * (arrayCopy.length - 1));
			randomArray.push (arrayCopy.splice (randomIndex, 1)[0]);
			
		}
		
		return randomArray;
		
	}
	
	
	private function renderView (rect:Rectangle):Void {
		
		GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
		
		if (currentProgram == null) return;
		
		var time = Lib.getTimer () - startTime;
		
		GL.useProgram (currentProgram);
		
		GL.uniform1f (timeUniform, time / 1000);
		GL.uniform2f (mouseUniform, 0.1, 0.1); //GL.uniform2f (mouseUniform, (stage.mouseX / stage.stageWidth) * 2 - 1, (stage.mouseY / stage.stageHeight) * 2 - 1);
		GL.uniform2f (resolutionUniform, rect.width, rect.height);
		GL.uniform1i (backbufferUniform, 0 );
		GL.uniform2f (surfaceSizeUniform, rect.width, rect.height);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer (positionAttribute, 2, GL.FLOAT, false, 0, 0);
		GL.vertexAttribPointer (vertexPosition, 2, GL.FLOAT, false, 0, 0);
		
		GL.clearColor (0, 0, 0, 1);
		GL.clear (GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
		GL.drawArrays (GL.TRIANGLES, 0, 6);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		
		if (time > maxTime && fragmentShaders.length > 1) {
			
			currentIndex++;
			
			if (currentIndex > fragmentShaders.length - 1) {
				
				currentIndex = 0;
				
			}
			
			compile ();
			
		}
		
	}
	
	
}