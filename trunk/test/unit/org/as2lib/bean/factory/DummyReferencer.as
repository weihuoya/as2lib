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

import org.as2lib.bean.factory.DummyFactory;
import org.as2lib.bean.TestBean;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.DummyReferencer extends BasicClass {
	
	private var testBean1:TestBean;

	private var testBean2:TestBean;

	private var dummyFactory:DummyFactory;

	public function DummyReferencer(dummyFactory:DummyFactory) {
		this.dummyFactory = dummyFactory;
	}

	public function setDummyFactory(dummyFactory:DummyFactory) {
		this.dummyFactory = dummyFactory;
	}

	public function getDummyFactory(Void):DummyFactory {
		return dummyFactory;
	}

	public function setTestBean1(testBean1:TestBean):Void {
		this.testBean1 = testBean1;
	}

	public function getTestBean1(Void):TestBean {
		return testBean1;
	}

	public function setTestBean2(testBean2:TestBean):Void {
		this.testBean2 = testBean2;
	}

	public function getTestBean2(Void):TestBean {
		return testBean2;
	}

}