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

import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.ConfigurableLogger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogMessage;

/**
 * SimpleLogger is a simple implementation of the ConfigurableLogger
 * interface.
 *
 * <p>It cannot be used with the LoggerHierarchy because it does not
 * offer hierarchy support. If you want to use you logger in a hierarchy
 * use the SimpleHierarchicalLogger instead.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.SimpleLogger extends BasicClass implements ConfigurableLogger {
	
	/** The actual level. */
	private var level:LogLevel;
	
	/** Stores the broadcaster factory. */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param name the name of the new logger
	 */
	public function SimpleLogger(broadcaster:EventBroadcaster) {
		this.broadcaster = broadcaster ? broadcaster : new SpeedEventBroadcaster();
	}
	
	/**
	 * @see ConfigurableLogger#setLevel()
	 */
	public function setLevel(level:LogLevel):Void {
		if (!level) level = AbstractLogLevel.ALL;
		this.level = level;
	}
	
	/**
	 * If the level has not been set, that means is undefined, the level of
	 * the parent will be returned.
	 *
	 * <p>Null or undefined will only be returned if this level is not defined
	 * and the parent's getLevel() method returns null or undefined.
	 *
	 * @see Logger#getLevel()
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * @see ConfigurableLogger#addHandler()
	 */
	public function addHandler(handler:LogHandler):Void {
		if (handler)
			broadcaster.addListener(handler);
	}
	
	/**
	 * @see ConfigurableLogger#removeHandler()
	 */
	public function removeHandler(handler:LogHandler):Void {
		if (handler)
			broadcaster.removeListener(handler);
	}
	
	/**
	 * @see ConfigurableLogger#removeAllHandler()
	 */
	public function removeAllHandler(Void):Void {
		broadcaster.removeAllListener();
	}
	
	/**
	 * This method never returns null or undefined.
	 *
	 * @see HierarchicalLogger#getAllHandler()
	 */
	public function getAllHandler(Void):Array {
		return broadcaster.getAllListener();
	}
	
	/**
	 * False will be returned if:
	 * <ul>
	 *   <li>This logger is not enabled for the passed-in level.</li>
	 *   <li>The passed-in level is null or undefined.</li>
	 * </ul>
	 *
	 * @see Logger#isEnabled()
	 */
	public function isEnabled(level:LogLevel):Boolean {
		if (!level) return false;
		return getLevel().isGreaterOrEqual(level);
	}
	
	/**
	 * @see Logger#isDebugEnabled()
	 */
	public function isDebugEnabled(Void):Boolean {
		return isEnabled(AbstractLogLevel.DEBUG);
	}
	
	/**
	 * @see Logger#isInfoEnabled()
	 */
	public function isInfoEnabled(Void):Boolean {
		return isEnabled(AbstractLogLevel.INFO);
	}
	
	/**
	 * @see Logger#isWarningEnabled()
	 */
	public function isWarningEnabled(Void):Boolean {
		return isEnabled(AbstractLogLevel.WARNING);
	}
	
	/**
	 * @see Logger#isErrorEnabled()
	 */
	public function isErrorEnabled(Void):Boolean {
		return isEnabled(AbstractLogLevel.ERROR);
	}
	
	/**
	 * @see Logger#isFatalEnabled()
	 */
	public function isFatalEnabled(Void):Boolean {
		return isEnabled(AbstractLogLevel.FATAL);
	}
	
	/**
	 * Broadcasts the passed-in message to all handlers of this logger as
	 * well as to the handlers of every parent logger.
	 *
	 * @see Logger#log()
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			broadcaster.dispatch(new LogMessage(message, level, null));
		}
	}
	
	/**
	 * @see Logger#debug()
	 */
	public function debug(message):Void {
		log(message, AbstractLogLevel.DEBUG);
	}
	
	/**
	 * @see Logger#info()
	 */
	public function info(message):Void {
		log(message, AbstractLogLevel.INFO);
	}
	
	/**
	 * @see Logger#warning()
	 */
	public function warning(message):Void {
		log(message, AbstractLogLevel.WARNING);
	}
	
	/**
	 * @see Logger#error()
	 */
	public function error(message):Void {
		log(message, AbstractLogLevel.ERROR);
	}
	
	/**
	 * @see Logger#fatal()
	 */
	public function fatal(message):Void {
		log(message, AbstractLogLevel.FATAL);
	}
	
}