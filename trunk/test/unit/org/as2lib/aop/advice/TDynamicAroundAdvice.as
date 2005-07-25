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
import org.as2lib.app.exec.Call;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.advice.DynamicAroundAdvice;
import org.as2lib.aop.advice.AbstractTAdvice;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.TDynamicAroundAdvice extends AbstractTAdvice {
	
	private function createAdvice(p:Pointcut, c:Call):Advice {
		return new DynamicAroundAdvice(p, c);
	}
	
	public function testGetProxyWithProperlyReturningJoinPoint(Void):Void {
		var pc:MockControl = new MockControl(Pointcut);
		var p:Pointcut = pc.getMock();
		pc.replay();
		var a3:Object = new Object();
		var o:Object = new Object();
		var z:Array = new Array();
		var thiz:TestCase = this;
		var j:JoinPoint = getBlankJoinPoint();
		j.update = function(object):JoinPoint {
			thiz.assertSame(object, o);
			return j;
		};
		j.proceed = function(args:Array):String {
			z.push("proceed");
			thiz.assertSame(args[0], "blubber1");
			thiz.assertSame(args[1], a3);
			thiz.assertSame(args[2], 5);
			return "rv";
		};
		var c:Call = new Call(this, function(joinPoint:JoinPoint, args:Array):String {
			z.push("callback");
			thiz.assertSame(joinPoint, j);
			thiz.assertSame(args[0], "arg1");
			thiz.assertSame(args[1], 2);
			thiz.assertSame(args[2], a3);
			joinPoint.proceed(["blubber1", a3, 5], "rv");
			return "blubber";
		});
		var a:Advice = createAdvice(p, c);
		o.p = a.getProxy(j);
		assertSame(o.p("arg1", 2, a3), "blubber");
		assertSame(z.length, 2);
		assertSame(z[0], "callback");
		assertSame(z[1], "proceed");
		pc.verify();
	}
	
	public function testGetProxyWithExceptionThrowingJoinPoint(Void):Void {
		var pc:MockControl = new MockControl(Pointcut);
		var p:Pointcut = pc.getMock();
		var e:Error = new Error();
		pc.replay();
		var a3:Object = new Object();
		var o:Object = new Object();
		var z:Array = new Array();
		var thiz:TestCase = this;
		var j:JoinPoint = getBlankJoinPoint();
		j.update = function(object):JoinPoint {
			thiz.assertSame(object, o);
			return j;
		};
		j.proceed = function(args:Array):String {
			z.push("proceed");
			thiz.assertSame(args[0], "blubber1");
			thiz.assertSame(args[1], a3);
			thiz.assertSame(args[2], 5);
			throw e;
			return "rv";
		};
		var c:Call = new Call(this, function(joinPoint:JoinPoint, args:Array):String {
			z.push("callback");
			thiz.assertSame(joinPoint, j);
			thiz.assertSame(args[0], "arg1");
			thiz.assertSame(args[1], 2);
			thiz.assertSame(args[2], a3);
			joinPoint.proceed(["blubber1", a3, 5]);
			return "blubber";
		});
		var a:Advice = createAdvice(p, c);
		o.p = a.getProxy(j);
		try {
			o.p("arg1", 2, a3);
			fail("expected error");
		} catch (e:Error) {
		}
		assertSame(z.length, 2);
		assertSame(z[0], "callback");
		assertSame(z[1], "proceed");
		pc.verify();
	}
	
}