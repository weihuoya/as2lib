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

/**
 * LogLevel is the basic interface for all levels used by loggers. Levels in
 * descending order are: ALL, DEBUG, INFO, WARNING, ERROR, FATAL, NONE.
 * Levels are used to determine if a specific output will be made or not. If
 * you for example set the level to ALL, all output will be made. If you set
 * the level to INFO then info, warning, error and fatal output will be made.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.env.log.LogLevel extends BasicInterface {
	
	/**
	 * Determines whether this level is greater or equal than the one given
	 * as argument.
	 *
	 * @param level the level this level shall be compared with
	 * @return true if this level is greater or equal than the passed one
	 */
	public function isGreaterOrEqual(level:LogLevel):Boolean;
	
	/**
	 * @return the number representation of this level
	 */
	public function toNumber(Void):Number;
	
	/**
	 * @return the string representation of this level
	 */
	public function toString(Void):String;
	
}