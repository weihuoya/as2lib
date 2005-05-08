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

import org.as2lib.data.type.Integer;
import org.as2lib.test.unit.TestCase;
import org.as2lib.data.type.NumberFormatException;
import org.as2lib.util.ConstructorCall;

/**
 * Testcase for the Iterator type.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.type.TInteger extends TestCase {
	
	/**
	 * Uses the iterator with positive numbers.
	 */
	public function testPositiveInteger(Void):Void {
		var int:Integer = new Integer(1);
		assertEquals("1 should return 1, without modification", int, 1);
		assertEquals("The addition of 2 to 1 should be 3", int+2, 3);
		assertEquals("The addition of 2.2 to 1 should be 3.2", int+2.2, 3.2);
	}
	
	/**
	 * Uses the iterator with normal negative numbers.
	 */
	public function testNegativeInteger(Void):Void {
		var int:Integer = new Integer(-1);
		assertEquals("-1 should return -1, without modification", int, -1);
		assertEquals("The addition of 2 to -1 should be 1", int+2, (-1)+2);
		assertEquals("The addition of 2.2 to -1 should be 1.2", int+2.2, (-1)+2.2);
	}
	
	/**
	 * Validates that zero works proper.
	 */
	public function testZero() {
		var int:Integer = new Integer(0);
		assertEquals("0 should be 0, without modification", int, 0);
		assertEquals("The addition of 2 to 0 should be 2", int+2, 2);
		assertEquals("The subtraction of 2 from 0 should be -2", int-2, -2);
	}
	
	public function testInfinity() {
		assertThrows("Infinity is not allowed as integer", NumberFormatException, new ConstructorCall(Integer), [Infinity]);
		assertThrows("-Infinity is not allowed as integer", NumberFormatException, new ConstructorCall(Integer), [-Infinity]);
	}
	
	/**
	 * Validates that positive floating points works proper.
	 */
	public function testPositiveFloatingPoint() {
		var int:Integer = new Integer(1.2);
		var int2:Integer = new Integer(1.9);
		var int3:Integer = new Integer(1.6);
		assertEquals("1.2 should return 1", int, 1);
		assertEquals("1.9 should return 1", int2, 1);
		assertEquals("The addition of 2 to 1.2 should be 3", int+2, 3);
		assertEquals("The addition of 2.2 to 1.6 should be 3.2", int3+2.2, 3.2);
	}
	
	/**
	 * Validates that negative floating points works proper.
	 */
	public function testNegativeFloatingPoint() {
		var int:Integer = new Integer(-1.2);
		var int2:Integer = new Integer(-1.9);
		var int3:Integer = new Integer(-1.6);
		assertEquals("-1.2 should return -1", int, -1);
		assertEquals("-1.9 should return -1", int2, -1);
		assertEquals("The addition of 2 to -1.2 should be 1", int+2, (-1)+2);
		assertEquals("The addition of 2.2 to -1.6 should be 1.2", int3+2.2, (-1)+2.2);
	}
}