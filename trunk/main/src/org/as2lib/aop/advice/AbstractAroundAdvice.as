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
import org.as2lib.aop.advice.AroundAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAroundAdvice extends AbstractAdvice {
	
	/**
	 * @see org.as2lib.aop.advice.AbstractAdvice#new(Aspect)
	 */
	private function AbstractAroundAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	/**
	 * @see org.as2lib.aop.Advice#getProxy(JoinPoint):Function
	 */
	public function getProxy(joinPoint:JoinPoint):Function {
		var owner:AbstractAroundAdvice = this;
		return (function() {
			joinPoint = joinPoint.getClass().newInstance([joinPoint.getInfo(), this]);
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
		return this["execute"](joinPoint, args);
	}
	
}