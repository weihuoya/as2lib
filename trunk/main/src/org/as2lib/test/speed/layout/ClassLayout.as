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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.speed.TestResultLayout;
import org.as2lib.test.speed.TestSuiteResult;
import org.as2lib.test.speed.MethodInvocation;
import org.as2lib.test.speed.ConfigurableTestSuiteResult;
import org.as2lib.test.speed.SimpleTestSuiteResult;
import org.as2lib.test.speed.layout.MethodLayout;

/**
 * @author Simon Wacker */
class org.as2lib.test.speed.layout.ClassLayout extends BasicClass implements TestResultLayout {
	
	private var result:ConfigurableTestSuiteResult;
	
	/** */
	private var methodInvocations:Array;
	
	/**
	 * Constructs a new {@code ClassLayout} instance.	 */
	public function ClassLayout(Void) {
	}
	
	/**
	 * Lays the passed-in {@code testResult} out and returns a new lay-outed test
	 * result.
	 * 
	 * @param testResult the test result to lay-out
	 * @return the lay-outed test result
	 */
	public function layOut(testSuiteResult:TestSuiteResult):TestSuiteResult {
		this.result = new SimpleTestSuiteResult(testSuiteResult.getName());
		this.methodInvocations = testSuiteResult.getAllMethodInvocations();
		for (var i:Number = 0; i < this.methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = this.methodInvocations[i];
			i -= addMethodInvocations(ClassInfo(methodInvocation.getMethod().getDeclaringType()));
		}
		this.result.sort(SimpleTestSuiteResult.TIME, true);
		return this.result;
	}
	
	private function addMethodInvocations(clazz:ClassInfo):Number {
		var count:Number = 0;
		var classResult:ConfigurableTestSuiteResult = new SimpleTestSuiteResult(clazz.getFullName());
		for (var i:Number = 0; i < this.methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = this.methodInvocations[i];
			if (methodInvocation.getMethod().getDeclaringType() == clazz) {
				classResult.addTestResult(methodInvocation);
				this.methodInvocations.splice(i, 1);
				i--;
				count++;
			}
		}
		this.result.addTestResult((new MethodLayout()).layOut(classResult));
		return count;
	}
	
}