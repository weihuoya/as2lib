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

import org.as2lib.data.holder.map.AbstractMap;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.ValueMapIterator;
import org.as2lib.data.holder.map.KeyMapIterator;
import org.as2lib.data.holder.Iterator;

/**
 * @author Michael Herrmann
 * @author Simon Wacker
 */
class org.as2lib.data.holder.map.HashMap extends AbstractMap implements Map {
	
	/** Contains the keys. */
	private var keys:Array;
	
	/** Contains the values. */
	private var values:Array;
	
	/**
	 * Constructs a new HashMap instance.
	 *
	 * <p>The map iterates over the passed-in source with the for..in
	 * loop and uses the variables' names as key and their values as
	 * value. Variables that are hidden from for..in loops will not be
	 * added to the map.
	 *
	 * @param source (optional) an object that contains values to populate the new source with
	 */
	public function HashMap(source) {
		keys = new Array();
		values = new Array();
		populate(source);
	}

	/**
	 * @see org.as2lib.data.holder.Map#containsKey()
	 */
	public function containsKey(key):Boolean {
		return (findKey(key) > -1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#containsValue()
	 */
	public function containsValue(value):Boolean {
		return (findValue(value) > -1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getKeys()
	 */
	public function getKeys(Void):Array {
		return keys.slice();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getValues()
	 */
	public function getValues(Void):Array {
		return values.slice();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#get()
	 */
	public function get(key) {
		return values[findKey(key)];
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#put()
	 */
	public function put(key, value) {
		var result;
		var i:Number = findKey(key); 
		if(i < 0) {
			keys.push(key);
			values.push(value);
		} else {
			result = values[i];
			values[i] = value;
		}
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#clear()
	 */
	public function clear(Void):Void {
		keys = new Array();
		values = new Array();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#putAll()
	 */
	public function putAll(map:Map):Void {
		var values:Array = map.getValues();
		var keys:Array = map.getKeys();
		var l:Number = keys.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			put(keys[i], values[i]);
		}
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#remove()
	 */
	public function remove(key) {
		var i:Number = findKey(key);
		if(i > -1) {
			var result = values[i];
			values.splice(i, 1);
			keys.splice(i, 1);
			return result;
		}
		return;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#iterator()
	 */
	public function iterator(Void):Iterator {
		return new ValueMapIterator(this);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#valueIterator()
	 */
	public function valueIterator(Void):Iterator {
		return iterator();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#keyIterator()
	 */
	public function keyIterator(Void):Iterator {
		return new KeyMapIterator(this);
	}

	/**
	 * @see org.as2lib.data.holder.Map#size()
	 */
	public function size(Void):Number {
		return keys.length;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (size() < 1);
	}
	
	/**
	 * Searches for the value and returns the index where it is stored.
	 *
	 * @return the index where the value is stored
	 */
	private function findValue(value):Number {
		var l = values.length;
		while (values[--l] !== value && l>-1);
		return l;
	}
	
	/**
	 * Searches for the key and returns the index where it is stored.
	 *
	 * @return the index where the key is stored
	 */
	private function findKey(key):Number {
		var l = keys.length;
		while (keys[--l] !== key && l>-1);
		return l;
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}