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
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.level.AbstractLogLevel;

import net.hiddenresource.util.alcon.Alcon;

/**
 * AlconHandler uses the {@code net.hiddenresource.util.alcon.Alcon}
 * class from Sascha Balkau to log messages.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.log.logger.AlconLogger
 * @see <a href="http://hiddenresource.corewatch.net/index.php?itemid=17">Alcon</a>
 */
class org.as2lib.env.log.handler.AlconHandler extends BasicClass implements LogHandler {
	
	/** Holds a alcon handler. */
	private static var alconHandler:AlconHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * @return a alcon handler
	 */
	public static function getInstance(Void):AlconHandler {
		if (!alconHandler) alconHandler = new AlconHandler();
		return alconHandler;
	}
	
	/** Determines whether to trace recursively or not. */
	private var recursiveTracing:Boolean;
	
	/**	
	 * Constructs a new {@code AlconHandler} instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So
	 * think about using the handler returned by the static {@link #getInstance}
	 * method.
	 * Using this instance prevents the instantiation of unnecessary alcon
	 * handlers and and saves storage.
	 *
	 * @param recursiveTracing (optional) determines whether messages shall
	 * be traced recursively or not
	 */
	public function AlconHandler(recursiveTracing:Boolean) {
		this.recursiveTracing = recursiveTracing;
	}
	
	/**
	 * Uses the {@code AlconHandler} class to log the message.
	 *
	 * <p>If recursive tracing is turned on, only the original message returned
	 * by {@link LogMessage#getMessage} is passed to the {@code Alcon.trace}
	 * method as parameter, otherwise the string returned by {@link LogMessage#toString}
	 * is used.
	 *
	 * @param message the message to log
	 */
	public function write(message:LogMessage):Void {
		if (this.recursiveTracing) {
			Alcon.trace(message.getMessage(), convertLevel(message.getLevel()), true);
		} else {
			Alcon.trace(message.toString(), convertLevel(message.getLevel()), false);
		}
	}
	
	/**
	 * Converts the As2lib {@code level} into the corresponding Alcon level
	 * number.
	 * 
	 * @param level the As2lib level to convert
	 * @return the corresponding Alcon level number or {@code null}
	 */
	private function convertLevel(level:LogLevel):Number {
		switch (level) {
			case AbstractLogLevel.DEBUG:
				return 0;
			case AbstractLogLevel.INFO:
				return 1;
			case AbstractLogLevel.WARNING:
				return 2;
			case AbstractLogLevel.ERROR:
				return 3;
			case AbstractLogLevel.FATAL:
				return 4;
			default:
				return null;
		}
	}
	
}