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
import org.as2lib.env.reflect.TypeInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.TMethodJoinPoint extends TestCase {
	
	public function testNewWithNullInfo(Void):Void {
		try {
			new MethodJoinPoint(null, new Object());
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithNullThiz(Void):Void {
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		ic.replay();
		
		try {
			new MethodJoinPoint(i, null);
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
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
	
	/*public function testProceedWithNullArgs(Void):Void {
		var r:Object = new Object();
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var fc:MockControl = new MockControl(Function);
		var f:Function = fc.getMock();
		f.apply(t, null);
		fc.setReturnValue(r);
		fc.replay();
		
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		i.getMethod();
		ic.setReturnValue(f);
		ic.replay();
	
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		assertSame(j.proceed(null), r);
		
		ic.verify();
		tc.verify();
		fc.verify();
	}
	
	public function testProceedWithRealArgs(Void):Void {
		var r:Object = new Object();
		var a:Array = [new Object(), "arg2", 3, new Function()];
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var fc:MockControl = new MockControl(Function);
		var f:Function = fc.getMock();
		f.apply(t, a);
		fc.setReturnValue(r);
		fc.replay();
		
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		i.getMethod();
		ic.setReturnValue(f);
		ic.replay();
	
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		assertSame(j.proceed(a), r);
		
		ic.verify();
		tc.verify();
		fc.verify();
	}*/
	
	public function testMatchesWithNullPattern(Void):Void {
		var mc:MockControl = new MockControl(Matcher);
		var m:Matcher = mc.getMock();
		m.match("org.as2lib.core.BasicClass.myMethod", null);
		mc.setReturnValue(true);
		mc.replay();
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var dc:MockControl = new MockControl(TypeInfo);
		var d:TypeInfo = dc.getMock();
		d.getFullName();
		dc.setReturnValue("org.as2lib.core.BasicClass");
		dc.replay();
		
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		i.getDeclaringType();
		ic.setReturnValue(d);
		i.getName();
		ic.setReturnValue("myMethod");
		ic.replay();
		
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		j.setMatcher(m);
		assertTrue(j.matches(null));
		
		ic.verify();
		dc.verify();
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
		
		var dc:MockControl = new MockControl(TypeInfo);
		var d:TypeInfo = dc.getMock();
		d.getFullName();
		dc.setReturnValue("org.as2lib.core.BasicClass");
		dc.replay();
		
		var ic:MockControl = new MockControl(MethodInfo);
		var i:MethodInfo = ic.getMock();
		i.getDeclaringType();
		ic.setReturnValue(d);
		i.getName();
		ic.setReturnValue("myMethod");
		ic.replay();
		
		var j:MethodJoinPoint = new MethodJoinPoint(i, t);
		j.setMatcher(m);
		assertFalse(j.matches("org.*.BasicClass.*()"));
		
		ic.verify();
		dc.verify();
		tc.verify();
		mc.verify();
	}
	
}