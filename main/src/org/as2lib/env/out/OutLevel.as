import org.as2lib.env.out.OutHandler;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;

/**
 * OutLevel is the basic interface for all OutLevels. OutLevels in a descending
 * order are: All, Debug, Info, Warning, Error, Fatal. OutLevels are used to
 * determine if a specific output will be made or not. If you for example set
 * the OutLevel to All all output will be made. If you set the OutLevel to Info
 * then info, warning, error and fatal output will be made.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutLevel extends BasicInterface {
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a Throwable.
	 *
	 * @param throwable the Throwable to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function error(exception:Throwable, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a Throwable.
	 *
	 * @param throwable the Throwable to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function fatal(exception:Throwable, broadcaster:EventBroadcaster):Void;
}