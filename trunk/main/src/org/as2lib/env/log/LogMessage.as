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
import org.as2lib.util.Stringifier;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessageStringifier;

/**
 * LogMessage is a dumb model that contains all the information about the
 * message to log. That is at least the message itself plus its level.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.LogMessage extends BasicClass implements EventInfo {
	
	/** The currently used stringifier. */
	private static var stringifier:Stringifier;
	
	/** The message object that shall be written out. */
	private var message;
	
	/** The level the output has. */
	private var level:LogLevel;
	
	/**
	 * Returns either the stringifier set via #setStringifier() or the
	 * default one.
	 *
	 * @return the currently used stringifier
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new LogMessageStringifier();
		return stringifier;
	}
	
	/**
	 * Sets a new stringifier to be used by the #toString() operation.
	 *
	 * @param newStringifier the new stringifier to be used
	 */
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	/**
	 * Constructs a new instance.
	 * 
	 * @param message the message object that shall be written out
	 * @param level the level of the message
	 */
	public function LogMessage(message, level:LogLevel) {
		this.message = message;
		this.level = level;
	}
	
	/**
	 * Returns the level of the message.
	 *
	 * @return the level of the message
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * Returns the message object that shall be written out.
	 *
	 * @return message the message object that shall be written out
	 */
	public function getMessage(Void) {
		return message;
	}
	
	/**
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return "write";
	}
	
	/**
	 * Uses the stringifier returned by #getStringifier() to stringify
	 * this instance.
	 *
	 * @see org.as2lib.core.BasicInterface
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}