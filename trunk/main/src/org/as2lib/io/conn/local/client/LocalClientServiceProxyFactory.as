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

import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.ResolveProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.client.ClientServiceProxyFactory;
import org.as2lib.io.conn.core.client.AbstractClientServiceProxyFactory;
import org.as2lib.io.conn.local.client.LocalClientServiceProxy;
import org.as2lib.io.conn.local.client.SimpleClientServiceProxyFactory;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
class org.as2lib.io.conn.local.client.LocalClientServiceProxyFactory extends AbstractClientServiceProxyFactory implements ClientServiceProxyFactory {
	
	/** The currently used proxy factory to create proxies for a specific type. */
	private var typeProxyFactory:ProxyFactory;
	
	/** Stores the client service proxy factory used to get client service proxy instances. */
	private var clientServiceProxyFactory:ClientServiceProxyFactory;
	
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
	public function getTypeProxyFactory(Void):ProxyFactory {
		if (!typeProxyFactory) typeProxyFactory = new ResolveProxyFactory();
		return typeProxyFactory;
	}
	
	/**
	 * Sets the new proxy factory.
	 *
	 * @param proxyFactory the new service proxy factory
	 */
	public function setTypeProxyFactory(typeServiceProxyFactory:ProxyFactory):Void {
		this.typeProxyFactory = typeServiceProxyFactory;
	}
	
	/**
	 * Returns the client service proxy factory used to get client service proxy
	 * instances.
	 *
	 * <p>The returned factory is either the one set via setClientServiceProxyFactory(ClientServiceProxyFactory):Void
	 * or the default one which is an instance of SimpleClientServiceProxyFactory.
	 *
	 * @return the currently used client service proxy factory
	 */
	public function getClientServiceProxyFactory(Void):ClientServiceProxyFactory {
		if (!clientServiceProxyFactory) clientServiceProxyFactory = new SimpleClientServiceProxyFactory();
		return clientServiceProxyFactory;
	}
	
	/**
	 * Sets a new client service proxy factory used to get client service proxy
	 * instances.
	 *
	 * <p>If you set a new factory of value null or undefined getClientServiceProxyFactory(Void):ClientServiceProxyFactory
	 * will return the default factory.
	 *
	 * @param clientServiceProxyFactory the new client service proxy factory
	 */
	public function setClientServiceProxyFactory(clientServiceProxyFactory:ClientServiceProxyFactory):Void {
		this.clientServiceProxyFactory = clientServiceProxyFactory;
	}
	
	/**
	 * @see ClientServiceProxyFactory#getClientServiceProxyByUrl()
	 */
	public function getClientServiceProxyByUrl(url:String):ClientServiceProxy {
		return getClientServiceProxyFactory().getClientServiceProxy(url);
	}
	
	/**
	 * @see ClientServiceProxyFactory#getClientServiceProxyByUrlAndType()
	 */
	public function getClientServiceProxyByUrlAndType(url:String, type:Function) {
		var serviceProxy:ClientServiceProxy = getClientServiceProxyByUrl(url);
		if (!type) return serviceProxy;
		var handler:InvocationHandler = new InvocationHandler();
		handler.invoke = function(proxy, methodName:String, args:FunctionArguments) {
			if (args[args.length-1] instanceof MethodInvocationCallback) {
				var callback:MethodInvocationCallback = MethodInvocationCallback(args.pop());
				return serviceProxy.invokeByNameAndArgumentsAndCallback(methodName, args, callback);
			} else {
				return serviceProxy.invokeByNameAndArguments(methodName, args);
			}
		}
		return getTypeProxyFactory().createProxy(type, handler);
	}
	
}