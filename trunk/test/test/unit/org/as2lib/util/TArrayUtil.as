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
import org.as2lib.util.ArrayUtil;;
import org.as2lib.data.holder.Stack;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Test of all methods in ArrayUtil.
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.util.TArrayUtil extends TestCase {
	
	/**
	 * Clones a array and validates the correctness of the cloning
	 */
	public function testClone(Void):Void {
		var test:Array = [1,2,3,4,5,6,7,8,9,10];
		
		var result:Array = ArrayUtil.clone(test);
		
		assertNotSame("The result should not be the same as the test", result, test);
		
		for(var i in result) {
			var index:Number = Number(i);
			if(index >= 0 && index <= 9) {
				assertEquals("Unexpected value found at position "+i, result[i], index+1);
			} else {
				fail("Unexpected index found: "+i);
			}
		}
	}
	
	/**
	 * Creates some cases of arrays to remove a content.
	 */
	public function testRemoveElement(Void):Void {
		// This array contains all values twice.
		var test:Array = [1,1,2,2,3,3,4,4,5,5];
		
		/**
		 * TODO: What if the element is more than once in the array ???
		 */
	}
	
	/**
	 * Test multiple cases where contains could fail.
	 */
	public function testContains(Void):Void {
		// This array contains all values twice.
		var test:Array = [1,1,2,2,3,3,4,4,5,5];
		
		// Test if it contains the first element
		assertTrue("Test should contain 1", ArrayUtil.contains(test, 1));
		
		// Test if it contains the last element
		assertTrue("Test should contain 5", ArrayUtil.contains(test, 5));
		
		// Test if it contains a middle element
		assertTrue("Test should contain 3", ArrayUtil.contains(test, 3));
		
		// Test if it contains a non existant element
		assertFalse("Test should not contain 6", ArrayUtil.contains(test, 6));
	}
	
	/**
	 * Tests some cases where indexOf could fail.
	 */
	public function testIndexOf(Void):Void {
		var test:Array = [1,2,3,4,5,6,7,8,9,10];
		
		// Check for the first value
		assertEquals("Wrong Content at the found Index for 1", test[ArrayUtil.indexOf(test, 1)], 1);
		assertEquals("Wrong Index found for 1", ArrayUtil.indexOf(test, 1), 0);
		
		// Check for the last value
		assertEquals("Wrong Content at the found Index for 10", test[ArrayUtil.indexOf(test, 10)], 10);
		assertEquals("Wrong Index found for 10", ArrayUtil.indexOf(test, 10), test.length-1);
		
		// Check for a middle value
		assertEquals("Wrong Content at the found Index for 5", test[ArrayUtil.indexOf(test, 5)], 5);
		assertEquals("Wrong Index found for 5", ArrayUtil.indexOf(test, 5), 4);
	}
	
	/**
	 * Creates stack instances from arrays and validates them.
	 */
	public function testToStack(Void):Void {
		var test:Array = [1,2,3,4,5,6,7];
		var stack:Stack;
		
		// Normal sorted Stack
		stack= ArrayUtil.toStack(test);
		for(var i:Number = 0; !stack.isEmpty(); i++) {
			if(i < 8) {
				assertEquals("Content at stack entry "+i+" should be as expected ("+(i+1)+")", stack.pop(), i+1);
			} else {
				fail("Unexpected index (> 8) found");
				break;
			}
		}
		
		// Inverted sorted Stack
		stack = ArrayUtil.toStack(test, true);
		for(var i:Number = 0; !stack.isEmpty(); i++) {
			if(i < 8) {
				assertEquals("Content at stack entry "+i+" should be as expected ("+(7-i)+")", stack.pop(), 7-i);
			} else {
				fail("Unexpected index (> 8) found");
				break;
			}
		}
	}
	
	/**
	 * Shuffles a big array and validates that it's not the same as before.
	 */
	public function testShuffle(Void):Void {
		var test:Array = new Array();
		var expectedSize:Number = 1000;
		var same:Boolean = true;
		
		// Creating a filled Array;
		for(var i:Number = 1; i<=expectedSize; i++) {
			test.push(i);
		}
		var result:Array = test.concat();
		
		// Shuffles the array
		ArrayUtil.shuffle(result);
		assertEquals("The shuffled Array should be as big as the source array", result.length, test.length);
		
		// Validates each entry in the array
		for(var i:Number = 0; i<result.length; i++) {
			if(result[i] != test[i]) {
				same = false;
				break;
			}
		}
		assertFalse("The shuffled Array should not be the same as the source array", same);
	}
}