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

import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionValidationException;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.PropertyValues;
import org.as2lib.env.overload.Overload;

/**
 * {@code RootBeanDefinition} is the most common type of bean definition. Root bean
 * definitions do not derive from a parent bean definition, and usually have a class
 * plus optionally constructor argument values and property values.
 * 
 * <p>Note that root bean definitions do not have to specify a bean class: This can be
 * useful for deriving childs from such definitions, each with its own bean class but
 * inheriting common property values and other settings.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.RootBeanDefinition extends AbstractBeanDefinition implements BeanDefinition {
	
	/**
	 * @overload RootBeanDefinitionByValues
	 * @overload RootBeanDefinitionBySource
	 */
	public function RootBeanDefinition() {
		var o:Overload = new Overload(this);
		o.addHandler([ConstructorArgumentValues, PropertyValues], RootBeanDefinitionByValues);
		o.addHandler([AbstractBeanDefinition], RootBeanDefinitionBySource);
		o.forward(arguments);
	}
	
	/**
	 * Constructs a new {@code RootBeanDefinition} with the given constructor argument
	 * and property values.
	 * 
	 * @param constructorArgumentValues the constructor argument values
	 * @param propertyValues the property values
	 */
	private function RootBeanDefinitionByValues(constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues):Void {
		setConstructorArgumentValues(constructorArgumentValues);
		setPropertyValues(propertyValues);
	}
	
	/**
	 * Constructs a new {@code RootBeanDefinition} by copying the given source bean
	 * definition.
	 * 
	 * @param source the bean definition to copy
	 */
	private function RootBeanDefinitionBySource(source:AbstractBeanDefinition):Void {
		if (source.hasBeanClass()) {
			setBeanClass(source.getBeanClass());
		}
		abstract = source.isAbstract();
		singleton = source.isSingleton();
		lazyInit = source.isLazyInit();
		autowireMode = source.getAutowireMode();
		dependencyCheck = source.getDependencyCheck();
		dependsOn = source.getDependsOn();
		constructorArgumentValues = new ConstructorArgumentValues(source.getConstructorArgumentValues());
		propertyValues = new PropertyValues(source.getPropertyValues());
		methodOverrides = new MethodOverrides(source.getMethodOverrides());
		factoryBeanName = source.getFactoryBeanName();
		factoryMethodName = source.getFactoryMethodName();
		initMethodName = source.getInitMethodName();
		enforceInitMethod = source.isEnforceInitMethod();
		destroyMethodName = source.getDestroyMethodName();
		enforceDestroyMethod = source.isEnforceDestroyMethod();
		defaultPropertyName = source.getDefaultPropertyName();
	}
	
	public function validate(Void):Void {
		super.validate();
		if (hasBeanClass()) {
			if (getBeanClass().prototype instanceof FactoryBean && !isSingleton()) {
				throw new BeanDefinitionValidationException("Factory bean must be defined as singleton - " +
						"Factory beans themselves are not allowed to be prototypes.", this, arguments);
			}
		}
	}
	
	public function toString():String {
		return "Root bean: " + super.toString();
	}
	
}