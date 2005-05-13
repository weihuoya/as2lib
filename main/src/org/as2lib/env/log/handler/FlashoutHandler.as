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

import org.as2lib.util.Stringifier;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.AbstractLogHandler;

/**
 * {@code FlashoutHandler} logs messages to the Flashout console.
 *
 * <p>The {@code Flashout} class is needed.
 * 
 * @author Simon Wacker
 * @see org.as2lib.env.log.logger.FlashoutLogger
 * @see <a href="http://www.potapenko.com/flashout">Flashout</a>
 */
class org.as2lib.env.log.handler.FlashoutHandler extends AbstractLogHandler implements LogHandler {
	
	/** Holds a flashout handler. */
	private static var flashoutHandler:FlashoutHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * <p>The {@code messageStringifier} argument is only recognized on first
	 * invocation of this method.
	 *
	 * @param messageStringifier (optional) the log message stringifier to be used by
	 * the returned handler
	 * @return a flashout handler
	 */
	public static function getInstance(messageStringifier:Stringifier):FlashoutHandler {
		if (!flashoutHandler) flashoutHandler = new FlashoutHandler(messageStringifier);
		return flashoutHandler;
	}
	
	/**	
	 * Constructs a new {@code FlashoutHandler} instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So think about
	 * using the handler returned by the static {@link #getInstance} method. Using this
	 * instance prevents the instantiation of unnecessary flashout handlers and
	 * saves storage.
	 * 
	 * @param messageStringifier (optional) the log message stringifier to use
	 */
	public function FlashoutHandler(messageStringifier:Stringifier) {
		super (messageStringifier);
	}
	
	/**
	 * Writes log messages to the Flashout console.
	 *
	 * <p>The string representation of the {@code message} to log is obtained via
	 * the {@code convertMessage} method.
	 *
	 * @param message the message to log
	 * @todo log directly to the console without help of the {@code Flashout} class
	 */
	public function write(message:LogMessage):Void {
		var m:String = convertMessage(message);
		switch (message.getLevel()) {
			case AbstractLogLevel.DEBUG:
				Flashout["async" + "Log"]("debug_log", m);
				break;
			case AbstractLogLevel.INFO:
				Flashout["async" + "Log"]("info_log", m);
				break;
			case AbstractLogLevel.WARNING:
				Flashout["async" + "Log"]("warning_log", m);
				break;
			case AbstractLogLevel.ERROR:
				Flashout["async" + "Log"]("error_log", m);
				break;
			case AbstractLogLevel.FATAL:
				Flashout["async" + "Log"]("error_log", m);
				break;
			default:
				Flashout["async" + "Log"]("default_log", m);
				break;
		}
	}
	
}