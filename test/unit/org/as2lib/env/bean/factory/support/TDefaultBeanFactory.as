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
import org.as2lib.test.mock.MockControl;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.Exception;
import org.as2lib.env.except.FatalException;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.bean.PropertyValue;
import org.as2lib.env.bean.PropertyValueSet;
import org.as2lib.env.bean.factory.support.DefaultBeanFactory;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.config.LifecycleCallbackBeanDefinition;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValueList;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.env.bean.factory.BeanDefinitionStoreException;
import org.as2lib.env.bean.factory.FactoryBean;
import org.as2lib.env.bean.factory.support.StubBean;
import org.as2lib.env.bean.factory.support.StubFactoryBean;
import org.as2lib.env.bean.factory.BeanNotOfRequiredTypeException;
import org.as2lib.env.bean.factory.NoSuchBeanDefinitionException;
import org.as2lib.env.bean.factory.config.RuntimeBeanReference;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.factory.support.TDefaultBeanFactory extends TestCase {
	
	private function getBeanDefinition(Void):BeanDefinition {
		var result = new Object();
		result.__proto__ = BeanDefinition["prototype"];
		return result;
	}
	
	public function testRegisterBeanDefinitionForMultipleRegistrationWithSameName(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = getBeanDefinition();
		factory.registerBeanDefinition("beanName", bd);
		factory.registerBeanDefinition("beanName", bd);
		factory.setAllowBeanDefinitionOverriding(false);
		assertThrows("Method should throw an exception in case one tries to overwrite a bean definition in the same bean factory.", BeanDefinitionStoreException, factory, factory.registerBeanDefinition, ["beanName", bd]);
	}
	
	public function testRegisterBeanDefinitionViaGetBeanDefinition(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = getBeanDefinition();
		factory.registerBeanDefinition("beanName", bd);
		assertSame("Returned and registered bean definition should be the same.", factory.getBeanDefinition("beanName"), bd);
	}
	
	public function testGetBeanDefinitionCountWithMultipleRegistrations(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = getBeanDefinition();
		assertSame("Bean definition count should be 0.", factory.getBeanDefinitionCount(), 0);
		factory.registerBeanDefinition("beanName1", bd);
		factory.registerBeanDefinition("beanName2", bd);
		factory.registerBeanDefinition("beanName3", bd);
		assertSame("Bean definition count should be 3.", factory.getBeanDefinitionCount(), 3);
	}
	
	public function testGetBeanDefinitionNamesByType(Void):Void {
		var bd1Control:MockControl = new MockControl(BeanDefinition);
		var bd2Control:MockControl = new MockControl(BeanDefinition);
		var bd3Control:MockControl = new MockControl(BeanDefinition);
		var bd4Control:MockControl = new MockControl(BeanDefinition);
		var bd5Control:MockControl = new MockControl(BeanDefinition);
		var bd1:BeanDefinition = bd1Control.getMock();
		var bd2:BeanDefinition = bd2Control.getMock();
		var bd3:BeanDefinition = bd3Control.getMock();
		var bd4:BeanDefinition = bd4Control.getMock();
		var bd5:BeanDefinition = bd5Control.getMock();
		bd1.getBeanClass();
		bd2.getBeanClass();
		bd3.getBeanClass();
		bd4.getBeanClass();
		bd5.getBeanClass();
		bd1Control.setReturnValue(Exception, 4);
		bd2Control.setReturnValue(FatalException, 4);
		bd3Control.setReturnValue(Exception, 4);
		bd4Control.setReturnValue(Throwable, 4);
		bd5Control.setReturnValue(Function, 4);
		bd1Control.replay();
		bd2Control.replay();
		bd3Control.replay();
		bd4Control.replay();
		bd5Control.replay();
		
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		factory.registerBeanDefinition("bean1", bd1);
		factory.registerBeanDefinition("bean2", bd2);
		factory.registerBeanDefinition("bean3", bd3);
		factory.registerBeanDefinition("bean4", bd4);
		factory.registerBeanDefinition("bean5", bd5);
		
		var names0:Array = factory.getBeanDefinitionNamesByType(null);
		assertSame("There should be 5 beans (all) when using null as type.", names0.length, 5);
		
		var names1:Array = factory.getBeanDefinitionNamesByType(Exception);
		assertSame("There should be 2 beans of type Exception.", names1.length, 2);
		
		var names2:Array = factory.getBeanDefinitionNamesByType(FatalException);
		assertSame("There should be 1 bean of type FatalException.", names2.length, 1);
		
		var names3:Array = factory.getBeanDefinitionNamesByType(Throwable);
		assertSame("There should be 4 beans of type Throwable.", names3.length, 4);
		
		var names4:Array = factory.getBeanDefinitionNamesByType(BasicInterface);
		assertSame("There should be 4 beans of type BasicInterface.", names4.length, 4);
		
		bd1Control.verify();
		bd2Control.verify();
		bd3Control.verify();
		bd4Control.verify();
		bd5Control.verify();
	}
	
	public function testRegisterSingletonViaGetBeanByName(Void):Void {
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		var s:Object = new Object();
		bf.registerSingleton("singleton", s);
		assertSame(bf.getBeanByName("singleton"), s);
	}
	
	public function testIsSingletonWithFactoryBean(Void):Void {
		var bdC:MockControl = new MockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(false);
		bd.getBeanClass();
		bdC.setDefaultReturnValue(StubFactoryBean);
		bd.getConstructorArgumentValues();
		bdC.setReturnValue(null);
		bd.getPropertyValues();
		bdC.setReturnValue(null);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertTrue("Bean wrapped by factory bean is supposed to be a singleton.", bf.isSingleton("bean"));
		
		bdC.verify();
	}
	
	public function testIsSingletonNormal(Void):Void {
		var bdC:MockControl = new MockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setReturnValue(true);
		bd.getBeanClass();
		bdC.setReturnValue(null);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertTrue(bf.isSingleton("bean"));
		
		bdC.verify();
	}
	
	public function testGetBeanByNameWithHierarchicalFactoryStructure(Void):Void {
		var bean1:Object = new Object();
		var bean2:Object = new Object();
		
		var parent:DefaultBeanFactory = new DefaultBeanFactory();
		parent.registerSingleton("beanName1", new Object());
		parent.registerSingleton("beanName2", bean2);
		
		var factory:DefaultBeanFactory = new DefaultBeanFactory(parent);
		factory.registerSingleton("beanName1", bean1);
		
		assertSame("1", factory.getBeanByName("beanName1"), bean1);
		assertSame("2", factory.getBeanByName("beanName2"), bean2);
	}
	
	public function testGetBeanWithSingletonBeanDefinition(Void):Void {
		var bdControl:MockControl = new MockControl(BeanDefinition);
		var bd:BeanDefinition = bdControl.getMock();
		bd.isSingleton();
		bdControl.setDefaultReturnValue(true);
		bd.getBeanClass();
		bdControl.setDefaultReturnValue(Object);
		bd.getConstructorArgumentValues();
		bdControl.setReturnValue(null);
		bd.getPropertyValues();
		bdControl.setReturnValue(null);
		bdControl.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		var returnedBean = bf.getBeanByName("bean");
		assertSame("Bean returned by bean definition should always be the same as the one returned by the factory.", returnedBean, bf.getBeanByName("bean"));
		assertSame("Bean returned by bean definition should always be the same as the one returned by the factory.", returnedBean, bf.getBeanByName("bean"));
		
		bdControl.verify();
	}
	
	public function testGetBeanByNameWithFactoryBeanPrefix(Void):Void {
		var bdC:MockControl = new MockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(true);
		bd.getBeanClass();
		bdC.setDefaultReturnValue(StubFactoryBean);
		bd.getConstructorArgumentValues();
		bdC.setReturnValue(null);
		bd.getPropertyValues();
		bdC.setReturnValue(null);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		var returnedFb:StubFactoryBean = bf.getBeanByName(DefaultBeanFactory.FACTORY_BEAN_PREFIX + "bean");
		assertTrue(returnedFb instanceof StubFactoryBean);
		assertSame(returnedFb, bf.getBeanByName(DefaultBeanFactory.FACTORY_BEAN_PREFIX + "bean"));
		assertSame(returnedFb, bf.getBeanByName(DefaultBeanFactory.FACTORY_BEAN_PREFIX + "bean"));
		
		bdC.verify();
	}
	
	public function testGetBeanByNameWithFactoryBeanWrappingActualBean(Void):Void {
		var object = new Object();
		StubFactoryBean.object = object;
		
		var bdC:MockControl = new MockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(true);
		bd.getBeanClass();
		bdC.setDefaultReturnValue(StubFactoryBean);
		bd.getConstructorArgumentValues();
		bdC.setReturnValue(null);
		bd.getPropertyValues();
		bdC.setReturnValue(null);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertSame(object, bf.getBeanByName("bean"));
		assertSame(object, bf.getBeanByName("bean"));
		
		bdC.verify();
	}
	
	public function testGetBeanWithNotExistingName(Void):Void {
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		assertThrows(NoSuchBeanDefinitionException, bf, bf.getBeanByName, ["bean"]);
		assertThrows(NoSuchBeanDefinitionException, bf, bf.getBeanByNameAndType, ["bean", null]);
	}
	
	private function getBasicInterface(Void):BasicInterface {
		var result = new Object();
		result.__proto__ = BasicInterface["prototype"];
		return result;
	}
	
	public function testGetBeanByNameAndType(Void):Void {
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		var bean:BasicInterface = getBasicInterface();
		bf.registerSingleton("bean", bean);
		assertSame(bf.getBeanByNameAndType("bean", Object), bean);
		assertSame(bf.getBeanByNameAndType("bean", BasicInterface), bean);
		assertSame(bf.getBeanByNameAndType("bean", null), bean);
		assertThrows(BeanNotOfRequiredTypeException, bf, bf.getBeanByNameAndType, ["bean", MockControl]);
	}
	
	public function testCreateBeanCallbackFunctionalityAndPropertyAndConstructorArgumentsFunctionality(Void):Void {
		var arg1C:MockControl = new MockControl(ConstructorArgumentValue);
		var arg1:ConstructorArgumentValue = arg1C.getMock();
		arg1.getType();
		arg1C.setDefaultReturnValue(String);
		arg1.getValue();
		arg1C.setDefaultReturnValue("arg1");
		arg1C.replay();
		
		var arg2C:MockControl = new MockControl(ConstructorArgumentValue);
		var arg2:ConstructorArgumentValue = arg2C.getMock();
		arg2.getType();
		arg2C.setDefaultReturnValue(Object);
		arg2.getValue();
		var actualArg2:Object = new Object();
		arg2C.setDefaultReturnValue(actualArg2);
		arg2C.replay();
		
		var arg3C:MockControl = new MockControl(ConstructorArgumentValue);
		var arg3:ConstructorArgumentValue = arg3C.getMock();
		arg3.getType();
		arg3C.setDefaultReturnValue(Number);
		arg3.getValue();
		var actualArg3:Number = new Number();
		arg3C.setDefaultReturnValue(actualArg3);
		arg3C.replay();
		
		var arg4C:MockControl = new MockControl(ConstructorArgumentValue);
		var arg4:ConstructorArgumentValue = arg4C.getMock();
		arg4.getType();
		// should the type of the referenced bean or RuntimeBeanReference be returned?
		arg4C.setDefaultReturnValue(RuntimeBeanReference);
		arg4.getValue();
		arg4C.setDefaultReturnValue(new RuntimeBeanReference("singleton"));
		arg4C.replay();
		
		var cavlC:MockControl = new MockControl(ConstructorArgumentValueList);
		var cavl:ConstructorArgumentValueList = cavlC.getMock();
		cavl.getArgumentValues();
		cavlC.setDefaultReturnValue([arg1, arg2, arg3, arg4]);
		cavlC.replay();
		
		var pv1C:MockControl = new MockControl(PropertyValue);
		var pv1:PropertyValue = pv1C.getMock();
		pv1.getType();
		pv1C.setDefaultReturnValue(Object);
		pv1.getName();
		pv1C.setDefaultReturnValue("property");
		pv1.getValue();
		var actualPv1:Object = new Object();
		pv1C.setDefaultReturnValue(actualPv1);
		pv1C.replay();

		var pv2C:MockControl = new MockControl(PropertyValue);
		var pv2:PropertyValue = pv2C.getMock();
		pv2.getType();
		pv2C.setDefaultReturnValue(Object);
		pv2.getName();
		pv2C.setDefaultReturnValue("keyAndProperty[key]");
		pv2.getValue();
		var actualPv2:Object = new Object();
		pv2C.setDefaultReturnValue(actualPv2);
		pv2C.replay();
		
		var pv3C:MockControl = new MockControl(PropertyValue);
		var pv3:PropertyValue = pv3C.getMock();
		pv3.getType();
		// should the type of the referenced bean or RuntimeBeanReference be returned?
		pv3C.setDefaultReturnValue(RuntimeBeanReference);
		pv3.getName();
		pv3C.setDefaultReturnValue("referenceBean");
		pv3.getValue();
		pv3C.setDefaultReturnValue(new RuntimeBeanReference("singleton"));
		pv3C.replay();
		
		var pvsC:MockControl = new MockControl(PropertyValueSet);
		var pvs:PropertyValueSet = pvsC.getMock();
		pvs.getPropertyValues();
		pvsC.setDefaultReturnValue([pv1, pv2, pv3]);
		pvsC.replay();
		
		var bdC:MockControl = new MockControl(LifecycleCallbackBeanDefinition);
		var bd:LifecycleCallbackBeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(false);
		bd.getBeanClass();
		bdC.setDefaultReturnValue(StubBean);
		bd.getInitMethodName();
		bdC.setDefaultReturnValue("init");
		bd.getConstructorArgumentValues();
		bdC.setDefaultReturnValue(cavl);
		bd.getPropertyValues();
		bdC.setDefaultReturnValue(pvs);
		bdC.replay();
		
		var singleton:Object = new Object();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		bf.registerSingleton("singleton", singleton);
		var bean:StubBean = bf.getBeanByName("bean");
		assertTrue("constructor not invoked.", bean.constructorInvoked);
		assertTrue("setBeanFactory not invoked.", bean.setBeanFactoryCalled);
		assertTrue("setBeanName not invoked.", bean.setBeanNameCalled);
		assertTrue("afterPropertiesSet not invoked.", bean.propertiesSetCalled);
		assertTrue("init not invoked.", bean.initCalled);
		assertTrue("setProperty not invoked.", bean.setPropertyCalled);
		assertTrue("setKeyAndProperty not invoked.", bean.setKeyAndPropertyCalled);
		assertTrue("setReferenceBean not invoked.", bean.setReferenceBeanCalled);
		
		assertTrue("constructor not invoked before calling afterPropertiesSet", bean.propertiesSetConstructorInvoked);
		assertTrue("setProperty not invoked before calling afterPropertiesSet", bean.propertiesSetProperty);
		assertTrue("setKeyAndProperty not invoked before calling afterPropertiesSet", bean.propertiesSetPropertiesKey);
		assertTrue("setBeanName not invoked before calling afterPropertiesSet", bean.propertiesSetBeanName);
		assertTrue("setBeanFactory not invoked before calling afterPropertiesSet", bean.propertiesSetBeanFactory);
		assertTrue("setReferenceBean not invoked before calling afterPropertiesSet", bean.propertiesSetReferenceBean);
		
		assertSame("arg1 does not have the expected value.", "arg1", bean.arg1);
		assertSame("arg2 does not have the expected value.", actualArg2, bean.arg2);
		assertSame("arg3 does not have the expected value.", actualArg3, bean.arg3);
		assertSame("arg4 does not have the expected value.", singleton, bean.arg4);
		assertSame("property does not have the expected value.", actualPv1, bean.property);
		assertSame("keyProperty does not have the expected value.", actualPv2, bean.keyProperty);
		assertSame("key does not have the expected value.", "key", bean.key);
		assertSame("beanFactory does not have the expected value.", bf, bean.beanFactory);
		assertSame("beanName does not have the expected value.", "bean", bean.beanName);
		assertSame("referenceBean does not have the expected value.", singleton, bean.referenceBean);
		
		arg1C.verify();
		arg2C.verify();
		arg3C.verify();
		cavlC.verify();
		pvsC.verify();
		bdC.verify();
		pv1C.verify();
		pv2C.verify();
	}
	
}