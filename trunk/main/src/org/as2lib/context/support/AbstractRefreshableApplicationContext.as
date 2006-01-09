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

import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.support.DefaultBeanFactory;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.AbstractApplicationContext;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.except.IllegalStateException;

/**
 * @author Simon Wacker
 */
class org.as2lib.context.support.AbstractRefreshableApplicationContext extends AbstractApplicationContext {
	
	/** Bean factory for this context */
	private var beanFactory:ConfigurableListableBeanFactory;
	
	public function AbstractRefreshableApplicationContext(parent:ApplicationContext) {
		super(parent);
	}
	
	//---------------------------------------------------------------------
	// Implementations of AbstractApplicationContext's template methods
	//---------------------------------------------------------------------
	
	private function refreshBeanFactory(Void):Void {
		// Shut down previous bean factory, if any.
		if (beanFactory != null) {
			beanFactory.destroySingletons();
			beanFactory = null;
		}
		// Initialize fresh bean factory.
		var beanFactory:ConfigurableListableBeanFactory = createBeanFactory();
		loadBeanDefinitions(beanFactory);
		this.beanFactory = beanFactory;
	}
	
	public function getBeanFactory(Void):ConfigurableListableBeanFactory {
		if (beanFactory == null) {
			throw new IllegalStateException("BeanFactory not initialized - " +
					"call 'refresh' before accessing beans via this context: " + this + ".", this, arguments);

		}
		return beanFactory;
	}
	
	/**
	 * Create the bean factory for this context.
	 * <p>Default implementation creates a DefaultListableBeanFactory with the
	 * internal bean factory of this context's parent as parent bean factory.
	 * <p>Can be overridden in subclasses.
	 * @return the bean factory for this context
	 * @see org.springframework.beans.factory.support.DefaultListableBeanFactory
	 * @see #getInternalParentBeanFactory
	 */
	private function createBeanFactory(Void):ConfigurableListableBeanFactory {
		return new DefaultBeanFactory(getInternalParentBeanFactory());
	}
	
	/**
	 * Load bean definitions into the given bean factory, typically through
	 * delegating to one or more bean definition readers.
	 * @param beanFactory the bean factory to load bean definitions into
	 * @throws IOException if loading of bean definition files failed
	 * @throws BeansException if parsing of the bean definitions failed
	 * @see org.springframework.beans.factory.support.PropertiesBeanDefinitionReader
	 * @see org.springframework.beans.factory.xml.XmlBeanDefinitionReader
	 */
	private function loadBeanDefinitions(beanFactory:ConfigurableListableBeanFactory):Void {
		throw new AbstractOperationException("This method is marked as abstract and must be overridden by sub-classes.", this, arguments);
	}
	
}