import org.as2lib.basic.out.OutLevel;
import org.as2lib.basic.event.EventBroadcaster;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.None implements OutLevel {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function error(exception:Exception, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function fatal(exception:Exception, broadcaster:EventBroadcaster):Void {
	}
}