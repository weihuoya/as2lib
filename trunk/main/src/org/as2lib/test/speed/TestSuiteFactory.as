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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.speed.TestSuite;

/**
 * {@code TestSuiteFactory} collects test suites.
 * 
 * @author Simon Wacker */
class org.as2lib.test.speed.TestSuiteFactory extends BasicClass {
	
	/**
	 * Constructs a new {@code TestSuiteFactory} instance.	 */
	public function TestSuiteFactory(Void) {
	}
	
	/**
	 * Collects all methods except the ones declared by {@code Object} as test cases.
	 * 
	 * @return a test suite that contains all tests	 */
	public function collectAllTestCases(Void):TestSuite {
		return collectTestCases(PackageInfo.getRootPackage());
	}
	
	/**
	 * Collects all methods except the ones declared by {@code Object} of the given
	 * {@code package} and all sub-packages as test cases.
	 * 
	 * @param package the package to begin the collection at
	 * @return a test suite that contains all collected tests	 */
	public function collectTestCases(package:PackageInfo):TestSuite {
		if (!package) throw new IllegalArgumentException("Argument 'package' [" + package + "] must not be 'null' nor 'undefined'.", this, arguments);
		var result:TestSuite = new TestSuite(package.getFullName());
		var ca:Array = package.getMemberClasses();
		for (var i:Number = 0; i < ca.length; i++) {
			var c:ClassInfo = ca[i];
			if (c.getType() === Object) continue;
			result.addTest(c.getConstructor());
			var ma:Array = c.getMethods(true);
			for (var k:Number = 0; k < ma.length; k++) {
				result.addTestByMethod(ma[k]);
			}
		}
		var pa:Array = package.getMemberPackages();
		for (var i:Number = 0; i < pa.length; i++) {
			result.addTest(collectTestCases(pa[i]));
		}
		return result;
	}
	
}