﻿/**
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
			Assert.isNotEqualWithMessage(message, val, compareTo);
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
			Assert.isSameWithMessage(message, val, compareTo);
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
			Assert.isNotSameWithMessage(message, val, compareTo);
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
			Assert.isNullWithMessage(message, val);
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
			Assert.isNotNullWithMessage(message, val);
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
			Assert.isUndefinedWithMessage(message, val);
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
		return assertNotUndefinedWithMessage("", val);
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
			Assert.isNotUndefinedWithMessage(message, val);
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
			Assert.isInfinityWithMessage(message, val);
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
			Assert.isNotInfinityWithMessage(message, val);
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
			Assert.isEmptyWithMessage(message, val);
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
	
	private function assertThrows():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Object, Call, Array], assertThrowsWithCall);
		overload.addHandler([Object, String, Array], assertThrowsWithString);
		overload.addHandler([Object, Function, Array], assertThrowsWithFunction);
		overload.addHandler([String, Object, Call, Array], assertThrowsWithCallAndMessage);
		overload.addHandler([String, Object, String, Array], assertThrowsWithStringAndMessage);
		overload.addHandler([String, Object, Function, Array], assertThrowsWithFunctionAndMessage);
		return overload.forward(arguments);
	}
	
	private function assertThrowsWithCall(object, call:Call, args:Array):Boolean {
		return assertThrowsWithCallAndMessage("", object, call, args);
	}
	
	private function assertThrowsWithString(object, string:String, args:Array):Boolean {
		return assertThrowsWithStringAndMessage("", object, string, args);
	}
	
	private function assertThrowsWithFunction(object, func:Function, args:Array):Boolean {
		return assertThrowsWithFunctionAndMessage("", object, func, args);
	}
	
	private function assertThrowsWithCallAndMessage(message:String, object, call:Call, args:Array):Boolean {
		try {
			Assert.isThrowing(message, object, call, args);
			return true;
		} catch(e:org.as2lib.test.unit.AssertException) {
			getMethodInformation().addError(e);
		} catch(e) {
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertEmpty", this, arguments).initCause(e));
		}
		return false;
	}
	
	private function assertThrowsWithStringAndMessage(message:String, object, string:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(this[string], "function")) {
			return assertThrowsWithCallAndMessage(message, object, new Call(this, this[string]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+string+"' is not available within "+toString(), this, arguments);
			getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrows", this, arguments).initCause(e));	
			return false;
		}
	}
	
	private function assertThrowsWithFunctionAndMessage(message:String, object, func:Function, args:Array):Boolean {
		return assertThrowsWithCallAndMessage(message, object, new Call(this, func), args);
	}
	
}