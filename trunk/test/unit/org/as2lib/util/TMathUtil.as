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
import org.as2lib.data.type.*;

/**
 * Test of all methods in MathUtil.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.util.TMathUtil extends TestCase {
	
	/**
	 * Tests different cases that are possible to get if a number is odd
	 */
	public function testIsOdd(Void):Void {
		// Normal Case
		assertTrue("1 is a odd number", MathUtil.isOdd(new Integer(1)));
		assertFalse("2 is not a odd number", MathUtil.isOdd(new Integer(2)));
		
		// Zero Case
		assertFalse("0 is a odd number", MathUtil.isOdd(new Integer(0)));
		
		// Negative Case
		assertTrue("-1 is a odd number", MathUtil.isOdd(new Integer(-1)));
		assertFalse("-2 is not a odd number", MathUtil.isOdd(new Integer(-2)));
		
		// Case with "bigger number"
		assertTrue("2047 is a odd number", MathUtil.isOdd(new Integer(2047)));
		assertFalse("2048 is not a odd number", MathUtil.isOdd(new Integer(2048)));
	}
	
	/**
	 * Tests different cases that are possible to get if a number is even
	 */
	public function testIsEven(Void):Void {
		// Normal Case
		assertFalse("1 is not a even number", MathUtil.isEven(new Integer(1)));
		assertTrue("2 is a even number", MathUtil.isEven(new Integer(2)));
		
		// Zero Case
		assertTrue("0 is a even number", MathUtil.isEven(new Integer(0)));
		
		// Negative Case
		assertFalse("-1 is not a even number", MathUtil.isEven(new Integer(-1)));
		assertTrue("-2 is a even number", MathUtil.isEven(new Integer(-2)));
		
		// Case with "bigger number"
		assertFalse("2047 is not a even number", MathUtil.isEven(new Integer(2047)));
		assertTrue("2048 is a even number", MathUtil.isEven(new Integer(2048)));
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
		for(var i=1; i<60; i++) {
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
					assertTrue(i+" is a prime number", MathUtil.isPrime(new NaturalNumber(i)));
					break;
				default:
					assertFalse(i+" is not a prime number", MathUtil.isPrime(new NaturalNumber(i)));
			}
		}
	}
	
	/**
	 * Tests factorial with working and nonworking content.
	 */
	public function testFactorial(Void):Void {
		
		// Tests some cases
		assertEquals("Factorial of 0 is 1", MathUtil.factorial(new NaturalNumberIncludingZero(0)), 1);
		assertEquals("Factorial of 1 is 1", MathUtil.factorial(new NaturalNumberIncludingZero(1)), 1);
		assertEquals("Factorial of 2 is 2", MathUtil.factorial(new NaturalNumberIncludingZero(2)), 2);
		assertEquals("Factorial of 3 is 6", MathUtil.factorial(new NaturalNumberIncludingZero(3)), 6);
		assertEquals("Factorial of 4 is 24", MathUtil.factorial(new NaturalNumberIncludingZero(4)), 24);
		assertEquals("Factorial of 5 is 120", MathUtil.factorial(new NaturalNumberIncludingZero(5)), 120);
		assertEquals("Factorial of 6 is 720", MathUtil.factorial(new NaturalNumberIncludingZero(6)), 720);
		assertEquals("Factorial of 7 is 5040", MathUtil.factorial(new NaturalNumberIncludingZero(7)), 5040);
		assertEquals("Factorial of 8 is 40320", MathUtil.factorial(new NaturalNumberIncludingZero(8)), 40320);
	}
	
	/**
	 * Compares the results of getDivisors with the real results
	 */
	public function testGetDivisors(Void):Void {
		assertTrue("Divisors of 1 are 1", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(1)), [1]));
		assertTrue("Divisors of 2 are 1,2", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(2)), [1,2]));
		assertTrue("Divisors of 3 are 1,3", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(3)), [1,3]));
		assertTrue("Divisors of 4 are 1,2,4", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(4)), [1,2,4]));
		assertTrue("Divisors of 5 are 1,5", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(5)), [1,5]));
		assertTrue("Divisors of 6 are 1,2,3,6", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(6)), [1,2,3,6]));
		assertTrue("Divisors of 7 are 1,7", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(7)), [1,7]));
		assertTrue("Divisors of 8 are 1,2,4,8", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(8)), [1,2,4,8]));
		assertTrue("Divisors of 9 are 1,3,9", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(9)), [1,3,9]));
		assertTrue("Divisors of 10 are 1,2,5,10", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(10)), [1,2,5,10]));
		assertTrue("Divisors of 11 are 1,11", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(11)), [1,11]));
		assertTrue("Divisors of 12 are 1,2,3,4,6,12", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(12)), [1,2,3,4,6,12]));
		assertTrue("Divisors of 0 are none", ArrayUtil.isSame(MathUtil.getDivisors(new NaturalNumberIncludingZero(0)), []));
	}
	
	
	/**
	 * Tests the rounding of a number with a given number of values after the comma.
	 */
	public function testRound():Void{
		assertEquals("1.2345 after rouding with 0 comma value is 1", MathUtil.round(1.2345, 0), 1);
		assertEquals("1.2345 after rouding with 1 comma value is 1.2", MathUtil.round(1.2345, 1), 1.2);
		assertEquals("1.2345 after rouding with 2 comma values is 1.23", MathUtil.round(1.2345, 2), 1.23);
		assertEquals("1.2344 after rouding with 3 comma values is 1.234", MathUtil.round(1.2344, 3), 1.234);
		assertEquals("1.2345 after rouding with 3 comma values is 1.235", MathUtil.round(1.2345, 3), 1.235);
	}
}