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
import org.aswing.JButton;
import org.aswing.JList;
import org.aswing.JProgressBar;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.aswing.AsWingViewOrdersForm extends ViewOrdersForm {

	private var orderList:JList = null;
	private var pizzaList:JList = null;
	private var cancelOrderButton:JButton = null;
	private var progressBar:JProgressBar = null;

	public function AsWingViewOrdersForm(Void) {
	}

	private function setShowProgressBar(showProgressBar:Boolean):Void {
		progressBar.setVisible(showProgressBar);
	}

	private function setEnableCancelOrderButton(enableCancelOrderButton:Boolean):Void {
		cancelOrderButton.setEnabled(enableCancelOrderButton);
	}

	private function getSelectedOrderIndex(Void):Number {
		return orderList.getSelectedIndex();
	}

	private function selectOrder(orderIndex:Number):Void {
		orderList.setSelectedIndex(orderIndex);
	}

	private function setOrders(orderNames:Array):Void {
		orderList.setListData(orderNames);
	}

	private function setPizzas(pizzaDetails:Array):Void {
		pizzaList.setListData(pizzaDetails);
	}

}