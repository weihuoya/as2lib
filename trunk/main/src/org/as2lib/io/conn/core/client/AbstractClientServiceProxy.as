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
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.client.AbstractClientServiceProxy extends BasicClass {
	
	/**
	 * Generates response urls with passed service url and method name.
	 *
	 * @param connectionName name of response LocalConnection
	 * @param method method to be called on response
	 * @return generated response identifier
	 */
	public static function generateResponseServiceUrl(url:String, method:String):String {
		return  url + "_" + method + "_Return";
	}
	
	/**
	 * Private constructor.
	 */
	private function AbstractClientServiceProxy(Void) {
	}
	
	/**
	 * @see ClientServiceProxy#invoke()
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
	 * @see ClientServiceProxy#invokeByName()
	 */
	public function invokeByName(name:String):MethodInvocationCallback {
		return this["invokeByNameAndArguments"](name, []);
	}
	
	/**
	 * @see ClientServiceProxy#invokeByNameAndCallback()
	 */
	public function invokeByNameAndCallback(name:String, callback:MethodInvocationCallback):MethodInvocationCallback {
		return this["invokeByNameAndArgumentsAndCallback"](name, [], callback);
	}
	
}