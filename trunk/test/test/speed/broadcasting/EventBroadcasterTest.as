import org.as2lib.test.speed.TestCase;
import broadcasting.ExampleCall;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.EventListener;

class broadcasting.EventBroadcasterTest implements TestCase{
	private var eB:EventBroadcaster;
	
	function EventBroadcasterTest () {
		eB = new EventBroadcaster();
		eB.addListener(new ExampleCall());
		eB.addListener(new ExampleCall());
		eB.addListener(new ExampleCall());
		eB.addListener(new ExampleCall());
		eB.addListener(new ExampleCall());
		eB.addListener(new ExampleCall());
	}
	public function run(Void):Void {
		eB.dispatch(new SimpleEventInfo("call"));
	}
}