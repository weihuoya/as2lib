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

import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.app.exec.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.DynamicAdviceFactory extends AdviceFactory {
	
	/**
	 * @overload #getAdviceByTypeAndStringAndCall()
	 * @overload #getAdviceByTypeAndPointcutAndCall()
	 * @see org.as2lib.aop.advice.AdviceFactory#getAdvice():Advice
	 */
	public function getAdvice():Advice;
	
	/**
	 * Returns the advice corresponding to the passed type. The advice
	 * uses the passed pointcut and callback. The Callback will be executed
	 * when the Advice#execute(..):Void method is called.
	 *
	 * @param type the type of the advice
	 * @param pointcut a string representation of a pointcut used by the returned advice
	 * @param callback a Call instance to execute the execute method on when the advice is executed
	 * @return the advice corresponding to the type
	 */
	public function getAdviceByTypeAndStringAndCall(type:Number, pointcut:String, callback:Call):Advice;
	
	/**
	 * Returns the advice corresponding to the passed type. The advice
	 * uses the passed pointcut and callback. The Callback will be executed
	 * when the Advice#execute(..):Void method is called.
	 *
	 * @param type the type of the advice
	 * @param pointcut the pointcut used by the returned advice
	 * @param callback a Call instance to execute the execute method on when the advice is executed
	 * @return the advice corresponding to the type
	 */
	public function getAdviceByTypeAndPointcutAndCall(type:Number, pointcut:Pointcut, callback:Call):Advice;
	
}