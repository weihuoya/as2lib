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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.logger.AbstractLogger;
import org.as2lib.env.log.level.DynamicLogLevel;

import LuminicBox.Log.Level;
import LuminicBox.Log.IPublisher;

/**
 * LuminicBoxLogger acts as a wrapper for a {@code Logger} instance of
 * the LuminicBox Logging API.
 *
 * <p>All functionalities that the LuminicBox Logging API offers are
 * delegated to it. Other functionalities are performed by this class
 * directly.
 *
 * <p>Note that custom levels, others than the one declared by LuminicBox
 * and the As2lib's equivalents, are not supported right now.
 *
 * @author Simon Wacker
 * @see <a href="http://www.luminicbox.com/dev/flash/log">LuminicBox Logging API</a>
 */
class org.as2lib.env.log.logger.LuminicBoxLogger extends AbstractLogger implements Logger {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Function = AbstractLogger;
	
	/** This level is between {@code ALL} and {@code DEBUG}. */
	public static var LOG:LogLevel = new DynamicLogLevel(55, "LOG");
	
	/** The Logger instance of LuminicBox everything is delegated to. */
	private var logger:LuminicBox.Log.Logger;
	
	/** The set level. */
	private var level:LogLevel;
	
	/** The set level as number. */
	private var levelAsNumber:Number;
	
	/** Level {@code ALL}. */
	private var allLevel:LogLevel;
	
	/** Level {@code LOG}. */
	private var logLevel:LogLevel;
	
	/** Level {@code LOG} as number. */
	private var logLevelAsNumber:Number;
	
	/** Level {@code NONE}. */
	private var noneLevel:LogLevel;
	
	/**
	 * Constructs a new {@code LuminicBoxLogger} instance.
	 *
	 * @param name (optional) the name of this logger
	 */
	public function LuminicBoxLogger(name:String) {
		logger = new LuminicBox.Log.Logger(name);
		// todo: ask pablo to implement a getLevel method
		setLevel(logger["_level"]);
		allLevel = DynamicLogLevel.ALL;
		logLevel = LOG;
		logLevelAsNumber = LOG.toNumber();
		noneLevel = DynamicLogLevel.NONE;
	}
	
	/**
	 * Returns the name of this logger.
	 *
	 * @return the name of this logger
	 */
	public function getName(Void):String {
		// todo: ask pablo to implement a getLoggerId method
		return logger["_loggerId"];
	}
	
	/**
	 * Sets the new level.
	 *
	 * <p>The level determines which messages are logged and which are not.
	 *
	 * @param newLevel the new level
	 */
	public function setLevel(newLevel:Level):Void {
		switch (newLevel) {
			case Level.ALL:
				level = allLevel;
				break;
			case Level.LOG:
				level = logLevel;
				break;
			case Level.DEBUG:
				level = debugLevel;
				break;
			case Level.INFO:
				level = infoLevel;
				break;
			case Level.WARN:
				level = warningLevel;
				break;
			case Level.ERROR:
				level = errorLevel;
				break;
			case Level.FATAL:
				level = fatalLevel;
				break;
			case Level.NONE:
				level = noneLevel;
				break;
			default:
				throw new IllegalArgumentException("Unknown log level [" + newLevel + "].", this, arguments);
				break;
		}
		logger.setLevel(newLevel);
		levelAsNumber = level.toNumber();
	}
	
	/**
	 * Returns the log level.
	 *
	 * @return the log level
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * Adds a publisher to the wrapped LuminicBox {@code Logger}.
	 *
	 * @param publisher the publisher to add
	 */
	public function addPublisher(publisher:IPublisher):Void {
		logger.addPublisher(publisher);
	}
	
	/** 
	 * Removes a publisher from the wrapped LuminicBox {@code Logger}.
	 *
	 * @param publisher the publisher to remove
	 */
	public function removePublisher(publisher:IPublisher):Void {
		logger.removePublisher(publisher);
	}
	
	/**
	 * Returns the added publishers of type {@code IPublisher}.
	 *
	 * @return the added publishers
	 * @see #addPublisher
	 */
	public function getPublishers(Void):Array {
		return logger.getPublishers();
	}
	
	/**
	 * Checks whether this logger is enabled for the passed-in log level.
	 *
	 * <p>False will be returned if:
	 * <ul>
	 *   <li>This logger is not enabled for the passed-in level.</li>
	 *   <li>The passed-in level is null or undefined.</li>
	 * </ul>
	 *
	 * @param level the level to make the check upon
	 * @return true if this logger is enabled for the given level else false
	 * @see #log
	 */
	public function isEnabled(level:LogLevel):Boolean {
		if (!level) return false;
		return (levelAsNumber >= level.toNumber());
	}
	
	/**
	 * Checks if this logger is enabled for debug level log messages.
	 *
	 * @return true if debug messages are logged
	 * @see #debug
	 */
	public function isDebugEnabled(Void):Boolean {
		return (levelAsNumber >= debugLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for info level log messages.
	 *
	 * @return true if info messages are logged
	 * @see #info
	 */
	public function isInfoEnabled(Void):Boolean {
		return (levelAsNumber >= infoLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for warning level log messages.
	 *
	 * @return true if warning messages are logged
	 * @see #warning
	 */
	public function isWarningEnabled(Void):Boolean {
		return (levelAsNumber >= warningLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for error level log messages.
	 *
	 * @return true if error messages are logged
	 * @see #error
	 */
	public function isErrorEnabled(Void):Boolean {
		return (levelAsNumber >= errorLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for fatal level log messages.
	 *
	 * @return true if fatal messages are logged
	 * @see #fatal
	 */
	public function isFatalEnabled(Void):Boolean {
		return (levelAsNumber >= fatalLevelAsNumber);
	}
	
	/**
	 * Logs the message object to LuminicBox {@code Logger} at the given
	 * level.
	 *
	 * <p>If the passed-in {@code level} is {@code null} or if it was not
	 * passed-in, the {@code log} method on the Logger of LuminicBox Logging
	 * API is invoked.
	 *
	 * <p>If the passed-in {@code level} is a real level, the log message
	 * is delegated to the appropriate method on the wrapped logger.
	 *
	 * @param message the message object to log
	 * @param level (optional) the specific level at which the message shall
	 * be logged
	 * @throws IllegalArgumentException if the passed-in {@code level} is
	 * a custom one
	 * @see #isEnabled
	 */
	public function log(message, level:LogLevel):Void {
		if (!level) {
			logger.log(message);
		} else {
			switch (levelAsNumber) {
				case logLevelAsNumber:
					logger.log(message);
					break;
				case debugLevelAsNumber:
					logger.debug(message);
					break;
				case infoLevelAsNumber:
					logger.info(message);
					break;
				case warningLevelAsNumber:
					logger.warn(message);
					break;
				case errorLevelAsNumber:
					logger.error(message);
					break;
				case fatalLevelAsNumber:
					logger.fatal(message);
					break;
				default:
					throw new IllegalArgumentException("Custom levels [" + level + "] are not supported by the 'Logger' class of the LuminicBox Logging API.", this, arguments);
			}
		}
	}
	
	/**
	 * Logs the message object to LuminicBox {@code Logger} at debug level.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled
	 */
	public function debug(message):Void {
		logger.debug(message);
	}
	
	/**
	 * Logs the message object to LuminicBox {@code Logger} at info level.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled
	 */
	public function info(message):Void {
		logger.info(message);
	}
	
	/**
	 * Logs the message object to LuminicBox {@code Logger} at warning level.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled
	 */
	public function warning(message):Void {
		logger.warn(message);
	}
	
	/**
	 * Logs the message object to LuminicBox {@code Logger} at error level.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled
	 */
	public function error(message):Void {
		logger.error(message);
	}
	
	/**
	 * Logs the message object to LuminicBox {@code Logger} at fatal level.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled
	 */
	public function fatal(message):Void {
		logger.fatal(message);
	}
	
}