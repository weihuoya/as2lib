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
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.logger.AbstractLogger;

/**
 * TraceLogger is a simple implementation of the Logger interface.
 *
 * <p>The actual log output is always made using trace. No other output
 * devices are supported. Use the SimpleLogger to be able to add log
 * handlers as you please which allows you to log to every device you
 * want.
 *
 * <p>The basic methods to write the log messages are #log, #debug,
 * #info, #warning and #fatal.
 *
 * <p>The first thing to note is that you can write log messages at
 * different levels. These levels are DEBUG, INFO, WARNING, ERROR and
 * FATAL. Depending on what level was set only messages at a given
 * level are logged.
 * The levels are organized in a hierarchical manner. That means if you
 * set you log level to ALL every messages get logged. If you set it
 * to ERROR only messages at ERROR and FATAL level get logged and so on.
 * It is also possible to define your own set of levels. You can therefor
 * use the #isEnabled(LogLevel):Boolean and log(*, LogLevel):Boolean
 * methods.
 *
 * <p>To do not waste unnecessary performance in constructing log messages
 * that do not get logged you can use the #isEnabled, #isDebugEnabled,
 * #isInfoEnabled, #isWarningEnabled, #isErrorEnabled and #isFatalEnabled
 * methods.
 *
 * <p>Note that the message does in neither case have to be a string.
 * That means you can pass-in messages as objects, that get stringified
 * by the stringifier of the LogMessage class. The stringifier uses by
 * default the toString method of the message.
 * You can use this method to do not lose performance in cases where
 * the message does not get logged.
 *
 * <p>This logger can simply be used as follows:
 * <code>var logger:TraceLogger = new TraceLogger("myTraceLogger");
 * // checks if the output gets actually made
 * if (logger.isInfoEnabled()) {
	 // log the message at the info level
 *   logger.info("This is a informative log message.");
 * }</code>
 *
 * <p>It cannot be used with the LoggerHierarchy because it does not
 * offer hierarchy support. If you want to use your logger in a hierarchy
 * use the SimpleHierarchicalLogger instead.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.TraceLogger extends AbstractLogger implements Logger {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Function = AbstractLogger;
	
	/** The set level. */
	private var level:LogLevel;
	
	/** The set level as number. */
	private var levelAsNumber:Number;
	
	/** The name of the logger. */
	private var name:String;
	
	/**
	 * Constructs a new TraceLogger instance.
	 *
	 * <p>The default log level is ALL. This means all messages regardless
	 * of their level get logged.
	 *
	 * <p>The logger name is by default shown in the log message to identify
	 * where the message came from.
	 *
	 * @param name (optional) the name of this logger
	 */
	public function TraceLogger(name:String) {
		this.name = name;
		level = ALL;
		levelAsNumber = level.toNumber();
	}
	
	/**
	 * Returns the name of this logger.
	 *
	 * <p>This method returns null if no name has been set via the
	 * #setName method.
	 *
	 * @return the name of this logger
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Sets the name of this logger.
	 *
	 * <p>The name is by default shown in the log message.
	 *
	 * @param name the new name of this logger
	 */
	public function setName(name:String):Void {
		this.name = name;
	}
	
	/**
	 * Sets the log level.
	 *
	 * <p>The log level determines which messages get logged and which do
	 * not get logged.
	 *
	 * <p>A level of value null or undefined gets interpreted as level ALL,
	 * which is also the default level.
	 *
	 * @param level the new log level
	 */
	public function setLevel(level:LogLevel):Void {
		if (level) {
			this.level = level;
			levelAsNumber = level.toNumber();
		} else {
			this.level = ALL;
			levelAsNumber = level.toNumber();
		}
	}
	
	/**
	 * Returns the set level.
	 *
	 * @return the set level
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * Checks whether this logger is enabled for the passed-in log level.
	 *
	 * False will be returned if:
	 * <ul>
	 *   <li>This logger is not enabled for the passed-in level.</li>
	 *   <li>The passed-in level is null or undefined.</li>
	 * </ul>
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @param level the level to make the check upon
	 * @return true if this logger is enabled for the given level else false
	 * @see #log(*, LogLevel):Void
	 */
	public function isEnabled(level:LogLevel):Boolean {
		if (!level) return false;
		return (levelAsNumber >= level.toNumber());
	}
	
	/**
	 * Checks if this logger is enabled for debug level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if debug output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#DEBUG
	 * @see #debug(*):Void
	 */
	public function isDebugEnabled(Void):Boolean {
		return (levelAsNumber >= debugLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for info level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if info output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#INFO
	 * @see #info(*):Void
	 */
	public function isInfoEnabled(Void):Boolean {
		return (levelAsNumber >= infoLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for warning level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if warning output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#WARNING
	 * @see #warning(*):Void
	 */
	public function isWarningEnabled(Void):Boolean {
		return (levelAsNumber >= warningLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for error level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if error output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#ERROR
	 * @see #error(*):Void
	 */
	public function isErrorEnabled(Void):Boolean {
		return (levelAsNumber >= errorLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for fatal level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if fatal output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#FATAL
	 * @see #fatal(*):Void
	 */
	public function isFatalEnabled(Void):Boolean {
		return (levelAsNumber >= fatalLevelAsNumber);
	}
	
	/**
	 * Logs the message object at the given level.
	 *
	 * <p>The message gets only logged when this logger is enabled for
	 * the passed-in log level.
	 *
	 * <p>The message gets always logged using trace.
	 *
	 * @param message the message object to log
	 * @param level the specific level at which the message shall be logged
	 * @see #isEnabled(LogLevel):Boolean
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			trace(new LogMessage(message, level, name));
		}
	}
	
	/**
	 * Logs the message object at debug level.
	 *
	 * <p>The message gets only logged when the level is set to debug or
	 * a level above.
	 *
	 * <p>The message gets always logged using trace.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled(Void):Boolean
	 */
	public function debug(message):Void {
		if (isDebugEnabled()) {
			trace(new LogMessage(message, debugLevel, name));
		}
	}
	
	/**
	 * Logs the message object at info level.
	 *
	 * <p>The message gets only logged when the level is set to info or
	 * a level above.
	 *
	 * <p>The message gets always logged using trace.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled(Void):Boolean
	 */
	public function info(message):Void {
		if (isInfoEnabled()) {
			trace(new LogMessage(message, infoLevel, name));
		}
	}
	
	/**
	 * Logs the message object at warning level.
	 *
	 * <p>The message gets only logged when the level is set to warning or
	 * a level above.
	 *
	 * <p>The message gets always logged using trace.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled(Void):Boolean
	 */
	public function warning(message):Void {
		if (isWarningEnabled()) {
			trace(new LogMessage(message, warningLevel, name));
		}
	}
	
	/**
	 * Logs the message object at error level.
	 *
	 * <p>The message gets only logged when the level is set to error or a
	 * level above.
	 *
	 * <p>The message gets always logged using trace.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled(Void):Boolean
	 */
	public function error(message):Void {
		if (isErrorEnabled()) {
			trace(new LogMessage(message, errorLevel, name));
		}
	}
	
	/**
	 * Logs the message object at fatal level.
	 *
	 * <p>The message gets only logged when the level is set to fatal or a
	 * level above.
	 *
	 * <p>The message gets always logged using trace.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled(Void):Boolean
	 */
	public function fatal(message):Void {
		if (isFatalEnabled()) {
			trace(new LogMessage(message, fatalLevel, name));
		}
	}
	
}