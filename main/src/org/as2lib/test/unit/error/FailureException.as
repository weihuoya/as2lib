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

import org.as2lib.env.except.Exception;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.test.unit.AssertException;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.test.unit.stringifier.FailureStringifier;
import org.as2lib.util.string.Stringifier;

/**
 * Rudimentary failure class for the Testunit system.
 * Most primitive failure to occur during testcases.
 * It contains only a message not even a place where it occurs.
 *
 * @autor Martin Heidegger
 * @date 16.11.2003
 */
 
class org.as2lib.test.unit.error.FailureException extends Exception implements AssertException {
	
	// Stringifier holder for the class.
	private static var stringifier:Stringifier = new FailureStringifier();
		
	/**
	 * Constructs a new FailureException.
	 * 
	 * @param message Message appended to the failure.
	 */
	function FailureException (message:String, thrower, args) {
		super(message, thrower, args);
	}
	
	/**
	 * Sets the class specific Stringifier.
	 * This stringifier will be used during @see #toString.
	 * 
	 * @param to Stringifier for all instances.
	 */
	public static function setStringifier(to:Stringifier):Void {
		stringifier = to;
	}
	
	/**
	 * Returns the stringifier for all instances.
	 * @see #toString takes this method to create string of the instance.
	 *
	 * @see #toString
	 * @return Stringifier the instances are working with.
	 */
	public static function getStringifier(Void):Stringifier {
		return stringifier;
	}
		
	/**
	 * Function to print the Failure as String.
	 * It takes the class specific stringifier (defined with @see #setStringifier)
	 * and returns the result of the stringifier.
	 * 
	 * @return	Failure as String.
	 */
    public function toString (Void):String {
		return getStringifier().execute(this);
	}
}