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
import org.as2lib.data.holder.HolderConfig;

/**
 * LinearQueue is an implementaion of the Queue interface. The LinearQueue stores
 * values in a linear manner.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.queue.LinearQueue extends BasicClass implements Queue {
	/** Contains the inserted elements. */
	private var data:Array;
	
	/**
	 * Constructs a new LinearQueue.
	 */
	public function LinearQueue(Void) {
		data = new Array();
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
	 * @see org.as2lib.data.holder.Queue#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (data.length < 1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new ArrayIterator(data));
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getQueueStringifier().execute(this);
	}
}