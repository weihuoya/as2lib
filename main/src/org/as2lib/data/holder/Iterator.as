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

import org.as2lib.core.BasicInterface;

/**
 * Iterators are used to iterate over data holders.
 *
 * @author Michael Herrmann
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.Iterator extends BasicInterface {
	/**
	 * Returns whether there exists another object to iterate over.
	 *
	 * @return true if there are objects left to iterate over
	 */
	public function hasNext(Void):Boolean;
	
	/**
	 * Returns the next object.
	 *
	 * @return the next object
	 * @throws org.as2lib.data.iterator.NoSuchElementException if there is no next element
	 */
	public function next(Void);
	
	/**
	 * Removes the presently selected object from the data holder the Iterator
	 * iterates over.
	 *
	 * @throws org.as2lib.env.except.IllegalStateException if you try to remove an element when none is selected
	 * @throws org.as2lib.env.except.UnsupportedOperationException if the operation is not supported by the given Iterator
	 */
	public function remove(Void):Void;
}