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
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.logger.AbstractLogger;

/**
 * SimpleHierarchicalLogger is a simple implementation of the
 * ConfigurableLogger and ConfigurableHierarchicalLogger interfaces.
 *
 * <p>This logger is thus capable of functioning correctly in a hierarchy.
 * It gets normally used within the LoggerHierarchy repository.
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
 * If you do not set a log level the level of its parent gets used to
 * decide whether the message shall be logged.
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
 * This logger does not only use the handlers of itself but also the
 * ones of its parents.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.SimpleHierarchicalLogger extends AbstractLogger implements ConfigurableLogger, ConfigurableHierarchicalLogger {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Function = AbstractLogger;
	
	/** The actual level. */
	private var level:LogLevel;
	
	/** Says whether the handlers array already contains the parents' handlers. */
	private var addedParentHandlers:Boolean;
	
	/** Stores the parent. */
	private var parent:HierarchicalLogger;
	
	/** The name of this logger. */
	private var name:String;
	
	/** Stores the broadcaster to broadcast to all added handlers. */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new SimpleHierarchicalLogger instance.
	 *
	 * <p>The default broadcaster is an instance of type SpeedEventBroadcaster.
	 *
	 * @param name the name of the new logger
	 * @param broadcaster (optional) the broadcaster used to dispatch log messages to all handlers
	 */
	public function SimpleHierarchicalLogger(name:String, broadcaster:EventBroadcaster) {
		setName(name);
		this.broadcaster = broadcaster ? broadcaster : new SpeedEventBroadcaster();
		addedParentHandlers = false;
	}
	
	/**
	 * Returns the parent of this logger that must also be a hierarchical
	 * logger.
	 *
	 * <p>This logger uses the parent to get the log level, if no
	 * one has been set to this logger manually and to get the handlers of
	 * its parents to write the log messages out.
	 *
	 * @return the parent of this logger
	 */
	public function getParent(Void):HierarchicalLogger {
		return parent;
	}
	
	/**
	 * Sets the parent of this logger.
	 *
	 * <p>The parent gets used to obtain needed configuration like handlers
	 * and levels.
	 *
	 * @param parent the parent of this logger
	 */
	public function setParent(parent:HierarchicalLogger):Void {
		this.parent = parent;
	}
	
	/**
	 * Returns the name of this logger.
	 *
	 * <p>The name is a fully qualified name and the different parts are
	 * be separated by periods.
	 * The name could for example be 'org.as2lib.core.BasicClass'.
	 *
	 * @return the name of this logger
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Sets the name of this logger.
	 *
	 * <p>The name must exists of the path as well as the actual identifier.
	 * That means it must be fully qualified.
	 * 
	 * <p>The LoggerHierarchy prescribes that the different parts of the
	 * name must be separated by periods.
	 *
	 * @param name the name of this logger
	 */
	public function setName(name:String):Void {
		this.name = name;
	}
	
	/**
	 * Sets the log level.
	 *
	 * <p>The level determines which output to make and and which to make
	 * not.
	 *
	 * <p>The level is allowed to be set to null or undefined. If you do
	 * so the #getLevel method returns the level of the parent.
	 *
	 * @param level the new level to control the output
	 * @see #getLevel(Void):LogLevel
	 */
	public function setLevel(level:LogLevel):Void {
		this.level = level;
	}
	
	/**
	 * Returns the log level of this logger.
	 *
	 * <p>If the level has not been set, that means is undefined, the level of
	 * the parent will be returned.
	 *
	 * <p>Null or undefined will only be returned if this level is not defined
	 * and the parent's getLevel method returns null or undefined.
	 *
	 * @return the log level of this logger
	 */
	public function getLevel(Void):LogLevel {
		if (level === undefined) return getParent().getLevel();
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
	 * <p>If the passed-in handler has already been added it gets deleted
	 * and added again.
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
	 * Returns all handlers this logger broadcasts to when logging a message.
	 *
	 * <p>These handlers are the once directly added to this logger and the
	 * once of the parents.
	 *
	 * <p>The handlers of the parents are obtained via the parents getAllHandler
	 * method which is supposed to also return the handlers of its parent and
	 * so on.
	 *
	 * <p>This method never returns null but an empty array if there are no
	 * handlers added to this logger nor to its parents.
	 *
	 * <p>Note that this method stores the parents handlers by itself if it
	 * once obtained it. That is when you first log a message. It than always
	 * works with the stored handlers. That means that handlers added to its
	 * parents after the handlers have once been stored are not recognized.
	 *
	 * @return all added log handlers and the ones of the parents
	 */
	public function getAllHandler(Void):Array {
		if (!addedParentHandlers) addParentHandlers();
		return broadcaster.getAllListener();
	}
	
	/**
	 * Adds the parent handlers to the broadcaster.
	 */
	private function addParentHandlers(Void):Void {
		var parentHandlers:Array = getParent().getAllHandler();
		if (parentHandlers) {
			broadcaster.addAllListener(parentHandlers);
		}
		addedParentHandlers = true;
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
		return (getLevel().toNumber() >= level.toNumber());
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
		return (getLevel().toNumber() >= debugLevelAsNumber);
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
		return (getLevel().toNumber() >= infoLevelAsNumber);
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
		return (getLevel().toNumber() >= warningLevelAsNumber);
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
		return (getLevel().toNumber() >= errorLevelAsNumber);
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
		return (getLevel().toNumber() >= fatalLevelAsNumber);
	}
	
	/**
	 * Logs the message object at the given level.
	 *
	 * <p>The message gets only logged when this logger is enabled for
	 * the passed-in log level.
	 *
	 * <p>The message gets broadcasted to all log handlers of this logger
	 * and to the ones of its parents or more specifically to the ones
	 * returned by the parent's getAllHandler method, that normally also
	 * returns the handlers of its parents and so on.
	 *
	 * <p>Note that the handlers of the parents are resloved only once,
	 * when the first message gets logged. They are stored in this logger
	 * to reference them faster.
	 *
	 * @param message the message object to log
	 * @param level the specific level at which the message shall be logged
	 * @see #isEnabled(LogLevel):Boolean
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			var logMessage:LogMessage = new LogMessage(message, level, name);
			if (!addedParentHandlers) addParentHandlers();
			broadcaster.dispatch(logMessage);
		}
	}
	
	/**
	 * Logs the message object at debug level.
	 *
	 * <p>The message gets only logged when the level is set to debug or
	 * a level above.
	 *
	 * <p>The message gets broadcasted to all log handlers of this logger
	 * and to the ones of its parents or more specifically to the ones
	 * returned by the parent's getAllHandler method, that normally also
	 * returns the handlers of its parents and so on.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled(Void):Boolean
	 */
	public function debug(message):Void {
		log(message, debugLevel);
	}
	
	/**
	 * Logs the message object at info level.
	 *
	 * <p>The message gets only logged when the level is set to info or
	 * a level above.
	 *
	 * <p>The message gets broadcasted to all log handlers of this logger
	 * and to the ones of its parents or more specifically to the ones
	 * returned by the parent's getAllHandler method, that normally also
	 * returns the handlers of its parents and so on.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled(Void):Boolean
	 */
	public function info(message):Void {
		log(message, infoLevel);
	}
	
	/**
	 * Logs the message object at warning level.
	 *
	 * <p>The message gets only logged when the level is set to warning or
	 * a level above.
	 *
	 * <p>The message gets broadcasted to all log handlers of this logger
	 * and to the ones of its parents or more specifically to the ones
	 * returned by the parent's getAllHandler method, that normally also
	 * returns the handlers of its parents and so on.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled(Void):Boolean
	 */
	public function warning(message):Void {
		log(message, warningLevel);
	}
	
	/**
	 * Logs the message object at error level.
	 *
	 * <p>The message gets only logged when the level is set to error or a
	 * level above.
	 *
	 * <p>The message gets broadcasted to all log handlers of this logger
	 * and to the ones of its parents or more specifically to the ones
	 * returned by the parent's getAllHandler method, that normally also
	 * returns the handlers of its parents and so on.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled(Void):Boolean
	 */
	public function error(message):Void {
		log(message, errorLevel);
	}
	
	/**
	 * Logs the message object at fatal level.
	 *
	 * <p>The message gets only logged when the level is set to fatal or a
	 * level above.
	 *
	 * <p>The message gets broadcasted to all log handlers of this logger
	 * and to the ones of its parents or more specifically to the ones
	 * returned by the parent's getAllHandler method, that normally also
	 * returns the handlers of its parents and so on.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled(Void):Boolean
	 */
	public function fatal(message):Void {
		log(message, fatalLevel);
	}
	
}