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
import org.as2lib.test.unit.stringifier.AssertIsNotEqualStringifier;
import org.as2lib.util.string.Stringifier;

/**
 * Failure class for Failures occur during a Testcase.
 * It marks that the arguments are not equal.
 * 
 * @autor Martin Heidegger.
 */
class org.as2lib.test.unit.error.AssertIsNotEqualException extends Exception implements AssertException {
	/** Stringifier for the TestCase */
	private static var stringifier:Stringifier = new AssertIsNotEqualStringifier();
	
	/** Compared Var Holder */
	private var comparedVar;
	
	/** Error Holder */
	private var mainVar;

	/**
	 * Constructs a new AssertIsEqualException.
     *
	 * @param message		Message appended to the Failure.
	 * @param mainVar		Variable that was handled to root.
	 * @param comparedVar	Variable that got compared with the mainVar.
	 * @param thrower		Thrower for the Exception
	 * @param arguments		Arguments for the Exception
	 */
	public function AssertIsNotEqualException (message:String, mainVar, comparedVar, thrower, args:FunctionArguments) {
		super(message, thrower, args);
		this.mainVar = mainVar;
		this.comparedVar = comparedVar;
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
	 * @return The main variable that the var was compared with.
	 */
	public function getMainVariable(Void) {
		return mainVar;
	}
	
	/**
	 * 
	 * 
	 * @return The variable that was compared.
	 */
	public function getComparedVariable(Void) {
		return comparedVar;
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