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

import org.as2lib.data.holder.Iterator;
import org.as2lib.core.BasicInterface;

/**
 * Map is the base interface for data holders that map keys to values.
 *
 * @author Michael Herrmann
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.Map extends BasicInterface {
	
	/**
	 * Checks if the key exists.
	 *
	 * @param key the key to be checked for availability
	 * @return true if the key exists else false
	 */
	public function containsKey(key):Boolean;
	
	/**
	 * Checks if the value is mapped to a key.
	 *
	 * @param value the value to be checked for availability
	 * @return true if the value is mapped to a key else false
	 */
	public function containsValue(value):Boolean;
	
	/**
	 * Returns an Array that contains all the keys.
	 *
	 * @return an Array containing the keys
	 */
	public function getKeys(Void):Array;
	
	/**
	 * Returns an Array containing all the values.
	 *
	 * @return an Array containing the values
	 */
	public function getValues(Void):Array;
	
	/**
	 * Returns the value that is mapped to the passed key.
	 *
	 * @param key the key the appropriate value shall be returned
	 * @return the value appropriate to the key
	 */
	public function get(key);
	
	/**
	 * Maps the specified key to the value.
	 *
	 * @param key the key used as identifier for the value
	 * @param value the value that shall be mapped to the key
	 * @return the value that was originally mapped to the key or null
	 */
	public function put(key, value);
	
	/**
	 * Copies all mappings from the specified map to this map.
	 *
	 * @param map mappings to be stored in this map
	 */
	public function putAll(map:Map):Void;
	
	/**
	 * Removes the mapping from the specified key to the value.
	 *
	 * @param key the key identifying the mapping to be removed
	 * @return the value that was originally mapped to the key
	 */
	public function remove(key);
	
	/**
	 * Clears all mappings.
	 */
	public function clear(Void):Void;
	
	/**
	 * Returns an Iterator to iterate over the values of the Map.
	 *
	 * @return an Iterator to iterate over the Map
	 * @see org.as2lib.data.holder.Iterator
	 */
	public function iterator(Void):Iterator;
	
	/**
	 * Returns the amount of mappings.
	 *
	 * @return the amount of mappings
	 */
	public function size(Void):Number;
	
	/**
	 * Returns whether the Map contains any mappings.
	 *
	 * @return true if the Map contains mappings else false
	 */
	public function isEmpty(Void):Boolean;
	
}