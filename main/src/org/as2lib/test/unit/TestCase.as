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
import org.as2lib.env.overload.Overload;
import org.as2lib.test.unit.info.*;
import org.as2lib.test.unit.ExecutionInfo;
import org.as2lib.test.unit.LoggerTestListener;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResultFactory;
import org.as2lib.test.unit.TestCaseResultFactory;
import org.as2lib.app.exec.Call;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.Process;
import org.as2lib.util.ObjectUtil;

/**
 * {@code Testcase} class to be extended.
 * <p>A Testcase defines the Access to all parts of the TestUnit System of as2lib.
 * 
 * It is handled as an abstract class this means you have to extend it if you 
 * want to work with the system (similar to the most other testunit systems).
 * <code>
 * import org.as2lib.test.unit.TestCase;
 * 
 * class MyTestCase extends TestCase {
 * }
 * </code>
 * 
 * A testcase usually gets processed by {@link #run}. 
 * The System will fetch all Methods starting with "test" and execute them in
 * a new, isolated instance. Before each method call the methods {@link #setUp} and
 * {@link #tearDown} will get called.
 *
 * Example:
 *   Testcase:
 *   <code>
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
 *   </code>
 *   Call:
 *   <code>
 * new MyTestCase().run();
 *   </code>
 *   Result:
 *   <code>
 * new instance
 * set up
 * myFirstTest
 * tear down
 * new instance
 * set up
 * mySecondTest
 * tear down
 *   </code>
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
 *       <th>assertAlmostEquals</th>
 *       <td>(<i>a</i> < <i>b</i> && <i>a</i>+x > <i>b</i>) || (<i>a</i> > <i>b</i> && <i>a</i>-x < <i>b</i>)</td>
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
 *     <tr>
 *       <th>assertTypeOf</th>
 *       <td><i>value</i> typeof <i>type</i></td>
 *     </tr>
 *     <tr>
 *       <th>assertInstanceOf</th>
 *       <td><i>value</i> instanceof <i>type</i></td>
 *     </tr>
 *   </tbody>
 * </table>
 * 
 * You have also got the possibility to simple fail the Testcase by {@link #fail}.
 *
 * @author Martin Heidegger
 * @version 1.2
 * @see org.as2lib.test.unit.TestSuite
 * @see org.as2lib.test.unit.Test
 * @see org.as2lib.test.unit.TestResult
 */

class org.as2lib.test.unit.TestCase extends BasicClass implements Test {
	
	// Holder for the resultFactory.
	private static var resultFactory:TestCaseResultFactory;
	
	// Defaut maximal difference used in assertAlmostEquals
	public static var DEFAULT_MAX_DIFF:Number = 0.0000001;
	
	// Internal Holder for the TestRunner context the method is running in.
	private var testRunner:TestRunner;
	
	/**
	 * Returns a factory to create a Result
	 * 
	 * @return Factory for a result for this test.
	 */
	public function getResultFactory(Void):TestResultFactory {
		if(!resultFactory) resultFactory = new TestCaseResultFactory();
		return resultFactory;
	}
	
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
	 * @see TestRunner#run
	 * @return Runner of the Testcases (containing all informations about the run)
	 */
	public function run():TestRunner {
		var testRunner:TestRunner = new TestRunner();
		testRunner.addProcessListener(new LoggerTestListener());
		return testRunner.run(this);
		// not mtasc compatible:
		// return new TestRunner().run(this);
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
	 * Method to start a subprocess for this process.
	 * 
	 * @param process Process to start.
	 * @param args Arguments to be used for the process
	 * @param callBack Call to be executed if the execution finishes.
	 */
	private function startProcess(process:Process, args:Array, callBack:Executable):Void {
		getTestRunner().startSubProcess(process, args, callBack);
	}
	
	/**
	 * Setter for the testrunner.
	 * The testrunner represents the context of the actual method.
	 * {@link #getMethodInformation} is a referred to the informations that represent this
	 * methods information. It will be automatically set by the testrunner, because
	 * only it know who runs this test)
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
	public function getTestRunner(Void):TestRunner {
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
	 * @return Methodinformation for the current testcase method.
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
		getMethodInformation().addInfo(new FailureInfo(message));
	}
	
	/**
	 * @overload #assertTrueWithMessage
	 * @overload #assertTrueWithoutMessage
	 */
	private function assertTrue():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertTrueWithMessage);
		overload.addHandler([Object], assertTrueWithoutMessage);
		overload.addHandler([], assertTrueWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is true.
	 * 
	 * @see #assertFalse
	 * @see #assertTrue
	 * @see #assertTrueWithMessage
	 * @param val Boolean that should be "true".
	 * @return true if no error occured else false.
	 */
	private function assertTrueWithoutMessage(val:Boolean):Boolean {
		return assertTrueWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is true or fails with a message.
	 * This methods asserts the same like @see #assertTrueWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see #assertFalse
	 * @see #assertTrue
	 * @see #assertTrueWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Boolean that should be "true".
	 * @return true if no error occured else false.
	 */
	private function assertTrueWithMessage(message:String, val:Boolean):Boolean {
		var info:ExecutionInfo = new AssertTrueInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * overload
	 * @overload #assertFalseWithMessage
	 * @overload #assertFalseWithoutMessage
	 */
	private function assertFalse():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertFalseWithMessage);
		overload.addHandler([Object], assertFalseWithoutMessage);
		overload.addHandler([], assertFalseWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is false else it fails.
	 * 
	 * @see #assertTrue
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
	 * @see #assertTrue
	 * @see #assertFalse
	 * @see #assertFalseWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Boolean that should be "false".
	 * @return true if no error occured else false.
	 */
	private function assertFalseWithMessage(message:String, val:Boolean):Boolean {
		var info:ExecutionInfo = new AssertFalseInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertEqualsWithMessage
	 * @overload #assertEqualsWithoutMessage
	 */
	private function assertEquals():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, Object], assertEqualsWithMessage);
		overload.addHandler([String, Object], assertEqualsWithMessage);
		overload.addHandler([Object, Object], assertEqualsWithoutMessage);
		overload.addHandler([String, String], assertEqualsWithoutMessage);
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
	 * @see #assertSame
	 * @see #assertNotEquals
	 * @see #assertEquals
	 * @see #assertEqualsWithMessage
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false.
	 */
	private function assertEqualsWithoutMessage(val, compareTo):Boolean {
		return assertEqualsWithMessage("", val, compareTo);
	}
	
	/**
	 * Asserts that two variables contain the same value else it fails.
	 * This method asserts the same like @see #assertEqualsWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see #assertSame
	 * @see #assertNotEquals
	 * @see #assertEquals
	 * @see #assertEqualsWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertEqualsWithMessage(message:String, val, compareTo):Boolean {
		var info:ExecutionInfo = new AssertEqualsInfo(message, val, compareTo);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertAlmostEqualsWithMessageWithMaxDiff
	 * @overload #assertAlmostEqualsWithoutMessageWithMaxDiff
	 * @overload #assertAlmostEqualsWithMessageWithoutMaxDiff
	 * @overload #assertAlmostEqualsWithoutMessageWithoutMaxDiff
	 */
	private function assertAlmostEquals():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Number, Number, Number], assertAlmostEqualsWithMessageWithMaxDiff);
		overload.addHandler([String, Number, Number], assertAlmostEqualsWithMessageWithoutMaxDiff);
		overload.addHandler([Number, Number, Number], assertAlmostEqualsWithoutMessageWithMaxDiff);
		overload.addHandler([Number, Number], assertAlmostEqualsWithoutMessageWithoutMaxDiff);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that two number are the same with some difference value.
	 * This method compares two number if they are almost the same.
	 * It compares the two numbers by including a unsharpning buffer {@link #DEFAULT_MAX_DIFF}.
	 * 
	 * @see #assertSame
	 * @see #assertEquals
	 * @see #assertAlmostEquals
	 * 
	 * @param val number1 to be compared.
	 * @param compareTo number2 to compare with val.
	 * @return true if no error occured else false.
	 */
	private function assertAlmostEqualsWithoutMessageWithoutMaxDiff(val:Number, compareTo:Number):Boolean {
		return assertAlmostEqualsWithMessageWithMaxDiff("", val, compareTo, DEFAULT_MAX_DIFF);
	}
	
	/**
	 * Asserts that two number are the same with some difference value.
	 * This method asserts the same like {@link #assertAlmostEqualsWithoutMessageWithoutMaxDiff}
	 * but it adds a message to the failure.
	 * 
	 * @see #assertSame
	 * @see #assertEquals
	 * @see #assertAlmostEquals
	 * 
	 * @param message message to be added to the failure.
	 * @param val number1 to be compared.
	 * @param compareTo number2 to compare with val.
	 * @return true if no error occured else false.
	 */
	private function assertAlmostEqualsWithMessageWithoutMaxDiff(message:String, val:Number, compareTo:Number):Boolean {
		return assertAlmostEqualsWithMessageWithMaxDiff(message, val, compareTo, DEFAULT_MAX_DIFF);
	}
	
	/**
	 * Asserts that two number are the same with some difference value.
	 * This method compares two number if they are almost the same.
	 * It compares the two numbers by including a unsharpning buffer (applied as argument).
	 * 
	 * @see #assertSame
	 * @see #assertEquals
	 * @see #assertAlmostEquals
	 * 
	 * @param val number1 to be compared.
	 * @param compareTo number2 to compare with val.
	 * @param maxDiff max. difference between those two numbers.
	 * @return true if no error occured else false.
	 */
	private function assertAlmostEqualsWithoutMessageWithMaxDiff(val:Number, compareTo:Number, maxDiff:Number):Boolean {
		return assertAlmostEqualsWithMessageWithMaxDiff("", val, compareTo, maxDiff);
	}
	
	/**
	 * Asserts that two number are the same with some difference value.
	 * This method asserts the same like {@link #assertAlmostEqualsWithoutMessageWithMaxDiff}
	 * but it adds a message to the failure.
	 * 
	 * @see #assertSame
	 * @see #assertEquals
	 * @see #assertAlmostEquals
	 * 
	 * @param message Message to be applied if a failure occurs
	 * @param val number1 to be compared.
	 * @param compareTo number2 to compare with val.
	 * @param maxDiff max. difference between those two numbers.
	 * @return true if no error occured else false.
	 */
	private function assertAlmostEqualsWithMessageWithMaxDiff(message:String, val:Number, compareTo:Number, maxDiff:Number):Boolean {
		var info:ExecutionInfo = new AssertAlmostEqualsInfo(message, val, compareTo, maxDiff);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNotEqualsWithMessage
	 * @overload #assertNotEqualsWithoutMessage
	 */
	private function assertNotEquals():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, Object], assertNotEqualsWithMessage);
		overload.addHandler([String, Object], assertNotEqualsWithMessage);
		overload.addHandler([Object, Object], assertNotEqualsWithoutMessage);
		overload.addHandler([String, String], assertNotEqualsWithoutMessage);
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
	 * @see #assertNotSame
	 * @see #assertEquals
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
	 * This method asserts the same like {@link #assertNotEqualsWithoutMessage}
	 * but it adds a message to the failure.
	 * 
	 * @see #assertNotSame
	 * @see #assertEquals
	 * @see #assertNotEquals
	 * @see #assertNotEqualsWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertNotEqualsWithMessage(message:String, val, compareTo):Boolean {
		var info:ExecutionInfo = new AssertNotEqualsInfo(message, val, compareTo);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertSameWithMessage
	 * @overload #assertSameWithoutMessage
	 */
	private function assertSame():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, Object], assertSameWithMessage);
		overload.addHandler([String, Object], assertSameWithMessage);
		overload.addHandler([Object, Object], assertSameWithoutMessage);
		overload.addHandler([String, String], assertSameWithoutMessage);
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
	 * @see #assertNotSame
	 * @see #assertEquals
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
	 * @see #assertNotSame
	 * @see #assertEquals
	 * @see #assertSame
	 * @see #assertSameWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertSameWithMessage(message:String, val, compareTo):Boolean {
		var info:ExecutionInfo = new AssertSameInfo(message, val, compareTo);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNotSameWithMessage
	 * @overload #assertNotSameWithoutMessage
	 */
	private function assertNotSame():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object, Object], assertNotSameWithMessage);
		overload.addHandler([String, Object], assertNotSameWithMessage);
		overload.addHandler([Object, Object], assertNotSameWithoutMessage);
		overload.addHandler([String, String], assertNotSameWithoutMessage);
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
	 * @see #assertSame
	 * @see #assertNotEquals
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
	 * @see #assertSame
	 * @see #assertNotEquals
	 * @see #assertNotSame
	 * @see #assertNotSameWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be compared.
	 * @param compareTo Object to compare with val.
	 * @return true if no error occured else false
	 */
	private function assertNotSameWithMessage(message:String, val, compareTo):Boolean {
		var info:ExecutionInfo = new AssertNotSameInfo(message, val, compareTo);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNullWithMessage
	 * @overload #assertNullWithoutMessage
	 */
	private function assertNull():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertNullWithMessage);
		overload.addHandler([Object], assertNullWithoutMessage);
		overload.addHandler([], assertNullWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is (===) null else it fails.
	 * 
	 * @see #assertNotNull
	 * @see #assertUndefined
	 * @see #assertEmpty
	 * @see #assertNull
	 * @see #assertNullWithMessage
	 * @param val Object that should be null.
	 * @return true if no error occured else false
	 */
	private function assertNullWithoutMessage(val):Boolean {
		return assertNullWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is (===) null else it fails.
	 * This method asserts the same like @see #assertNullWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see #assertNotNull
	 * @see #assertUndefined
	 * @see #assertEmpty
	 * @see #assertNull
	 * @see #assertNullWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be null.
	 * @return true if no error occured else false
	 */
	private function assertNullWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertNullInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNotNullWithMessage
	 * @overload #assertNotNullWithoutMessage
	 */
	private function assertNotNull():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertNotNullWithMessage);
		overload.addHandler([Object], assertNotNullWithoutMessage);
		overload.addHandler([], assertNotNullWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is not (!==) null else it fails.
	 * 
	 * @see #assertNull
	 * @see #assertNotUndefined
	 * @see #assertNotEmpty
	 * @see #assertNotNull
	 * @see #assertNotNullWithMessage
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertNotNullWithoutMessage(val):Boolean {
		return assertNotNullWithMessage("", val);
	}
	
	/**
	 * Asserts if a value is not (!==) null else it fails.
	 * This method asserts the same like @see #assertNotNullWithoutMessage
	 * but it adds a message to the failure.
	 * 
	 * @see #assertNull
	 * @see #assertNotUndefined
	 * @see #assertNotEmpty
	 * @see #assertNotNull
	 * @see #assertNotNullWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertNotNullWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertNotNullInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertUndefinedWithMessage
	 * @overload #assertUndefinedWithoutMessage
	 */
	private function assertUndefined():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertUndefinedWithMessage);
		overload.addHandler([Object], assertUndefinedWithoutMessage);
		overload.addHandler([], assertUndefinedWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is (===) undefined else it fails.
	 * 
	 * @see #assertNotUndefined
	 * @see #assertNull
	 * @see #assertEmpty
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
	 * @see #assertNotUndefined
	 * @see #assertNull
	 * @see #assertEmpty
	 * @see #assertUndefined
	 * @see #assertUndefinedWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertUndefinedWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertUndefinedInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNotUndefinedWithMessage
	 * @overload #assertNotUndefinedWithoutMessage
	 */
	private function assertNotUndefined():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertNotUndefinedWithMessage);
		overload.addHandler([Object], assertNotUndefinedWithoutMessage);
		overload.addHandler([], assertNotUndefinedWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts if a value is not undefined else it fails.
	 * 
	 * @see #assertUndefined
	 * @see #assertNotNull
	 * @see #assertNotEmpty
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
	 * @see #assertUndefined
	 * @see #assertNotNull
	 * @see #assertNotEmpty
	 * @see #assertNotUndefined
	 * @see #assertNotUndefinedWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be null.
	 * @return true if no error occured else false
	 */
	private function assertNotUndefinedWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertNotUndefinedInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertInfinityWithMessage
	 * @overload #assertInfinityWithoutMessage
	 */
	private function assertInfinity():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertInfinityWithMessage);
		overload.addHandler([Object], assertInfinityWithoutMessage);
		overload.addHandler([], assertInfinityWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is infinity else it fails.
	 * 
	 * @see #assertNotInfinity
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
	 * @see #assertNotInfinity
	 * @see #assertInfinity
	 * @see #assertInfinityWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be Infinity.
	 * @return true if no error occured else false
	 */
	private function assertInfinityWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertInfinityInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNotInfinityWithMessage
	 * @overload #assertNotInfinityWithoutMessage
	 */
	private function assertNotInfinity():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertNotInfinityWithMessage);
		overload.addHandler([Object], assertNotInfinityWithoutMessage);
		overload.addHandler([], assertNotInfinityWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is not Infinity else it fails.
	 * 
	 * @see #assertInfinity
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
	 * @see #assertInfinity
	 * @see #assertNotInfinity
	 * @see #assertNotInfinityWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be Infinity.
	 * @return true if no error occured else false
	 */
	private function assertNotInfinityWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertNotInfinityInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertEmptyWithMessage
	 * @overload #assertEmptyWithoutMessage
	 */
	private function assertEmpty():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertEmptyWithMessage);
		overload.addHandler([Object], assertEmptyWithoutMessage);
		overload.addHandler([], assertEmptyWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is empty else it fails.
	 * Method to assert that a value is empty, in sense of
	 * is null or undefined. (== null || == undefined)
	 * 
	 * @see #assertNull
	 * @see #assertUndefined
	 * @see #assertNotEmpty
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
	 * @see #assertNull
	 * @see #assertUndefined
	 * @see #assertNotEmpty
	 * @see #assertEmpty
	 * @see #assertEmptyWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should be empty.
	 * @return true if no error occured else false
	 */
	private function assertEmptyWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertEmptyInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertNotEmptyWithMessage
	 * @overload #assertNotEmptyWithoutMessage
	 */
	private function assertNotEmpty():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Object], assertNotEmptyWithMessage);
		overload.addHandler([Object], assertNotEmptyWithoutMessage);
		overload.addHandler([], assertNotEmptyWithoutMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is not empty else it fails.
	 * Method to assert that a value is not empty, in sense of
	 * neither null or undefined. (!= null || != undefined)
	 * 
	 * @see #assertNotNull
	 * @see #assertNotUndefined
	 * @see #assertEmpty
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
	 * @see #assertNotNull
	 * @see #assertNotUndefined
	 * @see #assertEmpty
	 * @see #assertNotEmpty
	 * @see #assertNotEmptyWithoutMessage
	 * @param message Message that should be provided if the assertion fails.
	 * @param val Object that should not be empty.
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertNotEmptyWithMessage(message:String, val):Boolean {
		var info:ExecutionInfo = new AssertNotEmptyInfo(message, val);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * @overload #assertThrowsWithCall
	 * @overload #assertThrowsWithCallAndType
	 * @overload #assertThrowsWithCallAndMessage
	 * @overload #assertThrowsWithCallAndMessageAndType
	 * @overload #assertThrowsWithString
	 * @overload #assertThrowsWithStringAndType
	 * @overload #assertThrowsWithStringAndMessage
	 * @overload #assertThrowsWithStringAndMessageAndType
	 * @overload #assertThrowsWithFunction
	 * @overload #assertThrowsWithFunctionAndType
	 * @overload #assertThrowsWithFunctionAndMessage
	 * @overload #assertThrowsWithFunctionAndMessageAndType
	 */
	private function assertThrows():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Executable, Array], assertThrowsWithCall);
		overload.addHandler([Object, String, Array], assertThrowsWithString);
		overload.addHandler([Object, Function, Array], assertThrowsWithFunction);
		overload.addHandler([Object, Executable, Array], assertThrowsWithCallAndType);
		overload.addHandler([Object, Object, String, Array], assertThrowsWithStringAndType);
		overload.addHandler([Object, Object, Function, Array], assertThrowsWithFunctionAndType);
		overload.addHandler([String, Executable, Array], assertThrowsWithCallAndMessage);
		overload.addHandler([String, Object, String, Array], assertThrowsWithStringAndMessage);
		overload.addHandler([String, Object, Function, Array], assertThrowsWithFunctionAndMessage);
		overload.addHandler([String, Object, Executable, Array], assertThrowsWithCallAndMessageAndType);
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
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithCall(call:Executable, args:Array):Boolean {
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
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithCallAndType(type, call:Executable, args:Array):Boolean {
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
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithCallAndMessage(message:String, call:Executable, args:Array):Boolean {
		return assertThrowsWithCallAndMessageAndType(message, null, call, args);
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithCallAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithCallAndType
	 * @param message	Message that should be used by fail.
	 * @param type	Type of the Exception that should be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithCallAndMessageAndType(message:String, type, call:Executable, args:Array):Boolean {
		var info:ExecutionInfo = new AssertThrowsInfo(message, type, call, args);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * Asserts the same like @see #assertThrowsWithString but adds a message to the failure (if necessary).
	 * 
	 * @see #assertThrowsWithString
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithStringAndMessage(message:String,  inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertThrowsWithCallAndMessage(message, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			//getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrowsWithStringAndMessage", this, arguments).initCause(e));	
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
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithStringAndMessageAndType(message:String, type, inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertThrowsWithFunctionAndMessageAndType(message, type, inObject, inObject[name], args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			//getMethodInformation().addError(new UnexpectedException("Unexpected Exeption during assertThrowsWithStringAndMessageAndType", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like {@link #assertThrowsWithFunction} but adds a message to the failure (if necessary).
	 * 
	 * @see assertThrowsWithFunction
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertThrowsWithFunctionAndMessageAndType(message:String, type, inObject, func:Function, args:Array):Boolean {
		return assertThrowsWithCallAndMessageAndType(message, type, new Call(inObject, func), args);
	}
	
	
	/**
	 * @overload #assertNotThrowsWithCall
	 * @overload #assertNotThrowsWithCallAndType
	 * @overload #assertNotThrowsWithCallAndMessage
	 * @overload #assertNotThrowsWithCallAndMessageAndType
	 * @overload #assertNotThrowsWithString
	 * @overload #assertNotThrowsWithStringAndType
	 * @overload #assertNotThrowsWithStringAndMessage
	 * @overload #assertNotThrowsWithStringAndMessageAndType
	 * @overload #assertNotThrowsWithFunction
	 * @overload #assertNotThrowsWithFunctionAndType
	 * @overload #assertNotThrowsWithFunctionAndMessage
	 * @overload #assertNotThrowsWithFunctionAndMessageAndType
	 */
	private function assertNotThrows():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Executable, Array], assertNotThrowsWithCall);
		overload.addHandler([Object, String, Array], assertNotThrowsWithString);
		overload.addHandler([Object, Function, Array], assertNotThrowsWithFunction);
		overload.addHandler([Object, Executable, Array], assertNotThrowsWithCallAndType);
		overload.addHandler([Object, Object, String, Array], assertNotThrowsWithStringAndType);
		overload.addHandler([Object, Object, Function, Array], assertNotThrowsWithFunctionAndType);
		overload.addHandler([String, Executable, Array], assertNotThrowsWithCallAndMessage);
		overload.addHandler([String, Object, String, Array], assertNotThrowsWithStringAndMessage);
		overload.addHandler([String, Object, Function, Array], assertNotThrowsWithFunctionAndMessage);
		overload.addHandler([String, Object, Executable, Array], assertNotThrowsWithCallAndMessageAndType);
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
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithCallAndMessage
	 * @see #assertNotThrowsWithCallAndMessageAndType
	 */
	private function assertNotThrowsWithCall(call:Executable, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessage("", call, args);
	}
	
	/**
	 * Asserts that the execution of a call doesn't throw a exception.
	 * This method executes the given Call with arguments and checks if it doesn't throw a expected exception.
	 * 
	 * The assertion adds a error to the result if the method did throw the expected exception.
	 * 
	 * @param type	Type of the Exception that should not be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithCallAndMessageAndType
	 */
	private function assertNotThrowsWithCallAndType(type, call:Executable, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessageAndType("", type, call, args);
	}
	
	/**
	 * Asserts that the execution of a method doesn't throw any exception.
	 * This method takes a method of the given object(inObject) by a given name and checks if it doesn't throw any exception by execution.
	 * 
	 * The assertion adds a error to the result if the method did throw any exception or if the method was not available.
	 * 
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithStringAndMessage
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
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithStringAndMessageAndType
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
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
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
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertNotThrowsWithCallAndMessage(message:String, call:Executable, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessageAndType(message, null, call, args);
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithCallAndType but adds a message to the failure (if necessary).
	 * 
	 * @see #assertNotThrowsWithCallAndType
	 * @param message	Message that should be used by fail.
	 * @param type	Type of the Exception that should not be thrown.
	 * @param call	Call that should be executed.
	 * @param args	Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertNotThrowsWithCallAndMessageAndType(message:String, type, call:Executable, args:Array):Boolean {
		var info:ExecutionInfo = new AssertNotThrowsInfo(message, type, call, args);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithString but adds a message to the failure (if necessary).
	 * 
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithString
	 */
	private function assertNotThrowsWithStringAndMessage(message:String, inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertNotThrowsWithCallAndMessage(message, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			//getMethodInformation().addInfo(new UnexpectedException("Unexpected Exeption during assertNotThrowsWithString", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithStringAndType but adds a message to the failure (if necessary).
	 * 
	 * @param message	Message that should be used by fail.
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param name		Name of the method that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithString
	 */
	private function assertNotThrowsWithStringAndMessageAndType(message:String, type, inObject, name:String, args:Array):Boolean {
		if(ObjectUtil.isTypeOf(inObject[name], "function")) {
			return assertNotThrowsWithCallAndMessageAndType(message, type, new Call(inObject, inObject[name]), args);
		} else {
			var e:IllegalArgumentException = new IllegalArgumentException("The method '"+name+"' is not available within "+inObject.toString(), this, arguments);
			//getMethodInformation().addInfo(new UnexpectedException("Unexpected Exeption during assertNotThrowsWithStringAndMessageAndType", this, arguments).initCause(e));	
			return false;
		}
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithFunction but adds a message to the failure (if necessary).
	 * 
	 * @param message	Message that should be used by fail.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithFunction
	 */
	private function assertNotThrowsWithFunctionAndMessage(message:String, inObject, func:Function, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessage(message, new Call(inObject, func), args);
	}
	
	/**
	 * Asserts the same like @see #assertNotThrowsWithFunctionAndType but adds a message to the failure (if necessary).
	 * 
	 * @param message	Message that should be used by fail.
	 * @param type		Type of the Exception that should not be thrown.
	 * @param inObject	Object that should be used as scope.
	 * @param func		Function that should be executed.
	 * @param args		Arguments that should be used by executing.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertNotThrowsWithFunctionAndType
	 */
	private function assertNotThrowsWithFunctionAndMessageAndType(message:String, type, inObject, func:Function, args:Array):Boolean {
		return assertNotThrowsWithCallAndMessageAndType(message, type, new Call(inObject, func), args);
	}
	
	/**
	 * @overload #assertTypeOfWithMessage
	 * @overload #assertTypeOfWithoutMessage
	 */
	private function assertTypeOf():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Object, String], assertTypeOfWithoutMessage);
		overload.addHandler([String, Object, String], assertTypeOfWithMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that the type of a value a special type.
	 * 
	 * @param val	Value to be validated.
	 * @param type	Expected type of the value.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertTypeOfWithMessage
	 * @see org.as2lib.util.ObjectUtil#isTypeOf
	 */
	private function assertTypeOfWithoutMessage(val, type:String):Boolean {
		return assertTypeOfWithMessage("", val, type);
	}
	
	/**
	 * Asserts that the type of a value a special type and adds a exception if the assertion fails.
	 * 
	 * @see #assertTypeOfWithoutMessage
	 * @param message	Message to be appended if the assertion fails.
	 * @param val		Value to be validated.
	 * @param type		Expected type of the value.
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertTypeOfWithMessage(message:String, val, type:String):Boolean {
		var info:ExecutionInfo = new AssertTypeOfInfo(message, val, type);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
	
	/** 
	 * @overload #assertInstanceOfWithMessage
	 * @overload #assertInstanceOfWithoutMessage
	 */
	private function assertInstanceOf():Boolean {
		var overload:Overload = new Overload(this);
		overload.addHandler([Object, Function], assertInstanceOfWithoutMessage);
		overload.addHandler([String, Object, Function], assertInstanceOfWithMessage);
		return overload.forward(arguments);
	}
	
	/**
	 * Asserts that a value is a instance of a special type.
	 * 
	 * @param val		Value to be validated.
	 * @param type		Expected type of the value.
	 * @return {@code true} if no error occured else {@code false}
	 * @see #assertInstanceOfWithoutMessage
	 */
	private function assertInstanceOfWithoutMessage(val, type:Function):Boolean {
		return assertInstanceOfWithMessage("", val, type);
	}
	
	/**
	 * Asserts that a value is a instance of a special type and applies a
	 * message if the assertion fails.
	 * 
	 * @see #assertInstanceOfWithoutMessage
	 * @param message	Message to be appended if the assertion fails.
	 * @param val		Value to be validated.
	 * @param type		Expected type of the value.
	 * @return {@code true} if no error occured else {@code false}
	 */
	private function assertInstanceOfWithMessage(message:String, val, type:Function):Boolean {
		var info:ExecutionInfo = new AssertInstanceOfInfo(message, val, type);
		getMethodInformation().addInfo(info);
		return !info.isFailed();
	}
}