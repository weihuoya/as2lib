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

import org.as2lib.core.BasicClass;
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
class org.as2lib.env.log.logger.SimpleHierarchicalLogger extends BasicClass implements ConfigurableLogger, ConfigurableHierarchicalLogger {
	
	/** The actual level. */
	private var level:LogLevel;
	
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
	
	/** Stores all added handlers. */
	private var handlers:Array;
	
	/** Stores the parent. */
	private var parent:HierarchicalLogger;
	
	/** The name of this logger. */
	private var name:String;
	
	/** Stores the broadcaster to broadcast to all added handlers. */
	private var broadcaster:EventBroadcaster;
	
	/**
	 * Constructs a new SimpleHierarchicalLogger instance.
	 *
	 * @param name the name of the new logger
	 */
	public function SimpleHierarchicalLogger(name:String) {
		setName(name);
		handlers = new Array();
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
	 * @param handler the new log handler to log messages
	 */
	public function addHandler(handler:LogHandler):Void {
		if (handler) {
			handlers.push(handler);
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
			var i:Number = handlers.length;
			while (--i-(-1)) {
				if (handlers[i] == handler) {
					handlers.splice(i, 1);
				}
			}
		}
	}
	
	/**
	 * Removes all added log handlers.
	 */
	public function removeAllHandler(Void):Void {
		handlers = new Array();
	}
	
	/**
	 * Returns all handlers that were directly added to this logger.
	 *
	 * <p>If there are no added handlers an empty array gets returned.
	 *
	 * <p>This method does never return null or undefined.
	 *
	 * @return all added log handlers
	 */
	public function getAllHandler(Void):Array {
		var parentHandlers:Array = getParent().getAllHandler();
		if (parentHandlers) {
			return handlers.concat(parentHandlers);
		}
		return handlers.concat();
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
	 * @param message the message object to log
	 * @param level the specific level at which the message shall be logged
	 * @see #isEnabled(LogLevel):Boolean
	 */
	public function log(message, level:LogLevel):Void {
		if (isEnabled(level)) {
			var logMessage:LogMessage = new LogMessage(message, level, name);
			var broadcaster:EventBroadcaster = getBroadcaster();
			broadcaster.addAllListener(getAllHandler());
			broadcaster.dispatch(logMessage);
			broadcaster.removeAllListener();
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