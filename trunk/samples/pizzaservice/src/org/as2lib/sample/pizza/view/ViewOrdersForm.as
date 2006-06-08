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

import org.as2lib.context.ApplicationEvent;
import org.as2lib.context.ApplicationListener;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderCanceledEvent;
import org.as2lib.sample.pizza.event.OrdersLoadedEvent;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.ViewOrdersForm extends BasicClass implements
		ApplicationListener {

	private var controller:Controller = null;

	private function ViewOrdersForm(Void) {
	}

	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrdersLoadedEvent) {
			updateOrders();
			hideProgressBar();
			return;
		}
		if (event instanceof OrderCanceledEvent) {
			controller.loadOrders();
			return;
		}
	}

	public function cancelOrder(Void):Void {
		showProgressBar();
		var orderIndex:Number = getSelectedOrderIndex();
		controller.cancelOrder(orderIndex);
	}

	public function updateOrders(Void):Void {
		var orderNames:Array = controller.getOrderNames();
		setOrders(orderNames);
		if (orderNames.length > 0) {
			selectOrder(0);
			enableCancelOrderButton();
		}
		else {
			disableCancelOrderButton();
		}
		updatePizzas();
	}

	public function updatePizzas(Void):Void {
		var orderIndex:Number = getSelectedOrderIndex();
		if (orderIndex > -1) {
			var pizzaDetails:Array = controller.getPizzaDetails(orderIndex);
			setPizzas(pizzaDetails);
			enableCancelOrderButton();
		}
		else {
			setPizzas(null);
			disableCancelOrderButton();
		}
	}

	private function showProgressBar(Void):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function hideProgressBar(Void):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function getSelectedOrderIndex(Void):Number {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function selectOrder(orderIndex:Number):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function enableCancelOrderButton(Void):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function disableCancelOrderButton(Void):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function setOrders(orderNames:Array):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function setPizzas(pizzaDetails:Array):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

}