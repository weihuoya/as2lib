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
import org.as2lib.env.event.EventListener;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestListener;
import org.as2lib.test.unit.StartInfo;
import org.as2lib.test.unit.ProgressInfo;
import org.as2lib.test.unit.FinishInfo;
import org.as2lib.test.unit.PauseInfo;
import org.as2lib.test.unit.ResumeInfo;

/**
 * Default listener for TestRunner.
 * Listener as default logger for the Testrunner. To be used as standard outwriter for the TestRunner.
 *
 * @see LogManager#getLoggerRepository
 * @see Logger
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.LoggerTestListener extends BasicClass implements TestListener {
	
	/** Stores the logger used to do the output. */
	private static var logger:Logger;
	
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
	public function onStart(startInfo:StartInfo):Void {
	}
	
	/**
	 * Progress event, fired after each executed method within a TestRunner.
	 * 
	 * @param progressInfo Extended informations the current progress.
	 */
	public function onProgress(progressInfo:ProgressInfo):Void {
	}
	
	/**
	 * Redirects the string representation of the testrunner to the logger
	 * 
	 * @param finishInfo Informations about the TestRunner that finished.
	 */
	public function onFinish(finishInfo:FinishInfo):Void {
		var testRunner:TestRunner = finishInfo.getTestRunner();
	    getLogger().info(testRunner.getTestResult().toString());
	}
	
	/**
	 * Pause event, fired after by pausing the execution of a TestRunner.
	 * 
	 * @param pauseInfo Informations about the TestRunner that paused.
	 */
	public function onPause(pauseInfo:PauseInfo):Void {
	}
	
	/**
	 * Pause event, fired after by resuming the execution of a TestRunner.
	 * 
	 * @param resumeInfo Informations about the TestRunner that resumed working.
	 */
	public function onResume(resumeInfo:ResumeInfo):Void {
	}
}