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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.log.LogLevel;

/**
 * Logger defines all possible operations to write output at specific levels.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.log.Logger extends BasicInterface {
	
	/**
	 * Checks whether this instance is enabled for a given level passed as
	 * argument.
	 *
	 * @param level the level to make the check upon
	 * @return true if this instance is enabled for the given level else false
	 */
	public function isEnabled(level:LogLevel):Boolean;
	
	/**
	 * Checks if this instance is enabled for debug level output.
	 *
	 * @return true if debug output can be made
	 */
	public function isDebugEnabled(Void):Boolean;
	
	/**
	 * Checks if this instance is enabled for info level output.
	 *
	 * @return true if info output can be made
	 */
	public function isInfoEnabled(Void):Boolean;
	
	/**
	 * Checks if this instance is enabled for warning level output.
	 *
	 * @return true if warning output can be made
	 */
	public function isWarningEnabled(Void):Boolean;
	
	/**
	 * Checks if this instance is enabled for error level output.
	 *
	 * @return true if error output can be made
	 */
	public function isErrorEnabled(Void):Boolean;
	
	/**
	 * Checks if this instance is enabled for fatal level output.
	 *
	 * @return true if fatal output can be made
	 */
	public function isFatalEnabled(Void):Boolean;
	
	/**
	 * @return the currently active level
	 */
	public function getLevel(Void):LogLevel;
	
	/**
	 * Outputs a message object at the given level.
	 *
	 * @param message the message object to be written out
	 * @param level the specific level at which the message shall be written out
	 */
	public function log(message, level:LogLevel):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the level is set to
	 * debug or an above level.
	 *
	 * @param message the message object to be written out
	 * @see LogLevel
	 */
	public function debug(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the level is set to
	 * info or an above level.
	 *
	 * @param message the message object to be written out
	 * @see LogLevel
	 */
	public function info(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the level is set to
	 * warning or an above level.
	 *
	 * @param message the message object to be written out
	 * @see LogLevel
	 */
	public function warning(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the level is set to
	 * error or an above level.
	 *
	 * @param message the message object to be written out
	 * @see LogLevel
	 */
	public function error(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the level is set to
	 * fatal or an above level.
	 *
	 * @param message the message object to be written out
	 * @see LogLevel
	 */
	public function fatal(message):Void;
	
}