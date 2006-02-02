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

import org.as2lib.bean.PropertyAccessException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.TypeMismatchException extends PropertyAccessException {
	
	public function TypeMismatchException(propertyName:String, propertyValue, requiredType:Function, message:String, scope, args:Array) {
		super(propertyName, 
				"Failed to convert property value of type [" +
				(propertyValue != null ? ReflectUtil.getTypeName(propertyValue) : null) + "]" +
				(requiredType != null ? " to required type [" + ReflectUtil.getTypeNameForType(requiredType) + "]" : "") +
				(propertyName != null ? " for property '" + propertyName + "'" : "") +
				(message != null ? ": " + message : ""), scope, args);
	}
	
}