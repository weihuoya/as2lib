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
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.Assert;
import org.as2lib.test.unit.AssertException;
import org.as2lib.test.unit.error.*;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ClassUtil;

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
	 * Abstract constructor. You shoudl extend this class to use the API.
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
			Assert.isTrueWithMessage(message, val);
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
			Assert.isFalseWithMessage(message, val);
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
		overload.addHandler([Object, Object], assertEqualsWithoutMessage);
		overload.addHandler([undefined, Object], assertEqualsWithoutMessage);
		overload.addHandler([Object, undefined], assertEqualsWithoutMessage);
		overload.addHandler([undefined, undefined], assertEqualsWithoutMessage);
		overload.addHandler([undefined], assertEqualsWithoutMessage);
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
			Assert.isEqualWithMessage(message, val, compareTo);
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
		overload.addHandler([String, Object, Object], assertNotEqualsWithMessage);
		overload.addHandler([Object, Object], assertNotEqualsWithoutMessage);
		overload.addHandler([undefined, Object], assertNotEqualsWithoutMessage);
		overload.addHandler([Object, undefined], assertNotEqualsWithoutMessage);
		overload.addHandler([undefined, undefined], assertNotEqualsWithoutMessage);
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
			Assert.isNotEqualWithMessage(message, val, compareTo);
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
	 * @see #assertSameWithMessage
	 * @see #assertSameWithoutMessage
	 */
	private function assertSame():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, undefined], assertSameWithMessage);
		overload.addHandler([String, undefined, Object], assertSameWithMessage);
		overload.addHandler([String, Object, Object], assertSameWithMessage);
		overload.addHandler([Object, Object], assertSameWithoutMessage);
		overload.addHandler([undefined, Object], assertSameWithoutMessage);
		overload.addHandler([Object, undefined], assertSameWithoutMessage);
		overload.addHandler([undefined, undefined], assertSameWithoutMessage);
		overload.addHandler([undefined], assertSameWithoutMessage);
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
			Assert.isSameWithMessage(message, val, compareTo);
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
	 * @see #assertIsNotNullWithMessage
	 * @see #assertIsNotNullWithoutMessage
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
			Assert.isNotNullWithMessage(message, val);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertNotNull", this, arguments).initCause(e));
		}
		return false;
	}
}