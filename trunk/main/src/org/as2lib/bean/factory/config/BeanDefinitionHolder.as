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
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.BeanDefinitionHolder extends BasicClass {
	
	/** The held bean definition. */
	private var beanDefinition:BeanDefinition;
	
	/** The name of the bean. */
	private var beanName:String;
	
	/** The bean's aliases. */
	private var aliases:Array;
	
	/**
	 * Constructs a new {@code BeanDefinitionHolder} instance.
	 * 
	 * @param beanDefinition the bean definition to hold
	 * @param beanName the name of the bean
	 * @param aliases the alias names of the bean
	 */
	public function BeanDefinitionHolder(beanDefinition:BeanDefinition, beanName:String, aliases:Array) {
		this.beanDefinition = beanDefinition;
		this.beanName = beanName;
		this.aliases = aliases;
	}
	
	/**
	 * Returns the held bean definition.
	 * 
	 * @return the held bean definition
	 */
	public function getBeanDefinition(Void):BeanDefinition {
		return beanDefinition;
	}
	
	/**
	 * Returns the name of the bean.
	 * 
	 * @return the name of the bean
	 */
	public function getBeanName(Void):String {
		return beanName;
	}
	
	/**
	 * Returns the alias names of the bean.
	 * 
	 * @return the alias names of the bean
	 */
	public function getAliases(Void):Array {
		return aliases;
	}
	
	public function toString():String {
		return "Bean definition with name '" + beanName + "': " + beanDefinition + ".";
	}
	
}