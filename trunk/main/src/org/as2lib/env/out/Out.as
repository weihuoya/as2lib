﻿import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.env.out.level.*;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;

/**
 * Out is the main output class. You use this class to make your output.
 * Output can be made in different OutLevels. You use these OutLevels to enable
 * or prevent specific output. OutLevels are:
 * Out.ALL, Out.DEBUG, Out.INFO, Out.WARNING, Out.ERROR, Out.FATAL, Out.NONE
 * These OutLevels are ordered in a specific order. Out.ALL will enable all output
 * to be made. Out.DEBUG only allows output that is at a lower OutLevel and so on.
 * If you for example want to prevent all output other than Exceptions and FatalExceptions
 * you would set the OutLevel to Out.ERROR with the #setLevel(OutLevel) operation.
 * You can also add your own OutHandler. To write for example to a textfile. You do this
 * with the #addHandler(OutHandler) operation.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.Out extends BasicClass implements OutAccess {
	/** All output will be made. */
	public static var ALL:OutLevel = new All();
	
	/** All output that is at a lower output level than Debug will be made. */
	public static var DEBUG:OutLevel = new Debug();
	
	/** All output that is at a lower output level than Info will be made. */
	public static var INFO:OutLevel = new Info();
	
	/** All output that is at a lower output level than Warning will be made. */
	public static var WARNING:OutLevel = new Warning();
	
	/** All output that is at a lower output level than Error will be made. */
	public static var ERROR:OutLevel = new Error();
	
	/** All output that is at a lower output level than Fatal will be made. */
	public static var FATAL:OutLevel = new Fatal();
	
	/** No output will be made. */
	public static var NONE:OutLevel = new None();
	
	/** The actual OutLevel of the Out instance. */
	private var level:OutLevel;
	
	/** The EventBroadcaster that is used to dispatch to all registered OutHandlers. */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new Out instance and sets the default OutLevel, ALL.
	 */
	public function Out(Void) {
		level = ALL;
		broadcaster = new EventBroadcaster();
		addHandler(new TraceHandler());
	}
	
	/**
	 * Sets a new OutLevel. The OutLevel determines which output will be made.
	 * Possible OutLevels are: 
	 * Out.ALL, Out.DEBUG, Out.INFO, Out.WARNING, Out.ERROR, Out.FATAL, Out.NONE
	 *
	 * @param level the new OutLevel to control the output
	 */
	public function setLevel(newLevel:OutLevel):Void {
		level = newLevel;
	}
	
	/**
	 * Adds a new OutHandler to the list of handlers. These OutHandlers will be used
	 * to make the actual output. They get invoked when output shall be made.
	 *
	 * @param handler the new OutHandler that shall handle output
	 */
	public function addHandler(aHandler:OutHandler):Void {
		broadcaster.addListener(aHandler);
	}
	
	/**
	 * Removes the specified OutHandler from the list of handlers. If the OutHandler
	 * does not exist in the list the IllegalArgumentException will be thrown.
	 *
	 * @param handler the OutHandler to be removed from the list
	 * @throws IllegalArgumentException the exception will be thrown when the OutHandler does not exist on the list
	 */
	public function removeHandler(aHandler:OutHandler):Void {
		broadcaster.removeListener(aHandler);
	}
	
	/**
	 * Removes all registered handlers.
	 */
	public function removeAllHandler(Void):Void {
		broadcaster.removeAllListener();
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function log(message:String):Void {
		level.log(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function debug(message:String):Void {
		level.debug(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function info(message:String):Void {
		level.info(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function warning(message:String):Void {
		level.warning(message, broadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function error(throwable:Throwable):Void {
		level.error(throwable, broadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function fatal(throwable:Throwable):Void {
		level.fatal(throwable, broadcaster);
	}
}