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

import org.as2lib.core.BasicInterface;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * @author Simon Wacker
 */
interface org.as2lib.sample.pizza.dao.PizzaService extends BasicInterface {

	public function order(name:String, orderItems:Array, callback:MethodInvocationCallback):Number;
	public function cancelOrder(orderId:Number, callback:MethodInvocationCallback):Boolean;
	public function getOrderList(callback:MethodInvocationCallback):Array;
	public function listToppings(callback:MethodInvocationCallback):Array;

}