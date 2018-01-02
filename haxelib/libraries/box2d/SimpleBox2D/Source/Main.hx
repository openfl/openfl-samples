package;


import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;


class Main extends Sprite {
	
	
	private static var PHYSICS_SCALE:Float = 1 / 30;
	
	private var PhysicsDebug:Sprite;
	private var World:B2World;
	
	
	public function new () {
		
		super ();
		
		World = new B2World (new B2Vec2 (0, 10.0), true);
		
		PhysicsDebug = new Sprite ();
		addChild (PhysicsDebug);
		
		var debugDraw = new B2DebugDraw ();
		debugDraw.setSprite (PhysicsDebug);
		debugDraw.setDrawScale (1 / PHYSICS_SCALE);
		debugDraw.setFlags (B2DebugDraw.e_shapeBit);
		
		World.setDebugDraw (debugDraw);
		
		createBox (250, 300, 500, 100, false);
		createBox (250, 100, 100, 100, true);
		createCircle (100, 100, 50, false);
		createCircle (400, 100, 50, true);
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	private function createBox (x:Float, y:Float, width:Float, height:Float, dynamicBody:Bool):Void {
		
		var bodyDefinition = new B2BodyDef ();
		bodyDefinition.position.set (x * PHYSICS_SCALE, y * PHYSICS_SCALE);
		
		if (dynamicBody) {
			
			bodyDefinition.type = B2Body.b2_dynamicBody;
			
		}
		
		var polygon = new B2PolygonShape ();
		polygon.setAsBox ((width / 2) * PHYSICS_SCALE, (height / 2) * PHYSICS_SCALE);
		
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = polygon;
		
		var body = World.createBody (bodyDefinition);
		body.createFixture (fixtureDefinition);
		
	}
	
	
	private function createCircle (x:Float, y:Float, radius:Float, dynamicBody:Bool):Void {
		
		var bodyDefinition = new B2BodyDef ();
		bodyDefinition.position.set (x * PHYSICS_SCALE, y * PHYSICS_SCALE);
		
		if (dynamicBody) {
			
			bodyDefinition.type = B2Body.b2_dynamicBody;
			
		}
		
		var circle = new B2CircleShape (radius * PHYSICS_SCALE);
		
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = circle;
		
		var body = World.createBody (bodyDefinition);
		body.createFixture (fixtureDefinition);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		World.step (1 / 30, 10, 10);
		World.clearForces ();
		World.drawDebugData ();
		
	}
	
	
}