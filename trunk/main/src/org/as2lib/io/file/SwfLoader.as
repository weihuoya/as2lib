import org.as2lib.io.file.AbstractResourceLoader;
import org.as2lib.data.type.Byte;
import org.as2lib.data.holder.Iterator;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.file.SwfListener;
import org.as2lib.env.event.impulse.FrameImpulse;
import org.as2lib.env.event.impulse.FrameImpulseListener;
import org.as2lib.io.file.ResourceNotFoundException;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.io.file.ResourceNotLoadedException;
import org.as2lib.data.type.Time;

/**
 * 
 */
class org.as2lib.io.file.SwfLoader extends AbstractResourceLoader implements ResourceLoader, FrameImpulseListener {
	
	public static var TIMEOUT:Time = new Time(3000);
	
	private var holder:MovieClip;
	private var result:MovieClip;
	private var swfEvent:SwfListener;
	
	public function SwfLoader(holder:MovieClip) {
		this.holder = holder;
		
		distributorControl.acceptListenerType(SwfListener);
		swfEvent = distributorControl.getDistributor(SwfListener);
	}
	
	private function run() {
		result = null;
		if (uri == null) {
			throw new IllegalArgumentException("Url has to be set for starting the process.", this, arguments);
		} else {
			working = true;
			if(parameters) {
				var keys:Iterator = parameters.keyIterator();
				while (keys.hasNext()) {
					var key = keys.next();
					holder[key.toString()] = parameters.get(key);
				}
			}
			if (method == "POST") {
				loadMovie(uri, holder, "POST");
			} else {
				loadMovie(uri, holder, "GET");
			}
			swfEvent.onSwfStartLoading(this);
			resourceEvent.onResourceStartLoading(this);
			processEvent.onStartProcess(this);
			FrameImpulse.getInstance().addFrameImpulseListener(this);
		}
	}
	
	public function getResource(Void) {
		return getTarget();
	}
	
	public function getTarget(Void):MovieClip {
		if (!result) {
			throw new ResourceNotLoadedException("No File has been loaded.", this, arguments);
		}
		return result;
	}
	
	public function getBytesLoaded(Void):Byte {
		var result:Number = holder.getBytesLoaded();
		if (result >= 0) {
			return new Byte(result);
		}
		return null;
	}
	
	public function getBytesTotal(Void):Byte {
		var total:Number = holder.getBytesTotal();
		if (total >= 0) {
			return new Byte(total);
		}
		return null;
	}
	
	public function onFrameImpulse(impulse:FrameImpulse):Void {
		if (checkTimeout()) {
			failLoading();
		} else if (checkFinished()){
			successLoading();
		}
	}
	
	private function checkFinished():Boolean {
		holder = eval(""+holder._target);
		if ( holder.getBytesTotal() > 10 
			&& holder.getBytesTotal() - holder.getBytesLoaded() < 10) { 
			return true;
		}
		return false;
	}
	
	private function checkTimeout():Boolean {
		if (holder.getBytesTotal() > 10) {
			return false;
		}
		return (getDuration().valueOf() > TIMEOUT);
	}
	
	private function successLoading(Void):Void {
		finished = true;
		started = false;
		paused = false;
		working = false;
		result = holder;
		endTime = getTimer();
		swfEvent.onSwfLoad(holder);
		resourceEvent.onResourceLoad(this);
		tearDown();
	}
	
	private function failLoading(Void):Void {
		finished = true;
		started = false;
		paused = false;
		working = false;
		endTime = getTimer();
		swfEvent.onSwfNotFound(uri);
		resourceEvent.onResourceNotFound(uri);
		processEvent.onProcessError(this, new ResourceNotFoundException("'"+uri+"' could not be loaded.", this, arguments));
		tearDown();
	}
	
	private function tearDown(Void):Void {
		FrameImpulse.getInstance().removeListener(this);
		processEvent.onFinishProcess(this);
	}

}