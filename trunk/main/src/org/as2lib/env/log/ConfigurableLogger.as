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

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogHandler;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.log.ConfigurableLogger extends Logger {
	
	/**
	 * Sets a new level. The level determines which output will be made.
	 *
	 * @param level the new level to control the output
	 * @see LogLevel
	 */
	public function setLevel(level:LogLevel):Void;
	
	/**
	 * Adds a new log handler. These handlers will be used to make the
	 * actual output.
	 *
	 * @param handler the new log handler that shall write output
	 */
	public function addHandler(handler:LogHandler):Void;
	
	/**
	 * Removes the specified log handler.
	 *
	 * @param handler the log handler to remove
	 */
	public function removeHandler(handler:LogHandler):Void;
	
	/**
	 * Removes all registered log handlers.
	 */
	public function removeAllHandler(Void):Void;
	
}