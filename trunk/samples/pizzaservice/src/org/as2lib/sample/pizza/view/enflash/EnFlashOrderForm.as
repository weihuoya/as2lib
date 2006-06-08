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

import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.ComboBox;
import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.ListItem;
import com.asual.enflash.ui.ProgressBar;
import com.asual.enflash.ui.TextInput;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.enflash.EnFlashOrderForm extends OrderForm {

	public function EnFlashOrderForm(Void) {
	}

	private function getName(Void):String {
		return getNameTextInput().value;
	}

	private function getQuantity(Void):Number {
		// TODO If quantity text field is changed, style information in xml format is applied to value.
		return Number(getQuantityTextInput().value);
	}

	private function getSize(Void):String {
		return getSizeComboBox().selectedItem.value;
	}

	private function getCrust(Void):String {
		return getCrustComboBox().selectedItem.value;
	}

	private function getToppings(Void):Array {
		return [getToppingList().selectedItem.value];
	}

	private function showProgressBar(Void):Void {
		getProgressBar().visible = true;
	}

	private function enablePlaceOrderButton(Void):Void {
		getPlaceOrderButton().enabled = true;
	}

	private function disablePlaceOrderButton(Void):Void {
		getPlaceOrderButton().enabled = false;
	}

	private function enableAddButton(Void):Void {
		getAddButton().enabled = true;
	}

	private function disableAddButton(Void):Void {
		getAddButton().enabled = false;
	}

	private function enableRemoveButton(Void):Void {
		getRemoveButton().enabled = true;
	}

	private function disableRemoveButton(Void):Void {
		getRemoveButton().enabled = false;
	}

	private function getOrderTicketCount(Void):Number {
		return getOrderTicketList()["_content"].length;
	}

	private function getSelectedOrderTicketIndices(Void):Array {
		return [getOrderTicketList().selectedIndex];
	}

	private function addOrderTicket(orderTicket:String):Void {
		var orderTicketList:ListBox = getOrderTicketList();
		var listItem:ListItem = orderTicketList.addItem();
		listItem.value = orderTicket;
		orderTicketList.selectedIndex = orderTicketList["_content"].length - 1;
	}

	private function removeOrderTickets(orderTicketIndices:Array):Void {
		if (orderTicketIndices != null) {
			getOrderTicketList().removeItemAt(orderTicketIndices[0]);
		}
		else {
			getOrderTicketList().removeAll();
		}
	}

	private function selectOrderTicket(orderTicketIndex:Number):Void {
		getOrderTicketList().selectedIndex = orderTicketIndex;
	}

	private function isToppingSelected(Void):Boolean {
		return (getToppingList().selectedIndex != -1);
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

}