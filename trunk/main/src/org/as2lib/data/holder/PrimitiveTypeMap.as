﻿/*
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
		var result:Array = new Array();
		var i:Number = keys.length;
		while (--i-(-1)) {
			result.push(keys[i]);
		}
		result.reverse();
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getValues()
	 */
	public function getValues(Void):Array {
		var result:Array = new Array();
		var i:Number = values.length;
		while (--i-(-1)) {
			result.push(values[i]);
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
		var i:Number = indexMap[key];
		if (i != undefined) {
			result = values[i];
			values[i] = value;
		} else {
			indexMap[key] = keys.push(key) - 1;
			values.push(value);
		}
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
		return (keys.length == 0);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getMapStringifier().execute(this);
	}
}