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
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.Map;

/**
 * ValueMapIterator is used to iterate over the values of a map.
 *
 * @author Michael Hermann
 * @author Simon Wacker
 */
class org.as2lib.data.holder.map.ValueMapIterator extends BasicClass implements Iterator {
	
	/** The target data holder to iterate over. */
	private var target:Map;
	
	/** The iterator used as a helper. */
	private var iterator:ArrayIterator;
	
	/** The presently selected key. */
	private var key;
	
	/**
	 * Constructs a new ValueMapIterator instance.
	 *
	 * @param target the map to iterate over
	 */
	public function ValueMapIterator(newTarget:Map) {
		target = newTarget;
		iterator = new ArrayIterator(target.getKeys());
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#hasNext()
	 */
	public function hasNext(Void):Boolean {
		return iterator.hasNext();
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#next()
	 */
	public function next(Void) {
		key = iterator.next();
		return target.get(key);
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#remove()
	 */
	public function remove(Void):Void {
		iterator.remove();
		target.remove(key);
	}
	
}