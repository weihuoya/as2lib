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
import org.as2lib.env.event.EventInfo;

/**
 * MethodInvocationReturnInfo is a data transfer object used to inform
 * clients that the method invocation completed successfully.
 *
 * <p>This class gets used in conjunction with the MethodInvocationCallback
 * and MethodInvocationReturnListener classes.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.MethodInvocationReturnInfo extends BasicClass implements EventInfo {
	
	/** The return value returned by the invoked method. */
	private var returnValue;
	
	/** Url of the service the method should have been invoked on. */
	private var serviceUrl:String;
	
	/** The name of the method to be executed. */
	private var methodName:String;
	
	/** The arguments used for the invocation. */
	private var methodArguments:Array;
	
	/**
	 * Constructs a new MethodInvocationReturnInfo instance.
	 *
	 * @param serviceUrl the url to the service the method should be or was invoked on
	 * @param methodName the name of the method to be executed
	 * @param methodArguments the arguments used as parameters for the method invocation
	 * @param returnValue the result of the invoked method
	 */
	public function MethodInvocationReturnInfo(serviceUrl:String, methodName:String, methodArguments:Array, returnValue) {
		this.serviceUrl = serviceUrl;
		this.methodName = methodName;
		this.methodArguments = methodArguments;
		this.returnValue = returnValue;
	}
	
	/**
	 * @return the url to the service the method should be or was executed on
	 */
	public function getServiceUrl(Void):String {
		return serviceUrl;
	}
	
	/**
	 * @return the name of the method that should be or was executed on the service
	 */
	public function getMethodName(Void):String {
		return methodName;
	}
	
	/**
	 * @return the arguments used as parameters for the method invocation
	 */
	public function getMethodArguments(Void):Array {
		return methodArguments;
	}
	
	/*
	 * @return the return value of the invoked method
	 */
	public function getReturnValue(Void) {
		return returnValue;
	}
	
	/**
	 * @see EventInfo
	 */
	public function getName(Void):String {
		return "onResponse";
	}
	
}