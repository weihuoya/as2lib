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

import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.sample.pizza.view.ViewOrdersForm;

import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.ListItem;
import com.asual.enflash.ui.ProgressBar;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.enflash.EnFlashViewOrdersForm extends ViewOrdersForm {

	public function EnFlashViewOrdersForm(Void) {
	}

	private function setShowProgressBar(showProgressBar:Boolean):Void {
		getProgressBar().visible = showProgressBar;
	}

	private function setEnableCancelOrderButton(enableCancelOrderButton:Boolean):Void {
		getCancelOrderButton().enabled = enableCancelOrderButton;
	}

	private function getSelectedOrderIndex(Void):Number {
		return getOrderList().selectedIndex;
	}

	private function selectOrder(orderIndex:Number):Void {
		getOrderList().selectedIndex = orderIndex;
	}

	private function setOrders(orderNames:Array):Void {
		var orderList:ListBox = getOrderList();
		orderList.removeAll();
		if (orderNames != null) {
			for (var i:Number = 0; i < orderNames.length; i++) {
				var item:ListItem = orderList.addItem();
				item.value = orderNames[i];
			}
		}
	}

	private function setPizzas(pizzaDetails:Array):Void {
		var pizzaList:ListBox = getPizzaList();
		pizzaList.removeAll();
		if (pizzaDetails != null) {
			for (var i:Number = 0; i < pizzaDetails.length; i++) {
				var item:ListItem = pizzaList.addItem();
				item.value = pizzaDetails[i];
			}
		}
	}

	public function getOrderList(Void):ListBox {
		throw new AbstractOperationException("Implementation must be provided by sub-class or " +
				"IoC container.", this, arguments);
		return null;
	}

	public function getPizzaList(Void):ListBox {
		throw new AbstractOperationException("Implementation must be provided by sub-class or " +
				"IoC container.", this, arguments);
		return null;
	}

	public function getCancelOrderButton(Void):Button {
		throw new AbstractOperationException("Implementation must be provided by sub-class or " +
				"IoC container.", this, arguments);
		return null;
	}

	public function getProgressBar(Void):ProgressBar {
		throw new AbstractOperationException("Implementation must be provided by sub-class or " +
				"IoC container.", this, arguments);
		return null;
	}

}