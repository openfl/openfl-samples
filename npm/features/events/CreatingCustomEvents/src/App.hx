import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;


class App extends Sprite {
	
	
	public function new () {
		
		super ();
		
		addEventListener ("simpleCustomEvent", this_onSimpleCustomEvent);
		addEventListener (CustomEvent.TYPED_CUSTOM_EVENT, this_onTypedCustomEvent);
		
		dispatchEvent (new Event ("simpleCustomEvent"));
		dispatchEvent (new CustomEvent (CustomEvent.TYPED_CUSTOM_EVENT, 100));
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onSimpleCustomEvent (event:Event):Void {
		
		trace (event);
		
	}
	
	
	private function this_onTypedCustomEvent (event:CustomEvent) {
		
		trace (event);
		
	}
	
	
	
	
	// Entry Point
	
	
	
	
	static function main () {
		
		var stage = new Stage (550, 400, 0xFFFFFF, App);
		js.Browser.document.body.appendChild (stage.element);
		
	}
	
	
}