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
import org.as2lib.env.except.UnsupportedOperationException;

/**
 * The ProtectedIterator is used to iterate over any data holder without being
 * able to remove elements.
 *
 * @author Michael Herrmann
 * @author Simon Wacker
 */
class org.as2lib.data.holder.ProtectedIterator extends BasicClass implements Iterator {
	
	/** Holds the iterator this protected iterator delegates to. */
	private var iterator:Iterator;
	
	/**
	 * Constructs a new instance.
	 * 
	 * @param iterator the iterator to protect
	 */
	public function ProtectedIterator(iterator:Iterator) {
		this.iterator = iterator;
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#hasNext(Void):Boolean
	 */
	public function hasNext(Void):Boolean {
		return iterator.hasNext();
	}
	
	/**
	 * @see org.as2lib.data.holder.Iterator#next(Void)
	 */
	public function next(Void) {
		return iterator.next();
	}
	
	/**
	 * @see org.as2lib.data.holders.Iterator#remove()
	 */
	public function remove(Void):Void {
		throw new UnsupportedOperationException("This Iterator does not support the remove() method.", this, arguments);
	}
	
}