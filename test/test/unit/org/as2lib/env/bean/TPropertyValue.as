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
import org.as2lib.env.bean.PropertyValue;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.TPropertyValue extends TestCase {
	
	/*public function testApplyWithEmptyPrefix(Void):Void {
		var value:Object = new Object();
		var propertyValue:PropertyValue = new PropertyValue("test", value, "");
		
		var beanControl:MockControl = new MockControl(Object);
		var bean:Object = beanControl.getMock();
		bean.test(value);
		beanControl.setVoidCallable();
		beanControl.replay();
		
		propertyValue.apply(bean);
		
		beanControl.verify(this);
	}
	
	public function testApplyWithDefaultPrefix(Void):Void {
		var value:Object = new Object();
		var propertyValue:PropertyValue = new PropertyValue("value", value);
		
		var beanControl:MockControl = new MockControl(Object);
		var bean:Object = beanControl.getMock();
		bean.setValue(value);
		beanControl.setVoidCallable();
		beanControl.replay();
		
		propertyValue.apply(bean);
		
		beanControl.verify(this);
	}
	
	public function testApplyWithCustomPrefix(Void):Void {
		var value:Object = new Object();
		var propertyValue:PropertyValue = new PropertyValue("value", value, "add");
		
		var beanControl:MockControl = new MockControl(Object);
		var bean:Object = beanControl.getMock();
		bean.addValue(value);
		beanControl.setVoidCallable();
		beanControl.replay();
		
		propertyValue.apply(bean);
		
		beanControl.verify(this);
	}*/
	
}