/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.OutConfig;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.env.out.level.*;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;

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
	public static var ALL:OutLevel = new AllLevel();
	
	/** All output that is at a lower output level than DebugLevel will be made. */
	public static var DEBUG:OutLevel = new DebugLevel();
	
	/** All output that is at a lower output level than InfoLevel will be made. */
	public static var INFO:OutLevel = new InfoLevel();
	
	/** All output that is at a lower output level than WarningLevel will be made. */
	public static var WARNING:OutLevel = new WarningLevel();
	
	/** All output that is at a lower output level than ErrorLevel will be made. */
	public static var ERROR:OutLevel = new ErrorLevel();
	
	/** All output that is at a lower output level than FatalLevel will be made. */
	public static var FATAL:OutLevel = new FatalLevel();
	
	/** No output will be made. */
	public static var NONE:OutLevel = new NoneLevel();
	
	/** The EventBroadcaster that is used to dispatch to all static registered OutHandlers. */
	private static var staticBroadcaster:EventBroadcaster;
	
	/** The actual OutLevel of the Out instance. */
	private var level:OutLevel;
	
	/** The EventBroadcaster that is used to dispatch to all registered OutHandlers. */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new Out instance and sets the default OutLevel, ALL.
	 */
	public function Out(Void) {
		level = ALL;
		broadcaster = OutConfig.getEventBroadcasterFactory().createEventBroadcaster();
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
	 * Returns the currently set OutLevel.
	 *
	 * @return the OutLevel
	 */
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	/**
	 * Adds a new OutHandler to the static list of handlers. These OutHandlers will be used
	 * to make the output of all instances. They get invoked when output shall be made.
	 *
	 * @param handler the new OutHandler that shall handle output
	 */
	public static function addStaticHandler(aHandler:OutHandler):Void {
		if(!staticBroadcaster) {
			staticBroadcaster = OutConfig.getEventBroadcasterFactory().createEventBroadcaster();
		}
		staticBroadcaster.addListener(aHandler);
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
	 * Removes the specified OutHandler from the list of static handlers. If the OutHandler
	 * does not exist in the list the IllegalArgumentException will be thrown.
	 *
	 * @param handler the OutHandler to be removed from the list
	 * @throws IllegalArgumentException the exception will be thrown when the OutHandler does not exist on the list
	 */
	public static function removeStaticHandler(aHandler:OutHandler):Void {
		staticBroadcaster.removeListener(aHandler);
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
	 * Checks whether this Out instance is enabled for a given OutLevel passed as
	 * parameter.
	 *
	 * @param level the OutLevel to make the check upon
	 * @return true if this Out instance is enabled for the given OutLevel else false
	 */
	public function isEnabledFor(aLevel:OutLevel):Boolean {
		if (level == aLevel) return true;
		return (level instanceof ReflectUtil.getClassInfo(aLevel).getType());
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function log(message):Void {
		level.log(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function debug(message):Void {
		level.debug(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function info(message):Void {
		level.info(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function warning(message):Void {
		level.warning(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function error(message):Void {
		level.error(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function fatal(message):Void {
		level.fatal(message, broadcaster, staticBroadcaster);
	}
}