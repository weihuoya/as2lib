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
import org.as2lib.io.conn.local.client.LocalClientServiceProxy;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.io.conn.local.client.TLocalClientServiceProxy extends TestCase {
	
	public function testNewWithNullUrl(Void):Void {
		try {
			new LocalClientServiceProxy(null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithEmptyStringUrl(Void):Void {
		try {
			new LocalClientServiceProxy("");
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithUrl(Void):Void {
		var p:LocalClientServiceProxy = new LocalClientServiceProxy("local.as2lib.org/myService");
		assertSame(p.getUrl(), "local.as2lib.org/myService");
	}
	
	public function testInvokeByNameAndArgumentsAndCallbackWithNullName(Void):Void {
		var p:LocalClientServiceProxy = new LocalClientServiceProxy("local.as2lib.org/myService");
		try {
			p.invokeByNameAndArgumentsAndCallback(null, [], new MethodInvocationCallback());
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testInvokeByNameAndArgumentsAndCallbackWithEmptyStringName(Void):Void {
		var p:LocalClientServiceProxy = new LocalClientServiceProxy("local.as2lib.org/myService");
		try {
			p.invokeByNameAndArgumentsAndCallback("", [], new MethodInvocationCallback());
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
}