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
import org.as2lib.data.holder.NoSuchElementException;

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
	 * Creates a array with duplicate entries to test if really all were removed.
	 */
	public function testRemoveElement(Void):Void {
		// This array contains all values twice.
		var test:Array = [1,1,2,2,3,3,4,4,5,5];
		
		assertTrue("It should return that the entries could be removed", ArrayUtil.removeElement(test, 2));
		assertEquals("Length has to match the expected length", test.length, 8);
		for(var i=0; i<test.length; i++) {
			var expected:Number = 0;
			switch(i) {
				case 0:
				case 1:
					expected = 1;
					break;
				case 2:
				case 3:
					expected = 3;
					break;
				case 4:
				case 5:
					expected = 4;
					break;
				case 6:
				case 7:
					expected = 5;
			}
			assertEquals("Element "+i+" should not change by removing a element", test[i], expected);
		}
		assertFalse("It should not return that the entries could be removed", ArrayUtil.removeAllOccurances(test, 2));
	}
	
	/**
	 * Creates a array with duplicate entries to test if really all were removed.
	 */	
	public function testRemoveAllOccurances(Void):Void {
		// This array contains all values twice.
		var test:Array = [1,1,2,2,3,3,4,4,5,5];
		
		assertTrue("It should return that the entries could be removed", ArrayUtil.removeAllOccurances(test, 2));
		assertEquals("Length has to match the expected length", test.length, 8);
		for(var i=0; i<test.length; i++) {
			var expected:Number = 0;
			switch(i) {
				case 0:
				case 1:
					expected = 1;
					break;
				case 2:
				case 3:
					expected = 3;
					break;
				case 4:
				case 5:
					expected = 4;
					break;
				case 6:
				case 7:
					expected = 5;
			}
			assertEquals("Element "+i+" should not change by removing a element", test[i], expected);
		}
		assertFalse("It should not return that the entries could be removed", ArrayUtil.removeAllOccurances(test, 2));
	}

	/**
	 * Creates a array with duplicate entries to test if the first element was removed.
	 */
	public function testRemoveFirstOccurance(Void):Void {
		// This array contains all values twice.
		var test:Array = [6,2,3,4,5,6];
		
		assertTrue("It should return that the entry could be removed", ArrayUtil.removeFirstOccurance(test, 6));
		assertEquals("Length has to match the expected length", test.length, 5);
		for(var i=0; i<test.length; i++) {
			var expected:Number = i+2;
			assertEquals("Element "+i+" should not change by removing a element", test[i], expected);
		}
		assertFalse("It shoudld return that the entry could not be removed", ArrayUtil.removeFirstOccurance(test, 7));
	}
	
	/**
	 * Creates a array with duplicate entries to test if the first element was removed.
	 */
	public function testRemoveLastOccurance(Void):Void {
		// This array contains all values twice.
		var test:Array = [1,2,3,4,5,1];
		
		assertTrue("It should return that the entry could be removed", ArrayUtil.removeLastOccurance(test, 1));
		assertEquals("Length has to match the expected length", test.length, 5);
		for(var i=0; i<test.length; i++) {
			var expected:Number = i+1;
			assertEquals("Element "+i+" should not change by removing a element", test[i], expected);
		}
		assertFalse("It shoudld return that the entry could not be removed", ArrayUtil.removeLastOccurance(test, 7));
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
	 * Test different contents with indexOf
	 */
	public function testIndexOf(Void):Void {
		var obj:Object = {};
		var arr:Array = [];
		var test:Array = [1,"2",obj,arr,null,undefined];
		
		// Test of indexOf for objects that are contained
		assertEquals("Index of 1 should be 0", ArrayUtil.indexOf(test, 1), 0);
		assertEquals("Index of '2' should be 1", ArrayUtil.indexOf(test, "2"), 1);
		assertEquals("Index of [obj] should be 2", ArrayUtil.indexOf(test, obj), 2);
		assertEquals("Index of [arr] should be 3", ArrayUtil.indexOf(test, arr), 3);
		assertEquals("Index of null should be 4", ArrayUtil.indexOf(test, null), 4);
		assertEquals("Index of undefined should be 5", ArrayUtil.indexOf(test, undefined), 5);
		
		// Test of indexOf for objects that are not contained
		assertEquals("Index of 2 should be -1", ArrayUtil.indexOf(test, 2), -1);
		assertEquals("Index of true should be -1", ArrayUtil.indexOf(test, true), -1);
		assertEquals("Index of {} should be -1", ArrayUtil.indexOf(test, {}), -1);
		assertEquals("Index of [] should be -1", ArrayUtil.indexOf(test, []), -1);
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
	
	/**
	 * Tests the swap method 
	 */
	public function testSwap(Void):Void {
		var obj1:Object = {};
		var obj2:Object = {};
		
		// Test usual case 
		assertTrue("Swapping in [1,2,3] 0 and 2 should change the array to [3,2,1]", ArrayUtil.isSame(ArrayUtil.swap([1,2,3], 0, 2), [3,2,1]));
		
		// Test if really the references get switched
		assertTrue("Swapping in [obj1,obj2] 1 and 0 should change the array to [obj2,obj1]", ArrayUtil.isSame(ArrayUtil.swap([obj1,obj2], 1, 0), [obj2,obj1]));
		
		// Test with wrong attributes
		assertThrows("Swapping in [] 1 and 2 should throw a NoSuchElementException", NoSuchElementException, ArrayUtil, "swap", [[], 1, 2]);
		assertThrows("Swapping in [1,2] 1 and 2 should throw a NoSuchElementException", NoSuchElementException, ArrayUtil, "swap", [[1,2], 1, 2]);
		assertThrows("Swapping in null 1 and 2 should throw a IllegalArgumentException", IllegalArgumentException, ArrayUtil, "swap", [null, 1, 2]);
	}
	
	/**
	 * Validates different possibilities of usage of isSame.
	 */
	public function testIsSame(Void):Void {
		var obj = {};
		
		// Positive Cases
		assertTrue("[] is the same like []", ArrayUtil.isSame([], []));
		assertTrue("[1] is the same like [1]", ArrayUtil.isSame([1], [1]));
		assertTrue("[true] is the same like [true]", ArrayUtil.isSame([true], [true]));
		assertTrue("[null] is the same like [null]", ArrayUtil.isSame([null], [null]));
		assertTrue("[obj] is the same like [obj]", ArrayUtil.isSame([obj], [obj]));
		
		// Negative Cases
		assertFalse("[undefined] is not the same as []", ArrayUtil.isSame([undefined], []));
		assertFalse("[] is not the same as [undefined]", ArrayUtil.isSame([], [undefined]));
		assertFalse("[1] is not the same as [1,0]", ArrayUtil.isSame([1], [1,0]));
		assertFalse("[null] is not the same as [undefined]", ArrayUtil.isSame([null], [undefined]));
		assertFalse("[undefined] is not the same as [null]", ArrayUtil.isSame([undefined], [null]));
	}
}