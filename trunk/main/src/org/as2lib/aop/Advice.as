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
 * Advice is the core interface that must be implemented to
 * create a custom advice. An advice normally contains the
 * code to be executed at a given pointcut.
 * Refer to http://www.simonwacker.com/blog/archives/000066.php
 * to read what an advice is all about in AOP terms.
 *
 * @author Simon Wacker
 */
interface org.as2lib.aop.Advice extends BasicInterface {
	
	/**
	 * Checks whether the advice captures the specific join
	 * point. This check is normally being done using the set
	 * pointcut.
	 *
	 * @param joinPoint the join point upon which the check shall be made
	 * @return true if the joinPoint is being captured
	 */
	public function captures(joinPoint:JoinPoint):Boolean;
	
	/**
	 * Returns a proxy method that shall be used instead of the
	 * original method.
	 *
	 * @param joinPoint the join point that represents the original method
	 * @return the proxy method
	 */
	public function getProxy(joinPoint:JoinPoint):Function;
	
}