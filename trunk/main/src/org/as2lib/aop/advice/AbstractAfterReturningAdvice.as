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

import org.as2lib.aop.Aspect;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AfterReturningAdvice;
import org.as2lib.aop.JoinPoint;
import org.as2lib.env.reflect.ClassInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAfterReturningAdvice extends AbstractAdvice {
	
	/**
	 * @see org.as2lib.aop.advice.AbstractAdvice#new(Aspect)
	 */
	private function AbstractAfterReturningAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	/**
	 * @see org.as2lib.aop.Advice#getProxy(JoinPoint):Function
	 */
	public function getProxy(joinPoint:JoinPoint):Function {
		var owner:AbstractAfterReturningAdvice = this;
		return (function() {
			joinPoint = ClassInfo.forInstance(joinPoint).newInstance([joinPoint.getInfo(), this]);
			return owner.executeJoinPoint(joinPoint, arguments);
		});
	}
	
	/**
	 * Logic to be executed when a join point is being reached.
	 *
	 * @param joinPoint the reached join point
	 * @param args the arguments passed to the join point
	 */
	private function executeJoinPoint(joinPoint:JoinPoint, args:Array) {
		var result = joinPoint.proceed(args);
		this["execute"](joinPoint, result);
		return result;
	}
	
}