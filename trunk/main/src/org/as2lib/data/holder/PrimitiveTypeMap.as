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

import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.MapIterator;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;

/**
 * ?
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.PrimitiveTypeMap extends BasicClass implements Map {
	/** Contains the mappings. */
	private var map:Object;
	
	/** Stores the number of put values. */
	private var length:Number;
	
	/**
	 * Constructs a new PrimitiveTypeMap.
	 */
	public function PrimitiveTypeMap(Void) {
		map = new Object();
		length = 0;
	}

	/**
	 * @see org.as2lib.data.holder.Map#containsKey()
	 */
	public function containsKey(key):Boolean {
		return (map[key] != undefined);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#containsValue()
	 */
	public function containsValue(value):Boolean {
		var i:String;
		for (i in map) {
			if (map[i] == value) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getKeys()
	 */
	public function getKeys(Void):Array {
		var result:Array = new Array();
		var i:String;
		for (i in map) {
			result.push(i);
		}
		result.reverse();
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getValues()
	 */
	public function getValues(Void):Array {
		var result:Array = new Array();
		var i:String;
		for (i in map) {
			result.push(map[i]);
		}
		result.reverse();
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#get()
	 */
	public function get(key) {
		return map[key];
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#put()
	 */
	public function put(key, value) {
		var result = null;
		if (map[key] != undefined) result = map[key];
		else length++;
		map[key] = value;
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#clear()
	 */
	public function clear(Void):Void {
		map = new Object();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#putAll()
	 */
	public function putAll(map:Map):Void {
		var valueIterator:ArrayIterator = new ArrayIterator(map.getValues());
		var keyIterator:ArrayIterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			put(keyIterator.next(), valueIterator.next());
		}
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#remove()
	 */
	public function remove(key) {
		var result = null;
		if(map[key] != undefined) {
			result = map[key];
			map[key] = undefined;
		}
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new MapIterator(this));
	}

	/**
	 * @see org.as2lib.data.holder.Map#size()
	 */
	public function size(Void):Number {
		return length;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (size() == 0);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getMapStringifier().execute(this);
	}
}