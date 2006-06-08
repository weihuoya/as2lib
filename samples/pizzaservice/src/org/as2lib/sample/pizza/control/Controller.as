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

import org.as2lib.context.ApplicationListener;
import org.as2lib.context.MessageSource;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.sample.pizza.dao.PizzaService;
import org.as2lib.sample.pizza.model.Order;
import org.as2lib.sample.pizza.model.OrderItem;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.control.Controller extends BasicClass {

	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.pizza.control.Controller");

	private var pizzaService:PizzaService;
	private var loadOrdersCallback:MethodInvocationCallback;
	private var placeOrderCallback:MethodInvocationCallback;
	private var cancelOrderCallback:MethodInvocationCallback;
	private var currentOrder:Order;
	private var cachedOrders:Array;

	private function Controller(Void) {
		currentOrder = new Order();
	}

	public function init(Void):Void {
		if (pizzaService == null) {
			throw new IllegalArgumentException("Pizza service is required.", this, arguments);
		}
		if (loadOrdersCallback == null) {
			throw new IllegalArgumentException("Load orders callback is required.", this, arguments);
		}
		if (placeOrderCallback == null) {
			throw new IllegalArgumentException("Place order callback is required.", this, arguments);
		}
		if (cancelOrderCallback == null) {
			throw new IllegalArgumentException("Cancel order callback is required.", this, arguments);
		}
	}

	public function setPizzaService(pizzaService:PizzaService):Void {
		this.pizzaService = pizzaService;
	}

	public function setLoadOrdersCallback(loadOrdersCallback:MethodInvocationCallback):Void {
		this.loadOrdersCallback = loadOrdersCallback;
	}

	public function setPlaceOrderCallback(placeOrderCallback:MethodInvocationCallback):Void {
		this.placeOrderCallback = placeOrderCallback;
	}

	public function setCancelOrderCallback(cancelOrderCallback:MethodInvocationCallback):Void {
		this.cancelOrderCallback = cancelOrderCallback;
	}

	public function placeOrder(customerName:String):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Placing order [" + currentOrder + "] for customer '" + customerName + "'.");
		}
		pizzaService.order(customerName, currentOrder.getItems(), placeOrderCallback);
	}

	public function cancelOrder(orderIndex:Number):Void {
		var orderId:Number = Order(cachedOrders[orderIndex]).getId();
		if (logger.isInfoEnabled()) {
			logger.info("Canceling order '" + orderId + "'.");
		}
		pizzaService.cancelOrder(orderId, cancelOrderCallback);
	}

	public function loadOrders(Void):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Loading orders.");
		}
		pizzaService.getOrderList(loadOrdersCallback);
	}

	public function addOrderItem(quantity:Number, size:String, crust:String, toppings:Array):String {
		var details:String = OrderItem.generateDetails(quantity, size, crust, toppings);
		if (logger.isInfoEnabled()) {
			logger.info("Adding order item '" + details + "'.");
		}
		var orderItem:OrderItem = new OrderItem(quantity, details);
		currentOrder.addItem(orderItem);
		return details;
	}

	public function removeOrderItem(itemIndex:Number):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Removing order item '" + itemIndex + "'.");
		}
		currentOrder.removeItem(itemIndex);
	}

	public function removeOrderItems(items:Array):Void {
		if (items == null) {
			currentOrder.removeItems();
		}
		else {
			for (var i:Number = items.length - 1; i >= 0; i--) {
				removeOrderItem(Number(items[i]));
			}
		}
	}

	public function getOrderNames(Void):Array {
		var result:Array = new Array();
		for (var i:Number = 0; i < cachedOrders.length; i++) {
			var order:Order = cachedOrders[i];
			result.push(order.getName());
		}
		return result;
	}

	public function getPizzaDetails(orderIndex:Number):Array {
		var result:Array = new Array();
		var order:Order = cachedOrders[orderIndex];
		var orderItems:Array = order.getItems();
		for (var i:Number = 0; i < orderItems.length; i++) {
			var orderItem:OrderItem = orderItems[i];
			result.push(orderItem.getDetails());
		}
		return result;
	}

	public function setOrders(orders:Array):Void {
		this.cachedOrders = orders;
	}

}