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
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.Queue extends BasicInterface {
	
	/**
	 * Inserts the value into the queue.
	 *
	 * @param value the value to be inserted
	 */
	public function enqueue(value):Void;
	
	/**
	 * Removes the firstly inserted value.
	 *
	 * @return the firstly inserted value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Queue is empty
	 */
	public function dequeue(Void);
	
	/**
	 * Returns the firstly inserted value.
	 *
	 * @return the firstly inserted value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Queue is empty
	 */
	public function peek(Void);
	
	/**
	 * Returns an Iterator that can be used to iterate over the elements fo this
	 * Queue.
	 *
	 * @return an Iterator to iterate over this queue
	 * @see org.as2lib.data.holder.Iterator
	 */
	public function iterator(Void):Iterator;
	
	/**
	 * Returns whether the queue contains no values.
	 *
	 * @return true if the queue contains no values else false
	 */
	public function isEmpty(Void):Boolean;
	
	/**
	 * Returns an array representation of this queue.
	 *
	 * <p>The elements are copied onto the array in a first-in-first-out
	 * order, similar to the order of the elements returned by a succession 
	 * of calls to #dequeue().
	 *
	 * @return the stack's array representation
	 */
	public function toArray(Void):Array;
	
}