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

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedMap extends BasicClass implements Map, Mergeable {
	
	private var keys:Array;
	private var values:Array;
	private var keyType:Function;
	private var valueType:Function;
	private var mergeEnabled:Boolean;
	
	public function ManagedMap(Void) {
		keys = new Array();
		values = new Array();
	}
	
	public function getKeyType(Void):Function {
		return keyType;
	}
	
	public function setKeyType(keyType:Function):Void {
		this.keyType = keyType;
	}
	
	public function getValueType(Void):Function {
		return valueType;
	}
	
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
		if (parent instanceof Map) {
			var parentMap:Map = parent;
			keys = parentMap.getKeys().concat(keys);
			values = parentMap.getValues().concat(values);
		}
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