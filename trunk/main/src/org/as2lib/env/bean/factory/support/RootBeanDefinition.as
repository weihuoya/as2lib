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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.bean.PropertyValueSet;
import org.as2lib.env.bean.MutablePropertyValueSet;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValueList;
import org.as2lib.env.bean.factory.config.MutableConstructorArgumentValueList;
import org.as2lib.env.bean.factory.BeanFactory;
import org.as2lib.env.bean.factory.BeanNameAware;
import org.as2lib.env.bean.factory.BeanFactoryAware;
import org.as2lib.env.bean.factory.InitializingBean;
import org.as2lib.env.bean.factory.DisposableBean;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.factory.support.RootBeanDefinition extends BasicClass implements BeanDefinition {
	
	private var beanClass:Function;
	private var argumentValues:ConstructorArgumentValueList;
	private var propertyValues:PropertyValueSet;
	private var singleton:Boolean;
	private var destroyMethodName:String;
	private var initMethodName:String;
	private var beanName:String;
	private var beanFactory:BeanFactory;
	
	public function RootBeanDefinition() {
		var o:Overload = new Overload(this);
		o.addHandler([Function], RootBeanDefinitionByClass);
		o.addHandler([Function, PropertyValueSet], RootBeanDefinitionByClassAndPropertyValues);
		o.addHandler([Function, ConstructorArgumentValueList, PropertyValueSet], RootBeanDefinitionByClassAndArgumentValuesAndPropertyValues);
		o.forward(arguments);
	}
	
	private function RootBeanDefinitionByClass(beanClass:Function):Void {
		RootBeanDefinitionByClassAndPropertyValues(beanClass, new MutablePropertyValueSet());
	}
	
	private function RootBeanDefinitionByClassAndPropertyValues(beanClass:Function, propertyValues:PropertyValueSet):Void {
		RootBeanDefinitionByClassAndArgumentValuesAndPropertyValues(beanClass, new MutableConstructorArgumentValueList(), propertyValues);
	}
	
	private function RootBeanDefinitionByClassAndArgumentValuesAndPropertyValues(beanClass:Function, argumentValues:ConstructorArgumentValueList, propertyValues:PropertyValueSet):Void {
		this.beanClass = beanClass;
		this.argumentValues = argumentValues;
		this.propertyValues = propertyValues;
	}
	
	public function setSingleton(singleton:Boolean):Void {
		this.singleton = singleton;
	}
	
	public function setConstructorArgumentValues(argumentValues:ConstructorArgumentValueList):Void {
		this.argumentValues = argumentValues;
	}
	
	public function setPropertyValues(propertyValues:PropertyValueSet):Void {
		this.propertyValues = propertyValues;
	}

	public function getBeanClass(Void):Function {
		return beanClass;
	}
	
	public function getConstructorArgumentValues(Void):ConstructorArgumentValueList {
		return argumentValues;
	}
	
	public function getPropertyValues(Void):PropertyValueSet {
		return propertyValues;
	}
	
	public function isSingleton(Void):Boolean {
		return singleton;
	}
	
	public function getDestroyMethodName(Void):String {
		return destroyMethodName;
	}
	
	public function setDestroyMethodName(destroyMethodName:String):Void {
		this.destroyMethodName = destroyMethodName;
	}
	
	public function getInitMethodName(Void):String {
		return initMethodName;
	}
	
	public function setInitMethodName(initMethodName:String):Void {
		this.initMethodName = initMethodName;
	}
	
	public function createBean(Void) {
		var result = new Object();
		result.__proto__ = beanClass.prototype;
		beanClass.apply(result, argumentValues.getArgumentValues());
		if (result instanceof BeanNameAware) {
			BeanNameAware(result).setBeanName(beanName);
		}
		if (result instanceof BeanFactoryAware) {
			BeanFactoryAware(result).setBeanFactory(beanFactory);
		}
		propertyValues.apply(result);
		if (result instanceof InitializingBean) {
			InitializingBean(result).afterPropertiesSet();
		}
		if (initMethodName) {
			result[initMethodName]();
		}
		return result;
	}
	
	public function destroyBean(bean):Void {
		if (bean instanceof DisposableBean) {
			DisposableBean(bean).destroy();
		}
		if (destroyMethodName) {
			bean[destroyMethodName]();
		}
	}
	
}