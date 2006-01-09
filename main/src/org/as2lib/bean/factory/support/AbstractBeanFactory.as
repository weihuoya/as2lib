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
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.AbstractBeanFactory extends BasicClass {
	
	/**
	 * Used to dereference a FactoryBean and distinguish it from beans
	 * <i>created</i> by the FactoryBean. For example, if the bean named
	 * <code>myEjb</code> is a FactoryBean, getting <code>&myEjb</code> will
	 * return the factory, not the instance returned by the factory.
	 */
	public static var FACTORY_BEAN_PREFIX:String = "&";
	
	/**
	 * Constant that indicates no autowiring at all
	 * (other than callbacks such as BeanFactoryAware).
	 * @see #createBean
	 * @see #autowire
	 * @see #autowireBeanProperties
	 */
	public static var AUTOWIRE_NO:Number = 0;

	/**
	 * Constant that indicates autowiring bean properties by name.
	 * @see #createBean
	 * @see #autowire
	 * @see #autowireBeanProperties
	 */
	public static var AUTOWIRE_BY_NAME:Number = 1;
	
	private var thiz:BeanFactory;
	
	private function AbstractBeanFactory(Void) {
		thiz = BeanFactory(this);
	}
	
	/**
	 * @overload #getBeanByName
	 * @overload #getBeanByNameAndType
	 * @overload #getBeanByNameAndArguments
	 * @overload #getBeanByNameAndTypeAndArguments
	 */
	public function getBean() {
		var o:Overload = new Overload(this);
		o.addHandler([String], thiz.getBeanByName);
		o.addHandler([String, Function], thiz.getBeanByNameAndType);
		return o.forward(arguments);
	}
	
}