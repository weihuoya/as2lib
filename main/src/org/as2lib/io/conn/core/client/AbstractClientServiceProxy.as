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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * Offers default implementations of some methods needed when implemnting
 * the ClientServiceProxy interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.client.AbstractClientServiceProxy extends BasicClass {
	
	/**
	 * Generates the response url for a service.
	 *
	 * <p>The response url gets composed as follows:
	 * [serviceUrl]_[methodName]_Return
	 *
	 * <p>If the methodName is null, undefined or an empty string it will
	 * be composed as follows:
	 * [serviceUrl]_Return
	 *
	 * @param serviceUrl the url to the service
	 * @param methodName the responsing method
	 * @return the generated response url
	 * @throws IllegalArgumentException if the passed-in service url is null, undefined or an empty stirng
	 */
	public static function generateResponseServiceUrl(serviceUrl:String, methodName:String):String {
		if (!serviceUrl) throw new IllegalArgumentException("Service url must not be null, undefined or an empty string.");
		if (!methodName) return serviceUrl + "_Return";
		return serviceUrl + "_" + methodName + "_Return";
	}
	
	/**
	 * Private constructor.
	 */
	private function AbstractClientServiceProxy(Void) {
	}
	
	/**
	 * @overload #invokeByName(String):MethodInvocationCallback
	 * @overload #invokeByNameAndArguments(String, Array):MethodInvocationCallback
	 * @overload #invokeByNameAndCallback(String, MethodInvocationCallback):MethodInvocationCallback
	 * @overload #invokeByNameAndArgumentsAndCallback(String, Array, MethodInvocationCallback):MethodInvocationCallback
	 * @see ClientServiceProxy#invoke():MethodInvocationCallback
	 */
	public function invoke():MethodInvocationCallback {
		var o:Overload = new Overload(this);
		o.addHandler([String], invokeByName);
		o.addHandler([String, Array], this["invokeByNameAndArguments"]);
		o.addHandler([String, MethodInvocationCallback], invokeByNameAndCallback);
		o.addHandler([String, Array, MethodInvocationCallback], this["invokeByNameAndArgumentsAndCallback"]);
		return o.forward(arguments);
	}
	
	/**
	 * Forwards to the invokeByNameAndArguments-method passing an empty
	 * argumetns array.
	 *
	 * @see ClientServiceProxy#invokeByName(String):MethodInvocationCallback
	 */
	public function invokeByName(methodName:String):MethodInvocationCallback {
		return this["invokeByNameAndArguments"](methodName, []);
	}
	
	/**
	 * Forwards to the invokeByNameAndArgumentsAndCallback-method passing an
	 * empty argumetns array.
	 *
	 * @see ClientServiceProxy#invokeByNameAndCallback(String, MethodInvocationCallback):MethodInvocationCallback
	 */
	public function invokeByNameAndCallback(methodName:String, callback:MethodInvocationCallback):MethodInvocationCallback {
		return this["invokeByNameAndArgumentsAndCallback"](methodName, [], callback);
	}
	
}