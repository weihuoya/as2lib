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
class org.as2lib.sample.pizza.model.OrderItem extends BasicClass {

	public static function generateDetails(quantity:Number, size:String, crust:String,
			toppings:Array):String {
		var result:String = quantity.toString();
		result += " " + size;
		result += " " + crust;
		for (var i:Number = 0; i < toppings.length; i++) {
			result += " " + toppings[i];
		}
		return result;
	}

	private var quantity:Number;
	private var details:String;

	public function OrderItem(quantity:Number, details:String) {
		this.quantity = quantity;
		this.details = details;
	}

	public function getQuantity(Void):Number {
		return quantity;
	}

	public function getDetails(Void):String {
		return details;
	}

	public function toString():String {
		return "OrderItem(" + details + ")";
	}

}