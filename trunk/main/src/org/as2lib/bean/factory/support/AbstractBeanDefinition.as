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

import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.support.BeanDefinitionValidationException;
import org.as2lib.bean.factory.support.MethodOverride;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.AbstractBeanDefinition extends BasicClass {
	
	/**
	 * Constant that indicates no autowiring at all.
	 * @see #setAutowireMode
	 */
	public static var AUTOWIRE_NO:Number = 0;

	/**
	 * Constant that indicates autowiring bean properties by name.
	 * @see #setAutowireMode
	 */
	public static var AUTOWIRE_BY_NAME:Number = 1;
	
	/**
	 * Constant that indicates no dependency check at all.
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_NONE:Number = 0;
	
	/**
	 * Constant that indicates dependency checking for object references.
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_OBJECTS:Number = 1;
	
	/**
	 * Constant that indicates dependency checking for "simple" properties.
	 * @see #setDependencyCheck
	 * @see org.springframework.beans.BeanUtils#isSimpleProperty
	 */
	public static var DEPENDENCY_CHECK_SIMPLE:Number = 2;
	
	/**
	 * Constant that indicates dependency checking for all properties
	 * (object references as well as "simple" properties).
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_ALL:Number = 3;
	
	private var beanClass:Function;
	
	private var beanClassName:String;
	
	private var abstract:Boolean;

	private var singleton:Boolean;

	private var lazyInit:Boolean;
	
	private var autowireMode:Number;

	private var dependencyCheck:Number;

	private var dependsOn:Array;

	private var constructorArgumentValues:ConstructorArgumentValues;

	private var propertyValues:PropertyValues;

	private var methodOverrides:MethodOverrides;

	private var factoryBeanName:String;

	private var factoryMethodName:String;

	private var initMethodName:String;

	private var destroyMethodName:String;

	private var enforceInitMethod:Boolean;

	private var enforceDestroyMethod:Boolean;
	
	/**
	 * Constructs a new {@code AbstractBeanDefinition} instance.
	 * 
	 * @param constructorArgumentValues the constructor argument values
	 * @param propertyValues the property values
	 */
	public function AbstractBeanDefinition(constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues) {
		setConstructorArgumentValues(constructorArgumentValues);
		setPropertyValues(propertyValues);
		abstract = false;
		singleton = true;
		lazyInit = false;
		dependencyCheck = DEPENDENCY_CHECK_NONE;
		autowireMode = AUTOWIRE_NO;
		methodOverrides = new MethodOverrides();
		enforceInitMethod = true;
		enforceDestroyMethod = true;
	}
	
	/**
	 * Overrides settings in this bean definition from the given bean definition.
	 * 
	 * <p><ul>
	 *   <li>Will override beanClass if specified in the given bean definition.
	 *   <li>Will always take abstract, singleton, lazyInit from the given bean definition.
	 *   <li>Will add argumentValues, propertyValues, methodOverrides to
	 *       existing ones.
	 *   <li>Will override initMethodName, destroyMethodName, staticFactoryMethodName
	 *       if specified.
	 *   <li>Will always take dependsOn, autowireMode, dependencyCheck from the
	 *       given bean definition.
	 * </ul>
	 */
	public function override(beanDefinition:AbstractBeanDefinition):Void {
		if (beanDefinition.hasBeanClass()) {
			setBeanClass(beanDefinition.getBeanClass());
		}
		setAbstract(beanDefinition.isAbstract());
		setSingleton(beanDefinition.isSingleton());
		setLazyInit(beanDefinition.isLazyInit());
		setAutowireMode(beanDefinition.getAutowireMode());
		setDependencyCheck(beanDefinition.getDependencyCheck());
		setDependsOn(beanDefinition.getDependsOn());
		getConstructorArgumentValues().addArgumentValues(beanDefinition.getConstructorArgumentValues());
		getPropertyValues().addPropertyValues(beanDefinition.getPropertyValues());
		getMethodOverrides().addOverrides(beanDefinition.getMethodOverrides());
		if (beanDefinition.getFactoryBeanName() != null) {
			setFactoryBeanName(beanDefinition.getFactoryBeanName());
		}
		if (beanDefinition.getFactoryMethodName() != null) {
			setFactoryMethodName(beanDefinition.getFactoryMethodName());
		}
		if (beanDefinition.getInitMethodName() != null) {
			setInitMethodName(beanDefinition.getInitMethodName());
			setEnforceInitMethod(beanDefinition.isEnforceInitMethod());
		}
		if (beanDefinition.getDestroyMethodName() != null) {
			setDestroyMethodName(beanDefinition.getDestroyMethodName());
			setEnforceDestroyMethod(beanDefinition.isEnforceDestroyMethod());
		}
	}
	
	/**
	 * Returns whether this definition specifies a bean class.
	 */
	public function hasBeanClass(Void):Boolean {
		return (beanClass != null);
	}
	
	/**
	 * Specifies the class for this bean.
	 */
	public function setBeanClass(beanClass:Function):Void {
		this.beanClass = beanClass;
	}
	
	/**
	 * Returns the class of the wrapped bean.
	 * 
	 * @throws IllegalStateException if the bean definition does not carry a resolved
	 * bean class
	 */
	public function getBeanClass(Void):Function {
		if (!hasBeanClass()) {
			throw new IllegalStateException("Bean definition does not carry a bean class.", this, arguments);
		}
		return beanClass;
	}
	
	/**
	 * Specifies the class name for this bean.
	 */
	public function setBeanClassName(beanClassName:String):Void {
		this.beanClassName = beanClassName;
	}

	/**
	 * Returns the class name of the wrapped bean.
	 */
	public function getBeanClassName(Void):String {
		if (beanClassName == null && beanClass != null) {
			beanClassName = ReflectUtil.getTypeNameForType(beanClass);
		}
		return beanClassName;
	}
	
	/**
	 * Sets if this bean is "abstract", i.e. not meant to be instantiated itself but
	 * rather just serving as parent for concrete child bean definitions.
	 * 
	 * <p>Default is "false". Specify true to tell the bean factory to not try to
	 * instantiate that particular bean in any case.
	 */
	public function setAbstract(abstract:Boolean):Void {
		this.abstract = abstract;
	}

	/**
	 * Return whether this bean is "abstract", i.e. not meant to be instantiated
	 * itself but rather just serving as parent for concrete child bean definitions.
	 */
	public function isAbstract(Void):Boolean {
		return abstract;
	}

	/**
	 * Set if this a <b>Singleton</b>, with a single, shared instance returned
	 * on all calls. If false, the BeanFactory will apply the <b>Prototype</b>
	 * design pattern, with each caller requesting an instance getting an
	 * independent instance. How this is defined will depend on the BeanFactory.
	 * <p>"Singletons" are the commoner type, so the default is true.
	 */
	public function setSingleton(singleton:Boolean):Void {
		this.singleton = singleton;
	}

	/**
	 * Return whether this a <b>Singleton</b>, with a single, shared instance
	 * returned on all calls.
	 */
	public function isSingleton(Void):Boolean {
		return singleton;
	}

	/**
	 * Set whether this bean should be lazily initialized.
	 * Only applicable to a singleton bean.
	 * If false, it will get instantiated on startup by bean factories
	 * that perform eager initialization of singletons.
	 */
	public function setLazyInit(lazyInit:Boolean):Void {
		this.lazyInit = lazyInit;
	}

	/**
	 * Return whether this bean should be lazily initialized, i.e. not
	 * eagerly instantiated on startup. Only applicable to a singleton bean.
	 */
	public function isLazyInit(Void):Boolean {
		return lazyInit;
	}
	
	/**
	 * Set the autowire mode. This determines whether any automagical detection
	 * and setting of bean references will happen. Default is AUTOWIRE_NO,
	 * which means there's no autowire.
	 * @param autowireMode the autowire mode to set.
	 * Must be one of the constants defined in this class.
	 * @see #AUTOWIRE_NO
	 * @see #AUTOWIRE_BY_NAME
	 * @see #AUTOWIRE_BY_TYPE
	 * @see #AUTOWIRE_CONSTRUCTOR
	 * @see #AUTOWIRE_AUTODETECT
	 */
	public function setAutowireMode(autowireMode:Number):Void {
		this.autowireMode = autowireMode;
	}
	
	/**
	 * Return the autowire mode as specified in the bean definition.
	 */
	public function getAutowireMode(Void):Number {
		return autowireMode;
	}
	
	/**
	 * Set the dependency check code.
	 * @param dependencyCheck the code to set.
	 * Must be one of the four constants defined in this class.
	 * @see #DEPENDENCY_CHECK_NONE
	 * @see #DEPENDENCY_CHECK_OBJECTS
	 * @see #DEPENDENCY_CHECK_SIMPLE
	 * @see #DEPENDENCY_CHECK_ALL
	 */
	public function setDependencyCheck(dependencyCheck:Number):Void {
		this.dependencyCheck = dependencyCheck;
	}

	/**
	 * Return the dependency check code.
	 */
	public function getDependencyCheck(Void):Number {
		return dependencyCheck;
	}

	/**
	 * Set the names of the beans that this bean depends on being initialized.
	 * The bean factory will guarantee that these beans get initialized before.
	 * <p>Note that dependencies are normally expressed through bean properties or
	 * constructor arguments. This property should just be necessary for other kinds
	 * of dependencies like statics (*ugh*) or database preparation on startup.
	 */
	public function setDependsOn(dependsOn:Array):Void {
		this.dependsOn = dependsOn;
	}

	/**
	 * Return the bean names that this bean depends on.
	 */
	public function getDependsOn(Void):Array {
		return dependsOn;
	}
	
	/**
	 * Specify constructor argument values for this bean.
	 */
	public function setConstructorArgumentValues(constructorArgumentValues:ConstructorArgumentValues):Void {
		this.constructorArgumentValues = (constructorArgumentValues != null) ? constructorArgumentValues : new ConstructorArgumentValues();
	}
	
	/**
	 * Return constructor argument values for this bean, if any.
	 */
	public function getConstructorArgumentValues(Void):ConstructorArgumentValues {
		return constructorArgumentValues;
	}

	/**
	 * Return if there are constructor argument values defined for this bean.
	 */
	public function hasConstructorArgumentValues(Void):Boolean {
		return (constructorArgumentValues != null && !constructorArgumentValues.isEmpty());
	}

	/**
	 * Specify property values for this bean, if any.
	 */
	public function setPropertyValues(propertyValues:PropertyValues):Void {
		this.propertyValues = (propertyValues != null) ? propertyValues : new PropertyValues();
	}

	/**
	 * Return property values for this bean, if any.
	 */
	public function getPropertyValues(Void):PropertyValues {
		return propertyValues;
	}
	
	public function hasPropertyValues(Void):Boolean {
		return (propertyValues != null && !propertyValues.isEmpty());
	}

	/**
	 * Specify method overrides for the bean, if any.
	 */
	public function setMethodOverrides(methodOverrides:MethodOverrides):Void {
		this.methodOverrides = (methodOverrides != null) ? methodOverrides : new MethodOverrides();
	}

	/**
	 * Return information about methods to be overridden by the IoC
	 * container. This will be empty if there are no method overrides.
	 * Never returns null.
	 */
	public function getMethodOverrides(Void):MethodOverrides {
		return methodOverrides;
	}


	/**
	 * Specify the factory bean to use, if any.
	 */
	public function setFactoryBeanName(factoryBeanName:String):Void {
		this.factoryBeanName = factoryBeanName;
	}

	/**
	 * Returns the factory bean name, if any.
	 */
	public function getFactoryBeanName(Void):String {
		return factoryBeanName;
	}

	/**
	 * Specify a factory method, if any. This method will be invoked with
	 * constructor arguments, or with no arguments if none are specified.
	 * The static method will be invoked on the specifed factory bean,
	 * if any, or on the local bean class else.
	 * @param factoryMethodName static factory method name, or <code>null</code> if
	 * normal constructor creation should be used
	 * @see #getBeanClass
	 */
	public function setFactoryMethodName(factoryMethodName:String):Void {
		this.factoryMethodName = factoryMethodName;
	}

	/**
	 * Return a factory method, if any.
	 */
	public function getFactoryMethodName(Void):String {
		return factoryMethodName;
	}

	/**
	 * Set the name of the initializer method. The default is null
	 * in which case there is no initializer method.
	 */
	public function setInitMethodName(initMethodName:String):Void {
		this.initMethodName = initMethodName;
	}

	/**
	 * Return the name of the initializer method.
	 */
	public function getInitMethodName(Void):String {
		return initMethodName;
	}

	/**
	 * Specifies whether or not the configured init method is the default.
	 * Default value is <code>false</code>.
	 * @see #setInitMethodName
	 */
	public function setEnforceInitMethod(enforceInitMethod:Boolean):Void {
		this.enforceInitMethod = enforceInitMethod;
	}

	/**
	 * Indicates whether the configured init method is the default.
	 * @see #getInitMethodName()
	 */
	public function isEnforceInitMethod(Void):Boolean {
		return enforceInitMethod;
	}

	/**
	 * Set the name of the destroy method. The default is null
	 * in which case there is no destroy method.
	 */
	public function setDestroyMethodName(destroyMethodName:String):Void {
		this.destroyMethodName = destroyMethodName;
	}

	/**
	 * Return the name of the destroy method.
	 */
	public function getDestroyMethodName(Void):String {
		return destroyMethodName;
	}

	/**
	 * Specifies whether or not the configured destroy method is the default.
	 * Default value is <code>false</code>.
	 * @see #setDestroyMethodName
	 */
	public function setEnforceDestroyMethod(enforceDestroyMethod:Boolean):Void {
		this.enforceDestroyMethod = enforceDestroyMethod;
	}

	/**
	 * Indicates whether the configured destroy method is the default.
	 * @see #getDestroyMethodName
	 */
	public function isEnforceDestroyMethod(Void):Boolean {
		return enforceDestroyMethod;
	}
	
	/**
	 * Validate this bean definition.
	 * @throws BeanDefinitionValidationException in case of validation failure
	 */
	public function validate(Void):Void {
		if (lazyInit && !singleton) {
			throw new BeanDefinitionValidationException("Lazy initialization is only applicable to singleton beans.", this, arguments);
		}
		if (!getMethodOverrides().isEmpty() && getFactoryMethodName() != null) {
			throw new BeanDefinitionValidationException(
					"Cannot combine static factory method with method overrides: " +
					"the static factory method must create the instance", this, arguments);
		}
		if (hasBeanClass()) {
			// Check that lookup methods exists
			var overrides:Array = getMethodOverrides().getOverrides();
			for (var i:Number = 0; i < overrides.length; i++) {
				validateMethodOverride(overrides[i]);
			}
		}
	}
	
	/**
	 * Validate the given method override.
	 * Checks for existence of a method with the specified name.
	 * @param mo the MethodOverride object to validate
	 * @throws BeanDefinitionValidationException in case of validation failure
	 */
	private function validateMethodOverride(methodOverride:MethodOverride):Void {
		var methodName:String = methodOverride.getMethodName();
		if (beanClass[methodName] == null && beanClass.prototype[methodName] == null) {
			throw new BeanDefinitionValidationException(
			    "Invalid method override: no method with name '" + methodName + "' on class [" + beanClassName + "].", this, arguments);
		}
	}
	
	public function toString():String {
		var result:String = "class [";
		result += getBeanClassName() + "]";
		result += "; abstract=" + abstract;
		result += "; singleton=" + singleton;
		result += "; lazyInit=" + lazyInit;
		result += "; autowire=" + autowireMode;
		result += "; dependencyCheck=" + dependencyCheck;
		result += "; factoryBeanName=" + factoryBeanName;
		result += "; factoryMethodName=" + factoryMethodName;
		result += "; initMethodName=" + initMethodName;
		result += "; destroyMethodName=" + destroyMethodName;
		return result;
	}
	
}