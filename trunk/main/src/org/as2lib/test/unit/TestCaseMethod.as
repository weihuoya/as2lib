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
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.UnsupportedOperationException;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.unit.TestCase;
import org.as2lib.util.ObjectUtil;

/**
 * MethodInfo Wrapper used during TestCaseInformation generation.
 * Wrapps a MethoInfo to get tested.
 * Saves the executiontime of the Testcasemethod.
 *
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.TestCaseMethod extends BasicClass {
	/** Internal Method holder */
	private var method:MethodInfo;
	/** Execution time of the */
	private var executionTime:Number;
	
	/**
	 * Constructs a TestCaseMethod.
	 *
	 * @param method 	MethodInfo that should get wrapped.
	 */
	public function TestCaseMethod (method:MethodInfo) {
		this.method = method;
	}
	
	/**
	 * Executes the Method to a TestCase.
	 * 
	 * @param forInstance TestCaseinstance to execute the Method.
	 */
	public function execute(forInstance:TestCase):Void {
		checkExistance(forInstance);
		var beforeExecution:Number = _global.getTimer();
		this.method.getMethod().apply(forInstance);
		var afterExecution:Number = _global.getTimer();
		this.executionTime = afterExecution-beforeExecution;
	}
	
	/**
	 * Getter for the Execution Time of the TestCase.
	 *
	 * @return the execution time of the testcase.
	 */
	public function getExecutionTime(Void):Number {
		if(ObjectUtil.isEmpty(this.executionTime)) {
			throw new IllegalStateException("The Testcase was not called, so the executiontime is not available.", this, arguments);
		}
		return this.executionTime;
	}
	
	/**
	 * Proofes if this Method is available within the Instance 
	 *
	 * @param forInstance Instance where it should check if the method exists.
	 */
	private function checkExistance(forInstance:TestCase):Void {
		if(!ObjectUtil.isTypeOf(forInstance[this.method.getName()], "function")) {
			throw new UnsupportedOperationException("The method does not exist it the used TestCase.", this, arguments);
		}
	}
}