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
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __matchArguments:Object;
	
	public function ArgumentsMatcherMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__matchArguments = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function doVerify(Void):Void {
		if (__matchArguments.callExpected != __matchArguments.called) testCase["fail"]("matchArguments(..): Expected call.");
	}
	
	public function setMatchArgumentsReturnValue(returnValue:Boolean):Void {
		__matchArguments.returnValue = returnValue;
	}
	
	public function matchArguments(expectedArguments:Array, actualArguments:Array):Boolean {
		if (state == RECORD) {
			__matchArguments.callExpected = true;
			__matchArguments.expectedArguments = expectedArguments;
			__matchArguments.actualArguments = actualArguments;
		} else {
			if (__matchArguments.callExpected) {
				__matchArguments.called = true;
				testCase["assertSame"]("Wrong expected arguments.", __matchArguments.expectedArguments, expectedArguments);
				testCase["assertSame"]("Wrong actual arguments.", __matchArguments.actualArguments, actualArguments);
				return __matchArguments.returnValue;
			} else {
				testCase["fail"]("matchArguments(..): Unexpected call.");
			}
		}
	}
	
}