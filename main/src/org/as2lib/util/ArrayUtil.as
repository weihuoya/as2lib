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
import org.as2lib.env.except.IllegalArgumentException;

/**
 * ArrayUtil contains fundamental operations to manipulate Arrays.
 *
 * @author Simon Wacker
 */
class org.as2lib.util.ArrayUtil extends BasicClass {
	/**
	 * Private constructor.
	 */
	private function ArrayUtil(Void) {
	}
	
	/**
	 * Clones an Array.
	 *
	 * @param array the Array to be cloned
	 * @return a clone of the passed in Array
	 */
	public static function clone(array:Array):Array {
		return array.concat();
	}
	
	/**
	 * Removes a specific element out of the Array.
	 *
	 * @param array the Array to remove the element out of
	 * @param element the element to be removed
	 * @throws IllegalArgumentException if the element could not be found in the Array
	 */
	public static function removeElement(array:Array, element):Void {
		var l:Number = array.length;
		for (var i:Number = 0; i <= l; i++) {
			if (array[i] === element) {
				array.splice(i, 1);
				return;
			}
		}
		throw new IllegalArgumentException("The specified element [" + element + "] is not available in the array [" + array + "] and could therefore not be removed.", 
											eval("th" + "is"),
											arguments);
	}
}