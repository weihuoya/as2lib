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
import org.as2lib.data.holder.NoSuchElementException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.core.BasicClass;

/**
 * ArrayIterator is used to iterate over an Array.
 *
 * @author Michael Herrmann
 * @author Simon Wacker
 */
class org.as2lib.data.holder.array.ArrayIterator extends BasicClass implements Iterator {
	
	/** The target data holder. */
	private var target:Array;
	
	/** The current index of the iteration. */
	private var index:Number;
	
	/**
	 * Constructs a new ArrayIterator.
	 *
	 * @param target the Array to iterate over
	 */
	public function ArrayIterator(newTarget:Array) {
		target = newTarget;
		index = -1;
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#hasNext()
	 */
	public function hasNext(Void):Boolean {
		return (index < target.length - 1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#next()
	 */
	public function next(Void) {
		if (!hasNext()) {
			throw new NoSuchElementException("There is no more element.", this, arguments);
		}
		return target[++index];
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#remove()
	 */
	public function remove(Void):Void {
		if (index < 0) {
			throw new IllegalStateException("You tried to remove an element before calling the #next() method. Thus there is no element selected to remove.", this, arguments);
		}
		target.splice(index--, 1);
	}
	
}