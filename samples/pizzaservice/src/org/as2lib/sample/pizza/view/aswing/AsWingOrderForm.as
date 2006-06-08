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

import org.as2lib.sample.pizza.view.OrderForm;
import org.aswing.JButton;
import org.aswing.JComboBox;
import org.aswing.JList;
import org.aswing.JProgressBar;
import org.aswing.JTextField;
import org.aswing.VectorListModel;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.aswing.AsWingOrderForm extends OrderForm {

	private var nameTextField:JTextField = null;
	private var quantityTextField:JTextField = null;
	private var sizeComboBox:JComboBox = null;
	private var crustComboBox:JComboBox = null;
	private var toppingList:JList = null;
	private var orderTicketList:JList = null;
	private var addButton:JButton = null;
	private var removeButton:JButton = null;
	private var placeOrderButton:JButton = null;
	private var progressBar:JProgressBar = null;

	public function AsWingOrderForm(Void) {
	}

	private function getName(Void):String {
		return nameTextField.getText();
	}

	private function getQuantity(Void):Number {
		return Number(quantityTextField.getText());
	}

	private function getSize(Void):String {
		return String(sizeComboBox.getSelectedItem());
	}

	private function getCrust(Void):String {
		return String(crustComboBox.getSelectedItem());
	}

	private function getToppings(Void):Array {
		return toppingList.getSelectedValues();
	}

	private function showProgressBar(Void):Void {
		progressBar.setVisible(true);
	}

	private function enablePlaceOrderButton(Void):Void {
		placeOrderButton.setEnabled(true);
	}

	private function disablePlaceOrderButton(Void):Void {
		placeOrderButton.setEnabled(false);
	}

	private function enableAddButton(Void):Void {
		addButton.setEnabled(true);
	}

	private function disableAddButton(Void):Void {
		addButton.setEnabled(false);
	}

	private function enableRemoveButton(Void):Void {
		removeButton.setEnabled(true);
	}

	private function disableRemoveButton(Void):Void {
		removeButton.setEnabled(false);
	}

	private function getOrderTicketCount(Void):Number {
		return orderTicketList.getModel().getSize();
	}

	private function getSelectedOrderTicketIndices(Void):Array {
		return orderTicketList.getSelectedIndices();
	}

	private function addOrderTicket(orderTicket:String):Void {
		// TODO: Find a better solution for adding items to the list.
		var model:VectorListModel = VectorListModel(orderTicketList.getModel());
		model.append(orderTicket);
		selectOrderTicket(model.getSize() - 1);
		orderTicketList.scrollToBottomLeft();
	}

	private function removeOrderTickets(orderTicketIndices:Array):Void {
		// TODO: Find a better solution for removing items from the list.
		var model:VectorListModel = VectorListModel(orderTicketList.getModel());
		if (orderTicketIndices != null) {
			for (var i:Number = orderTicketIndices.length - 1; i >= 0; i--) {
				model.removeAt(orderTicketIndices[i]);
			}
		}
		else {
			model.removeRange(0, model.size() - 1);
		}
	}

	private function selectOrderTicket(orderTicketIndex:Number):Void {
		orderTicketList.setSelectedIndex(orderTicketIndex);
	}

	private function isToppingSelected(Void):Boolean {
		return !toppingList.isSelectionEmpty();
	}

}