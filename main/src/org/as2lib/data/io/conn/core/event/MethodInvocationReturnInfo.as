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
import org.as2lib.env.event.EventInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.core.event.MethodInvocationReturnInfo extends BasicClass implements EventInfo {
	
	/** The result returned by the invoked method. */
	private var returnValue;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param returnValue the result of the invoked method
	 */
	public function MethodInvocationReturnInfo(returnValue) {
		this.returnValue = returnValue;
	}
	
	/*
	 * Returns the result returned by the invoked method.
	 *
	 * @param the result of the invoked method
	 */
	public function getReturnValue(Void) {
		return returnValue;
	}
	
	/**
	 * @see EventInfo
	 */
	public function getName(Void):String {
		return "onResponse";
	}
	
}