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
interface org.as2lib.data.holder.Stack extends BasicInterface {
	
	/**
	 * Pushes the value to the Stack.
	 *
	 * @param value the value to be pushed to the Stack
	 */
	public function push(value):Void;
	
	/**
	 * Removes the lastly pushed value.
	 *
	 * @return the lastly pushed value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Stack is empty
	 */
	public function pop(Void);
	
	/**
	 * Returns the lastly pushed value.
	 *
	 * @return the lastly pushed value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Stack is empty
	 */
	public function peek(Void);
	
	/**
	 * Returns an Iterator used to iterate over the values of the Stack.
	 *
	 * @return an Iterator to iterate over the Stack
	 * @see org.as2lib.data.holder.Iterator
	 */
	public function iterator(Void):Iterator;
	
	/**
	 * Returns whether the Stack is empty.
	 *
	 * @return true if the Stack is empty else false
	 */
	public function isEmpty(Void):Boolean;
	
	/**
	 * Returns the number of pushed elements.
	 *
	 * @return the number of pushed elements
	 * @see #push(*):Void
	 */
	public function size(Void):Number;
	
	/**
	 * Returns an array representation of this stack.
	 *
	 * <p>The elements are copied onto the array in a last-in-first-out
	 * order, similar to the order of the elements returned by a succession 
	 * of calls to #pop().
	 *
	 * @return the stack's array representation
	 */
	 public function toArray(Void):Array;
	
}