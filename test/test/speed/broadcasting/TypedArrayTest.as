import org.as2lib.test.speed.TestCase;
import broadcasting.ExampleCall;
import org.as2lib.data.TypedArray;
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
class broadcasting.TypedArrayTest implements TestCase {
	private var content:TypedArray;
	
	function TypedArrayTest () {
		this.content = new TypedArray(ExampleCall);
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
	public function getName(Void):String {
		return "TypedArray";
	}
}