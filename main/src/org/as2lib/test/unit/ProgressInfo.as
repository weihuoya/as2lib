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
import org.as2lib.test.unit.TestRunnerInfo;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestCaseMethodInfo;

/**
 * Information published if the TestRunner processed a method.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.ProgressInfo extends BasicClass implements TestRunnerInfo {

	/** Internal Testrunner holder. */	
	private var testRunner:TestRunner;

	/** Internal Holder for the TestCaseResult. */
	private var testCaseResult:TestCaseResult;

	/** Internal Holder for the TestCaseMethodInformation. */
	private var testCaseMethod:TestCaseMethodInfo;
	
	/**
	 * Constructs a event information for a process.
	 * 
	 * @param testRunner TestRunner that published this event.
	 * @param testCaseResult Result for the current TestCase.
	 * @param testCaseMethod Method that just finished.
	 */
	public function ProgressInfo(testRunner:TestRunner, testCaseResult:TestCaseResult, testCaseMethod:TestCaseMethodInfo) {
		this.testRunner = testRunner;
		this.testCaseResult = testCaseResult;
		this.testCaseMethod = testCaseMethod;
	}
	
	/**
	 * Implementation of TestRunnerInfo#getTestRunner.
	 * 
	 * @return TestRunner that published this event.
	 */
	public function getTestRunner(Void):TestRunner {
		return testRunner;
	}
	
	/**
	 * Getter for the current running TestCase.
	 * 
	 * @return ResultInformations for the current running TestCase.
	 */
	public function getRunningTestCase(Void):TestCaseResult {
		return testCaseResult;
	}
	
	/**
	 * Getter for the just finished Mmethod.
	 *
	 * @return MethodInfo for the just finished method.
	 */
	public function getFinishedMethodInfo(Void):TestCaseMethodInfo {
		return testCaseMethod;
	}
	
	/**
	 * Implementation of TestRunnerInfo#getName.
	 * 
	 * @return Name of the event.
	 */
	public function getName(Void):String {
		return "onProgress";
	}
}