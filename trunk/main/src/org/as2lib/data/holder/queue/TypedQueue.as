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
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.Queue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * TypedQueue is used as a wrapper for {@link Queue} instances that ensures
 * that only values of a specific type can be added to the wrapped queue.
 *
 * <p>This class simply delegates all method invocations to the wrapped
 * queue. If the specific method is responsible for adding values it first
 * checks if the values to add are of the expected type. If they are the
 * method invocation gets forwarded, otherwise an {@link IllegalArgumentException}
 * gets thrown.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.queue.TypedQueue extends BasicClass implements Queue {
	
	/** The Queue the TypedQueue wraps. */
	private var queue:Queue;
	
	/** The type of values that can be added. */
	private var type:Function;
	
	/**
	 * Constructs a new TypedQueue instance.
	 *
	 * <p>If the passed-in queue does already contain values, these values
	 * do not get type-checked.
	 *
	 * @param type the type of the values that are allowed to be added
	 * @param queue the queue to be wrapped
	 * @throws IllegalArgumentException if the passed-in type is null or undefined
	 */
	public function TypedQueue(type:Function, queue:Queue) {
		this.type = type;
		this.queue = queue;
	}
	
	/**
	 * Returns the type that all values in the wrapped queue have.
	 *
	 * <p>This is the type passed-in on construction.
	 *
	 * @return the type the all values of the wrapped queue have
	 */
	public function getType(Void):Function {
		return type;
	}
	
	/**
	 * Adds the passed-in value to this queue.
	 *
	 * <p>The value gets only enqueued if it is of the expected type.
	 *
	 * @param value the value add
	 * @throws IllegalArgumentException if the type of the passed-in value is not valid
	 */
	public function enqueue(value):Void {
		validate(value);
		queue.enqueue(value);
	}
	
	/**
	 * Removes the firstly inserted value.
	 *
	 * @return the firstly inserted value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if this queue is empty
	 */
	public function dequeue(Void) {
		return queue.dequeue();
	}
	
	/**
	 * Returns the firstly inserted value.
	 *
	 * @return the firstly inserted value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if this queue is empty
	 */
	public function peek(Void) {
		return queue.peek();
	}
	/**
	 * Returns an iterator that can be used to iterate over the values of
	 * this queue.
	 *
	 * @return an iterator to iterate over this queue
	 * @see #toArray
	 */
	public function iterator(Void):Iterator {
		return queue.iterator();
	}
	
	/**
	 * Returns whether this queue contains any values.
	 *
	 * @return true if this queue contains no values else false
	 */
	public function isEmpty(Void):Boolean {
		return queue.isEmpty();
	}
	
	/**
	 * Returns the number of enqueued elements.
	 *
	 * @return the number of enqueued elements
	 * @see #enqueue
	 */
	public function size(Void):Number {
		return queue.size();
	}
	
	/**
	 * Returns an array representation of this queue.
	 *
	 * <p>The elements are copied onto the array in a first-in, first-out
	 * order, similar to the order of the elements returned by a succession 
	 * of calls to the {@link #dequeue} method.
	 *
	 * @return the array representation of this queue
	 */
	public function toArray(Void):Array {
		return queue.toArray();
	}
	
	/**
	 * Returns the string representation of the wrapped queue.
	 *
	 * @return the string representation of the wrapped queue
	 */
	public function toString(Void):String {
		return queue.toString();
	}
	
	/**
	 * Validates the passed-in value based on its type.
	 *
	 * @param value the value whose type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	private function validate(value):Void {
		if (!ObjectUtil.typesMatch(value, type)) {
			throw new IllegalArgumentException("Type mismatch between value '" + value + "' and type '" + type + "'.", this, arguments);
		}
	}
	
}