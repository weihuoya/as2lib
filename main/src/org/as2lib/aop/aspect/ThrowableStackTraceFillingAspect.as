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
import org.as2lib.aop.aspect.AbstractAspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.AbstractJoinPoint;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.util.ArrayUtil;

/**
 * {@code ThrowableStackTraceFillingAspect} fills the stack trace of all throwables
 * with the stack trace elements you captured with your pointcut.
 * 
 * <p>This means that if you weave this aspect in every join point, every throwable
 * will contain its full stack trace.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.ThrowableStackTraceFillingAspect extends AbstractAspect {
	
	/**
	 * Constructs a new {@code ThrowableStackTraceFillingAspect} instance.
	 * 
	 * @param stackTraceElementPointcut the pointcut that captures join point that
	 * shall be added as stack trace elements to throwables that are thrown
	 */
	public function ThrowableStackTraceFillingAspect(stackTraceElementPointcut:String) {
		if (stackTraceElementPointcut == null) {
			throw new IllegalArgumentException("Argument 'stackTraceElementPointcut' [" + stackTraceElementPointcut + "] must not be 'null' nor 'undefined'", this, arguments);
		}
		addAdvice(AbstractAdvice.AFTER_THROWING, stackTraceElementPointcut, afterThrowingAdvice);
	}
	
	/**
	 * Adds the stack trace element represented by the {@code joinPoint} to the given
	 * {@code throwable}.
	 * 
	 * @param joinPoint the join point to add as stack trace element
	 * @param throwable the throwable to add the stack trace element to
	 */
	private function afterThrowingAdvice(joinPoint:JoinPoint, throwable):Void {
		if (throwable instanceof Throwable) {
			var exception:Throwable = throwable;
			var stackTrace:Array = exception.getStackTrace();
			var method:Function = getMethod(joinPoint);
			if (stackTrace.length != 1) {
				exception.addStackTraceElement(joinPoint.getThis(), method, joinPoint.getArguments());
			} else {
				var element:StackTraceElement = stackTrace[0];
				if (element.getThrower() != joinPoint.getThis()
						|| !ArrayUtil.isSame(element.getArguments(), joinPoint.getArguments())
						|| element.getMethod() != method) {
					exception.addStackTraceElement(joinPoint.getThis(), method, joinPoint.getArguments());
				}
			}
		}
	}
	
	/**
	 * Returns the concrete method the given {@code joinPoint} represents.
	 * 
	 * @param joinPoint the join point representing the concrete method to return
	 * @return the concrete method the given {@code joinPoint} represents
	 */
	private function getMethod(joinPoint:JoinPoint):Function {
		if (joinPoint.getType() == AbstractJoinPoint.METHOD
				|| joinPoint.getType() == AbstractJoinPoint.CONSTRUCTOR) {
			return MethodInfo(joinPoint.getInfo()).getMethod();
		}
		if (joinPoint.getType() == AbstractJoinPoint.GET_PROPERTY) {
			return PropertyInfo(joinPoint.getInfo()).getGetter().getMethod();
		}
		if (joinPoint.getType() == AbstractJoinPoint.SET_PROPERTY) {
			return PropertyInfo(joinPoint.getInfo()).getSetter().getMethod();
		}
		return null;
	}
	
}