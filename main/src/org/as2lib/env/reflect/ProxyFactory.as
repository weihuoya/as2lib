﻿/*
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
import org.as2lib.env.reflect.InvocationHandler;

/**
 * ProxyFactory offers the functionality to create dynamic proxies, that
 * means at run-time, of specific types, that are classes or interfaces.
 *
 * <p>Methods that get invoked on the returned proxy are forwared to an
 * invocation handler that is responsible to respond appropriately to the
 * method invocation.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.ProxyFactory extends BasicInterface {
	
	/**
	 * Creates a proxy for the given type and delegates method invocations
	 * to the {@link InvocationHandler#invoke} method.
	 *
	 * <p>Types are classes or interfaces.
	 *
	 * <p>The returned proxy can be casted to the passed-in type.
	 *
	 * @param type the type to create a proxy for
	 * @param handler the handler to call the invoke method on method invocations on the proxy
	 * @return a proxy for the given type
	 */
	public function createProxy(type:Function, handler:InvocationHandler);
	
}