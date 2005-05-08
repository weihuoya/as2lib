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
import org.as2lib.io.conn.local.server.LocalServerRegistry;

/**
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.server.TLocalServerRegistry extends TestCase {
	
	public function testRegisterServerWithNullHost(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		try {
			r.registerServer(null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testRegisterServerWithBlankStringHost(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		try {
			r.registerServer("");
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testRegisterServerNormalAndWithReservedHostViaContainsServer(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		r.registerServer("local.as2lib.org");
		assertTrue(r.containsServer("local.as2lib.org"));
		try {
			r.registerServer("local.as2lib.org");
			fail("Expected ReservedHostException");
		} catch (e:org.as2lib.io.conn.core.server.ReservedHostException) {
		}
		assertTrue(r.containsServer("local.as2lib.org"));
		r.removeServer("local.as2lib.org");
	}
	
	public function testRemoveServerWithUnknownHost(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		r.removeServer("local.unknown.org");
	}
	
	public function testRemoveServerWithRegisteredHost(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		r.registerServer("local.as2lib.org");
		assertTrue(r.containsServer("local.as2lib.org"));
		r.removeServer("local.as2lib.org");
		assertFalse(r.containsServer("local.as2lib.org"));
	}
	
	public function testRemoveServerWithNotDirectlyRegisteredServer(Void):Void {
		var r1:LocalServerRegistry = new LocalServerRegistry();
		r1.registerServer("remote.as2lib.org");
		
		var r:LocalServerRegistry = new LocalServerRegistry();
		try {
			r.removeServer("remote.as2lib.org");
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		r1.removeServer("remote.as2lib.org");
	}
	
	public function testContainsServerWithUnknownHost(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		assertFalse(r.containsServer("local.unknown.org"));
	}
	
	public function testContainsServerWithKnownHost(Void):Void {
		var r:LocalServerRegistry = new LocalServerRegistry();
		r.registerServer("local.as2lib.org");
		assertTrue(r.containsServer("local.as2lib.org"));
		r.removeServer("local.as2lib.org");
		assertFalse(r.containsServer("local.as2lib.org"));
	}
	
	public function testContainsServerWithServerThatHasBeenRegisteredInAnotherRegistry(Void):Void {
		var r1:LocalServerRegistry = new LocalServerRegistry();
		r1.registerServer("local.as2lib.org");
		assertTrue(r1.containsServer("local.as2lib.org"));
		
		var r:LocalServerRegistry = new LocalServerRegistry();
		assertTrue(r.containsServer("local.as2lib.org"));
		assertTrue(r.containsServer("local.as2lib.org"));
		
		r1.removeServer("local.as2lib.org");
		assertFalse(r1.containsServer("local.as2lib.org"));
		assertFalse(r.containsServer("local.as2lib.org"));
	}
	
}