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
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.queue.TypedQueue;
import org.as2lib.data.holder.map.TypedMap;
import org.as2lib.data.holder.Iterator;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestSuiteResult;
import org.as2lib.test.unit.TestListener;
import org.as2lib.test.unit.StartInfo;
import org.as2lib.test.unit.ProgressInfo;
import org.as2lib.test.unit.FinishInfo;
import org.as2lib.test.unit.PauseInfo;
import org.as2lib.test.unit.ResumeInfo;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.test.unit.info.*;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventBroadcaster;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;
import org.as2lib.util.StringUtil;
import org.as2lib.util.StopWatch;

/**
 * Central TestSystem Class to run Testcases and TestSuites.
 * This is the heart of the TestSystem. All Tests get executed here.
 * It contains a execution service for TestSuites and TestCase.
 * 
 * To use the TestRunner you simple have to instanciate it and run some
 * @see TestCase to it.
 * 
 * Example:
 * <code>
 * import org.as2lib.test.unit.TestRunner;
 * 
 * var testRunner:TestRunner = new TestRunner();
 * testRunner.run(new MyTestCase()); // alternativly you have a faster .runTestCase
 * </code>
 * 
 * You can get the result of the running testcase(s) by @see #getTestResult.
 * It contains all Informations about the resulted testcases.
 * 
 * It is also possible to add Listener to the TestRunner by @see #addListener.
 * In this way it is possible to build a graphical view to the TestRunner
 * (TestRunner is the Controller and TestResult the Model -> MVC). The Listener
 * definition is made with @see org.as2lib.test.unit.TestListener.
 * 
 * The current State of the testrunner can be evaluated by:
 * @see #isRunning
 * @see #isPaused
 * @see #isStarted
 * @see #isFinished
 * 
 * Note: There is currently no better abstraction Level Possible so we have to differ
 *       between TestCase & TestSuite. The current implementation of .run allows only those
 *       two classes.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.TestRunner extends BasicClass {
	
	/** Internal EventBroadcaster holder. */
	private var eB:EventBroadcaster;
	
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
	
	/** Boolean flag if the Testrunner has already finished work. */
	private var finished:Boolean = false;
	
	/** Boolean flag if the instance is currently paused. */
	private var paused:Boolean = false;
	
	/** Boolean flag if the Testrunner started work. */
	private var started:Boolean = false;
	
	/** Flag if the Result should be printed by finish or not. */
	private var doNotPrintResult:Boolean;
	
	/** Holder for the methodscope of the current Method. */
	private var testCaseInstance:TestCase;
	
	/** Pause Flag (if pause is allowed or not. */
	private var pauseAllowed:Boolean;
	
	/**
	 * Constructs a new Testrunner
	 */
	public function TestRunner(Void) {
		eB = new SimpleEventBroadcaster();
	}
	
	/**
	 * Adds a listener to the TestRunner instance.
	 * 
	 * @param l Listener to be added.
	 */
	public function addListener(l:TestListener) {
		eB.addListener(l);
	}
	
	/**
	 * Removes a listener from the TestRunner instance.
	 * 
	 * @param l Listener to be removed.
	 */
	public function removeListener(l:TestListener) {
		eB.removeListener(l);
	}
	
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
	}
	
	/**
	 * overload
	 * @see #runTestCase
	 * @see #runTestSuite
	 */
	public function run():TestRunner {
		var o = new Overload(this);
		o.addHandler([TestCase], runTestCase);
		o.addHandler([TestCase, null], runTestCase);
		o.addHandler([TestCase, Boolean], runTestCase);
		o.addHandler([TestSuite], runTestSuite);
		o.addHandler([TestSuite, undefined], runTestCase);
		o.addHandler([TestSuite, Boolean], runTestSuite);
		return o.forward(arguments);
	}
	
	/**
	 * Prepares the Testcase to run the TestCase/TestSuite.
	 */
	private function prepareRun(Void):Void {
		testCases = new TypedArray(TestCaseResult);
		processedTestCaseMethods = new TypedArray(TestCaseMethodInfo);
		finished = false;
		started = false;
		paused = false;
	}
	
	/**
	 * Starts the Test.
	 */
	private function startRun(Void):Void {
		testCaseIterator = new ArrayIterator(this.testCases);
		started = true;
		
		// Dispatches the event for the view.
		eB.dispatch(new StartInfo(this));
		processQueue();
	}
	
	/**
	 * Runs a TestCase.
	 * 
	 * @param test Test that should get run.
	 * @param doNotPrintResult	true if the result should not be printed immediately.
	 * @return The current TestRunner (contains all informations about the process).
	 */
	public function runTestCase(test:TestCase, doNotPrintResult:Boolean):TestRunner {
		this.doNotPrintResult = doNotPrintResult;
		prepareRun();
		setTestResult(new TestCaseResult(test, this));
		
		testCases.push(getTestResult());
		
		startRun();
		return this;
	}
	
	/**
	 * Runs a TestSuite.
	 * 
	 * @param test TestSuite that should get run.
	 * @param doNotPrintResult	true if the result should not be printed immediately.
	 * @return The current TestRunner (contains all informations about the process).
	 */
	public function runTestSuite(test:TestSuite, doNotPrintResult:Boolean):TestRunner {
		this.doNotPrintResult = doNotPrintResult;
		prepareRun();
		setTestResult(new TestSuiteResult(test, this));
		
		var testCaseResultIterator:Iterator = new ArrayIterator(this.testResult.getTestCaseResults());
		while(testCaseResultIterator.hasNext()){
			testCases.push(testCaseResultIterator.next());
		}
		
		startRun();
		return this;
	}
	
	/**
	 * @return true if the process has finished. (false if the process hasn't started yet)
	 */
	public function isFinished(Void):Boolean {
		return finished;
	}
	
	/**
	 * @return true if the process is paused.
	 */
	public function isPaused(Void):Boolean {
		return paused;
	}
	
	/**
	 * @return true if the process has started.
	 */
	public function isStarted(Void):Boolean {
		return started;
	}
	
	/**
	 * @return true if the process is running.
	 */
	public function isRunning(Void):Boolean {
		return(!isPaused() && isStarted());
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
			eB.dispatch(new PauseInfo(this));
		}
	}
	
	/**
	 * Resumes the process.
	 * 
	 * @see #pause
	 */
	public function resume(Void):Void {
		paused = false;
		eB.dispatch(new ResumeInfo(this));
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
				testCaseInstance = TestCase(currentTestCase.getTestCase().getClass().newInstance());
				testCaseInstance.setTestRunner(this);
			} catch(e) {
				methodInfo.addInfo(new InstanciationError("IMPORTANT: Testcase threw an error by instanciation.\n"+StringUtil.addSpaceIndent(e.toString(), 2), this, arguments));
			}
			
			// Prepare the execution of the method by setUp
			if(!methodInfo.hasErrors()) {
				try {
					testCaseInstance.setUp();
				} catch (e) {
					methodInfo.addInfo(new SetUpError("IMPORTANT: Error occured during set up. (Testcase won't get executed!)\n"+StringUtil.addSpaceIndent(e.toString(), 2), testCaseInstance, arguments));
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
					methodInfo.addInfo(new ExecutionError(methodInfo.getMethodInfo().toString()+" threw a unexpected exception.\n"+StringUtil.addSpaceIndent(e.toString(), 2), testCaseInstance, arguments));
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
				methodInfo.addInfo(new TearDownError("IMPORTANT: Error occured during tear down.\n"+StringUtil.addSpaceIndent(e.toString(), 2), testCaseInstance, arguments));
			}
		}
		
		processedTestCaseMethods.push(methodInfo);
		
		// Dispatch the actual progress information
		eB.dispatch(new ProgressInfo(this, currentTestCase, methodInfo));
		
		delete methodInfo;
	}
	
	/**
	 * Internal Method to finish the Test.
	 */
	private function finish(Void):Void {
		if(!doNotPrintResult) {
			testResult.print();
		}
		finished = true;
		started = false;
		paused = false;
		eB.dispatch(new FinishInfo(this));
	}		
}