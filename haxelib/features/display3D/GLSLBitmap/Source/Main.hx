package;


import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Matrix3D;
import openfl.utils.Assets;
import openfl.Vector;


class Main extends Sprite {
	
	
	private var bitmapIndexBuffer:IndexBuffer3D;
	private var bitmapRenderTransform:Matrix3D;
	private var bitmapTexture:RectangleTexture;
	private var bitmapTransform:Matrix3D;
	private var bitmapVertexBuffer:VertexBuffer3D;
	private var program:Program3D;
	private var programMatrixUniform:Int;
	private var programTextureAttribute:Int;
	private var programVertexAttribute:Int;
	private var projectionTransform:Matrix3D;
	
	
	public function new () {
		
		super ();
		
		var context = stage.context3D;
		
		if (context == null) {
			
			trace ("Stage does not have a compatible 3D context available");
			return;
			
		}
		
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
		
		program = context.createProgram (GLSL);
		program.uploadSources (vertexSource, fragmentSource);
		
		programVertexAttribute = program.getAttributeIndex ("aPosition");
		programTextureAttribute = program.getAttributeIndex ("aTexCoord");
		programMatrixUniform = program.getConstantIndex ("uMatrix");
		
		var bitmapData = Assets.getBitmapData ("assets/openfl.png");
		bitmapTexture = context.createRectangleTexture (bitmapData.width, bitmapData.height, BGRA, false);
		bitmapTexture.uploadFromBitmapData (bitmapData);
		
		var vertexData = new Vector<Float> ([
			bitmapData.width, bitmapData.height, 0, 1, 1,
			0, bitmapData.height, 0, 0, 1,
			bitmapData.width, 0, 0, 1, 0,
			0, 0, 0, 0, 0.0
		]);
		
		bitmapVertexBuffer = context.createVertexBuffer (4, 5);
		bitmapVertexBuffer.uploadFromVector (vertexData, 0, 20);
		
		var indexData = new Vector<UInt> ([
			0, 1, 2,
			2, 1, 3
		]);
		
		bitmapIndexBuffer = context.createIndexBuffer (6);
		bitmapIndexBuffer.uploadFromVector (indexData, 0, 6);
		
		bitmapTransform = new Matrix3D ();
		bitmapTransform.appendTranslation (100, 100, 0);
		projectionTransform = new Matrix3D ();
		bitmapRenderTransform = new Matrix3D ();
		
		resize (stage.stageWidth, stage.stageHeight);
		
		stage.addEventListener (Event.RESIZE, stage_onResize);
		stage.addEventListener (Event.RENDER, stage_onRender);
		
		render ();
		
	}
	
	
	private function render ():Void {
		
		stage.invalidate ();
		
		var context = stage.context3D;
		
		context.setProgram (program);
		
		context.setBlendFactors (ONE, ONE_MINUS_SOURCE_ALPHA);
		context.setTextureAt (0, bitmapTexture);
		context.setSamplerStateAt (0, CLAMP, LINEAR, MIPNONE);
		
		context.setProgramConstantsFromMatrix (Context3DProgramType.VERTEX, programMatrixUniform, bitmapRenderTransform, false);
		context.setVertexBufferAt (programVertexAttribute, bitmapVertexBuffer, 0, FLOAT_3);
		context.setVertexBufferAt (programTextureAttribute, bitmapVertexBuffer, 3, FLOAT_2);
		
		context.drawTriangles (bitmapIndexBuffer);
		context.present ();
		
	}
	
	
	private function resize (width:Int, height:Int):Void {
		
		projectionTransform = new Matrix3D ();
		projectionTransform.copyRawDataFrom (Vector.ofArray ([
			2.0 / stage.stageWidth, 0.0, 0.0, 0.0,
			0.0, -2.0 / stage.stageHeight, 0.0, 0.0,
			0.0, 0.0, -2.0 / 2000, 0.0,
			-1.0, 1.0, 0.0, 1.0
		]));
		
		bitmapRenderTransform.identity ();
		bitmapRenderTransform.append (bitmapTransform);
		bitmapRenderTransform.append (projectionTransform);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage_onRender (event:Event):Void {
		
		render ();
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}