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
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.ArgumentsMatcherMock extends BasicClass implements ArgumentsMatcher {
	
	private var testCase:TestCase;
	private var expectedExpectedArguments:Array;
	private var expectedActualArguments:Array;
	private var returnValue:Boolean;
	private var callExpected:Boolean;
	
	public function ArgumentsMatcherMock(testCase:TestCase) {
		this.testCase = testCase;
	}
	
	public function setExpectedExpectedArguments(expectedExpectedArguments:Array):Void {
		this.expectedExpectedArguments = expectedExpectedArguments;
	}
	
	public function setExpectedActualArguments(expectedActualArguments:Array):Void {
		this.expectedActualArguments = expectedActualArguments;
	}
	
	public function setReturnValueForMatchArguments(returnValue:Boolean):Void {
		this.returnValue = returnValue;
	}
	
	public function setExpectedCallToMatchArguments(Void):Void {
		callExpected = true;
	}
	
	public function matchArguments(expectedArguments:Array, actualArguments:Array):Boolean {
		testCase["assertTrue"]("Unexpected call to matchArguments(..)-method.", callExpected);
		testCase["assertSame"]("Expected arguments are not the same.", expectedExpectedArguments, expectedArguments);
		testCase["assertSame"]("Actual arguments are not the same.", expectedActualArguments, actualArguments);
		return returnValue;
	}
	
}