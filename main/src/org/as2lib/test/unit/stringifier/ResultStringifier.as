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
import org.as2lib.util.string.Stringifier;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestInformation;

/**
 * Stringifier for a normal Failure.
 * 
 * @see Failure
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.stringifier.ResultStringifier extends BasicClass implements Stringifier {
	
	/**
	 * Returns a Failure as string.
	 * 
	 * @return Failure as string.
	 */
	public function execute (object):String {
		var testResult:TestResult = TestResult(object);
		var result:String = "-- Testcase run in "+testResult.getTotalTime()+" ms --\n";
		
		result += "\n"+testCasesToString(testResult);
		result += "\n"+errorsToString(testResult);
		
		result += "--------------------------";
		
		return result;
	}
	
	private function testCasesToString(testResult:TestResult):String {
		var result:String = "[Testcases]\n";
		var tests:Array = testResult.getTests()
		for(var i:Number = 0; i<tests.length; i++) {
			result += TestInformation(tests[i]).toString()+"\n";
		}
		return result;
	}
	
	private function errorsToString(testResult:TestResult):String {
		var result:String = "[Errors]\n";
		var tests:Array = testResult.getTests();
		var hasErrors:Boolean = false;
		for(var j:Number = 0; j<tests.length; j++) {
			var test:TestInformation = TestInformation(tests[j]);
			if(test.hasErrors()) {
				hasErrors = true;
				result += test.errorsToString();
			}
		}
		if(!hasErrors) {
			result += "  no errors occured\n\n";
		}
		return result;
	}
}