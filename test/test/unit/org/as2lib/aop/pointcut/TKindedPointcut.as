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
import org.as2lib.aop.pointcut.KindedPointcut;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.aop.pointcut.TKindedPointcut extends TestCase {
	
	public function testCapturesWithNullJoinPoint(Void):Void {
		var p:KindedPointcut = new KindedPointcut("*", 2);
		assertFalse(p.captures(null));
	}
	
	public function testCapturesWithNullMatchingJoinPoint(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		j.matches("*");
		jc.setReturnValue(true);
		jc.replay();
		
		var p:KindedPointcut = new KindedPointcut("*", null);
		assertTrue(p.captures(j));
		
		jc.verify();
	}
	
	public function testCapturesWithNullPattern(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		j.getType();
		jc.setReturnValue(2);
		j.matches(null);
		jc.setReturnValue(false);
		jc.replay();
		
		var p:KindedPointcut = new KindedPointcut(null, 2);
		assertFalse(p.captures(j));
		
		jc.verify();
	}
	
	public function testCapturesWithPatternAndMatchingJoinPoint(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		j.getType();
		jc.setReturnValue(2);
		j.matches("pattern*..");
		jc.setReturnValue(true);
		jc.replay();
		
		var p:KindedPointcut = new KindedPointcut("pattern*..", 2);
		assertTrue(p.captures(j));
		
		jc.verify();
	}
	
	public function testCapturesWithNotMatchingPatternButMatchingJoinPoint(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		j.getType();
		jc.setReturnValue(2);
		j.matches("pattern*..");
		jc.setReturnValue(false);
		jc.replay();
		
		var p:KindedPointcut = new KindedPointcut("pattern*..", 2);
		assertFalse(p.captures(j));
		
		jc.verify();
	}
	
	public function testCapturesWithMatchingPatternButNotMatchingJoinPoint(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		j.getType();
		jc.setReturnValue(3);
		jc.replay();
		
		var p:KindedPointcut = new KindedPointcut("pattern*..", 2);
		assertFalse(p.captures(j));
		
		jc.verify();
	}
	
}