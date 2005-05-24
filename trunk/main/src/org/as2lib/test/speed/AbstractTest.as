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
import org.as2lib.test.speed.TestResult;
import org.as2lib.test.speed.ConfigurableTestSuiteResult;
import org.as2lib.test.speed.layout.MethodInvocationLayout;
import org.as2lib.test.speed.layout.MethodLayout;
import org.as2lib.test.speed.layout.ClassLayout;
import org.as2lib.test.speed.layout.PackageLayout;
import org.as2lib.test.speed.layout.MethodInvocationTreeLayout;

/**
 * @author Simon Wacker */
class org.as2lib.test.speed.AbstractTest extends BasicClass {
	
	/** */
	public static var NONE:Number = -1;
	
	/** */
	public static var METHOD_INVOCATION:Number = 0;
	
	/** */
	public static var METHOD:Number = 1;
	
	/** */
	public static var CLASS:Number = 2;
	
	/** */
	public static var PACKAGE:Number = 3;
	
	/** */
	public static var METHOD_INVOCATION_TREE:Number = 4;
	
	/** */
	private var result:ConfigurableTestSuiteResult;
	
	/**
	 * Constructs a new {@code AbstractTest} instance.	 */
	private function AbstractTest(Void) {
	}
	
	/**
	 * Return the result of this test suite.
	 * 
	 * @param layout (optional) the layout of the returned test result
	 * @return this test suite's result
	 */
	public function getResult(layout:Number):TestResult {
		switch (layout) {
			case NONE:
				return this.result;
				break;
			case METHOD_INVOCATION:
				return (new MethodInvocationLayout()).layOut(this.result);
				break;
			case METHOD:
				return (new MethodLayout()).layOut(this.result);
				break;
			case CLASS:
				return (new ClassLayout()).layOut(this.result);
				break;
			case PACKAGE:
				return (new PackageLayout()).layOut(this.result);
				break;
			default:
				return (new MethodInvocationTreeLayout()).layOut(this.result);
				break;
		}
	}
	
	/**
	 * 	 */
	private function setResult(result:ConfigurableTestSuiteResult):Void {
		this.result = result;
	}
	
}