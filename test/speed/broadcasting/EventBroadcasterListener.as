import org.as2lib.env.event.EventListener;

interface broadcasting.EventBroadcasterListener extends EventListener {
	function call(Void):Void;
}