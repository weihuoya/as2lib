import org.as2lib.basic.out.OutHandler;
import org.as2lib.basic.event.EventBroadcaster;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.out.OutLevel {
	/**
	 * Log a message.
	 * @param message
	 * @param handler
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Log a message with the DEBUG priority.
	 * @param message
	 * @param handler
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Log a message with the INFO priority.
	 * @param message
	 * @param handler
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Log a message with the WARNING priority.
	 * @param message
	 * @param handler
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Log a message with the ERROR priority.
	 * @param message
	 * @param handler
	 */
	public function error(exception:Exception, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Log a message with the FATAL priority.
	 * @param message
	 * @param handler
	 */
	public function fatal(exception:Exception, broadcaster:EventBroadcaster):Void;
}