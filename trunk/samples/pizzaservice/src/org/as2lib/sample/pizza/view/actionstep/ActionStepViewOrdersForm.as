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

import org.actionstep.ASList;
import org.actionstep.ASListItem;
import org.actionstep.NSArray;
import org.actionstep.NSButton;
import org.actionstep.NSProgressIndicator;
import org.as2lib.sample.pizza.view.ViewOrdersForm;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.actionstep.ActionStepViewOrdersForm extends
		ViewOrdersForm {

	private var orderList:ASList = null;
	private var pizzaList:ASList = null;
	private var cancelOrderButton:NSButton = null;
	private var progressBar:NSProgressIndicator = null;

	public function ActionStepViewOrdersForm(Void) {
	}

	private function showProgressBar(Void):Void {
		progressBar.setHidden(false);
	}

	private function hideProgressBar(Void):Void {
		progressBar.setHidden(true);
	}

	private function enableCancelOrderButton(Void):Void {
		cancelOrderButton.setEnabled(true);
	}

	private function disableCancelOrderButton(Void):Void {
		cancelOrderButton.setEnabled(false);
	}

	private function getSelectedOrderIndex(Void):Number {
		var items:Array = orderList.items().internalList();
		for (var i:Number = 0; i < items.length; i++) {
			var item:ASListItem = items[i];
			if (item.isSelected()) {
				return i;
			}
		}
		return -1;
	}

	private function selectOrder(orderIndex:Number):Void {
		orderList.selectItemAtIndex(orderIndex);
	}

	private function setOrders(orderNames:Array):Void {
		orderList.setItems(toListItems(orderNames));
	}

	private function setPizzas(pizzaDetails:Array):Void {
		pizzaList.setItems(toListItems(pizzaDetails));
	}

	private function toListItems(itemNames:Array):NSArray {
		var result:NSArray = new NSArray();
		if (itemNames != null) {
			for (var i:Number = 0; i < itemNames.length; i++) {
				var name:String = itemNames[i];
				var item:ASListItem = new ASListItem();
				item.initWithLabelData(name, null);
				result.addObject(item);
			}
		}
		return result;
	}

}