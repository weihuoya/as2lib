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

import org.as2lib.aop.advice.AbstractAfterThrowingAdvice;
import org.as2lib.aop.advice.AfterThrowingAdvice;
import org.as2lib.util.Call;
import org.as2lib.aop.JoinPoint;
import org.as2lib.env.except.Throwable;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicAfterThrowingAdvice extends AbstractAfterThrowingAdvice implements AfterThrowingAdvice {
	
	/** Stores the callback instance. */
	private var callback:Call;
	
	/**
	 * Constrcuts a new DynamicAfterThrowingAdvice.
	 *
	 * @param pointcut the pointcut that is used by the #captures(JoinPoint):Boolean operation
	 * @param callback the Call instance executed when the #execute(JoinPoint):Void operation is being executed
	 */
	public function DynamicAfterThrowingAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	/**
	 * Executes the callback passing the passed join point and throwable.
	 * 
	 * @see org.as2lib.aop.advice.AfterThrowingAdvice#execute(JoinPoint, Throwable):Void
	 */
	public function execute(joinPoint:JoinPoint, throwable:Throwable):Void {
		callback.execute([joinPoint, throwable]);
	}
	
}