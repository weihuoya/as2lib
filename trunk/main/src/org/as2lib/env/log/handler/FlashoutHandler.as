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
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.level.AbstractLogLevel;

/**
 * FlashoutHandler uses the Flashout class provided by the flashout eclipse
 * plugin to log messages.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.log.logger.FlashoutLogger
 * @see <a href="http://www.potapenko.com/flashout">Flashout</a>
 */
class org.as2lib.env.log.handler.FlashoutHandler extends BasicClass implements LogHandler {
	
	/** Holds a flashout handler. */
	private static var flashoutHandler:FlashoutHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * @return a flashout handler
	 */
	public static function getInstance(Void):FlashoutHandler {
		if (!flashoutHandler) flashoutHandler = new FlashoutHandler();
		return flashoutHandler;
	}
	
	/**	
	 * Constructs a new FlashoutHandler instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So
	 * think about using the handler returned by the static {@link #getInstance}
	 * method.
	 * Using this instance prevents the instantiation of unnecessary flashout
	 * handlers and and saves storage.
	 */
	public function FlashoutHandler(Void) {
	}
	
	/**
	 * Uses the Flashout class to write the log message out.
	 *
	 * <p>Uses the {@link LogMessage#toString} method to obtain the string that
	 * is written out.
	 *
	 * @param message the log message to write out
	 */
	public function write(message:LogMessage):Void {
		switch (message.getLevel()) {
			case AbstractLogLevel.DEBUG:
				Flashout["async" + "Log"]("debug_log", message.toString());
				break;
			case AbstractLogLevel.INFO:
				Flashout["async" + "Log"]("info_log", message.toString());
				break;
			case AbstractLogLevel.WARNING:
				Flashout["async" + "Log"]("warning_log", message.toString());
				break;
			case AbstractLogLevel.ERROR:
				Flashout["async" + "Log"]("error_log", message.toString());
				break;
			case AbstractLogLevel.FATAL:
				Flashout["async" + "Log"]("error_log", message.toString());
				break;
			default:
				Flashout["async" + "Log"]("default_log", message.toString());
				break;
		}
	}
	
}