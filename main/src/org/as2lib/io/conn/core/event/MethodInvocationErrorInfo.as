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
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.MethodInvocationErrorInfo extends BasicClass implements EventInfo {
	
	/** Indicates an error of unknown origin. */
	public static var ERROR_UNKNOWN:Number = 0;
	
	/** Indicates an error caused because of a not existing service. */
	public static var ERROR_UNKNOWN_SERVICE:Number = 1;
	
	/** Indicates that the method to be invoked does not exist. */
	public static var ERROR_UNKNOWN_METHOD:Number = 2;
	
	/** Indicates an error caused by arguments that are out of size. */
	public static var ERROR_ARGUMENTS_OVERSIZED:Number = 3;
	
	/** Indicates that the service method to be invoked threw an exception. */
	public static var ERROR_SERVICE_METHOD:Number = 4;
	
	/** Url of the service the method should have been invoked on. */
	private var url:String;
	
	/** The name of the method to be executed. */
	private var method:String;
	
	/** A number indicating the type of the error. */
	private var error:Number;
	
	/** The exception that has caused the error. */
	private var exception;
	
	/**
	 * Constructs a new MethodInvocationErrorInfo.
	 *
	 * @param connection the identifier of the connection the method should have been executed on
	 * @param method the name of the method to be executed
	 * @param error a number indicating the type of the error
	 */
	public function MethodInvocationErrorInfo(url:String, method:String, error:Number, exception) {
		this.url = url;
		this.method = method;
		this.error = error;
		this.exception = exception;
	}
	
	/**
	 * @return the connection identifier passed via the constructor arguments
	 */
	public function getUrl(Void):String {
		return url;
	}
	
	/**
	 * @return the method name passed to the constructor on initialization
	 */
	public function getMethod(Void):String {
		return method;
	}
	
	/**
	 * @return the error code that describes the error type
	 */
	public function getError(Void):Number {
		return error;
	}
	
	/**
	 * @return the exception that caused the error
	 */
	public function getException(Void) {
		return exception;
	}
	
	/**
	 * @see EventInfo
	 */
	public function getName(Void):String {
		return "onError";
	}
	
}