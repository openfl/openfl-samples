package;


import openfl.display.Sprite;
import openfl.events.Event;


class Main extends Sprite {
	
	
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
	
	
}