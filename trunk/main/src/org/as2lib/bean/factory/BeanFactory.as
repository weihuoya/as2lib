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

import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.BeanFactory extends BasicInterface {
	
	/**
	 * Checks whether this bean factory contains a bean definition with the given 
	 * {@code beanName}. The parent factory will be asked if the bean cannot be found
	 * in this factory.
	 * 
	 * @param name the name of the bean to query
	 * @return {@code true} if a bean with the given name is defined else {@code false}
	 */
	public function containsBean(name:String):Boolean;
	
	/**
	 * @overload #getBeanByName
	 * @overload #getBeanByNameAndType
	 */
	public function getBean();
	
	/**
	 * Returns an instance, which may be shared or independent, of the given bean name.
	 * This method allows a bean factory to be used as a replacement for the singleton
	 * or prototype design patterns.
	 * 
	 * <p>Callers may retain references to returned objects in the case of singleton
	 * beans.
	 * 
	 * <p>This method delegates to the parent factory if the bean cannot be found in
	 * this factory. 
	 * 
	 * @param name the name of the bean to return
	 * @return the bean instance
	 * @throws NoSuchBeanDefinitionException if there is no bean definition with the
	 * specified name 
     * @throws BeanException if the bean could not be obtained
	 */
	public function getBeanByName(name:String);
	
	/**
	 * Returns an instance (possibly shared or independent) of the given bean name.
	 * 
	 * <p>Behaves the same as {@link #getBeanByName}, but provides a measure of type
	 * safety by throwing an exception if the bean is not of the required type. This
	 * means that class cast errors will not happen when casting the result.
	 * 
	 * @param name the name of the bean to return
	 * @param requiredType the type the bean must match or {@code null} for any match
	 * @return an instance of the bean
	 * @throws BeanNotOfRequiredTypeException if the bean is not of the required type
	 * @throws NoSuchBeanDefinitionException if there is no bean definition for the
	 * given name
	 * @throws BeanException if the bean could not be created
	 */
	public function getBeanByNameAndType(name:String, requiredType:Function);
	
	/**
	 * Determines the type of the bean with the given name. More specifically, checks
	 * the type of object that {@link #getBean} would return. For a {@link FactoryBean},
	 * returns the type of object that the factory bean creates.
	 * 
	 * @param name the name of the bean to query
	 * @return the type of the bean, or {@code null} if not determinable
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function getType(name:String):Function;
	
	/**
	 * Returns the aliases ({@code String} values) for the given bean name, if defined.
	 * 
	 * <p>Will ask the parent factory if the bean cannot be found in this factory.
	 * 
	 * @param name the bean name to check for aliases
	 * @return the aliases, or an empty array if none
	 * @throws NoSuchBeanDefinitionException if there is no such bean definition
	 */
	public function getAliases(name:String):Array;
	
	/**
	 * Checks whether the bean corresponding to the given name is a singleton. If it is
	 * a singleton {@link #getBean} always returns the same object.
	 * 
	 * <p>Will ask the parent factory if the bean cannot be found in this factory.
	 * 
	 * @param name the name of the bean to query
	 * @return {@code true} if the bean is a singleton else {@code false}
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function isSingleton(name:String):Boolean;
	
}