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
import org.actionstep.NSButton;
import org.actionstep.NSComboBox;
import org.actionstep.NSProgressIndicator;
import org.actionstep.NSStepper;
import org.actionstep.NSTextField;
import org.as2lib.sample.pizza.view.OrderForm;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.actionstep.ActionStepOrderForm extends OrderForm {

	private var nameTextField:NSTextField = null;
	private var quantityStepper:NSStepper = null;
	private var sizeComboBox:NSComboBox = null;
	private var crustComboBox:NSComboBox = null;
	private var toppingList:ASList = null;
	private var orderTicketList:ASList = null;
	private var addButton:NSButton = null;
	private var removeButton:NSButton = null;
	private var placeOrderButton:NSButton = null;
	private var progressBar:NSProgressIndicator = null;

	public function ActionStepOrderForm(Void) {
	}

	private function getName(Void):String {
		return nameTextField.stringValue();
	}

	private function getQuantity(Void):Number {
		return quantityStepper.intValue();
	}

	private function getSize(Void):String {
		return String(sizeComboBox.objectValueOfSelectedItem());
	}

	private function getCrust(Void):String {
		return String(crustComboBox.objectValueOfSelectedItem());
	}

	private function getToppings(Void):Array {
		var result:Array = new Array();
		var toppingItems:Array = toppingList.selectedItems().internalList();
		for (var i:Number = 0; i < toppingItems.length; i++) {
			var item:ASListItem = toppingItems[i];
			result.push(item.label());
		}
		return result;
	}

	private function setShowProgressBar(showProgressBar:Boolean):Void {
		progressBar.setHidden(!showProgressBar);
	}

	private function setEnablePlaceOrderButton(enablePlaceOrderButton:Boolean):Void {
		placeOrderButton.setEnabled(enablePlaceOrderButton);
	}

	private function setEnableAddButton(enableAddButton:Boolean):Void {
		addButton.setEnabled(enableAddButton);
	}

	private function setEnableRemoveButton(enableRemoveButton:Boolean):Void {
		removeButton.setEnabled(enableRemoveButton);
	}

	private function getOrderItemCount(Void):Number {
		return orderTicketList.numberOfItems();
	}

	private function getSelectedOrderItemIndices(Void):Array {
		var result:Array = new Array();
		var items:Array = orderTicketList.items().internalList();
		for (var i:Number = 0; i < items.length; i++) {
			var item:ASListItem = items[i];
			if (item.isSelected()) {
				result.push(i);
			}
		}
		return result;
	}

	private function addToOrderTicket(orderItem:String):Void {
		orderTicketList.addItemWithLabelData(orderItem);
		orderTicketList.selectItemAtIndex(orderTicketList.numberOfItems() - 1);
	}

	private function removeFromOrderTicket(orderItemIndices:Array):Void {
		if (orderItemIndices != null) {
			for (var i:Number = orderItemIndices.length - 1; i >= 0; i--) {
				orderTicketList.removeItemAtIndex(orderItemIndices[i]);
			}
		}
		else {
			orderTicketList.removeAllItems();
		}
	}

	private function selectOrderItem(orderItemIndex:Number):Void {
		orderTicketList.selectItemAtIndex(orderItemIndex);
	}

	private function isToppingSelected(Void):Boolean {
		return (toppingList.selectedItems().internalList().length > 0);
	}

}