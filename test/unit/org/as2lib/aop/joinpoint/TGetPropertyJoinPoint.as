﻿/*
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
import org.as2lib.aop.joinpoint.GetPropertyJoinPoint;
import org.as2lib.env.reflect.PropertyInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.TGetPropertyJoinPoint extends TestCase {
	
	public function testNewWithNotReadableProperty(Void):Void {
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		i.isReadable();
		ic.setReturnValue(false);
		ic.replay();
		try {
			var jp:GetPropertyJoinPoint = new GetPropertyJoinPoint(i, new Object());
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		ic.verify();
	}
	
	public function testNewWithReadableProperty(Void):Void {
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		i.isReadable();
		ic.setReturnValue(true);
		ic.replay();
		var jp:GetPropertyJoinPoint = new GetPropertyJoinPoint(i, new Object());
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
		
		var gc:MockControl = new MockControl(MethodInfo);
		var g:MethodInfo = gc.getMock();
		g.getMethod();
		gc.setReturnValue(f);
		gc.replay();
		
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		i.getGetter();
		ic.setReturnValue(g);
		ic.replay();
	
		var j:GetPropertyJoinPoint = new GetPropertyJoinPoint(i, t);
		assertSame(j.proceed(null), r);
		
		ic.verify();
		tc.verify();
		fc.verify();
		gc.verify();
	}
	
	public function testProceedWithRealArgs(Void):Void {
		var r:Object = new Object();
		var a:Array = [new Object(), "arg1", 2, new Function()];
		
		var tc:MockControl = new MockControl(Object);
		var t:Object = tc.getMock();
		tc.replay();
		
		var fc:MockControl = new MockControl(Function);
		var f:Function = fc.getMock();
		f.apply(t, a);
		fc.setReturnValue(r);
		fc.replay();
		
		var gc:MockControl = new MockControl(MethodInfo);
		var g:MethodInfo = gc.getMock();
		g.getMethod();
		gc.setReturnValue(f);
		gc.replay();
		
		var ic:MockControl = new MockControl(PropertyInfo);
		var i:PropertyInfo = ic.getMock();
		i.getGetter();
		ic.setReturnValue(g);
		ic.replay();
		
		var j:GetPropertyJoinPoint = new GetPropertyJoinPoint(i, t);
		assertSame(j.proceed(a), r);
		
		ic.verify();
		tc.verify();
		fc.verify();
		gc.verify();
	}*/
	
}