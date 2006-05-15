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

import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.ComboBox;
import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.ListItem;
import com.asual.enflash.ui.ProgressBar;
import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.TextInput;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.enflash.EnFlashOrderForm extends ScrollPane implements
		ApplicationListener {
	
	private var controller:Controller = null;
	
	public function EnFlashOrderForm(Void) {
	}
	
	public function getNameTextInput(Void):TextInput {
		return null;
	}
	
	public function getQuantityTextInput(Void):TextInput {
		return null;
	}
	
	public function getSizeComboBox(Void):ComboBox {
		return null;
	}
	
	public function getCrustComboBox(Void):ComboBox {
		return null;
	}
	
	public function getToppingList(Void):ListBox {
		return null;
	}
	
	public function getOrderTicketList(Void):ListBox {
		return null;
	}
	
	public function getAddButton(Void):Button {
		return null;
	}
	
	public function getRemoveButton(Void):Button {
		return null;
	}
	
	public function getPlaceOrderButton(Void):Button {
		return null;
	}
	
	public function getProgressBar(Void):ProgressBar {
		return null;
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrderPlacedEvent) {
			getOrderTicketList().removeAll();
			controller.removeOrderItems();
		}
	}
	
	public function placeOrder(Void):Void {
		getProgressBar().visible = true;
		controller.placeOrder(getNameTextInput().value);
	}
	
	public function addOrderItem(Void):Void {
		var orderTicketList:ListBox = getOrderTicketList();
		var quantity:Number = Number(getQuantityTextInput().value);
		var size:String = getSizeComboBox().selectedItem.value;
		var crust:String = getCrustComboBox().selectedItem.value;
		var topping:String = getToppingList().selectedItem.value;
		var orderItem:String = controller.addOrderItem(quantity, size, crust, [topping]);
		var listItem:ListItem = orderTicketList.addItem();
		listItem.value = orderItem;
		orderTicketList.selectedIndex = orderTicketList["_content"].length - 1;
		getRemoveButton().enabled = true;
		if (getNameTextInput().value != "") {
			getPlaceOrderButton().enabled = true;
		}
	}
	
	public function removeOrderItem(Void):Void {
		var orderTicketList:ListBox = getOrderTicketList();
		var itemIndex:Number = orderTicketList.selectedIndex;
		controller.removeOrderItem(itemIndex);
		orderTicketList.removeItemAt(itemIndex);
		if (orderTicketList["_content"].length == 0) {
			getRemoveButton().enabled = false;
			getPlaceOrderButton().enabled = false;
		}
		else {
			var index:Number;
			if (orderTicketList["_content"].length > itemIndex) {
				index = itemIndex;
			}
			else {
				index = orderTicketList["_content"].length - 1;
			}
			orderTicketList.selectedIndex = index;
		}
	}
	
	public function onNameChanged(Void):Void {
		if (getNameTextInput().value.length > 0) {
			if (getOrderTicketList()["_content"].length > 0) {
				getPlaceOrderButton().enabled = true;
			}
		}
		else {
			getPlaceOrderButton().enabled = false;
		}
	}
	
	public function onToppingsChanged(Void):Void {
		if (getToppingList().selectedIndex == -1) {
			getAddButton().enabled = false;
		}
		else {
			getAddButton().enabled = true;
		}
	}
	
}