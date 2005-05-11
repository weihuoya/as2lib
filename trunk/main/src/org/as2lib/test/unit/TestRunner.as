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
 
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.Iterator;
import org.as2lib.test.unit.info.InstantiationError;
import org.as2lib.test.unit.info.SetUpError;
import org.as2lib.test.unit.info.ExecutionError;
import org.as2lib.test.unit.info.TearDownError;
import org.as2lib.test.unit.info.PauseError;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.util.ArrayUtil;
import org.as2lib.util.StringUtil;
import org.as2lib.util.StopWatch;
import org.as2lib.env.reflect.ClassInfo;

/**
 * Central TestSystem Class to run Testcases and TestSuites.
 * This is the heart of the TestSystem. All Tests get executed here.
 * It contains a execution service for TestSuites and TestCase.
 * 
 * <p>To use the TestRunner you simple have to instanciate it and run some
 * {@link TestCase} to it.
 * 
 * Example:
 * <code>
 * import org.as2lib.test.unit.TestRunner;
 * import org.as2lib.test.unit.LoggerTestListener;
 * 
 * var testRunner:TestRunner = new TestRunner();
 * testRunner.addProcessListener(new LoggerTestListener());
 * testRunner.run(new MyTestCase()); // alternativly you have a faster .runTestCase
 * </code>
 * 
 * <p>You can get the result of the running testcase(s) by @see #getTestResult.
 * It contains all Informations about the resulted testcases.
 * 
 * <p>The Testrunner is designed as process so its possible to add Listener to the
 * TestRunner by {@link #addProcessListener}. In this way it is possible to build a
 * graphical view to the TestRunner (TestRunner is the Controller and TestResult the
 * Model -> MVC).
 *
 * <p>Note: There is currently no better abstraction Level Possible so we have to differ
 *       between TestCase & TestSuite. The current implementation of .run allows only those
 *       two classes.
 * 
 * The current State of the testrunner can be evaluated by:
 * @see #isRunning
 * @see #isPaused
 * @see #hasStarted
 * @see #hasFinished
 * 
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.TestRunner extends AbstractProcess implements Process {
	
	/** Result Holder for a TestResult. */
	private var testResult:TestResult;
	
	/** Internal List of Testcases to process. */
	private var testCases:TypedArray;
	
	/** Iterator over all Testcases. Holds the current position. */
	private var testCaseIterator:Iterator;
	
	/** Information for the current processing method. */
	private var methodInfo:TestCaseMethodInfo;
	
	/** Internal holder of the processed Testcasesmethods. */
	private var processedTestCaseMethods:TypedArray;
	
	/** Holder of the currently running Testcase. */
	private var currentTestCase:TestCaseResult;
	
	/** Interator for the methods of the current Testcase. */
	private var currentTestCaseMethodIterator:Iterator;
		
	/** Holder for the methodscope of the current Method. */
	private var testCaseInstance:TestCase;
	
	/** Pause Flag (if pause is allowed or not. */
	private var pauseAllowed:Boolean;
	
	/**
	 * Getter for the Testresult.
	 * The Testresult contains all informations about the process.
	 * 
	 * @return Result of the TestRunner.
	 */
	public function getTestResult(Void):TestResult {
		return testResult;
	}
	
	/**
	 * Setter for the Testresult.
	 * Only private used for a possible instanciation of the TestCase.
	 * 
	 * @param result TestResult for the runner.
	 */
	private function setTestResult(result:TestResult):Void {
		testResult = result;
		// TODO: Check consistance.
		testCases = result.getTestCaseResults();
		testCaseIterator = new ArrayIterator(testCases);
	}
	
	public function start() {
		return run.apply(this, arguments);
	}
	
	/**
	 * Runs a test.
	 * 
	 * @param test Test to run.
	 */
	public function run(test:Test):TestRunner {
		prepare();
		setTestResult(test.getResultFactory().createResult(test, this));
		
		started = true;
		// Dispatches the event for the view.
		event.onStartProcess(this);
		
		processQueue();
		return this;
	}
	
	/**
	 * Prepares the Testcase to run the TestCase/TestSuite.
	 */
	private function prepare(Void):Void {
		testCases = new TypedArray(TestCaseResult);
		processedTestCaseMethods = new TypedArray(TestCaseMethodInfo);
		super.prepare();
	}
	
	/**
	 * Pauses the process.
	 * This is only possible during the execution of a testmethod (not before, not after).
	 * Else it will add a error to the methodInfo.
	 * 
	 * @see #resume
	 */
	public function pause(Void):Void {
		if(!pauseAllowed) {
			methodInfo.addInfo(new PauseError("IMPORTANT: Pause is not available before the execution of a testcase method. Action failed."))
		} else {
			paused = true;
			event.onPauseProcess(this);
		}
	}
	
	/**
	 * Resumes the process.
	 * 
	 * @see #pause
	 */
	public function resume(Void):Void {
		paused = false;
		event.onResumeProcess(this);
		processQueue();
	}
	
	/**
	 * Starts or resumes the TestCase Queue.
	 */
	private function processQueue(Void):Void {
		// Resuming former startet TestCase (if available);
		if(currentTestCase && isRunning()) {
			processMethodQueue();
		}
		
		while(testCaseIterator.hasNext() && isRunning()) {
			startTestCase(this.testCaseIterator.next());
		}
		
		// Finish if the current run isn't finished
		if(isRunning()) {
			finish();
		}
	}
	
	/**
	 * @param testCaseMethodInfo Information about a TestCaseMethod that should be checked if it was run already or not.
	 * @return true if a testcasemethod has already been processed.
	 */
	public function isTestCaseMethodFinished(testCaseMethodInfo:TestCaseMethodInfo):Boolean {
		return ArrayUtil.contains(processedTestCaseMethods, testCaseMethodInfo);
	}
	
	/**
	 * Starts the execution of a TestCase.
	 * 
	 * @param testCase TestCase that should be executed.
	 */
	private function startTestCase(testCase:TestCaseResult):Void {
		currentTestCase = testCase;
		currentTestCaseMethodIterator = new ArrayIterator(testCase.getMethodInfos());
		processMethodQueue();
	}
	
	/**
	 * Getter for the current executing TestCase.
	 * 
	 * @return TestCaseResult Result to the current executing TestCase.
	 */
	public function getCurrentTestCase(Void):TestCaseResult {
		return currentTestCase;
	}
	
	/**
	 * Getter for the current executing TestCaseMethod.
	 * 
	 * @return TestCaseMethodInfo Information about the current executing TestCaseMethod
	 */
	public function getCurrentTestCaseMethodInfo(Void):TestCaseMethodInfo {
		return methodInfo;
	}
	
	/**
	 * Processes all methods of the current Testcase.
	 */
	private function processMethodQueue(Void):Void {
		if(methodInfo) {
			methodInfo.getStopWatch().stop();
			finishMethod();
		}
		while(currentTestCaseMethodIterator.hasNext() && isRunning()) {
			methodInfo = TestCaseMethodInfo(currentTestCaseMethodIterator.next());
			
			try {
				testCaseInstance = TestCase(ClassInfo.forInstance(currentTestCase.getTestCase()).newInstance());
				testCaseInstance.setTestRunner(this);
			} catch(e) {
				methodInfo.addInfo(new InstantiationError("IMPORTANT: Testcase threw an error by instanciation.\n"+StringUtil.addSpaceIndent(e.toString(), 2), this, arguments));
			}
			
			// Prepare the execution of the method by setUp
			if(!methodInfo.hasErrors()) {
				try {
					testCaseInstance.setUp();
				} catch (e) {
					methodInfo.addInfo(new SetUpError("IMPORTANT: Error occured during set up(Testcase wasn't executed):\n"+StringUtil.addSpaceIndent(e.toString(), 2), testCaseInstance, arguments));
				}
			}
			
			if(!methodInfo.hasErrors()) {
				
				// Execute the method
				var sW:StopWatch = methodInfo.getStopWatch();
				try {
					sW.start();
					pauseAllowed = true;
					methodInfo.executeTo(testCaseInstance);
				} catch (e) {
					methodInfo.addInfo(new ExecutionError("Unexpected exception thrown during execution:\n"+StringUtil.addSpaceIndent(e.toString(), 2), testCaseInstance, arguments));
				}
				pauseAllowed = false;
				
				if(isRunning()) {
					sW.stop();
				}
			}

			if(isRunning()) {
				finishMethod();
			}
		}
	}

	/**
	 * Finishes the last MethodInfo.
	 * 
	 * Note: It is necessary for pause() to finish it later.
	 */
	private function finishMethod():Void {
		if(methodInfo.isExecuted()){
			// Tear down the changed of setUp.
			try {
				testCaseInstance.tearDown();
			} catch(e) {
				methodInfo.addInfo(new TearDownError("IMPORTANT: Error occured during tear down:\n"+StringUtil.addSpaceIndent(e.toString(), 2), testCaseInstance, arguments));
			}
		}
		
		processedTestCaseMethods.push(methodInfo);
		
		// Dispatch the actual progress information
		event.onUpdateProcess(this);
		
		delete methodInfo;
	}		
	
	public function getPercentage(Void):Number {
		return testResult.getPercentage();
	}
}