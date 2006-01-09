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

import org.as2lib.bean.Mergable;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedMap extends BasicClass implements Map, Mergable {
	
	private var targetMap:Map;
	
	private var mergeEnabled:Boolean;
	
	public function ManagedMap(targetMap:Map) {
		if (targetMap == null) {
			targetMap = new HashMap();
		}
		this.targetMap = targetMap;
	}
	
	public function containsKey(key):Boolean {
		return targetMap.containsKey(key);
	}

	public function containsValue(value):Boolean {
		return targetMap.containsValue(value);
	}

	public function getKeys(Void):Array {
		return targetMap.getKeys();
	}

	public function getValues(Void):Array {
		return targetMap.getValues();
	}

	public function get(key) {
		return targetMap.get(key);
	}

	public function put(key, value) {
		return targetMap.put(key, value);
	}

	public function putAll(map:Map):Void {
		targetMap.putAll(map);
	}

	public function remove(key) {
		return targetMap.remove(key);
	}

	public function clear(Void):Void {
		targetMap.clear();
	}

	public function iterator(Void):Iterator {
		return targetMap.iterator();
	}

	public function valueIterator(Void):Iterator {
		return targetMap.valueIterator();
	}

	public function keyIterator(Void):Iterator {
		return targetMap.keyIterator();
	}

	public function size(Void):Number {
		return targetMap.size();
	}

	public function isEmpty(Void):Boolean {
		return targetMap.isEmpty();
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
			var temp:Map = new HashMap();
			temp.putAll(parentMap);
			temp.putAll(this);
			targetMap.clear();
			targetMap.putAll(temp);
		}
	}
	
}