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
import org.as2lib.io.conn.local.core.EnhancedLocalConnection;

/**
 * Offers default implementations of some methods needed when implemnting
 * the {@link ClientServiceProxy} interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.client.AbstractClientServiceProxy extends BasicClass {
	
	/**
	 * Generates the response url for a service.
	 *
	 * <p>The response url gets composed as follows:
	 * <pre>[serviceUrl].[methodName]_Return_[index]</pre>
	 *
	 * <p>If the methodName is null, undefined or an empty string it will
	 * be composed as follows:
	 * [serviceUrl]_Return_[index]
	 *
	 * <p>Index is a number from null to infinite depending on how many
	 * responses are pending.
	 *
	 * @param serviceUrl the url to the service
	 * @param methodName the responsing method
	 * @return the generated response url
	 * @throws IllegalArgumentException if the passed-in service url is null, undefined or an empty stirng
	 */
	public static function generateResponseServiceUrl(serviceUrl:String, methodName:String):String {
		if (!serviceUrl) throw new IllegalArgumentException("Service url must not be null, undefined or an empty string.");
		if (!methodName) {
			var result:String = serviceUrl + "_Return";
			var i:Number = 0;
			while (EnhancedLocalConnection.connectionExists(result + "_" + i)) {
				i++;
			}
			return result + "_" + i;
		} else {
			var result:String = serviceUrl + "_" + methodName + "_Return";
			var i:Number = 0;
			while (EnhancedLocalConnection.connectionExists(result + "_" + i)) {
				i++;
			}
			return result + "_" + i;
		}
	}
	
	/**
	 * Private constructor.
	 */
	private function AbstractClientServiceProxy(Void) {
	}
	
	/**
	 * @overload #invokeByName
	 * @overload #invokeByNameAndArguments
	 * @overload #invokeByNameAndCallback
	 * @overload #invokeByNameAndArgumentsAndCallback
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
	 * Invokes the passed-in method on the service.
	 *
	 * <p>The invocation is done by forwardning to the {@link #invokeByNameAndArguments}
	 * method passing an empty arguments array.
	 *
	 * @param methodName the name of the method to invoke
	 * @return a callback that can be used to get informed of the response
	 */
	public function invokeByName(methodName:String):MethodInvocationCallback {
		return this["invokeByNameAndArguments"](methodName, []);
	}
	
	/**
	 * Invokes the passed-in method on the service.
	 *
	 * <p>When the response arrives the appropriate callback method gets
	 * invoked.
	 *
	 * <p>If the passed-in callback is not null, the returned callback
	 * should be the same.
	 *
	 * <p>The invocation is done by forwardning to the {@link #invokeByNameAndArgumentsAndCallback}
	 * method passing an empty arguments array.
	 *
	 * @param methodName the name of the method to invoke
	 * @param callback the callback that receives the return value or errors
	 * @return a callback that can be used to get informed of the response
	 */
	public function invokeByNameAndCallback(methodName:String, callback:MethodInvocationCallback):MethodInvocationCallback {
		return this["invokeByNameAndArgumentsAndCallback"](methodName, [], callback);
	}
	
}