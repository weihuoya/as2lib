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

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.logger.AbstractLogger;

/**
 * FlashoutLogger delegates all log messages to the appropriate methods
 * of the {@code Flashout} class.
 *
 * <p>Using this class instead of the {@code Flashout} class in your
 * application directly enables you to switch between almost every available
 * logging API without having to change the logging calls, but just the
 * underlying configuration on startup.
 * 
 * <p>Note that this class takes advantage of the As2lib {@code LogMessage}
 * class to format messages with the logger name, a timestamp, the level
 * and the actual message. You can edit the string representation generated
 * by the {@code LogMessage} class manually if you want some information
 * not to be shown.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.log.handler.FlashoutHandler
 */
class org.as2lib.env.log.logger.FlashoutLogger extends AbstractLogger implements Logger {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Function = AbstractLogger;
	
	/** The set level. */
	private var level:LogLevel;
	
	/** The set level as number. */
	private var levelAsNumber:Number;
	
	/** The name of the logger. */
	private var name:String;
	
	/**
	 * Constructs a new FlashoutLogger instance.
	 *
	 * <p>The default log level is {@code ALL}. This means all messages
	 * regardless of their level are logged.
	 *
	 * <p>The logger name is by default shown in the log message to identify
	 * where the message came from.
	 *
	 * @param name (optional) the name of this logger
	 */
	public function FlashoutLogger(name:String) {
		this.name = name;
		level = ALL;
		levelAsNumber = level.toNumber();
	}
	
	/**
	 * Returns the name of this logger.
	 *
	 * <p>This method returns {@code null} if no name has been set via the
	 * {@link #setName} method and on construction.
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
	 * <p>The log level determines which messages are logged and are not.
	 *
	 * <p>A level of value {@code null} or {@code undefined} os interpreted
	 * as level {@code ALL}, which is also the default level.
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
	 * Checks if this logger is enabled for debug level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return {@code true} if debug output is made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#DEBUG
	 * @see #debug
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
	 * @return {@code true} if info output is made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#INFO
	 * @see #info
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
	 * @return {@code true} if warning output is made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#WARNING
	 * @see #warning
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
	 * @return {@code true} if error output is made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#ERROR
	 * @see #error
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
	 * @return {@code true} if fatal output is made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#FATAL
	 * @see #fatal
	 */
	public function isFatalEnabled(Void):Boolean {
		return (levelAsNumber >= fatalLevelAsNumber);
	}
	
	/**
	 * Logs the message object at debug level.
	 *
	 * <p>The message is only logged when the level is set to debug or
	 * a level above.
	 *
	 * <p>The message is logged using the {@code Flashout.debug} method.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled
	 */
	public function debug(message):Void {
		if (isDebugEnabled()) {
			Flashout.debug(new LogMessage(message, debugLevel, name));
		}
	}
	
	/**
	 * Logs the message object at info level.
	 *
	 * <p>The message is only logged when the level is set to info or
	 * a level above.
	 *
	 * <p>The message is logged using the {@code Flashout.info} method.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled
	 */
	public function info(message):Void {
		if (isInfoEnabled()) {
			Flashout.info(new LogMessage(message, infoLevel, name));
		}
	}
	
	/**
	 * Logs the message object at warning level.
	 *
	 * <p>The message is only logged when the level is set to warning or
	 * a level above.
	 *
	 * <p>The message is logged using the {@code Flashout.warning} method.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled
	 */
	public function warning(message):Void {
		if (isWarningEnabled()) {
			Flashout.warning(new LogMessage(message, warningLevel, name));
		}
	}
	
	/**
	 * Logs the message object at error level.
	 *
	 * <p>The message is only logged when the level is set to error or a
	 * level above.
	 *
	 * <p>The message is logged using the {@code Flashout.error} method.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled
	 */
	public function error(message):Void {
		if (isErrorEnabled()) {
			Flashout.error(new LogMessage(message, errorLevel, name));
		}
	}
	
	/**
	 * Logs the message object at fatal level.
	 *
	 * <p>The message is only logged when the level is set to fatal or a
	 * level above.
	 *
	 * <p>The message is logged using the {@code Flashout.error} method.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled
	 */
	public function fatal(message):Void {
		if (isFatalEnabled()) {
			Flashout.error(new LogMessage(message, fatalLevel, name));
		}
	}
	
}