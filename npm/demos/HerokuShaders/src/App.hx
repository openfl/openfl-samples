import js.html.webgl.Buffer in GLBuffer;
import js.html.webgl.Program in GLProgram;
import js.html.webgl.RenderingContext in GLRenderContext;
import js.html.webgl.Shader in GLShader;
import js.html.webgl.UniformLocation in GLUniformLocation;
import js.html.Float32Array;
import openfl.display.OpenGLRenderer;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.RenderEvent;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetManifest;
import openfl.utils.ByteArray;
import openfl.Assets;
import openfl.Lib;


class App extends Sprite {
	
	
	private static var glFragmentShaders = [ "6286", "6288.1", "6284.1", "6238", "6223.2", "6175", "6162", "6147.1", "6049", "6043.1", "6022", "5891.5", "5805.18", "5812", "5733", "5454.21", "5492", "5359.8", "5398.8", "4278.1" ];
	private static var maxTime = 7000;
	
	private var currentIndex:Int;
	private var glBackbufferUniform:GLUniformLocation;
	private var glBuffer:GLBuffer;
	private var glCurrentProgram:GLProgram;
	private var glMouseUniform:GLUniformLocation;
	private var glPositionAttribute:Int;
	private var glResolutionUniform:GLUniformLocation;
	private var glSurfaceSizeUniform:GLUniformLocation;
	private var glTimeUniform:GLUniformLocation;
	private var glVertexPosition:Int;
	private var initialized:Bool;
	private var startTime:Int;
	
	
	public function new () {
		
		super ();
		
		glFragmentShaders = randomizeArray (glFragmentShaders);
		currentIndex = 0;
		
		addEventListener (RenderEvent.RENDER_OPENGL, render);
		addEventListener (Event.ENTER_FRAME, enterFrame);
		
	}
	
	
	private function enterFrame (event:Event):Void {
		
		invalidate ();
		
	}
	
	
	private function glCompile (gl:GLRenderContext):Void {
		
		var program = gl.createProgram ();
		var vertex = Assets.getText ("assets/heroku.vert");
		
		var fragment = "precision mediump float;";
		fragment += Assets.getText ("assets/" + glFragmentShaders[currentIndex] + ".frag");
		
		var vs = glCreateShader (gl, vertex, GLRenderContext.VERTEX_SHADER);
		var fs = glCreateShader (gl, fragment, GLRenderContext.FRAGMENT_SHADER);
		
		if (vs == null || fs == null) return;
		
		gl.attachShader (program, vs);
		gl.attachShader (program, fs);
		
		gl.deleteShader (vs);
		gl.deleteShader (fs);
		
		gl.linkProgram (program);
		
		if (gl.getProgramParameter (program, GLRenderContext.LINK_STATUS) == 0) {
			
			trace (gl.getProgramInfoLog (program));
			trace ("VALIDATE_STATUS: " + gl.getProgramParameter (program, GLRenderContext.VALIDATE_STATUS));
			trace ("ERROR: " + gl.getError ());
			return;
			
		}
		
		if (glCurrentProgram != null) {
			
			gl.deleteProgram (glCurrentProgram);
			
		}
		
		glCurrentProgram = program;
		
		glPositionAttribute = gl.getAttribLocation (glCurrentProgram, "surfacePosAttrib");
		gl.enableVertexAttribArray (glPositionAttribute);
		
		glVertexPosition = gl.getAttribLocation (glCurrentProgram, "position");
		gl.enableVertexAttribArray (glVertexPosition);
		
		glTimeUniform = gl.getUniformLocation (program, "time");
		glMouseUniform = gl.getUniformLocation (program, "mouse");
		glResolutionUniform = gl.getUniformLocation (program, "resolution");
		glBackbufferUniform = gl.getUniformLocation (program, "backglBuffer");
		glSurfaceSizeUniform = gl.getUniformLocation (program, "surfaceSize");
		
		startTime = Lib.getTimer ();
		
	}
	
	
	private function glCreateShader (gl:GLRenderContext, source:String, type:Int):GLShader {
		
		var shader = gl.createShader (type);
		gl.shaderSource (shader, source);
		gl.compileShader (shader);
		
		if (gl.getShaderParameter (shader, GLRenderContext.COMPILE_STATUS) == 0) {
			
			trace (gl.getShaderInfoLog (shader));
			return null;
			
		}
		
		return shader;
		
	}
	
	
	private function glInitialize (gl:GLRenderContext):Void {
		
		if (!initialized) {
			
			glBuffer = gl.createBuffer ();
			gl.bindBuffer (GLRenderContext.ARRAY_BUFFER, glBuffer);
			var glBufferArray = new Float32Array ([ -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0 ]);
			gl.bufferData (GLRenderContext.ARRAY_BUFFER, glBufferArray, GLRenderContext.STATIC_DRAW);
			gl.bindBuffer (GLRenderContext.ARRAY_BUFFER, null);
			
			glCompile (gl);
			
			initialized = true;
			
		}
		
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
	
	
	private function render (event:RenderEvent):Void {
		
		var renderer:OpenGLRenderer = cast event.renderer;
		var gl = renderer.gl;
		
		glInitialize (gl);
		
		if (glCurrentProgram == null) return;
		
		var time = Lib.getTimer () - startTime;
		
		gl.useProgram (glCurrentProgram);
		
		gl.uniform1f (glTimeUniform, time / 1000);
		gl.uniform2f (glMouseUniform, 0.1, 0.1); //gl.uniform2f (glMouseUniform, (stage.mouseX / stage.stageWidth) * 2 - 1, (stage.mouseY / stage.stageHeight) * 2 - 1);
		gl.uniform2f (glResolutionUniform, stage.stageWidth, stage.stageHeight);
		gl.uniform1i (glBackbufferUniform, 0 );
		gl.uniform2f (glSurfaceSizeUniform, stage.stageWidth, stage.stageHeight);
		
		gl.bindBuffer (GLRenderContext.ARRAY_BUFFER, glBuffer);
		gl.vertexAttribPointer (glPositionAttribute, 2, GLRenderContext.FLOAT, false, 0, 0);
		gl.vertexAttribPointer (glVertexPosition, 2, GLRenderContext.FLOAT, false, 0, 0);
		
		gl.clearColor (0, 0, 0, 1);
		gl.clear (GLRenderContext.COLOR_BUFFER_BIT | GLRenderContext.DEPTH_BUFFER_BIT );
		gl.drawArrays (GLRenderContext.TRIANGLES, 0, 6);
		gl.bindBuffer (GLRenderContext.ARRAY_BUFFER, null);
		
		if (time > maxTime && glFragmentShaders.length > 1) {
			
			currentIndex++;
			
			if (currentIndex > glFragmentShaders.length - 1) {
				
				currentIndex = 0;
				
			}
			
			glCompile (gl);
			
		}
		
	}
	
	
	static function main () {
		
		var manifest = new AssetManifest ();
		manifest.addText ("assets/heroku.vert");
		
		for (shader in glFragmentShaders) {
			
			manifest.addText ("assets/" + shader + ".frag");
			
		}
		
		AssetLibrary.loadFromManifest (manifest).onComplete (function (library) {
			
			Assets.registerLibrary ("default", library);
			
			var stage = new Stage (550, 400, 0xFFFFFF, App);
			js.Browser.document.body.appendChild (stage.element);
			
		}).onError (function (e) {
			
			trace (e);
			
		});
		
	}
	
	
}