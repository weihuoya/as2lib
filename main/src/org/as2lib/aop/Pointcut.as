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

import org.as2lib.core.BasicInterface;
import org.as2lib.aop.JoinPoint;

/**
 * Any class implementing this interface represents a pointcut.
 * A pointcut normally defines a pattern that can be matched against
 * a join point to check whether the join point is being captured.
 * Refer to http://www.simonwacker.com/blog/archives/000043.php for
 * a explanation of what pointcuts are in AOP termonology.
 *
 * @author Simon Wacker
 */
interface org.as2lib.aop.Pointcut extends BasicInterface {
	
	/**
	 * Checks if the join point is being captured by this pointcut.
	 *
	 * @param joinPoint the join point upon which the check shall be made
	 * @return true if the join point is being captured by this pointcut
	 */
	public function captures(joinPoint:JoinPoint):Boolean;
	
}