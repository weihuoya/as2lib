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
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.ProtectedIterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.util.Stringifier;
import org.as2lib.data.holder.stack.StackStringifier;

/**
 * A simple implementation of the Stack interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.stack.SimpleStack extends BasicClass implements Stack {
	
	/** Used to stringify stacks. */
	private static var stringifier:Stringifier;
	
	/** Contains the inserted values. */
	private var values:Array;
	
	/**
	 * Returns the stringifier that stringifies stacks.
	 *
	 * @return the stringifier that stringifies stacks
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new StackStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the new stringifier that stringifies stacks.
	 *
	 * @param stackStringifier the new stack stringifier
	 */
	public static function setStringifier(stackStringifier:Stringifier):Void {
		stringifier = stackStringifier;
	}
	
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
			throw new EmptyDataHolderException("You tried to pop an element from an empty Stack.", this, arguments);
		}
		return values.pop();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#peek()
	 */
	public function peek(Void) {
		if (isEmpty()) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Stack.", this, arguments);
		}
		return values[values.length-1];
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#iterator()
	 */
	public function iterator(Void):Iterator {
		var reversedValues:Array = values.slice();
		reversedValues.reverse();
		return (new ProtectedIterator(new ArrayIterator(reversedValues)));
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (values.length < 1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#size()
	 */
	public function size(Void):Number {
		return values.length;
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#toArray()
	 */
	public function toArray(Void):Array {
		var result:Array = values.concat();
		result.reverse();
		return result;
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}