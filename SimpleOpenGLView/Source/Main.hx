package;


import flash.display.Sprite;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import openfl.display.OpenGLView;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLTexture;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;
import openfl.Assets;


class Main extends Sprite {
	
	
	private var imageUniform:Int;
	private var modelViewMatrixUniform:Int;
	private var projectionMatrixUniform:Int;
	private var shaderProgram:GLProgram;
	private var texCoordAttribute:Int;
	private var texCoordBuffer:GLBuffer;
	private var texture:GLTexture;
	private var view:OpenGLView;
	private var vertexAttribute:Int;
	private var vertexBuffer:GLBuffer;
	
	
	public function new () {
		
		super ();
		
		if (OpenGLView.isSupported) {
			
			view = new OpenGLView ();
			
			initializeShaders ();
			
			createBuffers ();
			createTexture ();
			
			view.render = renderView;
			addChild (view);
			
		}
		
	}
	
	
	private function createBuffers ():Void {
		
		var vertices = [
			
			200, 200, 0,
			-200, 200, 0,
			200, -200, 0,
			-200, -200, 0
			
		];
		
		vertexBuffer = GL.createBuffer ();
		GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast vertices), GL.STATIC_DRAW);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		
		var texCoords = [
			
			1, 1, 
			0, 1, 
			1, 0, 
			0, 0, 
			
		];
		
		texCoordBuffer = GL.createBuffer ();
		GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);	
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast texCoords), GL.STATIC_DRAW);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		
	}
	
	
	private function createTexture ():Void {
		
		texture = GL.createTexture ();
		var bitmapData = Assets.getBitmapData ("assets/openfl.png");
		GL.bindTexture (GL.TEXTURE_2D, texture);
		GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, new UInt8Array(bitmapData.getPixels (bitmapData.rect)));
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
	private function initializeShaders ():Void {
		
		var vertexShaderSource = 
			
			"attribute vec3 aVertexPosition;
			attribute vec2 aTexCoord;
			varying vec2 vTexCoord;
			
			uniform mat4 uModelViewMatrix;
			uniform mat4 uProjectionMatrix;
			
			void main(void) {
				vTexCoord = aTexCoord;
				gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
			}";
		
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (vertexShader, vertexShaderSource);
		GL.compileShader (vertexShader);
		
		if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
			
			throw "Error compiling vertex shader";
			
		}
		
		var fragmentShaderSource = 
			
			"varying vec2 vTexCoord;
			uniform sampler2D uImage0;
			
			void main(void)
			{
				gl_FragColor = texture2D (uImage0, vTexCoord).gbar;
			}";
		
		var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
		GL.shaderSource (fragmentShader, fragmentShaderSource);
		GL.compileShader (fragmentShader);
		
		if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
			
			throw "Error compiling fragment shader";
			
		}
		
		shaderProgram = GL.createProgram ();
		GL.attachShader (shaderProgram, vertexShader);
		GL.attachShader (shaderProgram, fragmentShader);
		GL.linkProgram (shaderProgram);
		
		if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {
			
			throw "Unable to initialize the shader program.";
			
		}
		
		vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
		texCoordAttribute = GL.getAttribLocation (shaderProgram, "aTexCoord");
		projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
		modelViewMatrixUniform = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");
		imageUniform = GL.getUniformLocation (shaderProgram, "uImage0");
		
		GL.enableVertexAttribArray (vertexAttribute);
		GL.enableVertexAttribArray (texCoordAttribute);
		
	}
	
	
	
	private function renderView (rect:Rectangle):Void {
		
		GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
		
		GL.clearColor (1.0, 1.0, 1.0, 1.0);
		GL.clear (GL.COLOR_BUFFER_BIT);
		
		var positionX = rect.width / 2;
		var positionY = rect.height / 2;
		var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 1000, -1000);
		var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
		
		GL.useProgram (shaderProgram);
		
		GL.activeTexture (GL.TEXTURE0);
		GL.bindTexture (GL.TEXTURE_2D, texture);
		GL.enable (GL.TEXTURE_2D);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
		GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 0, 0);
		GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
		GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
		
		GL.uniformMatrix3D (projectionMatrixUniform, false, projectionMatrix);
		GL.uniformMatrix3D (modelViewMatrixUniform, false, modelViewMatrix);
		GL.uniform1i (imageUniform, 0);
		
		GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		GL.disable (GL.TEXTURE_2D);
		GL.bindTexture (GL.TEXTURE_2D, null);
		GL.activeTexture (null);
		GL.useProgram (null);
		
	}
	
	
}