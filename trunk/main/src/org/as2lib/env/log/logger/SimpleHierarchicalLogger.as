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
import org.as2lib.util.ArrayUtil;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.ConfigurableLogger;
import org.as2lib.env.log.ConfigurableHierarchicalLogger;
import org.as2lib.env.log.HierarchicalLogger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogMessage;

/**
 * Log output can be made at different levels. You use these levels to enable
 * or prevent specific output. Refer to LogLevel for further information.
 * You can also add your own message handlers, to write for example to a textfile.
 * You do this with the #addHandler(LogHandler) method.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.SimpleHierarchicalLogger extends BasicClass implements ConfigurableLogger, ConfigurableHierarchicalLogger {
	
	/** The actual level. */
	private var level:LogLevel;
	
	/** Stores all added handlers. */
	private var handlers:Array;
	
	/** Stores the parent. */
	private var parent:HierarchicalLogger;
	
	/** The name of this logger. */
	private var name:String;
	
	/** Stores the broadcaster factory. */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param name the name of the new logger
	 */
	public function SimpleHierarchicalLogger(name:String) {
		setName(name);
		handlers = new Array();
	}
	
	/**
	 * Sets the broadcaster used to dispatch to all registered handlers.
	 *
	 * <p>If you set a broadcaster of value null or undefined the default
	 * broadcaster will be used.
	 *
	 * @param broadcaster the new broadcaster used to dispatch to handlers
	 * @see #getBroadcaster()
	 */
	public function setBroadcaster(broadcaster:EventBroadcaster):Void {
		this.broadcaster = broadcaster;
	}
	
	/**
	 * Returns the currently used broadcaster.
	 *
	 * <p>Either the broadcaster set via #setBroadcaster(EventBroadcaster) will be
	 * returned or the default SpeedEventBroadcaster.
	 *
	 * <p>The default one will be used if you set a broadcaster of value null
	 * or undefined.
	 *
	 * @return the currently used broadcaster
	 * @see #setBroadcaster(EventBroadcaster)
	 */
	public function getBroadcaster(Void):EventBroadcaster {
		if (!broadcaster) broadcaster = new SpeedEventBroadcaster();
		return broadcaster;
	}
	
	/**
	 * @see HierarchicalLogger#getParent()
	 */
	public function getParent(Void):HierarchicalLogger {
		return parent;
	}
	
	/**
	 * @see ConfigurableHierarchicalLogger#setParent()
	 */
	public function setParent(parent:HierarchicalLogger):Void {
		this.parent = parent;
	}
	
	/**
	 * @see HierarchicalLogger#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * @see ConfigurableHierarchicalLogger#setName()
	 */
	public function setName(name:String):Void {
		this.name = name;
	}
	
	/**
	 * @see ConfigurableLogger#setLevel()
	 */
	public function setLevel(level:LogLevel):Void {
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
		if (level === undefined) return getParent().getLevel();
		return level;
	}
	
	/**
	 * @see ConfigurableLogger#addHandler()
	 */
	public function addHandler(handler:LogHandler):Void {
		if (handler)
			handlers.push(handler);
	}
	
	/**
	 * @see ConfigurableLogger#removeHandler()
	 */
	public function removeHandler(handler:LogHandler):Void {
		if (handler)
			ArrayUtil.removeElement(handlers, handler);
	}
	
	/**
	 * @see ConfigurableLogger#removeAllHandler()
	 */
	public function removeAllHandler(Void):Void {
		handlers = new Array();
	}
	
	/**
	 * This method never returns null or undefined.
	 *
	 * @see HierarchicalLogger#getAllHandler()
	 */
	public function getAllHandler(Void):Array {
		return handlers.concat();
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
			var logMessage:LogMessage = new LogMessage(message, level, name);
			var broadcaster:EventBroadcaster = getBroadcaster();
			var target:HierarchicalLogger = this;
			while (target) {
				var handlers:Array = target.getAllHandler();
				if (handlers.length > 0) {
					broadcaster.addAllListener(handlers);
				}
				target = target.getParent();
			}
			broadcaster.dispatch(logMessage);
			broadcaster.removeAllListener();
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