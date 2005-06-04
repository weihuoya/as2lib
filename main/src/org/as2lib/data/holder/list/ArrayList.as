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
import org.as2lib.data.holder.List;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.util.Stringifier;
import org.as2lib.data.holder.list.ListStringifier;

/**
 * {@code ArrayList} is a resizable-array implementation of {@code List} interface.
 * 
 * @author Simon Wacker
 */
class org.as2lib.data.holder.list.ArrayList extends BasicClass implements List {
	
	/** Stringifies lists. */
	private static var stringifier:Stringifier;
	
	/** Holds added values. */
	private var data:Array;
	
	/**
	 * Returns the stringifier to stringify lists.
	 *
	 * @return the list stringifier
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new ListStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the stringifier to stringify lists.
	 *
	 * @param listStringifier the stringifier to stringify lists
	 */
	public static function setStringifier(listStringifier:Stringifier):Void {
		stringifier = listStringifier;
	}
	
	/**
	 * Constructs a new {@code ArrayList} instance.
	 *
	 * @param source (optional) an array that contains values to populate this new list
	 * with
	 */
	public function ArrayList(source:Array) {
		if (source) {
			data = source.concat();
		} else {
			data = new Array();
		}
	}
	
	/**
	 * Inserts {@code value} at the end of this list.
	 * 
	 * @param value the value to insert
	 * @see #insertLast
	 */
	public function insert(value):Void {
		insertLast(value);
	}
	
	/**
	 * Inserts {@code value} at the beginning of this list.
	 * 
	 * @param value the value to insert
	 */
	public function insertFirst(value):Void {
		data.unshift(value);
	}
	
	/**
	 * Inserts {@code value} at the end of this list.
	 * 
	 * @param value the value to insert
	 * @see #insert
	 */
	public function insertLast(value):Void {
		data.push(value);
	}
	
	/**
	 * Inserts all values contained in {@code list} to the end of this list.
	 * 
	 * @param list the values to insert
	 */
	public function insertAll(list:List):Void {
		var v:Array = list.toArray();
		var l:Number = a.length;
		for (var i:Number = 0; i < l; i++) {
			insertLast(v[i]);
		}
	}
	
	/**
	 * @overload #removeByValue
	 * @overload #removeByIndex
	 */
	public function remove() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], removeByValue);
		o.addHandler([Number], removeByIndex);
		o.forward(arguments);
	}
	
	/**
	 * Removes {@code value} from this list if it exists.
	 * 
	 * @param value the value to remove
	 */
	public function removeByValue(value):Void {
		data.splice(indexOf(value), 1);
	}
	
	/**
	 * Removes the value at given {@code index} from this list and returns it.
	 * 
	 * @param index the index of the value to remove
	 * @return the removed value that was originally at given {@code index}
	 */
	public function removeByIndex(index:Number) {
		var result = data[index];
		data.splice(index, 1);
		return result;
	}
	
	/**
	 * Removes the value at the beginning of this list.
	 * 
	 * @return the removed value
	 */
	public function removeFirst(Void) {
		return data.shift();
	}
	
	/**
	 * Removes the value at the end of this list.
	 * 
	 * @return the removed value
	 */
	public function removeLast(Void) {
		return data.pop();
	}
	
	/**
	 * Removes all values contained in {@code list}.
	 * 
	 * @param list the values to remove
	 */
	public function removeAll(list:List):Void {
		var v:Array = list.toArray();
		var l:Number = v.length;
		for (var i:Number = 0; i < l; i++) {
			removeByValue(v[i]);
		}
	}
	
	/**
	 * Sets {@code value} to given {@code index} on this list.
	 * 
	 * @param index the index of {@code value}
	 * @param value the {@code value} to set to given {@code index}
	 * @return the value that was orignially at given {@code index}
	 */
	public function set(index:Number, value) {
		var result = data[index];
		data[index] = value;
		return result;
	}
	
	/**
	 * Sets all values contained in {@code list} to this list, starting from given
	 * {@code index}.
	 * 
	 * @param index the index to start at
	 * @param list the values to set
	 */
	public function setAll(index:Number, list:List):Void {
		var v:Array = list.toArray();
		var l:Number = v.length;
		for (var i:Number = 0; i < l; i++) {
			this.set(index++, v[i]);
		}
	}
	
	/**
	 * Returns the value at given {@code index}.
	 * 
	 * @param index the index to return the value of
	 * @return the value that is at given {@code index}
	 */
	public function get(index:Number) {
		return data[index];
	}
	
	/**
	 * Checks whether {@code value} is contained in this list.
	 * 
	 * @param value the value to check whether it is contained
	 * @return {@code true} if {@code value} is contained else {@code false}
	 */
	public function contains(value):Boolean {
		return (indexOf(value) > -1);
	}
	
	/**
	 * Checks whether all values of {@code list} are contained in this list.
	 * 
	 * @param list the values to check whether they are contained
	 * @return {@code true} if all values of {@code list} are contained else
	 * {@code false}
	 */
	public function containsAll(list:List):Boolean {
		var v:Array = list.toArray();
		var l:Number = v.length;
		for (var i:Number = 0; i < l; i++) {
			if (!contains(v[i])) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Retains all values the are contained in {@code list} and removes all others.
	 * 
	 * @param list the list of values to retain
	 */
	public function retainAll(list:List):Void {
		var i:Number = data.length;
		while(--i-(-1)) {
			if (!list.contains(data[i])) {
				removeByIndex(i);
			}
		}
	}
	
	/**
	 * Removes all values from this list.
	 */
	public function clear(Void):Void {
		data = new Array();
	}
	
	/**
	 * Returns the number of added values.
	 * 
	 * @return the number of added values
	 */
	public function size(Void):Number {
		return data.length;
	}
	
	/**
	 * Returns whether this list is empty.
	 * 
	 * <p>This list is empty if it has no values assigned to it.
	 * 
	 * @return {@code true} if this list is empty else {@code false}
	 */
	public function isEmpty(Void):Boolean {
		return (data.length < 1);
	}
	
	/**
	 * Returns the iterator to iterate over this list.
	 * 
	 * @return the iterator to iterate over this list
	 */
	public function iterator(Void):Iterator {
		return new ArrayIterator(data);
	}
	
	/**
	 * Returns the index of {@code value}.
	 * 
	 * @param value the value to return the index of
	 * @return the index of {@code value}
	 */
	public function indexOf(value):Number {
		var l = data.length;
		while (data[--l] !== value && l > -1);
		return l;
	}
	
	/**
	 * Returns the array representation of this list.
	 * 
	 * @return the array representation of this list
	 */
	public function toArray(Void):Array {
		return data.concat();
	}
	
	/**
	 * Returns the string representation of this list.
	 * 
	 * <p>The string representation is obtained via the stringifier returned by the
	 * static {@link #getStringifier} method.
	 * 
	 * @return the string representation of this list
	 */
	public function toString():String {
		return getStringifier().execute(this);
	}
	
}