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
import org.as2lib.util.Call;

/**
 * Interface for  standardized ServiceProxies to handle client request to a certain service on a server and its response.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

interface org.as2lib.data.io.conn.ServiceProxy extends BasicInterface {
	
	/**
	 * Overload
	 * #invokeWithArgs()
	 * #invokeWithoutArgs()
	 */
	public function invoke():Void;
	
	/**
	 * Invokes remote method and its arguments and sends the response to set call object.
	 * 
	 * @param method remoting method to be called
	 * @param args arguments which are passed to remote method
	 */
	public function invokeWithArgs(method:String, args:Array):Void;
	
	/**
	 * Invokes remote method and sends response to set call object.
	 * 
	 * @param method remoting method to be called
	 */
	public function invokeWithoutArgs(method:String):Void;
	
	/**
	 * Invokes remote method and sends response to set call object.
	 * 
	 * @param method to which the call object is linked to
	 * @param call which is executed after method response
	 */
	public function putCallback(method:String, call:Call):Void;
}