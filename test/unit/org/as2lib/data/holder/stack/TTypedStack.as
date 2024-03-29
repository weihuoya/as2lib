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

import org.as2lib.data.holder.stack.SimpleStack;
import org.as2lib.data.holder.stack.TypedStack;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.AbstractTStack;

/**
 * Test for the extended implementation of Stack: TypedStack
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.data.holder.stack.TTypedStack extends AbstractTStack {
	
	/**
	 * Implementation of the getStack Method in AbstractTStack
	 * 
	 * @return New Instance of a TypedStack
	 */
	public function getStack(Void):Stack {
		return new TypedStack(Object, new SimpleStack());
	}
	
	/**
	 * Extends .testPush and tests if pushing of wrong types work proper.
	 */
	public function testPush(Void):Void {
		super.testPush();
		var stack2:Stack = new TypedStack(String, new SimpleStack());
		assertThrows("stack2 should throw a exception if you push a number", stack2, "push", [1]);
		assertTrue("stack2 should be empty, nothing has been pushed!", stack2.isEmpty());
	}
	
}