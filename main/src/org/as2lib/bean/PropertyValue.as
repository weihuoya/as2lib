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

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValue extends BasicClass {
	
	private var name:String;
	private var value;
	private var type:Function;
	
	public function PropertyValue(name:String, value, type:Function) {
		this.name = name;
		this.value = value;
		this.type = type;
	}
	
	public function getName(Void):String {
		return name;
	}
	
	public function getValue(Void) {
		return value;
	}
	
	public function getType(Void):Function {
		return type;
	}
	
	public function toString():String {
		return (name + "=" + value);
	}
	
}