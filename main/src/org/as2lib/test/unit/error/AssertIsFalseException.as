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
 
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Throwable;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.SimpleStack;
import org.as2lib.test.unit.Assert;
import org.as2lib.test.unit.AssertException;
import org.as2lib.test.unit.TestCaseInformation;
import org.as2lib.test.unit.TestCaseError;
import org.as2lib.test.unit.stringifier.AssertIsFalseStringifier;
import org.as2lib.util.string.Stringifier;

/**
 * Failure class for Failures occur during a Testcase.
 * It is the simples possible Failute that could be thrown.
 * The Single Special Property is @see #message.
 * 
 * @autor Martin Heidegger.
 */
class org.as2lib.test.unit.error.AssertIsFalseException extends BasicClass implements AssertException {
	/** Stringifier for the TestCase */
	private static var stringifier:Stringifier = new AssertIsFalseStringifier();
	
	/** Error Holder */
	private var wrongVar;
	
	/** Message related to the Failure */
	private var message:String;

	private var cause:Throwable;	
	
	/**
	 * Constructs a new AssertThows exception.
	 * 
	 * @param inTest	TestCase where the Failure occured.
	 * @param message	Message appended to the Failure.
	 */
	public function AssertIsFalseException (message:String, wrongVar) {
		this.wrongVar = wrongVar;
		this.message = message;
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
	 * Returns the Testcase where the Error occured.
	 * Implementation of the superclass.
	 * 
	 * @return TestCase where the Error occured.
	 */
	public function getWrongVariable(Void) {
		return this.wrongVar;
	}
	
	/**
	 * Returns the Message of the Failure.
	 *  
	 * @return Message of the Failure.
	 */
	public function getMessage(Void):String {
		return this.message;
	}
	
	/**
	 * Executes the static stringifier and returns the result.
	 * 
	 * @return Failure as string.
	 */
	public function toString (Void):String {
		return getStringifier().execute(this);
	}	
	public function initCause(cause:Throwable):Throwable {
		this.cause = cause;
		return this;
	}
	
	public function getCause(Void):Throwable {
		return this.cause;
	}
	
	public function getStackTrace(Void):Stack {
		return new SimpleStack;
	}
}