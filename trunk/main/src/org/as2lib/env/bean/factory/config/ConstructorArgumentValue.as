﻿/*
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
import org.as2lib.env.overload.Overload;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.factory.config.ConstructorArgumentValue extends BasicClass {
	
	private var value;
	private var type:Function;
	
	public function ConstructorArgumentValue() {
		var o:Overload = new Overload(this);
		o.addHandler([String], ConstructorArgumentValueByValue);
		o.addHandler([String, Function], ConstructorArgumentValueByValueAndType);
		o.forward(arguments);
	}
	
	private function ConstructorArgumentValueByValue(value):Void {
		ConstructorArgumentValueByValueAndType(value, null);
	}
	
	private function ConstructorArgumentValueByValueAndType(value, type:Function):Void {
		this.value = value;
		this.type = type;
	}
	
	public function getValue(Void) {
		return value;
	}
	
	public function getType(Void):Function {
		return type;
	}
	
}