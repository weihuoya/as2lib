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
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ResolveProxyFactory extends BasicClass implements ProxyFactory {
	
	/**
	 * @see ProxyFactory#createProxy()
	 */
	public function createProxy(type:Function, handler:InvocationHandler) {
		var result:Object = new Object();
		result.__proto__ = type.prototype;
		result.__resolve = function(methodName:String):Function {
			return (function() {
				return handler.invoke(this, methodName, arguments);
			});
		}
		return result;
	}
	
}