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
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.Exception;
import org.as2lib.env.except.FatalException;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.bean.factory.support.DefaultBeanFactory;
import org.as2lib.env.bean.factory.config.BeanDefinition;
import org.as2lib.env.bean.factory.BeanDefinitionStoreException;
import org.as2lib.env.bean.factory.FactoryBean;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.factory.support.TDefaultBeanFactory extends TestCase {
	
	public function testRegisterBeanDefinitionForMultipleRegistrationWithSameName(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = new BeanDefinition();
		factory.registerBeanDefinition("beanName", bd);
		factory.registerBeanDefinition("beanName", bd);
		factory.setAllowBeanDefinitionOverriding(false);
		assertThrows("Method should throw an exception in case one tries to overwrite a bean definition in the same bean factory.", BeanDefinitionStoreException, factory, factory.registerBeanDefinition, ["beanName", bd]);
	}
	
	public function testRegisterBeanDefinitionViaGetBeanDefinition(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = new BeanDefinition();
		factory.registerBeanDefinition("beanName", bd);
		assertSame("Returned and registered bean definition should be the same.", factory.getBeanDefinition("beanName"), bd);
	}
	
	public function testGetBeanDefinitionCountWithMultipleRegistrations(Void):Void {
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		var bd:BeanDefinition = new BeanDefinition();
		factory.registerBeanDefinition("beanName1", bd);
		factory.registerBeanDefinition("beanName2", bd);
		factory.registerBeanDefinition("beanName3", bd);
		assertSame("Bean definition count should be 3.", factory.getBeanDefinitionCount(), 3);
	}
	
	public function testGetBeanDefinitionNamesByType(Void):Void {
		var bd1Control:MockControl = new SimpleMockControl(BeanDefinition);
		var bd2Control:MockControl = new SimpleMockControl(BeanDefinition);
		var bd3Control:MockControl = new SimpleMockControl(BeanDefinition);
		var bd4Control:MockControl = new SimpleMockControl(BeanDefinition);
		var bd1:BeanDefinition = bd1Control.getMock();
		var bd2:BeanDefinition = bd2Control.getMock();
		var bd3:BeanDefinition = bd3Control.getMock();
		var bd4:BeanDefinition = bd4Control.getMock();
		bd1.getBeanClass();
		bd2.getBeanClass();
		bd3.getBeanClass();
		bd4.getBeanClass();
		bd1Control.setReturnValue(Exception, 4);
		bd2Control.setReturnValue(FatalException, 4);
		bd3Control.setReturnValue(Exception, 4);
		bd4Control.setReturnValue(Throwable, 4);
		bd1Control.replay();
		bd2Control.replay();
		bd3Control.replay();
		bd4Control.replay();
		
		var factory:DefaultBeanFactory = new DefaultBeanFactory();
		factory.registerBeanDefinition("bean1", bd1);
		factory.registerBeanDefinition("bean2", bd2);
		factory.registerBeanDefinition("bean3", bd3);
		factory.registerBeanDefinition("bean4", bd4);
		
		var names1:Array = factory.getBeanDefinitionNamesByType(Exception);
		assertSame("There should be 2 beans of type Exception.", names1.length, 2);
		
		var names2:Array = factory.getBeanDefinitionNamesByType(FatalException);
		assertSame("There should be 1 bean of type FatalException.", names2.length, 1);
		
		var names3:Array = factory.getBeanDefinitionNamesByType(Throwable);
		assertSame("There should be 4 beans of type Throwable.", names3.length, 4);
		
		var names4:Array = factory.getBeanDefinitionNamesByType(BasicInterface);
		assertSame("There should be 4 beans of type BasicInterface.", names4.length, 4);
		
		bd1Control.verify(this);
		bd2Control.verify(this);
		bd3Control.verify(this);
		bd4Control.verify(this);
	}
	
	public function testGetBeanByNameWithHierarchicalFactoryStructure(Void):Void {
		var bean1:Object = new Object();
		var bean2:Object = new Object();
		
		var bd1C:MockControl = new SimpleMockControl(BeanDefinition);
		var bd2C:MockControl = new SimpleMockControl(BeanDefinition);
		var bd1:BeanDefinition = bd1C.getMock();
		var bd2:BeanDefinition = bd2C.getMock();
		bd1.createBean();
		bd2.createBean();
		bd1C.setReturnValue(bean1);
		bd2C.setReturnValue(bean2);
		bd1C.replay();
		bd2C.replay();
		
		var parent:DefaultBeanFactory = new DefaultBeanFactory();
		parent.registerBeanDefinition("beanName1", new BeanDefinition());
		parent.registerBeanDefinition("beanName2", bd2);
		
		var factory:DefaultBeanFactory = new DefaultBeanFactory(parent);
		factory.registerBeanDefinition("beanName1", bd1);
		
		assertSame(factory.getBeanByName("beanName1"), bean1);
		assertSame(factory.getBeanByName("beanName2"), bean2);
		
		bd1C.verify(this);
		bd2C.verify(this);
	}
	
	public function testGetBeanWithSingletonBeanDefinition(Void):Void {
		var bdControl:MockControl = new SimpleMockControl(BeanDefinition);
		var bd:BeanDefinition = bdControl.getMock();
		bd.isSingleton();
		bdControl.setDefaultReturnValue(true);
		bd.createBean();
		var bean:Object = new Object();
		bdControl.setReturnValue(bean);
		bdControl.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertSame("Bean returned by bean definition should always be the same as the one returned by the factory.", bean, bf.getBeanByName("bean"));
		assertSame("Bean returned by bean definition should always be the same as the one returned by the factory.", bean, bf.getBeanByName("bean"));
		
		bdControl.verify(this);
	}
	
	public function testIsSingletonWithFactoryBean(Void):Void {
		var fbC:MockControl = new SimpleMockControl(FactoryBean);
		var fb:FactoryBean = fbC.getMock();
		fb.isSingleton();
		fbC.setReturnValue(true);
		fbC.replay();
		
		var bdC:MockControl = new SimpleMockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(false);
		bd.createBean();
		bdC.setReturnValue(fb);
		bd.getBeanClass();
		bdC.setReturnValue(FactoryBean);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertTrue("Bean wrapped by factory bean is supposed to be a singleton.", bf.isSingleton("bean"));
		
		fbC.verify(this);
		bdC.verify(this);
	}
	
	public function testIsSingletonNormal(Void):Void {
		var bdC:MockControl = new SimpleMockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setReturnValue(true);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertTrue(bf.isSingleton("bean"));
		
		bdC.verify(this);
	}
	
	public function testGetBeanByNameWithFactoryBeanPrefix(Void):Void {
		var fbC:MockControl = new SimpleMockControl(FactoryBean);
		var fb:FactoryBean = fbC.getMock();
		fbC.replay();
		
		var bdC:MockControl = new SimpleMockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(false);
		bd.createBean();
		bdC.setReturnValue(fb, 2);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertSame(fb, bf.getBeanByName(DefaultBeanFactory.FACTORY_BEAN_PREFIX + "bean"));
		assertSame(fb, bf.getBeanByName(DefaultBeanFactory.FACTORY_BEAN_PREFIX + "bean"));
		
		fbC.verify(this);
		bdC.verify(this);
	}
	
	public function testGetBeanByNameWithFactoryBeanWrappingActualBean(Void):Void {
		var fbC:MockControl = new SimpleMockControl(FactoryBean);
		var fb:FactoryBean = fbC.getMock();
		fb.isSingleton();
		fbC.setDefaultReturnValue(true);
		fb.getObject();
		var bean:Object = new Object();
		fbC.setReturnValue(bean, 2);
		fbC.replay();
		
		var bdC:MockControl = new SimpleMockControl(BeanDefinition);
		var bd:BeanDefinition = bdC.getMock();
		bd.isSingleton();
		bdC.setDefaultReturnValue(true);
		bd.createBean();
		bdC.setReturnValue(fb);
		bdC.replay();
		
		var bf:DefaultBeanFactory = new DefaultBeanFactory();
		bf.registerBeanDefinition("bean", bd);
		assertSame(bean, bf.getBeanByName("bean"));
		assertSame(bean, bf.getBeanByName("bean"));
		
		fbC.verify(this);
		bdC.verify(this);
	}
	
}