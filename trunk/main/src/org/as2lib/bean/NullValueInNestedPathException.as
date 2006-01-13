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

import org.as2lib.bean.InvalidPropertyException;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.NullValueInNestedPathException extends InvalidPropertyException {
	
	public function NullValueInNestedPathException(bean, propertyName:String, message:String, scope, args:Array) {
		super(bean, propertyName, (message == null ? "Value of nested property '" + propertyName + "' is 'null'." : message), scope, args);
	}
	
}