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
import org.as2lib.core.BasicInterface;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.Test;
import org.as2lib.util.ClassUtil;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.overload.OverloadHandler;

/**
 * Test of all methods in ClassUtil.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.util.TClassUtil extends TestCase {

	/**
	 * Testing the possible ways to use "isImplementationOf"
	 */
	public function testIsSubClassOf(Void):Void {
		assertTrue("TestCase is a subclass of BasicClass because it directly extends it", ClassUtil.isSubClassOf(TestCase, BasicClass));
		assertFalse("TestCase is not a subclass of BasicInterface because it is a Interface", ClassUtil.isSubClassOf(TestCase, BasicInterface));
		assertFalse("TestCase is not a subclass of Test because it directly implements it", ClassUtil.isSubClassOf(TestCase, Test));
		assertFalse("TestCase is not a subclass of TestCase because it is TestCase", ClassUtil.isSubClassOf(TestCase, TestCase));
		assertFalse("TestCase is not a subclass of Overload", ClassUtil.isSubClassOf(TestCase, Overload));
	}
	
	/**
	 * Testing the possible ways to use "isImplementationOf".
	 */
	public function testIsImplementationOf(Void):Void {
		assertFalse("TestCase is not a implementation of BasicClass because BasicClass is no interface", ClassUtil.isImplementationOf(TestCase, BasicClass));
		assertTrue("TestCase is a implementation of BasicInterface because it is a Interface", ClassUtil.isImplementationOf(TestCase, BasicInterface));
		assertTrue("TestCase is a implementation of Test because it directly implements it", ClassUtil.isImplementationOf(TestCase, Test));
		assertTrue("TestCase is a implementation of TestCase because it is no interface", ClassUtil.isImplementationOf(TestCase, TestCase));
		assertFalse("TestCase is not a implementation of OverloadHandler", ClassUtil.isImplementationOf(TestCase, OverloadHandler));
	}
	
	/**
	 * Creates a clean instance and validates that the contructor will not be called.
	 */
	public function testCreateCleanInstance(Void):Void {
		var clazz:Function = function() {
			// Short Class construct (easy as1 way)
			this.test = "a";
		};
		var instance:Object = ClassUtil.createCleanInstance(clazz);
		assertNotEmpty("Instance was created so it must not be empty", instance);
		assertUndefined("Constructor may not be called", instance.test);
		assertInstanceOf("Instance has to be a instance of clazz", instance, clazz);
	}	
}