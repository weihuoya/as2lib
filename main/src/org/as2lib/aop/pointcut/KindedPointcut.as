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

import org.as2lib.aop.pointcut.AbstractPointcut;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;

/**
 * KindedPointcut represents any kinded pointcuts. Kinded
 * pointcuts are for example execute, set and get access
 * pointcuts.
 *
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.KindedPointcut extends AbstractPointcut implements Pointcut {
	
	/** Stores the type of the matching join points. */
	private var matchingJoinPoint:Number;
	
	/**
	 * Constructs a new KindedPointcut instance.
	 *
	 * @param pattern the join point pattern
	 * @param matchingJoinPoint the type of join points that match the pointcut type
	 */
	public function KindedPointcut(pattern:String, matchingJoinPoint:Number) {
		setJoinPointPattern(pattern);
		this.matchingJoinPoint = matchingJoinPoint;
	}
	
	/**
	 * @see org.as2lib.aop.Pointcut#captures(JoinPoint):Boolean
	 */
	public function captures(joinPoint:JoinPoint):Boolean {
		return (joinPoint.getType() == matchingJoinPoint
					&& joinPoint.matches(getJoinPointPattern()));
	}
	
}