import org.as2lib.test.speed.TestCase;
import broadcasting.ExampleCall;

/**
 * Test for a minimal Eventhandling with an Array.
 * Runs a test applying to an Array with 6 contentNodes.
 * 
 * @autor Martin Heidegger
 * @version 1.0
 * @see broadcasting.ASBroadcasterTest
 * @see broadcasting.EventBroadcasterTest
 * @see broadcasting.EventDispatcherTest
 */
class broadcasting.ArrayTest implements TestCase {
	private var content:Array;
	
	function ArrayTest () {
		this.content = new Array();
		this.content.push(new ExampleCall());
		this.content.push(new ExampleCall());
		this.content.push(new ExampleCall());
		this.content.push(new ExampleCall());
		this.content.push(new ExampleCall());
		this.content.push(new ExampleCall());
	}
	
	public function run(Void):Void {
		for(var i=0; i<this.content.length; i++) {
			this.content[i]["call"]();
		}
	}
}