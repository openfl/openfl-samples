import js.html.webgl.Buffer;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Texture;
import js.html.webgl.UniformLocation;
import js.html.Float32Array;
import js.html.ImageElement;
import js.Browser;
import openfl.display.BitmapData;
import openfl.display.CanvasRenderer;
import openfl.display.DisplayObjectShader;
import openfl.display.DOMRenderer;
import openfl.display.OpenGLRenderer;
import openfl.display.Shader;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.RenderEvent;
import openfl.geom.Matrix;
import openfl.utils.Assets;


class App extends Sprite {
	
	
	private var bitmapData:BitmapData;
	private var domImage:ImageElement;
	private var glBuffer:Buffer;
	private var glMatrixUniform:UniformLocation;
	private var glProgram:Program;
	private var glShader:Shader;
	private var glTexture:Texture;
	private var glTextureAttribute:Int;
	private var glVertexAttribute:Int;
	
	
	public function new () {
		
		super ();
		
		BitmapData.loadFromFile ("assets/openfl.png").onComplete (function (bitmapData) {
			
			this.bitmapData = bitmapData;
			
			addEventListener (RenderEvent.CLEAR_DOM, clearDOM);
			addEventListener (RenderEvent.RENDER_CANVAS, renderCanvas);
			addEventListener (RenderEvent.RENDER_DOM, renderDOM);
			addEventListener (RenderEvent.RENDER_OPENGL, renderOpenGL);
			
			invalidate ();
			
		}).onError (function (e) {
			
			trace (e);
			
		});
		
		x = 100;
		y = 100;
		rotation = 6;
		
	}
	
	
	private function clearDOM (event:RenderEvent):Void {
		
		var renderer:DOMRenderer = cast event.renderer;
		renderer.clearStyle (domImage);
		
	}
	
	
	private function renderCanvas (event:RenderEvent):Void {
		
		var renderer:CanvasRenderer = cast event.renderer;
		var context = renderer.context;
		var transform = event.objectMatrix;
		
		context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		context.drawImage (bitmapData.image.src, 0, 0, bitmapData.width, bitmapData.height);
		
	}
	
	
	private function renderDOM (event:RenderEvent):Void {
		
		var renderer:DOMRenderer = cast event.renderer;
		
		if (domImage == null) {
			
			domImage = cast Browser.document.createElement ("img");
			domImage.src = "assets/openfl.png";
			
		}
		
		renderer.applyStyle (this, domImage);
		
	}
	
	
	private function renderOpenGL (event:RenderEvent):Void {
		
		var renderer:OpenGLRenderer = cast event.renderer;
		var gl = renderer.gl;
		
		if (glShader == null) {
			
			glShader = new DisplayObjectShader ();
			
		}
		
		renderer.setShader (glShader);
		renderer.applyAlpha (1.0);
		renderer.applyColorTransform (event.objectColorTransform);
		renderer.applyBitmapData (bitmapData, event.allowSmoothing);
		renderer.applyMatrix (renderer.getMatrix (event.objectMatrix));
		renderer.updateShader ();
		
		if (glBuffer == null) {
			
			var data:Array<Float> = [
				
				bitmapData.width, bitmapData.height, 0, 1, 1,
				0, bitmapData.height, 0, 0, 1,
				bitmapData.width, 0, 0, 1, 0,
				0, 0, 0, 0, 0
				
			];
			
			glBuffer = gl.createBuffer ();
			gl.bindBuffer (RenderingContext.ARRAY_BUFFER, glBuffer);
			gl.bufferData (RenderingContext.ARRAY_BUFFER, new Float32Array (data), RenderingContext.STATIC_DRAW);
			
		} else {
			
			gl.bindBuffer (RenderingContext.ARRAY_BUFFER, glBuffer);
			
		}
		
		gl.vertexAttribPointer (glShader.data.openfl_Position.index, 3, RenderingContext.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (glShader.data.openfl_TextureCoord.index, 2, RenderingContext.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (RenderingContext.TRIANGLE_STRIP, 0, 4);
		gl.bindBuffer (RenderingContext.ARRAY_BUFFER, null);
		
	}
	
	
	static function main () {
		
		// var stage = new Stage (700, 500, 0xFFFFFF, App, { renderer: "canvas" });
		// var stage = new Stage (700, 500, 0xFFFFFF, App, { renderer: "dom" });
		var stage = new Stage (700, 500, 0xFFFFFF, App);
		js.Browser.document.body.appendChild (stage.element);
		
	}
	
	
}