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
import org.as2lib.env.bean.PropertyValueSet;
import org.as2lib.env.bean.MutablePropertyValueSet;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValueList;
import org.as2lib.env.bean.factory.config.MutableConstructorArgumentValueList;
import org.as2lib.env.bean.factory.BeanFactory;
import org.as2lib.env.bean.factory.BeanNameAware;
import org.as2lib.env.bean.factory.BeanFactoryAware;
import org.as2lib.env.bean.factory.DisposableBean;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.factory.support.SingletonBeanDefinition extends BasicClass implements BeanDefinition {
	
	private var beanClass:Function;
	private var argumentValues:ConstructorArgumentValueList;
	private var propertyValues:PropertyValueSet;
	private var beanName:String;
	private var beanFactory:BeanFactory;
	private var singleton;
	
	public function SingletonBeanDefinition(beanName:String, beanFactory:BeanFactory, singleton) {
		this.beanName = beanName;
		this.beanFactory = beanFactory;
		this.singleton = singleton;
		beanClass = singleton.__constructor__;
		argumentValues = new MutableConstructorArgumentValueList();
		propertyValues = new MutablePropertyValueSet();
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
		return true;
	}
	
	public function createBean(Void) {
		if (singleton instanceof BeanNameAware) {
			BeanNameAware(singleton).setBeanName(beanName);
		}
		if (singleton instanceof BeanFactoryAware) {
			BeanFactoryAware(singleton).setBeanFactory(beanFactory);
		}
		return singleton;
	}
	
	public function destroyBean(bean):Void {
		if (bean instanceof DisposableBean) {
			DisposableBean(bean).destroy();
		}
	}
	
}