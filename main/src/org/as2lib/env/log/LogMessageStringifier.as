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
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessage;

/**
 * LogMessageStringifier is the default stringifier used by log messages.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.LogMessageStringifier extends BasicClass implements Stringifier {
	
	/**
	 * @see org.as2lib.util.Stringifier
	 */
	public function execute(target):String {
		var message:LogMessage = target;
		return ("** " + message.getLevel() + " ** \n" 
				+ message.getMessage());
	}
	
}