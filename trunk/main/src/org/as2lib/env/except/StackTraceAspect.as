﻿/*
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
import org.as2lib.aop.joinpoint.AbstractJoinPoint;
import org.as2lib.env.except.StackTraceElement;

/**
 * {@code StackTraceAspect} traces method invocations and stores them as stack
 * trace elements in a stack trace.
 * 
 * @author Scott Hyndman
 * @author Simon Wacker
 * @see StackTraceElement
 */
class org.as2lib.env.except.StackTraceAspect extends AbstractAspect implements Aspect {
	
	/** The stack of stack trace elements preceding and including the current method invocation. */
	private static var stackTrace:Array;
	
	/**
	 * Returns the stack of {@link StackTraceElement} instances preceding and including
	 * the current method invocation.
	 * 
	 * @return the stack trace
	 */
	public static function getStackTrace(Void):Array {
		return stackTrace.concat();
	}
	
	/** Pointcut capturing methods to trace. */
	private var tracedMethodsPointcut:String;
	
	/**
	 * Constructs a new {@code StackAspect} instance.
	 * 
	 * <p>If {@code traceMethodsPointcut} is not specified, the default pointcut is used.
	 * The default pointcut captures all methods except the methods of this aspect.
	 * <code>execution(* ..*.*()) && !within(org.as2lib.aop.aspect.StackTraceAspect)</code>
	 * 
	 * @param tracedMethodsPointcut (optional) the pointcut capturing methods whose
	 * invocations shall be included in the stack trace
	 */
	public function StackTraceAspect(tracedMethodsPointcut:String) {
		if (tracedMethodsPointcut == null) {
			this.tracedMethodsPointcut = "execution(* ..*.*()) && !within(org.as2lib.aop.aspect.StackTraceAspect)";
		} else {
			this.tracedMethodsPointcut = tracedMethodsPointcut;
		}
		stackTrace = new Array();
		addAdvice(AbstractAdvice.AROUND, getTracedMethodsPointcut(), aroundTracedMethodsAdvice);
	}
	
	/**
	 * Pushes stack trace elements to and pops stack trace elements from the stack trace.
	 * 
	 * @param joinPoint the called method to trace
	 * @param args the argument used for the method call
	 * @return the result of the invocation of the given {@code joinPoint}
	 */
	private function aroundTracedMethodsAdvice(joinPoint:JoinPoint, args:Array) {
		var stackTraceElement:StackTraceElement = new StackTraceElement(
				joinPoint.getThis(),
				AbstractJoinPoint.getMethod(joinPoint).getMethod(),
				args);
		stackTrace.push(stackTraceElement);
		var result = joinPoint.proceed();;
		stackTrace.pop();
		return result;
	}
	
	/**
	 * Returns the pointcut capturing methods whose invocations shall be included in
	 * the stack trace.
	 * 
	 * @param the pointcut capturing methods to trace
	 */
	public function getTracedMethodsPointcut(Void):String {
		return tracedMethodsPointcut;
	}
	
}