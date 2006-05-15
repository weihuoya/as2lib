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
import org.as2lib.sample.pizza.model.OrderItem;
import org.as2lib.util.ArrayUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.model.Order extends BasicClass {
	
	private var id:Number;
	private var name:String;
	private var items:Array;
	
	public function Order(id:Number, name:String) {
		this.id = id;
		this.name = name;
		items = new Array();
	}
	
	public function getId(Void):Number {
		return id;
	}
	
	public function getName(Void):String {
		return name;
	}
	
	public function getItems(Void):Array {
		return items;
	}
	
	public function addItem(item:OrderItem):Void {
		items.push(item);
	}
	
	public function removeItem(itemIndex:Number):Void {
		items.splice(itemIndex, 1);
	}
	
	public function removeItems(Void):Void {
		items = new Array();
	}
	
	public function toString():String {
		var result:String = "Order";
		if (id != null) {
			result += [" + id + "];
		}
		result += "(";
		for (var i:Number = 0; i < items.length; i++) {
			result += items[i].toString();
			if (i < items.length - 1) {
				result += ", ";
			}
		}
		result += ")";
		return result;
	}
	
}