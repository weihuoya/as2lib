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
import org.as2lib.sample.pizza.event.OrderPlacedEvent;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.OrderForm extends BasicClass implements
		ApplicationListener {

	private var controller:Controller = null;

	private function OrderForm(Void) {
	}

	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrderPlacedEvent) {
			removeFromOrderTicket(null);
			setEnablePlaceOrderButton(false);
			setEnableRemoveButton(false);
			controller.removeOrderItems();
		}
	}

	public function placeOrder(Void):Void {
		setShowProgressBar(true);
		controller.placeOrder(getName());
	}

	public function addOrderItem(Void):Void {
		var orderItem:String = controller.addOrderItem(getQuantity(), getSize(), getCrust(), getToppings());
		addToOrderTicket(orderItem);
		setEnableRemoveButton(true);
		if (getName().length > 0) {
			setEnablePlaceOrderButton(true);
		}
	}

	public function removeOrderItem(Void):Void {
		var items:Array = getSelectedOrderItemIndices();
		controller.removeOrderItems(items);
		removeFromOrderTicket(items);
		var orderItemCount:Number = getOrderItemCount();
		if (orderItemCount > 0) {
			var index:Number;
			if (orderItemCount > items[0]) {
				index = items[0];
			}
			else {
				index = orderItemCount - 1;
			}
			selectOrderItem(index);
		}
		else {
			setEnableRemoveButton(false);
			setEnablePlaceOrderButton(false);
		}
	}

	public function onNameChanged(Void):Void {
		if (getName().length > 0) {
			if (getOrderItemCount() > 0) {
				setEnablePlaceOrderButton(true);
			}
		}
		else {
			setEnablePlaceOrderButton(false);
		}
	}

	public function onToppingsChanged(Void):Void {
		if (isToppingSelected()) {
			setEnableAddButton(true);
		}
		else {
			setEnableAddButton(false);
		}
	}

	private function getName(Void):String {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function getQuantity(Void):Number {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function getSize(Void):String {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function getCrust(Void):String {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function getToppings(Void):Array {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function setShowProgressBar(showProgressBar:Boolean):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function setEnablePlaceOrderButton(enablePlaceOrderButton:Boolean):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function setEnableAddButton(enableAddButton:Boolean):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function setEnableRemoveButton(enableRemoveButton:Boolean):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function getOrderItemCount(Void):Number {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function getSelectedOrderItemIndices(Void):Array {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

	private function addToOrderTicket(orderItem:String):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function removeFromOrderTicket(orderItemIndices:Array):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function selectOrderItem(orderItemIndex:Number):Void {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	private function isToppingSelected(Void):Boolean {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
		return null;
	}

}