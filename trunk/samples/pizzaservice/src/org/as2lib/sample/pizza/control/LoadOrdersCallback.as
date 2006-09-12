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

import mx.remoting.RecordSet;

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.io.conn.core.event.ContextMethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrdersLoadedEvent;
import org.as2lib.sample.pizza.model.Order;
import org.as2lib.sample.pizza.model.OrderItem;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.control.LoadOrdersCallback extends ContextMethodInvocationCallback {

	private static var logger:Logger = LogManager.getLogger(eval("th" + "is"));

	private var controller:Controller;

	public function LoadOrdersCallback(Void) {
	}

	public function setController(controller:Controller):Void {
		this.controller = controller;
	}

	public function onReturn(returnInfo:MethodInvocationReturnInfo):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Loaded orders successfully.");
		}
		var orders:Array = parseOrders(returnInfo.getReturnValue());
		controller.setOrders(orders);
		super.onReturn(returnInfo);
	}

	private function parseOrders(orders:RecordSet):Array {
		var result:Array = new Array();
		var temp:Array = new Array();
		for (var i:Number = orders.getLength() - 1; i >= 0; i--) {
			var item = orders.getItemAt(i);
			var order:Order = temp[item.orderid];
			if (order == null) {
				order = new Order(item.orderid, item.name);
				result.push(order);
				temp[item.orderid] = order;
			}
			order.addItem(new OrderItem(item.quantity, item.details));
		}
		return result;
	}

}