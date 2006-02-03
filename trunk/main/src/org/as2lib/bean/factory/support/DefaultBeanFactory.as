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

import org.as2lib.bean.AbstractBeanWrapper;
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.factory.BeanCreationException;
import org.as2lib.bean.factory.BeanCurrentlyInCreationException;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanIsNotAFactoryException;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.BeanNotOfRequiredTypeException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.config.ConfigurableBeanFactory;
import org.as2lib.bean.factory.config.ConfigurableHierarchicalBeanFactory;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.DestructionAwareBeanPostProcessor;
import org.as2lib.bean.factory.config.InstantiationAwareBeanPostProcessor;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.FactoryBeanNotInitializedException;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.bean.factory.ListableBeanFactory;
import org.as2lib.bean.factory.NoSuchBeanDefinitionException;
import org.as2lib.bean.factory.support.AbstractBeanFactory;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.factory.support.ChildBeanDefinition;
import org.as2lib.bean.factory.support.ManagedArray;
import org.as2lib.bean.factory.support.ManagedList;
import org.as2lib.bean.factory.support.ManagedMap;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.bean.PropertyValues;
import org.as2lib.bean.SimpleBeanWrapper;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.reflect.NoSuchMethodException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.MethodUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.DefaultBeanFactory extends AbstractBeanFactory implements ConfigurableBeanFactory, ConfigurableListableBeanFactory, ConfigurableHierarchicalBeanFactory, BeanDefinitionRegistry {
	
	//---------------------------------------------------------------------
	// Instance data
	//---------------------------------------------------------------------
	
	private var parentBeanFactory:BeanFactory;
	
	private var beanDefinitionMap:Map;
	
	private var singletonCache:Map;
	
	private var aliasMap:Map;
	
	private var beanPostProcessors:Array;
	
	private var hasDestructionAwareBeanPostProcessors:Boolean;
	
	private var allowBeanDefinitionOverriding:Boolean;
	
	/** Disposable bean instances: bean name --> disposable instance */
	private var disposableBeans:Map;

	/** Map between dependent bean names: bean name --> dependent bean name */
	private var dependentBeanMap:Map;
	
	/** Whether to automatically try to resolve circular references between beans */
	private var allowCircularReferences:Boolean;
	
	private var propertyValueConverters:Map;
	
	/** Names of beans that are currently in creation */
	private var currentlyInCreation:Array;
	
	//---------------------------------------------------------------------
	// Constructors
	//---------------------------------------------------------------------
	
	public function DefaultBeanFactory(parentBeanFactory:BeanFactory) {
		this.parentBeanFactory = parentBeanFactory;
		beanDefinitionMap = new PrimitiveTypeMap();
		singletonCache = new PrimitiveTypeMap();
		aliasMap = new PrimitiveTypeMap();
		allowBeanDefinitionOverriding = true;
		disposableBeans = new PrimitiveTypeMap();
		dependentBeanMap = new PrimitiveTypeMap();
		propertyValueConverters = new HashMap();
		beanPostProcessors = new Array();
		currentlyInCreation = new Array();
		allowCircularReferences = true;
	}
	
	//---------------------------------------------------------------------
	// Implementation of AutowireCapableBeanFactory interface
	//---------------------------------------------------------------------
	
	public function autowire(beanClass, autowireMode:Number, dependencyCheck:Boolean) {
		// Use non-singleton bean definition, to avoid registering bean as dependent bean.
		var bd:RootBeanDefinition = new RootBeanDefinition(beanClass, autowireMode, dependencyCheck);
		bd.setSingleton(false);
		var beanName:String = ReflectUtil.getTypeNameForType(beanClass);
		var bean = instantiateBean(beanName, bd);
		populateBean(beanName, bean, bd);
		return bean;
	}
	
	public function autowireBeanProperties(existingBean, autowireMode:Number, dependencyCheck:Boolean) {
		// Use non-singleton bean definition, to avoid registering bean as dependent bean.
		var beanClassName:String = ReflectUtil.getTypeNameForInstance(existingBean);
		var bd:RootBeanDefinition = new RootBeanDefinition(eval("_global." + beanClassName), autowireMode, dependencyCheck);
		bd.setSingleton(false);
		populateBean(beanClassName, existingBean, bd);
	}
	
	//---------------------------------------------------------------------
	// Implementation methods
	//---------------------------------------------------------------------
	
	public function setAllowBeanDefinitionOverriding(allowBeanDefinitionOverriding:Boolean):Void {
		this.allowBeanDefinitionOverriding = allowBeanDefinitionOverriding;
	}
	
	/**
	 * Return whether it should be allowed to override bean definitions by registering
	 * a different definition with the same name, automatically replacing the former.
	 */
	public function isAllowBeanDefinitionOverriding(Void):Boolean {
		return allowBeanDefinitionOverriding;
	}
	
	/**
	 * Set whether to allow circular references between beans - and automatically
	 * try to resolve them.
	 * <p>Note that circular reference resolution means that one of the involved beans
	 * will receive a reference to another bean that is not fully initialized yet.
	 * This can lead to subtle and not-so-subtle side effects on initialization;
	 * it does work fine for many scenarios, though.
	 * <p>Default is "true". Turn this off to throw an exception when encountering
	 * a circular reference, disallowing them completely.
	 */
	public function setAllowCircularReferences(allowCircularReferences:Boolean):Void {
		this.allowCircularReferences = allowCircularReferences;
	}
	
	/**
	 * Return whether to allow circular references between beans - and automatically
	 * try to resolve them.
	 */
	public function isAllowCircularReferences(Void):Boolean {
		return allowCircularReferences;
	}
	
	public function applyBeanPropertyValues(existingBean, beanName:String):Void {
		var bd:RootBeanDefinition = getMergedBeanDefinition(beanName, true);
		applyPropertyValues(beanName, existingBean, bd, bd.getPropertyValues());
	}
	
	/**
	 * Initialize the given BeanWrapper with the custom editors registered
	 * with this factory. To be called for BeanWrappers that will create
	 * and populate bean instances.
	 * @param bw the BeanWrapper to initialize
	 */
	private function initBeanWrapper(beanWrapper:BeanWrapper):Void {
		var classes:Array = propertyValueConverters.getKeys();
		var converters:Array = propertyValueConverters.getValues();
		for (var i:Number = 0; i < classes.length; i++) {
			var clazz:Function = classes[i];
			var converter:PropertyValueConverter = converters[i];
			beanWrapper.registerPropertyValueConverter(clazz, converter);
		}
	}
	
	private function getBeanForSingleton(name:String, bean) {
		var beanName:String = transformBeanName(name);
		if (isFactoryDereference(name) && !(bean instanceof FactoryBean)) {
			throw new BeanIsNotAFactoryException(beanName, bean.__constructor__, this, arguments);
		}
		if (bean instanceof FactoryBean) {
			if (!isFactoryDereference(name)) {
				try {
					bean = FactoryBean(bean).getObject();
				}
				catch (exception) {
					throw (new BeanCreationException(beanName, "Factory bean threw exception on object creation.", this, arguments)).initCause(exception);
				}
				if (bean == null) {
					throw new FactoryBeanNotInitializedException(beanName, "Factory bean returned 'null' object: " +
							"probably not fully initialized (maybe due to circular bean reference).", this, arguments);
				}
				return bean;
			}
		}
		return bean;
	}
	
	private function isFactoryDereference(name:String):Boolean {
		return (name.indexOf(FACTORY_BEAN_PREFIX) == 0);
	}
	
	private function transformBeanName(name:String):String {
		var beanName:String = name;
		if (name.indexOf(FACTORY_BEAN_PREFIX) == 0) {
			beanName = name.substring(FACTORY_BEAN_PREFIX.length);
		}
		if (aliasMap.containsKey(beanName)) {
			beanName = aliasMap.get(beanName);
		}
		return beanName;
	}
	
	private function createBean(beanName:String, mergedBeanDefinition:RootBeanDefinition) {
		var result;
		if (mergedBeanDefinition.hasBeanClass()) {
			result = applyBeanPostProcessorsBeforeInstantiation(mergedBeanDefinition.getBeanClass(), beanName);
			if (result != null) {
				return result;
			}
		}
		if (mergedBeanDefinition.getDependsOn() != null) {
			var dependsOn:Array = mergedBeanDefinition.getDependsOn();
			for (var i:Number = 0; i < dependsOn.length; i++) {
				getBeanByName(dependsOn[i]);
			}
		}
		var originalBean;
		var errorMessage:String;
		try {
			errorMessage = "Instantiation of bean failed.";
			if (mergedBeanDefinition.getFactoryMethodName() == null) {
				result = instantiateBean(beanName, mergedBeanDefinition);
			}
			else {
				result = instantiateBeanUsingFactoryMethod(beanName, mergedBeanDefinition);
			}
			// Eagerly cache singletons to be able to resolve circular references
			// even when triggered by lifecycle interfaces like BeanFactoryAware.
			if (allowCircularReferences) {
				if (isSingletonCurrentlyInCreation(beanName)) {
					addSingleton(beanName, result);
				}
			}
			errorMessage = "Initialization of bean failed.";
			// Give any InstantiationAwareBeanPostProcessors the opportunity to modify the state
			// of the bean before properties are set. This can be used, for example,
			// to support styles of field injection.
			var continueWithPropertyPopulation:Boolean = true;
			for (var i:Number = 0; i < beanPostProcessors.length; i++) {
				var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
				if (beanProcessor instanceof InstantiationAwareBeanPostProcessor) {
					if (!InstantiationAwareBeanPostProcessor(beanProcessor).postProcessAfterInstantiation(result, beanName)) {
						continueWithPropertyPopulation = false;
						break;
					}
				}
			}
			if (continueWithPropertyPopulation) {
				populateBean(beanName, result, mergedBeanDefinition);
			}
			originalBean = result;
			result = initializeBean(beanName, result, mergedBeanDefinition);
		}
		catch (exception:org.as2lib.bean.factory.BeanCreationException) {
			throw exception;
		}
		catch (exception) {
			throw (new BeanCreationException(beanName, errorMessage, this, arguments)).initCause(exception);
		}
		registerDisposableBeanIfNecessary(beanName, originalBean, mergedBeanDefinition);
		return result;
	}
	
	/**
	 * Apply InstantiationAwareBeanPostProcessors to the given existing bean instance,
	 * invoking their <code>postProcessBeforeInstantiation</code> methods.
	 * The returned bean instance may be a wrapper around the original.
	 * @param beanClass the class of the bean to be instantiated
	 * @param beanName the name of the bean
	 * @return the bean object to use instead of a default instance of the target bean
	 * @throws BeansException if any post-processing failed
	 * @see InstantiationAwareBeanPostProcessor#postProcessBeforeInstantiation
	 */
	private function applyBeanPostProcessorsBeforeInstantiation(beanClass:Function, beanName:String) {
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
			if (beanProcessor instanceof InstantiationAwareBeanPostProcessor) {
				var result = InstantiationAwareBeanPostProcessor(beanProcessor).postProcessBeforeInstantiation(beanClass, beanName);
				if (result != null) {
					return result;
				}
			}
		}
		return null;
	}
	
	private function instantiateBean(beanName:String, mergedBeanDefinition:RootBeanDefinition) {
		var bean = new Object();
		var beanClass:Function = mergedBeanDefinition.getBeanClass();
		bean.__proto__ = beanClass.prototype;
		bean.__constructor__ = beanClass;
		var constructorArguments:Array = resolveConstructorArguments(mergedBeanDefinition.getConstructorArgumentValues());
		try {
			beanClass.apply(bean, constructorArguments);
		} catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Could not instantiate class [" + ReflectUtil.getTypeNameForType(beanClass) + "]: Constructor threw an exception.", this, arguments)).initCause(exception);
		}
		return bean;
	}
	
	private function instantiateBeanUsingFactoryMethod(beanName:String, mergedBeanDefinition:RootBeanDefinition) {
		var factory;
		var isStatic:Boolean;
		if (mergedBeanDefinition.getFactoryBeanName() != null) {
			factory = getBeanByName(mergedBeanDefinition.getFactoryBeanName());
			isStatic = false;
		}
		else {
			factory = mergedBeanDefinition.getBeanClass();
			isStatic = true;
		}
		var factoryMethodName:String = mergedBeanDefinition.getFactoryMethodName();
		if (factory[factoryMethodName] == null) {
			throw new BeanDefinitionStoreException(beanName, "Factory method with name '" + factoryMethodName + "' does not exist on factory " +
					isStatic ? "class [" + ReflectUtil.getTypeNameForType(factory) : "bean named '" + mergedBeanDefinition.getFactoryBeanName(), this, arguments);
		}
		var bean;
		var args:Array = resolveConstructorArguments(mergedBeanDefinition.getConstructorArgumentValues());
		try {
			if (isStatic) {
				bean = factory[factoryMethodName].apply(factory, args);
			}
			else {
				bean = MethodUtil.invoke(factoryMethodName, factory, args);
			}
		}
		catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Factory method [" + factoryMethodName + "] threw an exception", this, arguments)).initCause(exception);
		}
		if (bean == null) {
			throw new BeanCreationException(
					beanName, "Factory method '" + mergedBeanDefinition.getFactoryMethodName() + "' on class [" +
					ReflectUtil.getTypeNameForType(factory) + "] returned 'null'.", this, arguments);
		}
		return bean;
	}
	
	private function resolveConstructorArguments(constructorArgumentValues:ConstructorArgumentValues):Array {
		var result:Array = new Array();
		var beanWrapper:SimpleBeanWrapper = new SimpleBeanWrapper();
		initBeanWrapper(beanWrapper);
		var avs:Array = constructorArgumentValues.getArgumentValues();
		for (var i:Number = 0; i < avs.length; i++) {
			var argument:ConstructorArgumentValue = avs[i];
			var value = resolveValue("constructor argument with index " + i, argument.getValue());
			value = beanWrapper.convertPropertyValue("constructor-arg", argument.getType(), argument.getValue());
			result.push(value);
		}
		return result;
	}
	
	/**
	 * Populate the bean instance in the given BeanWrapper with the property values
	 * from the bean definition.
	 * @param beanName name of the bean
	 * @param mergedBeanDefinition the bean definition for the bean
	 * @param bw BeanWrapper with bean instance
	 */
	private function populateBean(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		var propertyValues:PropertyValues = mergedBeanDefinition.getPropertyValues();
		if (mergedBeanDefinition.getAutowireMode() == RootBeanDefinition.AUTOWIRE_BY_NAME) {
			var pvs:PropertyValues = new PropertyValues(propertyValues);
			// Add property values based on autowire by name if applicable.
			autowireByName(beanName, bean, mergedBeanDefinition, pvs);
			propertyValues = pvs;
		}
		//checkDependencies(beanName, mergedBeanDefinition, bw, pvs);
		applyPropertyValues(beanName, bean, mergedBeanDefinition, propertyValues);
	}
	
	/**
	 * Fill in any missing property values with references to
	 * other beans in this factory if autowire is set to "byName".
	 * @param beanName name of the bean we're wiring up.
	 * Useful for debugging messages; not used functionally.
	 * @param mergedBeanDefinition bean definition to update through autowiring
	 * @param bw BeanWrapper from which we can obtain information about the bean
	 * @param pvs the PropertyValues to register wired objects with
	 */
	private function autowireByName(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition, propertyValues:PropertyValues):Void {
		var propertyNames:Array = getBeanNames(true);
		var beanWrapper:BeanWrapper = new SimpleBeanWrapper(bean);
		initBeanWrapper(beanWrapper);
		for (var i:Number = 0; i < propertyNames.length; i++) {
			var propertyName:String = propertyNames[i];
			if (!propertyValues.contains(propertyName)) {
				if (beanWrapper.isWritableProperty(propertyName)) {
					var propertyValue = getBean(propertyName);
					propertyValues.addPropertyValue(propertyName, propertyValue);
					if (mergedBeanDefinition.isSingleton()) {
						registerDependentBean(propertyName, beanName);
					}
				}
			}
		}
	}
	
	/**
	 * Apply the given property values, resolving any runtime references
	 * to other beans in this bean factory. Must use deep copy, so we
	 * don't permanently modify this property.
	 * @param beanName bean name passed for better exception information
	 * @param bw BeanWrapper wrapping the target object
	 * @param pvs new property values
	 */
	private function applyPropertyValues(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition, propertyValues:PropertyValues):Void {
		if (propertyValues == null || propertyValues.isEmpty()) {
			return;
		}
		var beanWrapper:BeanWrapper = new SimpleBeanWrapper(bean);
		initBeanWrapper(beanWrapper);
		// Create a deep copy, resolving any references for values.
		var deepCopy:PropertyValues = new PropertyValues();
		var pvArray:Array = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < pvArray.length; i++) {
			var pv:PropertyValue = pvArray[i];
			var resolvedValue = resolveValue(pv.getName(), pv.getValue(), beanName, mergedBeanDefinition);
			deepCopy.addPropertyValue(pv.getName(), resolvedValue, pv.getType());
		}
		try {
			beanWrapper.setPropertyValues(deepCopy);
		}
		catch (exception:org.as2lib.bean.BeanException) {
			// Improve the message by showing the context.
			throw (new BeanCreationException(beanName, "Error setting property values.", this, arguments)).initCause(exception);
		}
	}
	
	private function resolveValue(valueName:String, value, beanName:String, beanDefinition:BeanDefinition) {
		// We must check each value to see whether it requires a runtime reference
		// to another bean to be resolved.
		if (value instanceof BeanDefinitionHolder) {
			// Resolve BeanDefinitionHolder: contains BeanDefinition with name and aliases.
			var bdHolder:BeanDefinitionHolder = value;
			return resolveInnerBeanDefinition(bdHolder.getBeanName(), bdHolder.getBeanDefinition(), beanName, beanDefinition);
		}
		if (value instanceof BeanDefinition) {
			// Resolve plain BeanDefinition, without contained name: use dummy name.
			var bd:BeanDefinition = value;
			return resolveInnerBeanDefinition("(inner bean)", bd, beanName, beanDefinition);
		}
		if (value instanceof RuntimeBeanReference) {
			var ref:RuntimeBeanReference = value;
			return resolveReference(valueName, ref, beanName, beanDefinition);
		}
		if (value instanceof ManagedArray) {
			return resolveManagedArray(valueName, value);
		}
		if (value instanceof ManagedList) {
			// May need to resolve contained runtime references.
			return resolveManagedList(valueName, value);
		}
		if (value instanceof ManagedMap) {
			// May need to resolve contained runtime references.
			return resolveManagedMap(valueName, value);
		}
		// no need to resolve value
		return value;
	}
	
	/**
	 * Resolve an inner bean definition.
	 */
	private function resolveInnerBeanDefinition(innerBeanName:String, innerBeanDefinition:BeanDefinition, beanName:String, beanDefinition:BeanDefinition) {
		var mergedInnerBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(innerBeanName, false, innerBeanDefinition);
		var innerBean = createBean(innerBeanName, mergedInnerBeanDefinition, null);
		if (mergedInnerBeanDefinition.isSingleton()) {
			registerDependentBean(innerBeanName, beanName);
		}
		return getBeanForSingleton(innerBeanName, innerBean);
	}

	/**
	 * Resolve a reference to another bean in the factory.
	 */
	private function resolveReference(valueName:String, reference:RuntimeBeanReference, beanName:String, beanDefinition:BeanDefinition) {
		try {
			if (reference.isToParent()) {
				if (parentBeanFactory == null) {
					throw new BeanCreationException(
							beanName, "Can't resolve reference to bean '" + reference.getBeanName() +
							"' in parent factory: no parent factory available", this, arguments);
				}
				return parentBeanFactory.getBean(reference.getBeanName());
			}
			else {
				if (beanDefinition.isSingleton()) {
					registerDependentBean(reference.getBeanName(), beanName);
				}
				return getBean(reference.getBeanName());
			}
		}
		catch (exception:org.as2lib.bean.BeanException) {
			throw (new BeanCreationException(
					beanName, "Can't resolve reference to bean '" + reference.getBeanName() +
					"' while setting property '" + valueName + "'", this, arguments)).initCause(exception);
		}
	}
	
	private function resolveManagedArray(valueName:String, managedArray:ManagedArray):Array {
		for (var i:Number = 0; i < managedArray.length; i++) {
			managedArray[i] = resolveValue(valueName + AbstractBeanWrapper.PROPERTY_KEY_PREFIX + i + AbstractBeanWrapper.PROPERTY_KEY_SUFFIX, managedArray[i]);
		}
		return managedArray;
	}
	
	/**
	 * For each element in the ManagedList, resolve reference if necessary.
	 */
	private function resolveManagedList(valueName:String, managedList:ManagedList):List {
		var values:Array = managedList.toArray();
		for (var i:Number = 0; i < values.length; i++) {
			values[i] = resolveValue(valueName + AbstractBeanWrapper.PROPERTY_KEY_PREFIX + i + AbstractBeanWrapper.PROPERTY_KEY_SUFFIX, values[i]);
		}
		return managedList;
	}
	
	/**
	 * For each element in the ManagedMap, resolve reference if necessary.
	 */
	private function resolveManagedMap(valueName:String, managedMap:ManagedMap):Map {
		var keys:Array = managedMap.getKeys();
		var values:Array = managedMap.getValues();
		for (var i:Number = 0; i < keys.length; i++) {
			keys[i] = resolveValue(valueName, keys[i]);
			values[i] = resolveValue(valueName + AbstractBeanWrapper.PROPERTY_KEY_PREFIX + keys[i] + AbstractBeanWrapper.PROPERTY_KEY_SUFFIX, values[i]);
		}
		return managedMap;
	}
	
	/**
	 * Initialize the given bean instance, applying factory callbacks
	 * as well as init methods and bean post processors.
	 * <p>Called from <code>createBean</code> for traditionally defined beans,
	 * and from <code>initializeBean(existingBean, beanName)</code> for existing
	 * bean instances.
	 * @param beanName the bean has in the factory. Used for debug output.
	 * @param bean new bean instance we may need to initialize
	 * @param mergedBeanDefinition the bean definition that the bean was created with
	 * (can also be <code>null</code>, if given an existing bean instance)
	 * @see org.springframework.beans.factory.BeanNameAware
	 * @see org.springframework.beans.factory.BeanFactoryAware
	 * @see #applyBeanPostProcessorsBeforeInitialization
	 * @see #invokeInitMethods
	 * @see #applyBeanPostProcessorsAfterInitialization
	 * @see #createBean
	 * @see #initializeBean(Object, String)
	 */
	private function initializeBean(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition) {
		if (bean instanceof BeanNameAware) {
			BeanNameAware(bean).setBeanName(beanName);
		}
		if (bean instanceof BeanFactoryAware) {
			BeanFactoryAware(bean).setBeanFactory(this);
		}
		bean = applyBeanPostProcessorsBeforeInitialization(bean, beanName);
		try {
			invokeInitMethods(beanName, bean, mergedBeanDefinition);
		}
		catch (exception) {
			throw (new BeanCreationException(beanName, "Invocation of init method failed.", this, arguments)).initCause(exception);
		}
		bean = applyBeanPostProcessorsAfterInitialization(bean, beanName);
		return bean;
	}
	
	public function applyBeanPostProcessorsBeforeInitialization(existingBean, beanName:String) {
		var result = existingBean;
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
			result = beanProcessor.postProcessBeforeInitialization(result, beanName);
			if (result == null) {
				throw new BeanCreationException(beanName,
						"postProcessBeforeInitialization method of BeanPostProcessor [" + beanProcessor +
						"] returned 'null' for bean [" + result + "] with name [" + beanName + "]", this, arguments);
			}
		}
		return result;
	}
	
	/**
	 * Give a bean a chance to react now all its properties are set,
	 * and a chance to know about its owning bean factory (this object).
	 * This means checking whether the bean implements InitializingBean or defines
	 * a custom init method, and invoking the necessary callback(s) if it does.
	 * @param beanName the bean has in the factory. Used for debug output.
	 * @param bean new bean instance we may need to initialize
	 * @param mergedBeanDefinition the bean definition that the bean was created with
	 * (can also be <code>null</code>, if given an existing bean instance)
	 * @throws Throwable if thrown by init methods or by the invocation process
	 * @see #invokeCustomInitMethod
	 */
	private function invokeInitMethods(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		if (bean instanceof InitializingBean) {
			InitializingBean(bean).afterPropertiesSet();
		}
		if (mergedBeanDefinition.getInitMethodName() != null) {
			invokeCustomInitMethod(beanName, bean, mergedBeanDefinition.getInitMethodName(), mergedBeanDefinition.isEnforceInitMethod());
		}
	}
	
	/**
	 * Invoke the specified custom init method on the given bean.
	 * Called by invokeInitMethods.
	 * <p>Can be overridden in subclasses for custom resolution of init
	 * methods with arguments.
	 * @param beanName the bean has in the factory. Used for debug output.
	 * @param bean new bean instance we may need to initialize
	 * @param initMethodName the name of the custom init method
	 * @param enforceInitMethod indicates whether the defined init method needs to exist
	 * @see #invokeInitMethods
	 */
	private function invokeCustomInitMethod(beanName:String, bean, initMethodName:String, enforceInitMethod:Boolean):Void {
		if (bean[initMethodName] == null) {
			if (enforceInitMethod) {
				throw new NoSuchMethodException("Couldn't find an init method named '" + initMethodName +
						"' on bean with name '" + beanName + "'", this, arguments);
			}
			else {
				// Ignore non-existent default lifecycle methods.
				return;
			}
		}
		bean[initMethodName]();
	}
	
	public function applyBeanPostProcessorsAfterInitialization(existingBean, beanName:String) {
		var result = existingBean;
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
			result = beanProcessor.postProcessAfterInitialization(result, beanName);
			if (result == null) {
				throw new BeanCreationException(beanName,
						"postProcessAfterInitialization method of BeanPostProcessor [" + beanProcessor +
						"] returned 'null' for bean [" + result + "] with name [" + beanName + "]", this, arguments);
			}
		}
		return result;
	}
	
	private function destroyBean(beanName:String, bean) {
		var dependencies:Array = dependentBeanMap.remove(beanName);
		if (dependencies != null) {
			for (var i:Number = 0; i < dependencies.length; i++) {
				var dependentBeanName:String = dependencies[i];
				destroyDisposableBean(dependentBeanName);
			}
		}
		if (bean instanceof DisposableBean) {
			try {
				DisposableBean(bean).destroy();
			}
			catch (exception) {
				// logger.error("Destroy method on bean with name '" + beanName + "' threw an exception", ex);
			}
		}
	}
	
	private function destroyDisposableBean(beanName:String):Void {
		var disposableBean = disposableBeans.remove(beanName);
		destroyBean(beanName, disposableBean);
	}
	
	private function getMergedBeanDefinition(beanName:String, includingAncestors:Boolean, beanDefinition:BeanDefinition):RootBeanDefinition {
		if (beanDefinition == null) {
			try {
				beanDefinition = getBeanDefinition(transformBeanName(beanName));
			} catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
				if (includingAncestors && parentBeanFactory instanceof DefaultBeanFactory) {
					return DefaultBeanFactory(parentBeanFactory).getMergedBeanDefinition(beanName, true);
				}
				throw exception;
			}
		}
		if (beanDefinition instanceof RootBeanDefinition) {
			return RootBeanDefinition(beanDefinition);
		}
		if (beanDefinition instanceof ChildBeanDefinition) {
			var cbd:ChildBeanDefinition = ChildBeanDefinition(beanDefinition);
			var pbd:RootBeanDefinition = null;
			try {
				if (beanName != cbd.getParentName()) {
					pbd = getMergedBeanDefinition(cbd.getParentName(), true);
				}
				else {
					if (parentBeanFactory instanceof DefaultBeanFactory) {
						var pbf:DefaultBeanFactory = DefaultBeanFactory(parentBeanFactory);
						pbd = pbf.getMergedBeanDefinition(cbd.getParentName(), true);
					}
					else {
						throw new NoSuchBeanDefinitionException(cbd.getParentName(),
								"Parent name '" + cbd.getParentName() + "' is equal to bean name '" + beanName +
								"': cannot be resolved without a default bean factory parent.", this, arguments);
					}
				}
			}
			catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
				throw (new BeanDefinitionStoreException(beanName, "Could not resolve parent bean definition '" + cbd.getParentName() + "'.", this, arguments)).initCause(exception);
			}
			var rbd:RootBeanDefinition = new RootBeanDefinition(pbd);
			rbd.override(cbd);
			try {
				rbd.validate();
			}
			catch (exception:org.as2lib.bean.factory.support.BeanDefinitionValidationException) {
				throw (new BeanDefinitionStoreException(beanName, "Validation of bean definition failed.", this, arguments)).initCause(exception);
			}
			return rbd;
		}
		throw new BeanDefinitionStoreException(beanName, "Definition is neither a root bean definition nor a child bean definition.", this, arguments);
	}
	
	/**
	 * Add the given bean to the list of disposable beans in this factory,
	 * registering its DisposableBean interface and/or the given destroy method
	 * to be called on factory shutdown (if applicable). Only applies to singletons.
	 * <p>Also registers bean as dependent on other beans, according to the
	 * "depends-on" configuration in the bean definition.
	 * @param beanName the name of the bean
	 * @param bean the bean instance
	 * @param mergedBeanDefinition the bean definition for the bean
	 * @see RootBeanDefinition#isSingleton
	 * @see RootBeanDefinition#getDependsOn
	 * @see #registerDisposableBean
	 * @see #registerDependentBean
	 */
	private function registerDisposableBeanIfNecessary(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		if (mergedBeanDefinition.isSingleton()) {
			var isDisposableBean:Boolean = (bean instanceof DisposableBean);
			var hasDestroyMethod:Boolean = (mergedBeanDefinition.getDestroyMethodName() != null);
			if (isDisposableBean || hasDestroyMethod || hasDestructionAwareBeanPostProcessors) {
				// Determine unique key for registration of disposable bean
				var counter:Number = 1;
				var id:String = beanName;
				while (disposableBeans.containsKey(id)) {
					counter++;
					id = beanName + "#" + counter;
				}
				// Register a DisposableBean implementation that performs all destruction
				// work for the given bean: DestructionAwareBeanPostProcessors,
				// DisposableBean interface, custom destroy method.
				var db:DisposableBean = new eval("Object")();
				db["__proto__"] = DisposableBean["prototype"];
				db["__constructor__"] = DisposableBean;
				var beanPostProcessors:Array = beanPostProcessors;
				var hasDestructionAwareBeanPostProcessors:Boolean = hasDestructionAwareBeanPostProcessors;
				db.destroy = function(Void):Void {
					if (hasDestructionAwareBeanPostProcessors) {
						for (var i:Number = beanPostProcessors.length - 1; i >= 0; i--) {
							var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
							if (beanProcessor instanceof DestructionAwareBeanPostProcessor) {
								DestructionAwareBeanPostProcessor(beanProcessor).postProcessBeforeDestruction(bean, beanName);
							}
						}
					}
					if (isDisposableBean) {
						DisposableBean(bean).destroy();
					}
					if (hasDestroyMethod) {
						var destroyMethodName = mergedBeanDefinition.getDestroyMethodName();
						if (bean[destroyMethodName] == null) {
							if (mergedBeanDefinition.isEnforceDestroyMethod()) {
								/*logger.error("Couldn't find a destroy method named '" + destroyMethodName +
										"' on bean with name '" + beanName + "'");*/
							}
						}
						else {
							try {
								bean[destroyMethodName]();
							}
							catch (exception) {
								/*logger.error("Couldn't invoke destroy method '" + destroyMethodName +
										"' of bean with name '" + beanName + "'", ex);*/
							}
						}
					}
				};
				disposableBeans.put(id, db);
			}
			// Register bean as dependent on other beans, if necessary,
			// for correct shutdown order.
			var dependsOn:Array = mergedBeanDefinition.getDependsOn();
			if (dependsOn != null) {
				for (var i:Number = 0; i < dependsOn.length; i++) {
					registerDependentBean(dependsOn[i], beanName);
				}
			}
		}
	}
	
	/**
	 * Register a dependent bean for the given bean,
	 * to be destroyed before the given bean is destroyed.
	 * @param beanName the name of the bean
	 * @param dependentBeanName the name of the dependent bean
	 */
	private function registerDependentBean(beanName:String, dependentBeanName:String):Void {
		var dependencies:Array = dependentBeanMap.get(beanName);
		if (dependencies == null) {
			dependencies = new Array();
			dependentBeanMap.put(beanName, dependencies);
		}
		dependencies.push(dependentBeanName);
	}
	
	//---------------------------------------------------------------------
	// Implementation of BeanFactory interface
	//---------------------------------------------------------------------
	
	public function containsBean(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		if (singletonCache.containsKey(beanName)) {
			return true;
		}
		if (beanDefinitionMap.containsKey(beanName)) {
			return true;
		}
		if (parentBeanFactory != null) {
			return parentBeanFactory.containsBean(name);
		}
		return false;
	}
	
	public function getBeanByName(name:String) {
		var beanName:String = transformBeanName(name);
		if (singletonCache.containsKey(beanName)) {
			var singleton = singletonCache.get(beanName);
			if (isSingletonCurrentlyInCreation(beanName)) {
				/*if (logger.isDebugEnabled()) {
					logger.debug("Returning eagerly cached instance of singleton bean '" + beanName +
							"' that is not fully initialized yet - a consequence of a circular reference");
				}*/
			}
			else {
				/*if (logger.isDebugEnabled()) {
					logger.debug("Returning cached instance of singleton bean '" + beanName + "'");
				}*/
			}
			return getBeanForSingleton(name, singleton);
		}
		// Fail if we're already creating this singleton instance:
		// We're assumably within a circular reference.
		if (isSingletonCurrentlyInCreation(beanName)) {
			throw new BeanCurrentlyInCreationException(beanName, null, this, arguments);
		}
		var beanDefinition:RootBeanDefinition;
		try {
			beanDefinition = getMergedBeanDefinition(beanName, false);
		} catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
			if (parentBeanFactory != null) {
				return getParentBeanFactory().getBeanByName(name);
			}
			throw exception;
		}
		if (beanDefinition.isSingleton()) {
			currentlyInCreation[beanName] = true;
			var bean;
			try {
				bean = createBean(beanName, beanDefinition);
				singletonCache.put(beanName, bean);
			}
			catch (exception:org.as2lib.bean.BeanException) {
				// Explicitly remove instance from singleton cache:
				// It might have been put there eagerly by the creation process,
				// to allow for circular reference resolution.
				singletonCache.remove(beanName);
				throw exception;
			}
			finally {
				delete currentlyInCreation[beanName];
			}
			return getBeanForSingleton(name, bean);
		}
		return createBean(beanName, beanDefinition);
	}
	
	public function getBeanByNameAndType(name:String, requiredType:Function) {
		var bean = getBeanByName(name);
		if (requiredType && !(bean instanceof requiredType)) {
			throw new BeanNotOfRequiredTypeException(name, requiredType, bean.__constructor__, this, arguments);
		}
		return bean;
	}
	
	public function getAliases(name:String):Array {
		var beanName:String = transformBeanName(name);
		if (containsSingleton(beanName) || containsBeanDefinition(beanName)) {
			var aliases:Array = new Array();
			var keys:Array = aliasMap.getKeys();
			var values:Array = aliasMap.getValues();
			for (var i:Number = 0; i < keys.length; i++) {
				if (values[i] == beanName) {
					aliases.push(keys[i]);
				}
			}
			return aliases;
		}
		if (parentBeanFactory != null) {
			return parentBeanFactory.getAliases(name);
		}
		throw new NoSuchBeanDefinitionException(beanName, toString(), this, arguments);
	}
	
	public function isSingleton(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		try {
			var singleton:Boolean = true;
			var bean;
			bean = singletonCache.get(beanName);
			if (bean != null) {
				if (bean instanceof FactoryBean && !isFactoryDereference(name)) {
					var factoryBean:FactoryBean = FactoryBean(getBean(FACTORY_BEAN_PREFIX + beanName));
					return factoryBean.isSingleton();
				}
				singleton = true;
			}
			else {
				var bd:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
				if (bd.hasBeanClass()) {
					if (ClassUtil.isImplementationOf(bd.getBeanClass(), FactoryBean) && !isFactoryDereference(name)) {
						var factoryBean:FactoryBean = FactoryBean(getBean(FACTORY_BEAN_PREFIX + beanName));
						return factoryBean.isSingleton();
					}
				}
				singleton = bd.isSingleton();
			}
			return singleton;
		}
		catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
			if (parentBeanFactory != null) {
				return parentBeanFactory.isSingleton(name);
			}
			throw exception;
		}
	}
	
	public function getType(name:String):Function {
		var beanName:String = transformBeanName(name);
		try {
			var beanClass:Function = null;
			var bean = null;
			bean = singletonCache.get(beanName);
			if (bean != null) {
				beanClass = eval("_global." + ReflectUtil.getTypeName(bean));
			}
			else {
				var mergedBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
				if (mergedBeanDefinition.getFactoryMethodName() != null) {
					return getTypeForFactoryMethod(name, mergedBeanDefinition);
				}
				if (!mergedBeanDefinition.hasBeanClass()) {
					return null;
				}
				beanClass = mergedBeanDefinition.getBeanClass();
			}
			if (ClassUtil.isImplementationOf(beanClass, FactoryBean) && !isFactoryDereference(name)) {
				var factoryBean:FactoryBean = FactoryBean(getBean(FACTORY_BEAN_PREFIX + beanName));
				return factoryBean.getObjectType();
			}
			return beanClass;
		}
		catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
			if (parentBeanFactory != null) {
				return parentBeanFactory.getType(name);
			}
			throw exception;
		}
		catch (exception:org.as2lib.bean.factory.BeanCreationException) {
			if (exception.contains(BeanCurrentlyInCreationException) ||
					exception.contains(FactoryBeanNotInitializedException)) {
				//logger.debug("Ignoring BeanCreationException on FactoryBean type check", ex);
				return null;
			}
			throw exception;
		}
	}
	
	private function getTypeForFactoryMethod(beanName:String, mergedBeanDefinition:RootBeanDefinition):Function {
		if (mergedBeanDefinition.getFactoryBeanName() != null &&
				mergedBeanDefinition.isSingleton() && !mergedBeanDefinition.isLazyInit()) {
			return eval("_global." + ReflectUtil.getTypeName(getBean(beanName)));
		}
		return null;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableBeanFactory interface
	//---------------------------------------------------------------------
	
	/**
	 * Return whether the specified singleton is currently in creation
	 * @param beanName the name of the bean
	 */ 
	private function isSingletonCurrentlyInCreation(beanName:String):Boolean {
		return (currentlyInCreation[beanName] == true);
	}
	
	public function registerSingleton(beanName:String, singleton):Void {
		if (singletonCache.containsKey(beanName)) {
			throw new BeanDefinitionStoreException(null, "Could not register singleton [" + singleton +
					"] under bean name '" + beanName + "': there is already singleton [" + 
					singletonCache.get(beanName) + " bound.", this, arguments);
		}
		singletonCache.put(beanName, singleton);
	}
	
	public function addSingleton(beanName:String, singleton):Void {
		singletonCache.put(beanName, singleton);
	}
	
	public function containsSingleton(beanName : String) : Boolean {
		return singletonCache.containsKey(beanName);
	}
	
	public function destroySingletons(Void):Void {
		try {
			singletonCache.clear();
			var dbs:Array = disposableBeans.getKeys();
			for (var i:Number = 0; i < dbs.length; i++) {
				destroyDisposableBean(dbs[i]);
			}
		}
		catch (exception) {
			//logger.error("Unexpected failure during bean destruction", ex);
		}
	}
	
	public function getSingletonNames(Void):Array {
		return singletonCache.getKeys();
	}
	
	public function registerAlias(beanName:String, alias:String):Void {
		if (aliasMap.containsKey(alias)) {
			throw new BeanDefinitionStoreException(null, "Cannot register alias '" + alias + "' for bean name '" +
					beanName + "': it is already registered for bean name '" + aliasMap.get(alias) + "'.", this, arguments);
		}
		aliasMap.put(alias, beanName);
	}
	
	public function addBeanPostProcessor(beanPostProcessor:BeanPostProcessor):Void {
		beanPostProcessors.push(beanPostProcessor);
		if (beanPostProcessor instanceof DestructionAwareBeanPostProcessor) {
			hasDestructionAwareBeanPostProcessors = true;
		}
	}
	
	public function getBeanPostProcessorCount(Void):Number {
		return beanPostProcessors.length;
	}
	
	public function getBeanPostProcessors(Void):Array {
		return beanPostProcessors.concat();
	}
	
	public function registerPropertyValueConverter(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void {
		propertyValueConverters.put(requiredType, propertyValueConverter);
	}
	
	//---------------------------------------------------------------------
	// Implementation of HierarchicalBeanFactory interface
	//---------------------------------------------------------------------
	
	public function getParentBeanFactory(Void):BeanFactory {
		return parentBeanFactory;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableHierarchicalBeanFactory interface
	//---------------------------------------------------------------------
	
	public function setParentBeanFactory(parentBeanFactory:BeanFactory):Void {
		this.parentBeanFactory = parentBeanFactory;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ListableBeanFactory interface
	//---------------------------------------------------------------------
	
	public function containsBeanDefinition(beanName:String, includingAncestors:Boolean):Boolean {
		var result:Boolean = beanDefinitionMap.containsKey(beanName);
		if (result) {
			return true;
		}
		if (includingAncestors) {
			if (parentBeanFactory instanceof ListableBeanFactory) {
				return ListableBeanFactory(parentBeanFactory).containsBeanDefinition(beanName, true);
			}
		}
		return false;
	}
	
	public function getBeanDefinitionCount(includingAncestors:Boolean):Number {
		var result:Number = beanDefinitionMap.size();
		if (includingAncestors) {
			if (parentBeanFactory instanceof ListableBeanFactory) {
				result += ListableBeanFactory(parentBeanFactory).getBeanDefinitionCount(true);
			}
		}
		return result;
	}
	
	public function getBeanDefinitionNames(includingAncestors:Boolean):Array {
		var result:Array = beanDefinitionMap.getKeys();
		if (includingAncestors) {
			if (parentBeanFactory instanceof ListableBeanFactory) {
				result = result.concat(ListableBeanFactory(parentBeanFactory).getBeanDefinitionNames(true));
			}
		}
		return result;
	}
	
	public function getBeanNames(includingAncestors:Boolean):Array {
		var result:Array = new Array();
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanName:String = beanDefinitionNames[i];
			var rootBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			if (!rootBeanDefinition.isAbstract()) {
				result.push(beanName);
			}
		}
		var singletonNames:Array = getSingletonNames();
		for (var i:Number = 0; i < singletonNames.length; i++) {
			var beanName:String = singletonNames[i];
			// Only check if manually registered.
			if (!containsBeanDefinition(beanName)) {
				result.push(beanName);
			}
		}
		if (includingAncestors) {
			if (parentBeanFactory instanceof ListableBeanFactory) {
				result = result.concat(ListableBeanFactory(parentBeanFactory).getBeanNames(true));
			}
		}
		return result;
	}
	
	public function getBeanNamesForType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Array {
		var result:Array = new Array();
		if (includePrototypes == null) includePrototypes = true;
		if (includeFactoryBeans == null) includeFactoryBeans = true;
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanName:String = beanDefinitionNames[i];
			var rootBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			if (!rootBeanDefinition.isAbstract()) {
				var isFactoryBean:Boolean = ClassUtil.isImplementationOf(rootBeanDefinition.getBeanClass(), FactoryBean);
				if (isFactoryBean || rootBeanDefinition.getFactoryBeanName() != null) {
					if (includeFactoryBeans && (includePrototypes || isSingleton(beanName))
							&& isBeanTypeMatch(beanName, type)) {
						result.push(beanName);
						// Match found for this bean: do not match FactoryBean itself anymore.
						continue;	
					}
					// We're done for anything but a full FactoryBean.
					if (!isFactoryBean) {
						continue;
					}
					// In case of FactoryBean, try to match FactoryBean itself next.
					beanName = FACTORY_BEAN_PREFIX + beanName;
				}
				// Match raw bean instance (might be raw FactoryBean).
				if ((includePrototypes || rootBeanDefinition.isSingleton()) && isBeanTypeMatch(beanName, type)) {
					result.push(beanName);
				}
			}
		}
		var singletonNames:Array = getSingletonNames();
		for (var i:Number = 0; i < singletonNames.length; i++) {
			var beanName:String = singletonNames[i];
			// Only check if manually registered.
			if (!containsBeanDefinition(beanName)) {
				// In case of FactoryBean, match object created by FactoryBean.
				if (isFactoryBean(beanName)) {
					if (includeFactoryBeans && (includePrototypes || isSingleton(beanName)) &&
							isBeanTypeMatch(beanName, type)) {
						result.push(beanName);
						// Match found for this bean: do not match FactoryBean itself anymore.
						continue;
					}
					// In case of FactoryBean, try to match FactoryBean itself next.
					beanName = FACTORY_BEAN_PREFIX + beanName;
				}
				// Match raw bean instance (might be raw FactoryBean).
				if (isBeanTypeMatch(beanName, type)) {
					result.push(beanName);
				}
			}
		}
		if (includingAncestors) {
			if (parentBeanFactory instanceof ListableBeanFactory) {
				result = result.concat(ListableBeanFactory(parentBeanFactory).getBeanNamesForType(type, includePrototypes, includeFactoryBeans, true));
			}
		}
		return result;
	}
	
	/**
	 * Determine whether the bean with the given name is a FactoryBean.
	 * @param name the name of the bean to check
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function isFactoryBean(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		try {
			var bean;
			bean = singletonCache.get(beanName);
			if (bean != null) {
				return (bean instanceof FactoryBean);
			}
			else {
				var bd:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
				return (bd.hasBeanClass() && ClassUtil.isImplementationOf(bd.getBeanClass(), FactoryBean));
			}
		}
		catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
			// Not found -> check parent.
			if (parentBeanFactory != null) {
				return parentBeanFactory.isSingleton(name);
			}
			throw exception;
		}
	}

	/**
	 * Check whether the specified bean matches the given type.
	 * @param beanName the name of the bean to check
	 * @param type the type to check for
	 * @return whether the bean matches the given type
	 * @see #getType
	 */
	private function isBeanTypeMatch(beanName:String, type:Function):Boolean {
		if (type == null) {
			return true;
		}
		var beanType:Function = getType(beanName);
		return (ClassUtil.isSubClassOf(beanType, type) || ClassUtil.isImplementationOf(beanType, type));
	}
	
	public function getBeansOfType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Map {
		var result:Map = new PrimitiveTypeMap();
		var beanNames:Array = getBeanNamesForType(type, includePrototypes, includeFactoryBeans);
		for (var i:Number = 0; i < beanNames.length; i++) {
			var beanName:String = beanNames[i];
			try {
				result.put(beanName, getBeanByName(beanName));
			}
			catch (exception:org.as2lib.bean.factory.BeanCreationException) {
				if (exception.contains(BeanCurrentlyInCreationException)) {
					// Ignore: indicates a circular reference when autowiring constructors.
					// We want to find matches other than the currently created bean itself.
				}
				else {
					throw exception;
				}
			}
		}
		return result;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableListableBeanFactory interface
	//---------------------------------------------------------------------
	
	public function getBeanDefinition(beanName:String, includingAncestors:Boolean):BeanDefinition {
		if (beanDefinitionMap.containsKey(beanName)) {
			return beanDefinitionMap.get(beanName);
		}
		if (includingAncestors) {
			if (parentBeanFactory instanceof ConfigurableListableBeanFactory) {
				return ConfigurableListableBeanFactory(parentBeanFactory).getBeanDefinition(beanName, true);
			}
		}
		throw new NoSuchBeanDefinitionException(beanName, null, this, arguments);
	}
	
	public function preInstantiateSingletons(Void):Void {
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanName:String = beanDefinitionNames[i];
			var beanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			if (!beanDefinition.isAbstract() && beanDefinition.isSingleton() && !beanDefinition.isLazyInit()) {
				if (ClassUtil.isImplementationOf(beanDefinition.getBeanClass(), FactoryBean)) {
					var factory:FactoryBean = FactoryBean(getBeanByName(FACTORY_BEAN_PREFIX + beanName));
					if (factory.isSingleton()) {
						getBeanByName(beanName);
					}
					return;
				}
				getBeanByName(beanName);
			}
		}
	}
	
	//---------------------------------------------------------------------
	// Implementation of BeanDefinitionRegistry interface
	//---------------------------------------------------------------------
	
	public function registerBeanDefinition(beanName:String, beanDefinition:BeanDefinition):Void {
		if (!allowBeanDefinitionOverriding && beanDefinitionMap.containsKey(beanName)) {
			throw new BeanDefinitionStoreException(
					beanName, "Cannot register bean definition [" + beanDefinition + "] for bean '" + beanName +
					"': there is already [" + beanDefinitionMap.get(beanName) + "] bound.", this, arguments);
		}
		beanDefinitionMap.put(beanName, beanDefinition);
	}
	
}