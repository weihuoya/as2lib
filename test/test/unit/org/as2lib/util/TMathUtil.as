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
import org.as2lib.util.ArrayUtil;
import org.as2lib.util.MathUtil;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Test of all methods in MathUtil.
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.util.TMathUtil extends TestCase {
	
	/**
	 * Tests different cases that are possible to get if a number is odd
	 */
	public function testIsOdd(Void):Void {
		// Normal Case
		assertTrue("1 is a odd number", MathUtil.isOdd(1));
		assertFalse("2 is not a odd number", MathUtil.isOdd(2));
		
		// Zero Case
		assertFalse("0 is a odd number", MathUtil.isOdd(0));
		
		// Negative Case
		assertTrue("-1 is a odd number", MathUtil.isOdd(-1));
		assertFalse("-2 is not a odd number", MathUtil.isOdd(-2));
		
		// Case with "bigger number"
		assertTrue("2047 is a odd number", MathUtil.isOdd(2047));
		assertFalse("2048 is not a odd number", MathUtil.isOdd(2048));
		
		// Case with floating point numbers (base will be used)
		assertFalse("1.47 is not a odd number", MathUtil.isOdd(1.47));
		assertFalse("1.48 is not a odd number", MathUtil.isOdd(1.48));
		assertFalse("2.47 is not a odd number", MathUtil.isOdd(2.47));
		assertFalse("2.48 is not a odd number", MathUtil.isOdd(2.48));
	}
	
	/**
	 * Tests different cases that are possible to get if a number is even
	 */
	public function testIsEven(Void):Void {
		// Normal Case
		assertFalse("1 is not a even number", MathUtil.isEven(1));
		assertTrue("2 is a even number", MathUtil.isEven(2));
		
		// Zero Case
		assertTrue("0 is a even number", MathUtil.isEven(0));
		
		// Negative Case
		assertFalse("-1 is not a even number", MathUtil.isEven(-1));
		assertTrue("-2 is a even number", MathUtil.isEven(-2));
		
		// Case with "bigger number"
		assertFalse("2047 is not a even number", MathUtil.isEven(2047));
		assertTrue("2048 is a even number", MathUtil.isEven(2048));
		
		// Case with floating point numbers (base will be used)
		assertFalse("1.47 is not a even number", MathUtil.isEven(1.47));
		assertFalse("1.48 is not a even number", MathUtil.isEven(1.48));
		assertFalse("2.47 is not a even number", MathUtil.isEven(2.47));
		assertFalse("2.48 is not a even number", MathUtil.isEven(2.48));
	}
	
	/**
	 * Tests positive and negative integers and floatings points if they are integer.
	 */
	public function testIsInteger(Void):Void {
		// Testing normal case
		assertTrue("2 is a integer", MathUtil.isInteger(2));
		assertTrue("1 is a integer", MathUtil.isInteger(1));
		assertTrue("-1 is a integer", MathUtil.isInteger(-1));
		assertTrue("-2 is a integer", MathUtil.isInteger(-2));
		
		// Testing zero case
		assertTrue("0 is a integer", MathUtil.isInteger(0));
		
		// Testing floating point cases.
		assertFalse("2.2 is not a integer", MathUtil.isInteger(2.2));
		assertFalse("1.1 is not a integer", MathUtil.isInteger(1.1));
		assertFalse("-1.1 is not a integer", MathUtil.isInteger(-1.1));
		assertFalse("-2.1 is not a integer", MathUtil.isInteger(-2.2));
		
		// Testing extreme cases
		assertTrue("1/3*3 is a integer", MathUtil.isInteger(1/3*3));
	}

	/**
	 * Tests some cases if they are natural.
	 */
	public function testIsNatural(Void):Void {
		// Normal case
		assertTrue("2 is a natural number", MathUtil.isNatural(2));
		assertFalse("-2 is not a natural number", MathUtil.isNatural(-2));
		
		// Zero case
		assertTrue("0 is a natural number", MathUtil.isNatural(0));
		
		// Floating points
		assertFalse("2.2 is not a natural number", MathUtil.isNatural(2.2));
		assertFalse("-2.2 is not a natural number", MathUtil.isNatural(-2.2));
	} 
	
	/**
	 * Tests some working cases and non-working cases.
	 */
	public function testIsPrime(Void):Void {
		
		// Tests the first 60 numbers
		for(var i=0; i<60; i++) {
			switch(i) {
				case 2:
				case 3:
				case 5:
				case 7:
				case 11:
				case 13:
				case 17:
				case 19:
				case 23:
				case 29:
				case 31:
				case 37:
				case 41:
				case 43:
				case 47:
				case 53:
				case 59:
					assertTrue(i+" is a prime number", MathUtil.isPrime(i));
					break;
				default:
					assertFalse(i+" is not a prime number", MathUtil.isPrime(i));
			}
		}
		
		// Zero Case
		assertFalse("0 is not a prime number", MathUtil.isPrime(0));
		
		// Negative Case
		assertFalse("-3 is not a prime number", MathUtil.isPrime(-3));
	}
	
	/**
	 * Tests factorial with working and nonworking content.
	 */
	public function testFactorial(Void):Void {
		
		// Tests some cases
		assertEquals("Factorial of 0 is 1", MathUtil.factorial(0), 1);
		assertEquals("Factorial of 1 is 1", MathUtil.factorial(1), 1);
		assertEquals("Factorial of 2 is 2", MathUtil.factorial(2), 2);
		assertEquals("Factorial of 3 is 6", MathUtil.factorial(3), 6);
		assertEquals("Factorial of 4 is 24", MathUtil.factorial(4), 24);
		assertEquals("Factorial of 5 is 120", MathUtil.factorial(5), 120);
		assertEquals("Factorial of 6 is 720", MathUtil.factorial(6), 720);
		assertEquals("Factorial of 7 is 5040", MathUtil.factorial(7), 5040);
		assertEquals("Factorial of 8 is 40320", MathUtil.factorial(8), 40320);
		
		assertThrows("Getting the factorial of -1 should throw a IllegalArgumentException", IllegalArgumentException, MathUtil, "factorial", [-1]);
		assertThrows("Getting the factorial of 0.5 should throw a IllegalArgumentException", IllegalArgumentException, MathUtil, "factorial", [0.5]);
	}
	
	/**
	 * Compares the results of getDivisors with the real results
	 */
	public function testGetDivisors(Void):Void {
		assertTrue("Divisors of 1 are 1", ArrayUtil.isSame(MathUtil.getDivisors(1), [1]));
		assertTrue("Divisors of 2 are 1,2", ArrayUtil.isSame(MathUtil.getDivisors(2), [1,2]));
		assertTrue("Divisors of 3 are 1,3", ArrayUtil.isSame(MathUtil.getDivisors(3), [1,3]));
		assertTrue("Divisors of 4 are 1,2,4", ArrayUtil.isSame(MathUtil.getDivisors(4), [1,2,4]));
		assertTrue("Divisors of 5 are 1,5", ArrayUtil.isSame(MathUtil.getDivisors(5), [1,5]));
		assertTrue("Divisors of 6 are 1,2,3,6", ArrayUtil.isSame(MathUtil.getDivisors(6), [1,2,3,6]));
		assertTrue("Divisors of 7 are 1,7", ArrayUtil.isSame(MathUtil.getDivisors(7), [1,7]));
		assertTrue("Divisors of 8 are 1,2,4,8", ArrayUtil.isSame(MathUtil.getDivisors(8), [1,2,4,8]));
		assertTrue("Divisors of 9 are 1,3,9", ArrayUtil.isSame(MathUtil.getDivisors(9), [1,3,9]));
		assertTrue("Divisors of 10 are 1,2,5,10", ArrayUtil.isSame(MathUtil.getDivisors(10), [1,2,5,10]));
		assertTrue("Divisors of 11 are 1,11", ArrayUtil.isSame(MathUtil.getDivisors(11), [1,11]));
		assertTrue("Divisors of 12 are 1,2,3,4,6,12", ArrayUtil.isSame(MathUtil.getDivisors(12), [1,2,3,4,6,12]));
		assertTrue("Divisors of 0 are none", ArrayUtil.isSame(MathUtil.getDivisors(0), []));
	}
	
}