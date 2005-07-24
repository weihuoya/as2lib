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
import org.as2lib.aop.joinpoint.PropertyJoinPoint;
import org.as2lib.aop.Matcher;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.TPropertyJoinPoint extends TestCase {
	
	public function testNewWithNullInfo(Void):Void {
		try {
			new PropertyJoinPoint(null, new Object());
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithNullThiz(Void):Void {
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		ic.replay();
		
		try {
			new PropertyJoinPoint(i, null);
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		ic.verify();
	}
	
	public function testNewWithDefinedInfoAndThiz(Void):Void {
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		ic.replay();
		
		var t:Object = new Object();
	
		var j:PropertyJoinPoint = new PropertyJoinPoint(i, t);
		assertSame(j.getInfo(), i);
		assertSame(j.getThis(), t);
		
		ic.verify();
	}
	
	public function testProceed(Void):Void {
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		ic.replay();
		
		var j:PropertyJoinPoint = new PropertyJoinPoint(i, t);
		try {
			j.proceed([]);
			fail("Expected UnsupportedOperationException.");
		} catch (e:org.as2lib.env.except.UnsupportedOperationException) {
		}
		
		ic.verify();
		tc.verify();
	}
	
	public function testMatchesWithNullPattern(Void):Void {
		var mc:MockControl = new MockControl(Matcher);
		var m:Matcher = mc.getMock();
		m.match("org.as2lib.core.BasicClass.myProperty", null);
		mc.setReturnValue(true);
		mc.replay();
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		i.getFullName();
		ic.setReturnValue("org.as2lib.core.BasicClass.myProperty");
		ic.replay();
		
		var j:PropertyJoinPoint = new PropertyJoinPoint(i, t);
		j.setMatcher(m);
		assertTrue(j.matches(null));
		
		ic.verify();
		tc.verify();
		mc.verify();
	}
	
	public function testMatchesWithRealPattern(Void):Void {
		var mc:MockControl = new MockControl(Matcher);
		var m:Matcher = mc.getMock();
		m.match("org.as2lib.core.BasicClass.myProperty", "org.*.BasicClass.*()");
		mc.setReturnValue(false);
		mc.replay();
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		i.getFullName();
		ic.setReturnValue("org.as2lib.core.BasicClass.myProperty");
		ic.replay();
		
		var j:PropertyJoinPoint = new PropertyJoinPoint(i, t);
		j.setMatcher(m);
		assertFalse(j.matches("org.*.BasicClass.*()"));
		
		ic.verify();
		tc.verify();
		mc.verify();
	}
	
}