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
import org.actionstep.NSView;
import org.as2lib.context.ApplicationEvent;
import org.as2lib.context.ApplicationListener;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderPlacedEvent;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.actionstep.ActionStepOrderForm extends NSView implements ApplicationListener {
	
	private var controller:Controller = null;
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
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrderPlacedEvent) {
			orderTicketList.removeAllItems();
			controller.removeOrderItems();
		}
	}
	
	public function placeOrder(Void):Void {
		progressBar.setHidden(false);
		controller.placeOrder(nameTextField.stringValue());
	}
	
	public function addOrderItem(Void):Void {
		var quantity:Number = Number(quantityStepper.intValue());
		var size:String = String(sizeComboBox.objectValueOfSelectedItem());
		var crust:String = String(crustComboBox.objectValueOfSelectedItem());
		var toppings:Array = getToppingNames(toppingList.selectedItems().internalList());
		var item:String = controller.addOrderItem(quantity, size, crust, toppings);
		orderTicketList.addItemWithLabelData(item);
		orderTicketList.selectItemAtIndex(orderTicketList.numberOfItems() - 1);
		removeButton.setEnabled(true);
		if (nameTextField.stringValue() != "") {
			placeOrderButton.setEnabled(true);
		}
	}
	
	private function getToppingNames(toppingItems:Array):Array {
		var result:Array = new Array();
		for (var i:Number = 0; i < toppingItems.length; i++) {
			var item:ASListItem = toppingItems[i];
			result.push(item.label());
		}
		return result;
	}
	
	public function removeOrderItem(Void):Void {
		var items:Array = orderTicketList.items().internalList();
		var itemIndices:Array = new Array();
		for (var i:Number = 0; i < items.length; i++) {
			var item:ASListItem = items[i];
			if (item.isSelected()) {
				itemIndices.push(i);
			}
		}
		controller.removeOrderItems(itemIndices);
		for (var i:Number = itemIndices.length - 1; i >= 0; i--) {
			orderTicketList.removeItemAtIndex(itemIndices[i]);
		}
		if (orderTicketList.numberOfItems() == 0) {
			removeButton.setEnabled(false);
			placeOrderButton.setEnabled(false);
		}
		else {
			var index:Number;
			if (orderTicketList.numberOfItems() > itemIndices[0]) {
				index = itemIndices[0];
			}
			else {
				index = orderTicketList.numberOfItems() - 1;
			}
			orderTicketList.selectItemAtIndex(index);
		}
	}
	
	public function onNameChanged(Void):Void {
		if (nameTextField.stringValue() != "") {
			if (orderTicketList.numberOfItems() > 0) {
				placeOrderButton.setEnabled(true);
			}
		}
		else {
			placeOrderButton.setEnabled(false);
		}
	}
	
	public function onToppingsChanged(Void):Void {
		if (toppingList.selectedItems().internalList().length == 0) {
			addButton.setEnabled(false);
		}
		else {
			addButton.setEnabled(true);
		}
	}
	
}