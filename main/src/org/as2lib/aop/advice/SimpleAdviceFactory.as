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
import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.env.overload.Overload;
import org.as2lib.app.exec.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.SimpleAdviceFactory extends BasicClass implements AdviceFactory {
	
	/** Stores the advice. */
	private var advice:Function;
	
	/**
	 * Constructs a new SimpleAdviceFactory.
	 *
	 * @param advice the actual advice to return a instance of
	 */
	public function SimpleAdviceFactory(advice:Function) {
		this.advice = advice;
	}
	
	/**
	 * @see org.as2lib.aop.advice.AdviceFactory#getAdvice():Advice
	 */
	public function getAdvice():Advice {
		var o:Overload = new Overload(this);
		o.addHandler([String, Call], getAdviceByStringAndCall);
		o.addHandler([Pointcut, Call], getAdviceByPointcutAndCall);
		return o.forward(arguments);
	}
	
	/**
	 * @see org.as2lib.aop.advice.AdviceFactory#getAdviceByStringAndCall(String, Call):Advice
	 */
	public function getAdviceByStringAndCall(pointcut:String, callback:Call):Advice {
		return Advice(new advice(pointcut, callback));
	}
	
	/**
	 * @see org.as2lib.aop.advice.AdviceFactory#getAdviceByPointcutAndCall(Pointcut, Call):Advice
	 */
	public function getAdviceByPointcutAndCall(pointcut:Pointcut, callback:Call):Advice {
		return Advice(new advice(pointcut, callback));
	}
	
}