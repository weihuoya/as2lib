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
import org.as2lib.data.io.conn.ServiceProxy;
import org.as2lib.util.Call;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;

/**
 * Proxy handles client request to a certain service and its response.
 * services, which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.LocalClientServiceProxy extends BasicClass implements ServiceProxy {
	private var target:String;
	private var connection:ExtendedLocalConnection;
	private var callbackMap:Map;
	
	/**
	 * Constructor of LocalClientServiceProxy
	 * 
	 * @param target host on which service methods should be called
	 */
	public function LocalClientServiceProxy(target:String) {
		this.target = target;
		connection = new ExtendedLocalConnection();
		callbackMap = new HashMap();
	}
	
	/**
	 * Puts callback object which should be called after service method response.
	 * 
	 * @param method of a specific service
	 * @param call object which is connected to service
	 */
	public function putCallback(method:String, call:Call):Void {
		callbackMap.put(method, call);
	}
	
	/**
	 * Overload
	 * #invokeWithArgs()
	 * #invokeWithoutArgs()
	 */
	public function invoke():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String, Array], invokeWithArgs);
		o.addHandler([String], invokeWithoutArgs);
		o.forward(arguments);
	}
	
	/**
	 * Invokes service method with passed arguments.
	 * 
	 * @param method of service which should be invoked
	 * @param args arguments which should be passed to service method
	 */
	public function invokeWithArgs(method:String, args:Array):Void {
		if (callbackMap.containsKey(method)) {
			connection.send(target, "remoteCall", [method, args], callbackMap.get(method));
			return;
		}
		connection.send(target, "remoteCall", [method, args]);
	}
	
	/**
	 * invokes service method.
	 * 
	 * @param method of service which should be invoked
	 */
	public function invokeWithoutArgs(method:String):Void {
		invokeWithArgs(method, []);
	}
}