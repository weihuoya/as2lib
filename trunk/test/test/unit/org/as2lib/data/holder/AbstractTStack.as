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

import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.Iterator;

/**
 * Abstract Test for the Stack interface, every implementation should be matched with this test.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.AbstractTStack extends TestCase {
	
	/** internal holder for a object */
	private var obj1:Object;
	
	/** internal holder for another object */
	private var obj2:Object;
	
	/** internal holder for a stack */
	private var stack:Stack;
	
	/**
	 * Static method to block this test from getting collected with the TestSuiteFactory.
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Sets up the testcases instance
	 */
	public function setUp(Void):Void {
		obj1 = {};
		obj2 = {};
		stack = getStack();
	}
	
	/**
	 * Template method for the extending testcases.
	 */
	public function getStack():Stack {
		return null;
	}
	
	/**
	 * Method to fill the test instance with test content.
	 */
	private function fillStack(Void):Void {
		stack.push(obj1);
		stack.push(obj2);
	}
	
	/**
	 * Tests if push really pushes content to the object
	 */
	public function testPush(Void):Void {
		// Pushing content
		fillStack();
		
		// Pops the content of the stack and tests if the expected content will be returned
		assertSame("The first content should match obj2", stack.pop(), obj2);
		assertFalse("The Stack should not be empty", stack.isEmpty());
		assertSame("The second content should match obj1", stack.pop(), obj1);
		assertTrue("The Stack should be empty after removing both contents", stack.isEmpty());
	}
	
	/**
	 * Tests if pop really removed content from the stack.
	 */
	public function testPop(Void):Void {
		// pop from a empty stack should throw a exception
		assertThrows("push should throw a exception if the stack is empty", EmptyDataHolderException, stack, "pop", []);
		fillStack();
		
		// Removes all entries
		assertSame("The first content should match obj2", stack.pop(), obj2);
		assertFalse("The Stack should not be empty", stack.isEmpty());
		assertSame("The second content should match obj1", stack.pop(), obj1);
		assertTrue("The Stack should be empty after removing both contents", stack.isEmpty());
	}
	
	/**
	 * Test if peek works properly 
	 */
	public function testPeek(Void):Void {
		// Peek from a empty stack
		assertThrows("peek should throw a exception if the stack is empty", EmptyDataHolderException, stack, "peek", []);
		fillStack(stack);
		
		// Peek and pop all entries
		assertEquals("Result of the first peek should be obj2", stack.peek(), obj2);
		assertEquals("Result of the first pop should be obj2", stack.pop(), obj2);
		assertFalse("The stack should not be empty after removing one element", stack.isEmpty());
		assertEquals("Result of the second peek should be obj1", stack.peek(), obj1);
		assertFalse("peek may not delete anything", stack.isEmpty());
		assertEquals("Result of the second pop should be obj1", stack.pop(), obj1);
		assertTrue("The stack should be empty if all objects are removed", stack.isEmpty());
	}
	
	/**
	 * Test the available iterator of the stack implementation
	 */
	public function testIterator(Void):Void {
		var iterator:Iterator = stack.iterator();
		assertFalse("A iterator of a empty stack may not allow hasNext", iterator.hasNext());
		fillStack(stack);
		
		// Tests if the former used iterator is ma
		assertFalse("The iterator must not be affected of a change of the stack", iterator.hasNext());
		
		// Norma literator test.
		iterator = stack.iterator();
		assertTrue("A Stack with a iterator has to have something 'next'", iterator.hasNext());
		assertEquals("The first object in the iterator should match obj2", obj2, iterator.next());
		assertEquals("The second object in the iterator should match obj1", obj1, iterator.next());
		assertFalse("There should be only two entries in the iterator", iterator.hasNext());
	}
	
	/**
	 * Tests if isEmpty really works.
	 */
	public function testIsEmpty(Void):Void {
		var obj:Object = {};
		
		assertTrue("A empty stack should not contain anything", stack.isEmpty());
		stack.push(obj);
		assertFalse("A stack with one content should contain something", stack.isEmpty());
		stack.push(obj);
		assertFalse("A stack with two contents should contain something", stack.isEmpty());
		stack.pop();
		stack.pop();
		assertTrue("A stack with all popped should contain nothing", stack.isEmpty());
		assertThrows("Removing something from a empty stack should throw a exception", EmptyDataHolderException, stack, "pop", []);
		assertTrue("A Exception should not manipulate the isEmpty result", stack.isEmpty());
	}
	
	public function testToArray(Void):Void {
		var obj:Object = new Object();
		
		assertSame("Stack is empty and so should be the array representation.", stack.toArray().length, 0);
		stack.push(obj1);
		assertSame("Array representation should contain exactly one element.", stack.toArray().length, 1);
		assertSame("The first and only element should be obj1.", stack.toArray()[0], obj1);
		stack.push(obj2);
		assertSame("Array representation should contain exactly two elements.", stack.toArray().length, 2);
		assertSame("The first element should be obj2.", stack.toArray()[0], obj2);
		assertSame("The second element should be obj1.", stack.toArray()[1], obj1);
		stack.push(obj);
		assertSame("Array representation should contain exactly three elements.", stack.toArray().length, 3);
		assertSame("The first element should be obj.", stack.toArray()[0], obj);
		assertSame("The second element should be obj2.", stack.toArray()[1], obj2);
		assertSame("The third element should be obj1.", stack.toArray()[2], obj1);
		stack.pop();
		stack.pop();
		stack.pop();
		assertSame("Stack is again empty and so should be the array representation.", stack.toArray().length, 0);
	}
	
}