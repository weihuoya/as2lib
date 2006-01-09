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
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.BeanDefinition extends BasicInterface {
	
	/**
	 * 
	 */
	public function hasBeanClass(Void):Boolean;
	
	/**
	 * 
	 */
	public function getBeanClass(Void):Function;
	
	/**
	 * 
	 */
	public function getBeanClassName(Void):String;
	
	/**
	 * 
	 */
	public function getFactoryBeanName(Void):String;
	
	/**
	 * 
	 */
	public function getFactoryMethodName(Void):String;
	
	/**
	 * 
	 */
	public function getDependsOn(Void):Array;
	
	/**
	 * 
	 */
	public function getDependencyCheck(Void):Number;
	
	/**
	 * Return the autowire mode as specified in the bean definition.
	 */
	public function getAutowireMode(Void):Number;
	
	/**
	 * 
	 */
	public function getMethodOverrides(Void):MethodOverrides;
	
	/**
	 * 
	 */
	public function getInitMethodName(Void):String;
	
	/**
	 * 
	 */
	public function isEnforceInitMethod(Void):Boolean;
	
	/**
	 * 
	 */
	public function getDestroyMethodName(Void):String;
	
	/**
	 * 
	 */
	public function isEnforceDestroyMethod(Void):Boolean;
	
	/**
	 * 
	 */
	public function hasConstructorArgumentValues(Void):Boolean;
	
	/**
	 * Returns the argument values for this bean, if any. Can be modified during bean
	 * factory post-processing.
	 * 
	 * @return the argument values or {@code null}
	 */
	public function getConstructorArgumentValues(Void):ConstructorArgumentValues;
	
	/**
	 * 
	 */
	public function hasPropertyValues(Void):Boolean;
	
	/**
	 * Returns the property values to be applied to a new instance of this bean, if any.
	 * Can be modified during bean factory post-processing.
	 * 
	 * @return the property values or {@code null}
	 */
	public function getPropertyValues(Void):PropertyValues;
	
	/**
	 * Returns whether this bean is a singleton with a single shared instance returned
	 * on all calls.
	 * 
	 * @return {@code true} if this bean is a singleton else {@code false}
	 */
	public function isSingleton(Void):Boolean;
	
	/**
	 * Returns whether this bean should be lazily initialized, i.e. not eagerly
	 * instantiated on startup. Only applicable to a singleton bean.
	 */
	public function isLazyInit(Void):Boolean;
	
	/**
	 * Returns whether this bean is abstract, i.e. not meant to be instantiated.
	 * 
	 * @return {@code true} if this bean is abstract else {@code false}
	 */
	public function isAbstract(Void):Boolean;
	
	/**
	 * 
	 */
	public function validate(Void):Void;
	
}