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
import org.as2lib.env.bean.factory.support.RootBeanDefinition;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValueList;
import org.as2lib.env.bean.PropertyValueSet;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.factory.support.TRootBeanDefinition extends TestCase {
	
	public function testGetBeanWithNoValuesForCorrectBeanType(Void):Void {
		var definition:RootBeanDefinition = new RootBeanDefinition(TestCase);
		var bean:TestCase = definition.getBean();
		assertTrue("Returned bean should be of type TestCase.", bean instanceof TestCase);
	}
	
	public function testGetBeanWithConstructorArgumentValues(Void):Void {
		// TODO
	}
	
	public function testGetBeanWithPropertyValues(Void):Void {
		var valuesControl:MockControl = new SimpleMockControl(PropertyValueSet);
		var values:PropertyValueSet = valuesControl.getMock();
		
		// support needed that enables easy use of custom arguments matcher
	}
	
	public function testGetBeanWithConstructorArgumentAndPropertyValues(Void):Void {
		// support needed that enables easy use of custom arguments matcher
	}
	
}