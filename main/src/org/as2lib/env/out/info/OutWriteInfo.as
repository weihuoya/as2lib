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

import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.core.BasicClass;

/**
 * OutWriteInfo is a dumb model that contains all the information needed by the OutHandlers
 * #write() operation. These information include the OutLevel the output has as 
 * well as the message that shall be written out.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.info.OutWriteInfo extends BasicClass implements EventInfo {
	/** The message that shall be written out. */
	private var message:String;
	
	/** The OutLevel the output has. */
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 * 
	 * @param message the message that shall be written out
	 * @param level the level of the output
	 */
	public function OutWriteInfo(aMessage:String, aLevel:OutLevel) {
		message = aMessage;
		level = aLevel;
	}
	
	/**
	 * Returns the OutLevel of the output. This OutLevel has been set during instantiation.
	 *
	 * @return the level of the output
	 */
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	/**
	 * Returns the message that shall be written out. This message has been set during instantiation.
	 *
	 * @return message the message that shall be written out
	 */
	public function getMessage(Void):String {
		return message;
	}
	
	/**
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return "write";
	}
}