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
 
import org.as2lib.test.unit.*
import org.as2lib.core.BasicClass;

/**
 * Example View for the TestSystem.
 * Displays all Event of the System.
 * 
 * @author Martin Heidegger.
 */
class TestView extends BasicClass implements TestListener {
	
	public function onProgress(info:ProgressInfo):Void {
		trace('onProgress event fired. '+ Math.round(info.getTestRunner().getTestResult().getPercentage()*10)/10+"%");
		trace('  Finished Method: '+info.getFinishedMethodInfo().getMethodInfo().getName());
		trace('  Running TestCase: '+info.getRunningTestCase().getName());
	}
	
	public function onStart(info:StartInfo):Void {
		trace('onStart event fired.');
	}
	
	public function onFinish(info:FinishInfo):Void {
		trace('onFinish event fired.');
		  
		var result:String = info.getTestRunner().getTestResult().toString();
		
		info.getTestRunner().getTestResult().print();
		
		if(result.toLowerCase().indexOf("not fail") >= 0) {
			trace( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
				  +"!!! RESULT !!! "+(result.toLowerCase().split('not fail').length-1)+" critical error occured. !!!\n"
				  +"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		} else {
			trace( "************************************************\n"
				  +"*** RESULT *** Finished without any mistake. ***\n"
				  +"************************************************");
		}
	}
	
	public function onPause(info:PauseInfo):Void {
		trace('onPause event fired.');
	}

	public function onResume(info:ResumeInfo):Void {
		trace('onResume event fired.');
	}
}