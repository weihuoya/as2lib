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
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.ListableBeanFactory;
import org.as2lib.bean.PropertyValueConverter;

/**
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.ConfigurableListableBeanFactory extends ListableBeanFactory {
	
	public function getBeanDefinition(beanName:String, includingAncestors:Boolean):BeanDefinition;
	public function preInstantiateSingletons(Void):Void;
	
	public function containsSingleton(beanName:String):Boolean;
	public function registerSingleton(beanName:String, singleton):Void;
	public function destroySingletons(Void):Void;
	public function registerAlias(beanName:String, alias:String):Void;
	public function addBeanPostProcessor(beanPostProcessor:BeanPostProcessor):Void;
	public function getBeanPostProcessorCount(Void):Number;
	public function registerPropertyValueConverter(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void;
	public function setParentBeanFactory(parentBeanFactory:BeanFactory):Void;
	
}