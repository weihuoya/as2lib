import org.as2lib.basic.out.OutLevel;
import org.as2lib.event.EventBroadcaster;
import org.as2lib.except.Throwable;
import org.as2lib.basic.BasicClass;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.None extends BasicClass implements OutLevel {
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
	public function error(exception:Throwable, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function fatal(exception:Throwable, broadcaster:EventBroadcaster):Void {
	}
}