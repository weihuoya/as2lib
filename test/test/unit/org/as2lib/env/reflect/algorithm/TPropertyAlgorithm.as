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

import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.CompositeMemberInfo;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.reflect.algorithm.TPropertyAlgorithm extends TestCase {
	
	public function setUp(Void):Void {
		test.unit.org.as2lib.env.reflect.treflect.SubClass;
		test.unit.org.as2lib.env.reflect.treflect.SuperClass;
	}
	
	public function testExecuteWithNullAndUndefinedArguments(Void):Void {
		var a:PropertyAlgorithm = new PropertyAlgorithm();
		assertNull("execute(null) should return null", a.execute(null));
		assertNull("execute(undefined) should return null", a.execute(undefined));
	}
	
	public function testExecuteWithArgumentWhoseGetTypeMethodReturnsNull(Void):Void {
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		i.getType();
		ic.setReturnValue(null);
		ic.replay();
		
		var a:PropertyAlgorithm = new PropertyAlgorithm();
		assertNull(a.execute(i));
		
		ic.verify();
	}
	
	public function testExecute(Void):Void {
		var pc:MockControl = new MockControl(ClassInfo);
		var p:ClassInfo = pc.getMock();
		p.getType();
		pc.setReturnValue(test.unit.org.as2lib.env.reflect.treflect.SubClass);
		pc.replay();
		
		var a:PropertyAlgorithm = new PropertyAlgorithm();
		var c:Array = a.execute(p);
		assertNotNull("property array should not be null", c);
		assertSame("there should be 4 properties", c.length, 4);
		for (var i:Number = 0; i < c.length; i++) {
			var k:PropertyInfo = c[i];
			if (k.getName() == "setOnlyProperty") {
				assertSame("setOnlyProperty: setter", k.getSetter().getMethod(), test.unit.org.as2lib.env.reflect.treflect.SubClass.prototype["__set__" + k.getName()]);
				// Souldn't it be null?
				assertEmpty("setOnlyProperty: getter", k.getGetter());
				assertFalse("setOnlyProperty: static", k.isStatic());
				assertSame("setOnlyProperty: type", k.getDeclaringType(), p);
			} else if (k.getName() == "getOnlyProperty") {
				assertSame("getOnlyProperty: getter", k.getGetter().getMethod(), test.unit.org.as2lib.env.reflect.treflect.SubClass.prototype["__get__" + k.getName()]);
				// Souldn't it be null?
				assertEmpty("getOnlyProperty: setter", k.getSetter());
				assertFalse("getOnlyProperty: static", k.isStatic());
				assertSame("getOnlyProperty: type", k.getDeclaringType(), p);
			} else if (k.getName() == "setAndGetProperty") {
				assertSame("setAndGetProperty: setter", k.getSetter().getMethod(), test.unit.org.as2lib.env.reflect.treflect.SubClass.prototype["__set__" + k.getName()]);
				assertSame("setAndGetProperty: getter", k.getGetter().getMethod(), test.unit.org.as2lib.env.reflect.treflect.SubClass.prototype["__get__" + k.getName()]);
				assertFalse("setAndGetProperty: static", k.isStatic());
				assertSame("setAndGetProperty: type", k.getDeclaringType(), p);
			} else if (k.getName() == "staticSetAndGetProperty") {
				assertSame("staticSetAndGetProperty: setter", k.getSetter().getMethod(), test.unit.org.as2lib.env.reflect.treflect.SubClass["__set__" + k.getName()]);
				assertSame("staticSetAndGetProperty: getter", k.getGetter().getMethod(), test.unit.org.as2lib.env.reflect.treflect.SubClass["__get__" + k.getName()]);
				assertTrue("staticSetAndGetProperty: static", k.isStatic());
				assertSame("staticSetAndGetProperty: type", k.getDeclaringType(), p);
			} else {
				fail("unknown property '" + k + "'");
			}
		}
		
		pc.verify();
	}
	
	public function testExecuteByClassWithoutMethods(Void):Void {
		var pc:MockControl = new MockControl(ClassInfo);
		var p:ClassInfo = pc.getMock();
		p.getType();
		pc.setReturnValue(test.unit.org.as2lib.env.reflect.treflect.SuperClass);
		pc.replay();
		
		var a:PropertyAlgorithm = new PropertyAlgorithm();
		var c:Array = a.execute(p);
		assertNotNull("children array should not be null", c);
		assertSame("there should be no children", c.length, 0);
		
		pc.verify();
	}
	
}