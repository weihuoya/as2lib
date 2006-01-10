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
import org.as2lib.env.except.Exception;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.TestBean extends BasicClass {
	
	private var name:String;
	private var age:Number;
	private var spouse:TestBean;
	private var postProcessed:Boolean;
	private var touchy:String;
	
	public function TestBean(name:String, age:Number) {
		this.name = name;
		this.age = age == null ? 0 : age;
	}
	
	public function getName(Void):String {
		return name;
	}
	
	public function setName(name:String):Void {
		this.name = name;
	}
	
	public function getAge(Void):Number {
		return age;
	}
	
	public function setAge(age:Number):Void {
		this.age = age;
	}
	
	public function getSpouse(Void):TestBean {
		return spouse;
	}
	
	public function setSpouse(spouse:TestBean):Void {
		this.spouse = spouse;
	}
	
	public function setPostProcessed(postProcessed:Boolean):Void {
		this.postProcessed = postProcessed;
	}

	public function isPostProcessed():Boolean {
		return postProcessed;
	}
	
	public function setTouchy(touchy:String):Void {
		if (touchy.indexOf('.') != -1) {
			throw new Exception("Can't contain a .", this, arguments);
		}
		if (touchy.indexOf(',') != -1) {
			throw new Exception("Number format exception: contains a ,", this, arguments);
		}
		this.touchy = touchy;
	}
	
	public function getTouchy(Void):String {
		return touchy;
	}
	
	public function equals(other):Boolean {
		if (this == other) {
			return true;
		}
		if (other == null || !(other instanceof TestBean)) {
			return false;
		}
		var tb2:TestBean = other;
		return (this.name == tb2.getName() && this.age == tb2.getAge());
	}
	
}