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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.MapIterator;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.HolderConfig;

/**
 * ?
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.map.PrimitiveTypeMap extends BasicClass implements Map {
	/** Contains the mappings. */
	private var map:Object;
	
	/** */
	private var indexMap:Object;
	
	/** */
	private var keys:Array;
	
	/** */
	private var values:Array;
	
	/**
	 * Constructs a new PrimitiveTypeMap.
	 */
	public function PrimitiveTypeMap(Void) {
		map = new Object();
		indexMap = new Object();
		indexMap.__proto__ = undefined;
		keys = new Array();
		values = new Array();
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
		var i:Number = keys.length;
		while (--i-(-1)) {
			if (values[i] == value) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getKeys()
	 */
	public function getKeys(Void):Array {
		return keys.concat();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getValues()
	 */
	public function getValues(Void):Array {
		return values.concat();
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
		var result;
		var i:Number = indexMap[key];
		if (i == undefined) {
			indexMap[key] = keys.push(key) - 1;
			values.push(value);
		} else {
			result = values[i];
			values[i] = value;
		}
		map[key] = value;
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#clear()
	 */
	public function clear(Void):Void {
		map = new Object();
		indexMap = new Object();
		indexMap.__proto__ = undefined;
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
		var result;
		var i:Number = indexMap[key];
		if (i != undefined) {
			result = values[i];
			map[key] = undefined;
			indexMap[key] = undefined;
			keys.splice(i, 1);
			values.splice(i, 1);
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
		return keys.length;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (size() < 1);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getMapStringifier().execute(this);
	}
}