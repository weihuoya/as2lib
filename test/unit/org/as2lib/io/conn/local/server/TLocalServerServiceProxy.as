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
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.io.conn.local.server.LocalServerServiceProxy;
import org.as2lib.io.conn.local.core.EnhancedLocalConnection;

/**
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.server.TLocalServerServiceProxy extends TestCase {
	
	public function testNewWithNullPath(Void):Void {
		try {
			new LocalServerServiceProxy(null, new Object());
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithEmptyStringPath(Void):Void {
		try {
			new LocalServerServiceProxy("", new Object());
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithNullService(Void):Void {
		try {
			new LocalServerServiceProxy("myPath", null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNew(Void):Void {
		var service:Object = new Object();
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", service);
		assertSame(p.getPath(), "myPath");
		assertSame(p.getService(), service);
		assertFalse(p.isRunning());
	}
	
	public function testRunWithNullHost(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.connect("myPath");
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		p.run(null);
		assertTrue(p.isRunning());
		
		cc.verify();
	}
	
	public function testRunWithEmptyStringHost(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.connect("myPath");
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		p.run("");
		assertTrue(p.isRunning());
		
		cc.verify();
	}
	
	public function testRunWithHost(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.connect("local.as2lib.org/myPath");
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		p.run("local.as2lib.org");
		assertTrue(p.isRunning());
		
		cc.verify();
	}
	
	public function testRunWithAlreadyRunningServiceProxy(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.connect("local.as2lib.org/myPath");
		c.close();
		c.connect("local.simonwacker.com/myPath");
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		p.run("local.as2lib.org");
		assertTrue(p.isRunning());
		p.run("local.simonwacker.com");
		assertTrue(p.isRunning());
		
		cc.verify();
	}
	
	public function testRunWithReservedService(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.connect("local.as2lib.org/myPath");
		cc.setThrowable(new org.as2lib.io.conn.local.core.ReservedConnectionException("message ;)"));
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		try {
			p.run("local.as2lib.org");
			fail("Expected ReservedServiceException.");
		} catch (e:org.as2lib.io.conn.core.server.ReservedServiceException) {
		}
		
		cc.verify();
	}
	
	public function testStopWithNotRunningServiceProxy(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.close();
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		p.stop();
		assertFalse(p.isRunning());
		
		cc.verify();
	}
	
	public function testStopWithRunningServiceProxy(Void):Void {
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.connect("local.as2lib.org/myPath");
		c.close();
		cc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", new Object());
		p.setConnection(c);
		p.run("local.as2lib.org");
		p.stop();
		assertFalse(p.isRunning());
		
		cc.verify();
	}
	
	public function getService(Void):Function {
		var service:Function = function() {};
		service.prototype.method = function() {};
		return service;
	}
	
	public function testInvokeMethodByNameAndArgumentsWithNullName(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArguments(null, []);
		
		bc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsWithEmptyStringName(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArguments("", []);
		
		bc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsWithUnknownMethod(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArguments("unknownMethod", []);
		
		bc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsWithKnownMethodAndArguments(Void):Void {
		var arg3:Object = new Object();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method("arg1", 2, arg3);
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArguments("method", ["arg1", 2, arg3]);
		
		bc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsWithKnownMethodButWithNullArguments(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArguments("method", null);
		
		bc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsWithExceptionThrowingMethod(Void):Void {
		var arg3:Object = new Object();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method("arg1", 2, arg3);
		sc.setThrowable(new Error("throwable"));
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArguments("method", ["arg1", 2, arg3]);
		
		bc.verify();
		sc.verify();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithNullResponseService(Void):Void {
		var arg3:Object = new Object();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method("a1", 2, arg3);
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s, null);
		p.setErrorBroadcaster(b);
		p.invokeMethodByNameAndArgumentsAndResponseService("method", ["a1", 2, arg3]);
		
		bc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithNullName(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onError", null, null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService(null, [], "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithEmptyStringName(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onError", null, null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("", [], "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithUnknownMethod(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onError", null, null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("unknownMethod", [], "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithKnownMethodAndArgumentsAndReturnValue(Void):Void {
		var returnValue:Object = new Object();
		var arg3:Object = new Object();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onReturn", null, null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method("arg1", 2, arg3);
		sc.setReturnValue(returnValue);
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("method", ["arg1", 2, arg3], "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithKnownMethodButWithNullArguments(Void):Void {
		var returnValue:Object = new Object();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onReturn", null, null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method();
		sc.setReturnValue(returnValue);
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("method", null, "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithExceptionThrowingMethod(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onError", null, null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method();
		sc.setThrowable(new Error("throwable"));
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("method", [], "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithUnknownResponseService(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("unknownResponseService", "onReturn", null, null);
		cc.setThrowable(new org.as2lib.io.conn.local.core.UnknownConnectionException("unknown connection exception"));
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("method", [], "unknownResponseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
	public function testInvokeMethodByNameAndArgumentsAndResponseServiceWithOversizedArguments(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([MethodInvocationErrorInfo]));
		bc.replay();
		
		var cc:MockControl = new MockControl(EnhancedLocalConnection);
		var c:EnhancedLocalConnection = cc.getMock();
		c.send("responseService", "onReturn", null, null);
		cc.setThrowable(new org.as2lib.io.conn.core.client.MethodInvocationException("method invocation exception"));
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([null, null, Array, MethodInvocationErrorListener]));
		cc.replay();
		
		var sc:MockControl = new MockControl(getService());
		var s = sc.getMock();
		s.method();
		sc.replay();
		
		var p:LocalServerServiceProxy = new LocalServerServiceProxy("myPath", s);
		p.setErrorBroadcaster(b);
		p.setConnection(c);
		p.invokeMethodByNameAndArgumentsAndResponseService("method", [], "responseService");
		
		bc.verify();
		cc.verify();
		sc.verify();
	}
	
}