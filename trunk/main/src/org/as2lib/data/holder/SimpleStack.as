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

import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ProtectedArrayIterator;
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
	private var values:Array;
	
	/**
	 * Constructs a new SimpleStack.
	 */
	public function SimpleStack(Void) {
		values = new Array();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#push()
	 */
	public function push(value):Void {
		values.push(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#pop()
	 */
	public function pop(Void) {
		if (isEmpty()) {
			throw new EmptyDataHolderException("You tried to pop an element from an empty Stack.",
											   this,
											   arguments);
		}
		return values.pop();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#peek()
	 */
	public function peek(Void) {
		if (values.length == 0) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Stack.",
											   this,
											   arguments);
		}
		return values[values.length-1];
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#iterator()
	 */
	public function iterator(Void):Iterator {
		var reversedValues:Array = values.slice();
		reversedValues.reverse();
		return (new ProtectedArrayIterator(reversedValues));
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (values.length == 0);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getStackStringifier().execute(this);
	}
}