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
import org.as2lib.data.holder.Stack;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ArrayUtil;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResult;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Composite Implementation for Tests.
 * A TestSuite is a collection of Tests. While TestSuite implements Test
 * it is possible to even add TestSuite to the TestSuite.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.TestSuite extends BasicClass implements Test {

	/** Internal Holder for all test contained within the TestSuite. */
	private var tests:TypedArray;
	
	/** Name of the TestSuite. */
	private var name:String;

	/**
	 * Constructs a new TestSuite.
	 * 
	 * @param name Name of the TestSuite.
	 */
	public function TestSuite(name:String) {
		this.tests = new TypedArray(Test);
		this.name = name;
	}
	
	/**
	 * Adds a Test to the TestSuite.
	 * 
	 * @param test Test that should be added.
	 * @throws IllegalArgumentException If you add the TestSuite to itself.
	 */
	public function addTest(test:Test):Void {
		if(test === this) {
			throw new IllegalArgumentException("A testsuite may not include itself.", this, arguments);
		}
		tests.push(test);
	}
	
	/**
	 * Getter for the name of the TestSuite.
	 * 
	 * @return Name of the TestSuite.
	 */
	public function getName(Void):String {
		if(!name) {
			return "";	
		}
		return name;
	}
	
	/**
	 * Runs the TestSuite (implementation of Test.run)
	 * 
	 * @param doNotPrintResult [Optional Parameter, null interpreted as false] Boolean if the Result should be printed immediately or not.
	 * @return TestRunner that run this test (including all informations about the run).
	 */
	public function run(doNotPrintResult:Boolean):TestRunner {
		if(!doNotPrintResult) {
			 doNotPrintResult = false;
		}
		return new TestRunner().run(this, doNotPrintResult);
	}
	
	/**
	 * Blocks collecting of TestSuiteFactory
	 * 
	 * @return true to not get collected.
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Getter for all Tests contained within the TestSuite.
	 * 
	 * @return TypedArray that contains all Tests of the TestSuite.
	 */
	public function getTests(Void):TypedArray {
		return this.tests;
	}
}