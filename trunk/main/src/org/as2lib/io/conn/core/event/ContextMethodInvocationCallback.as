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

import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationContextAware;
import org.as2lib.context.ApplicationEventPublisher;
import org.as2lib.context.event.ErrorEvent;
import org.as2lib.context.event.SuccessEvent;
import org.as2lib.core.BasicClass;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;

/**
 * {@code ContextMethodInvocationCallback} is a simple method invocation callback
 * designed to be used in an application context, that publishes {@link ErrorEvent}
 * or {@link SuccessEvent} instances with the given error code and success code
 * respectively.
 * 
 * <p>Note that error or success events are only published if there is a error
 * or success code, respectively.
 * 
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.ContextMethodInvocationCallback extends BasicClass implements MethodInvocationCallback, ApplicationContextAware {
	
	private var applicationContext:ApplicationContext;
	
	private var eventPublisher:ApplicationEventPublisher;
	
	private var errorCode:String;
	
	private var successCode:String;
	
	/**
	 * Constructs a new {@code ContextMethodInvocationCallback} instance with error and
	 * success codes.
	 * 
	 * @param errorCode the error code to use
	 * @param successCode the success code to use
	 */
	public function ContextMethodInvocationCallback(errorCode:String, successCode:String) {
		this.errorCode = errorCode;
		this.successCode = successCode;
	}
	
	/**
	 * Returns the error code used for publishing error events.
	 * 
	 * @return the error code
	 */
	public function getErrorCode(Void):String {
		return errorCode;
	}
	
	/**
	 * Sets the error code to use for publishing error events.
	 * 
	 * @param errorCode the error code
	 */
	public function setErrorCode(errorCode:String):Void {
		this.errorCode = errorCode;
	}
	
	/**
	 * Returns the success code used for publishing success events.
	 * 
	 * @return the success code
	 */
	public function getSuccessCode(Void):String {
		return successCode;
	}
	
	/**
	 * Sets the success code to use for publishing success events.
	 * 
	 * @param successCode the success code
	 */
	public function setSuccessCode(successCode:String):Void {
		this.successCode = successCode;
	}
	
	public function setApplicationContext(applicationContext:ApplicationContext):Void {
		this.applicationContext = applicationContext;
		this.eventPublisher = applicationContext.getEventPublisher();
	}
	
	/**
	 * Publishes a success event if a success code has been set. The success event
	 * contains the success code.
	 * 
	 * @param returnInfo the return info of the method invocation
	 * @see SuccessEvent
	 */
	public function onReturn(returnInfo:MethodInvocationReturnInfo):Void {
		if (successCode != null) {
			var event:SuccessEvent = new SuccessEvent(successCode, applicationContext);
			eventPublisher.publishEvent(event);
		}
	}
	
	/**
	 * Publishes an error event if an error code has been set. The error event contains
	 * the error code.
	 * 
	 * @param errorInfo the error info of the method invocation
	 * @see ErrorEvent
	 */
	public function onError(errorInfo:MethodInvocationErrorInfo):Void {
		if (errorCode != null) {
			var event:ErrorEvent = new ErrorEvent(errorCode, applicationContext);
			eventPublisher.publishEvent(event);
		}
	}
	
}