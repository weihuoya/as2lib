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

import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.Aspect;
import org.as2lib.aop.aspect.AbstractAspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.env.except.AbstractOperationException;

/**
 * {@code IndentedLoggingAspect} indents logging of messages.
 * 
 * <p>You must sub-class this class and override the abstract methods
 * {@link #getLoggedMethodsPointcut} and {@link #getLoggingMethodsPointcut}.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.IndentedLoggingAspect extends AbstractAspect implements Aspect {
	
	/** The temporary indentation level. */
	private var indentationLevel:Number = -1;
	
	/**
	 * Constructs a new {@code IndentedLoggingAspect} instance.
	 */
	private function IndentedLoggingAspect(Void) {
		addAdvice(AbstractAdvice.AROUND, getLoggingMethodsPointcut(), aroundLoggingMethodsAdvice);
		addAdvice(AbstractAdvice.BEFORE, getLoggedMethodsPointcut(), beforeLoggedMethodsAdvice);
		addAdvice(AbstractAdvice.AFTER, getLoggedMethodsPointcut(), afterLoggedMethodsAdvice);
	}
	
	/**
	 * Adds the indentation to the message to log.
	 * 
	 * <p>It is expected that {@code args} has the message as first parameter. This
	 * message is made to a string via its {@code toString} method and the indentation
	 * is added to the resulting string. After this is done, the given {@code args}
	 * array with the first element stringified and indented is used to proceed the
	 * given {@code joinPoint}.
	 * 
	 * @param joinPoint the called log method
	 * @param args the arguments used for the method call
	 * @return the result of the invocation of the given {@code joinPoint} with the
	 * changed {@code args}
	 */
	private function aroundLoggingMethodsAdvice(joinPoint:JoinPoint, args:Array) {
		var spaces:String = "";
		for (var i:Number = 0; i < indentationLevel; i++) {
			spaces += "  ";
		}
		args[0] = spaces + args[0].toString();
		return joinPoint.proceed(args);
	}
	
	/**
	 * Increases the indentation level before a logged method is invoked.
	 * 
	 * @param joinPoint the logged method
	 * @param args the arguments used for invoking the logged method
	 */
	private function beforeLoggedMethodsAdvice(joinPoint:JoinPoint, args:Array):Void {
		indentationLevel++;
	}
	
	/**
	 * Decreases the indentation level after a logged method was invoked.
	 * 
	 * @param joinPoint the logged method
	 */
	private function afterLoggedMethodsAdvice(joinPoint:JoinPoint):Void {
		indentationLevel--;
	}
	
	/**
	 * Returns the pointcut that captures methods that shall be logged.
	 * 
	 * @return the pointcut that captures methods to log
	 * @throws AbstractOperationException because this method must be overridden by
	 * sub-classes
	 */
	public function getLoggedMethodsPointcut(Void):String {
		throw new AbstractOperationException("This operation is marked as abstract and must be overridden by a concrete subclasses.", this, arguments);
		return null;
	}
	
	/**
	 * Returns the pointcut that captures methods that are responsible for logging
	 * messages. Such a method is for example the {@code Logger.info} method.
	 * 
	 * @return the pointcut that captures log methods
	 * @throws AbstractOperationException because this method must be overridden by
	 * sub-classes
	 */
	public function getLoggingMethodsPointcut(Void):String {
		throw new AbstractOperationException("This operation is marked as abstract and must be overridden by a concrete subclasses.", this, arguments);
		return null;
	}
	
}