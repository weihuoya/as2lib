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
import org.as2lib.data.io.conn.core.client.ClientServiceProxy;
import org.as2lib.data.io.conn.core.client.ClientServiceProxyFactory;
import org.as2lib.data.io.conn.local.client.LocalClientServiceProxy;
import org.as2lib.data.io.conn.core.event.MethodInvocationCallback;

/**
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.client.LocalClientServiceProxyFactory extends BasicClass implements ClientServiceProxyFactory {
	
	/**
	 * Constructs a new LocalClientServiceProxyFactory.
	 */
	public function LocalClientServiceProxyFactory(Void) {
	}
	
	/**
	 * @see ClientServiceProxyFactory#getServiceProxy()
	 */
	public function getServiceProxy() {
		var o:Overload = new Overload(this);
		o.addHandler([String], getServiceProxyByUrl);
		o.addHandler([String, Function], getServiceProxyByUrlAndInterface);
		return o.forward(arguments);
	}
	
	/**
	 * @see ClientServiceProxyFactory#getServiceProxyByHostAndService()
	 */
	public function getServiceProxyByUrl(url:String):ClientServiceProxy {
		return new LocalClientServiceProxy(url);
	}
	
	/**
	 * @see ClientServiceProxyFactory#getServiceProxyByHostAndServiceAndInterface()
	 */
	public function getServiceProxyByUrlAndInterface(url:String, interfaze:Function) {
		var result = new (interfaze)();
		var proxy:ClientServiceProxy = new LocalClientServiceProxy(url);
		result.__resolve = function(methodName:String):Function {
			return (function () {
				if (arguments[arguments.length-1] instanceof MethodInvocationCallback) {
					var callback:MethodInvocationCallback = arguments[arguments.length-1];
					proxy.invoke(methodName, arguments, callback);
				} else {
					proxy.invoke(methodName, arguments);
				}
			});
		}
		return result;
	}
	
}