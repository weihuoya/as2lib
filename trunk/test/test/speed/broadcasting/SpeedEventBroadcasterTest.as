import org.as2lib.test.speed.TestCase;
import broadcasting.ExampleCall;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.env.event.SimpleEventInfo;

class broadcasting.SpeedEventBroadcasterTest implements TestCase{
	private var eB:EventBroadcaster;
	
	function SpeedEventBroadcasterTest () {
		eB = new SpeedEventBroadcaster();
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