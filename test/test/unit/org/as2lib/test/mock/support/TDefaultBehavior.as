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
import org.as2lib.test.mock.support.DefaultBehavior;
import org.as2lib.test.mock.MethodCall;
import test.unit.org.as2lib.test.mock.MethodBehaviorFactoryMock;
import test.unit.org.as2lib.test.mock.MethodBehaviorMock;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TDefaultBehavior extends TestCase {
	
	public function testAddMethodBehaviorWithNullMethodBehavior(Void):Void {
		var b:DefaultBehavior = new DefaultBehavior();
		try {
			b.addMethodBehavior("name", null);
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	// TODO /////////////////////////////////
	// Add further addMethodBehavior()-tests. //
	// TODO /////////////////////////////////
	
	public function testVerify(Void):Void {
		var m1:MethodBehaviorMock = new MethodBehaviorMock(this);
		m1.verify();
		m1.replay();
		
		var m2:MethodBehaviorMock = new MethodBehaviorMock(this);
		m2.verify();
		m2.replay();
		
		var m3:MethodBehaviorMock = new MethodBehaviorMock(this);
		m3.verify();
		m3.replay();
		
		var m4:MethodBehaviorMock = new MethodBehaviorMock(this);
		m4.verify();
		m4.replay();
		
		var m5:MethodBehaviorMock = new MethodBehaviorMock(this);
		m5.verify();
		m5.replay();
		
		var m6:MethodBehaviorMock = new MethodBehaviorMock(this);
		m6.verify();
		m6.replay();
		
		var m7:MethodBehaviorMock = new MethodBehaviorMock(this);
		m7.verify();
		m7.replay();
		
		var m8:MethodBehaviorMock = new MethodBehaviorMock(this);
		m8.verify();
		m8.replay();
		
		var m9:MethodBehaviorMock = new MethodBehaviorMock(this);
		m9.verify();
		m9.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.addMethodBehavior("m1", m1);
		b.addMethodBehavior("m1", m2);
		b.addMethodBehavior("m2", m3);
		b.addMethodBehavior("m1", m4);
		b.addMethodBehavior("m3", m5);
		b.addMethodBehavior("m4", m6);
		b.addMethodBehavior("m3", m7);
		b.addMethodBehavior("m3", m8);
		b.addMethodBehavior("m5", m9);
		b.verify();
		
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
	
	public function testCreateMethodBehaviorWithNullArgument(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.replay();
		
		var f:MethodBehaviorFactoryMock = new MethodBehaviorFactoryMock(this);
		f.getMethodBehavior(null);
		f.setGetMethodBehaviorReturnValue(m);
		f.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.setMethodBehaviorFactory(f);
		assertSame(b.createMethodBehavior(null), m);
		
		m.doVerify();
	}
	
	public function testCreateMethodBehaviorWithRealArgument(Void):Void {
		var m:MethodBehaviorMock = new MethodBehaviorMock(this);
		m.replay();
		
		var c:MethodCall = new MethodCall("methodName", []);
		
		var f:MethodBehaviorFactoryMock = new MethodBehaviorFactoryMock(this);
		f.getMethodBehavior(c);
		f.setGetMethodBehaviorReturnValue(m);
		f.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.setMethodBehaviorFactory(f);
		assertSame(b.createMethodBehavior(c), m);
		
		m.doVerify();
	}
	
	public function testGetMethodBehaviorWithNullArgument(Void):Void {
		var b:DefaultBehavior = new DefaultBehavior();
		assertNull(b.getMethodBehavior(null));
	}
	
	public function testGetMethodBehaviorWithNullName(Void):Void {
		var ac1:Object = new Object();
		var ac2:String = "a2"
		
		var m1:MethodBehaviorMock = new MethodBehaviorMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall(null, [ac1, ac2]));
		m1.replay();
		
		var ac3:Object = new Object();
		var ac4:String = "a4"
		
		var m2:MethodBehaviorMock = new MethodBehaviorMock(this);
		m2.getExpectedMethodCall();
		m2.setGetExpectedMethodCallReturnValue(new MethodCall(null, [ac3, ac4]));
		m2.replay();
		
		var m3:MethodBehaviorMock = new MethodBehaviorMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall(null, []));
		m3.replay();
		
		var m4:MethodBehaviorMock = new MethodBehaviorMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("methodName", [ac1, ac2]));
		m4.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.addMethodBehavior(null, m1);
		b.addMethodBehavior(null, m2);
		b.addMethodBehavior(null, m3);
		b.addMethodBehavior(null, m4);
		assertSame(b.getMethodBehavior(new MethodCall(null, [ac3, ac4])), m2);
		assertSame(b.getMethodBehavior(new MethodCall(null, [])), m3);
		assertSame(b.getMethodBehavior(new MethodCall(null, [ac1, ac2])), m1);
		assertSame(b.getMethodBehavior(new MethodCall("methodName", [ac1, ac2])), m4);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviorWithNames(Void):Void {
		var ac1:Object = new Object();
		var ac2:String = "a2"
		
		var m1:MethodBehaviorMock = new MethodBehaviorMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall("c1", [ac1, ac2]));
		m1.replay();
		
		var ac3:Object = new Object();
		var ac4:String = "a4"
		
		var m2:MethodBehaviorMock = new MethodBehaviorMock(this);
		m2.getExpectedMethodCall();
		m2.setGetExpectedMethodCallReturnValue(new MethodCall("c2", [ac3, ac4]));
		m2.replay();
		
		var m3:MethodBehaviorMock = new MethodBehaviorMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall("c3", []));
		m3.replay();
		
		var m4:MethodBehaviorMock = new MethodBehaviorMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("c4", [ac1, ac2]));
		m4.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.addMethodBehavior("c1", m1);
		b.addMethodBehavior("c2", m2);
		b.addMethodBehavior("c3", m3);
		b.addMethodBehavior("c4", m4);
		assertSame(b.getMethodBehavior(new MethodCall("c2", [ac3, ac4])), m2);
		assertSame(b.getMethodBehavior(new MethodCall("c3", [])), m3);
		assertSame(b.getMethodBehavior(new MethodCall("c1", [ac1, ac2])), m1);
		assertSame(b.getMethodBehavior(new MethodCall("c4", [ac1, ac2])), m4);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviorWithNoMatchingBehaviors(Void):Void {
		var ac1:Object = new Object();
		var ac2:String = "a2"
		
		var m1:MethodBehaviorMock = new MethodBehaviorMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall("c1", [ac1, ac2]));
		m1.replay();
		
		var ac3:Object = new Object();
		var ac4:String = "a4"
		
		var m2:MethodBehaviorMock = new MethodBehaviorMock(this);
		m2.replay();
		
		var m3:MethodBehaviorMock = new MethodBehaviorMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall("c3", []));
		m3.replay();
		
		var m4:MethodBehaviorMock = new MethodBehaviorMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("c4", [ac1, ac2]));
		m4.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.addMethodBehavior("c1", m1);
		b.addMethodBehavior("c2", m2);
		b.addMethodBehavior("c3", m3);
		b.addMethodBehavior("c4", m4);
		assertNull("1", b.getMethodBehavior(new MethodCall("c3", [ac3, ac4])));
		assertNull("2", b.getMethodBehavior(new MethodCall("c3", [new Object()])));
		assertNull("3", b.getMethodBehavior(new MethodCall("c1", [ac1, ac2, new Object()])));
		assertNull("4", b.getMethodBehavior(new MethodCall("c4", [ac1])));
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviorWithMultipleMatchingOnes(Void):Void {
		var m1:MethodBehaviorMock = new MethodBehaviorMock(this);
		m1.getExpectedMethodCall();
		m1.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m1.expectsAnotherMethodCall();
		m1.setExpectsAnotherMethodCallReturnValue(true);
		m1.replay();
		
		var m2:MethodBehaviorMock = new MethodBehaviorMock(this);
		m2.getExpectedMethodCall();
		m2.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m2.expectsAnotherMethodCall();
		m2.setExpectsAnotherMethodCallReturnValue(true);
		m2.replay();
		
		var m3:MethodBehaviorMock = new MethodBehaviorMock(this);
		m3.getExpectedMethodCall();
		m3.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m3.expectsAnotherMethodCall();
		m3.setExpectsAnotherMethodCallReturnValue(false);
		m3.replay();
		
		var m4:MethodBehaviorMock = new MethodBehaviorMock(this);
		m4.getExpectedMethodCall();
		m4.setGetExpectedMethodCallReturnValue(new MethodCall("method", []));
		m4.expectsAnotherMethodCall();
		m4.setExpectsAnotherMethodCallReturnValue(true);
		m4.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		b.addMethodBehavior("method", m1);
		b.addMethodBehavior("method", m2);
		b.addMethodBehavior("method", m3);
		b.addMethodBehavior("method", m4);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m1);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m1);
		m1.setExpectsAnotherMethodCallReturnValue(false);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m2);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m2);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m2);
		m2.setExpectsAnotherMethodCallReturnValue(false);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m4);
		m4.setExpectsAnotherMethodCallReturnValue(false);
		assertSame(b.getMethodBehavior(new MethodCall("method", [])), m4);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
	}
	
	public function testGetMethodBehaviorWithoutAddedBehaviors(Void):Void {
		var b:DefaultBehavior = new DefaultBehavior();
		assertNull(b.getMethodBehavior(new MethodCall("methodName", [])));
	}
	
	public function testGetLastMethodBehaviorWithoutAddedBehaviors(Void):Void {
		var b:DefaultBehavior = new DefaultBehavior();
		assertUndefined(b.getLastMethodBehavior());
	}
	
	public function testGetLastMethodBehavior(Void):Void {
		var m1:MethodBehaviorMock = new MethodBehaviorMock(this);
		m1.replay();
		var m2:MethodBehaviorMock = new MethodBehaviorMock(this);
		m2.replay();
		var m3:MethodBehaviorMock = new MethodBehaviorMock(this);
		m3.replay();
		var m4:MethodBehaviorMock = new MethodBehaviorMock(this);
		m4.replay();
		var m5:MethodBehaviorMock = new MethodBehaviorMock(this);
		m5.replay();
		var m6:MethodBehaviorMock = new MethodBehaviorMock(this);
		m6.replay();
		var m7:MethodBehaviorMock = new MethodBehaviorMock(this);
		m7.getExpectedMethodCall();
		m7.setGetExpectedMethodCallReturnValue(null);
		m7.replay();
		
		var b:DefaultBehavior = new DefaultBehavior();
		assertUndefined(b.getLastMethodBehavior());
		b.addMethodBehavior("methodName", m1);
		assertSame("1", b.getLastMethodBehavior(), m1);
		b.addMethodBehavior("methodName", m2);
		assertSame("2", b.getLastMethodBehavior(), m2);
		b.addMethodBehavior("anotherMethodName", m3);
		assertSame("3", b.getLastMethodBehavior(), m3);
		b.addMethodBehavior("methodName", m4);
		assertSame("4", b.getLastMethodBehavior(), m4);
		b.addMethodBehavior("thirdMethodName", m5);
		assertSame("5", b.getLastMethodBehavior(), m5);
		b.addMethodBehavior("anotherMethodName", m6);
		assertSame("6", b.getLastMethodBehavior(), m6);
		b.addMethodBehavior(null, m7);
		assertSame("7", b.getLastMethodBehavior(), m7);
		
		m1.doVerify();
		m2.doVerify();
		m3.doVerify();
		m4.doVerify();
		m5.doVerify();
		m6.doVerify();
		m7.doVerify();
	}
	
}