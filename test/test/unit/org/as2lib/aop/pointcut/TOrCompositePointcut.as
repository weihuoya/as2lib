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
import org.as2lib.aop.pointcut.OrCompositePointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.pointcut.PointcutConfig;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.aop.pointcut.TOrCompositePointcut extends TestCase {
	
	private var oldPointcutFactory:PointcutFactory;
	
	public function setUp(Void):Void {
		oldPointcutFactory = PointcutConfig.getPointcutFactory();
	}
	
	public function tearDown(Void):Void {
		PointcutConfig.setPointcutFactory(oldPointcutFactory);
	}
	
	public function testNewWithNullStringPattern(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		fc.replay();
		
		PointcutConfig.setPointcutFactory(f);
		
		var p:OrCompositePointcut = new OrCompositePointcut(null);
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithEmptyStringPattern(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		fc.replay();
		
		PointcutConfig.setPointcutFactory(f);
		
		var p:OrCompositePointcut = new OrCompositePointcut("");
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithSinglePointcutString(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(new Pointcut());
		fc.replay();
		
		PointcutConfig.setPointcutFactory(f);
		
		var p:OrCompositePointcut = new OrCompositePointcut("org.as2lib.core.*.*()");
		// test wether the pointcut really has been added
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithMultiplePointcutString(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(new Pointcut());
		f.getPointcut("org.as2lib.env.reflect.*.*()");
		fc.setReturnValue(new Pointcut());
		f.getPointcut("org.as2lib.test.Juhu.lol()");
		fc.setReturnValue(new Pointcut());
		fc.replay();
		
		PointcutConfig.setPointcutFactory(f);
		
		var p:OrCompositePointcut = new OrCompositePointcut("org.as2lib.core.*.*() || org.as2lib.env.reflect.*.*() || org.as2lib.test.Juhu.lol()");
		// test wether the pointcut really has been added
		
		fc.verify();
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
		
		PointcutConfig.setPointcutFactory(f);
		
		var p:OrCompositePointcut = new OrCompositePointcut("org.as2lib.core.*.*()");
		assertFalse(p.captures(null));
		
		fc.verify();
		pc.verify();
		tearDown();
	}
	
	public function testCapturesWithEmptyPointcutStack(Void):Void {
		var p:OrCompositePointcut = new OrCompositePointcut(null);
		assertFalse(p.captures(new JoinPoint()));
	}
	
	public function testCapturesWithNoPointcutCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = new JoinPoint();
		
		var pc1:MockControl = new MockControl(Pointcut);
		var p1:Pointcut = pc1.getMock();
		p1.captures(j);
		pc1.setReturnValue(false);
		pc1.replay();
		
		var pc2:MockControl = new MockControl(Pointcut);
		var p2:Pointcut = pc2.getMock();
		p2.captures(j);
		pc2.setReturnValue(false);
		pc2.replay();
		
		var pc3:MockControl = new MockControl(Pointcut);
		var p3:Pointcut = pc3.getMock();
		p3.captures(j);
		pc3.setReturnValue(false);
		pc3.replay();
		
		var p:OrCompositePointcut = new OrCompositePointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertFalse(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
	public function testCapturesWithTheLastPointcutCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = new JoinPoint();
		
		var pc1:MockControl = new MockControl(Pointcut);
		var p1:Pointcut = pc1.getMock();
		pc1.replay();
		
		var pc2:MockControl = new MockControl(Pointcut);
		var p2:Pointcut = pc2.getMock();
		pc2.replay();
		
		var pc3:MockControl = new MockControl(Pointcut);
		var p3:Pointcut = pc3.getMock();
		p3.captures(j);
		pc3.setReturnValue(true);
		pc3.replay();
		
		var p:OrCompositePointcut = new OrCompositePointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertTrue(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
	public function testCapturesWithTheMiddlePointcutCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = new JoinPoint();
		
		var pc1:MockControl = new MockControl(Pointcut);
		var p1:Pointcut = pc1.getMock();
		pc1.replay();
		
		var pc2:MockControl = new MockControl(Pointcut);
		var p2:Pointcut = pc2.getMock();
		p2.captures(j);
		pc2.setReturnValue(true);
		pc2.replay();
		
		var pc3:MockControl = new MockControl(Pointcut);
		var p3:Pointcut = pc3.getMock();
		p3.captures(j);
		pc3.setReturnValue(false);
		pc3.replay();
		
		var p:OrCompositePointcut = new OrCompositePointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertTrue(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
}