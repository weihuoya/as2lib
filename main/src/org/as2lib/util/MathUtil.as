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

import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.ArrayUtil;

/**
 * MathUtil contains fundamental math operations.
 *
 * @author Christophe Herreman
 */
class org.as2lib.util.MathUtil extends BasicClass {
	/**
	 * Private constructor.
	 */
	private function MathUtil() {
	}
	
	/**
	 * Checks if a number is odd.
	 * Note: Only integers can be odd!
	 *
	 * @param n The number to check.
	 * @return True if the number is odd, false if not.
	 */
	public static function isOdd(n:Number):Boolean{
		if(n%1 != 0){
			return false;
		}
		return Boolean(n%2);
	}
	
	/**
	 * Checks if a number is even.
	 * Note: Only integers can be even!
	 *
	 * @param n The number to check.
	 * @return True if the number is even, false if not.
	 */	
	public static function isEven(n:Number):Boolean{
		if(n%1 != 0){
			return false;
		}
		return (n%2 == 0);
	}
	
	/**
	 * Checks if a number is an integer.
	 *
	 * @param n The number to check.
	 * @return True if the number is an integer, false if not.
	 */	
	public static function isInteger(n:Number):Boolean{
		return (n%1 == 0);
	}

	/**
	 * Checks if a number is a naturak.
	 *
	 * @param n The number to check.
	 * @return True if the number is a natural, false if not.
	 */	
	public static function isNatural(n:Number):Boolean{
		if(n >= 0 && n%1 == 0){
			return true;
		}else{
			return false;
		}
	} 
	
	/**
	 * Checks if a number is a prime number.
	 * A prime number is a positive integer that has no positive integer
	 * divisors other than 1 and itself.
	 *
	 * @param n The number to check.
	 * @return True if the number is a prime, false if not.
	 */	
	public static function isPrime(n:Number):Boolean{
		if(n<=1){
			return false;
		}
		for(var i:Number=2; i<n-1; i++){
			if(n%i == 0){
				return false;
			}
		}
		return true;
	}
		
	/**
	 * Calculates the factorial of a given number.
	 *
	 * @param n The number to calculate its factorial from.
	 * @return The factorial of the number.
	 */
	public static function factorial(n:Number):Number{
		if(n < 0 || n%1 != 0){
			throw new IllegalArgumentException("The passed argument must be a positive integer.", eval("th"+"is"), arguments);
		}
		if(n == 0){
			return 1;
		}
		for(var i:Number = n-1; i>1; i--){
			n*=i;
		}
		return n;
	}
		
	/**
	 * Returns an array with all the divisors of a given number.
	 *
	 * @param Number The number to get the divisors from.
	 * @return An array with the divisors of the number.
	 */
	public static function getDivisors(n:Number):Array{
		var divisors:Array = new Array();
		for(var i:Number=1; i<=n; i++){
			if(n%i == 0){
				divisors.push(i);
			}
		}
		return divisors;
	}
	

}