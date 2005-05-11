﻿/**
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

import org.as2lib.core.BasicInterface;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResultFactory;

/**
 * Basic Class to be Extended by all Testcases.
 * This class provides all Function to be used by traditional Testcases.
 * It should used by all Testcases. It uses the Class "test.Failure" for Errors.
 * This is a Subproject from www.as2lib.org.
 *
 * @author Martin Heidegger
 * @see TestResult
 */
interface org.as2lib.test.unit.Test extends BasicInterface {
		
	/**
	 * Runs the Test.
	 * 
	 * @return TestRunner that run this test (including all informations about the run).
	 */
	public function run():TestRunner;
	
	/**
	 * Returns the Information information sheet for the Result.
	 * <p>Warning: The Result might be not complete! The Result will get filled
	 * during the execution of the Testcase.
	 * 
	 * @return Informations about the test.
	 */
	public function getResultFactory(Void):TestResultFactory;
}