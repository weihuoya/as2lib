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
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.io.conn.local.client.LocalClientServiceProxyFactory;
import org.as2lib.io.conn.core.client.ClientServiceProxyFactory;
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.io.conn.local.client.TLocalClientServiceProxyFactory extends TestCase {
	
	public function testGetClientServiceProxyByUrlWithNullUrl(Void):Void {
		var pc:MockControl = new MockControl(ClientServiceProxy);
		var p:ClientServiceProxy = pc.getMock();
		pc.replay();
		
		var sfc:MockControl = new MockControl(ClientServiceProxyFactory);
		var sf:ClientServiceProxyFactory = sfc.getMock();
		sf.getClientServiceProxy(null);
		sfc.setReturnValue(p);
		sfc.replay();
		
		var f:LocalClientServiceProxyFactory = new LocalClientServiceProxyFactory();
		f.setClientServiceProxyFactory(sf);
		assertSame(f.getClientServiceProxyByUrl(null), p);
		
		pc.verify();
		sfc.verify();
	}
	
	public function testGetClientServiceProxyByUrlWithUrl(Void):Void {
		var pc:MockControl = new MockControl(ClientServiceProxy);
		var p:ClientServiceProxy = pc.getMock();
		pc.replay();
		
		var sfc:MockControl = new MockControl(ClientServiceProxyFactory);
		var sf:ClientServiceProxyFactory = sfc.getMock();
		sf.getClientServiceProxy("local.as2lib.org/myService");
		sfc.setReturnValue(p);
		sfc.replay();
		
		var f:LocalClientServiceProxyFactory = new LocalClientServiceProxyFactory();
		f.setClientServiceProxyFactory(sf);
		assertSame(f.getClientServiceProxyByUrl("local.as2lib.org/myService"), p);
		
		pc.verify();
		sfc.verify();
	}
	
	public function testGetClientServiceProxyByUrlAndTypeWithNullType(Void):Void {
		var tc:MockControl = new MockControl(ProxyFactory);
		var t:ProxyFactory = tc.getMock();
		tc.replay();
		
		var pc:MockControl = new MockControl(ClientServiceProxy);
		var p:ClientServiceProxy = pc.getMock();
		pc.replay();
		
		var sfc:MockControl = new MockControl(ClientServiceProxyFactory);
		var sf:ClientServiceProxyFactory = sfc.getMock();
		sf.getClientServiceProxy("local.as2lib.org/myService");
		sfc.setReturnValue(p);
		sfc.replay();
		
		var f:LocalClientServiceProxyFactory = new LocalClientServiceProxyFactory();
		f.setClientServiceProxyFactory(sf);
		f.setTypeProxyFactory(t);
		assertSame(f.getClientServiceProxyByUrlAndType("local.as2lib.org/myService", null), p);
		
		pc.verify();
		sfc.verify();
		tc.verify();
	}
	
	public function testGetClientServiceProxyByUrlAndTypeWithNullTypeAndNullUrl(Void):Void {
		var tc:MockControl = new MockControl(ProxyFactory);
		var t:ProxyFactory = tc.getMock();
		tc.replay();
		
		var pc:MockControl = new MockControl(ClientServiceProxy);
		var p:ClientServiceProxy = pc.getMock();
		pc.replay();
		
		var sfc:MockControl = new MockControl(ClientServiceProxyFactory);
		var sf:ClientServiceProxyFactory = sfc.getMock();
		sf.getClientServiceProxy(null);
		sfc.setReturnValue(p);
		sfc.replay();
		
		var f:LocalClientServiceProxyFactory = new LocalClientServiceProxyFactory();
		f.setClientServiceProxyFactory(sf);
		f.setTypeProxyFactory(t);
		assertSame(f.getClientServiceProxyByUrlAndType(null, null), p);
		
		pc.verify();
		sfc.verify();
		tc.verify();
	}
	
	public function testGetClientServiceProxyByUrlAndType(Void):Void {
		var type:Function = function() {};
		var proxy:Object = new Object();
		
		var tc:MockControl = new MockControl(ProxyFactory);
		var t:ProxyFactory = tc.getMock();
		t.createProxy(type, null);
		tc.setReturnValue(proxy);
		tc.setArgumentsMatcher(new TypeArgumentsMatcher([null, InvocationHandler]));
		tc.replay();
		
		var pc:MockControl = new MockControl(ClientServiceProxy);
		var p:ClientServiceProxy = pc.getMock();
		pc.replay();
		
		var sfc:MockControl = new MockControl(ClientServiceProxyFactory);
		var sf:ClientServiceProxyFactory = sfc.getMock();
		sf.getClientServiceProxy("local.as2lib.org/myService");
		sfc.setReturnValue(p);
		sfc.replay();
		
		var f:LocalClientServiceProxyFactory = new LocalClientServiceProxyFactory();
		f.setClientServiceProxyFactory(sf);
		f.setTypeProxyFactory(t);
		assertSame(f.getClientServiceProxyByUrlAndType("local.as2lib.org/myService", type), proxy);
		
		pc.verify();
		sfc.verify();
		tc.verify();
	}
	
	public function testGetClientServiceProxyByUrlAndTypeWithDefaultTypeProxyFactory(Void):Void {
		var Type:Function = function() {};
		var arg3:Object = new Object();
		var c1:MethodInvocationCallback = new MethodInvocationCallback();
		var c2:MethodInvocationCallback = new MethodInvocationCallback();
		
		var pc:MockControl = new MockControl(ClientServiceProxy);
		var p:ClientServiceProxy = pc.getMock();
		p.invokeByNameAndArguments("myMethod", ["arg1", 2, arg3]);
		pc.setReturnValue(c1);
		p.invokeByNameAndArgumentsAndCallback("anotherMethod", [arg3, 2, "arg1"], c2);
		pc.setReturnValue(c2);
		pc.replay();
		
		var sfc:MockControl = new MockControl(ClientServiceProxyFactory);
		var sf:ClientServiceProxyFactory = sfc.getMock();
		sf.getClientServiceProxy("local.as2lib.org/myService");
		sfc.setReturnValue(p);
		sfc.replay();
		
		var f:LocalClientServiceProxyFactory = new LocalClientServiceProxyFactory();
		f.setClientServiceProxyFactory(sf);
		var proxy = f.getClientServiceProxyByUrlAndType("local.as2lib.org/myService", Type);
		assertNotNull("proxy not of expected type", Type(proxy));
		assertSame(proxy.myMethod("arg1", 2, arg3), c1);
		assertSame(proxy.anotherMethod(arg3, 2, "arg1", c2), c2);
		
		pc.verify();
		sfc.verify();
	}
	
}