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
 * LogLevel is the basic interface for all levels.
 *
 * <p>It gets used by loggers to write log messages at different levels
 * and to define at which levels messages shall be written.
 *
 * <p>The default levels offered by the as2lib in a descending order are
 * All, Debug, Info, Warning, Error, Fatal and None. All these levels
 * are defined as constants in the {@link AbstractLogLevel} class. Use this class
 * to reference them.
 *
 * <p>It is also possible to create your own log levels. You just must
 * implement this interface or just instantiate one using the
 * {@link DynamicLogLevel} class.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.log.LogLevel extends BasicInterface {
	
	/**
	 * Determines whether this level is greater or equal than the one passed-in.
	 *
	 * <p>This is normally done using the number representation of this level
	 * and comparing it using the greater or equal operator with the number
	 * representation of the passed-in level.
	 *
	 * @param level the level this level shall be compared with
	 * @return true if this level is greater or equal than the passed-in one
	 */
	public function isGreaterOrEqual(level:LogLevel):Boolean;
	
	/**
	 * Returns the number representation of this level.
	 *
	 * <p>Gets used to compare levels with each other.
	 *
	 * @return the number representation of this level
	 */
	public function toNumber(Void):Number;
	
	/**
	 * Returns the string representation of this level.
	 *
	 * <p>Gets used when the level shall be shown together with the log
	 * message.
	 *
	 * @return the string representation of this level
	 */
	public function toString(Void):String;
	
}