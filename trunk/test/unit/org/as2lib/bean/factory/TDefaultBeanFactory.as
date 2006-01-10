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
import org.as2lib.bean.factory.BeanWithDestroyMethod;
import org.as2lib.bean.factory.BeanWithDisposableBean;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.config.InstantiationAwareBeanPostProcessor;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.DependenciesBean;
import org.as2lib.bean.factory.DummyFactory;
import org.as2lib.bean.factory.DummyReferencer;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.LifecycleBean;
import org.as2lib.bean.factory.LifecycleBeanPostProcessor;
import org.as2lib.bean.factory.MustBeInitialized;
import org.as2lib.bean.factory.parser.XmlBeanDefinitionParser;
import org.as2lib.bean.factory.support.ChildBeanDefinition;
import org.as2lib.bean.factory.support.DefaultBeanFactory;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.NestedTestBean;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.bean.TestBean;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.list.ArrayList;
import org.as2lib.data.holder.Map;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.TDefaultBeanFactory extends TestCase {
	
	private var parent:DefaultBeanFactory;
	private var factory:DefaultBeanFactory;
	
	public function setUp(Void):Void {
		parent = new DefaultBeanFactory();
		
		var pvs1:PropertyValues = new PropertyValues();
		pvs1.addPropertyValue("name", "Albert");
		parent.registerBeanDefinition("father", new RootBeanDefinition(TestBean, pvs1));
		
		var pvs2:PropertyValues = new PropertyValues();
		pvs2.addPropertyValue("name", "Roderick");
		parent.registerBeanDefinition("rod", new RootBeanDefinition(TestBean, pvs2));
		
		factory = new DefaultBeanFactory(parent);
		var parser:XmlBeanDefinitionParser = new XmlBeanDefinitionParser(factory);
		parser.parse(getXmlBeanDefinition());
		var bpp:BeanPostProcessor = createBeanPostProcessor();
		bpp.postProcessBeforeInitialization = function(bean, beanName:String) {
			if (bean instanceof TestBean) {
				TestBean(bean).setPostProcessed(true);
			}
			if (bean instanceof DummyFactory) {
				DummyFactory(bean).setPostProcessed(true);
			}
			return bean;
		};
		bpp.postProcessAfterInitialization = function(bean, beanName:String) {
			return bean;
		};
		factory.addBeanPostProcessor(bpp);
		factory.addBeanPostProcessor(new LifecycleBeanPostProcessor());
		factory.preInstantiateSingletons();
	}

	private function getXmlBeanDefinition(Void):String {
		var a = MustBeInitialized;
		a = LifecycleBean;
		a = LifecycleBeanPostProcessor;
		a = TestBean;
		a = DummyReferencer;
		return "<?xml version='1.0' encoding='UTF-8'?>
				<!DOCTYPE beans PUBLIC '-//SPRING//DTD BEAN//EN' 'http://www.springframework.org/dtd/spring-beans.dtd'>
				
				<beans>
				
					<bean id='validEmptyWithDescription' class='org.as2lib.bean.TestBean'>
						<description>
							I have no properties and I'm happy without them.
						</description>
					</bean>
				
					<!--
						Check automatic creation of alias, to allow for names that are illegal as XML ids.
					-->
					<bean id='aliased' class='org.as2lib.bean.TestBean' name='myalias'>
						<property name='name'><value>aliased</value></property>
					</bean>
				
					<alias name='aliased' alias='youralias'/>
				
					<alias name='multiAliased' alias='alias3'/>
				
					<bean id='multiAliased' class='org.as2lib.bean.TestBean' name='alias1,alias2'>
						<property name='name'><value>aliased</value></property>
					</bean>
				
					<alias name='multiAliased' alias='alias4'/>
				
					<bean class='org.as2lib.bean.TestBean' name='aliasWithoutId1,aliasWithoutId2,aliasWithoutId3'>
						<property name='name'><value>aliased</value></property>
					</bean>
				
					<bean class='org.as2lib.bean.TestBean'>
						<property name='name'><null/></property>
					</bean>
				
					<bean class='org.as2lib.bean.factory.DummyReferencer'/>
				
					<bean class='org.as2lib.bean.factory.DummyReferencer'/>
				
					<bean class='org.as2lib.bean.factory.DummyReferencer'/>
				
					<bean id='rod' class='org.as2lib.bean.TestBean'>
						<property name='name'><value><!-- a comment -->Rod</value></property>
						<property name='age'><value>31</value></property>
						<property name='spouse'><ref bean='father'/></property>
						<property name='touchy'><value/></property>
					</bean>
				
					<bean id='roderick' parent='rod'>
						<property name='name'><value>Roderick<!-- a comment --></value></property>
						<!-- Should inherit age -->
					</bean>
				
					<bean id='kerry' class='org.as2lib.bean.TestBean'>
						<property name='name'><value>Ker<!-- a comment -->ry</value></property>
						<property name='age'><value>34</value></property>
						<property name='spouse'><ref local='rod'/></property>
						<property name='touchy'><value></value></property>
					</bean>
				
					<bean id='kathy' class='org.as2lib.bean.TestBean' singleton='false'>
						<property name='name'><value>Kathy</value></property>
						<property name='age'><value>28</value></property>
						<property name='spouse'><ref bean='father'/></property>
					</bean>
				
					<bean id='typeMismatch' class='org.as2lib.bean.TestBean' singleton='false'>
						<property name='name'><value>typeMismatch</value></property>
						<property name='age'><value>34x</value></property>
						<property name='spouse'><ref local='rod'/></property>
					</bean>
				
					<!-- Test of lifecycle callbacks -->
					<bean id='mustBeInitialized' class='org.as2lib.bean.factory.MustBeInitialized'/>
				
					<bean id='lifecycle' class='org.as2lib.bean.factory.LifecycleBean'
						  init-method='declaredInitMethod'>
						<property name='initMethodDeclared'><value>true</value></property>
					</bean>
				
					<!-- Factory beans are automatically treated differently -->
					<bean id='singletonFactory'	class='org.as2lib.bean.factory.DummyFactory'>
					</bean>
				
					<bean id='prototypeFactory'	class='org.as2lib.bean.factory.DummyFactory'>
						<property name='singleton' type='Boolean'><value>false</value></property>
					</bean>
				
					<!-- Check that the circular reference resolution mechanism doesn't break
					     repeated references to the same FactoryBean -->
					<bean id='factoryReferencer' class='org.as2lib.bean.factory.DummyReferencer'>
						<property name='testBean1'><ref bean='singletonFactory'/></property>
						<property name='testBean2'><ref local='singletonFactory'/></property>
						<property name='dummyFactory'><ref bean='&amp;singletonFactory'/></property>
					</bean>
				
					<bean id='factoryReferencerWithConstructor' class='org.as2lib.bean.factory.DummyReferencer'>
						<constructor-arg><ref bean='&amp;singletonFactory'/></constructor-arg>
						<property name='testBean1'><ref bean='singletonFactory'/></property>
						<property name='testBean2'><ref local='singletonFactory'/></property>
					</bean>
				
					<!-- Check that the circular reference resolution mechanism doesn't break
					     prototype instantiation -->
					<bean id='prototypeReferencer' class='org.as2lib.bean.factory.DummyReferencer' singleton='false'>
						<property name='testBean1'><ref local='kathy'/></property>
						<property name='testBean2'><ref bean='kathy'/></property>
					</bean>
				
					<bean id='listenerVeto' class='org.as2lib.bean.TestBean'>
						<property name='name'><value>listenerVeto</value></property>
						<property name='age'><value>66</value></property>
					</bean>
				
					<bean id='validEmpty' class='org.as2lib.bean.TestBean'/>
				
					<bean id='commentsInValue' class='org.as2lib.bean.TestBean'>
					  <property name='name'><value>this is<!-- don't mind me --> a <![CDATA[<!--comment-->]]></value></property>
					</bean>
				
				</beans>
				";
	}

	private function getBeanFactory(Void):DefaultBeanFactory {
		return factory;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// AbstractBeanFactoryTests
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function testInheritance(Void):Void {
		assertTrue(getBeanFactory().containsBean("rod"));
		assertTrue(getBeanFactory().containsBean("roderick"));
		var rod:TestBean = getBeanFactory().getBean("rod");
		var roderick:TestBean = getBeanFactory().getBean("roderick");
		assertTrue("not == ", rod != roderick);
		assertTrue("rod.name is Rod", rod.getName() == "Rod");
		assertTrue("rod.age is 31", rod.getAge() == 31);
		assertTrue("roderick.name is Roderick", roderick.getName() == "Roderick");
		assertTrue("roderick.age was inherited", roderick.getAge() == rod.getAge());
	}
	
	/*public function testGetBeanWithNullArg(Void):Void {
		try {
			getBeanFactory().getBean(null);
			fail("Can't get null bean");
		}
		catch (exception:org.as2lib.env.except.IllegalArgumentException) {
			// OK
		}
	}*/
	
	/**
	 * Test that InitializingBean objects receive the
	 * afterPropertiesSet() callback
	 */
	public function testInitializingBeanCallback(Void):Void {
		var mbi:MustBeInitialized = getBeanFactory().getBean("mustBeInitialized");
		// The dummy business method will throw an exception if the
		// afterPropertiesSet() callback wasn't invoked
		mbi.businessMethod();
	}
	
	/**
	 * Test that InitializingBean/BeanFactoryAware/DisposableBean objects receive the
	 * afterPropertiesSet() callback before BeanFactoryAware callbacks
	 */
	public function testLifecycleCallbacks(Void):Void {
		var lb:LifecycleBean = getBeanFactory().getBean("lifecycle");
		assertEquals("lifecycle", lb.getBeanName());
		// The dummy business method will throw an exception if the
		// necessary callbacks weren't invoked in the right order.
		lb.businessMethod();
		assertTrue("Not destroyed", !lb.isDestroyed());
	}
	
	public function testFindsValidInstance(Void):Void {
		try {
			var o = getBeanFactory().getBean("rod");
			assertTrue("Rod bean is a TestBean", o instanceof TestBean);
			var rod:TestBean = o;
			assertTrue("rod.name is Rod", rod.getName() == "Rod");
			assertTrue("rod.age is 31", rod.getAge() == 31);
		}
		catch (exception) {
			fail("Shouldn't throw exception on getting valid instance: " + exception);
		}
	}
	
	public function testGetInstanceByMatchingClass(Void):Void {
		try {
			var o:TestBean = getBeanFactory().getBean("rod", TestBean);
			assertTrue("Rod bean is a TestBean", o instanceof TestBean);
		}
		catch (exception) {
			fail("Shouldn't throw exception on getting valid instance with matching class: " + exception);
		}
	}
	
	public function testGetInstanceByNonmatchingClass(Void):Void {
		try {
			var o = getBeanFactory().getBean("rod", BeanFactory);
			fail("Rod bean is not of type BeanFactory; getBeanInstance(rod, BeanFactory.class) should throw BeanNotOfRequiredTypeException");
		}
		catch (ex:org.as2lib.bean.factory.BeanNotOfRequiredTypeException) {
			// So far, so good
			assertTrue("Exception has correct bean name", ex.getBeanName() == "rod");
			assertTrue("Exception requiredType must be BeanFactory.class", ex.getRequiredType() == BeanFactory);
			assertTrue("Exception actualType as TestBean.class", ex.getActualType().prototype instanceof TestBean || ex.getActualType() == TestBean);
			assertTrue("Actual type is correct", ex.getActualType() == eval("_global." + ReflectUtil.getTypeName(getBeanFactory().getBean("rod"))));
		}
		catch (ex) {
			fail("Shouldn't throw exception on getting valid instance: " + ex);
		}
	}
	
	public function testGetSharedInstanceByMatchingClass(Void):Void {
		try {
			var o = getBeanFactory().getBean("rod", TestBean);
			assertTrue("Rod bean is a TestBean", o instanceof TestBean);
		}
		catch (exception) {
			fail("Shouldn't throw exception on getting valid instance with matching class: " + exception);
		}
	}
	
	public function testGetSharedInstanceByMatchingClassNoCatch(Void):Void {
		var o = getBeanFactory().getBean("rod", TestBean);
		assertTrue("Rod bean is a TestBean", o instanceof TestBean);
	}
	
	public function testGetSharedInstanceByNonmatchingClass(Void):Void {
		try {
			var o = getBeanFactory().getBean("rod", BeanFactory);
			fail("Rod bean is not of type BeanFactory; getBeanInstance(rod, BeanFactory.class) should throw BeanNotOfRequiredTypeException");
		}
		catch (ex:org.as2lib.bean.factory.BeanNotOfRequiredTypeException) {
			// So far, so good
			assertTrue("Exception has correct bean name", ex.getBeanName() == "rod");
			assertTrue("Exception requiredType must be BeanFactory.class", ex.getRequiredType() == BeanFactory);
			assertTrue("Exception actualType as TestBean.class", ex.getActualType() == TestBean || ex.getActualType().prototype instanceof TestBean);
		}
		catch (ex) {
			fail("Shouldn't throw exception on getting valid instance: " + ex);
		}
	}

	public function testSharedInstancesAreEqual() {
		try {
			var o = getBeanFactory().getBean("rod");
			assertTrue("Rod bean1 is a TestBean", o instanceof TestBean);
			var o1 = getBeanFactory().getBean("rod");
			assertTrue("Rod bean2 is a TestBean", o1 instanceof TestBean);
			assertTrue("Object equals applies", o == o1);
		}
		catch (ex) {
			fail("Shouldn't throw exception on getting valid instance: " + ex);
		}
	}
	
	public function testPrototypeInstancesAreIndependent() {
		var tb1:TestBean = getBeanFactory().getBean("kathy");
		var tb2:TestBean = getBeanFactory().getBean("kathy");
		assertTrue("ref equal DOES NOT apply", tb1 != tb2);
		assertTrue("object equal true", tb1.equals(tb2));
		tb1.setAge(1);
		tb2.setAge(2);
		assertTrue("1 age independent = 1", tb1.getAge() == 1);
		assertTrue("2 age independent = 2", tb2.getAge() == 2);
		assertTrue("object equal now false", !tb1.equals(tb2));
	}

	public function testNotThere() {
		assertFalse(getBeanFactory().containsBean("Mr Squiggle"));
		try {
			var o = getBeanFactory().getBean("Mr Squiggle");
			fail("Can't find missing bean");
		}
		catch (ex:org.as2lib.bean.BeanException) {
			//fail("Shouldn't throw exception on getting valid instance: " + ex);
		}
	}

	public function testValidEmpty() {
		try {
			var o = getBeanFactory().getBean("validEmpty");
			assertTrue("validEmpty bean is a TestBean", o instanceof TestBean);
			var ve:TestBean = o;
			assertTrue("Valid empty has defaults", ve.getName() == null && ve.getAge() == 0 && ve.getSpouse() == null);
		}
		catch (ex:org.as2lib.bean.BeanException) {
			fail("Shouldn't throw exception on valid empty: " + ex);
		}
	}
	
	/*public function testTypeMismatch() {
		try {
			var o = getBeanFactory().getBean("typeMismatch");
			fail("Shouldn't succeed with type mismatch");
		}
		catch (wex:org.as2lib.bean.factory.BeanCreationException) {
			assertEquals("typeMismatch", wex.getBeanName());
			assertTrue(wex.getCause() instanceof PropertyAccessExceptionsException);
			var ex:PropertyAccessExceptionsException = wex.getCause();
			// Further tests
			assertTrue("Has one error ", ex.getExceptionCount() == 1);
			assertTrue("Error is for field age", ex.getPropertyAccessException("age") != null);

			var tb:TestBean = ex.getBeanWrapper().getWrappedInstance();
			assertTrue("Age still has default", tb.getAge() == 0);
			assertTrue("We have rejected age in exception", ex.getPropertyAccessException("age").getPropertyChangeEvent().getNewValue().equals("34x"));
			assertTrue("valid name stuck", tb.getName() == "typeMismatch");
			assertTrue("valid spouse stuck", tb.getSpouse().getName() == "Rod");
		}
	}*/

	public function testGrandparentDefinitionFoundInBeanFactory() {
		var dad:TestBean = getBeanFactory().getBean("father");
		assertTrue("Dad has correct name", dad.getName() == "Albert");
	}

	public function testFactorySingleton() {
		assertTrue(getBeanFactory().isSingleton("&singletonFactory"));
		assertTrue(getBeanFactory().isSingleton("singletonFactory"));
		var tb:TestBean = getBeanFactory().getBean("singletonFactory");
		assertTrue("Singleton from factory has correct name, not " + tb.getName(), tb.getName() == DummyFactory.SINGLETON_NAME);
		var factory:DummyFactory = getBeanFactory().getBean("&singletonFactory");
		var tb2:TestBean = getBeanFactory().getBean("singletonFactory");
		assertTrue("Singleton references ==", tb == tb2);
		assertTrue("FactoryBean is BeanFactoryAware", factory.getBeanFactory() != null);
	}
	
	public function testFactoryPrototype() {
		assertTrue(getBeanFactory().isSingleton("&prototypeFactory"));
		assertFalse(getBeanFactory().isSingleton("prototypeFactory"));
		var tb:TestBean = getBeanFactory().getBean("prototypeFactory");
		assertNotSame(tb.getName(), DummyFactory.SINGLETON_NAME);
		var tb2:TestBean = getBeanFactory().getBean("prototypeFactory");
		assertNotSame("Prototype references !=", tb, tb2);
	}
	
	/**
	 * Check that we can get the factory bean itself.
	 * This is only possible if we're dealing with a factory
	 * @throws Exception
	 */
	public function testGetFactoryItself() {
		var factory:DummyFactory = getBeanFactory().getBean("&singletonFactory");
		assertTrue(factory != null);
	}
	
	/**
	 * Check that afterPropertiesSet gets called on factory
	 * @
	 */
	public function testFactoryIsInitialized() {
		var tb:TestBean = getBeanFactory().getBean("singletonFactory");
		var factory:DummyFactory = getBeanFactory().getBean("&singletonFactory");
		assertTrue("Factory was initialized because it implemented InitializingBean", factory.wasInitialized());
	}
	
	/**
	 * It should be illegal to dereference a normal bean
	 * as a factory
	 */
	public function testRejectsFactoryGetOnNormalBean() {
		try {
			getBeanFactory().getBean("&rod");
			fail("Shouldn't permit factory get on normal bean");
		}
		catch (ex:org.as2lib.bean.factory.BeanIsNotAFactoryException) {
			// Ok
		}
	}
	
	// TODO: refactor in AbstractBeanFactory (tests for AbstractBeanFactory)
	// and rename this class
	public function testAliasing() {
		if (!(getBeanFactory() instanceof DefaultBeanFactory))
			return;
		
		var alias:String = "rods alias";
		try {
			getBeanFactory().getBean(alias);
			fail("Shouldn't permit factory get on normal bean");
		}
		catch (ex:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
			// Ok
			assertSame(alias, ex.getBeanName());
		}
		
		// Create alias
		DefaultBeanFactory(getBeanFactory()).registerAlias("rod", alias);
		var rod = getBeanFactory().getBean("rod");
		var aliasRod = getBeanFactory().getBean(alias);
		assertSame(rod, aliasRod);

		try {
			DefaultBeanFactory(getBeanFactory()).registerAlias("father", alias);
			fail("Should have thrown FatalBeanException");
		}
		catch (ex:org.as2lib.bean.FatalBeanException) {
			// expected
		}

		// TODO: check prototype support
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// AbstractListableBeanFactoryTests
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function testCount(Void):Void {
		assertCount(23);
	}
	
	private function assertCount(count:Number):Void {
		var defnames:Array = getBeanFactory().getBeanDefinitionNames();
		assertSame("We should have " + count + " beans, not " + defnames.length, defnames.length, count);
	}

	public function testTestBeanCount(Void):Void {
		assertTestBeanCount(13);
	}

	public function assertTestBeanCount(count:Number):Void {
		var defNames:Array = getBeanFactory().getBeanNamesForType(TestBean, true, false);
		assertTrue("We should have " + count + " beans for class org.as2lib.bean.TestBean, not " +
				defNames.length, defNames.length == count);
		var countIncludingFactoryBeans:Number = count + 2;
		var names:Array = getBeanFactory().getBeanNamesForType(TestBean, true, true);
		assertTrue("We should have " + countIncludingFactoryBeans +
				" beans for class org.as2lib.bean.TestBean, not " + names.length,
				names.length == countIncludingFactoryBeans);
	}

	public function testGetDefinitionsForNoSuchClass(Void):Void {
		var defnames:Array = getBeanFactory().getBeanNamesForType(String);
		assertTrue("No string definitions", defnames.length == 0);
	}
	
	/**
	 * Check that count refers to factory class, not bean class. (We don't know
	 * what type factories may return, and it may even change over time.)
	 */
	public function testGetCountForFactoryClass(Void):Void {
		var factories:Array = getBeanFactory().getBeanNamesForType(FactoryBean);
		assertSame("Should have 2 factories, not " + factories.length, factories.length, 2);
		factories = getBeanFactory().getBeanNamesForType(FactoryBean);
		assertSame("Should have 2 factories, not " + factories.length, factories.length, 2);
	}

	public function testContainsBeanDefinition(Void):Void {
		assertTrue(getBeanFactory().containsBeanDefinition("rod"));
		assertTrue(getBeanFactory().containsBeanDefinition("roderick"));
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// DefaultListableBeanFactoryTests
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function testCanReferenceParentBeanFromChildViaAlias(Void):Void {
        var PARENTS_ALIAS:String = "alias";
        var EXPECTED_NAME:String = "Juergen";
        var EXPECTED_AGE:Number = 41;

        var parentDefinition:RootBeanDefinition = new RootBeanDefinition(TestBean);
        parentDefinition.setAbstract(true);
        parentDefinition.getPropertyValues().addPropertyValue("name", EXPECTED_NAME);
        parentDefinition.getPropertyValues().addPropertyValue("age", EXPECTED_AGE);

        var childDefinition:ChildBeanDefinition = new ChildBeanDefinition(PARENTS_ALIAS);

        var factory:DefaultBeanFactory = new DefaultBeanFactory();
        factory.registerBeanDefinition("parent", parentDefinition);
        factory.registerBeanDefinition("child", childDefinition);
        factory.registerAlias("parent", PARENTS_ALIAS);

        var child:TestBean = factory.getBean("child");
        assertEquals(EXPECTED_NAME, child.getName());
        assertEquals(EXPECTED_AGE, child.getAge());
    }
    
    public function testEmpty(Void):Void {
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		assertTrue("No beans defined --> array != null", bf.getBeanDefinitionNames() != null);
		assertTrue("No beans defined after no arg constructor", bf.getBeanDefinitionNames().length == 0);
		assertTrue("No beans defined after no arg constructor", bf.getBeanDefinitionCount() == 0);
	}
	
	public function testSelfReference(Void):Void {
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		var pvs:PropertyValues = new PropertyValues();
		pvs.addPropertyValue("spouse", new RuntimeBeanReference("self"));
		bf.registerBeanDefinition("self", new RootBeanDefinition(TestBean, pvs));
		var self:TestBean = bf.getBean("self");
		assertEquals(self, self.getSpouse());
	}
	
	public function testBeanDefinitionOverriding(Void):Void {
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("test", new RootBeanDefinition(TestBean));
		bf.registerBeanDefinition("test", new RootBeanDefinition(NestedTestBean));
		assertTrue(bf.getBean("test") instanceof NestedTestBean);
	}
	
	public function testBeanDefinitionOverridingNotAllowed(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		lbf.setAllowBeanDefinitionOverriding(false);
		lbf.registerBeanDefinition("test", new RootBeanDefinition(TestBean, null));
		try {
			lbf.registerBeanDefinition("test", new RootBeanDefinition(NestedTestBean, null));
			fail("Should have thrown BeanDefinitionStoreException");
		}
		catch (exception:org.as2lib.bean.factory.BeanDefinitionStoreException) {
			assertEquals("test", exception.getBeanName());
			// expected
		}
	}
	
	public function testRegisterExistingSingletonWithAlreadyBound(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var singletonObject:TestBean = new TestBean();
		lbf.registerSingleton("singletonObject", singletonObject);
		try {
			lbf.registerSingleton("singletonObject", singletonObject);
			fail("Should have thrown BeanDefinitionStoreException");
		}
		catch (exception:org.as2lib.bean.factory.BeanDefinitionStoreException) {
			// expected
		}
	}
	
	public function testAutowireBeanByName(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:RootBeanDefinition = new RootBeanDefinition(TestBean, new PropertyValues());
		lbf.registerBeanDefinition("spouse", bd);
		var bean:DependenciesBean = lbf.autowire(DependenciesBean, DefaultBeanFactory.AUTOWIRE_BY_NAME, true);
		var spouse:TestBean = lbf.getBean("spouse");
		assertEquals(bean.getSpouse(), spouse);
		assertSame(lbf.getBeansOfType(TestBean).get("spouse"), spouse);
	}
	
	/*public function testAutowireBeanByNameWithDependencyCheck(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:RootBeanDefinition = new RootBeanDefinition(TestBean, new PropertyValues());
		lbf.registerBeanDefinition("spous", bd);
		try {
			lbf.autowire(DependenciesBean, DefaultBeanFactory.AUTOWIRE_BY_NAME, true);
			fail("Should have thrown UnsatisfiedDependencyException");
		}
		catch (ex:org.as2lib.bean.factory.UnsatisfiedDependencyException) {
			// expected
		}
	}*/

	/*public void testAutowireBeanByNameWithNoDependencyCheck() {
		DefaultListableBeanFactory lbf = new DefaultListableBeanFactory();
		RootBeanDefinition bd = new RootBeanDefinition(TestBean.class, new MutablePropertyValues());
		lbf.registerBeanDefinition("spous", bd);
		DependenciesBean bean = (DependenciesBean)
				lbf.autowire(DependenciesBean.class, AutowireCapableBeanFactory.AUTOWIRE_BY_NAME, false);
		assertNull(bean.getSpouse());
	}*/
	
	public function testAutowireExistingBeanByName(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:RootBeanDefinition = new RootBeanDefinition(TestBean, new PropertyValues());
		lbf.registerBeanDefinition("spouse", bd);
		var existingBean:DependenciesBean = new DependenciesBean();
		lbf.autowireBeanProperties(existingBean, DefaultBeanFactory.AUTOWIRE_BY_NAME, true);
		var spouse:TestBean = lbf.getBean("spouse");
		assertEquals(existingBean.getSpouse(), spouse);
		assertSame(lbf.getBeansOfType(TestBean).get("spouse"), spouse);
	}

	/*public void testAutowireExistingBeanByNameWithDependencyCheck() {
		DefaultListableBeanFactory lbf = new DefaultListableBeanFactory();
		RootBeanDefinition bd = new RootBeanDefinition(TestBean.class, new MutablePropertyValues());
		lbf.registerBeanDefinition("spous", bd);
		DependenciesBean existingBean = new DependenciesBean();
		try {
			lbf.autowireBeanProperties(existingBean, AutowireCapableBeanFactory.AUTOWIRE_BY_NAME, true);
			fail("Should have thrown UnsatisfiedDependencyException");
		}
		catch (UnsatisfiedDependencyException ex) {
			// expected
		}
	}

	public void testAutowireExistingBeanByNameWithNoDependencyCheck() {
		DefaultListableBeanFactory lbf = new DefaultListableBeanFactory();
		RootBeanDefinition bd = new RootBeanDefinition(TestBean.class, new MutablePropertyValues());
		lbf.registerBeanDefinition("spous", bd);
		DependenciesBean existingBean = new DependenciesBean();
		lbf.autowireBeanProperties(existingBean, AutowireCapableBeanFactory.AUTOWIRE_BY_NAME, false);
		assertNull(existingBean.getSpouse());
	}
	
	public void testInvalidAutowireMode() {
		DefaultListableBeanFactory lbf = new DefaultListableBeanFactory();
		try {
			lbf.autowireBeanProperties(new TestBean(), 0, false);
			fail("Should have thrown IllegalArgumentException");
		}
		catch (IllegalArgumentException ex) {
			// expected
		}
	}*/
	
	public function testExtensiveCircularReference(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		for (var i:Number = 0; i < 20; i++) {
			var pvs:PropertyValues = new PropertyValues();
			pvs.addPropertyValue(new PropertyValue("spouse", new RuntimeBeanReference("bean" + (i < 19 ? i+1 : 0))));
			var bd:RootBeanDefinition = new RootBeanDefinition(TestBean, pvs);
			lbf.registerBeanDefinition("bean" + i, bd);
		}
		lbf.preInstantiateSingletons();
		for (var i:Number = 0; i < 20; i++) {
			var bean:TestBean = lbf.getBean("bean" + i);
			var otherBean:TestBean = lbf.getBean("bean" + (i < 19 ? i+1 : 0));
			assertTrue(bean.getSpouse() == otherBean);
		}
	}
	
	public function testApplyPropertyValues(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var pvs:PropertyValues = new PropertyValues();
		pvs.addPropertyValue("age", "99");
		lbf.registerBeanDefinition("test", new RootBeanDefinition(TestBean, pvs));
		var tb:TestBean = new TestBean();
		assertEquals(0, tb.getAge());
		lbf.applyBeanPropertyValues(tb, "test");
		assertEquals(99, tb.getAge());
	}

	public function testApplyPropertyValuesWithIncompleteDefinition(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var pvs:PropertyValues = new PropertyValues();
		pvs.addPropertyValue("age", "99");
		lbf.registerBeanDefinition("test", new RootBeanDefinition(null, pvs));
		var tb:TestBean = new TestBean();
		assertEquals(0, tb.getAge());
		lbf.applyBeanPropertyValues(tb, "test");
		assertEquals(99, tb.getAge());
	}
	
	public function testBeanPostProcessorWithWrappedObjectAndDisposableBean(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:RootBeanDefinition = new RootBeanDefinition(BeanWithDisposableBean, null);
		lbf.registerBeanDefinition("test", bd);
		var beanPostProcessor:BeanPostProcessor = createBeanPostProcessor();
		beanPostProcessor.postProcessBeforeInitialization = function(bean, beanName:String) {
			return new TestBean();
		};
		beanPostProcessor.postProcessAfterInitialization = function(bean, beanName:String) {
			return bean;
		};
		lbf.addBeanPostProcessor(beanPostProcessor);
		BeanWithDisposableBean.closed = false;
		lbf.preInstantiateSingletons();
		lbf.destroySingletons();
		assertTrue("Destroy method invoked", BeanWithDisposableBean.closed);
	}
	
	public function testBeanPostProcessorWithWrappedObjectAndDestroyMethod(Void):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:RootBeanDefinition = new RootBeanDefinition(BeanWithDestroyMethod, null);
		bd.setDestroyMethodName("close");
		lbf.registerBeanDefinition("test", bd);
		var beanPostProcessor:BeanPostProcessor = createBeanPostProcessor();
		beanPostProcessor.postProcessBeforeInitialization = function(bean, beanName:String) {
			return new TestBean();
		};
		beanPostProcessor.postProcessAfterInitialization = function(bean, beanName:String) {
			return bean;
		};
		lbf.addBeanPostProcessor(beanPostProcessor);
		BeanWithDestroyMethod.closed = false;
		lbf.preInstantiateSingletons();
		lbf.destroySingletons();
		assertTrue("Destroy method invoked", BeanWithDestroyMethod.closed);
	}
	
	private function createBeanPostProcessor(Void):BeanPostProcessor {
		var result = new Object();
		result.__proto___ = BeanPostProcessor["prototype"];
		result.__constructor__ = BeanPostProcessor;
		return result;
	}
	
	public function testFieldSettingWithInstantiationAwarePostProcessorNoShortCircuit(Void):Void {
		testFieldSettingWithInstantiationAwarePostProcessor(false);
	}
	
	public function testFieldSettingWithInstantiationAwarePostProcessorWithShortCircuit(Void):Void {
		testFieldSettingWithInstantiationAwarePostProcessor(true);
	}
	
	private function testFieldSettingWithInstantiationAwarePostProcessor(skipPropertyPopulation:Boolean):Void {
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:RootBeanDefinition = new RootBeanDefinition(TestBean, null);
		var ageSetByPropertyValue:Number = 27;
		bd.getPropertyValues().addPropertyValue(new PropertyValue("age", ageSetByPropertyValue));
		lbf.registerBeanDefinition("test", bd);
		var nameSetOnField:String = "nameSetOnField";
		var bpp:InstantiationAwareBeanPostProcessor = createInstantiationAwareBeanPostProcessor();
		var owner:TestCase = this;
		bpp.postProcessBeforeInitialization = function(bean, beanName:String) {
			return bean;
		};
		bpp.postProcessAfterInitialization = function(bean, beanName:String) {
			return bean;
		};
		bpp.postProcessBeforeInstantiation = function(beanClass:Function, beanName:String) {
			return null;
		};
		bpp.postProcessAfterInstantiation = function(bean, beanName:String):Boolean {
			var tb:TestBean = bean;
			try {
				tb.setName(nameSetOnField);
				return !skipPropertyPopulation;
			}
			catch (ex) {
				owner["fail"]("Unexpected exception: " + ex);
			}
		};
		lbf.addBeanPostProcessor(bpp);
		lbf.preInstantiateSingletons();
		var tb:TestBean = lbf.getBean("test");
		assertEquals("Name was set on field by IAPP", nameSetOnField, tb.getName());
		if (!skipPropertyPopulation) {
			assertEquals("Property value still set", ageSetByPropertyValue, tb.getAge());
		}
		else {
			assertEquals("Property value was NOT set and still has default value", 0, tb.getAge());
		}
	}
	
	private function createInstantiationAwareBeanPostProcessor(Void):InstantiationAwareBeanPostProcessor {
		var result = new Object();
		result.__proto__ = InstantiationAwareBeanPostProcessor["prototype"];
		result.__constructor__ = InstantiationAwareBeanPostProcessor;
		return result;
	}
	
	/*public function testFindTypeOfSingletonFactoryMethodOnBeanInstance(Void):Void {
		findTypeOfPrototypeFactoryMethodOnBeanInstance(true);
	}
	
	public function testFindTypeOfPrototypeFactoryMethodOnBeanInstance(Void):Void {
		findTypeOfPrototypeFactoryMethodOnBeanInstance(false);
	}*/
	
	/**
	 * @param singleton whether the bean created from the factory method on
	 * the bean instance should be a singleton or prototype. This flag is
	 * used to allow checking of the new ability in 1.2.4 to determine the type
	 * of a prototype created from invoking a factory method on a bean instance
	 * in the factory.
	 */
	/*private function findTypeOfPrototypeFactoryMethodOnBeanInstance(singleton:Boolean):Void {
		var expectedNameFromProperties:String = "tony";
		var expectedNameFromArgs:String = "gordon";
		
		var lbf:DefaultBeanFactory = new DefaultBeanFactory();
		var instanceFactoryDefinition:RootBeanDefinition = new RootBeanDefinition(BeanWithFactoryMethod, true);
		var pvs:PropertyValues = new PropertyValues();
		pvs.addPropertyValue("name", expectedNameFromProperties);
		instanceFactoryDefinition.setPropertyValues(pvs);
		lbf.registerBeanDefinition("factoryBeanInstance", instanceFactoryDefinition);
		
		var factoryMethodDefinitionWithProperties:RootBeanDefinition = new RootBeanDefinition();
		factoryMethodDefinitionWithProperties.setFactoryBeanName("factoryBeanInstance");
		factoryMethodDefinitionWithProperties.setFactoryMethodName("create");
		factoryMethodDefinitionWithProperties.setSingleton(singleton);
		lbf.registerBeanDefinition("fmWithProperties", factoryMethodDefinitionWithProperties);
		
		var factoryMethodDefinitionGeneric:RootBeanDefinition = new RootBeanDefinition();
		factoryMethodDefinitionGeneric.setFactoryBeanName("factoryBeanInstance");
		factoryMethodDefinitionGeneric.setFactoryMethodName("createGeneric");
		factoryMethodDefinitionGeneric.setSingleton(singleton);
		lbf.registerBeanDefinition("fmGeneric", factoryMethodDefinitionGeneric);

		var factoryMethodDefinitionWithArgs:RootBeanDefinition = new RootBeanDefinition();
		factoryMethodDefinitionWithArgs.setFactoryBeanName("factoryBeanInstance");
		factoryMethodDefinitionWithArgs.setFactoryMethodName("createWithArgs");
		var cvals:ConstructorArgumentValues = new ConstructorArgumentValues();
		//cvals.addGenericArgumentValue(expectedNameFromArgs);
		factoryMethodDefinitionWithArgs.setConstructorArgumentValues(cvals);
		factoryMethodDefinitionWithArgs.setSingleton(singleton);
		lbf.registerBeanDefinition("fmWithArgs", factoryMethodDefinitionWithArgs);

		assertEquals(4, lbf.getBeanDefinitionCount());
		var tbNames:Array = lbf.getBeanNamesForType(TestBean);
		assertTrue(tbNames.contains("fmWithProperties"));
		assertTrue(tbNames.contains("fmWithArgs"));
		if (singleton) {
			assertEquals(3, tbNames.size());
			assertTrue(tbNames.contains("fmGeneric"));
		}
		else {
			assertEquals(2, tbNames.size());
		}

		var tb:TestBean = lbf.getBean("fmWithProperties");
		var second:TestBean = lbf.getBean("fmWithProperties");
		if (singleton) {
			assertSame(tb, second);
		}
		else {
			assertNotSame(tb, second);
		}
		assertEquals(expectedNameFromProperties, tb.getName());

		tb = lbf.getBean("fmGeneric");
		second = lbf.getBean("fmGeneric");
		if (singleton) {
			assertSame(tb, second);
		}
		else {
			assertNotSame(tb, second);
		}
		assertEquals(expectedNameFromProperties, tb.getName());

		var tb2:TestBean = lbf.getBean("fmWithArgs");
		second = lbf.getBean("fmWithArgs");
		if (singleton) {
			assertSame(tb2, second);
		}
		else {
			assertNotSame(tb2, second);
		}
		assertEquals(expectedNameFromArgs, tb2.getName());
	}*/
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// XmlListableBeanFactoryTests
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function testDescriptionButNoProperties(Void):Void {
		var validEmpty:TestBean = getBeanFactory().getBean("validEmptyWithDescription");
		assertEquals(0, validEmpty.getAge());
	}

	/**
	 * Test that properties with name as well as id creating an alias up front.
	 */
	public function testAutoAliasing(Void):Void {
		var beanNames:List = new ArrayList(getBeanFactory().getBeanDefinitionNames());

		var tb1:TestBean = getBeanFactory().getBean("aliased");
		var alias1:TestBean = getBeanFactory().getBean("myalias");
		assertTrue(tb1 == alias1);
		var tb1Aliases:List = new ArrayList(getBeanFactory().getAliases("aliased"));
		assertEquals(2, tb1Aliases.size());
		assertTrue(tb1Aliases.contains("myalias"));
		assertTrue(tb1Aliases.contains("youralias"));
		assertTrue(beanNames.contains("aliased"));
		assertFalse(beanNames.contains("myalias"));
		assertFalse(beanNames.contains("youralias"));

		var tb2:TestBean = getBeanFactory().getBean("multiAliased");
		var alias2:TestBean = getBeanFactory().getBean("alias1");
		var alias3:TestBean = getBeanFactory().getBean("alias2");
		var alias3a:TestBean = getBeanFactory().getBean("alias3");
		var alias3b:TestBean = getBeanFactory().getBean("alias4");
		assertTrue(tb2 == alias2);
		assertTrue(tb2 == alias3);
		assertTrue(tb2 == alias3a);
		assertTrue(tb2 == alias3b);

		var tb2Aliases:List = new ArrayList(getBeanFactory().getAliases("multiAliased"));
		assertEquals(4, tb2Aliases.size());
		assertTrue(tb2Aliases.contains("alias1"));
		assertTrue(tb2Aliases.contains("alias2"));
		assertTrue(tb2Aliases.contains("alias3"));
		assertTrue(tb2Aliases.contains("alias4"));
		assertTrue(beanNames.contains("multiAliased"));
		assertFalse(beanNames.contains("alias1"));
		assertFalse(beanNames.contains("alias2"));
		assertFalse(beanNames.contains("alias3"));
		assertFalse(beanNames.contains("alias4"));

		var tb3:TestBean = getBeanFactory().getBean("aliasWithoutId1");
		var alias4:TestBean = getBeanFactory().getBean("aliasWithoutId2");
		var alias5:TestBean = getBeanFactory().getBean("aliasWithoutId3");
		assertTrue(tb3 == alias4);
		assertTrue(tb3 == alias5);
		var tb3Aliases:List = new ArrayList(getBeanFactory().getAliases("aliasWithoutId1"));
		assertEquals(2, tb3Aliases.size());
		assertTrue(tb3Aliases.contains("aliasWithoutId2"));
		assertTrue(tb3Aliases.contains("aliasWithoutId3"));
		assertTrue(beanNames.contains("aliasWithoutId1"));
		assertFalse(beanNames.contains("aliasWithoutId2"));
		assertFalse(beanNames.contains("aliasWithoutId3"));

		var tb4:TestBean = getBeanFactory().getBean("org.as2lib.bean.TestBean");
		assertEquals(null, tb4.getName());

		var drs:Map = getBeanFactory().getBeansOfType(DummyReferencer, false, false);
		assertEquals(5, drs.size());
		assertTrue(drs.containsKey("org.as2lib.bean.factory.DummyReferencer"));
		assertTrue(drs.containsKey("org.as2lib.bean.factory.DummyReferencer#1"));
		assertTrue(drs.containsKey("org.as2lib.bean.factory.DummyReferencer#2"));
	}

	public function testFactoryNesting(Void):Void {
		var father:TestBean = getBeanFactory().getBean("father");
		assertTrue("Bean from root context", father != null);

		var rod:TestBean = getBeanFactory().getBean("rod");
		assertSame("Bean from child context", "Rod", rod.getName());
		assertSame("Bean has external reference", rod.getSpouse(), father);

		rod = parent.getBean("rod");
		assertSame("Bean from root context", "Roderick", rod.getName());
	}

	public function testFactoryReferences(Void):Void {
		var factory:DummyFactory = getBeanFactory().getBean("&singletonFactory");

		var ref:DummyReferencer = getBeanFactory().getBean("factoryReferencer");
		assertSame(ref.getTestBean1(), ref.getTestBean2());
		assertSame(ref.getDummyFactory(), factory);

		var ref2:DummyReferencer = getBeanFactory().getBean("factoryReferencerWithConstructor");
		assertSame(ref2.getTestBean1(), ref2.getTestBean2());
		assertSame(ref2.getDummyFactory(), factory);
	}

	public function testPrototypeReferences(Void):Void {
		// check that not broken by circular reference resolution mechanism
		var ref1:DummyReferencer = getBeanFactory().getBean("prototypeReferencer");
		assertNotSame("Not referencing same bean twice", ref1.getTestBean1(), ref1.getTestBean2());
		var ref2:DummyReferencer = getBeanFactory().getBean("prototypeReferencer");
		assertNotSame("Not the same referencer", ref1, ref2);
		assertTrue("Not referencing same bean twice", ref2.getTestBean1() != ref2.getTestBean2());
		assertTrue("Not referencing same bean twice", ref1.getTestBean1() != ref2.getTestBean1());
		assertTrue("Not referencing same bean twice", ref1.getTestBean2() != ref2.getTestBean2());
		assertTrue("Not referencing same bean twice", ref1.getTestBean1() != ref2.getTestBean2());
	}

	public function testBeanPostProcessor(Void):Void {
		var kerry:TestBean = getBeanFactory().getBean("kerry");
		var kathy:TestBean = getBeanFactory().getBean("kathy");
		var factory:DummyFactory = getBeanFactory().getBean("&singletonFactory");
		var factoryCreated:TestBean = getBeanFactory().getBean("singletonFactory");
		assertTrue(kerry.isPostProcessed());
		assertTrue(kathy.isPostProcessed());
		assertTrue(factory.isPostProcessed());
		assertTrue(factoryCreated.isPostProcessed());
	}

	public function testEmptyValues(Void):Void {
		var rod:TestBean = getBeanFactory().getBean("rod");
		var kerry:TestBean = getBeanFactory().getBean("kerry");
		assertTrue("Touchy is empty", "" == rod.getTouchy());
		assertTrue("Touchy is empty", "" == kerry.getTouchy());
	}
	
	// TODO: not supported in Flash?
	/*public function testCommentsAndCdataInValue(Void):Void {
		var bean:TestBean = getBeanFactory().getBean("commentsInValue");
		assertEquals("Failed to handle comments and CDATA properly", "this is a <!--comment-->", bean.getName());
	}*/
	
}