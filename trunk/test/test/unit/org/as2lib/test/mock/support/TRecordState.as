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
import org.as2lib.test.mock.Behavior;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;
import test.unit.org.as2lib.test.mock.BehaviorMock;
import test.unit.org.as2lib.test.mock.MethodBehaviorMock;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TRecordState extends TestCase {
	
	private function getBlankBehavior(Void):Behavior {
		var result = new Object();
		result.__proto__ = Behavior["prototype"];
		return result;
	}
	
	private function getBlankArgumentsMatcher(Void):ArgumentsMatcher {
		var result = new Object();
		result.__proto__ = ArgumentsMatcher["prototype"];
		return result;
	}
	
	public function testNewWithNullArgument(Void):Void {
		try {
			var s:RecordState = new RecordState(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithRealArgument(Void):Void {
		var b:Behavior = getBlankBehavior();
		var s:RecordState = new RecordState(b);
		assertSame(s.getBehavior(), b);
	}
	
	public function testInvokeMethodWithNullArgument(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.replay();
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.createMethodBehavior(null);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior(undefined, m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(null);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithRealArgument(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall("methodName", []);
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.createMethodBehavior(c);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior("methodName", m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(c);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithNullReturningMethodCallGetMethodNameMethod(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall(null, []);
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.createMethodBehavior(c);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior(null, m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(c);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testInvokeMethodWithEmptyStringReturningMethodCallGetMethodNameMethod(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall("", []);
		
		var b:BehaviorMock = new BehaviorMock(this);
		b.createMethodBehavior(c);
		b.setCreateMethodBehaviorReturnValue(m);
		b.addMethodBehavior("", m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.invokeMethod(c);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetMethodResponseWithNullMethodResponse(Void):Void {
		var r:MethodCallRange = new MethodCallRange();
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addMethodResponse(null, r);
		m.replay();

		var b:BehaviorMock = new BehaviorMock(this);
		b.getLastMethodBehavior();
		b.setGetLastMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setMethodResponse(null, r);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetMethodResponseWithNullMethodCallRange(Void):Void {
		var r:MethodResponse = new MethodResponse();
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addMethodResponse(r, null);
		m.replay();

		var b:BehaviorMock = new BehaviorMock(this);
		b.getLastMethodBehavior();
		b.setGetLastMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setMethodResponse(r, null);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetMethodResponseWithRealArguments(Void):Void {
		var r:MethodResponse = new MethodResponse();
		var cr:MethodCallRange = new MethodCallRange();
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.addMethodResponse(r, cr);
		m.replay();

		var b:BehaviorMock = new BehaviorMock(this);
		b.getLastMethodBehavior();
		b.setGetLastMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setMethodResponse(r, cr);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetArgumentsMatcherWithNullArgument(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.setArgumentsMatcher(null);
		m.replay();

		var b:BehaviorMock = new BehaviorMock(this);
		b.getLastMethodBehavior();
		b.setGetLastMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setArgumentsMatcher(null);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testSetArgumentsMatcherWithRealArgument(Void):Void {
		var a:ArgumentsMatcher = getBlankArgumentsMatcher();
		
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.setArgumentsMatcher(a);
		m.replay();

		var b:BehaviorMock = new BehaviorMock(this);
		b.getLastMethodBehavior();
		b.setGetLastMethodBehaviorReturnValue(m);
		b.replay();
		
		var s:RecordState = new RecordState(b);
		s.setArgumentsMatcher(a);
		
		b.doVerify();
		m.doVerify();
	}
	
	public function testVerify(Void):Void {
		var s:RecordState = new RecordState(getBlankBehavior());
		try {
			s.verify();
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
	}
	
}