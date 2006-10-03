﻿/*
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

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.logger.AbstractLogger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.message.MtascLogMessage;
import org.as2lib.env.log.message.SimpleLogMessage;

/**
 * {@code TraceLogger} logs messages using {@code trace}.
 * 
 * <p>The actual logging is always made using {@code trace}. No other output 
 * devices are supported. Use the {@link SimpleLogger} to be able to add log
 * handlers as you please which allows you to log to every device you want.
 * 
 * <p>The basic methods to write the log messages are {@link #log}, {@link #debug},
 * {@link #info}, {@link #warning} and {@link #fatal}.
 *
 * <p>The first thing to note is that you can log messages at different levels.
 * These levels are {@code DEBUG}, {@code INFO}, {@code WARNING}, {@code ERROR}
 * and {@code FATAL}. Depending on what level has been set only messages at a
 * given level are logged. The levels are organized in a hierarchical manner. That
 * means if you set the log level to {@code ALL} every messages is logged. If you
 * set it to {@code ERROR} only messages at {@code ERROR} and {@code FATAL} level
 * are logged and so on.
 *
 * <p>To do not waste unnecessary performance in constructing log messages that are
 * not logged you can use the {@link #isDebugEnabled}, {@link #isInfoEnabled},
 * {@link #isWarningEnabled}, {@link #isErrorEnabled} and {@link #isFatalEnabled}
 * methods.
 *
 * <p>Note that the message does in neither case have to be a string. That means
 * you can pass-in messages and let the actual handler or logger decide how to
 * produce a string representation of the message. That is in most cases done by
 * using the {@code toString} method of the specific message. You can use this
 * method to do not lose performance in cases where the message is not logged.
 *
 * <p>Example:
 * <code>
 *   var logger:TraceLogger = new TraceLogger("myTraceLogger");
 *   // checks if the output gets actually made
 *   if (logger.isInfoEnabled()) {
	     // log the message at the info level
 *       logger.info("This is a informative log message.");
 *   }
 * </code>
 * 
 * <p>This logger cannot be used with the {@link LoggerHierarchy} because it does
 * not offer hierarchy support. If you want to use your logger in a hierarchy use
 * the {@link SimpleHierarchicalLogger} instead.
 *
 * @author Simon Wacker
 * @author Igor Sadovskiy
 * 
 * @see org.as2lib.env.log.handler.TraceHandler
 */
class org.as2lib.env.log.logger.TraceLogger extends AbstractLogger implements Logger {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Object = AbstractLogger;
	
	/**
	 * Proxy trace method for MTASC that directly outputs the specified {@code message} to
	 * the standard Macromedia Flash trace console.
	 * 
	 * <p>You can use this method as trace method for MTASC's trace support:
	 * <code>mtasc ... -trace org.as2lib.env.log.logger.TraceLogger.trace</code>
	 * 
	 * @param message the message to log
	 * @param location the fully qualified name of the class and method which invoked the
	 * {@code trace} method separated by "::"
	 * @param fileName the name of the source file which defines the class and method
	 * which called the {@code trace} method
	 * @param lineNumber the line number in the file at which the {@code trace} method was
	 * called
	 */
	public static function trace(message, location:String, fileName:String, lineNumber:Number):Void {
		_global.trace(new MtascLogMessage(message, location, fileName, lineNumber));
	}
	
	/** The set level. */
	private var level:LogLevel;
	
	/** The set level as number. */
	private var levelAsNumber:Number;
	
	/** The name of this logger. */
	private var name:String;
	
	/**
	 * Constructs a new {@code TraceLogger} instance.
	 *
	 * <p>The default log level is {@code ALL}. This means all messages regardless of
	 * their level are logged.
	 *
	 * <p>The {@code name} is by default shown in the log message to identify where
	 * the message came from.
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
	 * <p>This method returns {@code null} if no name has been set via the
	 * {@link #setName} method nor on construction.
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
	 * <p>The log level determines which messages are logged and which are not.
	 *
	 * <p>A level of value {@code null} or {@code undefined} is interpreted as level
	 * {@code ALL} which is also the default level.
	 *
	 * @param level the new log level
	 */
	public function setLevel(level:LogLevel):Void {
		if (level) {
			this.level = level;
		} else {
			this.level = ALL;
		}
		this.levelAsNumber = this.level.toNumber();
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
	 * Checks whether this logger is enabled for the passed-in {@code level}.
	 *
	 * <p>{@code false} will be returned if:
	 * <ul>
	 *   <li>This logger is not enabled for the passed-in {@code level}.</li>
	 *   <li>The passed-in {@code level} is {@code null} or {@code undefined}.</li>
	 * </ul>
	 *
	 * <p>Using this method as shown in the class documentation may improve performance
	 * depending on how long the log message construction takes.
	 *
	 * @param level the level to make the check upon
	 * @return {@code true} if this logger is enabled for the given {@code level} else
	 * {@code false}
	 * @see #log
	 */
	public function isEnabled(level:LogLevel):Boolean {
		if (!level) return false;
		return (levelAsNumber >= level.toNumber());
	}
	
	/**
	 * Checks if this logger is enabled for debug level log messages.
	 *
	 * <p>Using this method as shown in the class documentation may improve performance
	 * depending on how long the log message construction takes.
	 *
	 * @return {@code true} if debug messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#DEBUG
	 * @see #debug
	 */
	public function isDebugEnabled(Void):Boolean {
		return (levelAsNumber >= debugLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for info level log messages.
	 *
	 * <p>Using this method as shown in the class documentation may improve performance
	 * depending on how long the log message construction takes.
	 *
	 * @return {@code true} if info messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#INFO
	 * @see #info
	 */
	public function isInfoEnabled(Void):Boolean {
		return (levelAsNumber >= infoLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for warning level log messages.
	 *
	 * <p>Using this method as shown in the class documentation may improve performance
	 * depending on how long the log message construction takes.
	 *
	 * @return {@code true} if warning messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#WARNING
	 * @see #warning
	 */
	public function isWarningEnabled(Void):Boolean {
		return (levelAsNumber >= warningLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for error level log messages.
	 *
	 * <p>Using this method as shown in the class documentation may improve performance
	 * depending on how long the log message construction takes.
	 *
	 * @return {@code true} if error messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#ERROR
	 * @see #error
	 */
	public function isErrorEnabled(Void):Boolean {
		return (levelAsNumber >= errorLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for fatal level log messages.
	 *
	 * <p>Using this method as shown in the class documentation may improve performance
	 * depending on how long the log message construction takes.
	 *
	 * @return {@code true} if fatal messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#FATAL
	 * @see #fatal
	 */
	public function isFatalEnabled(Void):Boolean {
		return (levelAsNumber >= fatalLevelAsNumber);
	}
	
	/**
	 * Logs the passed-in {@code message} at the given {@code level}.
	 *
	 * <p>The {@code message} is only logged when this logger is enabled for the
	 * passed-in {@code level}.
	 *
	 * <p>The {@code message} is always logged using {@code trace}.
	 *
	 * @param message the message object to log
	 * @param level the specific level at which the {@code message} shall be logged
	 * @see #isEnabled
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			_global.trace(new SimpleLogMessage(message, level, name));
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at debug level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code DEBUG} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code trace}.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled
	 */
	public function debug(message):Void {
		if (isDebugEnabled()) {
			log(message, debugLevel);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at info level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code INFO} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code trace}.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled
	 */
	public function info(message):Void {
		if (isInfoEnabled()) {
			log(message, infoLevel);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at warning level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code WARNING}
	 * or a level above.
	 *
	 * <p>The {@code message} is always logged using {@code trace}.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled
	 */
	public function warning(message):Void {
		if (isWarningEnabled()) {
			log(message, warningLevel);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at error level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code ERROR} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code trace}.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled
	 */
	public function error(message):Void {
		if (isErrorEnabled()) {
			log(message, errorLevel);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at fatal level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code FATAL} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code trace}.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled
	 */
	public function fatal(message):Void {
		if (isFatalEnabled()) {
			log(message, fatalLevel);
		}
	}
	
}