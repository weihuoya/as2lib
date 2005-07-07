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
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.Aspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.AopConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAdvice extends BasicClass {
	
	/** Number value indicating a before advice. */
	public static var BEFORE:Number = 0;
	
	/** Number value indicating an around advice. */
	public static var AROUND:Number = 1;
	
	/** Number value indicating an after advice. */
	public static var AFTER:Number = 2;
	
	/** Number value indicating an after returning advice. */
	public static var AFTER_RETURNING:Number = 3;
	
	/** Number value indicating an after throwing advice. */
	public static var AFTER_THROWING:Number = 4;
	
	/** Stores the pointcut that is responsible for checking if a join point is captured by the advice. */
	private var pointcut:Pointcut;
	
	/** Stores the aspect that contains the advice. */
	private var aspect:Aspect;
	
	/**
	 * Private constrcutor to prevent direct instantiation.
	 *
	 * @param aspect the aspect that contains the advice
	 */
	private function AbstractAdvice(aspect:Aspect) {
		setAspect(aspect);
	}
	
	/**
	 * Sets the new aspect.
	 *
	 * @param newAspect the new aspect to be set
	 */
	private function setAspect(newAspect:Aspect):Void {
		aspect = newAspect;
	}
	
	/**
	 * Returns the set aspect.
	 *
	 * @return the set aspect
	 */
	private function getAspect(Void):Aspect {
		return aspect;
	}
	
	/**
	 * @overload #setPointcutByPointcut()
	 * @overload #setPointcutByString()
	 */
	private function setPointcut(pointcut) {
		var overload:Overload = new Overload(this);
		overload.addHandler([Pointcut], setPointcutByPointcut);
		overload.addHandler([String], setPointcutByString);
		overload.forward(arguments);
	}
	
	/**
	 * Sets the new pointcut.
	 *
	 * @param newPointcut the new pointcut to be set
	 */
	private function setPointcutByPointcut(newPointcut:Pointcut):Void {
		pointcut = newPointcut;
	}
	
	/**
	 * Sets the new pointcut.
	 *
	 * @param pointcutString a string representation of the pointcut to set
	 * @return the evaluated pointcut
	 */
	private function setPointcutByString(pointcutString:String):Pointcut {
		var result:Pointcut = AopConfig.getPointcutFactory().getPointcut(pointcutString);
		setPointcutByPointcut(result);
		return result;
	}
	
	/**
	 * Returns the set pointcut.
	 *
	 * @return the set pointcut
	 */
	private function getPointcut(Void):Pointcut {
		return pointcut;
	}
	
	/**
	 * @see org.as2lib.aop.Advice#captures(JoinPoint):Boolean
	 */
	public function captures(joinPoint:JoinPoint):Boolean {
		return pointcut.captures(joinPoint);
	}
	
}