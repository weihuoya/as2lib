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

import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionValidationException;
import org.as2lib.bean.PropertyValues;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ChildBeanDefinition extends AbstractBeanDefinition implements BeanDefinition {
	
	/** The name of the parent bean definition. */
	private var parentName:String;
	
	public function ChildBeanDefinition(parentName:String, constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues) {
		super(constructorArgumentValues, propertyValues);
		this.parentName = parentName;
	}
	
	/**
	 * Returns the name of the parent definition of this bean definition.
	 */
	public function getParentName(Void):String {
		return parentName;
	}
	
	public function validate(Void):Void {
		super.validate();
		if (parentName == null) {
			throw new BeanDefinitionValidationException("The name of the parent must be set in child bean definitions.", this, arguments);
		}
	}
	
	public function toString():String {
		return ("Child bean with parent '" + parentName + "': " + super.toString());
	}
	
}