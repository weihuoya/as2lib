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

import org.as2lib.core.BasicClass;
import org.as2lib.env.bean.factory.BeanFactory;
import org.as2lib.env.bean.factory.BeanFactoryAware;
import org.as2lib.env.bean.factory.BeanNameAware;
import org.as2lib.env.bean.factory.InitializingBean;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.factory.support.StubBean extends BasicClass implements BeanFactoryAware, BeanNameAware, InitializingBean {
	
	public var arg1:String;
	public var arg2:Object;
	public var arg3:Number;
	public var property:Object;
	public var properties:Array;
	public var key:Object;
	public var beanFactory:BeanFactory;
	public var beanName:String;
	
	public var propertiesSetArg1:Boolean;
	public var propertiesSetArg2:Boolean;
	public var propertiesSetArg3:Boolean;
	public var propertiesSetProperty:Boolean;
	public var propertiesSetPropertiesKey:Boolean;
	public var propertiesSetBeanName:Boolean;
	public var propertiesSetBeanFactory:Boolean;
	
	public var setPropertyCalled:Boolean;
	public var setKeyAndPropertyCalled:Boolean;
	public var setBeanFactoryCalled:Boolean;
	public var setBeanNameCalled:Boolean;
	public var propertiesSetCalled:Boolean;
	public var initCalled:Boolean;
	
	public function StubBean(arg1:String, arg2:Object, arg3:Number) {
		this.arg1 = arg1;
		this.arg2 = arg2;
		this.arg3 = arg3;
		this.properties = new Array();
		setPropertyCalled = false;
		setKeyAndPropertyCalled = false;
		setBeanFactoryCalled = false;
		setBeanNameCalled = false;
		propertiesSetCalled = false;
		initCalled = false;
	}
	
	public function setProperty(property:Object):Void {
		setPropertyCalled = true;
		this.property = property;
	}
	
	public function setKeyAndProperty(key:Object, property:Object):Void {
		setKeyAndPropertyCalled = true;
		this.key = key;
		properties[key] = property;
	}
	
	public function setBeanFactory(beanFactory:BeanFactory):Void {
		setBeanFactoryCalled = true;
		this.beanFactory = beanFactory;
	}
	
	public function setBeanName(beanName:String):Void {
		setBeanNameCalled = true;
		this.beanName = beanName;
	}
	
	public function afterPropertiesSet(Void):Void {
		propertiesSetCalled = true;
		propertiesSetArg1 = arg1 !== undefined;
		propertiesSetArg2 = arg2 !== undefined;
		propertiesSetArg3 = arg3 !== undefined;
		propertiesSetProperty = property !== undefined;
		propertiesSetPropertiesKey = properties[key] !== undefined;
		propertiesSetBeanName = beanName !== undefined;
		propertiesSetBeanFactory = beanFactory !== undefined;
	}
	
	public function init(Void):Void {
		initCalled = true;
	}
	
}