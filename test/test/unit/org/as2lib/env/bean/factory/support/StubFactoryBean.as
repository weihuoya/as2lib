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
import org.as2lib.env.bean.factory.FactoryBean;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.factory.support.StubFactoryBean extends BasicClass implements FactoryBean {
	
	public static var object;
	public static var objectType:Function;
	
	public var isSingletonCalled:Boolean;
	
	public function StubFactoryBean(Void) {
		isSingletonCalled = false;
	}
	
	public function isSingleton(Void):Boolean {
		isSingletonCalled = true;
		return true;
	}
	
	public function getObject(Void) {
		return object;
	}
	
	public function getObjectType(Void):Function {
		return objectType;
	}
	
}