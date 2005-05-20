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
import org.as2lib.env.overload.Overload;
import org.as2lib.test.speed.Test;
import org.as2lib.test.speed.TestResult;
import org.as2lib.test.speed.TestSuiteResult;
import org.as2lib.test.speed.TestCase;

/**
 * {@code TestSuite} is the core interface for standardized performance test
 * suites.
 * 
 * <p>Test suites hold multiple {@code Test} instances, including {@code TestCase},
 * instances, {@code TestSuite} instances and instances of your custom {@code Test}
 * implementations.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.test.speed.TestSuite extends BasicClass implements Test {
	
	/** This test suite's name. */
	private var name:String;
	
	/** All added tests. */
	private var tests:Array;
	
	/** This test suite's result. */
	private var result:TestSuiteResult;
	
	/**
	 * Constructs a new {@code TestSuite} instance.
	 * 
	 * <p>If the passed-in {@code tests} array contains elements that are not of type
	 * {@code Test}, they will be ignored.
	 * 
	 * @param name the name of this test suite
	 * @param tests (optional) {@code Test} instances to populate this test suite with	 */
	public function TestSuite(name:String, tests:Array) {
		this.name = name;
		this.tests = new Array();
		this.result = new TestSuiteResult(this);
		for (var i:Number = 0; i < tests.length; i++) {
			addTest(Test(tests[i]));
		}
	}
	
	/**
	 * Runs all added tests.	 */
	public function run(Void):Void {
		for (var i:Number = 0; i < this.tests.length; i++) {
			var test:Test = this.tests[i];
			test.run();
		}
	}
	
	/**
	 * Returns this test suite's name.
	 * 
	 * @return this test suite's name	 */
	public function getName(Void):String {
		return this.name;
	}
	
	/**
	 * @overload #addTestByTest
	 * @overload #addTestByScopeAndName	 */
	public function addTest() {
		var o:Overload = new Overload(this);
		o.addHandler([Test], addTestByTest);
		o.addHandler([Object, String], addTestByScopeAndName);
		return o.forward(arguments);
	}
	
	/**
	 * Adds the passed-in {@code test} to this test suite.
	 * 
	 * <p>If the argument {@code test} is {@code null} or {@code undefined} it will be
	 * ignored.
	 * 
	 * @param test the test to add	 */
	public function addTestByTest(test:Test):Void {
		if (test) {
			this.tests.push(test);
		}
	}
	
	/**
	 * Adds a new test case by {@code methodScope} and {@code methodName}.
	 * 
	 * @param methodScope the scope of the method to profile
	 * @param methodName the name of the method to profile
	 * @return the created and added test	 */
	public function addTestByScopeAndName(methodScope, methodName:String):Test {
		var test:TestCase = new TestCase(methodScope, methodName);
		addTestByTest(test);
		return test;
	}
	
	/**
	 * Returns all tests of this test suite.
	 * 
	 * @return all tests of this test suite	 */
	public function getAllTests(Void):Array {
		return this.tests.concat();
	}
	
	/**
	 * Return the result of this test suite.
	 * 
	 * @return this test suite's result	 */
	public function getResult(Void):TestResult {
		return this.result;
	}
	
}