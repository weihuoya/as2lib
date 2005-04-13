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

/**
 * {@code MusicTheoryHandler} writes messages to the SWF Console from Ricci Adams'
 * Musictheory.
 * 
 * @author Simon Wacker
 * @see org.as2lib.env.log.logger.MusicTheoryLogger
 * @see <a href="http://source.musictheory.net/swfconsole">SWF Console</a>
 */
class org.as2lib.env.log.handler.MusicTheoryHandler extends BasicClass implements LogHandler {
	
	/** Holds a music theory handler instance. */
	private static var musicTheoryHandler:MusicTheoryHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * @return a music theory handler
	 */
	public static function getInstance(Void):TraceHandler {
		if (!musicTheoryHandler) musicTheoryHandler = new MusicTheoryHandler();
		return musicTheoryHandler;
	}
	
	/**	
	 * Constructs a new {@code MusicTheoryHandler} instance.
	 * 
	 * <p>You can use one and the same instance for multiple loggers. So think about
	 * using the handler returned by the static {@link #getInstance} method. Using
	 * this instance prevents the instantiation of unnecessary music theory handlers
	 * and saves storage.
	 */
	public function MusicTheoryHandler(Void) {
	}
	
	/**
	 * Writes the passed-in {@code message} to the Musictheory SWF Console.
	 * 
	 * <p>The string that is logged is obtained via the {@link LogMessage#toString}
	 * method of the passed-in {@code message}.
	 *
	 * @param message the log message to write
	 */
	public function write(message:LogMessage):Void {
		getURL("javascript:showText('" + message.toString() + "')");
	}
	
}