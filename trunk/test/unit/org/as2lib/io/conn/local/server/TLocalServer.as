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
import org.as2lib.io.conn.local.server.LocalServer;
import org.as2lib.io.conn.core.server.ServerRegistry;
import org.as2lib.io.conn.core.server.ServerServiceProxy;

/**
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.server.TLocalServer extends TestCase {
	
	public function testNewWithNullHost(Void):Void {
		try {
			new LocalServer(null);
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithBlankStringHost(Void):Void {
		try {
			new LocalServer("");
			fail("Expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNew(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertSame(s.getHost(), "local.as2lib.org");
		assertFalse(s.isRunning());
	}
	
	public function testRunWithNotRunningServer(Void):Void {
		var rc:MockControl = new MockControl(ServerRegistry);
		var r:ServerRegistry = rc.getMock();
		r.registerServer("local.as2lib.org");
		rc.replay();
		
		var p1c:MockControl = new MockControl(ServerServiceProxy);
		var p1:ServerServiceProxy = p1c.getMock();
		p1.getPath();
		p1c.setReturnValue("myProxy1");
		p1.run("local.as2lib.org");
		p1c.replay();
		
		var p2c:MockControl = new MockControl(ServerServiceProxy);
		var p2:ServerServiceProxy = p2c.getMock();
		p2.getPath();
		p2c.setReturnValue("myProxy2");
		p2.run("local.as2lib.org");
		p2c.replay();
		
		var p3c:MockControl = new MockControl(ServerServiceProxy);
		var p3:ServerServiceProxy = p3c.getMock();
		p3.getPath();
		p3c.setReturnValue("myProxy3");
		p3.run("local.as2lib.org");
		p3c.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.setServerRegistry(r);
		s.addService(p1);
		s.addService(p2);
		s.addService(p3);
		s.run();
		assertTrue(s.isRunning());
		
		rc.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testRunWithRunningServer(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		
		var rc:MockControl = new MockControl(ServerRegistry);
		var r:ServerRegistry = rc.getMock();
		r.registerServer("local.as2lib.org");
		rc.setVoidCallable(2);
		r.containsServer("local.as2lib.org");
		rc.setReturnValue(true);
		r.removeServer("local.as2lib.org");
		rc.replay();
		
		var p1c:MockControl = new MockControl(ServerServiceProxy);
		var p1:ServerServiceProxy = p1c.getMock();
		p1.getPath();
		p1c.setReturnValue("myProxy1");
		p1.run("local.as2lib.org");
		p1c.setVoidCallable(2);
		p1.stop();
		p1c.replay();
		
		var p2c:MockControl = new MockControl(ServerServiceProxy);
		var p2:ServerServiceProxy = p2c.getMock();
		p2.getPath();
		p2c.setReturnValue("myProxy2");
		p2.run("local.as2lib.org");
		p2c.setVoidCallable(2);
		p2.stop();
		p2c.replay();
		
		var p3c:MockControl = new MockControl(ServerServiceProxy);
		var p3:ServerServiceProxy = p3c.getMock();
		p3.getPath();
		p3c.setReturnValue("myProxy3");
		p3.run("local.as2lib.org");
		p3c.setVoidCallable(2);
		p3.stop();
		p3c.replay();
		
		s.setServerRegistry(r);
		s.addService(p1);
		s.addService(p2);
		s.addService(p3);
		s.run();
		assertTrue(s.isRunning());
		s.run();
		assertTrue(s.isRunning());
		
		rc.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testStopWithNotRunningServer(Void):Void {
		var rc:MockControl = new MockControl(ServerRegistry);
		var r:ServerRegistry = rc.getMock();
		r.containsServer("local.as2lib.org");
		rc.setReturnValue(false);
		rc.replay();
		
		var p1c:MockControl = new MockControl(ServerServiceProxy);
		var p1:ServerServiceProxy = p1c.getMock();
		p1.getPath();
		p1c.setReturnValue("myProxy1");
		p1.stop();
		p1c.replay();
		
		var p2c:MockControl = new MockControl(ServerServiceProxy);
		var p2:ServerServiceProxy = p2c.getMock();
		p2.getPath();
		p2c.setReturnValue("myProxy2");
		p2.stop();
		p2c.replay();
		
		var p3c:MockControl = new MockControl(ServerServiceProxy);
		var p3:ServerServiceProxy = p3c.getMock();
		p3.getPath();
		p3c.setReturnValue("myProxy3");
		p3.stop();
		p3c.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.setServerRegistry(r);
		s.addService(p1);
		s.addService(p2);
		s.addService(p3);
		assertFalse(s.isRunning());
		s.stop();
		assertFalse(s.isRunning());
		
		rc.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testStopWithRunningServer(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		
		var rc:MockControl = new MockControl(ServerRegistry);
		var r:ServerRegistry = rc.getMock();
		r.containsServer("local.as2lib.org");
		rc.setReturnValue(true);
		r.registerServer("local.as2lib.org");
		r.removeServer("local.as2lib.org");
		rc.replay();
		
		var p1c:MockControl = new MockControl(ServerServiceProxy);
		var p1:ServerServiceProxy = p1c.getMock();
		p1.getPath();
		p1c.setReturnValue("myProxy1");
		p1.run("local.as2lib.org");
		p1.stop();
		p1c.replay();
		
		var p2c:MockControl = new MockControl(ServerServiceProxy);
		var p2:ServerServiceProxy = p2c.getMock();
		p2.getPath();
		p2c.setReturnValue("myProxy2");
		p2.run("local.as2lib.org");
		p2.stop();
		p2c.replay();
		
		var p3c:MockControl = new MockControl(ServerServiceProxy);
		var p3:ServerServiceProxy = p3c.getMock();
		p3.getPath();
		p3c.setReturnValue("myProxy3");
		p3.run("local.as2lib.org");
		p3.stop();
		p3c.replay();
		
		s.setServerRegistry(r);
		s.addService(p1);
		s.addService(p2);
		s.addService(p3);
		s.run();
		assertTrue(s.isRunning());
		s.stop();
		assertFalse(s.isRunning());
		
		rc.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testAddServiceWtihNullService(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		try {
			s.addService(null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testAddServiceWithNullServicePath(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue(null);
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		try {
			s.addService(p);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		pc.verify();
	}
	
	public function testAddServiceWithBlankStringServicePath(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("");
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		try {
			s.addService(p);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		pc.verify();
	}
	
	public function testAddServiceWithReservedServicePath(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("myService", 2);
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.addService(p);
		try {
			s.addService(p);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		pc.verify();
	}
	
	public function testAddServiceViaGetService(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("myService");
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.addService(p);
		assertSame(s.getService("myService"), p);
		
		pc.verify();
	}
	
	public function testAddServiceWithRunningServer(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("myService");
		p.run("local.as2lib.org");
		p.stop();
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.run();
		s.addService(p);
		assertSame(s.getService("myService"), p);
		s.stop();
		
		pc.verify();
	}
	
	public function testRemoveServiceWithNullServicePath(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertNull(s.removeService(null));
	}
	
	public function testRemoveServiceWithBlankStringServicePath(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertNull(s.removeService(""));
	}
	
	public function testRemoveServiceWithUnknownService(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertUndefined(s.removeService("unknownService"));
	}
	
	public function testRemoveServiceViaAddService(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("myService");
		p.isRunning();
		pc.setReturnValue(false);
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.addService(p);
		assertSame(s.removeService("myService"), p);
		assertUndefined(s.getService("myService"));
		
		pc.verify();
	}
	
	public function testRemoveServiceWithRunningService(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("myService");
		p.isRunning();
		pc.setReturnValue(true);
		p.stop();
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.addService(p);
		assertSame(s.removeService("myService"), p);
		assertUndefined(s.getService("myService"));
		
		pc.verify();
	}
	
	public function testGetServiceWithNullServicePath(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertNull(s.getService(null));
	}
	
	public function testGetServiceWithBlankStringServicePath(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertNull(s.getService(""));
	}
	
	public function testGetServiceWithUnknownService(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertUndefined(s.getService("unknownService"));
	}
	
	public function testGetServiceViaAddService(Void):Void {
		var pc:MockControl = new MockControl(ServerServiceProxy);
		var p:ServerServiceProxy = pc.getMock();
		p.getPath();
		pc.setReturnValue("myService");
		pc.replay();
		
		var s:LocalServer = new LocalServer("local.as2lib.org");
		s.addService(p);
		assertSame(s.getService("myService"), p);
		
		pc.verify();
	}
	
	public function testIsRunning(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertFalse("Default status should be not running.", s.isRunning());
		s.run();
		assertTrue("Server should run now.", s.isRunning());
		s.stop();
		assertFalse("Server shouldn't run anymore.", s.isRunning());
	}
	
	public function testGetHost(Void):Void {
		var s:LocalServer = new LocalServer("local.as2lib.org");
		assertSame(s.getHost(), "local.as2lib.org");
	}
	
}