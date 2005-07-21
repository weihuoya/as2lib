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
 * {@code AbstractAdvice} implements methods commonly needed by {@link Adivce}
 * implementations.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAdvice extends BasicClass {
	
	/** Signifies a before advice. */
	public static var BEFORE:Number = 0;
	
	/** Signifies an around advice. */
	public static var AROUND:Number = 1;
	
	/** Signifies an after advice. */
	public static var AFTER:Number = 2;
	
	/** Signifies an after returning advice. */
	public static var AFTER_RETURNING:Number = 3;
	
	/** Signifies an after throwing advice. */
	public static var AFTER_THROWING:Number = 4;
	
	/** The pointcut that is responsible for checking if a join point is captured by this advice. */
	private var pointcut:Pointcut;
	
	/** The aspect that contains this advice. */
	private var aspect:Aspect;
	
	/**
	 * Constructs a new {@code AbstractAdvice} instance.
	 *
	 * @param aspect (optional) the aspect that contains this advice
	 */
	private function AbstractAdvice(aspect:Aspect) {
		this.aspect = aspect;
	}
	
	/**
	 * Sets the aspect that contains this advice.
	 *
	 * @param aspect the new aspect containing this advice
	 */
	private function setAspect(aspect:Aspect):Void {
		this.aspect = aspect;
	}
	
	/**
	 * Returns the aspect that contains this advice.
	 * 
	 * @return the aspect that contains this advice
	 */
	public function getAspect(Void):Aspect {
		return this.aspect;
	}
	
	/**
	 * @overload #setPointcutByPointcut
	 * @overload #setPointcutByString
	 */
	private function setPointcut() {
		var overload:Overload = new Overload(this);
		overload.addHandler([Pointcut], setPointcutByPointcut);
		overload.addHandler([String], setPointcutByString);
		return overload.forward(arguments);
	}
	
	/**
	 * Sets a new pointcut. The pointcut determines which join points are captured.
	 *
	 * @param pointcut the new pointcut to set
	 */
	private function setPointcutByPointcut(pointcut:Pointcut):Void {
		this.pointcut = pointcut;
	}
	
	/**
	 * Sets the new pointcut by the pointcut's string representation.
	 *
	 * @param pointcut the string representation of the pointcut
	 * @return the actual pointcut set that was created by the given {@code pointcut}
	 * string
	 */
	private function setPointcutByString(pointcut:String):Pointcut {
		var result:Pointcut = AopConfig.getPointcutFactory().getPointcut(pointcut);
		setPointcutByPointcut(result);
		return result;
	}
	
	/**
	 * Returns the set pointcut.
	 * 
	 * @return the set pointcut
	 */
	public function getPointcut(Void):Pointcut {
		return this.pointcut;
	}
	
	/**
	 * Checks whether this advice captures the given {@code joinPoint}. This check is
	 * done with the help of the set pointcut's {@code captures} method.
	 * 
	 * @param joinPoint the join point upon which to make the check
	 * @return {@code true} if the given {@code joinPoint} is captured else {@code false}
	 */
	public function captures(joinPoint:JoinPoint):Boolean {
		return pointcut.captures(joinPoint);
	}
	
}