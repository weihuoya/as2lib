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
 * {@code DefaultApplicationContext} is the base class for most application contexts.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.DefaultApplicationContext extends AbstractApplicationContext {
	
	/** The wrapped bean factory to delegate bean managing tasks to. */
	private var beanFactory:DefaultBeanFactory;
	
	/** Indicates whether this application context has already been refreshed. */
	private var refreshed:Boolean;
	
	/**
	 * Constructs a new {@code DefaultApplicationContext} instance.
	 * 
	 * @param parent the parent of this application context
	 */
	public function DefaultApplicationContext(parent:ApplicationContext) {
		beanFactory = createBeanFactory();
		refreshed = false;
		setParent(parent);
	}
	
	/**
	 * Sets the parent of this application context, also setting the parent of the
	 * internal bean factory accordingly.
	 * 
	 * @param parent the parent of this application context
	 */
	public function setParent(parent:ApplicationContext):Void {
		super.setParent(parent);
		beanFactory.setParentBeanFactory(getInternalParentBeanFactory());
	}
	
	/**
	 * Creates the bean factory for this context.
	 * 
	 * <p>Default implementation creates a {@link DefaultListableBeanFactory} with the
	 * internal bean factory of this context's parent as parent bean factory.
	 * 
	 * <p>Can be overridden in subclasses.
	 * 
	 * @return the bean factory for this context
	 * @see #getInternalParentBeanFactory
	 */
	private function createBeanFactory(Void):DefaultBeanFactory {
		return new DefaultBeanFactory(getInternalParentBeanFactory());
	}
	
	//---------------------------------------------------------------------
	// Implementations of AbstractApplicationContext's template methods
	//---------------------------------------------------------------------
	
	/**
	 * Does nothing: We hold a single internal bean factory and rely on callers to
	 * register beans through our public methods.
	 * 
	 * @see #registerBeanDefinition
	 */
	private function refreshBeanFactory(Void):Void {
		if (refreshed) {
			throw new IllegalStateException("Multiple refreshs not supported: just call 'refresh' once", this, arguments);
		}
		refreshed = true;
	}
	
	/**
	 * Returns the single internal bean factory held by this context.
	 * 
	 * @return the single internal bean factory of this context
	 */
	public function getBeanFactory(Void):ConfigurableListableBeanFactory {
		return beanFactory;
	}
	
}