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

import org.as2lib.core.BasicInterface;

/**
 * InvocationHandler handles method invocations that took place on dynamic
 * proxies.
 *
 * <p>It is passed all the needed information to respond appropriately
 * to the incovation.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.reflect.ProxyFactory
 */
interface org.as2lib.env.reflect.InvocationHandler extends BasicInterface {
	
	/**
	 * Gets called when a method invocation on a proxy took place.
	 *
	 * @param proxy the proxy the method was called on
	 * @param method the method that was invoked
	 * @param args the arguments that were passed-in on invocation
	 * @return the result of the actual method invocation
	 */
	public function invoke(proxy, method:String, args:Array);
	
}