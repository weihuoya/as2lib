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
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.TestBean;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.DependenciesBean extends BasicClass implements BeanFactoryAware {
	
	private var age:Number;
	
	private var name:String;
	
	private var spouse:TestBean;

	private var beanFactory:BeanFactory;

	public function setAge(age:Number):Void {
		this.age = age;
	}

	public function getAge(Void):Number {
		return age;
	}

	public function setName(name:String):Void {
		this.name = name;
	}

	public function getName(Void):String {
		return name;
	}

	public function setSpouse(spouse:TestBean):Void {
		this.spouse = spouse;
	}

	public function getSpouse(Void):TestBean {
		return spouse;
	}

	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.beanFactory = beanFactory;
	}

	public function getBeanFactory(Void):BeanFactory {
		return beanFactory;
	}

}