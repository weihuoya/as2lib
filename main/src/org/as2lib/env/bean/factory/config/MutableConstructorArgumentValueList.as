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
import org.as2lib.util.ArrayUtil;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.bean.factory.config.ConstructorArgumentValueList;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.factory.config.MutableConstructorArgumentValueList extends BasicClass implements ConstructorArgumentValueList {
	
	private var argumentArray:Array;
	
	public function MutableConstructorArgumentValueList(Void) {
		argumentArray = new Array();
	}
	
	public function addArgumentValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], addArgumentValueByValue);
		o.addHandler([Number, Object], addArgumentValueByIndexAndValue);
		o.forward(arguments);
	}
	
	public function addArgumentValueByValue(value):Void {
		argumentArray.push(value);
	}
	
	public function addArgumentValueByIndexAndValue(index:Number, value):Void {
		argumentArray[index] = value;
	}
	
	public function removeArgumentValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], removeArgumentValueByValue);
		o.addHandler([Number], removeArgumentValueByIndex);
		o.forward(arguments);
	}
	
	public function removeArgumentValueByValue(value):Void {
		ArrayUtil.removeElement(argumentArray, value);
	}
	
	public function removeArgumentValueByIndex(index:Number):Void {
		argumentArray.splice(index, 1);
	}
	
	public function getArgumentCount(Void):Number {
		return argumentArray.length;
	}
	
	public function getArgumentValue(index:Number) {
		return argumentArray[index];
	}
	
	public function getArgumentValues(Void):Array {
		return argumentArray.concat();
	}
	
	public function isEmpty(Void):Boolean {
		return (argumentArray.length < 1);
	}
	
}