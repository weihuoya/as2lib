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

import org.as2lib.util.ClassUtil;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.bean.BeanWrapper;
import org.as2lib.env.bean.SimpleBeanWrapper;
import org.as2lib.env.bean.PropertyValue;
import org.as2lib.env.bean.PropertyValueConverter;
import org.as2lib.env.bean.factory.BeanFactory;
import org.as2lib.env.bean.factory.FactoryBean;
import org.as2lib.env.bean.factory.BeanDefinitionStoreException;
import org.as2lib.env.bean.factory.NoSuchBeanDefinitionException;
import org.as2lib.env.bean.factory.BeanNotOfRequiredTypeException;
import org.as2lib.env.bean.factory.BeanNameAware;
import org.as2lib.env.bean.factory.BeanFactoryAware;
import org.as2lib.env.bean.factory.InitializingBean;
import org.as2lib.env.bean.factory.DisposableBean;
import org.as2lib.env.bean.factory.support.AbstractBeanFactory;
import org.as2lib.env.bean.factory.support.RootBeanDefinition;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.config.LifecycleCallbackBeanDefinition;
import org.as2lib.env.bean.factory.config.ConfigurableBeanFactory;
import org.as2lib.env.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.env.bean.factory.config.ConfigurableHierarchicalBeanFactory;
import org.as2lib.env.bean.factory.config.RuntimeBeanReference;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValue;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.factory.support.DefaultBeanFactory extends AbstractBeanFactory implements ConfigurableBeanFactory, ConfigurableListableBeanFactory, ConfigurableHierarchicalBeanFactory {
	
	//---------------------------------------------------------------------
	// Class data
	//---------------------------------------------------------------------
	
	public static var FACTORY_BEAN_PREFIX:String = "&";
	
	//---------------------------------------------------------------------
	// Instance data
	//---------------------------------------------------------------------
	
	private var beanDefinitionMap:Map;
	
	private var singletonBeanMap:Map;
	
	private var parentBeanFactory:BeanFactory;
	
	private var allowBeanDefinitionOverriding:Boolean;
	
	private var beanWrapper:BeanWrapper;
	
	//---------------------------------------------------------------------
	// Constructors
	//---------------------------------------------------------------------
	
	public function DefaultBeanFactory(parentBeanFactory:BeanFactory) {
		this.parentBeanFactory = parentBeanFactory;
		beanDefinitionMap = new PrimitiveTypeMap();
		singletonBeanMap = new PrimitiveTypeMap();
		allowBeanDefinitionOverriding = true;
	}
	
	//---------------------------------------------------------------------
	// Implementation methods
	//---------------------------------------------------------------------
	
	public function setBeanWrapper(beanWrapper:BeanWrapper):Void {
		this.beanWrapper = beanWrapper;
	}
	
	public function getBeanWrapper(Void):BeanWrapper {
		if (!beanWrapper) beanWrapper = new SimpleBeanWrapper(null);
		return beanWrapper;
	}
	
	public function registerBeanDefinition(beanName:String, beanDefinition:BeanDefinition):Void {
		if (!allowBeanDefinitionOverriding && beanDefinitionMap.containsKey(beanName)) {
			throw new BeanDefinitionStoreException("Bean name [" + beanName + "] must only be registered once in bean factory.", this, arguments);
		}
		beanDefinitionMap.put(beanName, beanDefinition);
	}
	
	public function setAllowBeanDefinitionOverriding(allowBeanDefinitionOverriding:Boolean):Void {
		this.allowBeanDefinitionOverriding = allowBeanDefinitionOverriding;
	}
	
	private function getBeanByNameAndBean(name:String, bean) {
		if (bean instanceof FactoryBean && name.indexOf(FACTORY_BEAN_PREFIX) != 0) {
			return FactoryBean(bean).getObject();
		} else {
			return bean;
		}
	}
	
	private function transformBeanName(name:String):String {
		var result:String = name;
		if (!name) {
			throw new NoSuchBeanDefinitionException("Cannot get bean with null name [" + name + "].", this, arguments);
		}
		if (name.indexOf(FACTORY_BEAN_PREFIX) == 0) {
			result = name.substring(FACTORY_BEAN_PREFIX.length);
		}
		return result;
	}
	
	private function createBean(beanName:String, beanDefinition:BeanDefinition) {
		var result = new Object();
		var beanClass:Function = beanDefinition.getBeanClass();
		result.__proto__ = beanClass.prototype;
		result.__constructor__ = beanClass;
		var constructorArguments:Array = beanDefinition.getConstructorArgumentValues().getArgumentValues();
		for (var i:Number = 0; i < constructorArguments.length; i++) {
			var argument:ConstructorArgumentValue = constructorArguments[i];
			if ((typeof(argument.getValue()) == "string" || argument.getValue() instanceof String) && argument.getType()) {
				var converter:PropertyValueConverter = getBeanWrapper().findPropertyValueConverter(argument.getType());
				if (converter) {
					constructorArguments[i] = converter.convertPropertyValueByStringValueAndType(argument.getValue(), argument.getType());
				} else {
					constructorArguments[i] = argument.getValue();
				}
			} else if (argument.getValue() instanceof RuntimeBeanReference) {
				constructorArguments[i] = getBeanByName(RuntimeBeanReference(argument.getValue()).getBeanName());
			} else {
				constructorArguments[i] = argument.getValue();
			}
		}
		beanDefinition.getBeanClass().apply(result, constructorArguments);
		if (result instanceof BeanNameAware) {
			BeanNameAware(result).setBeanName(beanName);
		}
		if (result instanceof BeanFactoryAware) {
			BeanFactoryAware(result).setBeanFactory(this);
		}
		getBeanWrapper().setWrappedObject(result);
		var propertyValues:Array = beanDefinition.getPropertyValues().getPropertyValues();
		for (var i:Number = 0; i < propertyValues.length; i++) {
			var propertyValue:PropertyValue = propertyValues[i];
			var value = propertyValue.getValue();
			if (value instanceof RuntimeBeanReference) {
				value = getBeanByName(RuntimeBeanReference(value).getBeanName());
			}
			getBeanWrapper().setPropertyValueByPropertyValue(new PropertyValue(propertyValue.getName(), value, propertyValue.getType()));
		}
		if (result instanceof InitializingBean) {
			InitializingBean(result).afterPropertiesSet();
		}
		if (beanDefinition instanceof LifecycleCallbackBeanDefinition) {
			var initMethodName:String = LifecycleCallbackBeanDefinition(beanDefinition).getInitMethodName();
			if (initMethodName) {
				result[initMethodName]();
			}
		}
		return result;
	}
	
	private function destroyBean(bean, beanDefinition:BeanDefinition) {
		if (bean instanceof DisposableBean) {
			DisposableBean(bean).destroy();
		}
		if (beanDefinition instanceof LifecycleCallbackBeanDefinition) {
			var destroyMethodName:String = LifecycleCallbackBeanDefinition(beanDefinition).getDestroyMethodName();
			if (destroyMethodName) {
				bean[destroyMethodName]();
			}
		}
	}
	
	//---------------------------------------------------------------------
	// Implementation of BeanFactory
	//---------------------------------------------------------------------
	
	public function containsBean(name:String):Boolean {
		return containsBeanDefinition(name);
	}
	
	public function getBeanByName(name:String) {
		var beanName:String = transformBeanName(name);
		try {
			var beanDefinition:BeanDefinition = getBeanDefinition(beanName);
			if (beanDefinition.isSingleton()) {
				if (singletonBeanMap.containsKey(beanName)) {
					return getBeanByNameAndBean(name, singletonBeanMap.get(beanName));
				} else {
					var bean = createBean(beanName, beanDefinition);
					singletonBeanMap.put(beanName, bean);
					return getBeanByNameAndBean(name, bean);
				}
			} else {
				return getBeanByNameAndBean(name, createBean(beanName, beanDefinition));
			}
		} catch (exception:org.as2lib.env.bean.factory.NoSuchBeanDefinitionException) {
			if (!getParentBeanFactory()) throw exception;
			return getParentBeanFactory().getBeanByName(name);
		}
	}
	
	public function getBeanByNameAndType(name:String, requiredType:Function) {
		var bean = getBeanByName(name);
		if (requiredType && !(bean instanceof requiredType)) {
			throw new BeanNotOfRequiredTypeException("Received bean is not of required type [" + requiredType + "].", this, arguments);
		}
		return bean;
	}
	
	public function isSingleton(beanName:String):Boolean {
		var beanDefinition:BeanDefinition = getBeanDefinition(beanName);
		if (ClassUtil.isImplementationOf(beanDefinition.getBeanClass(), FactoryBean)) {
			return FactoryBean(getBeanByName(FACTORY_BEAN_PREFIX + beanName)).isSingleton();
		} else {
			return getBeanDefinition(beanName).isSingleton();
		}
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableBeanFactory
	//---------------------------------------------------------------------
	
	public function registerSingleton(beanName:String, singleton):Void {
		registerBeanDefinition(beanName, new RootBeanDefinition(singleton.__constructor__));
		singletonBeanMap.put(beanName, singleton);
	}
	
	//---------------------------------------------------------------------
	// Implementation of HierarchicalBeanFactory
	//---------------------------------------------------------------------
	
	public function getParentBeanFactory(Void):BeanFactory {
		return parentBeanFactory;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableHierarchicalBeanFactory
	//---------------------------------------------------------------------
	
	public function setParentBeanFactory(parentBeanFactory:BeanFactory):Void {
		this.parentBeanFactory = parentBeanFactory;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ListableBeanFactory
	//---------------------------------------------------------------------
	
	public function containsBeanDefinition(name:String):Boolean {
		return beanDefinitionMap.containsKey(name);
	}
	
	public function getBeanDefinitionCount(Void):Number {
		return beanDefinitionMap.size();
	}
	
	public function getBeanDefinitionNamesByVoid(Void):Array {
		return beanDefinitionMap.getKeys();
	}
	
	public function getBeanDefinitionNamesByType(type:Function):Array {
		if (!type) return getBeanDefinitionNamesByVoid();
		var result:Array = new Array();
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanClass:Function = BeanDefinition(beanDefinitionMap.get(beanDefinitionNames[i])).getBeanClass();
			var currentBean = new Object();
			currentBean.__proto__ = beanClass.prototype;
			if (currentBean instanceof type) {
				result.push(beanDefinitionNames[i]);
			}
		}
		return result;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableListableBeanFactory
	//---------------------------------------------------------------------
	
	public function getBeanDefinition(beanName:String):BeanDefinition {
		var result:BeanDefinition = beanDefinitionMap.get(beanName);
		if (!result) {
			throw new NoSuchBeanDefinitionException("There is no bean definition with name [" + beanName + "].", this, arguments);
		}
		return result;
	}
	
}