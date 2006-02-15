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
	 * @overload RootBeanDefinitionByClass
	 * @overload RootBeanDefinitionByClassAndPropertyValuesAndSingleton
	 * @overload RootBeanDefinitionByClassAndSingleton
	 * @overload RootBeanDefinitionByClassAndAutowireAndDependency
	 * @overload RootBeanDefinitionBySource
	 */
	public function RootBeanDefinition() {
		var o:Overload = new Overload(this);
		o.addHandler([], RootBeanDefinitionByValues);
		o.addHandler([Function], RootBeanDefinitionByClassAndPropertyValuesAndSingleton);
		o.addHandler([Function, PropertyValues], RootBeanDefinitionByClassAndPropertyValuesAndSingleton);
		o.addHandler([Function, PropertyValues, Boolean], RootBeanDefinitionByClassAndPropertyValuesAndSingleton);
		o.addHandler([Function, Boolean], RootBeanDefinitionByClassAndSingleton);
		o.addHandler([Function, Number, Boolean], RootBeanDefinitionByClassAndAutowireAndDependency);
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
	 * Constructs a new {@code RootBeanDefinition} with the given bean class, property
	 * values and singleton flag.
	 * 
	 * @param beanClass the class of the bean
	 * @param propertyValues the property values
	 * @param singleton whether the defined bean is a singleton
	 */
	private function RootBeanDefinitionByClassAndPropertyValuesAndSingleton(beanClass:Function, propertyValues:PropertyValues, singleton:Boolean):Void {
		setBeanClass(beanClass);
		if (propertyValues != null) {
			setPropertyValues(propertyValues);
		}
		if (singleton != null) {
			setSingleton(singleton);
		}
	}
	
	/**
	 * Constructs a new {@code RootBeanDefinition} with the given bean class and
	 * singleton flag.
	 * 
	 * @param beanClass the class of the bean
	 * @param singleton whether the defined bean is a singleton
	 */
	private function RootBeanDefinitionByClassAndSingleton(beanClass:Function, singleton:Boolean):Void {
		RootBeanDefinitionByClassAndPropertyValuesAndSingleton(beanClass, null, singleton);
	}
	
	/**
	 * Constructs a new {@code RootBeanDefinition} with the given bean class, autowire
	 * mode and dependency check code.
	 * 
	 * @param beanClass the class of the bean
	 * @param autowireMode the autowire mode
	 * @param dependencyCheck the dependency check code
	 */
	private function RootBeanDefinitionByClassAndAutowireAndDependency(beanClass:Function, autowireMode:Number, dependencyCheck:Boolean):Void {
		setBeanClass(beanClass);
		setAutowireMode(autowireMode);
		if (dependencyCheck) {
			setDependencyCheck(DEPENDENCY_CHECK_OBJECTS);
		}
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
		setAbstract(source.isAbstract());
		setSingleton(source.isSingleton());
		setLazyInit(source.isLazyInit());
		setAutowireMode(source.getAutowireMode());
		setDependencyCheck(source.getDependencyCheck());
		setDependsOn(source.getDependsOn());
		setConstructorArgumentValues(new ConstructorArgumentValues(source.getConstructorArgumentValues()));
		setPropertyValues(new PropertyValues(source.getPropertyValues()));
		setMethodOverrides(new MethodOverrides(source.getMethodOverrides()));
		setFactoryBeanName(source.getFactoryBeanName());
		setFactoryMethodName(source.getFactoryMethodName());
		setInitMethodName(source.getInitMethodName());
		setEnforceInitMethod(source.isEnforceInitMethod());
		setDestroyMethodName(source.getDestroyMethodName());
		setEnforceDestroyMethod(source.isEnforceDestroyMethod());
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