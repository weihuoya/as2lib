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
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;
import org.as2lib.env.out.OutConfig;

/**
 * OutErrorInfo is a dumb model that contains all the information needed by the OutHandlers
 * error() operation. These information include the OutLevel the output has as 
 * well as the Throwable that shall be written out.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.info.OutErrorInfo extends BasicClass implements EventInfo {
	/** The error object that shall be written out. */
	private var error;
	
	/** The OutLevel the output has. */
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 *
	 * @param error the error object that shall be written out
	 * @param level the level of the output
	 */
	public function OutErrorInfo(error, level:OutLevel) {
		this.error = error;
		this.level = level;
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
	 * Returns the error object that shall be written out. This error object has been set
	 * during instantiation.
	 *
	 * @return the error object that shall be written out
	 */
	public function getError(Void) {
		return error;
	}
	
	/**
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return "error";
	}
	
	/**
	 * Uses the Stringifier returned by OutConfig#getErrorStringifier()
	 * to stringify this OutErrorInfo.
	 *
	 * @see org.as2lib.core.BasicInterface
	 */
	public function toString(Void):String {
		return OutConfig.getErrorStringifier().execute(this);
	}
}