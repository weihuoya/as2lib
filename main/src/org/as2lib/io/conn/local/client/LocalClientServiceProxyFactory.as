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
 
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.ResolveProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.client.ClientServiceProxyFactory;
import org.as2lib.io.conn.local.client.LocalClientServiceProxy;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
/**
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.client.LocalClientServiceProxyFactory extends BasicClass implements ClientServiceProxyFactory {
	
	/** The currently used proxy factory. */
	private var proxyFactory:ProxyFactory;
	
	/**
	 * Constructs a new LocalClientServiceProxyFactory.
	 */
	public function LocalClientServiceProxyFactory(Void) {
	}
	
	/**
	 * Returns the proxy factory set via #setServiceProxyFactory() or
	 * the default one.
	 *
	 * @return the currently used service proxy factory
	 */
	public function getServiceProxyFactory(Void):ProxyFactory {
		if (!proxyFactory) proxyFactory = new ResolveProxyFactory();
		return proxyFactory;
	}
	
	/**
	 * Sets the new proxy factory.
	 *
	 * @param proxyFactory the new service proxy factory
	 */
	public function setServiceProxyFactory(proxyFactory:ProxyFactory):Void {
		this.proxyFactory = proxyFactory;
	}
	
	/**
	 * @see ClientServiceProxyFactory#getServiceProxy()
	 */
	public function getServiceProxy() {
		var o:Overload = new Overload(this);
		o.addHandler([String], getServiceProxyByUrl);
		o.addHandler([String, Function], getServiceProxyByUrlAndType);
		return o.forward(arguments);
	}
	
	/**
	 * @see ClientServiceProxyFactory#getServiceProxyByUrl()
	 */
	public function getServiceProxyByUrl(url:String):ClientServiceProxy {
		return new LocalClientServiceProxy(url);
	}
	
	/**
	 * @see ClientServiceProxyFactory#getServiceProxyByUrlAndType()
	 */
	public function getServiceProxyByUrlAndType(url:String, type:Function) {
		var proxy:ClientServiceProxy = new LocalClientServiceProxy(url);
		var handler:InvocationHandler = new InvocationHandler();
		handler.invoke = function(proxy, methodName:String, args:FunctionArguments) {
			if (args[args.length-1] instanceof MethodInvocationCallback) {
				var callback:MethodInvocationCallback = args[args.length-1];
				proxy.invoke(methodName, args, callback);
			} else {
				proxy.invoke(methodName, args);
			}
		}
		return getServiceProxyFactory().createProxy(type, handler);
	}
	
}