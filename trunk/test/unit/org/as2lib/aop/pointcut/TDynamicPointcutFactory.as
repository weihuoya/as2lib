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
import org.as2lib.aop.pointcut.DynamicPointcutFactory;
import org.as2lib.aop.pointcut.PointcutRule;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.TDynamicPointcutFactory extends TestCase {
	
	private function getBlankPointcutFactory(Void):PointcutFactory {
		var result = new Object();
		result.__proto__ = PointcutFactory["prototype"];
		return result;
	}
	
	private function getBlankPointcutRule(Void):PointcutRule {
		var result = new Object();
		result.__proto__ = PointcutRule["prototype"];
		return result;
	}
	
	private function getBlankPointcut(Void):Pointcut {
		var result = new Object();
		result.__proto__ = Pointcut["prototype"];
		return result;
	}
	
	public function testBindPointcutFactoryWithNullRule(Void):Void {
		var f:DynamicPointcutFactory = new DynamicPointcutFactory();
		try {
			f.bindPointcutFactory(null, getBlankPointcutFactory());
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testBindPointcutFactoryWithNullFactory(Void):Void {
		var f:DynamicPointcutFactory = new DynamicPointcutFactory();
		try {
			f.bindPointcutFactory(getBlankPointcutRule(), null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testGetPointcutWithNullPattern(Void):Void {
		var f:DynamicPointcutFactory = new DynamicPointcutFactory();
		assertNull(f.getPointcut(null));
	}
	
	public function testGetPointcutWithBlankPattern(Void):Void {
		var f:DynamicPointcutFactory = new DynamicPointcutFactory();
		assertNull(f.getPointcut(""));
	}
	
	public function testGetPointcutWithUnknownPattern(Void):Void {
		var f:DynamicPointcutFactory = new DynamicPointcutFactory();
		assertNull(f.getPointcut("unknownPattern"));
	}
	
	public function testGetPointcutWithMultipleBoundFactories(Void):Void {
		var p1:Pointcut = getBlankPointcut();
		var p3:Pointcut = getBlankPointcut();
		
		var fc1:MockControl = new MockControl(PointcutFactory);
		var f1:PointcutFactory = fc1.getMock();
		f1.getPointcut("anotherPattern");
		fc1.setReturnValue(p1);
		fc1.replay();
		
		var fc2:MockControl = new MockControl(PointcutFactory);
		var f2:PointcutFactory = fc2.getMock();
		fc2.replay();
		
		var fc3:MockControl = new MockControl(PointcutFactory);
		var f3:PointcutFactory = fc3.getMock();
		f3.getPointcut("myPattern");
		fc3.setReturnValue(p3);
		fc3.replay();
		
		var fc4:MockControl = new MockControl(PointcutFactory);
		var f4:PointcutFactory = fc4.getMock();
		fc4.replay();
		
		var rc1:MockControl = new MockControl(PointcutRule);
		var r1:PointcutRule = rc1.getMock();
		r1.execute("myPattern");
		rc1.setReturnValue(false);
		r1.execute("anotherPattern");
		rc1.setReturnValue(true);
		r1.execute("unknownPattern");
		rc1.setReturnValue(false);
		rc1.replay();
		
		var rc2:MockControl = new MockControl(PointcutRule);
		var r2:PointcutRule = rc2.getMock();
		r2.execute("myPattern");
		rc2.setReturnValue(false);
		r2.execute("unknownPattern");
		rc2.setReturnValue(false);
		rc2.replay();
		
		var rc3:MockControl = new MockControl(PointcutRule);
		var r3:PointcutRule = rc3.getMock();
		r3.execute("myPattern");
		rc3.setReturnValue(true);
		r3.execute("unknownPattern");
		rc3.setReturnValue(false);
		rc3.replay();
		
		var rc4:MockControl = new MockControl(PointcutRule);
		var r4:PointcutRule = rc4.getMock();
		r4.execute("unknownPattern");
		rc4.setReturnValue(false);
		rc4.replay();
		
		var f:DynamicPointcutFactory = new DynamicPointcutFactory();
		f.bindPointcutFactory(r1, f1);
		f.bindPointcutFactory(r2, f2);
		f.bindPointcutFactory(r3, f3);
		f.bindPointcutFactory(r4, f4);
		assertSame(f.getPointcut("myPattern"), p3);
		assertSame(f.getPointcut("anotherPattern"), p1);
		assertNull(f.getPointcut("unknownPattern"));
		
		fc1.verify();
		fc2.verify();
		fc3.verify();
		fc4.verify();
		rc1.verify();
		rc2.verify();
		rc3.verify();
		rc4.verify();
	}
	
}