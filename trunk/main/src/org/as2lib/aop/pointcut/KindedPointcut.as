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
	private var matchingJoinPointType:Number;
	
	/**
	 * Constructs a new KindedPointcut instance.
	 *
	 * <p>Depending on the join points matches-method a pattern of value
	 * null or undefined will cause the #captures(JoinPoint)-method to
	 * return true or false.
	 *
	 * <p>A matching join point type of value null or undefined gets
	 * interpreted as any type of join point allowed.
	 *
	 * @param pattern the join point pattern
	 * @param matchingJoinPointType the type of join points that match the pointcut type
	 */
	public function KindedPointcut(pattern:String, matchingJoinPointType:Number) {
		setJoinPointPattern(pattern);
		this.matchingJoinPointType = matchingJoinPointType;
	}
	
	/**
	 * False will be returned if:
	 * <ul>
	 *   <li>The passed-in join point is null or undefined.</li>
	 *   <li>The passed-in join point does not match the given join point pattern.</li>
	 *   <li>The passed-in join points type does not match the given one.</li>
	 * </ul>
	 *
	 * @see org.as2lib.aop.Pointcut#captures(JoinPoint):Boolean
	 * @see JoinPoint#matches(String):Boolean
	 */
	public function captures(joinPoint:JoinPoint):Boolean {
		if (!joinPoint) return false;
		if (matchingJoinPointType == null) {
			return joinPoint.matches(getJoinPointPattern());
		}
		return (joinPoint.getType() == matchingJoinPointType
					&& joinPoint.matches(getJoinPointPattern()));
	}
	
}