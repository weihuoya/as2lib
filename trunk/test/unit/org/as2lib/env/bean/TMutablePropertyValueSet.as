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
import org.as2lib.env.bean.MutablePropertyValueSet;
import org.as2lib.env.bean.PropertyValue;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.TMutablePropertyValueSet extends TestCase {
	
	/*public function testApplyWithMultiplePropertyValues(Void):Void {
		var bean:Object = new Object();
		
		var valueControl:MockControl = new MockControl(PropertyValue);
		var value:PropertyValue = valueControl.getMock();
		value.apply(bean);
		valueControl.setVoidCallable(3);
		valueControl.replay();
		
		var valueSet:MutablePropertyValueSet = new MutablePropertyValueSet();
		valueSet.addPropertyValue(value);
		valueSet.addPropertyValue(value);
		valueSet.addPropertyValue(value);
		valueSet.apply(bean);
		
		valueControl.verify();
	}*/
	
}