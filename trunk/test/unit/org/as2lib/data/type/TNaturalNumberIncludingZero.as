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
 import org.as2lib.data.type.NaturalNumberIncludingZero;
 import org.as2lib.data.type.NumberFormatException;
 import org.as2lib.util.ConstructorCall;
 
 /**
  * Test for the Natural Number type (that includes zero).
  * 
  * @author Martin Heidegger
  */
 class org.as2lib.data.type.TNaturalNumberIncludingZero extends TestCase {
	 
	/**
	 * Test the Natural Number if you apply a positive integer.
	 */
	public function testPositiveInteger() {
		assertEquals("1 should return 1, without modification", new NaturalNumberIncludingZero(1), 1);
		assertEquals("1/3 should return 0, rounded down", new NaturalNumberIncludingZero(1/3), 0);
		assertEquals("The addition of 2 to 1 should be 3", new NaturalNumberIncludingZero(1)+2, 3);
		assertEquals("The addition of 2.2 to 1 should be 3.2", new NaturalNumberIncludingZero(1)+2.2, 3.2);
	}
	
	/**
	 * Test the Natural Number if you apply a negative integer.
	 */ 
	public function testNegativeInteger() {
		assertThrows("Negative numbers are not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumberIncludingZero), [-1]);
		assertThrows("Big Negative numbers are not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumberIncludingZero), [-256]);
	}
	
	/**
	 * Test the Natural Number if you apply zero.
	 */
	public function testZero() {
		assertEquals("Zero is allowed in natural", new NaturalNumberIncludingZero(0), 0);
	}
	
	/**
	 * Test the Natural Number if you apply + and - Infinity.
	 */
	public function testInfinity() {
		assertThrows("Infinity is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumberIncludingZero), [Infinity]);
		assertThrows("-Infinity is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumberIncludingZero), [-Infinity]);
	}
	
	/**
	 * Test the Natural Number if you apply Floating points.
	 */
	public function testPositiveFloatingPoint() {
		assertEquals("1.2 shoudld be 1", new NaturalNumberIncludingZero(1.2), 1);
		assertEquals("1.2+1 should be 2", new NaturalNumberIncludingZero(1.2)+1, 2);
		assertEquals("1/3+1 should be 1 1/3", new NaturalNumberIncludingZero(1/3+1), 1);
	}
	
	/**
	 * Test the Natural Number if you apply negative Floating points.
	 */
	public function testNegativeFloatingPoint() {
		assertEquals("-1/3 is allowed because it is rounded down 0", new NaturalNumberIncludingZero(-1/3), 0);
		assertThrows("-1.2 is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumberIncludingZero), [-1.2]);
		assertThrows("-1 1/3 is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumberIncludingZero), [-1-1/3]);
	}
 }
