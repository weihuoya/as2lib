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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.ConfigurableLogger;
import org.as2lib.env.log.ConfigurableHierarchicalLogger;
import org.as2lib.env.log.HierarchicalLogger;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.repository.LoggerHierarchy;

/**
 * Log output can be made at different levels. You use these levels to enable
 * or prevent specific output. Refer to LogLevel for further information.
 * You can also add your own message handler. To write for example to a textfile.
 * You do this with the #addHandler(LogHandler) operation.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.SimpleLogger extends BasicClass implements ConfigurableLogger, ConfigurableHierarchicalLogger {
	
	/** The actual level. */
	private var level:LogLevel;
	
	/** The broadcaster that is used to dispatch to all registered writers. */
	private var broadcaster:EventBroadcaster;
	
	/** Stores the parent. */
	private var parent:HierarchicalLogger;
	
	/** The name of this logger. */
	private var name:String;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param name the name of the new logger (optional)
	 */
	public function SimpleLogger(name:String) {
		if (name) setName(name);
		else setName("");
		broadcaster = new SpeedEventBroadcaster();
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
		broadcaster.addListener(handler);
	}
	
	/**
	 * @see ConfigurableLogger#removeHandler()
	 */
	public function removeHandler(handler:LogHandler):Void {
		broadcaster.removeListener(handler);
	}
	
	/**
	 * @see ConfigurableLogger#removeAllHandler()
	 */
	public function removeAllHandler(Void):Void {
		broadcaster.removeAllListener();
	}
	
	/**
	 * @see HierarchicalLogger#getAllHandler()
	 */
	public function getAllHandler(Void):Array {
		return broadcaster.getAllListener();
	}
	
	/**
	 * @see Logger#isEnabled()
	 */
	public function isEnabled(level:LogLevel):Boolean {
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
	 * @see Logger#log()
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			var message:LogMessage = new LogMessage(message, level);
			var target:HierarchicalLogger = this;
			while (target) {
				new SpeedEventBroadcaster(target.getAllHandler()).dispatch(message);
				target = target.getParent();
			}
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