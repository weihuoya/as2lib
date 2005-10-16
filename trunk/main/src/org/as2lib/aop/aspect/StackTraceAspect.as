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

/**
 * {@code StackTraceAspect} traces method invocations and stores them in a stack.
 * 
 * <p>Traced method calls are stringified, this means a string representation of them
 * is created, and stored in the stack trace. The string representation consists of the
 * fully qualified method name plus the arguments used for the method call if wished.
 * 
 * @author Scott Hyndman
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.StackTraceAspect extends AbstractAspect implements Aspect {
	
	/** The stack of method calls preceding and including the current one. */
	private static var stackTrace:Array;
	
	/**
	 * Returns the stack of method calls preceding and including the current one.
	 * 
	 * <p>Method calls are represented by strings.
	 * 
	 * @return the stack trace
	 */
	public static function getStackTrace(Void):Array {
		return stackTrace;
	}
	
	/** Pointcut capturing methods to trace. */
	private var tracedMethodsPointcut:String;
	
	/** Determines whether to show arguments. */
	private var showArguments:Boolean;
	
	/**
	 * Constructs a new {@code StackAspect} instance.
	 * 
	 * <p>If {@code traceMethodsPointcut} is not specified, the default pointcut is used.
	 * The default pointcut captures all methods except the methods of this aspect.
	 * <code>execution(* ..*.*()) && !within(org.as2lib.aop.aspect.StackTraceAspect)</code>
	 * 
	 * <p>{@code showArguments} is by default set to {@code true}.
	 * 
	 * @param tracedMethodsPointcut (optional) the pointcut capturing methods whose
	 * invocations shall be included in the stack trace
	 * @param showArguments (optional) determines whether to show arguments in the string
	 * representations of the method calls
	 */
	public function StackTraceAspect(tracedMethodsPointcut:String, showArguments:Boolean) {
		if (tracedMethodsPointcut == null) {
			this.tracedMethodsPointcut = "execution(* ..*.*()) && !within(org.as2lib.aop.aspect.StackTraceAspect)";
		} else {
			this.tracedMethodsPointcut = tracedMethodsPointcut;
		}
		if (showArguments == null) {
			this.showArguments = true;
		} else {
			this.showArguments = showArguments;
		}
		stackTrace = new Array();
		addAdvice(AbstractAdvice.AROUND, getTracedMethodsPointcut(), aroundTracedMethodsAdvice);
	}
	
	/**
	 * Returns whether arguments are shown in the string representations of the method
	 * calls.
	 * 
	 * @return {@code true} if arguments are shown else {@code false}
	 */
	public function areArgumentsShown(Void):Boolean {
		return showArguments;
	}
	
	/**
	 * Pushes method calls to and pops method calls from the stack trace.
	 * 
	 * <p>Depending on your configuration, the given {@code args} are either included
	 * in the method call string or not.
	 * 
	 * @param joinPoint the called method to trace
	 * @param args the argument used for the method call
	 * @return the result of the invocation of the given {@code joinPoint} with the
	 * given {@code args}
	 */
	private function aroundTracedMethodsAdvice(joinPoint:JoinPoint, args:Array) {
		var methodCall:String = joinPoint.getInfo().getFullName();
		if (showArguments) {
			methodCall += "(" + args + ")";
		}
		stackTrace.push(methodCall);
		var result = joinPoint.proceed(args);;
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