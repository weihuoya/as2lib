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
 * MethodInvocationErrorInfo is a data transfer object used to inform
 * the client of an error that occured during a 'remote' method invocation.
 *
 * <p>It defines constants, that can be used to identify what kind of
 * error occured.
 *
 * <p>This class gets used in conjunction with the MethodInvocationCallback
 * and MethodInvocationErrorListener classes.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.MethodInvocationErrorInfo extends BasicClass implements EventInfo {
	
	/** Indicates an error of unknown origin. */
	public static var UNKNOWN_ERROR:Number = 0;
	
	/** Indicates an error caused because of a not existing service. */
	public static var UNKNOWN_SERVICE_ERROR:Number = 1;
	
	/** Indicates that the method to be invoked does not exist. */
	public static var UNKNOWN_METHOD_ERROR:Number = 2;
	
	/** Indicates an error caused by arguments that are out of size. */
	public static var OVERSIZED_ARGUMENTS_ERROR:Number = 3;
	
	/** Indicates that the service method to be invoked threw an exception. */
	public static var METHOD_EXCEPTION_ERROR:Number = 4;
	
	/** Url of the service the method should have been invoked on. */
	private var serviceUrl:String;
	
	/** The name of the method to be executed. */
	private var methodName:String;
	
	/** The arguments used for the invocation. */
	private var methodArguments:Array;
	
	/** A number indicating the type of the error. */
	private var errorCode:Number;
	
	/** The exception that has caused the error. */
	private var exception;
	
	/**
	 * Constructs a new MethodInvocationErrorInfo instance.
	 *
	 * @param serviceUrl the url to the service the method should be or was invoked on
	 * @param methodName the name of the method to be executed
	 * @param methodArguments the arguments used as parameters for the method invocation
	 * @param error a number indicating the type of the error
	 * @param exception the exception that caused the error
	 */
	public function MethodInvocationErrorInfo(serviceUrl:String, methodName:String, methodArguments:Array, errorCode:Number, exception) {
		this.serviceUrl = serviceUrl;
		this.methodName = methodName;
		this.methodArguments = methodArguments;
		this.errorCode = errorCode;
		this.exception = exception;
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
	
	/**
	 * @return the error code that describes the type of the error
	 */
	public function getErrorCode(Void):Number {
		return errorCode;
	}
	
	/**
	 * @return the exception that caused the error
	 */
	public function getException(Void) {
		return exception;
	}
	
	/**
	 * @return 'onError'
	 * @see EventInfo#getName(Void):String
	 */
	public function getName(Void):String {
		return "onError";
	}
	
}