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
import org.as2lib.data.holder.map.MapIterator;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * TypedMap is used as a wrapper. It can not be used alone. TypedMap enables
 * you to restrict the values that can be added to a specific type.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.map.TypedMap extends BasicClass implements Map {
	/** The Map the TypeMap wraps. */
	private var map:Map;
	
	/** The type of values that can be added. */
	private var type:Function;
	
	/**
	 * Constructs a new TypedMap.
	 *
	 * @param type the type of values this map contains
	 * @param map the Map that shall be wrapped by a TypedMap
	 */
	public function TypedMap(type:Function, map:Map) {
		this.map = map;
		this.type = type;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#containsKey()
	 */
	public function containsKey(key):Boolean {
		return map.containsKey(key);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#containsValue()
	 */
	public function containsValue(value):Boolean {
		return map.containsValue(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getKeys()
	 */
	public function getKeys(Void):Array {
		return map.getKeys();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getValues()
	 */
	public function getValues(Void):Array {
		return map.getValues();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#get()
	 */
	public function get(key) {
		return map.get(key);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#put()
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	public function put(key, value) {
		validate(value);
		return map.put(key, value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#clear()
	 */
	public function clear(Void):Void {
		map.clear();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#putAll()
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	public function putAll(map:Map):Void {
		var iterator:Iterator = map.iterator();
		while (iterator.hasNext()) {
			validate(iterator.next());
		}
		map.putAll(map);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#remove()
	 */
	public function remove(key) {
		return map.remove(key);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#iterator()
	 */
	public function iterator(Void):Iterator {
		return map.iterator();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#size()
	 */
	public function size(Void):Number {
		return map.size();
	}
	
	public function isEmpty(Void):Boolean {
		return map.isEmpty();
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return map.toString();
	}
	
	/**
	 * Validates the passed object based on its type.
	 *
	 * @param object the object which type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].",
											   this,
											   arguments);
		}
	}
}