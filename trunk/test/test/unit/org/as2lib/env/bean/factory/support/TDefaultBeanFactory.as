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

import org.as2lib.test.unit.TestCase;
import org.as2lib.env.bean.factory.support.DefaultBeanFactory;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.BeanDefinitionStoreException;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.factory.support.TDefaultBeanFactory extends TestCase {
	
	public function testRegisterBeanDefinitionForMultipleRegistrationWithSameName(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = new BeanDefinition();
		factory.registerBeanDefinition("beanName", bd);
		assertThrows("Method should throw an exception in case one tries to overwrite a bean definition in the same bean factory.", BeanDefinitionStoreException, factory, factory.registerBeanDefinition, ["beanName", bd]);
	}
	
}