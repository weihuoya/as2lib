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
 * @author Simon Wacker
 */
class org.as2lib.data.holder.list.ArrayList extends BasicClass implements List {
	
	/** Stringifies lists. */
	private static var stringifier:Stringifier;
	
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
	 * Constructs a new ArrayList instance.
	 *
	 * @param source (optional) an array that contains values to populate the new list with
	 */
	public function ArrayList(source:Array) {
		if (source) {
			data = source.concat();
		} else {
			data = new Array();
		}
	}
	
	public function insert(value):Void {
		insertLast(value);
	}
	
	public function insertFirst(value):Void {
		data.unshift(value);
	}
	
	public function insertLast(value):Void {
		data.push(value);
	}
	
	public function insertAll(list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			insertLast(iterator.next());
		}
	}
	
	public function remove() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], removeByValue);
		o.addHandler([Number], removeByIndex);
		o.forward(arguments);
	}
	
	public function removeByValue(value):Void {
		data.splice(indexOf(value), 1);
	}
	
	public function removeByIndex(index:Number) {
		var result = data[index];
		data.splice(index, 1);
		return result;
	}
	
	public function removeFirst(Void) {
		return data.shift();
	}
	
	public function removeLast(Void) {
		return data.pop();
	}
	
	public function removeAll(list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			removeByValue(iterator.next());
		}
	}
	
	public function set(index:Number, value) {
		var result = data[index];
		data[index] = value;
		return result;
	}
	
	public function setAll(index:Number, list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			var obj = iterator.next();
			this.set(index++, obj);
		}
	}
	
	public function get(index:Number) {
		return data[index];
	}
	
	public function contains(value):Boolean {
		return (indexOf(value) > -1);
	}
	
	public function containsAll(list:List):Boolean {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			if (!contains(iterator.next())) {
				return false;
			}
		}
		return true;
	}
	
	public function retainAll(list:List):Void {
		var i:Number = data.length;
		while(--i-(-1)) {
			if (!list.contains(data[i])) {
				removeByIndex(i);
			}
		}
	}
	
	public function clear(Void):Void {
		data = new Array();
	}
	
	public function size(Void):Number {
		return data.length;
	}
	
	public function isEmpty(Void):Boolean {
		return (data.length < 1);
	}
	
	public function iterator(Void):Iterator {
		return (new ArrayIterator(data));
	}
	
	public function indexOf(value):Number {
		var l = data.length;
		while (data[--l] !== value && l>-1);
		return l;
	}
	
	public function toArray(Void):Array {
		return data.concat();
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}