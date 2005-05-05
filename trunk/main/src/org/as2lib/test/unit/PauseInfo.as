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
import org.as2lib.test.unit.TestRunner;

/**
 * Information published if the TestRunner paused working.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.PauseInfo extends BasicClass implements TestRunnerInfo {
	
	/** Internal Testrunner holder. */
	private var testRunner:TestRunner;
	
	/**
	 * Constructs a new PauseInfo.
	 * 
	 * @param testRunner TestRunner that published the event.
	 */
	public function PauseInfo(testRunner:TestRunner) {
		this.testRunner = testRunner;
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
	 * Implementation of TestRunnerInfo#getName.
	 * 
	 * @return Name of the event.
	 */
	public function getName(Void):String {
		return "onPause";
	}
}