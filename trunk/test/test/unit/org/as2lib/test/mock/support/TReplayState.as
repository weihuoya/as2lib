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
import org.as2lib.test.mock.Behaviour;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;
import test.unit.org.as2lib.test.mock.BehaviourMock;
import test.unit.org.as2lib.test.mock.MethodBehaviourMock;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TReplayState extends TestCase {
	
	public function testNewWithNullArgument(Void):Void {
		try {
			var s:ReplayState = new ReplayState(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithRealArgument(Void):Void {
		var b:Behaviour = new Behaviour();
		var s:ReplayState = new ReplayState(b);
		assertSame(s.getBehaviour(), b);
	}
	
	public function testVerifyWithNullArgument(Void):Void {
		var b:BehaviourMock = new BehaviourMock(this);
		b.verify(null);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		s.verify(null);
		
		b.doVerify();
	}
	
	public function testVerifyWithRealArgument(Void):Void {
		var b:BehaviourMock = new BehaviourMock(this);
		b.verify(this);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		s.verify(this);
		
		b.doVerify();
	}
	
	public function testInvokeMethodWithAvailableMethodBehaviourAndNullArgument(Void):Void {
		var rv:Object = new Object();
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addActualMethodCall(null);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.getMethodBehaviour(null);
		b.setGetMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(null), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithAvailableMethodBehaviourAndRealArgument(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall("methodName", []);
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.getMethodBehaviour(mc);
		b.setGetMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviourAndNullArgument(Void):Void {
		var rv:Object = new Object();
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addActualMethodCall(null);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.getMethodBehaviour(null);
		b.setGetMethodBehaviourReturnValue(null);
		b.createMethodBehaviour(null);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("[unknown]", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(null), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviourAndRealArgument(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall("methodName", []);
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.getMethodBehaviour(mc);
		b.setGetMethodBehaviourReturnValue(null);
		b.createMethodBehaviour(null);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("methodName", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviourAndRealArgumentAndNullMethodName(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall(null, []);
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.getMethodBehaviour(mc);
		b.setGetMethodBehaviourReturnValue(null);
		b.createMethodBehaviour(null);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("[unknown]", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithUnavailableMethodBehaviourAndRealArgumentAndBlankStringMethodName(Void):Void {
		var rv:Object = new Object();
		var mc:MethodCall = new MethodCall("", []);
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addActualMethodCall(mc);
		m.response();
		m.setResponseReturnValue(rv);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.getMethodBehaviour(mc);
		b.setGetMethodBehaviourReturnValue(null);
		b.createMethodBehaviour(null);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("[unknown]", m);
		b.replay();
		
		var s:ReplayState = new ReplayState(b);
		assertSame(s.invokeMethod(mc), rv);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetMethodResponse(Void):Void {
		var b:BehaviourMock = new BehaviourMock(this);
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
		var b:BehaviourMock = new BehaviourMock(this);
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