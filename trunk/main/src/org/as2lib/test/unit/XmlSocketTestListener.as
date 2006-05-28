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

import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.core.BasicClass;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.util.StringUtil;

/**
 * @author Christophe Herreman
 * @author Simon Wacker
 */
class org.as2lib.test.unit.XmlSocketTestListener extends BasicClass implements
		ProcessStartListener, ProcessPauseListener, ProcessResumeListener,
		ProcessUpdateListener, ProcessErrorListener, ProcessFinishListener {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.test.unit.XmlSocketTestListener");
	
	private var socket:XMLSocket;
	
	public function XmlSocketTestListener(host:String, port:Number) {
		if (host == null) {
			host = "localhost";
		}
		if (port == null) {
			port = 3212;
		}
		socket = new XMLSocket();
		socket.connect(host, port);
	}
	
	public function onProcessStart(process:Process):Void {
		socket.send(new XML("<start>Started execution of tests.</start>"));
	}
	
	public function onProcessUpdate(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			var methodInfo:TestCaseMethodInfo = testRunner.getCurrentTestCaseMethodInfo();
			if (methodInfo != null) {
				socket.send(new XML("<update>Executing " + testRunner.getCurrentTestCase().getName() +
						"." + methodInfo.getMethodInfo().getName() + ".</update>"));
			}
		}
	}
	
	public function onProcessPause(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			socket.send(new XML("<pause>Paused execution at " +
					testRunner.getCurrentTestCaseMethodInfo().getName() + ".</pause>"));
		}
	}
	
	public function onProcessResume(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			socket.send(new XML("<resume>Resumed execution at " + 
					testRunner.getCurrentTestCaseMethodInfo().getName() + ".</resume>"));
		}
	}
	
	public function onProcessFinish(process:Process):Void {
		if (!(process instanceof TestRunner)) {
			if (logger.isErrorEnabled()) {
				logger.error("The process [" + process + "] this listener was added to " +
						"is not of the expected type 'org.as2lib.test.unit.TestRunner'.");
			}
		}
		var testResult:TestResult = TestRunner(process).getTestResult();
		socket.send(new XML("<finish hasErrors='" + testResult.hasErrors() + "'><![CDATA[" +
				"Finished execution with result:\n" + testResult + "]]></finish>"));
	}
	
	public function onProcessError(process:Process, error):Boolean {
		socket.send(new XML("<error><![CDATA[Error was raised during execution:\n" + error + "]]></error>"));
		return false;
	}
	
}