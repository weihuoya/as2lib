import org.as2lib.basic.OutAccess;
import org.as2lib.basic.out.OutLevel;
import org.as2lib.basic.out.OutHandler;
import org.as2lib.basic.out.handler.TraceHandler;
import org.as2lib.basic.out.level.*;
import org.as2lib.basic.event.EventBroadcaster;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.Out implements OutAccess {
	/** All output will be made. */
	public static var ALL:OutLevel = new All();
	/** All output that is at a lower output level will be made. */
	public static var DEBUG:OutLevel = new Debug();
	/** All output that is at a lower output level will be made. */
	public static var INFO:OutLevel = new Info();
	/** All output that is at a lower output level will be made. */
	public static var WARNING:OutLevel = new Warning();
	/** All output that is at a lower output level will be made. */
	public static var ERROR:OutLevel = new Error();
	/** All output that is at a lower output level will be made. */
	public static var FATAL:OutLevel = new Fatal();
	/** No output will be made. */
	public static var NONE:OutLevel = new None();
	
	/**
	 * The actual level of the Out instance.
	 */
	private var level:OutLevel;
	
	/**
	 * The broadcaster that is used to dispatch so all registered OutHandlers.
	 */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new Out instance and sets the default out level, ALL.
	 */
	public function Out(Void) {
		level = ALL;
		broadcaster = new EventBroadcaster();
		addHandler(new TraceHandler());
	}
	
	/**
	 * Sets a new level.
	 * @param newLevel
	 */
	public function setLevel(newLevel:OutLevel):Void {
		level = newLevel;
	}
	
	/**
	 * Adds a new OutHandler to the list of handlers.
	 * @param aHandler
	 */
	public function addHandler(aHandler:OutHandler):Void {
		broadcaster.addListener(aHandler);
	}
	
	/**
	 * Removes an OutHandler from the list of handlers.
	 * @param aHandler
	 */
	public function removeHandler(aHandler:OutHandler):Void {
		broadcaster.removeListener(aHandler);
	}
	
	/**
	 * @see org.as2lib.basic.OutAccess
	 */
	public function log(message:String):Void {
		level.log(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.basic.OutAccess
	 */
	public function debug(message:String):Void {
		level.debug(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.basic.OutAccess
	 */
	public function info(message:String):Void {
		level.info(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.basic.OutAccess
	 */
	public function warning(message:String):Void {
		level.warning(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.basic.OutAccess
	 */
	public function error(exception:Exception):Void {
		level.error(exception, broadcaster);
	}
	
	/**
	 * @see org.as2lib.basic.OutAccess
	 */
	public function fatal(exception:Exception):Void {
		level.fatal(exception, broadcaster);
	}
}