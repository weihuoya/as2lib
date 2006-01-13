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

import org.as2lib.bean.FatalBeanException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.InvalidPropertyException extends FatalBeanException {
	
	private var bean;
	private var propertyName:String;
	
	public function InvalidPropertyException(bean, propertyName:String, message:String, scope, args:Array) {
		super("Invalid property '" + propertyName + "' of bean class [" + ReflectUtil.getTypeName(bean) + "]: " + message, scope, args);
		this.bean = bean;
		this.propertyName = propertyName;
	}
	
	public function getBean(Void) {
		return bean;
	}
	
	public function getPropertyName(Void):String {
		return propertyName;
	}

}