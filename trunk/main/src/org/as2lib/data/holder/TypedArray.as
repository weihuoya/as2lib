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

import org.as2lib.util.ObjectUtil;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;

/**
 * Acts like a normal Array but assures that only objects from one and the same
 * type are added to the Array.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.data.holder.TypedArray extends Array implements BasicInterface {
	/*public static var CASEINSENSITIVE = Array.CASEINSENSITIVE;
	public static var DESCENDING = Array.DESCENDING;
	public static var NUMERIC = Array.NUMERIC;
	public static var RETURNINDEXDARRAY = Array.RETURNINDEXEDARRAY;
	public static var UNIQUESORT = Array.UNIQUESORT;*/
	
	/** The Array the TypedArray wraps. */
	private var array:Array;
	
	/** The type of values that can be added. */
	private var type:Function;
	
	/**
	 * Constructs a new TypedArray instance.
	 *
	 * @param type the type of the values this TypedArray contains
	 * @param array the Array that shall be wrapped
	 */
	public function TypedArray(type:Function, array:Array) {
		this.type = type;
		this.array = array;
	}
	
	/**
	 * @see Array
	 */
	public function concat():TypedArray {
		var l:Number = arguments.length;
		for (var i:Number = 0; i < l; i++) {
			validate(arguments[i]);
		}
		var result:TypedArray;
		if (l == 0) {
			result = new TypedArray(this.type, this.array.concat());
		} else {
			result = new TypedArray(this.type, this.array.concat(arguments));
		}
		return result;
	}
	
	/**
	 * Checks if the array already contains the passed object.
	 *
	 * @param object the object that shall be checked for availability
	 * @return true if the array contains the object else false
	 */
	/*public function contains(object):Boolean {
		var l:Number = array.length;
		for (var i:Number = 0; i < l; i++) {
			if (array[i] === object) {
				return true;
			}
		}
		return false;
	}*/
	
	/**
	 * Removes all content out of the TypedArray.
	 *
	 * @param 
	 */
	/*public function clear(Void):Void {
		array = new Array();
	}*/
	
	/**
	 * Sets the new value at the given position.
	 * @param number
	 * @param value
	 */
	/*public function setValue(number:Number, value):Void {
		this.array[number] = value;
	}*/
	
	/**
	 * Gets the value associated with the given number.
	 * @param number
	 * @return the value
	 */
	/*public function getValue(number:Number) {
		return this.array[number];
	}*/
	
	/**
	 * @see Array
	 */
	public function join(seperator:String):String {
		return this.array.join(seperator);
	}
	
	/**
	 * @see Array
	 */
	public function pop(Void) {
		return this.array.pop();
	}
	
	/**
	 * @see Array
	 */
	public function push(value):Number {
		validate(value);
		return this.array.push(value);
	}
	
	/**
	 * @see Array
	 */
	public function reverse(Void):Void {
		this.array.reverse();
	}
	
	/**
	 * @see Array
	 */
	public function shift(Void) {
		return this.array.shift();
	}
	
	/**
	 * @see Array
	 */
	public function sort() {
		return this.array.sort.apply(this.array, arguments);
	}
	
	/**
	 * @see Array
	 */

	 public function sortOn() {
		return this.array.sortOn.apply(this.array, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function splice(index:Number, count:Number):Void {
		this.array.splice.apply(this.array, arguments);
	}
	
	/**
	 * @see Array
	 */
	public function unshift(value):Number {
		validate(value);
		return this.array.unshift(value);
	}
	
	/**
	 * @return the type of the array
	 */
	/*public function getType(Void):Function {
		return this.type;
	}*/
	
	/**
	 * @see Array
	 */
	public function get length():Number {
		return this.array.length;
	}
	
	/**
	 * @see #length
	 */
	/*public function getLength():Number {
		return this.length;
	}*/
	
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	public function toString(Void):String {
		return "";
	}
	
	/**
	 * Checks if the object is of correct type.
	 *
	 * @param object the object that shall be type checked
	 * @throws 
	 */
	/**
	 * Validates the passed object based on its type.
	 *
	 * @param object the object which type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].");
		}
	}
}