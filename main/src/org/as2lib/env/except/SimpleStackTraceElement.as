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
import org.as2lib.env.except.ExceptConfig;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.Iterator;

/**
 * Simple implementation of the StackTraceElement interface.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.SimpleStackTraceElement extends BasicClass implements StackTraceElement {
	/** The thrower. */
	private var concreteThrower;
	
	/** The throwing method. */
	private var concreteMethod:Function;
	
	/** A ClassInfo representing the thrower. */
	private var thrower:ClassInfo;
	
	/** A MethodInfo representing the throwing method. */
	private var method:MethodInfo;
	
	/** The arguments passed to the throwing method. */
	private var args:FunctionArguments;
	
	/**
	 * Constructs a new SimpleStackTraceElement instance.
	 * 
	 * @param thrower the class that threw the Throwable
	 * @param method the method that threw the Throwabele
	 * @param args the arguments passed to the throwing method
	 */
	public function SimpleStackTraceElement(thrower, method:Function, args:FunctionArguments) {
		this.concreteThrower = thrower;
		this.concreteMethod = method;
		this.args = args;
	}
	
	/**
	 * @see org.as2lib.env.except.StackTraceElement#getThrower()
	 */
	public function getThrower(Void):ClassInfo {
		if (ObjectUtil.isEmpty(thrower)) {
			thrower = ReflectUtil.getClassInfo(concreteThrower);
		}
		return thrower;
	}
	
	/**
	 * @see org.as2lib.env.except.StackTraceElement#getMethod()
	 */
	public function getMethod(Void):MethodInfo {
		if (ObjectUtil.isEmpty(method)) {
			if (ObjectUtil.isEmpty(getThrower())) {
				break;
			}
			var tempMethod:MethodInfo = getThrower().getConstructor();
			if (tempMethod.getMethod() == concreteMethod) {
				return (method = tempMethod);
			}
			try {
				tempMethod = getThrower().getMethod(concreteMethod);
			} catch (e:org.as2lib.env.reflect.NoSuchTypeMemberException) {
			}
			if (tempMethod.getMethod() == concreteMethod) {
				return (method = tempMethod);
			}
			var properties:Array = getThrower().getProperties();
			var l:Number = properties.length;
			for (var i:Number = 0; i < l; i = i-(-1)) {
				var property:PropertyInfo = properties[i];
				tempMethod = property.getGetter();
				if (tempMethod.getMethod() == concreteMethod) {
					return (method = tempMethod);
				}
				tempMethod = property.getSetter();
				if (tempMethod.getMethod() == concreteMethod) {
					return (method = tempMethod);
				}
			}
		}
		return method;
	}
	
	/**
	 * @see org.as2lib.env.except.StackTraceElement#getArguments()
	 */
	public function getArguments(Void):FunctionArguments {
		return this.args;
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ExceptConfig.getStackTraceElementStringifier().execute(this);
	}
}