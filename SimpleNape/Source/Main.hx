package;

import nape.shape.Circle;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.space.Space;
import nape.util.Debug;
import nape.util.ShapeDebug;

import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;

import openfl.display.FPS;

class Main extends Sprite {

	private var space:Space;
	private var gravity:Vec2;
	private var debug:ShapeDebug;

	public function new() {
		super();

		this.addEventListener(Event.ADDED_TO_STAGE, init);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private function init(e:Event):Void {
		if(e != null) {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		this.gravity = Vec2.weak(0, 600);
		this.space = new Space(this.gravity);
		
		this.debug = new ShapeDebug(stage.stageWidth, stage.stageHeight);
		debug.thickness = 1.0;

		addChild(this.debug.display);

		createObjects();

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function createObjects():Void {
		var floor = new Body(BodyType.STATIC);
		floor.shapes.add(new Polygon(Polygon.rect(150, 300, 500, 100, true)));
		floor.space = this.space;

		var box = new Body(BodyType.DYNAMIC);
		box.shapes.add(new Polygon(Polygon.box(100, 100)));
		box.position.setxy(500, 100);
		box.space = this.space;

		var circle = new Body(BodyType.DYNAMIC);
		circle.shapes.add(new Circle(100));
		circle.position.setxy(210, 100);
		circle.angularVel = 10;
		circle.space = this.space;
	}

	private function onEnterFrame(e:Event):Void {
		this.space.step(1 / stage.frameRate);

		this.debug.clear();
		this.debug.draw(space);
		this.debug.flush();
	}

	private function onKeyDown(e:KeyboardEvent):Void {
		if(e.keyCode == Keyboard.SPACE) {
			this.space.clear();
			this.createObjects();
		}
	}

	public static function main():Void {
		Lib.current.stage.addChild(new Main());
		Lib.current.stage.addChild(new FPS());
	}
}