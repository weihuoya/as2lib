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
 * That means you can pass-in messages and let the actual handler or logger
 * decide how to produce a string representation of the message. That is in
 * most cases done by using the toString method of the specific message.
 * You can use this method to do not lose performance in cases where
 * the message does not get logged.
 *
 * <p>The actaul log output gets made by log handlers. To configure and
 * access the handlers of this logger you can use the methods #addHandler,
 * #removeHandler, #removeAllHandler and #getAllHandler. There are a
 * few pre-defined handlers for different output devices. Take a look
 * at the org.as2lib.env.log.handler package for these.
 *
 * <p>This logger can simply be used as follows:
 * <code>var logger:SimpleLogger = new SimpleLogger();
 * // adds a trace handler that is responsible for making the output
 * logger.addHandler(new TraceHandler());
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
 * @see org.as2lib.env.log.Logger
 */
class org.as2lib.env.log.logger.SimpleLogger extends BasicClass implements ConfigurableLogger {
	
	/** The set level. */
	private var level:LogLevel;
	
	/** The set level as number. */
	private var levelAsNumber:Number;
	
	/** The debug level. */
	private var debugLevel:LogLevel;
	
	/** The debug level as number. */
	private var debugLevelAsNumber:Number;
	
	/** The info level. */
	private var infoLevel:LogLevel;
	
	/** The info level as number. */
	private var infoLevelAsNumber:Number;
	
	/** The warning level. */
	private var warningLevel:LogLevel;
	
	/** The warning level as number. */
	private var warningLevelAsNumber:Number;
	
	/** The error level. */
	private var errorLevel:LogLevel;
	
	/** The error level as number. */
	private var errorLevelAsNumber:Number;
	
	/** The fatal level. */
	private var fatalLevel:LogLevel;
	
	/** The fatal level as number. */
	private var fatalLevelAsNumber:Number;
	
	/** The broadcaster to dispatch the messages to all handlers. */
	private var broadcaster:EventBroadcaster;
	
	/** The name of the logger. */
	private var name:String;
	
	/**
	 * Constructs a new SimpleLogger instance.
	 *
	 * <p>The default log level is ALL. This means all messages regardless
	 * of their level get logged.
	 *
	 * <p>The default broadcaster is of type SpeedEventBroadcaster.
	 *
	 * <p>The logger name is by default shown in the log message to identify
	 * where the message came from.
	 *
	 * @param broadcaster (optional) the name of this logger
	 * @param broadcaster (optional) the broadcaster used to broadcast to the added handlers
	 */
	public function SimpleLogger(name:String, broadcaster:EventBroadcaster) {
		this.name = name;
		this.broadcaster = broadcaster ? broadcaster : new SpeedEventBroadcaster();
		level = AbstractLogLevel.ALL;
		levelAsNumber = level.toNumber();
		debugLevel = AbstractLogLevel.DEBUG;
		debugLevelAsNumber = debugLevel.toNumber();
		infoLevel = AbstractLogLevel.INFO;
		infoLevelAsNumber = infoLevel.toNumber();
		warningLevel = AbstractLogLevel.WARNING;
		warningLevelAsNumber = warningLevel.toNumber();
		errorLevel = AbstractLogLevel.ERROR;
		errorLevelAsNumber = errorLevel.toNumber();
		fatalLevel = AbstractLogLevel.FATAL;
		fatalLevelAsNumber = fatalLevel.toNumber();
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
			this.level = AbstractLogLevel.ALL;
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
	 * Adds a new log handler.
	 *
	 * <p>Log handlers get used to actually log the messages. They determine
	 * what information to log and to which output device.
	 *
	 * <p>This method simply does nothing if the passed-in handler is null
	 * or undefined.
	 *
	 * @param handler the new log handler to log messages
	 */
	public function addHandler(handler:LogHandler):Void {
		if (handler) {
			broadcaster.addListener(handler);
		}
	}
	
	/**
	 * Removes all occerrences of the passed-in log handler.
	 *
	 * <p>If the passed-in handler is null or undefined the method invocation
	 * simply gets ignored.
	 *
	 * @param handler the log handler to remove
	 */
	public function removeHandler(handler:LogHandler):Void {
		if (handler) {
			broadcaster.removeListener(handler);
		}
	}
	
	/**
	 * Removes all added log handlers.
	 */
	public function removeAllHandler(Void):Void {
		broadcaster.removeAllListener();
	}
	
	/**
	 * Returns all handlers that were directly added to this logger.
	 *
	 * <p>If there are no added handlers an empty array gets returned.
	 *
	 * @return all added log handlers
	 */
	public function getAllHandler(Void):Array {
		return broadcaster.getAllListener();
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
	 * @param message the message object to log
	 * @param level the specific level at which the message shall be logged
	 * @see #isEnabled(LogLevel):Boolean
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			broadcaster.dispatch(new LogMessage(message, level, name));
		}
	}
	
	/**
	 * Logs the message object at debug level.
	 *
	 * <p>The message gets only logged when the level is set to debug or
	 * a level above.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled(Void):Boolean
	 */
	public function debug(message):Void {
		if (isDebugEnabled()) {
			broadcaster.dispatch(new LogMessage(message, debugLevel, name));
		}
	}
	
	/**
	 * Logs the message object at info level.
	 *
	 * <p>The message gets only logged when the level is set to info or
	 * a level above.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled(Void):Boolean
	 */
	public function info(message):Void {
		if (isInfoEnabled()) {
			broadcaster.dispatch(new LogMessage(message, infoLevel, name));
		}
	}
	
	/**
	 * Logs the message object at warning level.
	 *
	 * <p>The message gets only logged when the level is set to warning or
	 * a level above.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled(Void):Boolean
	 */
	public function warning(message):Void {
		if (isWarningEnabled()) {
			broadcaster.dispatch(new LogMessage(message, warningLevel, name));
		}
	}
	
	/**
	 * Logs the message object at error level.
	 *
	 * <p>The message gets only logged when the level is set to error or a
	 * level above.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled(Void):Boolean
	 */
	public function error(message):Void {
		if (isErrorEnabled()) {
			broadcaster.dispatch(new LogMessage(message, errorLevel, name));
		}
	}
	
	/**
	 * Logs the message object at fatal level.
	 *
	 * <p>The message gets only logged when the level is set to fatal or a
	 * level above.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled(Void):Boolean
	 */
	public function fatal(message):Void {
		if (isFatalEnabled()) {
			broadcaster.dispatch(new LogMessage(message, fatalLevel, name));
		}
	}
	
}