package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
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
		if (displayObjectShader.data != null)
		{
			displayObjectShader.data.vertexMultiplier.value = [1, 1, 1, 1];
			displayObjectShader.data.fragmentMultiplier.value = [1, 1, 1, 1];
			displayObject.shader = displayObjectShader;
		}

		displayObject.addChild(new Bitmap(Assets.getBitmapData("assets/openfl.png"), PixelSnapping.AUTO, true));
		displayObject.x = (stage.stageWidth - displayObject.width) / 2;
		displayObject.y = (stage.stageHeight - displayObject.height) / 4;
		addChild(displayObject);

		renderToTexture = new Sprite();

		renderToTextureShader = new CustomBitmapFilterShader();
		if (renderToTextureShader.data != null)
		{
			renderToTextureShader.data.vertexMultiplier.value = [1, 1, 1, 1];
			renderToTextureShader.data.fragmentMultiplier.value = [1, 1, 1, 1];
			renderToTexture.filters = [new ShaderFilter(renderToTextureShader)];
		}

		renderToTexture.addChild(new Bitmap(Assets.getBitmapData("assets/openfl.png"), PixelSnapping.AUTO, true));
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

		if (displayObjectShader.data != null)
		{
			displayObjectShader.data.vertexMultiplier.value[0] = multiplierX;
			displayObjectShader.data.vertexMultiplier.value[1] = multiplierY;
			displayObjectShader.data.fragmentMultiplier.value[3] = multiplierAlpha;
			displayObject.invalidate();
		}

		var multiplierX = (Math.random() + 99) / 100;
		var multiplierY = (Math.random() + 99) / 100;
		var multiplierAlpha = (Math.random() + 2) / 3;

		if (renderToTextureShader.data != null)
		{
			renderToTextureShader.data.vertexMultiplier.value[0] = multiplierX;
			renderToTextureShader.data.vertexMultiplier.value[1] = multiplierY;
			renderToTextureShader.data.fragmentMultiplier.value[3] = multiplierAlpha;
			renderToTexture.filters = renderToTexture.filters;
		}
	}
}
