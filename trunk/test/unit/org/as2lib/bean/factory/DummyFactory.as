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

import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.bean.factory.support.DefaultBeanFactory;
import org.as2lib.bean.TestBean;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Exception;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.DummyFactory extends BasicClass implements FactoryBean, BeanNameAware, BeanFactoryAware, InitializingBean, DisposableBean {
	
	public static var SINGLETON_NAME:String = "Factory singleton";

	private static var prototypeCreated:Boolean;

	/**
	 * Clear static state.
	 */
	public static function reset(Void):Void {
		prototypeCreated = false;
	}

	/**
	 * Default is for factories to return a singleton instance.
	 */
	private var singleton:Boolean;

	private var beanName:String;

	private var beanFactory:DefaultBeanFactory;

	private var postProcessed:Boolean;

	private var initialized:Boolean;

	private var testBean:TestBean;

	private var otherTestBean:TestBean;


	public function DummyFactory(Void) {
		this.testBean = new TestBean();
		this.testBean.setName(SINGLETON_NAME);
		this.testBean.setAge(25);
		singleton = true;
	}

	/**
	 * Return if the bean managed by this factory is a singleton.
	 * @see org.springframework.beans.factory.FactoryBean#isSingleton()
	 */
	public function isSingleton(Void):Boolean {
		return singleton;
	}

	/**
	 * Set if the bean managed by this factory is a singleton.
	 */
	public function setSingleton(singleton:Boolean):Void {
		this.singleton = singleton;
	}

	public function setBeanName(beanName:String):Void {
		this.beanName = beanName;
	}

	public function getBeanName(Void):String {
		return beanName;
	}

	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.beanFactory = DefaultBeanFactory(beanFactory);
		this.beanFactory.applyBeanPostProcessorsBeforeInitialization(this.testBean, this.beanName);
	}

	public function getBeanFactory(Void):BeanFactory {
		return beanFactory;
	}

	public function setPostProcessed(postProcessed:Boolean):Void {
		this.postProcessed = postProcessed;
	}

	public function isPostProcessed(Void):Boolean {
		return postProcessed;
	}

	public function setOtherTestBean(otherTestBean:TestBean):Void {
		this.otherTestBean = otherTestBean;
	}

	public function getOtherTestBean(Void):TestBean {
		return otherTestBean;
	}

	public function afterPropertiesSet(Void):Void {
		if (initialized) {
			throw new Exception("Cannot call afterPropertiesSet twice on the one bean");
		}
		this.initialized = true;
	}
	
	/**
	 * Was this initialized by invocation of the
	 * afterPropertiesSet() method from the InitializingBean interface?
	 */
	public function wasInitialized(Void):Boolean {
		return initialized;
	}

	public static function wasPrototypeCreated(Void):Boolean {
		return prototypeCreated;
	}

	/**
	 * Return the managed object, supporting both singleton
	 * and prototype mode.
	 * @see org.springframework.beans.factory.FactoryBean#getObject()
	 */
	public function getObject(Void) {
		if (isSingleton()) {
			return this.testBean;
		}
		else {
			var prototype:TestBean = new TestBean("prototype created at " + (new Date()).getTime(), 11);
			if (this.beanFactory != null) {
				this.beanFactory.applyBeanPostProcessorsBeforeInitialization(prototype, this.beanName);
			}
			prototypeCreated = true;
			return prototype;
		}
	}

	public function getObjectType(Void):Function {
		return TestBean;
	}


	public function destroy(Void):Void {
		if (this.testBean != null) {
			this.testBean.setName(null);
		}
	}

}