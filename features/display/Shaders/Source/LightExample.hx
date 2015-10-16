package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.Lib;
import shaders.LightShader;

/**
 * ...
 * @author MrCdK
 */
class LightExample extends Sprite {

	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(_) {
		// diffuse.png and normals.png from http://www.goodboydigital.com/pixijs/examples/20/
		var diffuse = Assets.getBitmapData("assets/diffuse.png");
		var normal  = Assets.getBitmapData("assets/normals.png");
		
		var sprite = new Sprite();
		addChild(sprite);
		sprite.addChild(new Bitmap(diffuse));
		
		var lightShader = new LightShader();
		sprite.shader = lightShader;
		
		lightShader.uSamplerN = normal;
		lightShader.uAmbientColor = [0.6, 0.6, 1, 0.2];
		lightShader.uLightColor = [1, 0.8, 0.6, 1];
		lightShader.uLightPos = [0, 0, 0.075];
		lightShader.uFalloff = [0.4, 1, 20];
		lightShader.uResolution = [sprite.width, sprite.height];
		
		stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) {
			lightShader.uLightPos[0] = e.stageX;
			lightShader.uLightPos[1] = e.stageY;
		});
		
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent) {
			lightShader.uLightPos[2] += e.delta * 0.005;
		});
		
		var bounds;
		stage.addEventListener(Event.RESIZE, function(_) {
			sprite.scaleX = stage.stageWidth / diffuse.width;
			sprite.scaleY = stage.stageHeight / diffuse.height;
			lightShader.uResolution = [stage.stageWidth, stage.stageHeight];
		});
	}
	
}