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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.log.LogLevel;

/**
 * Logger declares all methods needed to log messages in a well defined
 * and performant way.
 *
 * <p>The basic methods to log messages are {@link #debug}, {@link #info},
 * {@link #warning} and {@link #fatal}.
 *
 * <p>The first thing to note is that you can log messages at different
 * levels. These levels are {@link #DEBUG}, {@link #INFO}, {@link #WARNING},
 * {@link #ERROR} and {@link #FATAL}. Depending on what level has been
 * set only messages at a given level are logged. The levels are organized
 * in a hierarchical manner. That means if you set the log level to {@link #ALL}
 * every messages is logged. If you set it to {@link #ERROR} only messages
 * at {@link #ERROR} and {@link #FATAL} level are logged and so on.
 *
 * <p>To do not waste unnecessary performance in constructing log messages
 * that are not logged you can use the {@link #isDebugEnabled}, {@link #isInfoEnabled},
 * {@link #isWarningEnabled}, {@link #isErrorEnabled} and {@link #isFatalEnabled}
 * methods.
 *
 * <p>Note that the message does in neither case have to be a string.
 * That means you can pass-in messages and let the actual handler or logger
 * decide how to produce a string representation of the message. That is
 * in most cases done by using the {@code toString} method of the specific
 * message. You can use this method to do not lose performance in cases
 * where the message is not logged.
 *
 * <p>The basic workflow of using loggers is as follows:
 * <code>
 *   // MyLogger is an implementation of this interface
 *   var logger:Logger = new MyLogger();
 *   if (logger.isInfoEnabled()) {
 *       logger.info("This is an information message.");
 *   }
 * </code>
 *
 * <p>Note that we are in the above example not setting a log level.
 * This depends on what configuration methods the implementation of this
 * interface offers.
 * 
 * <p>Note also that depending on the concrete implementation and the message
 * it may be faster to do not call any of the {@code is*Enabled} methods.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.log.Logger extends BasicInterface {
	
	/**
	 * Checks if this logger is enabled for debug level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if debug output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#DEBUG
	 * @see #debug
	 */
	public function isDebugEnabled(Void):Boolean;
	
	/**
	 * Checks if this logger is enabled for info level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if info output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#INFO
	 * @see #info
	 */
	public function isInfoEnabled(Void):Boolean;
	
	/**
	 * Checks if this logger is enabled for warning level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if warning output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#WARNING
	 * @see #warning
	 */
	public function isWarningEnabled(Void):Boolean;
	
	/**
	 * Checks if this logger is enabled for error level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if error output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#ERROR
	 * @see #error
	 */
	public function isErrorEnabled(Void):Boolean;
	
	/**
	 * Checks if this logger is enabled for fatal level output.
	 *
	 * <p>Using this method as shown in the class documentation may improve
	 * performance depending on how long the log message construction takes.
	 *
	 * @return true if fatal output gets made
	 * @see org.as2lib.env.log.level.AbstractLogLevel#FATAL
	 * @see #fatal
	 */
	public function isFatalEnabled(Void):Boolean;
	
	/**
	 * Logs the message object at debug level.
	 *
	 * <p>The message gets only logged when the level is set to debug or
	 * a level above.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled
	 */
	public function debug(message):Void;
	
	/**
	 * Logs the message object at info level.
	 *
	 * <p>The message gets only logged when the level is set to info or
	 * a level above.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled
	 */
	public function info(message):Void;
	
	/**
	 * Logs the message object at warning level.
	 *
	 * <p>The message gets only logged when the level is set to warning or
	 * a level above.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled
	 */
	public function warning(message):Void;
	
	/**
	 * Logs the message object at error level.
	 *
	 * <p>The message gets only logged when the level is set to error or a
	 * level above.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled
	 */
	public function error(message):Void;
	
	/**
	 * Logs the message object at fatal level.
	 *
	 * <p>The message gets only logged when the level is set to fatal or a
	 * level above.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled
	 */
	public function fatal(message):Void;
	
}