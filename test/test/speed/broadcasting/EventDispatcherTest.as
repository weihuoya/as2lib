import org.as2lib.test.speed.TestCase;
import broadcasting.ExampleCall;
import mx.events.EventDispatcher;
/**
 * Test for the Eventdispatcher.
 * Runs a test of 6 Listeners to an EventDispatcher.
 * 
 * @autor Martin Heidegger
 * @version 1.0
 * @see broadcasting.ArrayTest
 * @see broadcasting.ASBroadcasterTest
 * @see broadcasting.EventDispatcherTest
 */
class broadcasting.EventDispatcherTest implements TestCase {
	
	/** adds a listener */
	public var addEventListener:Function;
	
	/** removes a listener */
	public var removeEventListener:Function;

	/** adds a listener */
	public var dispatchEvent:Function;
	
	/** adds a listener */
	public var dispatchQueue:Function;
	
	/** 
	 * Constructs an EventDispatcherTest.
	 */
	public function EventDispatcherTest () {
		EventDispatcher.initialize(this);
		addEventListener('call', new ExampleCall());
		addEventListener('call', new ExampleCall());
		addEventListener('call', new ExampleCall());
		addEventListener('call', new ExampleCall());
		addEventListener('call', new ExampleCall());
		addEventListener('call', new ExampleCall());
	}
	
	/**
	 * Single Call for all Events.
	 */
	public function run(Void):Void {
		dispatchEvent({type:'call'});
	}
	
	/**
	 * @return the own name.
	 */
	public function getName(Void):String {
		return "EventDispatcher";
	}
}