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
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.SimpleStack;

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
	
	/**
	 * Checks if the array already contains the passed object.
	 * It checks the content with a for-in loop. In this way all arrays can
	 * be passed in.
	 *
	 * @param array The array that shall contain the object.
	 * @param object The object that shall be checked for availability.
	 * @return true if the array contains the object else false
	 */
	public static function contains(array:Array, object):Boolean {
		for (var i:String in array) {
			if (array[i] === object) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Checks the index of a object within a array.
	 * It checks the content of a array by counting to the array length.
	 * It will return the first occurency of the object within the array.
	 * If the object wasn't found -1 will be returned.
	 *
	 * @param array The array that shall contain the object.
	 * @param object The object to get the position from.
	 * @return The number of the object within the array (if it was not found -1)
	 */
	public static function indexOf(array:Array, object):Number{
		for(var i:Number = array.length; i >= 0; i--){
			if(array[i] === object) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * Converts the passed Array to a Stack. The Boolean determines whether
	 * the Array shall be converted in asceding or descending order. Pass true
	 * for ascending and false for descending order.
	 *
	 * @param array the Array to be converted
	 * @param order Boolean value specifying the convertion order
	 * @return the Stack representation of the Array
	 */
	public static function toStack(array:Array, order:Boolean):Stack {
		var result:Stack = new SimpleStack();
		if (!order) {
			array.reverse();
		}
		for (var i:Number = 0; i < array.length; i++) {
			result.push(array[i]);
		}
		return result;
	}
}