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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.holder.array.TypedArray;

/**
 * Testcase for TypedArray.
 * It will test only the extended methods in TypedArray.
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.array.TTypedArray extends TestCase {
	
	/** Internal TypedArray holder to test*/
	private var typedArray:TypedArray;
	
	/**
	 * Fills the typedArray.
	 */
	private function setUp() {
		typedArray = new TypedArray(String);
	}
	
	/**
	 * Tests concat with various different contents
	 */
	public function testConcat(Void):Void {
		var newTypedArray:TypedArray;
		
		// Preparing the typedArray;
		typedArray.push("a");
		typedArray.push("b");
		typedArray.push("c");
		
		// Test a simple copy;
		newTypedArray = typedArray.concat();
		assertEquals("Content of the new array should match the current array at entry 0", newTypedArray[0], "a");
		assertEquals("Content of the new array should match the current array at entry 1", newTypedArray[1], "b");
		assertEquals("Content of the new array should match the current array at entry 2", newTypedArray[2], "c");
		assertThrows("New Array should be of the same type like the current array", IllegalArgumentException, newTypedArray, "push", [0]);
		
		// Test a normal concatination
		newTypedArray.push("d");
		newTypedArray = typedArray.concat(newTypedArray);
		assertEquals("Content of the new array should match the current array at entry 0 after merge", newTypedArray[0], "a");
		assertEquals("Content of the new array should match the current array at entry 1 after merge", newTypedArray[1], "b");
		assertEquals("Content of the new array should match the current array at entry 2 after merge", newTypedArray[2], "c");
		assertEquals("Content of the new array should match the former array at entry 0 after merge", newTypedArray[3], "a");
		assertEquals("Content of the new array should match the former array at entry 1 after merge", newTypedArray[4], "b");
		assertEquals("Content of the new array should match the former array at entry 2 after merge", newTypedArray[5], "c");
		assertEquals("Content of the new array should match the former array at entry 3 after merge", newTypedArray[6], "d");
		
		// Test a array concatination
		var arr:Array = new Array();
		arr.push("a");
		arr.push("b");
		newTypedArray = typedArray.concat(arr);
		assertEquals("Content of the new array should match the current array at entry 0 after array merge", newTypedArray[0], "a");
		assertEquals("Content of the new array should match the current array at entry 1 after array merge", newTypedArray[1], "b");
		assertEquals("Content of the new array should match the current array at entry 2 after array merge", newTypedArray[2], "c");
		assertEquals("Content of the new array should match the former array at entry 0 after array merge", newTypedArray[3], "a");
		assertEquals("Content of the new array should match the former array at entry 1 after array merge", newTypedArray[4], "b");
		
		// Test a concatinatioon with a wrong array.
		arr.push(1);
		assertThrows("Typed array should throw a exception if a wrong array should be concatinated", IllegalArgumentException, typedArray, "concat", [arr]);
		
		// Test a concatination with a normal entry.
		newTypedArray = typedArray.concat("d");
		assertEquals("Content of the new array should match the current array at entry 0 after add merge", newTypedArray[0], "a");
		assertEquals("Content of the new array should match the current array at entry 1 after add merge", newTypedArray[1], "b");
		assertEquals("Content of the new array should match the current array at entry 2 after add merge", newTypedArray[2], "c");
		assertEquals("Content of the new array should match the added entry at entry 0 after add merge", newTypedArray[3], "d");
		
		// Test a concatinatioon with a wrong entry.
		assertThrows("Typed array should throw a exception if a wrong entry should be concatinated", IllegalArgumentException, typedArray, "concat", [0]);
	}
	
	/**
	 * Tests push with working and non-working contents
	 */
	public function testPush(Void):Void {
		// Test with wrong content
		assertThrows("Current Array should throw a exception if the wrong type is used", IllegalArgumentException, typedArray, "push", [0]);
		
		// Simple push test
		typedArray.push("a");
		typedArray.push("b");
		assertEquals("Entry 0 should be 'a' after push", typedArray[0], "a");
		assertEquals("Entry 1 should be 'b' after push", typedArray[1], "b");
	}
	
	/**
	 * Tests unshift with working and non-working contents.
	 */
	public function testUnshift(Void):Void {
		// Test with wrong content
		assertThrows("Current Array should throw a exception if the wrong type is used", IllegalArgumentException, typedArray, "unshift", [0]);
		
		// Test with normal unshift
		typedArray.unshift("a");
		typedArray.unshift("b");
		assertEquals("Entry 0 should be 'b' after unshift", typedArray[0], "b");
		assertEquals("Entry 1 should be 'a' after unshift", typedArray[1], "a");
	}
}