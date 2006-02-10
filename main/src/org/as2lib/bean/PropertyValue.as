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

/**
 * {@code PropertyValue} holds information and value for an indivudual property.
 * 
 * <p>Note that the value does not need to be the final required type: A bean wrapper
 * should handle any necessary conversion.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValue extends BasicClass {
	
	private var name:String;
	private var value;
	private var type:Function;
	
	/**
	 * Constructs a new {@code PropertyValue} instance.
	 * 
	 * @param name the name of the property
	 * @param value the value to set for the property
	 * @param type the type to convert the value to
	 */
	public function PropertyValue(name:String, value, type:Function) {
		this.name = name;
		this.value = value;
		this.type = type;
	}
	
	/**
	 * Returns the name of the property.
	 * 
	 * @return the name of the property
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the value to set for the property.
	 * 
	 * @return the value to set for the property
	 */
	public function getValue(Void) {
		return value;
	}
	
	/**
	 * Returns the type to convert the value to.
	 * 
	 * @return the type to convert the value to
	 */
	public function getType(Void):Function {
		return type;
	}
	
	/**
	 * Returns the string representation of this property value.
	 * 
	 * @return the string representation of this property value
	 */
	public function toString():String {
		return (name + "=" + value);
	}
	
}