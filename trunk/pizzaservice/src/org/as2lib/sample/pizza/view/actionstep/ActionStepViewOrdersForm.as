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
import org.actionstep.NSView;
import org.as2lib.context.ApplicationEvent;
import org.as2lib.context.ApplicationListener;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderCanceledEvent;
import org.as2lib.sample.pizza.event.OrdersLoadedEvent;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.actionstep.ActionStepViewOrdersForm extends NSView implements ApplicationListener {
	
	private var controller:Controller = null;
	private var orderList:ASList = null;
	private var pizzaList:ASList = null;
	private var cancelOrderButton:NSButton = null;
	private var progressBar:NSProgressIndicator = null;
	
	public function ActionStepViewOrdersForm(Void) {
	}
	
	public function cancelOrder(Void):Void {
		progressBar.setHidden(false);
		var orderIndex:Number = getSelectedIndex();
		controller.cancelOrder(orderIndex);
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrdersLoadedEvent) {
			updateOrders();
			progressBar.setHidden(true);
			return;
		}
		if (event instanceof OrderCanceledEvent) {
			controller.loadOrders();
			return;
		}
	}
	
	private function updateOrders(Void):Void {
		var orderNames:Array = controller.getOrderNames();
		orderList.setItems(toListItems(orderNames));
		if (orderNames.length > 0) {
			orderList.selectItemAtIndex(0);
			cancelOrderButton.setEnabled(true);
		}
		updatePizzas();
	}
	
	public function updatePizzas(Void):Void {
		var orderIndex:Number = getSelectedIndex();
		if (orderIndex > -1) {
			var pizzas:Array = controller.getPizzaDetails(orderIndex);
			pizzaList.setItems(toListItems(pizzas));
			if (!cancelOrderButton.isEnabled()) {
				cancelOrderButton.setEnabled(true);
			}
		}
		else {
			cancelOrderButton.setEnabled(false);
			pizzaList.removeAllItems();
		}
	}
	
	private function toListItems(itemNames:Array):NSArray {
		var result:NSArray = new NSArray();
		for (var i:Number = 0; i < itemNames.length; i++) {
			var name:String = itemNames[i];
			var item:ASListItem = new ASListItem();
			item.initWithLabelData(name, null);
			result.addObject(item);
		}
		return result;
	}
	
	private function getSelectedIndex(Void):Number {
		var items:Array = orderList.items().internalList();
		for (var i:Number = 0; i < items.length; i++) {
			var item:ASListItem = items[i];
			if (item.isSelected()) {
				return i;
			}
		}
		return -1;
	}
	
}