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
import org.as2lib.test.mock.support.RecordState;
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
class test.unit.org.as2lib.test.mock.support.TRecordState extends TestCase {
	
	public function testNewWithNullArgument(Void):Void {
		try {
			var s:RecordState = new RecordState(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithRealArgument(Void):Void {
		var b:Behaviour = new Behaviour();
		var s:RecordState = new RecordState(b);
		assertSame(s.getBehaviour(), b);
	}
	
	public function testInvokeMethodWithNullArgument(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.replay();
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.createMethodBehaviour(null);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("[unknown]", m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(null);
	}
	
	public function testInvokeMethodWithRealArgument(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall("methodName", []);
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.createMethodBehaviour(c);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("methodName", m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(c);
	}
	
	public function testInvokeMethodWithNullReturningMethodCallGetMethodNameMethod(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall(null, []);
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.createMethodBehaviour(c);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("[unknown]", m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(c);
	}
	
	public function testInvokeMethodWithEmptyStringReturningMethodCallGetMethodNameMethod(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall("", []);
		
		var b:BehaviourMock = new BehaviourMock(this);
		b.createMethodBehaviour(c);
		b.setCreateMethodBehaviourReturnValue(m);
		b.addMethodBehaviour("[unknown]", m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(c);
	}
	
	public function testSetMethodResponseWithNullMethodResponse(Void):Void {
		var r:MethodCallRange = new MethodCallRange();
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addMethodResponse(null, r);
		m.replay();

		var b:BehaviourMock = new BehaviourMock(this);
		b.getLastMethodBehaviour();
		b.setGetLastMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setMethodResponse(null, r);
	}
	
	public function testSetMethodResponseWithNullMethodCallRange(Void):Void {
		var r:MethodResponse = new MethodResponse();
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addMethodResponse(r, null);
		m.replay();

		var b:BehaviourMock = new BehaviourMock(this);
		b.getLastMethodBehaviour();
		b.setGetLastMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setMethodResponse(r, null);
	}
	
	public function testSetMethodResponseWithRealArguments(Void):Void {
		var r:MethodResponse = new MethodResponse();
		var cr:MethodCallRange = new MethodCallRange();
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.addMethodResponse(r, cr);
		m.replay();

		var b:BehaviourMock = new BehaviourMock(this);
		b.getLastMethodBehaviour();
		b.setGetLastMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setMethodResponse(r, cr);
	}
	
	public function testSetArgumentsMatcherWithNullArgument(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.setArgumentsMatcher(null);
		m.replay();

		var b:BehaviourMock = new BehaviourMock(this);
		b.getLastMethodBehaviour();
		b.setGetLastMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setArgumentsMatcher(null);
	}
	
	public function testSetArgumentsMatcherWithRealArgument(Void):Void {
		var a:ArgumentsMatcher = new ArgumentsMatcher();
		
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.setArgumentsMatcher(a);
		m.replay();

		var b:BehaviourMock = new BehaviourMock(this);
		b.getLastMethodBehaviour();
		b.setGetLastMethodBehaviourReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setArgumentsMatcher(a);
	}
	
	public function testVerify(Void):Void {
		var s:RecordState = new RecordState(new Behaviour());
		try {
			s.verify(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
	}
	
}