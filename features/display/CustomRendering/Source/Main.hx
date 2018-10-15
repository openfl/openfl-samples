package;


import lime.graphics.cairo.*;
import lime.graphics.opengl.*;
import lime.math.Matrix3;
import lime.utils.Float32Array;
import openfl.display.BitmapData;
import openfl.display.CairoRenderer;
import openfl.display.CanvasRenderer;
import openfl.display.DOMRenderer;
import openfl.display.OpenGLRenderer;
import openfl.display.Sprite;
import openfl.events.RenderEvent;
import openfl.geom.Matrix;
import openfl.utils.Assets;

#if (js && html5)
import js.html.Image;
#end

#if (lime >= "7.0.0")
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.opengl.WebGLContext in WebGLRenderContext;
#end


class Main extends Sprite {
	
	
	private var bitmapData:BitmapData;
	private var cairoMatrix:Matrix3;
	private var cairoPattern:CairoPattern;
	private var cairoSurface:CairoSurface;
	private var glBuffer:GLBuffer;
	private var glMatrixUniform:GLUniformLocation;
	private var glProgram:GLProgram;
	private var glTexture:GLTexture;
	private var glTextureAttribute:Int;
	private var glVertexAttribute:Int;
	
	#if (js && html5)
	private var domImage:Image;
	#end
	
	
	public function new () {
		
		super ();
		
		bitmapData = Assets.getBitmapData ("assets/openfl.png");
		
		addEventListener (RenderEvent.CLEAR_DOM, clearDOM);
		addEventListener (RenderEvent.RENDER_CAIRO, renderCairo);
		addEventListener (RenderEvent.RENDER_CANVAS, renderCanvas);
		addEventListener (RenderEvent.RENDER_DOM, renderDOM);
		addEventListener (RenderEvent.RENDER_OPENGL, renderOpenGL);
		
		x = 100;
		y = 100;
		rotation = 6;
		
	}
	
	
	private function clearDOM (event:RenderEvent):Void {
		
		#if (js && html5)
		var renderer:DOMRenderer = cast event.renderer;
		renderer.clearStyle (domImage);
		#end
		
	}
	
	
	private function renderCairo (event:RenderEvent):Void {
		
		#if !flash
		
		if (cairoPattern == null) {
			
			var surface = bitmapData.getSurface ();
			cairoPattern = CairoPattern.createForSurface (surface);
			
			if (event.allowSmoothing) {
				
				cairoPattern.filter = CairoFilter.GOOD;
				
			} else {
				
				cairoPattern.filter = CairoFilter.NEAREST;
				
			}
			
		}
		
		var renderer:CairoRenderer = cast event.renderer;
		var cairo = renderer.cairo;
		
		renderer.applyMatrix (event.objectMatrix, cairo);
		
		cairo.source = cairoPattern;
		cairo.paint ();
		
		#end
		
	}
	
	
	private function renderCanvas (event:RenderEvent):Void {
		
		var renderer:CanvasRenderer = cast event.renderer;
		var context = renderer.context;
		var transform = event.objectMatrix;
		
		context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		context.drawImage (bitmapData.image.src, 0, 0, bitmapData.width, bitmapData.height);
		
	}
	
	
	private function renderDOM (event:RenderEvent):Void {
		
		#if (js && html5)
		var renderer:DOMRenderer = cast event.renderer;
		
		if (domImage == null) {
			
			domImage = new Image ();
			domImage.src = Assets.getPath ("assets/openfl.png");
			
		}
		
		renderer.applyStyle (this, domImage);
		#end
		
	}
	
	
	private function renderOpenGL (event:RenderEvent):Void {
		
		var renderer:OpenGLRenderer = cast event.renderer;
		var gl:WebGLRenderContext = renderer.gl;
		
		if (glProgram == null) {
			
			var vertexSource = 
				
				"attribute vec4 aPosition;
				attribute vec2 aTexCoord;
				varying vec2 vTexCoord;
				
				uniform mat4 uMatrix;
				
				void main(void) {
					
					vTexCoord = aTexCoord;
					gl_Position = uMatrix * aPosition;
					
				}";
			
			var fragmentSource = 
				
				#if !desktop
				"precision mediump float;" +
				#end
				"varying vec2 vTexCoord;
				uniform sampler2D uImage0;
				
				void main(void)
				{
					gl_FragColor = texture2D (uImage0, vTexCoord);
				}";
			
			glProgram = #if (lime >= "7.0.0") GLProgram.fromSources (gl, vertexSource, fragmentSource); #else lime.utils.GLUtils.createProgram (vertexSource, fragmentSource); #end
			gl.useProgram (glProgram);
			
			glVertexAttribute = gl.getAttribLocation (glProgram, "aPosition");
			glTextureAttribute = gl.getAttribLocation (glProgram, "aTexCoord");
			glMatrixUniform = gl.getUniformLocation (glProgram, "uMatrix");
			var imageUniform = gl.getUniformLocation (glProgram, "uImage0");
			
			gl.enableVertexAttribArray (glVertexAttribute);
			gl.enableVertexAttribArray (glTextureAttribute);
			gl.uniform1i (imageUniform, 0);
			
			var data = [
				
				bitmapData.width, bitmapData.height, 0, 1, 1,
				0, bitmapData.height, 0, 0, 1,
				bitmapData.width, 0, 0, 1, 0,
				0, 0, 0, 0, 0
				
			];
			
			glBuffer = gl.createBuffer ();
			gl.bindBuffer (gl.ARRAY_BUFFER, glBuffer);
			gl.bufferData (gl.ARRAY_BUFFER, new Float32Array (data), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
			// TODO
			#if !flash
			glTexture = @:privateAccess bitmapData.getTexture (@:privateAccess renderer.__context3D).__textureID;
			#end
			
		} else {
			
			gl.useProgram (glProgram);
			
			gl.enableVertexAttribArray (glVertexAttribute);
			gl.enableVertexAttribArray (glTextureAttribute);
			
		}
		
		var matrix = renderer.getMatrix (event.objectMatrix);
		gl.uniformMatrix4fv (glMatrixUniform, false, matrix);
		
		gl.activeTexture (gl.TEXTURE0);
		gl.bindTexture (gl.TEXTURE_2D, glTexture);
		
		#if desktop
		gl.enable (gl.TEXTURE_2D);
		#end
		
		if (event.allowSmoothing) {
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			
		} else {
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			
		}
		
		gl.bindBuffer (gl.ARRAY_BUFFER, glBuffer);
		gl.vertexAttribPointer (glVertexAttribute, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (glTextureAttribute, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end
		
		gl.disableVertexAttribArray (glVertexAttribute);
		gl.disableVertexAttribArray (glTextureAttribute);
		gl.useProgram (null);
		
	}
	
	
}