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
import org.as2lib.env.out.OutLevel;

/**
 * OutAccess defines all possible operations to write output at specific OutLevels.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutAccess extends BasicInterface {
	
	/**
	 * Checks whether this OutAccess instance is enabled for a given OutLevel passed as
	 * parameter.
	 *
	 * @param level the OutLevel to make the check upon
	 * @return true if this Out instance is enabled for the given OutLevel else false
	 */
	public function isEnabled(level:OutLevel):Boolean;
	
	/**
	 * Checks if this instance is enabled for log level output.
	 *
	 * @return true if log output can be made
	 */
	public function isLogEnabled(Void):Boolean;
	
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
	 * Returns the currently set OutLevel.
	 *
	 * @return the OutLevel
	 */
	public function getLevel(Void):OutLevel;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set
	 * to Out.ALL.
	 *
	 * @param message the message object to be written out
	 */
	public function log(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.DEBUG or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function debug(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.INFO or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function info(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.WARNING or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function warning(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.ERROR or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function error(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.FATAL or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function fatal(message):Void;
	
}