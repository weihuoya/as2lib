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

import org.as2lib.data.holder.AbstractPriority;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.holder.map.MapIterator;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.HolderConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.map.PriorityMap extends AbstractPriority implements Map {
	private var map:Map;
	private var priorityArray:Array;
	
	/**
	 * Constructs a new PriorityMap.
	 */
	public function PriorityMap(map:Map) {
		this.map = map;
		priorityArray = new Array();
		if (!map.isEmpty()) {
			var iterator:Iterator = map.iterator();
			while (iterator.hasNext()) {
				priorityArray.push(PRIORITY_NORMAL);
			}
		}
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
	
	public function put(key, value) {
		var o:Overload = new Overload(this);
		o.addHandler([Object, Object], putByValue);
		o.addHandler([Object, Object, Number], putByValueAndPriority);
		o.forward(arguments);
	}
	
	public function putByValue(key, value) {
		putByValueAndPriority(key, value, PRIORITY_NORMAL);
	}
	
	public function putByValueAndPriority(key, value, priority:Number) {
		var i:Number = findKey(key);
		var result = map.put(key, value);
		if (i == -1) {
			var index:Number = priorityArray.push(priority) - 1;
			filter(index);
		} else {
			priorityArray.splice(i, 0, priority);
			changePriorityByIndex(i, priority, true);
		}
		return result;
	}
	
	public function putAll(map:Map):Void {
		var o:Overload = new Overload(this);
		o.addHandler([Map], putAllByMap);
		o.addHandler([Map, Number], putAllByMapAndPriority);
		o.forward(arguments);
	}
	
	public function putAllByMap(map:Map):Void {
		putAllByMapAndPriority(map, PRIORITY_NORMAL);
	}
	
	public function putAllByMapAndPriority(map:Map, priority:Number):Void {
		var valueIterator:ArrayIterator = new ArrayIterator(map.getValues());
		var keyIterator:ArrayIterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			putByValueAndPriority(keyIterator.next(), valueIterator.next(), priority);
		}
	}
	
	public function changePriority(key, priority:Number, absolute:Boolean):Void {
		changePriorityByIndex(findKey(key), priority, absolute);
	}
	
	private function changePriorityByIndex(index:Number, priority:Number, absolute:Boolean):Void {
		var oldPriority:Number = priorityArray[index];
		if (absolute) {
			priorityArray[index] = priority;
		} else {
			priorityArray[index] += priority;
		}
		filter(index);
	}
	
	private function filter(index:Number):Void {
		if (priorityArray.length > 1) {
			var keyArray:Array = map.getKeys();
			var key = keyArray[index];
			var value = map.remove(key);
			var priority:Number = priorityArray.splice(index, 1)[0];
			var tempMap:Map = new HashMap();
			var i:Number;
			for (i = priorityArray.length-1; i > -1; i--) {
				if (priorityArray[i] > priority) {
					tempMap.put(keyArray[i], map.remove(keyArray[i]));
				} else {
					break;
				}
			}
			map.put(key, value);
			priorityArray.splice(i+1, 0, priority);
			map.putAll(tempMap);
		}
	}

	public function clear(Void):Void {
		map.clear();
		priorityArray = new Array();
	}
	
	public function remove(key) {
		var i:Number = findKey(key);
		priorityArray.splice(i, 1);
		return map.remove(key);
	}
	
	public function iterator(Void):Iterator {
		return map.iterator();
	}

	public function size(Void):Number {
		return map.size();
	}
	
	public function isEmpty(Void):Boolean {
		return map.isEmpty();
	}
	
	public function toString(Void):String {
		return map.toString();
	}
	private function findKey(key):Number {
		var keys:Array = map.getKeys();
		var l = keys.length;
		while (keys[--l] != key && l>-1);
		return l;
	}
}