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
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.TMethodAlgorithm extends TestCase {
	
	public function setUp(Void):Void {
		org.as2lib.env.reflect.treflect.SubClass;
		org.as2lib.env.reflect.treflect.SuperClass;
	}
	
	public function testExecuteWithNullAndUndefinedArguments(Void):Void {
		var a:MethodAlgorithm = new MethodAlgorithm();
		assertNull("execute(null) should return null", a.execute(null));
		assertNull("execute(undefined) should return null", a.execute(undefined));
	}
	
	public function testExecuteWithArgumentWhoseGetTypeMethodReturnsNull(Void):Void {
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		i.getType();
		ic.setReturnValue(null);
		ic.replay();
		
		var a:MethodAlgorithm = new MethodAlgorithm();
		assertNull(a.execute(i));
		
		ic.verify();
	}
	
	public function testExecute(Void):Void {
		var pc:MockControl = new MockControl(ClassInfo);
		var p:ClassInfo = pc.getMock();
		p.getType();
		pc.setReturnValue(org.as2lib.env.reflect.treflect.SubClass);
		pc.replay();
		
		var a:MethodAlgorithm = new MethodAlgorithm();
		var c:Array = a.execute(p);
		assertNotNull("method array should not be null", c);
		assertSame("there should be 4 methods", c.length, 4);
		for (var i:Number = 0; i < c.length; i++) {
			var k:MethodInfo = c[i];
			if (k.getName() == "publicMethod") {
				assertSame("publicMethod", k.getMethod(), org.as2lib.env.reflect.treflect.SubClass.prototype.publicMethod);
				assertFalse("publicMethod", k.isStatic());
				assertSame("publicMethod", k.getDeclaringType(), p);
			} else if (k.getName() == "privateMethod") {
				assertSame("privateMethod", k.getMethod(), org.as2lib.env.reflect.treflect.SubClass.prototype["private" + "Method"]);
				assertFalse("privateMethod", k.isStatic());
				assertSame("privateMethod", k.getDeclaringType(), p);
			} else if (k.getName() == "publicStaticMethod") {
				assertSame("publicStaticMethod", k.getMethod(), org.as2lib.env.reflect.treflect.SubClass.publicStaticMethod);
				assertTrue("publicStaticMethod", k.isStatic());
				assertSame("publicStaticMethod", k.getDeclaringType(), p);
			} else if (k.getName() == "privateStaticMethod") {
				assertSame("privateStaticMethod", k.getMethod(), org.as2lib.env.reflect.treflect.SubClass["private" + "StaticMethod"]);
				assertTrue("privateStaticMethod", k.isStatic());
				assertSame("privateStaticMethod", k.getDeclaringType(), p);
			} else {
				fail("unknown method '" + k + "'");
			}
		}
		
		pc.verify();
	}
	
	public function testExecuteByClassWithoutMethods(Void):Void {
		var pc:MockControl = new MockControl(ClassInfo);
		var p:ClassInfo = pc.getMock();
		p.getType();
		pc.setReturnValue(org.as2lib.env.reflect.treflect.SuperClass);
		pc.replay();
		
		var a:MethodAlgorithm = new MethodAlgorithm();
		var c:Array = a.execute(p);
		assertNotNull("method array should not be null", c);
		assertSame("there should be no methods", c.length, 0);
		
		pc.verify();
	}
	
}