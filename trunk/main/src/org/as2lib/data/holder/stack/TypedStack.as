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
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Stack;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * TypedStack is used as a wrapper for Stacks. It ensures that only values of a
 * specific type are added to the Stack.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.stack.TypedStack extends BasicClass implements Stack {
	/** The wrapped Stack. */
	private var stack:Stack;
	
	/** The type of values that are contained in the Stack. */
	private var type:Function;
	
	/**
	 * Constructs a new TypedStack.
	 *
	 * @param stack the Stack that shall be typed checked
	 * @param type the type of values the Stack can have
	 */
	public function TypedStack(stack:Stack, type:Function) {
		this.stack = stack;
		this.type = type;
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#push()
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the value is not valid
	 */
	public function push(value):Void {
		validate(value);
		stack.push(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#pop()
	 */
	public function pop(Void) {
		return stack.pop();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#peek()
	 */
	public function peek(Void) {
		return stack.peek();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#iterator()
	 */
	public function iterator(Void):Iterator {
		return stack.iterator();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return stack.isEmpty();
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return stack.toString();
	}
	
	/**
	 * Validates the passed object based on its type.
	 *
	 * @param object the object which type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].",
											   this,
											   arguments);
		}
	}
}