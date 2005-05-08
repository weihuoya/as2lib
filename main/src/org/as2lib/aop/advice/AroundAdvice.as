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

import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.AroundAdvice extends Advice {
	
	/**
	 * The actions to execute instead of the join point. If the
	 * join point shall nevertheless be executed this has to be
	 * done manually.
	 *
	 * @param joinPoint the join point the advice was woven into
	 * @param args the arguments passed to the join point
	 */
	public function execute(joinPoint:JoinPoint, args:Array);

}