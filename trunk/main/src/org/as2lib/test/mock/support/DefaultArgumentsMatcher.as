/**
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
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultArgumentsMatcher extends BasicClass implements ArgumentsMatcher {
	
	/**
	 * Constructs a new instance.
	 */
	public function DefaultArgumentsMatcher(Void) {
	}
	
	/**
	 * @see ArgumentsMatcher#matchArguments()
	 */
	public function matchArguments(expectedArguments:FunctionArguments, actualArguments:FunctionArguments):Boolean {
		if (expectedArguments.length != actualArguments.length) return false;
		for (var i:Number = 0; i < expectedArguments.length; i++) {
			if (expectedArguments[i] != actualArguments[i]) {
				return false;
			}
		}
		return true;
	}
	
}