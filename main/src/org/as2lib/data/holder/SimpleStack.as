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

import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.EmptyDataHolderException;

/**
 * A simple implementation of the Stack interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.SimpleStack extends BasicClass implements Stack {
	/** Contains the inserted values. */
	private var target:Array;
	
	/**
	 * Constructs a new SimpleStack.
	 */
	public function SimpleStack(Void) {
		target = new Array();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#push()
	 */
	public function push(value):Void {
		target.unshift(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#pop()
	 */
	public function pop(Void) {
		if (target.length == 0) {
			throw new EmptyDataHolderException("You tried to pop an element from an empty Stack.",
										  this,
										  arguments);
		}
		return target.shift();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#peek()
	 */
	public function peek(Void) {
		if (target.length == 0) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Stack.",
										  this,
										  arguments);
		}
		return target[target.length - 1];
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new ArrayIterator(target));
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (target.length == 0);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getStackStringifier().execute(this);
	}
}