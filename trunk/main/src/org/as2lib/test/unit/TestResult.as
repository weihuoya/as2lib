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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.util.Stringifier;

/**
 * Basic Interface for all Results produced by the run a Test.
 * The seperation between Test and this Interface is to control
 * Tests. Its a contains a extended API that a Test should not
 * include. (For useability reasons)
 * 
 * @see org.as2lib.test.unit.TestRunner
 * @see org.as2lib.test.unit.Test
 * @author Martin Heidegger
 */
interface org.as2lib.test.unit.TestResult extends BasicInterface {
	
	/**
	 * Getter for the percentage of the current running Test
	 * 
	 * @return Percent of the executed Test.
	 */
	public function getPercentage(Void):Number;
	
	/**
	 * @return True if the Test has finished.
	 */
	public function isFinished(Void):Boolean;
	
	/**
	 * @return True if the Test has started.
	 */
	public function isStarted(Void):Boolean;
	
	/**
	 * Getter for the name of the test.
	 * 
	 * @return Name of the Test.
	 */
	public function getName(Void):String;
	
	/**
	 * Getter for the opertation time of the test.
	 * 
	 * @return Operationtime of the Test.
	 */
	public function getOperationTime(Void):Number;
	
	/**
	 * @return true if the Test containes errors.
	 */
	public function hasErrors(Void):Boolean;
	
	/**
	 * Getter for all testresults.
	 * @return All testresults.
	 */
	public function getTestResults(Void):TypedArray;
	
	/**
	 * Getter for all TestCaseResults.
	 * 
	 * Testcases get handled different (because they are a Leaf).
	 */
	public function getTestCaseResults(Void):TypedArray;
	
	/**
	 * Method to print the TestResult.
	 */
	public function print(Void):Void;
}