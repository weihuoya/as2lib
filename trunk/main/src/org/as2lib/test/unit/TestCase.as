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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
import org.as2lib.test.unit.error.*;
import org.as2lib.test.unit.Assert;
import org.as2lib.test.unit.AssertException;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.util.Call;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.ObjectUtil;

/**
 * Basic Testcase class to be extended.
 * A Testcase defines the Access to all parts of the TestUnit System of as2lib.
 * 
 * It is handled as an abstract class this means you have to extend it if you 
 * want to work with the system (similar to the most other testunit systems).
 * [CODE]
 * import org.as2lib.test.unit.TestCase;
 * 
 * class MyTestCase extends TestCase {
 * }
 * [/CODE]
 * 
 * A testcase usually gets processed by @see #run. 
 * The System will fetch all Methods starting with "test" and execute them in
 * a new, isolated instance. Before each method call the methods @see #setUp and
 * @see #tearDown will get called.
 *
 * Example:
 *   Testcase:
 *   [CODE]
 * import org.as2lib.test.unit.TestCase;
 * 
 * class MyTestCase extends TestCase {
 *   public function TestCase(Void) {
 *     trace('new instance');
 *   }
 *   public function setUp(Void){
 *     trace('set up');
 *   }
 *   public function testMyFirstTest(Void) {
 *     trace('myFirstTest');
 *   }
 *   public function testMySecondTest(Void) {
 *     trace('mySecondTest');
 *   }
 *   public function tearDown(Void){
 *     trace('tear down');
 *   }
 * }
 *   [/CODE]
 *   Call:
 *   [CODE]
 * new MyTestCase().run(true);
 *   [/CODE]
 *   Result:
 *   [CODE]
 * new instance
 * set up
 * myFirstTest
 * tear down
 * new instance
 * set up
 * mySecondTest
 * tear down
 *   [/CODE]
 * 
 * Within the "test"-methods you have access to different assert methods:
 * <table>
 *   <thead>
 *     <tr>
 *       <th>Methodname</th>
 *       <th>Checks</th>
 *     </tr>
 *   </thead>
 *   <tbody>
 *     <tr>
 *       <th>assertTrue</th>
 *       <td><i>value</i> === true</td>
 *     </tr>
 *     <tr>
 *       <th>assertFalse</th>
 *       <td><i>value</i> === false</td>
 *     </tr>
 *     <tr>
 *       <th>assertEquals</th>
 *       <td><i>a</i> == <i>b</i></td>
 *     </tr>
 *     <tr>
 *       <th>assertNotEquals</th>
 *       <td><i>a</i> != <i>b</i></td>
 *     </tr>
 *     <tr>
 *       <th>assertSame</th>
 *       <td><i>a</i> === <i>b</i></td>
 *     </tr>
 *     <tr>
 *       <th>assertNotSame</th>
 *       <td><i>a</i> !== <i>b</i></td>
 *     </tr>
 *     <tr>
 *       <th>assertNull</th>
 *       <td><i>value</i> === null</td>
 *     </tr>
 *     <tr>
 *       <th>assertNotNull</th>
 *       <td><i>value</i> !== null</td>
 *     </tr>
 *     <tr>
 *       <th>assertUndefined</th>
 *       <td><i>value</i> === undefined</td>
 *     </tr>
 *     <tr>
 *       <th>assertNotUndefined</th>
 *       <td><i>value</i> !== undefined</td>
 *     </tr>
 *     <tr>
 *       <th>assertEmpty</th>
 *       <td><i>value</i> == null (equals == undefined)</td>
 *     </tr>
 *     <tr>
 *       <th>assertNotEmpty</th>
 *       <td><i>value</i> != null (equals != undefined)</td>
 *     </tr>
 *     <tr>
 *       <th>assertInfinity</th>
 *       <td><i>value</i> === Infinity</td>
 *     </tr>
 *     <tr>
 *       <th>assertNotInfinity</th>
 *       <td><i>value</i> !== Infinity</td>
 *     </tr>
 *     <tr>
 *       <th>assertThrows</th>
 *       <td><i>call</i>(<i>arguments</i>) throws <i>exception</i></td>
 *     </tr>
 *     <tr>
 *       <th>assertNotThrows</th>
 *       <td><i>call</i>(<i>arguments</i>) doesnt throw <i>exception</i></td>
 *     </tr>
 *   </tbody>
 * </table>
 * 
 * Note: All assertions refer to @see Assert methods. 
 * 
 * You have also got the possibility to simple fail the Testcase by @see #fail.
 *
 * @see org.as2lib.test.unit.TestSuite
 * @see org.as2lib.test.unit.Test
 * @see org.as2lib.test.unit.Assert
 * @see org.as2lib.test.unit.TestResults
 * @autor Martin Heidegger
 */

class org.as2lib.test.unit.TestCase extends BasicClass implements Test {
	
	// Internal Holder for the TestRunner context the method is running in.
	private var testRunner:TestRunner;
	
	/**
	 * Abstract constructor. You should extend this class to use the API.
	 */
	private function TestCase(Void) {}
	
	/**
	 * Template method to set up the testcase before running a method.
	 * This method will get called before executing each method in a clean,
	 * new instance.
	 */
	public function setUp(Void):Void {}
	
	/**
	 * Template method to tear down the testcase after running a method.
	 * This method will get called after the execution of each method of this
	 * testcase.
	 */
	public function tearDown(Void):Void {}
	
	/**
	 * Runs this testcase.
	 * Implementation of @see Test. 
	 * Runs all methods of this testcase in an new container.
	 * 
	 * @see TestRunner.run
	 * @param doNotPrintResult Parameter to prevent immediately printing of the Result.
	 * @return Result of the run. Warning the result is lacy, this means its values could
	 *         get filled after you recieved it. (related to @see #pause and @see #resume).
	 */
	public function run(doNotPrintResult:Boolean):TestResult {
		if(!doNotPrintResult) {
			 doNotPrintResult = false;
		}
		return new TestRunner().run(ClassUtil.createCleanInstance(getClass().getType()), doNotPrintResult);
	}
	
	/**
	 * Pauses the execution of this testcase.
	 * This method has been introduces to pause the execution of this method.
	 * The run will not be completed if @see #resume will not get called!
	 */
	private function pause(Void):Void {
		getTestRunner().pause();
	}
	
	/**
	 * Resumes the run of this method.
	 * This method resumes the execution of the testcase.
	 */
	private function resume(Void):Void {
		getTestRunner().resume();
	}
	
	/**
	 * Setter for the testrunner.
	 * The testrunner represents the context of the actual method.
	 * @see #getMethodInformation is a referred to the informations that represent this
	 * methods information. It will be automatically set by the testrunner.
	 * 
	 * @param testRunner Used testrunner for this testcase.
	 */
	public function setTestRunner(testRunner:TestRunner):Void {
		this.testRunner = testRunner;
	}
	
	/**
	 * Getter for the testrunner.
	 * The testrunner represents the context of the actual method.
	 * The testrunner is usually only available within a testunit run.
	 * 
	 * @return Current testrunner.
	 */
	private function getTestRunner(Void):TestRunner {
		return testRunner;
	}
	
	/**
	 * Returns the methodinformation for the method that is currently executed.
	 * The methodinformation represents the information holder for the current
	 * method that is executed.
	 * 
	 * Usually only available during the execution of the testcase.
	 * 
	 * @see TestRunner
	 * @see #getTestRunner
	 * @return Methodinformation for the curre
	 */
	private function getMethodInformation(Void):TestCaseMethodInfo {
		return getTestRunner().getCurrentTestCaseMethodInfo();
	}
	
	/**
	 * Simply fails the current Testcase.
	 * 
	 * @param message Message to the failing of the method.
	 */
	private function fail(message:String):Void {
		message = (typeof message == "string") ? message : "<no message applied>";
		getMethodInformation().addError(new FailureException(message, this, arguments));
	}
	
	/**
	 * overload
	 * @see #assertTrueWithMessage
	 * @see #assertTrueWithoutMessage
	 */
	private function assertTrue():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertTrueWithMessage);
		overload.addHandler([String, Object], assertTrueWithMessage);
		overload.addHandler([undefined], assertTrueWithoutMessage);
		overload.addHandler([Object], assertTrueWithoutMessage);
		overload.addHandler([], assertTrueWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is true.
	 * This methods adds a Failure to TestResult if you submit a parameter
	 * that is not "true".
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isTrue
	 * @see #assertTrue
	 * @see #assertTrueWithMessage
	 * @param val Boolean that should be "true".
	 * @return true if no error occured else false
	 */
	private function assertTrueWithoutMessage(val:Boolean):Boolean {
		return assertTrueWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is true or fails with a message.
	 * This methods asserts the same like @see #assertTrueWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isTrue
	 * @see #assertTrue
	 * @see #assertTrueWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Boolean that should be "true".
	 * @return true if no error occured else false
	 */
	private function assertTrueWithMessage(message:String, val:Boolean):Boolean {
		try {
			Assert.isTrue(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertTrue", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertFalseWithMessage
	 * @see #assertFalseWithoutMessage
	 */
	private function assertFalse():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertFalseWithMessage);
		overload.addHandler([String, Object], assertFalseWithMessage);
		overload.addHandler([undefined], assertFalseWithoutMessage);
		overload.addHandler([Object], assertFalseWithoutMessage);
		overload.addHandler([], assertFalseWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is false else it fails.
	 * This methods adds a Failure to TestResult if you submit a parameter
	 * that is not "false".
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isFalse
	 * @see #assertFalse
	 * @see #assertFalseWithMessage
	 * @param val Boolean that should be "false".
	 * @return true if no error occured else false
	 */
	private function assertFalseWithoutMessage(val:Boolean):Boolean {
		return assertFalseWithMessage("", val);
	}
	
	/**
	 * Asserts if a valueis false or fails.
	 * This method asserts the same like @see #assertFalseWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isFalse
	 * @see #assertFalse
	 * @see #assertFalseWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Boolean that should be "false".
	 * @return true if no error occured else false
	 */
	private function assertFalseWithMessage(message:String, val:Boolean):Boolean {
		try {
			Assert.isFalse(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertFalse", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertEqualsWithMessage
	 * @see #assertEqualsWithoutMessage
	 */
	private function assertEquals():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, undefined], assertEqualsWithMessage);
		overload.addHandler([String, undefined, Object], assertEqualsWithMessage);
		overload.addHandler([String, Object, Object], assertEqualsWithMessage);
		overload.addHandler([String, undefined], assertEqualsWithMessage);
		overload.addHandler([String, Object], assertEqualsWithMessage);
		overload.addHandler([undefined, undefined], assertEqualsWithoutMessage);
		overload.addHandler([undefined, Object], assertEqualsWithoutMessage);
		overload.addHandler([Object, undefined], assertEqualsWithoutMessage);
		overload.addHandler([Object, Object], assertEqualsWithoutMessage);
		overload.addHandler([undefined], assertEqualsWithoutMessage);
		overload.addHandler([Object], assertEqualsWithoutMessage);
		overload.addHandler([], assertEqualsWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that two variables contain the same value else it fails.
	 * This method compares two variables if they contain the same value.
	 * It compares the two variables with "==". @see #assertSame compares
	 * two variables with "===" as exact reference match.
	 * 
	 * Note: This method refers to the Assert Util
	 * Note: This method is completly the same method like @see #assertSame.
	 * 
	 * @see Assert#isEqual
	 * @see Assert#isSame
	 * @see #assertEquals
	 * @see #assertEqualsWithMessage
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertEqualsWithoutMessage(val, compareTo):Boolean {
		return assertEqualsWithMessage("", val, compareTo);
	}
	
	/**
	 * Asserts that two variables contain the same value else it fails.
	 * This method asserts the same like @see #assertEqualsWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isEqual
	 * @see Assert#isSame
	 * @see #assertEquals
	 * @see #assertEqualsWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertEqualsWithMessage(message:String, val, compareTo):Boolean {
		try {
			Assert.isEqual(message, val, compareTo);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertEquals", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNotEqualsWithMessage
	 * @see #assertNotEqualsWithoutMessage
	 */
	private function assertNotEquals():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, undefined], assertNotEqualsWithMessage);
		overload.addHandler([String, undefined, Object], assertNotEqualsWithMessage);
		overload.addHandler([String, Object, Object], assertNotEqualsWithMessage);
		overload.addHandler([String, undefined], assertNotEqualsWithMessage);
		overload.addHandler([String, Object], assertNotEqualsWithMessage);
		overload.addHandler([undefined, undefined], assertNotEqualsWithoutMessage);
		overload.addHandler([undefined, Object], assertNotEqualsWithoutMessage);
		overload.addHandler([Object, undefined], assertNotEqualsWithoutMessage);
		overload.addHandler([Object, Object], assertNotEqualsWithoutMessage);
		overload.addHandler([undefined], assertNotEqualsWithoutMessage);
		overload.addHandler([Object], assertNotEqualsWithoutMessage);
		overload.addHandler([], assertNotEqualsWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that two variables do not contain the same value else it fails.
	 * This method compares two variables if they do not contain the same value.
	 * It compares the two variables with "!=". @see #assertNotSame compares
	 * two variables with "!==" as exact reference match.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNotEqual
	 * @see Assert#isNotSame
	 * @see #assertNotEquals
	 * @see #assertNotEqualsWithMessage
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertNotEqualsWithoutMessage(val, compareTo):Boolean {
		return assertNotEqualsWithMessage("", val, compareTo);
	}
	
	/**
	 * Asserts that two variables do not contain the same value else it fails.
	 * This method asserts the same like @see #assertNotEqualsWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNotEqual
	 * @see Assert#isNotSame
	 * @see #assertNotEquals
	 * @see #assertNotEqualsWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertNotEqualsWithMessage(message:String, val, compareTo):Boolean {
		try {
			Assert.isNotEqual(message, val, compareTo);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotEquals", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertSameWithMessage
	 * @see #assertSameWithoutMessage
	 */
	private function assertSame():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, undefined], assertSameWithMessage);
		overload.addHandler([String, undefined, Object], assertSameWithMessage);
		overload.addHandler([String, Object, Object], assertSameWithMessage);
		overload.addHandler([String, undefined], assertSameWithMessage);
		overload.addHandler([String, Object], assertSameWithMessage);
		overload.addHandler([undefined, undefined], assertSameWithoutMessage);
		overload.addHandler([undefined, Object], assertSameWithoutMessage);
		overload.addHandler([Object, undefined], assertSameWithoutMessage);
		overload.addHandler([Object, Object], assertSameWithoutMessage);
		overload.addHandler([undefined], assertSameWithoutMessage);
		overload.addHandler([Object], assertSameWithoutMessage);
		overload.addHandler([], assertSameWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that two variables contain the same object reference else it fails.
	 * This method compares two variables if they contain the same object reference.
	 * It compares the two variables with "===". @see #assertEquals compares
	 * two variables with "==" as value match.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isEqual
	 * @see Assert#isSame
	 * @see #assertSame
	 * @see #assertSameWithMessage
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertSameWithoutMessage(val, compareTo):Boolean {
		return assertSameWithMessage("", val, compareTo);
	}
	
	/**
	 * Asserts that two variables contain the same object reference else it fails.
	 * This method asserts the same like @see #assertSameWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isEqual
	 * @see Assert#isSame
	 * @see #assertSame
	 * @see #assertSameWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertSameWithMessage(message:String, val, compareTo):Boolean {
		try {
			Assert.isSame(message, val, compareTo);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertSame", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNotSameWithMessage
	 * @see #assertNotSameWithoutMessage
	 */
	private function assertNotSame():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, undefined], assertNotSameWithMessage);
		overload.addHandler([String, undefined, Object], assertNotSameWithMessage);
		overload.addHandler([String, Object, Object], assertNotSameWithMessage);
		overload.addHandler([String, undefined], assertNotSameWithMessage);
		overload.addHandler([String, Object], assertNotSameWithMessage);
		overload.addHandler([undefined, undefined], assertNotSameWithoutMessage);
		overload.addHandler([undefined, Object], assertNotSameWithoutMessage);
		overload.addHandler([Object, undefined], assertNotSameWithoutMessage);
		overload.addHandler([Object, Object], assertNotSameWithoutMessage);
		overload.addHandler([undefined], assertNotSameWithoutMessage);
		overload.addHandler([Object], assertNotSameWithoutMessage);
		overload.addHandler([], assertNotSameWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that two variables do not contain the same object reference else it fails.
	 * This method compares two variables if they do not contain the same object reference.
	 * It compares the two variables with "!==". @see #assertNotEquals compares
	 * two variables with "!=" as value match.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNotEqual
	 * @see Assert#isNotSame
	 * @see #assertNotSame
	 * @see #assertNotSameWithMessage
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertNotSameWithoutMessage(val, compareTo):Boolean {
		return assertNotSameWithMessage("", val, compareTo);
	}
	
	/**
	 * Asserts that two variables do not contain the same object reference else it fails.
	 * This method asserts the same like @see #assertNotSameWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNotEqual
	 * @see Assert#isNotSame
	 * @see #assertNotSame
	 * @see #assertNotSameWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertNotSameWithMessage(message:String, val, compareTo):Boolean {
		try {
			Assert.isNotSame(message, val, compareTo);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotSame", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNullWithMessage
	 * @see #assertNullWithoutMessage
	 */
	private function assertNull():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertNullWithMessage);
		overload.addHandler([String, Object], assertNullWithMessage);
		overload.addHandler([undefined], assertNullWithoutMessage);
		overload.addHandler([Object], assertNullWithoutMessage);
		overload.addHandler([], assertNullWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is null else it fails.
	 * Method to assert that a value is null.
	 * It adds a error to the result if the value is not null.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNull
	 * @see #assertNull
	 * @see #assertNullWithMessage
	 * @param val Object that should be null.
	 * @return true if no error occured else false
	 */
	private function assertNullWithoutMessage(val):Boolean {
		return assertNullWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is null else it fails.
	 * This method asserts the same like @see #assertNullWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNull
	 * @see #assertNull
	 * @see #assertNullWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be null.
	 * @return true if no error occured else false
	 */
	private function assertNullWithMessage(message:String, val):Boolean {
		try {
			Assert.isNull(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNull", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNotNullWithMessage
	 * @see #assertNotNullWithoutMessage
	 */
	private function assertNotNull():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertNotNullWithMessage);
		overload.addHandler([String, Object], assertNotNullWithMessage);
		overload.addHandler([undefined], assertNotNullWithoutMessage);
		overload.addHandler([Object], assertNotNullWithoutMessage);
		overload.addHandler([], assertNotNullWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is not null else it fails.
	 * Method to assert that a value is not null.
	 * It adds a error to the result if the value is null.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNotNull
	 * @see #assertNotNull
	 * @see #assertNotNullWithMessage
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertNotNullWithoutMessage(val):Boolean {
		return assertNotNullWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is not null else it fails.
	 * This method asserts the same like @see #assertNotNullWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNotNull
	 * @see #assertNotNull
	 * @see #assertNotNullWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertNotNullWithMessage(message:String, val):Boolean {
		try {
			Assert.isNotNull(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotNull", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertUndefinedWithMessage
	 * @see #assertUndefinedWithoutMessage
	 */
	private function assertUndefined():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertUndefinedWithMessage);
		overload.addHandler([String, Object], assertUndefinedWithMessage);
		overload.addHandler([undefined], assertUndefinedWithoutMessage);
		overload.addHandler([Object], assertUndefinedWithoutMessage);
		overload.addHandler([], assertUndefinedWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is undefined else it fails.
	 * Method to assert that a value is undefined.
	 * It adds a error to the result if the value is not undefined.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isUndefined
	 * @see #assertUndefined
	 * @see #assertUndefinedWithMessage
	 * @param val Object that should be undefined.
	 * @return true if no error occured else false
	 */
	private function assertUndefinedWithoutMessage(val):Boolean {
		return assertUndefinedWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is undefined else it fails.
	 * This method asserts the same like @see #assertUndefinedWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isUndefined
	 * @see #assertUndefined
	 * @see #assertUndefinedWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertUndefinedWithMessage(message:String, val):Boolean {
		try {
			Assert.isUndefined(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertUndefined", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNotUndefinedWithMessage
	 * @see #assertNotUndefinedWithoutMessage
	 */
	private function assertNotUndefined():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertNotUndefinedWithMessage);
		overload.addHandler([String, Object], assertNotUndefinedWithMessage);
		overload.addHandler([undefined], assertNotUndefinedWithoutMessage);
		overload.addHandler([Object], assertNotUndefinedWithoutMessage);
		overload.addHandler([], assertNotUndefinedWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is not undefined else it fails.
	 * Method to assert that a value is not undefined.
	 * It adds a error to the result if the value is undefined.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNotUndefined
	 * @see #assertNotUndefined
	 * @see #assertNotUndefinedWithMessage
	 * @param val Object that should not be undefined.
	 * @return true if no error occured else false
	 */
	private function assertNotUndefinedWithoutMessage(val):Boolean {
		return assertNotUndefined("", val);
	}
	
	/**
	 * Asserts if a value is not undefined else it fails.
	 * This method asserts the same like @see #assertNotUndefinedWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNotUndefined
	 * @see #assertNotUndefined
	 * @see #assertNotUndefinedWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertNotUndefinedWithMessage(message:String, val):Boolean {
		try {
			Assert.isNotUndefined(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotUndefined", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertInfinityWithMessage
	 * @see #assertInfinityWithoutMessage
	 */
	private function assertInfinity():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertInfinityWithMessage);
		overload.addHandler([String, Object], assertInfinityWithMessage);
		overload.addHandler([undefined], assertInfinityWithoutMessage);
		overload.addHandler([Object], assertInfinityWithoutMessage);
		overload.addHandler([], assertInfinityWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is infinity else it fails.
	 * Method to assert that a value is infinity.
	 * It adds a error to the result if the value is not infinity.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isInfinity
	 * @see #assertInfinity
	 * @see #assertInfinityWithMessage
	 * @param val Object that should be Infinity.
	 * @return true if no error occured else false
	 */
	private function assertInfinityWithoutMessage(val):Boolean {
		return assertInfinityWithMessage("", val);
	}
	
	/**
	 * Asserts that a value is infinity else it fails.
	 * This method asserts the same like @see #assertInfinityWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isInfinity
	 * @see #assertInfinity
	 * @see #assertInfinityWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be Infinity.
	 * @return true if no error occured else false
	 */
	private function assertInfinityWithMessage(message:String, val):Boolean {
		try {
			Assert.isInfinity(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertInfinity", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNotInfinityWithMessage
	 * @see #assertNotInfinityWithoutMessage
	 */
	private function assertNotInfinity():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertNotInfinityWithMessage);
		overload.addHandler([String, Object], assertNotInfinityWithMessage);
		overload.addHandler([undefined], assertNotInfinityWithoutMessage);
		overload.addHandler([Object], assertNotInfinityWithoutMessage);
		overload.addHandler([], assertNotInfinityWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is not Infinity else it fails.
	 * Method to assert that a value is not Infinity.
	 * It adds a error to the result if the value is not Infinity.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNotInfinity
	 * @see #assertNotInfinity
	 * @see #assertNotInfinityWithMessage
	 * @param val Object that should not be Infinity.
	 * @return true if no error occured else false
	 */
	private function assertNotInfinityWithoutMessage(val):Boolean {
		return assertNotInfinityWithMessage("", val);
	}
	
	/**
	 * Asserts that a value is not infinity else it fails.
	 * This method asserts the same like @see #assertInfinityWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNotInfinity
	 * @see #assertNotInfinity
	 * @see #assertNotInfinityWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be Infinity.
	 * @return true if no error occured else false
	 */
	private function assertNotInfinityWithMessage(message:String, val):Boolean {
		try {
			Assert.isNotInfinity(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotInfinity", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertEmptyWithMessage
	 * @see #assertEmptyWithoutMessage
	 */
	private function assertEmpty():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertEmptyWithMessage);
		overload.addHandler([String, Object], assertEmptyWithMessage);
		overload.addHandler([undefined], assertEmptyWithoutMessage);
		overload.addHandler([Object], assertEmptyWithoutMessage);
		overload.addHandler([], assertEmptyWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is empty else it fails.
	 * Method to assert that a value is empty, in sense of
	 * is null or undefined.
	 * It adds a error to the result if the value is not empty.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isEmpty
	 * @see #assertEmpty
	 * @see #assertEmptyWithMessage
	 * @param val Object that should be empty.
	 * @return true if no error occured else false
	 */
	private function assertEmptyWithoutMessage(val):Boolean {
		return assertEmptyWithMessage("", val);
	}
	
	/**
	 * Asserts that a value is empty else it fails.
	 * This method asserts the same like @see #assertEmptyWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isEmpty
	 * @see #assertEmpty
	 * @see #assertEmptyWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be empty.
	 * @return true if no error occured else false
	 */
	private function assertEmptyWithMessage(message:String, val):Boolean {
		try {
			Assert.isEmpty(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertEmpty", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * @see #assertNotEmptyWithMessage
	 * @see #assertNotEmptyWithoutMessage
	 */
	private function assertNotEmpty():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, undefined], assertNotEmptyWithMessage);
		overload.addHandler([String, Object], assertNotEmptyWithMessage);
		overload.addHandler([undefined], assertNotEmptyWithoutMessage);
		overload.addHandler([Object], assertNotEmptyWithoutMessage);
		overload.addHandler([], assertNotEmptyWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is not empty else it fails.
	 * Method to assert that a value is not empty, in sense of
	 * neither null or undefined.
	 * It adds a error to the result if the value is empty.
	 * 
	 * Note: This method refers to the Assert Util
	 * 
	 * @see Assert#isNotEmpty
	 * @see #assertNotEmpty
	 * @see #assertNotEmptyWithMessage
	 * @param val Object that should not be empty.
	 * @return true if no error occured else false
	 */
	private function assertNotEmptyWithoutMessage(val):Boolean {
		return assertNotEmptyWithMessage("", val);
	}
	
	/**
	 * Asserts that a value is not empty else it fails.
	 * This method asserts the same like @see #assertNotEmptyWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see Assert#isNotEmpty
	 * @see #assertNotEmpty
	 * @see #assertNotEmptyWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be empty.
	 * @return true if no error occured else false
	 */
	private function assertNotEmptyWithMessage(message:String, val):Boolean {
		try {
			Assert.isNotEmpty(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertEmpty", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * overload
	 * 
	 * @see #assertThrowsWithCall
	 * @see #assertThrowsWithCallAndType
	 * @see #assertThrowsWithCallAndMessage
	 * @see #assertThrowsWithCallAndMessageAndType
	 * @see #assertThrowsWithString
	 * @see #assertThrowsWithStringAndType
	 * @see #assertThrowsWithStringAndMessage
	 * @see #assertThrowsWithStringAndMessageAndType
	 * @see #assertThrowsWithFunction
	 * @see #assertThrowsWithFunctionAndType
	 * @see #assertThrowsWithFunctionAndMessage
	 * @see #assertThrowsWithFunctionAndMessageAndType
	 */
	private function assertThrows():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Call, Array], assertThrowsWithCall);
		overload.addHandler([Object, String, Array], assertThrowsWithString);
		overload.addHandler([Object, Function, Array], assertThrowsWithFunction);
		overload.addHandler([Object, Call, Array], assertThrowsWithCallAndType);
		overload.addHandler([Object, Object, String, Array], assertThrowsWithStringAndType);
		overload.addHandler([Object, Object, Function, Array], assertThrowsWithFunctionAndType);
		overload.addHandler([String, Call, Array], assertThrowsWithCallAndMessage);
		overload.addHandler([String, Object, String, Array], assertThrowsWithStringAndMessage);
		overload.addHandler([String, Object, Function, Array], assertThrowsWithFunctionAndMessage);
		overload.addHandler([String, Object, Call, Array], assertThrowsWithCallAndMessageAndType);
		overload.addHandler([String, Object, Object, String, Array], assertThrowsWithStringAndMessageAndType);
		overload.addHandler([String, Object, Object, Function, Array], assertThrowsWithFunctionAndMessageAndType);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that the execution of a call throws any exception.
	 * This method executes the given Call with arguments and checks if it throws any Exception.
	 * 
	 * The assertion adds a error to the result if the method didn't throw a exception.
	 * 
	 * @see #assertThrowsWithCallAndMessage
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertThrowsWithCall(call:Call, args:Array):Boolean {
		return assertThrowsWithCallAndMessage("", call, args);
	}
	
	/**
	 * Asserts that the execution of a call throws any exception.
	 * This method executes the given Call with arguments and checks if it throws any Exception.
	 * 
	 * The assertion adds a error to the result if the method didn't throw a exception or throw a 
	 * exception with the wrong type.
	 * 
	 * @see #assertThrowsWithCallAndMessageAndType
	 * @param type	Type of the Exception that should be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertThrowsWithCallAndType(type, call:Call, args:Array):Boolean {
		return assertThrowsWithCallAndMessageAndType("", type, call, args);
	}
	
	/**
	 * Asserts that the execution of a method throws any exception.
	 * This method takes a method of the given object(inObject) by a given name and checks if it throws any expected exception by execution.
	 * 
	 * The assertion adds a error to the result if the method didn't throw a exception or if the method was not available.
	 * 
	 * @see #assertThrowsWithStringAndMessage
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithString(inObject, name:String, args:Array):Boolean {
		return assertThrowsWithStringAndMessage("",  inObject, name, args);
	}
	
	/**
	 * Asserts that the execution of a method throws a exception.
	 * This method takes a method of the given object(inObject) by a given name and checks if it throws a expected exception by execution.
	 * 
	 * The assertion adds a error to the result if the method didn't throw a exception or throw a 
	 * exception with the wrong type or if the method was not available.
	 * 
	 * @see #assertThrowsWithStringAndMessageAndType
	 * @param type		Type of the Exception that should be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithStringAndType(type, inObject, name:String, args:Array):Boolean {
		return assertThrowsWithStringAndMessageAndType("", type, inObject, name, args);
	}
	
	/**
	 * Asserts that the execution of a method throws any exception.
	 * This method takes a given method and excutes it within a given object. It checks if it throws any exception by execution.
	 * 
	 * The assertion adds a error to the result if the method didn't throw any exception.
	 * 
	 * @see #assertThrowsWithFunctionAndMessage
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithFunction(inObject, func:Function, args:Array):Boolean {
		return assertThrowsWithFunctionAndMessage("", inObject, func, args);
	}
	
	/**
	 * Asserts that the execution of a method throws a exception.
	 * This method takes a given method and excutes it within a given object. It checks if it throws a expected exception by execution.
	 * 
	 * The assertion adds a error to the result if the method didn't throw a exception or throw a exception with the wrong type.
	 * 
	 * @see #assertThrowsWithFunctionAndMessageAndType
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithFunctionAndType(type, inObject, func:Function, args:Array):Boolean {
		return assertThrowsWithFunctionAndMessageAndType("", type, inObject, func, args);
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithCall but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithCall
	 * @param message	Message that should be used by fail.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertThrowsWithCallAndMessage(message:String, call:Call, args:Array):Boolean {
		try {
			Assert.isThrowingWithoutType(message, call, args);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrowsWithCalAndMessage", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithCallAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithCallAndType
	 * @param message	Message that should be used by fail.
	 * @param type	Type of the Exception that should be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertThrowsWithCallAndMessageAndType(message:String, type, call:Call, args:Array):Boolean {
		try {
			Assert.isThrowing(message, type, call, args);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrowsWithCallAndMessageAndType", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithString but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithString
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithStringAndMessage(message:String,  inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertThrowsWithCallAndMessage(message, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrowsWithStringAndMessage", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithStringAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithStringAndType
	 * @param message	Message that should be used by fail.
	 * @param type		Type of the Exception that should be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithStringAndMessageAndType(message:String, type, inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertThrowsWithCallAndMessageAndType(message, type, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrowsWithStringAndMessageAndType", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithFunction but adds a message to the failure (if necessary).
	 * 
	 * @see assertThrowsWithFunction
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithFunctionAndMessage(message:String, inObject, func:Function, args:Array):Boolean {
		return assertThrowsWithCallAndMessage(message, new Call(inObject, func), args);
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithFunctionAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithFunctionAndType
	 * @param message	Message that should be used by fail.
	 * @param type		Type of the Exception that should be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertThrowsWithFunctionAndMessageAndType(message:String, type, inObject, func:Function, args:Array):Boolean {
		return assertThrowsWithCallAndMessageAndType(message, type, new Call(inObject, func), args);
	}
	
	
	/**
	 * overload
	 * 
	 * @see #assertNotThrowsWithCall
	 * @see #assertNotThrowsWithCallAndType
	 * @see #assertNotThrowsWithCallAndMessage
	 * @see #assertNotThrowsWithCallAndMessageAndType
	 * @see #assertNotThrowsWithString
	 * @see #assertNotThrowsWithStringAndType
	 * @see #assertNotThrowsWithStringAndMessage
	 * @see #assertNotThrowsWithStringAndMessageAndType
	 * @see #assertNotThrowsWithFunction
	 * @see #assertNotThrowsWithFunctionAndType
	 * @see #assertNotThrowsWithFunctionAndMessage
	 * @see #assertNotThrowsWithFunctionAndMessageAndType
	 */
	private function assertNotThrows():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Call, Array], assertNotThrowsWithCall);
		overload.addHandler([Object, String, Array], assertNotThrowsWithString);
		overload.addHandler([Object, Function, Array], assertNotThrowsWithFunction);
		overload.addHandler([Object, Call, Array], assertNotThrowsWithCallAndType);
		overload.addHandler([Object, Object, String, Array], assertNotThrowsWithStringAndType);
		overload.addHandler([Object, Object, Function, Array], assertNotThrowsWithFunctionAndType);
		overload.addHandler([String, Call, Array], assertNotThrowsWithCallAndMessage);
		overload.addHandler([String, Object, String, Array], assertNotThrowsWithStringAndMessage);
		overload.addHandler([String, Object, Function, Array], assertNotThrowsWithFunctionAndMessage);
		overload.addHandler([String, Object, Call, Array], assertNotThrowsWithCallAndMessageAndType);
		overload.addHandler([String, Object, Object, String, Array], assertNotThrowsWithStringAndMessageAndType);
		overload.addHandler([String, Object, Object, Function, Array], assertNotThrowsWithFunctionAndMessageAndType);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that the execution of a call doesn't throw any exception.
	 * This method executes the given Call with arguments and checks if it doesn't throw any exception.
	 * 
	 * The assertion adds a error to the result if the method did throw any exception.
	 * 
	 * @see #assertNotThrowsWithCallAndMessage
	 * @see #assertNotThrowsWithCallAndTypeAndMessage
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithCall(call:Call, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessage("", call, args);
	}
	
	/**
	 * Asserts that the execution of a call doesn't throw a exception.
	 * This method executes the given Call with arguments and checks if it doesn't throw a expected exception.
	 * 
	 * The assertion adds a error to the result if the method did throw the expected exception.
	 * 
	 * @see #assertNotThrowsWithCallAndTypeAndMessage
	 * @param type	Type of the Exception that should not be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithCallAndType(type, call:Call, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessageAndType("", type, call, args);
	}
	
	/**
	 * Asserts that the execution of a method doesn't throw any exception.
	 * This method takes a method of the given object(inObject) by a given name and checks if it doesn't throw any exception by execution.
	 * 
	 * The assertion adds a error to the result if the method did throw any exception or if the method was not available.
	 * 
	 * @see #assertNotThrowsWithStringAndMessage
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithString(inObject, name:String, args:Array):Boolean {
		return assertNotThrowsWithStringAndMessage("", inObject, name, args);
	}
	
	/**
	 * Asserts that the execution of a method doesn't throw a exception.
	 * This method takes a method of the given object(inObject) by a given name and checks if it doesn't throw a expected exception by execution.
	 * 
	 * The assertion adds a error to the result if the method did throw the expected exception or if the method was not available.
	 * 
	 * @see #assertNotThrowsWithStringAndMessageAndType
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithStringAndType(type, inObject, name:String, args:Array):Boolean {
		return assertNotThrowsWithStringAndMessageAndType("", type, inObject, name, args);
	}
	
	/**
	 * Asserts that the execution of a method doesn't throw any exception.
	 * This method takes a given method and excutes it within a given object. It checks if it doesn't throw any exception by execution.
	 * 
	 * The assertion adds a error to the result if the method did throw any exception.
	 * 
	 * @see #assertNotThrowsWithFunctionAndMessage
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithFunction(inObject, func:Function, args:Array):Boolean {
		return assertNotThrowsWithFunctionAndMessage("", inObject, func, args);
	}
	
	/**
	 * Asserts that the execution of a method doesn't throw a exception.
	 * This method takes a given method and excutes it within a given object. It checks if it doesn't throw a expected exception by execution.
	 * 
	 * The assertion adds a error to the result if the method did throw the expected exception.
	 * 
	 * @see #assertNotThrowsWithFunctionAndMessage
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithFunctionAndType(type, inObject, func:Function, args:Array):Boolean {
		return assertNotThrowsWithFunctionAndMessageAndType("", type, inObject, func, args);
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithCall but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithCall
	 * @param message	Message that should be used by fail.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithCallAndMessage(message:String, call:Call, args:Array):Boolean {
		try {
			Assert.isNotThrowingWithoutType(message, call, args);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotThrows", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithCallAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithCallAndType
	 * @param message	Message that should be used by fail.
	 * @param type	Type of the Exception that should not be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithCallAndMessageAndType(message:String, type, call:Call, args:Array):Boolean {
		try {
			Assert.isNotThrowing(message, type, call, args);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotThrows", this, arguments).initCause(e));
		}
		return false;
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithString but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithString
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithStringAndMessage(message:String, inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertNotThrowsWithCallAndMessage(message, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotThrowsWithString", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithStringAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithString
	 * @param message	Message that should be used by fail.
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithStringAndMessageAndType(message:String, type, inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertNotThrowsWithCallAndMessageAndType(message, type, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotThrowsWithStringAndMessageAndType", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithFunction but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithFunction
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithFunctionAndMessage(message:String, inObject, func:Function, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessage(message, new Call(inObject, func), args);
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithFunctionAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithFunctionAndType
	 * @param message	Message that should be used by fail.
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 */
	private function assertNotThrowsWithFunctionAndMessageAndType(message:String, type, inObject, func:Function, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessageAndType(message, type, new Call(inObject, func), args);
	}
}