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
import org.as2lib.test.mock.support.DefaultBehaviour;
import org.as2lib.test.mock.MethodCall;
import test.unit.org.as2lib.test.mock.MethodBehaviourFactoryMock;
import test.unit.org.as2lib.test.mock.MethodBehaviourMock;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TDefaultBehaviour extends TestCase {
	
	public function testAddMethodBehaviourWithNullMethodBehaviour(Void):Void {
		var b:DefaultBehaviour = new DefaultBehaviour();
		try {
			b.addMethodBehaviour("name", null);
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	// TODO /////////////////////////////////
	// Add further addMethodBehaviour()-tests. //
	// TODO /////////////////////////////////
	
	public function testVerify(Void):Void {
		var m1:MethodBehaviourMock = new MethodBehaviourMock(this);
		m1.verify(this);
		m1.replay();
		
		var m2:MethodBehaviourMock = new MethodBehaviourMock(this);
		m2.verify(this);
		m2.replay();
		
		var m3:MethodBehaviourMock = new MethodBehaviourMock(this);
		m3.verify(this);
		m3.replay();
		
		var m4:MethodBehaviourMock = new MethodBehaviourMock(this);
		m4.verify(this);
		m4.replay();
		
		var m5:MethodBehaviourMock = new MethodBehaviourMock(this);
		m5.verify(this);
		m5.replay();
		
		var m6:MethodBehaviourMock = new MethodBehaviourMock(this);
		m6.verify(this);
		m6.replay();
		
		var m7:MethodBehaviourMock = new MethodBehaviourMock(this);
		m7.verify(this);
		m7.replay();
		
		var m8:MethodBehaviourMock = new MethodBehaviourMock(this);
		m8.verify(this);
		m8.replay();
		
		var m9:MethodBehaviourMock = new MethodBehaviourMock(this);
		m9.verify(this);
		m9.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.addMethodBehaviour("m1", m1);
		b.addMethodBehaviour("m1", m2);
		b.addMethodBehaviour("m2", m3);
		b.addMethodBehaviour("m1", m4);
		b.addMethodBehaviour("m3", m5);
		b.addMethodBehaviour("m4", m6);
		b.addMethodBehaviour("m3", m7);
		b.addMethodBehaviour("m3", m8);
		b.addMethodBehaviour("m5", m9);
		b.verify(this);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
		m5.doVerify();
		m6.doVerify();
		m7.doVerify();
		m8.doVerify();
		m9.doVerify();
	}
	
	public function testCreateMethodBehaviourWithNullArgument(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.replay();
		
		var f:MethodBehaviourFactoryMock = new MethodBehaviourFactoryMock(this);
		f.getMethodBehaviour(null);
		f.setGetMethodBehaviourReturnValue(m);
		f.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.setMethodBehaviourFactory(f);
		assertSame(b.createMethodBehaviour(null), m);
		
		m.doVerify();
	}
	
	public function testCreateMethodBehaviourWithRealArgument(Void):Void {
		var m:MethodBehaviourMock = new MethodBehaviourMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall("methodName", []);
		
		var f:MethodBehaviourFactoryMock = new MethodBehaviourFactoryMock(this);
		f.getMethodBehaviour(c);
		f.setGetMethodBehaviourReturnValue(m);
		f.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.setMethodBehaviourFactory(f);
		assertSame(b.createMethodBehaviour(c), m);
		
		m.doVerify();
	}
	
	public function testGetMethodBehaviourWithNullArgument(Void):Void {
		var b:DefaultBehaviour = new DefaultBehaviour();
		assertNull(b.getMethodBehaviour(null));
	}
	
	public function testGetMethodBehaviourWithNullName(Void):Void {
		var ac1:Object = new Object();
		var ac2:String = "a2"
		
		var m1:MethodBehaviourMock = new MethodBehaviourMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall(null, [ac1, ac2]));
		m1.replay();
		
		var ac3:Object = new Object();
		var ac4:String = "a4"
		
		var m2:MethodBehaviourMock = new MethodBehaviourMock(this);
		m2.getExpectedMethodCall();
		m2.setGetExpectedMethodCallReturnValue(new MethodCall(null, [ac3, ac4]));
		m2.replay();
		
		var m3:MethodBehaviourMock = new MethodBehaviourMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall(null, []));
		m3.replay();
		
		var m4:MethodBehaviourMock = new MethodBehaviourMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("methodName", [ac1, ac2]));
		m4.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.addMethodBehaviour(null, m1);
		b.addMethodBehaviour(null, m2);
		b.addMethodBehaviour(null, m3);
		b.addMethodBehaviour(null, m4);
		assertSame(b.getMethodBehaviour(new MethodCall(null, [ac3, ac4])), m2);
		assertSame(b.getMethodBehaviour(new MethodCall(null, [])), m3);
		assertSame(b.getMethodBehaviour(new MethodCall(null, [ac1, ac2])), m1);
		assertSame(b.getMethodBehaviour(new MethodCall("methodName", [ac1, ac2])), m4);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviourWithNames(Void):Void {
		var ac1:Object = new Object();
		var ac2:String = "a2"
		
		var m1:MethodBehaviourMock = new MethodBehaviourMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall("c1", [ac1, ac2]));
		m1.replay();
		
		var ac3:Object = new Object();
		var ac4:String = "a4"
		
		var m2:MethodBehaviourMock = new MethodBehaviourMock(this);
		m2.getExpectedMethodCall();
		m2.setGetExpectedMethodCallReturnValue(new MethodCall("c2", [ac3, ac4]));
		m2.replay();
		
		var m3:MethodBehaviourMock = new MethodBehaviourMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall("c3", []));
		m3.replay();
		
		var m4:MethodBehaviourMock = new MethodBehaviourMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("c4", [ac1, ac2]));
		m4.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.addMethodBehaviour("c1", m1);
		b.addMethodBehaviour("c2", m2);
		b.addMethodBehaviour("c3", m3);
		b.addMethodBehaviour("c4", m4);
		assertSame(b.getMethodBehaviour(new MethodCall("c2", [ac3, ac4])), m2);
		assertSame(b.getMethodBehaviour(new MethodCall("c3", [])), m3);
		assertSame(b.getMethodBehaviour(new MethodCall("c1", [ac1, ac2])), m1);
		assertSame(b.getMethodBehaviour(new MethodCall("c4", [ac1, ac2])), m4);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviourWithNoMatchingBehaviours(Void):Void {
		var ac1:Object = new Object();
		var ac2:String = "a2"
		
		var m1:MethodBehaviourMock = new MethodBehaviourMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall("c1", [ac1, ac2]));
		m1.replay();
		
		var ac3:Object = new Object();
		var ac4:String = "a4"
		
		var m2:MethodBehaviourMock = new MethodBehaviourMock(this);
		m2.replay();
		
		var m3:MethodBehaviourMock = new MethodBehaviourMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall("c3", []));
		m3.replay();
		
		var m4:MethodBehaviourMock = new MethodBehaviourMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("c4", [ac1, ac2]));
		m4.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.addMethodBehaviour("c1", m1);
		b.addMethodBehaviour("c2", m2);
		b.addMethodBehaviour("c3", m3);
		b.addMethodBehaviour("c4", m4);
		assertNull("1", b.getMethodBehaviour(new MethodCall("c3", [ac3, ac4])));
		assertNull("2", b.getMethodBehaviour(new MethodCall("c3", [new Object()])));
		assertNull("3", b.getMethodBehaviour(new MethodCall("c1", [ac1, ac2, new Object()])));
		assertNull("4", b.getMethodBehaviour(new MethodCall("c4", [ac1])));
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviourWithMultipleMatchingOnes(Void):Void {
		var m1:MethodBehaviourMock = new MethodBehaviourMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m1.expectsAnotherMethodCall();
		m1.setExpectsAnotherMethodCallReturnValue(true);
		m1.replay();
		
		var m2:MethodBehaviourMock = new MethodBehaviourMock(this);
		m2.getExpectedMethodCall();
		m2.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m2.expectsAnotherMethodCall();
		m2.setExpectsAnotherMethodCallReturnValue(true);
		m2.replay();
		
		var m3:MethodBehaviourMock = new MethodBehaviourMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m3.expectsAnotherMethodCall();
		m3.setExpectsAnotherMethodCallReturnValue(false);
		m3.replay();
		
		var m4:MethodBehaviourMock = new MethodBehaviourMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m4.expectsAnotherMethodCall();
		m4.setExpectsAnotherMethodCallReturnValue(true);
		m4.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		b.addMethodBehaviour("method", m1);
		b.addMethodBehaviour("method", m2);
		b.addMethodBehaviour("method", m3);
		b.addMethodBehaviour("method", m4);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m1);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m1);
		m1.setExpectsAnotherMethodCallReturnValue(false);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m2);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m2);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m2);
		m2.setExpectsAnotherMethodCallReturnValue(false);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m4);
		m4.setExpectsAnotherMethodCallReturnValue(false);
		assertSame(b.getMethodBehaviour(new MethodCall("method", [])), m4);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviourWithoutAddedBehaviours(Void):Void {
		var b:DefaultBehaviour = new DefaultBehaviour();
		assertNull(b.getMethodBehaviour(new MethodCall("methodName", [])));
	}
	
	public function testGetLastMethodBehaviourWithoutAddedBehaviours(Void):Void {
		var b:DefaultBehaviour = new DefaultBehaviour();
		assertUndefined(b.getLastMethodBehaviour());
	}
	
	public function testGetLastMethodBehaviour(Void):Void {
		var m1:MethodBehaviourMock = new MethodBehaviourMock(this);
		m1.replay();
		var m2:MethodBehaviourMock = new MethodBehaviourMock(this);
		m2.replay();
		var m3:MethodBehaviourMock = new MethodBehaviourMock(this);
		m3.replay();
		var m4:MethodBehaviourMock = new MethodBehaviourMock(this);
		m4.replay();
		var m5:MethodBehaviourMock = new MethodBehaviourMock(this);
		m5.replay();
		var m6:MethodBehaviourMock = new MethodBehaviourMock(this);
		m6.replay();
		var m7:MethodBehaviourMock = new MethodBehaviourMock(this);
		m7.getExpectedMethodCall();
		m7.setGetExpectedMethodCallReturnValue(null);
		m7.replay();
		
		var b:DefaultBehaviour = new DefaultBehaviour();
		assertUndefined(b.getLastMethodBehaviour());
		b.addMethodBehaviour("methodName", m1);
		assertSame("1", b.getLastMethodBehaviour(), m1);
		b.addMethodBehaviour("methodName", m2);
		assertSame("2", b.getLastMethodBehaviour(), m2);
		b.addMethodBehaviour("anotherMethodName", m3);
		assertSame("3", b.getLastMethodBehaviour(), m3);
		b.addMethodBehaviour("methodName", m4);
		assertSame("4", b.getLastMethodBehaviour(), m4);
		b.addMethodBehaviour("thirdMethodName", m5);
		assertSame("5", b.getLastMethodBehaviour(), m5);
		b.addMethodBehaviour("anotherMethodName", m6);
		assertSame("6", b.getLastMethodBehaviour(), m6);
		b.addMethodBehaviour(null, m7);
		assertSame("7", b.getLastMethodBehaviour(), m7);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
		m5.doVerify();
		m6.doVerify();
		m7.doVerify();
	}
	
}