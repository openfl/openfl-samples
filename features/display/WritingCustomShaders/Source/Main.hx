package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.ShaderFilter;
import openfl.events.Event;
import openfl.utils.Assets;

class Main extends Sprite
{
	private var displayObject:Sprite;
	private var displayObjectShader:CustomDisplayObjectShader;
	private var renderToTexture:Sprite;
	private var renderToTextureShader:CustomBitmapFilterShader;

	public function new()
	{
		super();

		displayObject = new Sprite();

		displayObjectShader = new CustomDisplayObjectShader();
		displayObjectShader.vertexMultiplier.value = [1, 1, 1, 1];
		displayObjectShader.fragmentMultiplier.value = [1, 1, 1, 1];
		displayObject.shader = displayObjectShader;

		displayObject.addChild(new Bitmap(Assets.getBitmapData("assets/openfl.png"), null, true));
		displayObject.x = (stage.stageWidth - displayObject.width) / 2;
		displayObject.y = (stage.stageHeight - displayObject.height) / 4;
		addChild(displayObject);

		renderToTexture = new Sprite();

		renderToTextureShader = new CustomBitmapFilterShader();
		renderToTextureShader.vertexMultiplier.value = [1, 1, 1, 1];
		renderToTextureShader.fragmentMultiplier.value = [1, 1, 1, 1];
		renderToTexture.filters = [new ShaderFilter(renderToTextureShader)];

		renderToTexture.addChild(new Bitmap(Assets.getBitmapData("assets/openfl.png"), null, true));
		renderToTexture.x = (stage.stageWidth - renderToTexture.width) / 2;
		renderToTexture.y = ((stage.stageHeight - renderToTexture.height) / 4) * 3;
		addChild(renderToTexture);

		addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	// Event Handlers

	private function this_onEnterFrame(event:Event):Void
	{
		var multiplierX = (Math.random() + 99) / 100;
		var multiplierY = (Math.random() + 99) / 100;
		var multiplierAlpha = (Math.random() + 2) / 3;

		displayObjectShader.vertexMultiplier.value[0] = multiplierX;
		displayObjectShader.vertexMultiplier.value[1] = multiplierY;
		displayObjectShader.fragmentMultiplier.value[3] = multiplierAlpha;
		displayObject.invalidate();

		var multiplierX = (Math.random() + 99) / 100;
		var multiplierY = (Math.random() + 99) / 100;
		var multiplierAlpha = (Math.random() + 2) / 3;

		renderToTextureShader.vertexMultiplier.value[0] = multiplierX;
		renderToTextureShader.vertexMultiplier.value[1] = multiplierY;
		renderToTextureShader.fragmentMultiplier.value[3] = multiplierAlpha;
		renderToTexture.filters = renderToTexture.filters;
	}
}
