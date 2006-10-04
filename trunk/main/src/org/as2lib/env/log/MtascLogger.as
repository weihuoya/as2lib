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
import org.as2lib.env.log.LogMessage;

/**
 * {@code MtascLogger} serves to add support of the MTASC trace functionality
 * to the Logger classes. 
 * 
 * @author Igor Sadovskiy
 */
interface org.as2lib.env.log.MtascLogger extends BasicInterface {
	
	/** Logs the passed-in instance of the {@code LogMessage}.
	 * 
	 * Uses information stored inside {@code message} to determine if it 
	 * has enough level to be logged with the specific {@code MtascLogger} 
	 * instance. 
	 *
	 * @param message the message to log
	 */
	public function logMessage(message:LogMessage):Void;
}