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
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderPlacedEvent;
import org.aswing.JButton;
import org.aswing.JComboBox;
import org.aswing.JList;
import org.aswing.JPanel;
import org.aswing.JProgressBar;
import org.aswing.JTextField;
import org.aswing.VectorListModel;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.aswing.AsWingOrderForm extends JPanel implements ApplicationListener {
	
	private var controller:Controller = null;
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
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrderPlacedEvent) {
			// TODO: Find a better solution for removing items from the list.
			var model:VectorListModel = VectorListModel(orderTicketList.getModel());
			model.removeRange(0, model.size() - 1);
		}
	}
	
	public function placeOrder(Void):Void {
		progressBar.setVisible(true);
		controller.placeOrder(nameTextField.getText());
	}
	
	public function addOrderItem(Void):Void {
		var quantity:Number = Number(quantityTextField.getText());
		var size:String = String(sizeComboBox.getSelectedItem());
		var crust:String = String(crustComboBox.getSelectedItem());
		var toppings:Array = toppingList.getSelectedValues();
		var item:String = controller.addOrderItem(quantity, size, crust, toppings);
		// TODO: Find a better solution for adding items to the list.
		var model:VectorListModel = VectorListModel(orderTicketList.getModel());
		model.append(item);
		orderTicketList.setSelectedIndex(model.getSize() - 1);
		orderTicketList.scrollToBottomLeft();
		removeButton.setEnabled(true);
		if (nameTextField.getText() != "") {
			placeOrderButton.setEnabled(true);
		}
	}
	
	public function removeOrderItem(Void):Void {
		var items:Array = orderTicketList.getSelectedIndices();
		controller.removeOrderItems(items);
		// TODO: Find a better solution for removing items to the list.
		var model:VectorListModel = VectorListModel(orderTicketList.getModel());
		for (var i:Number = items.length - 1; i >= 0; i--) {
			model.removeAt(items[i]);
		}
		if (model.isEmpty()) {
			removeButton.setEnabled(false);
			placeOrderButton.setEnabled(false);
		}
		else {
			var index:Number;
			if (model.getSize() > items[0]) {
				index = items[0];
			}
			else {
				index = model.getSize() - 1;
			}
			orderTicketList.setSelectedIndex(index);
		}
	}
	
	public function onNameChanged(Void):Void {
		if (nameTextField.getTextLength() > 0) {
			if (orderTicketList.getModel().getSize() > 0) {
				placeOrderButton.setEnabled(true);
			}
		}
		else {
			placeOrderButton.setEnabled(false);
		}
	}
	
	public function onToppingsChanged(Void):Void {
		if (toppingList.isSelectionEmpty()) {
			addButton.setEnabled(false);
		}
		else {
			addButton.setEnabled(true);
		}
	}
	
}