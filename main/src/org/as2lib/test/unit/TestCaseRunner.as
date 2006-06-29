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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Processor;
import org.as2lib.app.exec.StepByStepProcess;
import org.as2lib.data.holder.Queue;
import org.as2lib.data.holder.queue.LinearQueue;
import org.as2lib.test.unit.ExecutionInfo;
import org.as2lib.test.unit.info.ExecutionError;
import org.as2lib.test.unit.info.InstantiationError;
import org.as2lib.test.unit.info.SetUpError;
import org.as2lib.test.unit.info.TearDownError;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.StopWatch;
import org.as2lib.util.StringUtil;

/**
 * {@code TestCaseRunner} runs a test case. It invokes all {@code test*} methods
 * of the test case and handles exceptions and pauses and resumes.
 *
 * <p>You usually do not have to work with this class directly because every test
 * case handles its runner automatically.
 *
 * <p>Take a look at the {@link TestRunner} documentation for details on how to
 * use test runners and code samples.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.test.unit.TestCaseRunner extends AbstractProcess implements
		TestRunner, StepByStepProcess {

	/** State that indicates that the next method must be started. */
	private static var STATE_NOT_STARTED:Number = 1;

	/** State that indicates that the test case instance was created. */
	private static var STATE_TEST_CREATED:Number = 2;

	/** State that indicates that the {@code setUp} method was invoked. */
	private static var STATE_SET_UP_FINISHED:Number = 3;

	/** State that indicates that the {@code test*} method was invoked. */
	private static var STATE_EXECUTION_FINISHED:Number = 4;

	/** State that indicates that the {@code tearDown} method was invoked. */
	private static var STATE_TEAR_DOWN_FINISHED:Number = 5;

	/** The result to the test execution. */
	private var testResult:TestCaseResult;

	/** The {@code test*} methods to execute. */
	private var openTestCaseMethods:Queue;

	/**
	 * The currently executing test method. Since it is possible to pause/resume the
	 * test execution it is necessary to store it as instance variable.
	 */
	private var methodInfo:TestMethod;

	/**
	 * The current state of the execution of the current test method. Since it is
	 * possible to pause/resume the test execution it is necessary to safe at what
	 * point in the execution it was paused.
	 */
	private var methodState:Number;

	/** The test case to execute the current test method on. */
	private var testCaseInstance:TestCase;

	/** The stop watch for this test (saved in instance scope for better performance). */
	private var stopWatch:StopWatch;

	/**
	 * Constructs a new {@code TestCaseRunner} instance.
	 *
	 * @param testCase the test case to run
	 */
	function TestCaseRunner(testCase:TestCase) {
		testResult = new TestCaseResult(testCase);
		methodState = STATE_NOT_STARTED;
		openTestCaseMethods = new LinearQueue(testResult.getMethodInfos());
	}

	public function getTestResult(Void):TestResult {
		return testResult;
	}

	public function getCurrentTestCase(Void):TestCaseResult {
		return testResult;
	}

	public function getCurrentTestMethod(Void):TestMethod {
		return methodInfo;
	}

	/**
	 * Adds test execution information for the currently executing method.
	 *
	 * @param info the execution information to add
	 */
	public function addInfo(info:ExecutionInfo):Void {
		methodInfo.addInfo(info);
	}

	/**
	 * Adds this step-by-step process to the processor which executes one step after
	 * each other on every new frame. This makes it possible to pause and resume this
	 * test runner and prevents flash player crashes.
	 *
	 * @see Processor
	 */
	private function run() {
		working = true;
		// Processor to manage the concrete processing of the TestCase
		Processor.getInstance().addStepByStepProcess(this);
	}

	/**
	 * Executes the next step of this test run.
	 */
	public function nextStep(Void):Void {
		if (openTestCaseMethods.isEmpty()) {
			finish();
		}
		else {
			if (methodState == STATE_NOT_STARTED) {
				methodInfo = openTestCaseMethods.dequeue();
				stopWatch = methodInfo.getStopWatch();
				distributeUpdateEvent();
			}
			while (processMethod());
		}
	}

	/**
	 * Returns the progress in percent of this test run.
	 */
	public function getPercentage(Void):Number {
		return (100 - (100 / testResult.getMethodInfos().length * openTestCaseMethods.size()));
	}

	/**
	 * Executes the next state of the current test method.
	 *
	 * @return {@code true} if the execution of the test method is finished and
	 * {@code false} if not
	 */
	private function processMethod(Void):Boolean {
		// Execution depending to the current state.
		switch (methodState) {
			case STATE_NOT_STARTED:
			    // create instance and set state for next loop.
				methodState = STATE_TEST_CREATED;
			    try {
				    testCaseInstance = ClassUtil.createInstance(
							testResult.getTestCase()["__constructor__"]);
			    }
			    catch (exception) {
					fatal(new InstantiationError("IMPORTANT: Test case threw an " +
							"exception on instantiation:\n" +
							StringUtil.addSpaceIndent(exception.toString(), 2),
							this, arguments));
				}
				break;

			case STATE_TEST_CREATED:
				// set up the instance and set state for next loop.
				methodState = STATE_SET_UP_FINISHED;
				testCaseInstance.getTestRunner();
				// Prepare the execution of the method by setUp
				if (!methodInfo.hasErrors()) {
					try {
						testCaseInstance.setUp();
					}
					catch (exception) {
						fatal(new SetUpError("IMPORTANT: Error occurred during " +
								"set up:\n" + StringUtil.addSpaceIndent(
								exception.toString(), 2), this, arguments));
					}
				}
				break;

			case STATE_SET_UP_FINISHED:
				// execute the method and set the state for the next loop
				methodState = STATE_EXECUTION_FINISHED;
				if (!methodInfo.hasErrors()) {
					// Execute the method
					stopWatch.start();
					try {
						methodInfo.getMethodInfo().invoke(testCaseInstance, null);
					}
					catch (exception) {
						fatal(new ExecutionError("Test method threw an unexpected " +
								"exception:\n" + StringUtil.addSpaceIndent(
								exception.toString(), 2), this, arguments));
					}
				}
				break;

			case STATE_EXECUTION_FINISHED:
				// tear down the instance and set the state for the next loop
				methodState = STATE_TEAR_DOWN_FINISHED;
				if (stopWatch.hasStarted()) {
					stopWatch.stop();
				}
				if (!methodInfo.hasErrors()) {
					try {
						testCaseInstance.tearDown();
					}
					catch (exception) {
						fatal(new TearDownError("IMPORTANT: Error occurred during " +
								"tear down:\n" + StringUtil.addSpaceIndent(
								exception.toString(), 2), this, arguments));
					}
				}
				break;

			case STATE_TEAR_DOWN_FINISHED:
				methodState = STATE_NOT_STARTED;
				methodInfo.setExecuted(true);
				return false; // next method

		}
		// next state execution
		return true;
	}

	/**
	 * Adds the given fatal execution info to the currently executing method and stops
	 * its execution.
	 *
	 * @param error the fatal error that occurred
	 * @see #addInfo
	 * @see #STATE_TEAR_DOWN_FINISHED
	 */
	private function fatal(error:ExecutionInfo):Void {
		addInfo(error);
		methodState = STATE_TEAR_DOWN_FINISHED;
	}

}