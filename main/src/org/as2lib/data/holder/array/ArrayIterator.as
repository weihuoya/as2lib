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

import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.NoSuchElementException;

/**
 * ArrayIterator can be used to iterate over arrays.
 *
 * <p>This usage of this iterator is quite simple. There is one method to check
 * whether there are more elements left to iterate over {@link #hasNext},
 * one method to get the next element {@link #next} and one to remove
 * the current element {@link #remove}.
 *
 * <p>And here is how it works:
 * <code>
 *   var iterator:Iterator = new ArrayIterator(["value1", "value2", "value3"]);
 *   while (iterator.hasNext()) {
 *     trace(iterator.next());
 *   }
 * </code>
 * <p>The output would be the following:
 * <pre>
 *   value1
 *   value2
 *   value3
 * </pre>
 *
 * @author Simon Wacker
 * @author Michael Herrmann
 * @author Martin Heidegger
 */
 class org.as2lib.data.holder.array.ArrayIterator extends BasicClass implements Iterator {
	
	/** The target data holder. */
	private var t:Array;
	
	/** The current index of the iteration. */
	private var i:Number;
	
	/**
	 * Constructs a new ArrayIterator instance.
	 *
	 * @param target the array to iterate over
	 * @throws IllegalArgumentException if the passed-in target array is null or undefined
	 */
	public function ArrayIterator(target:Array) {
		// IllegalArgumentException if the passed array is not available.
		if (!target) throw new IllegalArgumentException("The passed-in target array '" + target + "' is not allowed to be null or undefined.", this, arguments);

		// Usual handling of the arguments.
		this.t = target;
		i = -1;
		
		// Prepare of fast internal replacement
		var t:Array = target;
		var g:Number = -1;
		var p = ArrayIterator.prototype;
		
		// Replacement of internal methods as performance upgrade.
		// - Only if this class is used, else the OOP functionality would be broken.
		// - With more than 50 elements, else this method would be slower
		if(this.__proto__ == p && t.length > 25) {
			
			// Replace for .next() if .hasNext was not called
			var y:Function = function() {
				if(g < t.length-1) {
					arguments.callee = p.next;
					throw new NoSuchElementException("There is no more element.", this, arguments);
				}
				return t[++g];
			}
			// Replace for .next() if .hasNext was called and there is something next
			var x:Function = function() {
				next = y;
				return t[++g];
			}
			// Replace for .next() if .hasNext found that there is no next
			var z:Function = function() {
				next = y;
				arguments.callee = p.next;
				throw new NoSuchElementException("There is no more element.", this, arguments);
			}
			// .next replacement
			next = y;
			// .hasNext replacement
			hasNext = function() {
				if(g < t.length-1) {
					next = x;
					return true;
				} else {
					next = z;
					return false; 
				}
			}
			// .remove replacement
			remove = function() {
				if (g < 0) {
					arguments.callee = p.remove;
					throw new IllegalStateException("You tried to remove an element before calling the #next() method. Thus there is no element selected to remove.", this, arguments);
				}
				t.splice(g--, 1);
			}
		}
	}
	
	/**
	 * Returns whether there exists another element to iterate over.
	 *
	 * @return true if there is at least one lement left to iterate over
	 */
	public function hasNext(Void):Boolean {
		return (i < t.length-1);
	}
	
	/**
	 * Returns the next element of the array.
	 *
	 * @return the next element of the array
	 * @throws org.as2lib.data.holder.NoSuchElementException if there is
	 * no next element
	 */
	public function next(Void) {
		if (!hasNext()) {
			throw new NoSuchElementException("There is no more element.", this, arguments);
		}
		return t[++i];
	}
	
	/**
	 * Removes the currently selected element from this iterator and from
	 * the passed-in array this iterator iterates over.
	 *
	 * @throws org.as2lib.env.except.IllegalStateException if you try to 
	 * remove an element when none is selected
	 */
	public function remove(Void):Void {
		if (i < 0) {
			throw new IllegalStateException("You tried to remove an element before calling the #next() method. Thus there is no element selected to remove.", this, arguments);
		}
		t.splice(i--, 1);
	}
	
}
