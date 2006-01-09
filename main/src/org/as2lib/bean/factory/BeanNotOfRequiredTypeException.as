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

import org.as2lib.bean.BeanException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanNotOfRequiredTypeException extends BeanException {
	
	private var beanName:String;
	private var requiredType:Function;
	private var actualType:Function;
	
	public function BeanNotOfRequiredTypeException(beanName:String, requiredType:Function, actualType:Function, scope, args:Array) {
		super(null, scope, args);
		this.beanName = beanName;
		this.requiredType = requiredType;
		this.actualType = actualType;
	}
	
	public function getMessage(Void):String {
		if (message == null) {
			message = "Bean named '" + beanName + "' must be of type [" + ReflectUtil.getTypeNameForType(requiredType) +
					"], but was actually of type [" + ReflectUtil.getTypeNameForType(actualType) + "]";
		}
		return message;
	}
	
	public function getBeanName(Void):String {
		return beanName;
	}
	
	public function getRequiredType(Void):Function {
		return requiredType;
	}
	
	public function getActualType(Void):Function {
		return actualType;
	}
	
}