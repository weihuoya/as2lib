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
import org.as2lib.aop.pointcut.AndPointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.AopConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.TAndPointcut extends TestCase {
	
	private var oldPointcutFactory:PointcutFactory;
	
	public function setUp(Void):Void {
		oldPointcutFactory = AopConfig.getPointcutFactory();
	}
	
	public function tearDown(Void):Void {
		AopConfig.setPointcutFactory(oldPointcutFactory);
	}
	
	private function getBlankPointcut(Void):Pointcut {
		var result = new Object();
		result.__proto__ = Pointcut["prototype"];
		return result;
	}
	
	private function getBlankJoinPoint(Void):JoinPoint {
		var result = new Object();
		result.__proto__ = JoinPoint["prototype"];
		return result;
	}
	
	public function testNewWithNullStringPattern(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var p:AndPointcut = new AndPointcut(null);
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithEmptyStringPattern(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var p:AndPointcut = new AndPointcut("");
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithSinglePointcutString(Void):Void {
		var pc:MockControl = new MockControl(Pointcut);
		var p:Pointcut = pc.getMock();
		pc.replay();
		
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(p);
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var c:AndPointcut = new AndPointcut("org.as2lib.core.*.*()");
		assertSame(c.getPointcuts().length, 1);
		assertSame(c.getPointcuts()[0], p);
		
		fc.verify();
		pc.verify();
		tearDown();
	}
	
	public function testNewWithMultiplePointcutString(Void):Void {
		var c1c:MockControl = new MockControl(Pointcut);
		var c1:Pointcut = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(Pointcut);
		var c2:Pointcut = c2c.getMock();
		c2c.replay();
		
		var c3c:MockControl = new MockControl(Pointcut);
		var c3:Pointcut = c3c.getMock();
		c3c.replay();
		
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(c1);
		f.getPointcut("org.as2lib.env.reflect.*.*()");
		fc.setReturnValue(c2);
		f.getPointcut("org.as2lib.test.Juhu.lol()");
		fc.setReturnValue(c3);
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var p:AndPointcut = new AndPointcut("org.as2lib.core.*.*() && org.as2lib.env.reflect.*.*() && org.as2lib.test.Juhu.lol()");
		assertSame(p.getPointcuts().length, 3);
		assertSame(p.getPointcuts()[0], c1);
		assertSame(p.getPointcuts()[1], c2);
		assertSame(p.getPointcuts()[2], c3);
		
		fc.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		tearDown();
	}
	
	public function testCapturesWithNullJoinPoint(Void):Void {
		var pc:MockControl = new MockControl(Pointcut);
		var p:Pointcut = pc.getMock();
		pc.replay();
		
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(p);
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var c:AndPointcut = new AndPointcut("org.as2lib.core.*.*()");
		assertFalse(c.captures(null));
		
		fc.verify();
		pc.verify();
		tearDown();
	}
	
	public function testCapturesWithoutPointcuts(Void):Void {
		var jc:MockControl = new MockControl(JoinPoint);
		var j:JoinPoint = jc.getMock();
		jc.replay();
		
		var p:AndPointcut = new AndPointcut(null);
		assertFalse(p.captures(j));
		
		jc.verify();
	}
	
	public function testCapturesWithAllPointcutsCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = getBlankJoinPoint();
		
		var pc1:MockControl = new MockControl(Pointcut);
		var p1:Pointcut = pc1.getMock();
		p1.captures(j);
		pc1.setReturnValue(true);
		pc1.replay();
		
		var pc2:MockControl = new MockControl(Pointcut);
		var p2:Pointcut = pc2.getMock();
		p2.captures(j);
		pc2.setReturnValue(true);
		pc2.replay();
		
		var pc3:MockControl = new MockControl(Pointcut);
		var p3:Pointcut = pc3.getMock();
		p3.captures(j);
		pc3.setReturnValue(true);
		pc3.replay();
		
		var p:AndPointcut = new AndPointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertTrue(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
	public function testCapturesWithTheLastPointcutNotCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = getBlankJoinPoint();
		
		var pc1:MockControl = new MockControl(Pointcut);
		var p1:Pointcut = pc1.getMock();
		pc1.replay();
		
		var pc2:MockControl = new MockControl(Pointcut);
		var p2:Pointcut = pc2.getMock();
		pc2.replay();
		
		var pc3:MockControl = new MockControl(Pointcut);
		var p3:Pointcut = pc3.getMock();
		p3.captures(j);
		pc3.setReturnValue(false);
		pc3.replay();
		
		var p:AndPointcut = new AndPointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertFalse(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
	public function testCapturesWithTheMiddlePointcutNotCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = getBlankJoinPoint();
		
		var pc1:MockControl = new MockControl(Pointcut);
		var p1:Pointcut = pc1.getMock();
		pc1.replay();
		
		var pc2:MockControl = new MockControl(Pointcut);
		var p2:Pointcut = pc2.getMock();
		p2.captures(j);
		pc2.setReturnValue(false);
		pc2.replay();
		
		var pc3:MockControl = new MockControl(Pointcut);
		var p3:Pointcut = pc3.getMock();
		p3.captures(j);
		pc3.setReturnValue(true);
		pc3.replay();
		
		var p:AndPointcut = new AndPointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertFalse(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
}