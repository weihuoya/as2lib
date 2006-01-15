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
import org.as2lib.context.support.AbstractRefreshableApplicationContext;

import com.asual.enflash.EnFlash;
import com.asual.enflash.EnFlashObject;

/**
 * @author Simon Wacker
 */
class org.as2lib.context.support.EnFlashApplicationContext extends AbstractRefreshableApplicationContext {
	
	private var enFlash:EnFlash;
	
	public function EnFlashApplicationContext(enFlash:EnFlash, parent:ApplicationContext) {
		super(parent);
		this.enFlash = enFlash;
	}
	
	public function getEnFlash(Void):EnFlash {
		return enFlash;
	}
	
	private function loadBeanDefinitions(beanFactory:ConfigurableListableBeanFactory):Void {
		// TODO: Ask EnFlash developers to implement 'getObjects' method.
		var beans:Array = enFlash["_objects"];
		for (var i:Number = 0; i < beans.length; i++) {
			var bean:EnFlashObject = beans[i];
			beanFactory.registerSingleton(bean.id, bean);
		}
		// TODO: Load XML bean definitions?
	}
	
}