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

	private function showProgressBar(Void):Void {
		getProgressBar().visible = true;
	}

	private function hideProgressBar(Void):Void {
		getProgressBar().visible = false;
	}

	private function enableCancelOrderButton(Void):Void {
		getCancelOrderButton().enabled = true;
	}

	private function disableCancelOrderButton(Void):Void {
		getCancelOrderButton().enabled = false;
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
		return null;
	}

	public function getPizzaList(Void):ListBox {
		return null;
	}

	public function getCancelOrderButton(Void):Button {
		return null;
	}

	public function getProgressBar(Void):ProgressBar {
		return null;
	}

}