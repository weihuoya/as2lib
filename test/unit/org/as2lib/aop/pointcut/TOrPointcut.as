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
import org.as2lib.aop.pointcut.OrPointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.AopConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.TOrPointcut extends TestCase {
	
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
		
		var p:OrPointcut = new OrPointcut(null);
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithEmptyStringPattern(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var p:OrPointcut = new OrPointcut("");
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithSinglePointcutString(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(getBlankPointcut());
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var p:OrPointcut = new OrPointcut("org.as2lib.core.*.*()");
		// test wether the pointcut really has been added
		
		fc.verify();
		tearDown();
	}
	
	public function testNewWithMultiplePointcutString(Void):Void {
		var fc:MockControl = new MockControl(PointcutFactory);
		var f:PointcutFactory = fc.getMock();
		f.getPointcut("org.as2lib.core.*.*()");
		fc.setReturnValue(getBlankPointcut());
		f.getPointcut("org.as2lib.env.reflect.*.*()");
		fc.setReturnValue(getBlankPointcut());
		f.getPointcut("org.as2lib.test.Juhu.lol()");
		fc.setReturnValue(getBlankPointcut());
		fc.replay();
		
		AopConfig.setPointcutFactory(f);
		
		var p:OrPointcut = new OrPointcut("org.as2lib.core.*.*()||org.as2lib.env.reflect.*.*()||org.as2lib.test.Juhu.lol()");
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
		
		AopConfig.setPointcutFactory(f);
		
		var p2:OrPointcut = new OrPointcut("org.as2lib.core.*.*()");
		assertFalse(p2.captures(null));
		
		fc.verify();
		pc.verify();
		tearDown();
	}
	
	public function testCapturesWithEmptyPointcutStack(Void):Void {
		var p:OrPointcut = new OrPointcut(null);
		assertFalse(p.captures(getBlankJoinPoint()));
	}
	
	public function testCapturesWithNoPointcutCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = getBlankJoinPoint();
		
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
		
		var p:OrPointcut = new OrPointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertFalse(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
	public function testCapturesWithTheLastPointcutCapturingTheJoinPoint(Void):Void {
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
		pc3.setReturnValue(true);
		pc3.replay();
		
		var p:OrPointcut = new OrPointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertTrue(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
	public function testCapturesWithTheMiddlePointcutCapturingTheJoinPoint(Void):Void {
		var j:JoinPoint = getBlankJoinPoint();
		
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
		
		var p:OrPointcut = new OrPointcut(null);
		p.addPointcut(p1);
		p.addPointcut(p2);
		p.addPointcut(p3);
		assertTrue(p.captures(j));
		
		pc1.verify();
		pc2.verify();
		pc3.verify();
	}
	
}