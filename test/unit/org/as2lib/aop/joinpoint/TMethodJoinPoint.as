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
import org.as2lib.aop.joinpoint.MethodJoinPoint;
import org.as2lib.aop.Matcher;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.aop.joinpoint.Class;
import org.as2lib.aop.joinpoint.SuperClass;
import org.as2lib.aop.joinpoint.SuperSuperClass;
import org.as2lib.aop.joinpoint.SuperSuperSuperClass;
import org.as2lib.aop.advice.DynamicAfterReturningAdvice;
import org.as2lib.app.exec.Call;
import org.as2lib.env.reflect.ClassInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.TMethodJoinPoint extends TestCase {
	
	public function testNewWithNullInfo(Void):Void {
		try {
			var jp:MethodJoinPoint = new MethodJoinPoint(null, new Object());
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithNullThiz(Void):Void {
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		ic.replay();
		
		var jp:MethodJoinPoint = new MethodJoinPoint(i, null);
		
		ic.verify();
	}
	
	public function testNewWithDefinedInfoAndThiz(Void):Void {
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		ic.replay();
		
		var t:Object = new Object();
	
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		assertSame(j.getInfo(), i);
		assertSame(j.getThis(), t);
		
		ic.verify();
	}
	
	public function testProceed(Void):Void {
		var e:Array = new Array();
		var c:Class = new Class(e);
		c.test();
		
		// Backing up current methods
		var o1:Function = Class.prototype.test;
		var o2:Function = SuperClass.prototype.test;
		var o3:Function = SuperSuperClass.prototype.test;
		var o4:Function = SuperSuperSuperClass.prototype.test;
		
		// Replacing with an advice
		var d:DynamicAfterReturningAdvice = new DynamicAfterReturningAdvice("", new Call(new Object(), function(){}));		
		Class.prototype.test = d.getProxy(new MethodJoinPoint(ClassInfo.forClass(Class).getMethod("test").snapshot(), this));
		SuperClass.prototype.test = d.getProxy(new MethodJoinPoint(ClassInfo.forClass(SuperClass).getMethod("test").snapshot(), this));
		SuperSuperClass.prototype.test = d.getProxy(new MethodJoinPoint(ClassInfo.forClass(SuperSuperClass).getMethod("test").snapshot(), this));
		SuperSuperSuperClass.prototype.test = d.getProxy(new MethodJoinPoint(ClassInfo.forClass(SuperSuperSuperClass).getMethod("test").snapshot(), this));
		
		var a:Array = new Array();
		c = new Class(a);
		c.test();
		
		assertSame("Result length before class modification does not match the expected length 22", e.length, 22);
		assertSame("Result length after modification does not match the expected length 22", a.length, 22);
		for (var i:Number = 0; i < e.length; i++) {
			assertSame("expectation [" + e[i] + "] for e[" + i + "] does not match actuality [" + a[i] + "]", e[i], a[i]);
		}
		
		// Restoring original methods.
		Class.prototype.test = o1;
		SuperClass.prototype.test = o2;
		SuperSuperClass.prototype.test = o3;
		SuperSuperSuperClass.prototype.test = o4;
	}
	
	public function testMatchesWithNullPattern(Void):Void {
		var mc:MockControl = new MockControl(Matcher);
		var m:Matcher = mc.getMock();
		m.match("static org.as2lib.core.BasicClass.myMethod", null);
		mc.setReturnValue(true);
		mc.replay();
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		i.isStatic();
		ic.setReturnValue(true);
		i.getFullName();
		ic.setReturnValue("org.as2lib.core.BasicClass.myMethod");
		ic.replay();
		
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		j.setMatcher(m);
		assertTrue(j.matches(null));
		
		ic.verify();
		tc.verify();
		mc.verify();
	}
	
	public function testMatchesWithRealPattern(Void):Void {
		var mc:MockControl = new MockControl(Matcher);
		var m:Matcher = mc.getMock();
		m.match("org.as2lib.core.BasicClass.myMethod", "org.*.BasicClass.*()");
		mc.setReturnValue(false);
		mc.replay();
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		i.isStatic();
		ic.setReturnValue(false);
		i.getFullName();
		ic.setReturnValue("org.as2lib.core.BasicClass.myMethod");
		ic.replay();
		
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		j.setMatcher(m);
		assertFalse(j.matches("org.*.BasicClass.*()"));
		
		ic.verify();
		tc.verify();
		mc.verify();
	}
	
}