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
 import org.as2lib.data.type.NaturalNumber;
 import org.as2lib.data.type.NumberFormatException;
 import org.as2lib.util.ConstructorCall;
 
 /**
  * Test for the Natural Number type.
  * 
  * @author Martin Heidegger
  */
 class org.as2lib.data.type.TNaturalNumber extends TestCase {
	 
	/**
	 * Test the Natural Number if you apply a positive integer.
	 */
	public function testPositiveInteger() {
		assertEquals("1 should return 1, without modification", new NaturalNumber(1), 1);
		assertThrows("1/3 is not allowed in natural because rounded down it would be 0", NumberFormatException, new ConstructorCall(NaturalNumber), [1/3]);
		assertEquals("The addition of 2 to 1 should be 3", new NaturalNumber(1)+2, 3);
		assertEquals("The addition of 2.2 to 1 should be 3.2", new NaturalNumber(1)+2.2, 3.2);
	}
	
	/**
	 * Test the Natural Number if you apply a negative integer.
	 */ 
	public function testNegativeInteger() {	 
		assertThrows("Negative numbers are not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [-1]);
		assertThrows("Big Negative numbers are not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [-256]);
	}
	
	/**
	 * Test the Natural Number if you apply zero.
	 */
	public function testZero() {
		assertThrows("Zero is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [0]);
	}
	
	/**
	 * Test the Natural Number if you apply + and - Infinity.
	 */
	public function testInfinity() {
		assertThrows("Infinity is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [Infinity]);
		assertThrows("-Infinity is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [-Infinity]);
	}
	
	/**
	 * Test the Natural Number if you apply Floating points.
	 */
	public function testPositiveFloatingPoint() {
		assertEquals("1.2 shoudld be 1", new NaturalNumber(1.2), 1);
		assertEquals("1.2+1 should be 2", new NaturalNumber(1.2)+1, 2);
		assertEquals("1/3+1 should be 1 1/3", new NaturalNumber(1/3+1), 1);
	}
	
	/**
	 * Test the Natural Number if you apply negative Floating points.
	 */
	public function testNegativeFloatingPoint() {
		assertThrows("-1.2 is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [-1.2]);
		assertThrows("-1/3 is not allowed in natural", NumberFormatException, new ConstructorCall(NaturalNumber), [-1/3]);
	}
 }
