/**
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
import org.as2lib.test.unit.AssertException;
import org.as2lib.test.unit.stringifier.AssertIsNotInfinityStringifier;
import org.as2lib.util.string.Stringifier;

/**
 * Failure class for Failures occur during a Testcase.
 * It is the simples possible Failute that could be thrown.
 * The Single Special Property is @see #message.
 * 
 * @autor Martin Heidegger.
 */
class org.as2lib.test.unit.error.AssertIsNotInfinityException extends Exception implements AssertException {
	/** Stringifier for the TestCase */
	private static var stringifier:Stringifier = new AssertIsNotInfinityStringifier();
	
	/**
	 * Constructs a new AssertIsNotInfinity exception.
	 * 
	 * @param message	Message appended to the Failure.
	 * @param thrower	Object where the exception occured.
	 * @param arguments	Argument of the method where the exception occured.
	 */
	public function AssertIsNotInfinityException (message:String, thrower, arguments:FunctionArguments) {
		super(message, thrower, arguments);
	}
	
	/**
	 * Sets the stringifier for this class.
	 * The stringifier will be used for the execution of the
	 * @see #toString.
	 *
	 * @param s	Stringifier of this class.
	 */
	public static function setStringifier (s:Stringifier):Void {
		stringifier = s;
	}
	
	/**
	 * Returns the stringifier of this class.
	 * The stringifier will be used for the execution of the
	 * @see #toString.
	 * 
	 * @return The stringifier of this class.
	 */
	public static function getStringifier (Void):Stringifier {
		return stringifier;
	}
	
	/**
	 * Executes the static stringifier and returns the result.
	 * 
	 * @return Failure as string.
	 */
	public function toString (Void):String {
		return getStringifier().execute(this);
	}
}