import org.as2lib.io.file.AbstractResourceLoader;
import org.as2lib.data.type.Byte;
import org.as2lib.data.holder.Iterator;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.event.impulse.FrameImpulse;
import org.as2lib.env.event.impulse.FrameImpulseListener;
import org.as2lib.io.file.ResourceNotFoundException;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.io.file.ResourceNotLoadedException;
import org.as2lib.data.type.Time;
import org.as2lib.env.bean.factory.InitializingBean;
import org.as2lib.app.exec.Executable;
import org.as2lib.data.holder.Map;
import org.as2lib.io.file.Resource;
import org.as2lib.io.file.SwfResource;

/**
 * 
 */
class org.as2lib.io.file.SwfLoader extends AbstractResourceLoader implements ResourceLoader, FrameImpulseListener {
	
	public static var TIMEOUT:Time = new Time(3000);
	
	private var holder:MovieClip;
	private var result:Resource;
	
	public function SwfLoader(holder:MovieClip) {
		this.holder = holder;
	}
	
	public function load(uri:String, method:String, parameters:Map, callBack:Executable):Void {
		result = null;
		if(parameters) {
			var keys:Iterator = parameters.keyIterator();
			while (keys.hasNext()) {
				var key = keys.next();
				holder[key.toString()] = parameters.get(key);
			}
		}
		loadMovie(uri, holder, method);
		sendStartEvent();
		FrameImpulse.getInstance().addFrameImpulseListener(this);
	}
	
	public function getResource(Void):Resource {
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
		result = new SwfResource(holder, uri, getBytesTotal());
		endTime = getTimer();
		sendCompleteEvent();
		tearDown();
	}
	
	private function failLoading(Void):Void {
		finished = true;
		started = false;
		endTime = getTimer();
		sendErrorEvent(FILE_NOT_FOUND_ERROR, this);
		tearDown();
	}
	
	private function tearDown(Void):Void {
		FrameImpulse.getInstance().removeListener(this);
	}

}