package;


import openfl.display3D.Context3DProgramType;
import openfl.display.Sprite;
import openfl.utils.Assets;
import openfl.Vector;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var bitmapData = Assets.getBitmapData ("assets/openfl.png");
		
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
		
		var program = stage.context3D.createProgram (GLSL);
		program.uploadSources (vertexSource, fragmentSource);
		
		var vertexAttribute = program.getVertexAttributeIndex ("aPosition");
		var textureAttribute = program.getVertexAttributeIndex ("aTexCoord");
		var matrixUniform = program.getFragmentConstantIndex ("uMatrix");
		
		stage.context3D.setBlendFactors (SOURCE_ALPHA, ONE_MINUS_SOURCE_ALPHA);
		
		var vertexData = new Vector<Float> ([
			
			bitmapData.width, bitmapData.height, 0, 1, 1,
			0, bitmapData.height, 0, 0, 1,
			bitmapData.width, 0, 0, 1, 0,
			0, 0, 0, 0, 0.0
			
		]);
		
		var vertexBuffer = stage.context3D.createVertexBuffer (4, 5);
		vertexBuffer.uploadFromVector (vertexData, 0, 20);
		
		var indexData = new Vector<Int> ([
			
			0, 1, 2,
			2, 1, 3
			
		]);
		
		var indexBuffer = stage.context3D.createIndexBuffer (6);
		indexBuffer.uploadFromVector (indexData, 0, 6);
		
		var texture = stage.context3D.createRectangleTexture (bitmapData.width, bitmapData.height, BGRA, false);
		texture.uploadFromBitmapData (bitmapData);
		
		stage.context3D.setTextureAt (0, texture);
		stage.context3D.setSamplerStateAt (0, CLAMP, LINEAR, MIPNONE);
		
		stage.context3D.clear (1, 1, 1, 1);
		
		var projectionTransform = new PerspectiveMatrix3D ();
		projectionTransform.orthoLH (stage.stageWidth, stage.stageHeight, -1000, 1000);
		stage.context3D.setProgramConstantsFromMatrix (Context3DProgramType.VERTEX, matrixUniform, projectionTransform, true);
		
		stage.context3D.setVertexBufferAt (vertexAttribute, vertexBuffer, 0, FLOAT_3);
		stage.context3D.setVertexBufferAt (textureAttribute, vertexBuffer, 3, FLOAT_2);
		
		stage.context3D.drawTriangles (indexBuffer);
		
	}
	
	
}