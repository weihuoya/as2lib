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

import org.as2lib.aop.Weaver;
import org.as2lib.bean.converter.ClassConverter;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.config.BeanFactoryPostProcessor;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.support.AbstractBeanFactory;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationEvent;
import org.as2lib.context.ApplicationEventPublisher;
import org.as2lib.context.ApplicationListener;
import org.as2lib.context.ConfigurableApplicationContext;
import org.as2lib.context.event.ContextClosedEvent;
import org.as2lib.context.event.ContextRefreshedEvent;
import org.as2lib.context.HierarchicalMessageSource;
import org.as2lib.context.Lifecycle;
import org.as2lib.context.MessageSource;
import org.as2lib.context.support.ApplicationContextAwareProcessor;
import org.as2lib.context.support.DelegatingMessageSource;
import org.as2lib.data.holder.Map;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.context.support.AbstractApplicationContext extends AbstractBeanFactory implements ApplicationEventPublisher {
	
	/**
	 * Name of the {@link MessageSource} bean in the factory.
	 * If none is supplied, message resolution is delegated to the parent.
	 */
	public static var MESSAGE_SOURCE_BEAN_NAME:String = "messageSource";
	
	/**
	 * Name of the {@link EventDistributorControl} bean in the factory.
	 * If none is supplied, the default {@link SimpleEventDistributorControl} is used.
	 */
	public static var EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME:String = "eventDistributorControl";
	
	/**
	 * Names of the {@link Weaver} bean in this factory.
	 */
	public static var WEAVER_BEAN_NAME:String = "weaver";
	
	/** Parent context. */
	private var parent:ApplicationContext;
	
	/** Display name. */
	private var displayName:String;
	
	/** System time in milliseconds when this context started */
	private var startupTime:Number;
	
	/** Flag that indicates whether this context is currently active. */
	private var active:Boolean;
	
	/** {@link BeanFactoryPostProcessor} instances to apply on refresh. */
	private var beanFactoryPostProcessors:Array;
	
	/** Message source to look-up localized messages. */
	private var messageSource:MessageSource;
	
	/** Event distributor control to distribute events. */
	private var eventDistributorControl:EventDistributorControl;
	
	/** Weaver to weave-in cross-cutting concerns code. */
	private var weaver:Weaver;
	
	/**
	 * Constructs a new {@code AbstractApplicationContext} instance.
	 * 
	 * @param parent the parent of this application context
	 */
	private function AbstractApplicationContext(parent:ApplicationContext) {
		this.parent = parent;
		active = true;
		beanFactoryPostProcessors = new Array();
	}
	
	/**
	 * Returns this instance properly typed.
	 * 
	 * @return this instance
	 */
	private function getThis(Void):ApplicationContext {
		return ApplicationContext(this);
	}
	
	//---------------------------------------------------------------------
	// Implementation of ApplicationContext interface
	//---------------------------------------------------------------------
	
	public function getParent(Void):ApplicationContext {
		return parent;
	}
	
	public function getDisplayName(Void):String {
		if (displayName == null) displayName = ReflectUtil.getTypeNameForInstance(this);
		return displayName;
	}
	
	/**
	 * Sets the display name of this context; typically done during initialization of
	 * concrete context implementations.
	 */
	public function setDisplayName(displayName:String):Void {
		this.displayName = displayName;
	}
	
	/**
	 * Returns the timestamp in milliseconds when this context was first loaded.
	 * 
	 * @return the start-up date
	 */
	public function getStartupDate(Void):Number {
		return startupTime;
	}
	
	public function getEventPublisher(Void):ApplicationEventPublisher {
		return this;
	}
	
	/**
	 * Returns the internal message source used by this context.
	 * 
	 * @return the internal message source
	 * @throws IllegalStateException if this context has not been initialized yet
	 */
	public function getMessageSource(Void):MessageSource {
		if (messageSource == null) {
			throw new IllegalStateException("Message source is not initialized - " +
					"Call 'refresh' before accessing messages via this context [" + this + "].", this, arguments);
		}
		return messageSource;
	}
	
	//---------------------------------------------------------------------
	// Implementation of ApplicationEventPublisher interface
	//---------------------------------------------------------------------
	
	/**
	 * Publishes the given {@code event} to all listeners.
	 * 
	 * <p>Note that listeners get initialized after the message source, to be able to
	 * access it within listeners. Thus, message sources cannot publish events.
	 * 
	 * @param event the event to publish (may be application-specific or a standard
	 * framework event)
	 */
	public function publishEvent(event:ApplicationEvent):Void {
		var eventDistributor:ApplicationListener = getEventDistributorControl().getDistributor();
		eventDistributor.onApplicationEvent(event);
		if (parent != null) {
			parent.getEventPublisher().publishEvent(event);
		}
	}
	
	/**
	 * Returns the event distributor control to publish events with.
	 * 
	 * <p>Note that there is no default event distributor control.
	 * 
	 * @return the event distributor control
	 * @throws IllegalStateException if either there is no event distributor control
	 * or it has not been initialized yet
	 */
	public function getEventDistributorControl(Void):EventDistributorControl {
		if (eventDistributorControl == null) {
			throw new IllegalStateException("Event distributor control not initialized: " +
					"Declare an event distributor or call 'refresh' before publishing events via this context [" + this + "].", this, arguments);
		}
		return eventDistributorControl;
	}
	
	/**
	 * Returns whether this context has an event distributor control.
	 * 
	 * @return {@code ture} if there is an event distributor and it has been initialized,
	 * otherwise {@code false}
	 */
	public function hasEventDistributorControl(Void):Boolean {
		return (eventDistributorControl != null);
	}
	
	//---------------------------------------------------------------------
	// Implementation of ConfigurableApplicationContext interface
	//---------------------------------------------------------------------
	
	public function setParent(parent:ApplicationContext):Void {
		this.parent = parent;
	}
	
	public function addBeanFactoryPostProcessor(beanFactoryPostProcessor:BeanFactoryPostProcessor):Void {
		beanFactoryPostProcessors.push(beanFactoryPostProcessor);
	}
	
	/**
	 * Returns the list of {@link BeanPostProcessor} instances that will be applied to
	 * beans created with this factory.
	 * 
	 * @return the list of bean post processors
	 */
	public function getBeanFactoryPostProcessors(Void):Array {
		return beanFactoryPostProcessors.concat();
	}
	
	public function refresh(Void):Void {
		this.startupTime = (new Date()).getTime();
		// tells subclass to refresh the internal bean factory
		refreshBeanFactory();
		var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
		// populates the bean factory with context-specific resource editors
		beanFactory.registerPropertyValueConverter(Function, new ClassConverter());
		// configures the bean factory with context semantics
		beanFactory.addBeanPostProcessor(new ApplicationContextAwareProcessor(getThis()));
		// allows post-processing of the bean factory in context subclasses
		postProcessBeanFactory(beanFactory);
		// invokes factory processors registered with the context instance
		for (var i:Number = 0; i < beanFactoryPostProcessors.length; i++) {
			var factoryProcessor:BeanFactoryPostProcessor = beanFactoryPostProcessors[i];
			factoryProcessor.postProcessBeanFactory(beanFactory);
		}
		try {
			// invokes factory processors registered as beans in the context
			invokeBeanFactoryPostProcessors();
			// registers bean processors that intercept bean creation
			registerBeanPostProcessors();
			// initializes weaver for this context
			initWeaver();
			// initializes message source for this context
			initMessageSource();
			// initializes event distributor control for this context
			initEventDistributorControl();
			// initializes other special beans in specific context subclasses
			onRefresh();
			// checks for listener beans and registers them
			registerListeners();
			// instantiates singletons this late to allow them to access the message source
			beanFactory.preInstantiateSingletons();
			// publishes corresponding event
			if (hasEventDistributorControl()) {
				publishEvent(new ContextRefreshedEvent(getThis()));
			}
			active = true;
		}
		catch (exception:org.as2lib.bean.BeanException) {
			// destroys already created singletons to avoid dangling resources
			beanFactory.destroySingletons();
			throw exception;
		}
	}
	
	/**
	 * Modifies the application context's internal bean factory after its standard
	 * initialization. All bean definitions will have been loaded, but no beans
	 * will have been instantiated yet. This allows for registering special bean post
	 * processors etc. in certain application contexts.
	 * 
	 * @param beanFactory the bean factory used by this application context
	 * @throws BeanException in case of errors
	 */
	private function postProcessBeanFactory(beanFactory:ConfigurableListableBeanFactory):Void {
	}
	
	/**
	 * Instantiates and invokes all registered post-processor beans. Must be called
	 * before singleton instantiation.
	 */
	private function invokeBeanFactoryPostProcessors(Void):Void {
		// Do not initialize FactoryBeans here: We need to leave all regular beans
		// uninitialized to let the bean factory post-processors apply to them!
		var factoryProcessorNames:Array = getBeanNamesForType(BeanFactoryPostProcessor, true, false);
		// Invoke BeanFactoryPostProcessors, one by one.
		for (var i:Number = 0; i < factoryProcessorNames.length; i++) {
			var factoryProcessorName:String = factoryProcessorNames[i];
			var factoryProcessor:BeanFactoryPostProcessor = getBean(factoryProcessorName);
			factoryProcessor.postProcessBeanFactory(getBeanFactory());
		}
	}
	
	/**
	 * Instantiates and invokes all registered post-processor beans.
	 * 
	 * <p>Must be called before any instantiation of application beans.
	 */
	private function registerBeanPostProcessors(Void):Void {
		// Actually fetch and register the BeanPostProcessor beans.
		// Do not initialize FactoryBeans here: We need to leave all regular beans
		// uninitialized to let the bean post-processors apply to them!
		var beanProcessors:Array = getBeansOfType(BeanPostProcessor, true, false).getValues();
		for (var i:Number = 0; i < beanProcessors.length; i++) {
			getBeanFactory().addBeanPostProcessor(beanProcessors[i]);
		}
	}
	
	/**
	 * Initializes the weaver if it exists.
	 */
	private function initWeaver(Void):Void {
		if (containsLocalBean(WEAVER_BEAN_NAME)) {
			weaver = getBean(WEAVER_BEAN_NAME, Weaver);
			weaver.weave();
		}
	}

	/**
	 * Initializes the message source.
	 */
	private function initMessageSource(Void):Void {
		if (containsLocalBean(MESSAGE_SOURCE_BEAN_NAME)) {
			messageSource = getBean(MESSAGE_SOURCE_BEAN_NAME, MessageSource);
			// Make MessageSource aware of parent MessageSource.
			if (parent != null && messageSource instanceof HierarchicalMessageSource) {
				var hms:HierarchicalMessageSource = HierarchicalMessageSource(messageSource);
				if (hms.getParentMessageSource() == null) {
					// Only set parent context as parent MessageSource if no parent MessageSource
					// registered already.
					hms.setParentMessageSource(getParent().getMessageSource());
				}
			}
		}
		else {
			// Use empty MessageSource to be able to accept getMessage calls.
			messageSource = new DelegatingMessageSource(getParent().getMessageSource());
		}
	}
	
	/**
	 * Initializes the event distributor control.
	 * 
	 * <p>Note that there is no default distributor.
	 */
	private function initEventDistributorControl(Void):Void {
		if (containsLocalBean(EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME)) {
			eventDistributorControl = getBean(EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME, EventDistributorControl);
		}
	}
	
	/**
	 * Returns whether the local bean factory of this context contains a bean of the
	 * given {@code beanName}, ignoring beans defined in ancestor contexts.
	 * 
	 * <p>Needs to check both bean definitions and manually registered singletons.
	 * We cannot use {@code containsBean} here, as we do not want a bean from an
	 * ancestor bean factory.
	 * 
	 * @param beanName the name of the bean to check whether it is contained
	 * @return {@code true} if this context contains such a bean else {@code false}
	 */
	private function containsLocalBean(beanName:String):Boolean {
		return (containsBeanDefinition(beanName) || getBeanFactory().containsSingleton(beanName));
	}
	
	/**
	 * Refreshes this context.
	 * 
	 * <p>This method is a template method which can be overridden to add
	 * context-specific refresh work. Called on initialization of special beans, before
	 * instantiation of singletons.
	 * 
	 * @throws BeansException in case of errors during refresh
	 * @see #refresh
	 */
	private function onRefresh(Void):Void {
		// For subclasses: do nothing by default.
	}
	
	/**
	 * Adds beans that implement the {@link ApplicationListener} interface as listeners.
	 * This does not affect other listeners, which can be added without being beans.
	 */
	private function registerListeners(Void):Void {
		// Do not initialize FactoryBeans here: We need to leave all regular beans
		// uninitialized to let post-processors apply to them!
		var listeners:Array = getBeansOfType(ApplicationListener, true, false).getValues();
		for (var i:Number = 0; i < listeners.length; i++) {
			addListener(listeners[i]);
		}
	}
	
	/**
	 * Registers an application listener. Any beans in this context that are listeners
	 * are automatically added.
	 * 
	 * @param listener the listener to register
	 */
	private function addListener(listener:ApplicationListener):Void {
		getEventDistributorControl().addListener(listener);
	}
	
	/**
	 * Destroys this instance by invoking the {@link close} method.
	 * 
	 * <p>This method corresponds to the {@link DisposableBean} callback for
	 * destruction of this context. Only called when this context itself is
	 * running as a bean in another bean factory or application context, which is
	 * rather unusual.
	 */
	public function destroy(Void):Void {
		close();
	}
	
	/**
	 * Closes this application context, destroying all beans in its bean factory.
	 */
	public function close(Void):Void {
		if (active) {
			try {
				if (hasEventDistributorControl()) {
					publishEvent(new ContextClosedEvent(getThis()));
				}
			}
			finally {
				// Destroy all cached singletons in this context, invoking
				// DisposableBean.destroy and/or the specified "destroy-method".
				var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
				if (beanFactory != null) {
					beanFactory.destroySingletons();
				}
			}
			active = false;
		}
	}
	
	//---------------------------------------------------------------------
	// Implementation of BeanFactory interface
	//---------------------------------------------------------------------
	
	public function getBeanByName(name:String) {
		return getBeanFactory().getBean(name);
	}
	
	public function getBeanByNameAndType(name:String, requiredType:Function) {
		return getBeanFactory().getBean(name, requiredType);
	}
	
	public function containsBean(name:String):Boolean {
		return getBeanFactory().containsBean(name);
	}
	
	public function isSingleton(name:String):Boolean {
		return getBeanFactory().isSingleton(name);
	}
	
	public function getType(name:String):Function {
		return getBeanFactory().getType(name);
	}
	
	public function getAliases(name:String):Array {
		return getBeanFactory().getAliases(name);
	}
	
	//---------------------------------------------------------------------
	// Implementation of ListableBeanFactory interface
	//---------------------------------------------------------------------
	
	public function containsBeanDefinition(name:String, includingAncestors:Boolean):Boolean {
		return getBeanFactory().containsBeanDefinition(name, includingAncestors);
	}
	
	public function getBeanDefinitionCount(includingAncestors:Boolean):Number {
		return getBeanFactory().getBeanDefinitionCount(includingAncestors);
	}
	
	public function getBeanDefinitionNames(includingAncestors:Boolean):Array {
		return getBeanFactory().getBeanDefinitionNames(includingAncestors);
	}
	
	public function getBeanNames(includingAncestors:Boolean):Array {
		return getBeanFactory().getBeanNames(includingAncestors);
	}
	
	public function getBeanNamesForType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Array {
		return getBeanFactory().getBeanNamesForType(type, includePrototypes, includeFactoryBeans, includingAncestors);
	}
	
	public function getBeansOfType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Map {
		return getBeanFactory().getBeansOfType(type, includePrototypes, includeFactoryBeans, includingAncestors);
	}
	
	//---------------------------------------------------------------------
	// Implementation of HierarchicalBeanFactory interface
	//---------------------------------------------------------------------
	
	public function getParentBeanFactory(Void):BeanFactory {
		return getParent();
	}
	
	/**
	 * Returns the internal bean factory of the parent context if it implements the
	 * {@link ConfigurableApplicationContext} class; else, returnr the parent context
	 * itself.
	 */
	private function getInternalParentBeanFactory(Void):BeanFactory {
		return (getParent() instanceof ConfigurableApplicationContext) ?
				ConfigurableApplicationContext(getParent()).getBeanFactory() : getParent();
	}
	
	//---------------------------------------------------------------------
	// Implementation of Lifecycle interface
	//---------------------------------------------------------------------
	
	public function start(Void):Void {
		var lifecycles:Array = getLifecycleBeans();
		for (var i:Number = 0; i < lifecycles.length; i++) {
			var lifecycle:Lifecycle = lifecycles[i];
			if (!lifecycle.isRunning()) {
				lifecycle.start();
			}
		}
	}
	
	public function stop(Void):Void {
		var lifecycles:Array = getLifecycleBeans();
		for (var i:Number = 0; i < lifecycles.length; i++) {
			var lifecycle:Lifecycle = lifecycles[i];
			if (lifecycle.isRunning()) {
				lifecycle.stop();
			}
		}
	}
	
	public function isRunning(Void):Boolean {
		var lifecycles:Array = getLifecycleBeans();
		for (var i:Number = 0; i < lifecycles.length; i++) {
			var lifecycle:Lifecycle = lifecycles[i];
			if (!lifecycle.isRunning()) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Returns a collection of all singleton beans that implement the {@link Lifecycle}
	 * interface in this context.
	 * 
	 * @return all singleton lifecycle beans
	 */
	private function getLifecycleBeans(Void):Array {
		return getBeanFactory().getBeansOfType(Lifecycle, false, false).getValues();
	}
	
	//---------------------------------------------------------------------
	// Abstract methods that must be implemented by subclasses
	//---------------------------------------------------------------------
	
	/**
	 * Refreshes the bean factory.
	 * 
	 * <p>Subclasses must implement this method to perform the actual configuration load.
	 * The method is invoked by refresh before any other initialization work.
	 * 
	 * <p>A subclass will either create a new bean factory and hold a reference to it,
	 * or return a single bean factory instance that it holds. In the latter case, it
	 * will usually throw an illegal state exception if refreshing the context more than
	 * once.
	 * 
	 * @throws BeanException if initialization of the bean factory failed
	 * @throws IllegalStateException if already initialized and multiple refresh attempts
	 * are not supported
	 * @see #refresh
	 */
	private function refreshBeanFactory(Void):Void {
		throw new AbstractOperationException("This method is marked as abstract and must be overridden by sub-classes.", this, arguments);
	}
	
	/**
	 * Returns the internal bean factory.
	 * 
	 * <p>Subclasses must return their internal bean factory here. They should implement
	 * the lookup efficiently, so that it can be called repeatedly without a performance
	 * penalty.
	 * 
	 * @return this application context's internal bean factory
	 * @throws IllegalStateException if the context does not hold an internal bean factory
	 * yet (usually if {@code refresh} has never been called)
	 * @see #refresh
	 */
	public function getBeanFactory(Void):ConfigurableListableBeanFactory {
		throw new AbstractOperationException("This method is marked as abstract and must be overridden by sub-classes.", this, arguments);
		return null;
	}
	
}