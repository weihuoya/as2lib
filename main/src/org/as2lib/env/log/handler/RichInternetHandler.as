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

import de.richinternet.utils.Dumper;

import org.as2lib.core.BasicClass;
import org.as2lib.util.Stringifier;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.level.AbstractLogLevel;

/**
 * {@code RichInternetHandler} logs messages to Dirk Eisman's Flex Trace Panel.
 * 
 * <p>The {@code de.richinternet.utils.Dumper} class is needed.
 * 
 * @author Simon Wacker
 * @see org.as2lib.env.log.logger.RichInternetLogger
 * @see <a href="http://www.richinternet.de/blog/index.cfm?entry=EB3BA9D6-A212-C5FA-A9B1B5DB4BB7F555">Flex Trace Panel</a>
 */
class org.as2lib.env.log.handler.RichInternetHandler extends BasicClass implements LogHandler {
	
	/** Holds a rich internet handler. */
	private static var richInternetHandler:RichInternetHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 * 
	 * <p>The {@code logMessageStringifier} argument will only be recognized on first
	 * invocation of this method.
	 *
	 * @param logMessageStringifier (optional) the log message stringifier to use with
	 * this handler
	 * @return a rich internet handler
	 */
	public static function getInstance(logMessageStringifier:Stringifier):RichInternetHandler {
		if (!richInternetHandler) richInternetHandler = new RichInternetHandler(logMessageStringifier);
		return richInternetHandler;
	}
	
	/** The log message stringifier. */
	private var logMessageStringifier:Stringifier;
	
	/**	
	 * Constructs a new {@code RichInternetHandler} instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So think about
	 * using the handler returned by the static {@link #getInstance} method. Using this
	 * instance prevents the instantiation of unnecessary rich internet handlers and
	 * saves storage.
	 * 
	 * @param logMessageStringifier (optional) the log message stringifier to use with
	 * this handler
	 */
	public function RichInternetHandler(logMessageStringifier:Stringifier) {
		this.logMessageStringifier = logMessageStringifier;
	}
	
	/**
	 * Writes log messages to Dirk Eisman's Flex Trace Panel.
	 *
	 * <p>Uses the {@code logMessageStringifier} to get the string representation of
	 * the {@code message} if set. If not, the {@link LogMessage#toString} method to
	 * of the {@code message} will be used.
	 * 
	 * <p>The default level is {@code INFO}. If the {@code message}'s level is {@code FATAL}
	 * it will be logged at {@code ERROR} level because Dirk Eisman's Flex Trace Panel
	 * does not support the {@code FATAL} level.
	 * 
	 * @param message the message to log
	 */
	public function write(message:LogMessage):Void {
		var m:String;
		if (this.logMessageStringifier) {
			m = this.logMessageStringifier.execute(message);
		} else {
			m = message.toString();
		}
		switch (message.getLevel()) {
			case AbstractLogLevel.DEBUG:
				Dumper.trace(m);
				break;
			case AbstractLogLevel.INFO:
				Dumper.info(m);
				break;
			case AbstractLogLevel.WARNING:
				Dumper.warn(m);
				break;
			case AbstractLogLevel.ERROR:
				Dumper.error(m);
				break;
			case AbstractLogLevel.FATAL:
				Dumper.error(m);
				break;
			default:
				Dumper.dump(m);
				break;
		}
	}
	
}