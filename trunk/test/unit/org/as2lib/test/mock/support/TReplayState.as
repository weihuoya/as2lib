/**
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
import org.as2lib.test.mock.support.ReplayState;
import org.as2lib.test.mock.Behavior;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.BehaviorMock;
import org.as2lib.test.mock.MethodBehaviorMock;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.TReplayState extends TestCase {

	private function getBlankBehavior(Void):Behavior {
		var result = new Object();
		result.__proto__ = Behavior["prototype"];
		return result;
	}
	
	public function testNewWithNullArgument(Void):Void {
		try {
			var s:ReplayState = new ReplayState(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithRealArgument(Void):Void {
		var b:Behavior = getBlankBehavior();
		var s:ReplayState = new ReplayState(b);
		assertSame(s.getBehavior(), b);
	}
	
	public function testVerifyWithNullArgument(Void):Void {
		var b:BehaviorMock = new BehaviorMock(this);
		b.verify();
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		s.verify();
		
		b.doVerify();
	}
	
	public function testVerifyWithRealArgument(Void):Void {
		var b:BehaviorMock = new BehaviorMock(this);
		b.verify();
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		s.verify();
		
		b.doVerify();
	}
	
	public function testInvokeMethodWithAvailableMethodBehaviorAndNullArgument(Void):Void {
		var rv:Object = new Object();
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addActualMethodCall(null);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.getMethodBehavior(null);
		b.setGetMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(null), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithAvailableMethodBehaviorAndRealArgument(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall("methodName", []);
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.getMethodBehavior(mc);
		b.setGetMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviorAndNullArgument(Void):Void {
		var rv:Object = new Object();
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addActualMethodCall(null);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.getMethodBehavior(null);
		b.setGetMethodBehaviorReturnValue(null);
		b.createMethodBehavior(null);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior("[unknown]", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(null), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviorAndRealArgument(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall("methodName", []);
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.getMethodBehavior(mc);
		b.setGetMethodBehaviorReturnValue(null);
		b.createMethodBehavior(null);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior("methodName", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviorAndRealArgumentAndNullMethodName(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall(null, []);
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.getMethodBehavior(mc);
		b.setGetMethodBehaviorReturnValue(null);
		b.createMethodBehavior(null);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior("[unknown]", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviorAndRealArgumentAndBlankStringMethodName(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall("", []);
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.getMethodBehavior(mc);
		b.setGetMethodBehaviorReturnValue(null);
		b.createMethodBehavior(null);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior("[unknown]", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetMethodResponse(Void):Void {
		var b:BehaviorMock = new BehaviorMock(this);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		try {
			s.setMethodResponse(null, null);
			fail("Expected IllegalStateException.");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
		
		b.doVerify();
	}
	
	public function testSetArgumentsMatcher(Void):Void {
		var b:BehaviorMock = new BehaviorMock(this);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		try {
			s.setMethodResponse(null);
			fail("Expected IllegalStateException.");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
		
		b.doVerify();
	}
	
}