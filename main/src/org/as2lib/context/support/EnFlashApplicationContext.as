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
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.DefaultApplicationContext;

import com.asual.enflash.EnFlash;
import com.asual.enflash.EnFlashObject;

/**
 * {@code EnFlashApplicationContext} provides special support for enflash applications.
 * The idea behind this is to use EnFlash for the visual part of the application and
 * As2lib Context for the control and business part.
 * 
 * <p>This context allows you to specify a target enflash application. The instances of
 * that application that have an id can be referenced by other beans of this context
 * (as simple bean references, as if the enflash instances were beans), for example
 * controller beans, to manage the control flow.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.EnFlashApplicationContext extends DefaultApplicationContext {
	
	/** The internal enflash application. */
	private var enFlash:EnFlash;
	
	/**
	 * Constructs a new {@code EnFlashApplicationContext} instance.
	 * 
	 * @param enFlash the enflash application holding instances that may be referenced
	 * by beans of this context
	 */
	public function EnFlashApplicationContext(enFlash:EnFlash, parent:ApplicationContext) {
		super(parent);
		this.enFlash = enFlash;
	}
	
	/**
	 * Returns the the internal enflash application.
	 * 
	 * @return the internal enflash application
	 */
	public function getEnFlash(Void):EnFlash {
		return enFlash;
	}
	
	/**
	 * Loads the instances from the internal enflash application and registers them as
	 * singleton beans with their id as bean names on the bean factory.
	 * 
	 * <p>These beans may then be referenced by other beans of this context.
	 * 
	 * @param beanFactory the bean factory to register beans on
	 */
	private function refreshBeanFactory(Void):Void {
		super.refreshBeanFactory();
		var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
		// TODO: Ask EnFlash developers to implement 'getObjects' method.
		var beans:Array = enFlash["_objects"];
		for (var i:Number = 0; i < beans.length; i++) {
			var bean:EnFlashObject = beans[i];
			var id:String = bean.id;
			if (id != null && id != "") {
				beanFactory.registerSingleton(id, bean);
			}
		}
	}
	
}