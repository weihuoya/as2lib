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
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.app.exec.Process;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Default listener for TestRunner.
 * Listener as default logger for the Testrunner. To be used as standard outwriter for the TestRunner.
 *
 * @author Martin Heidegger
 * @see LogManager#getLoggerRepository
 * @see Logger
 */
class org.as2lib.test.unit.LoggerTestListener extends BasicClass implements ProcessListener {
	
	/** Stores the logger used to do the output. */
	private static var logger:Logger;
	
	/** Stores former displayed TestCase. */
	private var formerTest:TestCaseResult;
	
	/**
	 * @return the logger used to do the output
	 */
	private static function getLogger(Void):Logger {
		if (!logger) logger = LogManager.getLoggerRepository().getLogger("org.as2lib.test.util.LoggerTestListener");
		return logger;
	}
	
	/**
	 * Start event, fired by start of a TestRunner.
	 * 
	 * @param startInfo Informations about the TestRunner that started.
	 */
	public function onStartProcess(process:Process):Void {
		getLogger().info("TestRunner started execution.");
	}
	
	/**
	 * Progress event, fired after each executed method within a TestRunner.
	 * 
	 * @param progressInfo Extended informations the current progress.
	 */
	public function onUpdateProcess(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		var currentTest:TestCaseResult = testRunner.getCurrentTestCase();
		if(formerTest != currentTest) {
			getLogger().info(Math.round(testRunner.getPercentage())+"% ... executing "+currentTest.getName());
		}
		formerTest = currentTest;
	}
	
	/**
	 * Redirects the string representation of the testrunner to the logger
	 * 
	 * @param finishInfo Informations about the TestRunner that finished.
	 */
	public function onFinishProcess(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if(testRunner) {
			getLogger().info("TestRunner finished with the result: \n"+testRunner.getTestResult().toString());
		} else {
			throw new IllegalArgumentException("LoggerTestListener added to a different Process", this, arguments);
		}
	}
	
	/**
	 * Pause event, fired after by pausing the execution of a TestRunner.
	 * 
	 * @param pauseInfo Informations about the TestRunner that paused.
	 */
	public function onPauseProcess(process:Process):Void {
		var test:TestRunner = TestRunner(process);
		getLogger().info("<TestRunner paused execution at "+test.getCurrentTestCaseMethodInfo().getName()+">");
	}
	
	/**
	 * Pause event, fired after by resuming the execution of a TestRunner.
	 * 
	 * @param resumeInfo Informations about the TestRunner that resumed working.
	 */
	public function onResumeProcess(process:Process):Void {
		getLogger().info("<TestRunner resumed execution>");
	}
}