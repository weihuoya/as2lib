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
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.PropertyAccessException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyAccessExceptionsException extends BeanException {
	
	private var beanWrapper:BeanWrapper;
	private var propertyAccessExceptions:Array;
	
	public function PropertyAccessExceptionsException(beanWrapper:BeanWrapper, propertyAccessExceptions:Array, args:Array) {
		super(null, beanWrapper, args);
		this.beanWrapper = beanWrapper;
		this.propertyAccessExceptions = propertyAccessExceptions;
	}
	
	public function getBeanWrapper(Void):BeanWrapper {
		return beanWrapper;
	}
	
	public function getPropertyAccessExceptions(Void):Array {
		return propertyAccessExceptions.concat();
	}
	
	public function getBean(Void) {
		return beanWrapper.getWrappedBean();
	}
	
	public function getExceptionCount(Void):Number {
		return propertyAccessExceptions.length;
	}
	
	public function getPropertyAccessException(propertyName:String):PropertyAccessException {
		for (var i:Number = 0; i < propertyAccessExceptions.length; i++) {
			var pae:PropertyAccessException = propertyAccessExceptions[i];
			if (propertyName == pae.getPropertyName()) {
				return pae;
			}
		}
		return null;
	}
	
	public function getMessage(Void):String {
		var result:String = "PropertyAccessExceptionsException (" + getExceptionCount() + " errors)";
		result += "; nested propertyAccessExceptions are: ";
		for (var i:Number = 0; i < propertyAccessExceptions.length; i++) {
			var pae:PropertyAccessException = this.propertyAccessExceptions[i];
			result += "[";
			result += ReflectUtil.getTypeNameForInstance(pae);
			result += ": ";
			result += pae.getMessage();
			result += "]";
			if (i < propertyAccessExceptions.length - 1) {
				result += ", ";
			}
		}
		return result;
	}
	
}