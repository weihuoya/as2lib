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

import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.pointcut.AbstractPointcut;

/**
 * {@code KindedPointcut} represents any kinded pointcuts. These are for example
 * execution, set and get access pointcuts.
 * 
 * <p>Kinded pointcuts build upon a join point pattern and a specific join point type.
 * Pre-defined join point types are {@link AbstractJoinPoint#METHOD},
 * {@link AbstractJoinPoint#PROPERTY}, {@link AbstractJoinPoint#GET_PROPERTY} and
 * {@link AbstractJoinPoint#SET_PROPERTY}.
 * 
 * <p>The pattern may consist of wildcards. Using wildcards you can capture join points
 * based on specific characteristics like capture every setter method contained in every
 * class whose name starts with {@code "Abstract"} in the {@code org.as2lib.env} package
 * and every sub-package. Such a pattern would look something like this:
 * <code>org.as2lib.env..Abstract*.set*</code>
 * 
 * <p>You already see two wildcards there: '*' and '..'.
 * <ul>
 *   <li>'*' indicates any number of characters excluding the period.</li>
 *   <li>'..' indicates any number of charecters including all periods.</li>
 *   <li>'+' indicates all subclasses or subinterfaces of a given type.</li>
 *   <li>
 *     '!' negates the match; match all join points except the ones that match the
 *     pattern.
 *   </li>
 * </ul>
 * 
 * @author Simon Wacker
 * @see <a href="http://www.simonwacker.com/blog/archives/000057.php">Kinded Pointcuts</a>
 * @see <a href="http://www.simonwacker.com/blog/archives/000053.php">Wildcards</a>
 */
class org.as2lib.aop.pointcut.KindedPointcut extends AbstractPointcut implements Pointcut {
	
	/** The type of the matching join points. */
	private var matchingJoinPointType:Number;
	
	/**
	 * Constructs a new {@code KindedPointcut} instance.
	 *
	 * <p>Depending on the join points {@code matches} method a pattern of value
	 * {@code null} or {@code undefined} will cause the {@link #captures} method to
	 * return {@code true} or {@code false}. Note that the join point implementations
	 * provided by this framework return {@code true} for a {@code null} pattern.
	 * 
	 * <p>A matching join point type of value {@code null} or {@code undefined} is
	 * interpreted as "any type of join point allowed".
	 * 
	 * @param pattern the join point pattern
	 * @param matchingJoinPointType the type of join points that match this pointcut
	 */
	public function KindedPointcut(pattern:String, matchingJoinPointType:Number) {
		setJoinPointPattern(pattern);
		this.matchingJoinPointType = matchingJoinPointType;
	}
	
	/**
	 * Checks whether the given {@code joinPoint} is captured by this pointcut. This is
	 * normally the case if the join point is of the correct type and the pattern
	 * matches the join point.
	 * 
	 * {@code false} will be returned if:
	 * <ul>
	 *   <li>The passed-in join point is {@code null} or {@code undefined}.</li>
	 *   <li>The passed-in join point does not match the given join point pattern.</li>
	 *   <li>The passed-in join point's type does not match the given one.</li>
	 * </ul>
	 *
	 * @param joinPoint the join point to check whether it is captured by this pointcut
	 * @return {@code true} if the given {@code joinPoint} is captured else {@code false}
	 * @see JoinPoint#matches
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