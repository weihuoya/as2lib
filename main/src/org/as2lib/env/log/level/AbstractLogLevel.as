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
import org.as2lib.env.except.IllegalArgumentException;

/**
 * AbstractLogLevel acts as a basic access point for the pre-defined levels
 * All, Debug, Info, Warning, Error, Fatal and None.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.level.AbstractLogLevel extends BasicClass implements LogLevel {
	
	/** All output will be made. */
	public static var ALL:LogLevel = new AbstractLogLevel(60, "ALL");
	
	/** All output that is at a lower output level than debug will be made. */
	public static var DEBUG:LogLevel = new AbstractLogLevel(50, "DEBUG");
	
	/** All output that is at a lower output level than info will be made. */
	public static var INFO:LogLevel = new AbstractLogLevel(40, "INFO");
	
	/** All output that is at a lower output level than warning will be made. */
	public static var WARNING:LogLevel = new AbstractLogLevel(30, "WARNINING");
	
	/** All output that is at a lower output level than error will be made. */
	public static var ERROR:LogLevel = new AbstractLogLevel(20, "ERROR");
	
	/** All output that is at a lower output level than fatal will be made. */
	public static var FATAL:LogLevel = new AbstractLogLevel(10, "FATAL");
	
	/** No output will be made. */
	public static var NONE:LogLevel = new AbstractLogLevel(0, "NONE");
	
	/** Stores the level in form of a number. */
	private var level:Number;
	
	/** The name of the level. */
	private var name:String;
	
	/**
	 * Private constructor.
	 *
	 * @param level the level represented by a number
	 * @param name the name of the level
	 * @throws IllegalArgumentException if passed-in level is null or undefined
	 */
	private function AbstractLogLevel(level:Number, name:String) {
		if (level == null) throw new IllegalArgumentException("Level is not allowed to be null or undefined.", this, arguments);
		this.level = level;
		this.name = name;
	}
	
	/**
	 * Compares the number representation of this level with the one of the
	 * passed-in level using the is greater or equal operator.
	 *
	 * True will be returned if:
	 * <ul>
	 *   <li>This level is greater or equal than the passed-in one.</li>
	 *   <li>The passed-in level is null or undefined.</li>
	 * </ul>
	 *
	 * @param level the level to compare this level with
	 * @return true if this level is greater or equal than the passed-in one else false
	 */
	public function isGreaterOrEqual(level:LogLevel):Boolean {
		return (this.level >= level.toNumber());
	}
	
	/**
	 * Returns the number representation of this level.
	 *
	 * <p>The return value is never null or undefined.
	 *
	 * @return the number representation of this level
	 */
	public function toNumber(Void):Number {
		return level;
	}
	
	/**
	 * Returns the string representation of this level.
	 *
	 * @return the string representation of this level
	 */
	public function toString(Void):String {
		return name;
	}
	
}