import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.holder.TypedQueue;
import org.as2lib.data.holder.TypedMap;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
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
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventBroadcaster;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;
import org.as2lib.util.StopWatch;

class org.as2lib.test.unit.TestRunner extends BasicClass {
	
	private var eB:EventBroadcaster;
	private var testResult:TestResult;
	private var testCases:TypedArray;
	private var testCaseIterator:Iterator;
	private var methodInfo:TestCaseMethodInfo;
	private var processedTestCaseMethods:TypedArray;
	private var currentTestCase:TestCaseResult;
	private var currentTestCaseMethodIterator:Iterator;
	private var testCaseMethodQueue:TypedQueue;
	private var finished:Boolean = false;
	private var paused:Boolean = false;
	private var started:Boolean = false;
	private var doNotPrintResult:Boolean;
	
	public function TestRunner(Void) {
		this.eB = new SimpleEventBroadcaster();
	}
	
	public function addListener(l:TestListener) {
		this.eB.addListener(l);
	}
	
	public function removeListener(l:TestListener) {
		this.eB.removeListener(l);
	}
	
	public function getTestResult(Void):TestResult {
		return this.testResult;
	}
	
	public function run():TestResult {
		var o = new Overload(this);
		o.addHandler([TestCase], this.runTestCase);
		o.addHandler([TestCase, null], this.runTestCase);
		o.addHandler([TestCase, Boolean], this.runTestCase);
		o.addHandler([TestSuite], this.runTestSuite);
		o.addHandler([TestSuite, undefined], this.runTestCase);
		o.addHandler([TestSuite, Boolean], this.runTestSuite);
		return o.forward(arguments);
	}
	
	private function prepareRun(Void):Void {
		this.testCases = new TypedArray(TestCaseResult);
		this.processedTestCaseMethods = new TypedArray(TestCaseMethodInfo);
		this.finished = false;
		this.started = false;
		this.paused = false;
	}
	
	private function startRun(Void):Void {
		this.testCaseIterator = new ArrayIterator(this.testCases);
		this.started = true;
		this.eB.dispatch(new StartInfo(this));
		this.processQueue();
	}
	
	public function runTestCase(test:TestCase, doNotPrintResult:Boolean):TestCaseResult {
		this.doNotPrintResult = doNotPrintResult;
		this.prepareRun();
		this.testResult = new TestCaseResult(test, this);
		this.testCases.push(this.testResult);
		this.startRun();
		return TestCaseResult(this.testResult);
	}
	
	public function runTestSuite(test:TestSuite, doNotPrintResult:Boolean):TestResult {
		this.doNotPrintResult = doNotPrintResult;
		this.prepareRun();
		this.testResult = new TestSuiteResult(test, this);
		var testCaseResultIterator:Iterator = new ArrayIterator(this.testResult.getTestCaseResults());
		while(testCaseResultIterator.hasNext()){
			this.testCases.push(testCaseResultIterator.next());
		}
		this.startRun();
		return null;
	}
	
	public function isFinished(Void):Boolean {
		return this.finished;
	}
	
	public function isPaused(Void):Boolean {
		return this.paused;
	}
	
	public function isRunning(Void):Boolean {
		return(!this.paused);
	}
	
	public function pause(Void):Void {
		this.paused = true;
		this.eB.dispatch(new ResumeInfo(this));
	}
	
	public function resume(Void):Void {
		this.paused = false;
		this.eB.dispatch(new PauseInfo(this));
		this.processQueue();
	}
	
	private function processQueue(Void):Void {
		// Resuming former startet TestCase (if available);
		if(this.currentTestCase) {
			this.processMethodQueue();
		}
		
		while(this.testCaseIterator.hasNext() && this.isRunning()) {
			this.startTestCase(this.testCaseIterator.next());
		}
		
		// Finish if the current run isn't finished
		if(this.isRunning()) {
			this.finish();
		}
	}
	
	public function isTestCaseMethodFinished(testCaseMethodInfo:TestCaseMethodInfo):Boolean {
		return ArrayUtil.contains(processedTestCaseMethods, testCaseMethodInfo);
	}
	
	private function startTestCase(testCase:TestCaseResult):Void {
		this.currentTestCase = testCase;
		this.currentTestCaseMethodIterator = new ArrayIterator(testCase.getMethodInfos());
		this.processMethodQueue();
	}
	
	public function getCurrentTestCase(Void):TestCaseResult {
		return currentTestCase;
	}
	
	public function getCurrentTestCaseMethodInfo(Void):TestCaseMethodInfo {
		return methodInfo;
	}
	
	private function processMethodQueue(Void):Void {
		while(this.currentTestCaseMethodIterator.hasNext() && this.isRunning()) {
			methodInfo = TestCaseMethodInfo(this.currentTestCaseMethodIterator.next());
			
			try {
				var freshScope:TestCase = TestCase(currentTestCase.getTestCase().getClass().newInstance());
			     	freshScope.setTestRunner(this);
			} catch(e) {
				//methodInfo.addError(new UnexpectedException("IMPORTANT: Testcase threw an error by instanciation.", this, arguments).initCause(e));
			}
			
			// Prepare the execution of the method by setUp
			if(!methodInfo.hasErrors()) {
				try {
					freshScope.setUp();
				} catch (e) {
					//methodInfo.addError(new UnexpectedException("IMPORTANT: Error occured during set up. (Testcase won't get executed!)", freshScope, arguments).initCause(e));
				}
			}
			
			if(!methodInfo.hasErrors()) {
				
				// Execute the method
				var sW:StopWatch = methodInfo.getStopWatch();
				try {
					sW.start();
					methodInfo.getMethodInfo().applyTo(freshScope, null);
				} catch (e) {
					//methodInfo.addError(new UnexpectedException(methodInfo.getMethodInfo().toString()+" threw a unexpected exception", freshScope, arguments).initCause(e));
				}
				sW.stop();
				
				// Tear down the changed of setUp.
				try {
					freshScope.tearDown();
				} catch(e) {
					//methodInfo.addError(new UnexpectedException("IMPORTANT: Error occured during tear down.", freshScope, arguments).initCause(e));
				}
				
			}

			processedTestCaseMethods.push(methodInfo);
			
			// Dispatch the actual progress information
			this.eB.dispatch(new ProgressInfo(this, currentTestCase, methodInfo));
			
			delete freshScope;
			delete methodInfo;
		}
	}
	
	private function finish(Void):Void {
		if(!this.doNotPrintResult) {
			this.testResult.print();
		}
		this.finished = true;
		this.started = false;
		this.paused = false;
		this.eB.dispatch(new FinishInfo(this));
	}		
}