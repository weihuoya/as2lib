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
import org.as2lib.aop.advice.DynamicAdviceFactory;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.aop.advice.SimpleAdviceFactory;
import org.as2lib.aop.advice.DynamicBeforeAdvice;
import org.as2lib.aop.advice.DynamicAroundAdvice;
import org.as2lib.aop.advice.DynamicAfterAdvice;
import org.as2lib.aop.advice.DynamicAfterReturningAdvice;
import org.as2lib.aop.advice.DynamicAfterThrowingAdvice;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.SimpleDynamicAdviceFactory extends BasicClass implements DynamicAdviceFactory {
	
	/** Stores all registered advices. */
	private var registry:Array;
	
	/**
	 * Constructs a new SimpleDynamicAdviceFactory.
	 */
	public function SimpleDynamicAdviceFactory(Void) {
		registry = new Array();
		registry[AbstractAdvice.TYPE_BEFORE] = new SimpleAdviceFactory(DynamicBeforeAdvice);
		registry[AbstractAdvice.TYPE_AROUND] = new SimpleAdviceFactory(DynamicAroundAdvice);
		registry[AbstractAdvice.TYPE_AFTER] = new SimpleAdviceFactory(DynamicAfterAdvice);
		registry[AbstractAdvice.TYPE_AFTER_RETURNING] = new SimpleAdviceFactory(DynamicAfterReturningAdvice);
		registry[AbstractAdvice.TYPE_AFTER_THROWING] = new SimpleAdviceFactory(DynamicAfterThrowingAdvice);
	}
	
	/**
	 * @see org.as2lib.aop.advice.DynamicAdviceFactory#getAdvice():Advice
	 */
	public function getAdvice():Advice {
		var o:Overload = new Overload(this);
		o.addHandler([String, Call], getAdviceByStringAndCall);
		o.addHandler([Pointcut, Call], getAdviceByPointcutAndCall);
		o.addHandler([Number, String, Call], getAdviceByTypeAndStringAndCall);
		o.addHandler([Number, Pointcut, Call], getAdviceByTypeAndPointcutAndCall);
		return o.forward(arguments);
	}
	
	/**
	 * @see org.as2lib.aop.advice.DynamicAdviceFactory#getAdviceByStringAndCall(String, Call):Advice
	 */
	public function getAdviceByStringAndCall(pointcut:String, callback:Call):Advice {
		return getAdviceByTypeAndStringAndCall(registry[AbstractAdvice.TYPE_BEFORE], pointcut, callback);
	}
	
	/**
	 * @see org.as2lib.aop.advice.DynamicAdviceFactory#getAdviceByPointcutAndCall(Pointcut, Call):Advice
	 */
	public function getAdviceByPointcutAndCall(pointcut:Pointcut, callback:Call):Advice {
		return getAdviceByTypeAndPointcutAndCall(registry[AbstractAdvice.TYPE_BEFORE], pointcut, callback);
	}
	
	/**
	 * @see org.as2lib.aop.advice.DynamicAdviceFactory#getAdviceByTypeAndStringAndCall(Number, String, Call):Advice
	 */
	public function getAdviceByTypeAndStringAndCall(type:Number, pointcut:String, callback:Call):Advice {
		return AdviceFactory(registry[type]).getAdvice(pointcut, callback);
	}
	
	/**
	 * @see org.as2lib.aop.advice.DynamicAdviceFactory#getAdviceByTypeAndPointcutAndCall(Number, Pointcut, Call):Advice
	 */
	public function getAdviceByTypeAndPointcutAndCall(type:Number, pointcut:Pointcut, callback:Call):Advice {
		return AdviceFactory(registry[type]).getAdvice(pointcut, callback);
	}
	
}