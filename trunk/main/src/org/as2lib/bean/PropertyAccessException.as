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

/**
 * {@code PropertyAccessException} is the super-class for exceptions related to
 * a property access, such as type mismatch or method invocation exception.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyAccessException extends BeanException {
	
	/** The name of the property that could not be accessed. */
	private var propertyName:String;
	
	/**
	 * Constructs a new {@code PropertyAccessException} instance.
	 * 
	 * @param propertyName the name of the property that could not be accessed
	 * @param message the message describing this exception in detail
	 * @param scope the {@code this}-scope of the method throwing this exception
	 * @param args the arguments passed to the method that throws this exception
	 */
	public function PropertyAccessException(propertyName:String, message:String, scope, args:Array) {
		// TODO: Add 'bean' as additional parameter.
		super(message, scope, args);
		this.propertyName = propertyName;
	}
	
	/**
	 * Returns the name of the property that could not be accessed.
	 * 
	 * @return the name of the property that could not bea accessed
	 */
	public function getPropertyName(Void):String {
		return propertyName;
	}
	
}