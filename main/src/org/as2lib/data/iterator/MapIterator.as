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

import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.Map;
import org.as2lib.core.BasicClass;

/**
 * MapIterator is used to iterate over a Map.
 *
 * @author Michael Hermann
 * @author Simon Wacker
 */
class org.as2lib.data.iterator.MapIterator extends BasicClass implements Iterator {
	/** The target data holder to iterate over. */
	private var target:Map;
	
	/** The ArrayIterator used as a helper. */
	private var iterator:ArrayIterator;
	
	/** The presently selected key. */
	private var key;
	
	/**
	 * Constructs a new MapIterator.
	 *
	 * @param target the Map to iterate over
	 */
	public function MapIterator(newTarget:Map) {
		target = newTarget;
		iterator = new ArrayIterator(target.getKeys());
	}
	
	/**
	 * @see org.as2lib.data.iterator.Iterator#hasNext()
	 */
	public function hasNext(Void):Boolean {
		return iterator.hasNext();
	}
	
	/**
	 * @see org.as2lib.data.iterator.Iterator#next()
	 */
	public function next(Void) {
		key = iterator.next();
		return target.get(key);
	}
	
	/**
	 * @see org.as2lib.data.iterator.Iterator#remove()
	 */
	public function remove(Void):Void {
		iterator.remove();
		target.remove(key);
	}
}