import org.as2lib.env.out.OutLevel;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.except.OutLevel
 */
class org.as2lib.env.out.level.None extends BasicClass implements OutLevel {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function error(exception:Throwable, broadcaster:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function fatal(exception:Throwable, broadcaster:EventBroadcaster):Void {
	}
}