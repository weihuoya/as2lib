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

import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.ConstructorArgumentValues extends BasicClass {
	
	private var argumentValues:Array;
	
	public function ConstructorArgumentValues(source:ConstructorArgumentValues) {
		argumentValues = new Array();
		if (source != null) {
			var avs:Array = source.getArgumentValues();
			for (var i:Number = 0; i < avs.length; i++) {
				var av:ConstructorArgumentValue = avs[i];
				argumentValues.push(new ConstructorArgumentValue(av.getValue(), av.getType()));
			}
		}
	}
	
	public function addArgumentValues(argumentValues:ConstructorArgumentValues):Void {
		var avs:Array = argumentValues.getArgumentValues();
		for (var i:Number = 0; i < avs.length; i++) {
			addArgumentValueByValue(avs[i]);
		}
	}
	
	public function addArgumentValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([ConstructorArgumentValue], addArgumentValueByValue);
		o.addHandler([Number, ConstructorArgumentValue], addArgumentValueByIndexAndValue);
		o.forward(arguments);
	}
	
	public function addArgumentValueByValue(value:ConstructorArgumentValue):Void {
		argumentValues.push(value);
	}
	
	public function addArgumentValueByIndexAndValue(index:Number, value:ConstructorArgumentValue):Void {
		argumentValues[index] = value;
	}
	
	public function removeArgumentValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([ConstructorArgumentValue], removeArgumentValueByValue);
		o.addHandler([Number], removeArgumentValueByIndex);
		o.forward(arguments);
	}
	
	public function removeArgumentValueByValue(value:ConstructorArgumentValue):Void {
		ArrayUtil.removeElement(argumentValues, value);
	}
	
	public function removeArgumentValueByIndex(index:Number):Void {
		argumentValues.splice(index, 1);
	}
	
	public function getArgumentCount(Void):Number {
		return argumentValues.length;
	}
	
	public function getArgumentValue(index:Number):ConstructorArgumentValue {
		return argumentValues[index];
	}
	
	public function getArgumentValues(Void):Array {
		return argumentValues.concat();
	}
	
	public function isEmpty(Void):Boolean {
		return (argumentValues.length < 1);
	}
	
}