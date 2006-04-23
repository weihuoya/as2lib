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

import org.as2lib.bean.Mergeable;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.Map;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code ManagedMap} represents a map that may contain run-time bean references and
 * whose keys and values are converted to specific types if given.
 * 
 * <p>Note that this {@code Map} implementation implements only the methods {@code put},
 * {@code getKeys} and {@code getValues}.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedMap extends BasicClass implements Map, Mergeable {
	
	/** The put keys. */
	private var keys:Array;
	
	/** The put values. */
	private var values:Array;
	
	/** The required key type. */
	private var keyType:Function;
	
	/** The required value type. */
	private var valueType:Function;
	
	/** Is merging enabled for this map. */
	private var mergeEnabled:Boolean;
	
	/**
	 * Constructs a new {@code ManagedMap} instance.
	 */
	public function ManagedMap(Void) {
		keys = new Array();
		values = new Array();
	}
	
	/**
	 * Returns the required type of the keys.
	 * 
	 * @return the required key type
	 */
	public function getKeyType(Void):Function {
		return keyType;
	}
	
	/**
	 * Sets the required key type.
	 * 
	 * @param keyType the required key type
	 */
	public function setKeyType(keyType:Function):Void {
		this.keyType = keyType;
	}
	
	/**
	 * Returns the required type of the values.
	 * 
	 * @return the required value type
	 */
	public function getValueType(Void):Function {
		return valueType;
	}
	
	/**
	 * Sets the required value type.
	 * 
	 * @param valueType the required value type
	 */
	public function setValueType(valueType:Function):Void {
		this.valueType = valueType;
	}
	
	public function isMergeEnabled(Void):Boolean {
		return mergeEnabled;
	}
	
	public function setMergeEnabled(mergeEnabled:Boolean):Void {
		this.mergeEnabled = mergeEnabled;
	}
	
	public function merge(parent):Void {
		if (!mergeEnabled) {
			throw new IllegalStateException("Merging is not enabled for this managed map.", this, arguments);
		}
		if (!(parent instanceof Map)) {
			throw new IllegalArgumentException("Cannot merge with instance of type [" +
					ReflectUtil.getTypeNameForInstance(parent) + "].", this, arguments);
		}
		var parentMap:Map = parent;
		keys = parentMap.getKeys().concat(keys);
		values = parentMap.getValues().concat(values);
	}
	
	public function put(key, value) {
		keys.push(key);
		values.push(value);
	}
	
	public function getKeys(Void):Array {
		return keys;
	}
	
	public function getValues(Void):Array {
		return values;
	}
	
	public function containsKey(key):Boolean {
		return null;
	}

	public function containsValue(value):Boolean {
		return null;
	}

	public function get(key) {
	}

	public function putAll(map:Map):Void {
	}

	public function remove(key) {
	}

	public function clear(Void):Void {
	}

	public function iterator(Void):Iterator {
		return null;
	}

	public function valueIterator(Void):Iterator {
		return null;
	}

	public function keyIterator(Void):Iterator {
		return null;
	}

	public function size(Void):Number {
		return null;
	}

	public function isEmpty(Void):Boolean {
		return null;
	}

}