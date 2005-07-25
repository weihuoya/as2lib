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
import org.as2lib.aop.Advice;
import org.as2lib.app.exec.Call;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.test.mock.MockControl;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractTAdvice extends TestCase {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function createAdvice(p:Pointcut, c:Call):Advice {
		return null;
	}
	
	private function getBlankJoinPoint(Void):JoinPoint {
		var r = new Object();
		r.__proto__ = JoinPoint["prototype"];
		r.__constructor__ = JoinPoint;
		return r;
	}
	
	public function testCapturesWithCapturingPointcut(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		jc.replay();
		
		var pc:MockControl = new MockControl(Pointcut);
		var p:Pointcut = pc.getMock();
		p.captures(j);
		pc.setReturnValue(true);
		pc.replay();
		
		var a:Advice = createAdvice(p);
		assertTrue(a.captures(j));
		
		pc.verify();
		jc.verify();
	}
	
	public function testCapturesWithNotCapturingPointcut(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		jc.replay();
		
		var pc:MockControl = new MockControl(Pointcut);
		var p:Pointcut = pc.getMock();
		p.captures(j);
		pc.setReturnValue(false);
		pc.replay();
		
		var a:Advice = createAdvice(p);
		assertFalse(a.captures(j));
		
		pc.verify();
		jc.verify();
	}
	
	public function testCapturesWithoutPointcut(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		jc.replay();
		
		var a:Advice = createAdvice(null);
		assertTrue(a.captures(j));
		
		jc.verify();
	}
	
}