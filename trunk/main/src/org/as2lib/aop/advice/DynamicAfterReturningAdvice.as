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

import org.as2lib.aop.advice.AbstractAfterReturningAdvice;
import org.as2lib.aop.advice.AfterReturningAdvice;
import org.as2lib.app.exec.Call;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicAfterReturningAdvice extends AbstractAfterReturningAdvice implements AfterReturningAdvice {
	
	/** Stores the callback instance. */
	private var callback:Call;
	
	/**
	 * Constrcuts a new DynamicAfterReturningAdvice.
	 *
	 * @param pointcut the pointcut that is used by the #captures(JoinPoint):Boolean operation
	 * @param callback the Call instance executed when the #execute(JoinPoint):Void operation is being executed
	 */
	public function DynamicAfterReturningAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	/**
	 * Executes the callback passing the passed join point and return value.
	 * 
	 * @see org.as2lib.aop.advice.AfterReturningAdvice#execute(JoinPoint, Object):Void
	 */
	public function execute(joinPoint:JoinPoint, returnValue):Void {
		callback.execute([joinPoint, returnValue]);
	}
	
}