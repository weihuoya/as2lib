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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.Iterator;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.ObjectUtil;

/**
 * Factory to create TestSuites.
 * This factory can be used to create TestSuites that contain all
 * TestCases that are available.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.test.unit.TestSuiteFactory extends BasicClass {
	
	/**
	 * Constructs a new Factory.
	 */
	public function TestSuiteFactory(Void) {}
	
	/**
	 * Collects all TestCases that are available.
	 * 
	 * @return TestSuite that contains all available TestCases.
	 */
	public function collectAllTestCases(Void):TestSuite {
		return collectTestCases(_global, true);
	}
	
	/**
	 * Collects all TestCases by a given package.
	 * 
	 * @param package Package to start with.
	 * @param recursive Recursive Flag.
	 * @return TestSuite that contains all available TestCases.
	 */
	public function collectTestCases(package, recursive:Boolean):TestSuite {
		var result:TestSuite = new TestSuite("<Generated TestSuite>");
		ObjectUtil.setAccessPermission(package, null, ObjectUtil.ACCESS_ALL_ALLOWED);
		collectAgent(package, result, recursive);
		return result;
	}

	/**
	 * Agent to collect TestCases within a package.
	 * 
	 * Note: If you want that a class gets blocked from collection simple add
	 * a static method "blockCollecting" that returns true.
	 * 
	 * Example:
	 * <code>
	 *   import org.as2lib.test.unit.TestCase;
	 * 
	 *   class MyTest extends TestCase {
	 *     public static function blockCollecting(Void):Boolean {
	 *	     return true;
	 *     }
	 *   }  
	 * </code>
	 * 
	 * 
	 * @param package Package to search in.
	 * @param suite TestSuite to add the found TestCase.
	 * @param recursive Recursive Flag.
	 */
	private function collectAgent(package, suite:TestSuite, recursive:Boolean):Void {
		var i:String;
		for(i in package) {
			var child = package[i];
			if(typeof child == "function" && ClassUtil.isSubClassOf(child, TestCase) && !child.blockCollecting()) {
				suite.addTest(TestCase(ClassUtil.createCleanInstance(child)));
			}
			if(typeof child == "object" && recursive) {
				collectAgent(child, suite, recursive);
			}
		}
	}
}