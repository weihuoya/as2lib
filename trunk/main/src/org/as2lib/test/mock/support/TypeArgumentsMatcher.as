﻿/**
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
class org.as2lib.test.mock.support.TypeArgumentsMatcher extends BasicClass implements ArgumentsMatcher {
	
	/** Stores the expected types. */
	private var expectedTypes:Array;
	
	/**
	 * Constructs a new instance.
	 * 
	 * @param expectedTypes the expected types of the arguments
	 */
	public function TypeArgumentsMatcher(expectedTypes:Array) {
		this.expectedTypes = expectedTypes;
	}
	
	/**
	 * Compares the actual arguments only by type.
	 *
	 * <p>False will be returned if:
	 * <ul>
	 *   <li>The lengths of the expected and actual arguments differ.</li>
	 *   <li>The lengths of the expected types and the actual arguments differ.</li>
	 *   <li>Any actual argument is not of the expected type.</li>
	 * </ul>
	 *
	 * @param expectedArgumens the expected arguments
	 * @param actualArguments the actual arguments
	 * @see ArgumentsMatcher#matchArguments()
	 */
	public function matchArguments(expectedArguments:Array, actualArguments:Array):Boolean {
		if (expectedArguments.length != actualArguments.length) return false;
		if (actualArguments.length != expectedTypes.length) return false;
		for (var i:Number = 0; i < expectedArguments.length; i++) {
			if (!(actualArguments[i] instanceof expectedTypes[i])) {
				return false;
			}
		}
		return true;
	}
	
}