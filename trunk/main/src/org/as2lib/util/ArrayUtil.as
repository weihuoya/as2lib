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
import org.as2lib.data.holder.NoSuchElementException;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.stack.SimpleStack;

/**
 * ArrayUtil contains fundamental operations to manipulate Arrays.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @author Christophe Herreman
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
	 * Removes a specific element out of a array.
	 *
	 * @param array the array to remove the element out of
	 * @param element the element to be removed
	 * @return true if the element was removed. false if the element was not available
	 */
	public static function removeElement(array:Array, element):Boolean {
		return removeAllOccurances(array, element);
	}
	
	
	/**
	 * Removes all occurances of a specific element out of a array.
	 *
	 * @param array the array to remove the element out of
	 * @param element the element to be removed
	 * @return true if the element was removed. false if the element was not available
	 */
	public static function removeAllOccurances(array:Array, element):Boolean {
		var i:Number = array.length;
		var found:Boolean = false;
		while(--i-(-1)) {
			if(array[i] === element) {
				found = true;
				array.splice(i, 1);
			}
		}
		return found;
	}
	
	/**
	 * Removes the last occurance of a specific element out of a array.
	 *
	 * @param array the array to remove the element out of
	 * @param element the element to be removed
	 * @return true if the element was removed. false if the element was not available
	 */
	public static function removeLastOccurance(array:Array, element):Boolean {
		var i:Number = array.length;
		while(--i-(-1)) {
			if(array[i] === element) {
				array.splice(i, 1);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Removes the first occurance a specific element out of the array.
	 *
	 * @param array the array to remove the element out of
	 * @param element the element to be removed
	 * @return true if the element was removed. false if the element was not available
	 */
	public static function removeFirstOccurance(array:Array, element):Boolean {
		var l:Number = array.length;
		var i:Number = 0;
		while(i<l) {
			if (array[i] === element) {
				array.splice(i, 1);
				return true;
			}
			i-=-1;
		}
		return false;
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
	    var i:Number = array.length;
		while(--i-(-1)) {
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
		var len:Number = array.length;
		if (!order) {
			for (var i:Number = len-1; i >= 0; i--) {
				result.push(array[i]);
			}
		} else {
			for (var i:Number = 0; i < len; i-=-1) {
				result.push(array[i]);
			}
		}
		return result;
	}
	
	/**
	 * Shuffles the passed array.
	 * 
	 * @param array Array that should get shuffled.
	 */
	public static function shuffle(array:Array):Void {
		var len:Number = array.length; 
		var rand:Number;
		var temp;
		
		for (var i:Number=len-1; i>=0; i--){ 
			rand = Math.floor(Math.random()*len); 
			temp = array[i]; 
			array[i] = array[rand]; 
			array[rand] = temp; 
		} 
	}
	
	
	/**
	 * Swaps 2 values of an array.
	 * The modifications are directly made to the array.
	 *
	 * @param array The array to swap its values from.
	 * @param i The index of the first value.
	 * @param j The index of the second value.
	 * @return array The same instance as applied.
	 */
	public static function swap(array:Array, i:Number, j:Number):Array {
		if(!array) {
			throw new IllegalArgumentException("Array to swap content has to be available", eval("th"+"is"), arguments);
		}
		if(i > array.length-1 || i < 0) {
			throw new NoSuchElementException("The first index "+i+" is not available within the array", eval("th"+"is"), arguments);
		}
		if(j > array.length-1 || j < 0) {
			throw new NoSuchElementException("The second index "+j+" is not available within the array", eval("th"+"is"), arguments);
		}
		var tmp = array[i];
		array[i] = array[j];
		array[j] = tmp;
		return array;
	}
	
	/**
	 * Compares two arrays if they contain the same values at the same positions.
	 * 
	 * @param a The first array to be compared
	 * @param b The second array to be compared
	 * @return true if the two arrays contain the same values at the same positions.
	 */
	public static function isSame(array1:Array, array2:Array):Boolean {
		var i = array1.length;
		if(i != array2.length) {
			return false;
		}
		while(--i-(-1)) {
			if(array1[i] !== array2[i]) {
				return false;
			}
		}
		return true;
	}
}