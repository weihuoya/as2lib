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

import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.client.ClientServiceProxyFactory;
import org.as2lib.io.conn.core.client.AbstractClientServiceProxyFactory;
import org.as2lib.io.conn.local.client.LocalClientServiceProxy;

/**
 * SimpleClientServiceProxyFactory is the simplest implementation of
 * a client service proxy factory.
 *
 * <p>It allows only for the getClientServiceProxyByUrl(String):ClientServiceProxy 
 * method to be used and not for the getClientServiceProxyByUrlAndType(String, Function)
 * method.
 * <code>
 * var clientFactory:SimpleClientServiceProxyFactory = new SimpleClientServiceProxyFactory();
 * var client:ClientServiceProxy = clientFactory.getClientServiceProxy("local.as2lib.org/myService");
 * </code>
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.client.SimpleClientServiceProxyFactory extends AbstractClientServiceProxyFactory implements ClientServiceProxyFactory {
	
	/**
	 * Constructs a new SimpleClientServiceProxyFactory instance.
	 */
	public function SimpleClientServiceProxyFactory(Void) {
	}
	
	/**
	 * Returns a client service proxy for the service specified by the url.
	 *
	 * <p>You can use this proxy to invoke methods on the 'remote' service
	 * and to handle responses.
	 *
	 * @param url the url of teh 'remote' service
	 * @return a client service proxy used to call methods on the 'remote' service
	 * @see ClientServiceProxyFactory#getClientServiceProxyByUrl(String):ClientServiceProxy
	 */
	public function getClientServiceProxyByUrl(url:String):ClientServiceProxy {
		return new LocalClientServiceProxy(url);
	}
	
}