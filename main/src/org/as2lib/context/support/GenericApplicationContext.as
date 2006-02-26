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
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.factory.support.DefaultBeanFactory;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.DefaultApplicationContext;
import org.as2lib.env.except.IllegalStateException;

/**
 * {@code GenericApplicationContext} is the application context of choice if refreshing
 * the application context more than once (which is required to initialize everything)
 * is not necessary and bean definitions are registered externally.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.GenericApplicationContext extends DefaultApplicationContext implements DisposableBean, BeanDefinitionRegistry {
	
	/**
	 * Constructs a new {@code GenericApplicationContext} instance.
	 * 
	 * @param parent the parent of this application context
	 */
	public function GenericApplicationContext(parent:ApplicationContext) {
		super(parent);
	}
	
	//---------------------------------------------------------------------
	// Implementation of BeanDefinitionRegistry
	//---------------------------------------------------------------------
	
	public function getBeanDefinition(beanName:String, includingAncestors:Boolean):BeanDefinition {
		return beanFactory.getBeanDefinition(beanName, includingAncestors);
	}
	
	public function registerBeanDefinition(beanName:String, beanDefinition:BeanDefinition):Void {
		beanFactory.registerBeanDefinition(beanName, beanDefinition);
	}
	
	public function registerAlias(beanName:String, alias:String):Void {
		beanFactory.registerAlias(beanName, alias);
	}
	
}