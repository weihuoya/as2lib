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

import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;
import org.as2lib.util.Call;
import org.as2lib.aop.AopConfig;

/**
 * AbstractAspect provides convenient method implmenetations and offers
 * functionalities to add advices in different manners.
 *
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.AbstractAspect extends BasicClass {
	
	/** Stores the added advices. */
	private var adviceArray:Array;
	
	/**
	 * Constructs a new AbstractAspect.
	 */
	private function AbstractAspect(Void) {
		adviceArray = new Array();
	}
	
	/**
	 * @see org.as2lib.aop.Aspect#getAdvices(Void):Array
	 */
	public function getAdvices(Void):Array {
		return adviceArray;
	}
	
	/**
	 * @overload #addAdviceByAdvice()
	 * @overload #addAdviceByTypeAndStringAndMethod()
	 * @overload #addAdviceByTypeAndPointcutAndMethod()
	 */
	private function addAdvice() {
		var o:Overload = new Overload(this);
		o.addHandler([Advice], addAdviceByAdvice);
		o.addHandler([Number, String, Function], addAdviceByTypeAndStringAndMethod);
		o.addHandler([Number, Pointcut, Function], addAdviceByTypeAndPointcutAndMethod);
		return o.forward(arguments);
	}
	
	/**
	 * Just adds the passed advice directly.
	 *
	 * @param advice the advice to be added
	 */
	private function addAdviceByAdvice(advice:Advice):Void {
		adviceArray.push(advice);
	}
	
	/**
	 * Adds a new advice of the given type. The advice is obtained from
	 * the AdviceFactory.
	 *
	 * @param type the type of the advice that shall be added
	 * @param pointcut the pointcut represented by a string that shall be used by the Advice#captures(JoinPoint):Boolean method
	 * @param method the method that contains the actions to be executed at specific join points
	 */
	private function addAdviceByTypeAndStringAndMethod(type:Number, pointcut:String, method:Function):Advice {
		var callback:Call = new Call(this, method);
		var result:Advice = AopConfig.getDynamicAdviceFactory().getAdvice(type, pointcut, callback);
		addAdviceByAdvice(result);
		return result;
	}
	
	/**
	 * Adds a new advice of the given type. The advice is obtained from
	 * the AdviceFactory.
	 *
	 * @param type the type of the advice that shall be added
	 * @param pointcut the pointcut that shall be used by the Advice#captures(JoinPoint):Boolean method
	 * @param method the method that contains the actions to be executed at specific join points
	 */
	private function addAdviceByTypeAndPointcutAndMethod(type:Number, pointcut:Pointcut, method:Function):Advice {
		var callback:Call = new Call(this, method);
		var result:Advice = AopConfig.getDynamicAdviceFactory().getAdvice(type, pointcut, callback);
		addAdviceByAdvice(result);
		return result;
	}
	
}