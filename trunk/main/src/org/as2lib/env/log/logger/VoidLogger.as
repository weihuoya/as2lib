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
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.HierarchicalLogger;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.ConfigurableHierarchicalLogger;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.repository.LoggerHierarchy;

/**
 * Logger that redirects all logged messages to nirvana.
 * Dismisses all given logmessages. Saves the level of the Logger but it
 * doesn't care about it.
 *
 * @author Martin Heidegger
 */
class org.as2lib.env.log.logger.VoidLogger extends BasicClass implements Logger, ConfigurableHierarchicalLogger {
	
	/** The actual level. */
	private var level:LogLevel;
	
	/** Stores the parent. */
	private var parent:HierarchicalLogger;
	
	/** The name of this logger. */
	private var name:String;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param name the name of the new logger
	 */
	public function VoidLogger(name:String) {
		setName(name);
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
	 * @see HierarchicalLogger#getAllHandler
	 */
	public function getAllHandler(Void):Array {
		return [];
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
	}
	
	/**
	 * @see Logger#debug()
	 */
	public function debug(message):Void {}
	
	/**
	 * @see Logger#info()
	 */
	public function info(message):Void {}
	
	/**
	 * @see Logger#warning()
	 */
	public function warning(message):Void {}
	
	/**
	 * @see Logger#error()
	 */
	public function error(message):Void {}
	
	/**
	 * @see Logger#fatal()
	 */
	public function fatal(message):Void {}
	
}