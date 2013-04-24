package;


import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.Program3D;
import flash.display3D.VertexBuffer3D;
import flash.display.Sprite;
import flash.display.Stage3D;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.geom.Matrix3D;
import flash.Vector;
import pazu.display3D.Shader3D;


class Main extends Sprite {
	
	
	private var context3D:Context3D;
	private var fragmentShader:Shader3D;
	private var indexBuffer:IndexBuffer3D;
	private var shaderProgram:Program3D;
	private var stage3D:Stage3D;
	private var vertexBuffer:VertexBuffer3D;
	private var vertexShader:Shader3D;
	
	
	public function new () {
		
		super ();
		
		stage3D = stage.stage3Ds[0];
		stage3D.addEventListener (Event.CONTEXT3D_CREATE, stage3D_onContext3DCreate);
		stage3D.addEventListener (ErrorEvent.ERROR, stage3D_onError);
		stage3D.requestContext3D ();
		
	}
	
	
	private function construct ():Void {
		
		context3D.configureBackBuffer (stage.stageWidth, stage.stageHeight, 0, false);
		context3D.enableErrorChecking = true;
		
		createProgram ();
		
		var vertices:Array<Float> = [
			
			100, 100, 0,
			-100, 100, 0,
			100, -100, 0,
			-100, -100, 0
			
		];
		
		vertexBuffer = context3D.createVertexBuffer (4, 3);
		vertexBuffer.uploadFromVector (Vector.ofArray (vertices), 0, 4);
		
		var indices:Array<UInt> = [ 0, 1, 2, 2, 3, 1 ];
		
		indexBuffer = context3D.createIndexBuffer (6);
		indexBuffer.uploadFromVector (Vector.ofArray (indices), 0, 6);
		
		#if flash
		addEventListener (Event.ENTER_FRAME, renderView);
		#else
		context3D.setRenderMethod (renderView);
		#end
		
	}
	
	
	private function create2D (x:Float, y:Float, scale:Float = 1, rotation:Float = 0):Matrix3D {
		
		#if flash
		
		var theta = rotation * Math.PI / 180.0;
		var c = Math.cos (theta);
		var s = Math.sin (theta);
		
		return new Matrix3D (Vector.ofArray ([
			c*scale,  -s*scale, 0,  0,
			s*scale,  c*scale, 0,  0,
			0,		0,		1,  0,
			x,		y,		0,  1
		]));
		
		#else
		
		return Matrix3D.create2D (x, y, scale, rotation);
		
		#end
		
	}
	
	
	public static function createOrtho (x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float):Matrix3D {
		
		#if flash
		
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);
		
		return new Matrix3D (Vector.ofArray ([
			2.0*sx,	   0,		  0,				 0,
			0,			2.0*sy,	 0,				 0,
			0,			0,		  -2.0*sz,		   0,
			- (x0+x1)*sx, - (y0+y1)*sy, - (zNear+zFar)*sz,  1,
		]));
		
		#else
		
		return Matrix3D.createOrtho (x0, x1, y0, y1, zNear, zFar);
		
		#end
		
	}
	
	
	private function createProgram ():Void {
		
		shaderProgram = context3D.createProgram ();
		
		var vertexShaderSource =
			
			"attribute vec3 vertexPosition;
			uniform mat4 mvpMatrix;
			
			void main(void) {
				gl_Position = mvpMatrix * vec4(vertexPosition, 1.0);
			}";
		
		vertexShader = new Shader3D (vertexShaderSource, Context3DProgramType.VERTEX);
		
		var fragmentShaderSource =
			
			"void main(void) {
				gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
			}";
		
		fragmentShader = new Shader3D (fragmentShaderSource, Context3DProgramType.FRAGMENT);
		
		shaderProgram.upload (vertexShader, fragmentShader);
		
	}
	
	
	private function renderView (_):Void {
		
		var positionX = stage.stageWidth / 2;
		var positionY = stage.stageHeight / 2;
		
		var projectionMatrix = createOrtho (0, stage.stageWidth, stage.stageHeight, 0, 1000, -1000);
		var modelViewMatrix = create2D (positionX, positionY, 1, 0);
		
		var mvpMatrix = modelViewMatrix.clone ();
		mvpMatrix.append (projectionMatrix);
		
		context3D.setProgram (shaderProgram);
		
		#if flash
		
		vertexShader.setAGALConstants (context3D);
		fragmentShader.setAGALConstants (context3D);
		
		context3D.setProgramConstantsFromMatrix (Context3DProgramType.VERTEX, vertexShader.getAGALRegisterIndex ("mvpMatrix"), mvpMatrix, true);
		context3D.setVertexBufferAt (vertexShader.getAGALRegisterIndex ("vertexPosition"), vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		
		#else
		
		context3D.setGLSLProgramConstantsFromMatrix ("mvpMatrix", mvpMatrix, true);
		context3D.setGLSLVertexBufferAt ("vertexPosition", vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		
		#end
		
		context3D.clear (0, 0, 0, 1.0);
		context3D.drawTriangles (indexBuffer);
		context3D.present ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage3D_onContext3DCreate (event:Event):Void {
		
		context3D = stage3D.context3D;
		
		construct ();
		
	}
	
	
	private function stage3D_onError (event:ErrorEvent):Void {
		
		trace (event);
		
	}


}