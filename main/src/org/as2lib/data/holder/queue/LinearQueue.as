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
import org.as2lib.data.holder.Queue;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.util.Stringifier;
import org.as2lib.data.holder.queue.QueueStringifier;

/**
 * LinearQueue is an implementaion of the Queue interface. The LinearQueue stores
 * values in a linear manner.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.queue.LinearQueue extends BasicClass implements Queue {
	
	/** Used to stringify queues. */
	private static var stringifier:Stringifier;
	
	/** Contains the inserted elements. */
	private var data:Array;
	
	/**
	 * Returns the stringifier that stringifies queues.
	 *
	 * @return the stringifier that stringifies queues
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new QueueStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the new stringifier that stringifies queues.
	 *
	 * @param queueStringifier the new queue stringifier
	 */
	public static function setStringifier(queueStringifier:Stringifier):Void {
		stringifier = queueStringifier;
	}
	
	/**
	 * Constructs a new LinearQueue instance.
	 *
	 * @param source (optional) an array that contains values to populate the new queue with
	 */
	public function LinearQueue(source:Array) {
		if (source) {
			data = source.concat();
		} else {
			data = new Array();
		}
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#enqueue()
	 */
	public function enqueue(value):Void {
		data.push(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#dequeue()
	 */
	public function dequeue(Void) {
		if (isEmpty()) {
			throw new EmptyDataHolderException("You tried to dequeue an element from an empty Queue.", this, arguments);
		}
		return data.shift();
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#peek()
	 */
	public function peek(Void) {
		if (isEmpty()) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Queue.", this, arguments);
		}
		return data[0];
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new ArrayIterator(data.concat()));
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (data.length < 1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#size()
	 */
	public function size(Void):Number {
		return data.length;
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#toArray()
	 */
	public function toArray(Void):Array {
		return data.concat();
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}