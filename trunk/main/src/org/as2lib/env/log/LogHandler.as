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

import org.as2lib.env.event.EventListener;
import org.as2lib.env.log.LogMessage;

/**
 * LogHandler is the base interface for all concrete handlers. Handers 
 * are used to write information to the output target.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.log.LogHandler extends EventListener {
	
	/**
	 * Writes information obtained from the message parameter as well as additional 
	 * information to the output target. It is not prescribed which information will be 
	 * written. Hence it depends on the concrete handler.
	 *
	 * @param message the message containing the basic information
	 */
	public function write(message:LogMessage):Void;
	
}