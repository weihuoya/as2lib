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

import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.bean.factory.BeanFactory;
import org.as2lib.env.bean.factory.FactoryBean;
import org.as2lib.env.bean.factory.BeanDefinitionStoreException;
import org.as2lib.env.bean.factory.NoSuchBeanDefinitionException;
import org.as2lib.env.bean.factory.BeanNotOfRequiredTypeException;
import org.as2lib.env.bean.factory.support.AbstractBeanFactory;
import org.as2lib.env.bean.factory.support.SingletonBeanDefinition;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.config.ConfigurableBeanFactory;
import org.as2lib.env.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.env.bean.factory.config.ConfigurableHierarchicalBeanFactory;

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
					var result = beanDefinition.createBean();
					singletonBeanMap.put(beanName, result);
					return getBeanByNameAndBean(name, result);
				}
			} else {
				return getBeanByNameAndBean(name, beanDefinition.createBean());
			}
		} catch (exception:org.as2lib.env.bean.factory.NoSuchBeanDefinitionException) {
			return getParentBeanFactory().getBeanByName(name);
		}
	}
	
	public function getBeanByNameAndType(name:String, requiredType:Function) {
		var bean = getBeanByName(name);
		if (!(bean instanceof requiredType)) {
			throw new BeanNotOfRequiredTypeException("Received bean is not of required type [" + requiredType + "].", this, arguments);
		}
		return bean;
	}
	
	public function isSingleton(beanName:String):Boolean {
		var beanDefinition:BeanDefinition = getBeanDefinition(beanName);
		if (beanDefinition.getBeanClass() == FactoryBean 
				|| beanDefinition.getBeanClass().prototype instanceof FactoryBean) {
			return FactoryBean(getBean(FACTORY_BEAN_PREFIX + beanName)).isSingleton();
		} else {
			return getBeanDefinition(beanName).isSingleton();
		}
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableBeanFactory
	//---------------------------------------------------------------------
	
	public function registerSingleton(beanName:String, singleton):Void {
		registerBeanDefinition(beanName, new SingletonBeanDefinition(beanName, this, singleton));
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