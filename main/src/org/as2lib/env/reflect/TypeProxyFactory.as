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
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;

/**
 * TypeProxyFactory can be used to create proxies of types, that means
 * classes or interfaces.
 *
 * <p>If you know that you only need interface proxies you chould think
 * about using InterfaceProxyFactory because it offers higher performance.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TypeProxyFactory extends BasicClass implements ProxyFactory {
	
	/**
	 * Creates proxies for types, that means classes and interfaces.
	 *
	 * <p>You can cast the returned proxy to the passed-in type.
	 *
	 * <p>Null gets returned if you pass-in a typ of value null or undefined.
	 *
	 * <p>The proxy catches method invocations by creating proxy methods for
	 * every method of the type that forward the invocations to the handler.
	 * Unknown, that means not defined methods get catched by using __resolve.
	 *
	 * <p>Note that also methods that are not declared on the type but
	 * get invoked on the proxy, get forwarded to the handler.
	 *
	 * @param type the type to create the proxy for
	 * @param handler the handler to invoke on proxy method invocations
	 * @return the created type proxy
	 * @see ProxyFactory#createProxy(Function, InvocationHandler)
	 */
	public function createProxy(type:Function, handler:InvocationHandler) {
		if (!type) return null;
		var result:Object = new Object();
		result.__proto__ = type.prototype;
		var prototype:Object = type.prototype;
		while (prototype != Object.prototype) {
			_global.ASSetPropFlags(prototype, null, 0, true);
			_global.ASSetPropFlags(prototype, ["__proto__", "constructor", "__constructor__", "prototype"], 1, true);
			for (var i:String in prototype) {
				if (typeof(prototype[i]) == "function") {
					result[i] = function() {
						return handler.invoke(this, arguments.callee.methodName, arguments);
					};
					result[i].methodName = i;
				}
			}
			prototype = prototype.__proto__;
		}
		result.__resolve = function(methodName:String):Function {
			return (function() {
				return handler.invoke(this, methodName, arguments);
			});
		}
		return result;
	}
	
}