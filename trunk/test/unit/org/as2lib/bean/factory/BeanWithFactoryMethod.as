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

import org.as2lib.bean.TestBean;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanWithFactoryMethod extends BasicClass {
	
	private var name:String;

	public function setName(name:String):Void {
		this.name = name;
	}

	public function create(Void):TestBean {
		var tb:TestBean = new TestBean();
		tb.setName(name);
		return tb;
	}

	public function createWithArgs(arg:String):TestBean {
		var tb:TestBean = new TestBean();
		tb.setName(arg);
		return tb;
	}

	public function createGeneric(Void):TestBean {
		return create();
	}

}