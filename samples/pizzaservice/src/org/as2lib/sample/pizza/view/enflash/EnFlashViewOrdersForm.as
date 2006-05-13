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
import org.as2lib.core.BasicClass;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderCanceledEvent;
import org.as2lib.sample.pizza.event.OrdersLoadedEvent;

import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.ListItem;
import com.asual.enflash.ui.ProgressBar;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.enflash.EnFlashViewOrdersForm extends BasicClass implements
		ApplicationListener {
	
	private var controller:Controller = null;
	
	public function EnFlashViewOrdersForm(Void) {
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
	
	public function cancelOrder(Void):Void {
		getProgressBar().visible = true;
		controller.cancelOrder(getOrderList().selectedIndex);
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrdersLoadedEvent) {
			updateOrders();
			getProgressBar().visible = false;
			return;
		}
		if (event instanceof OrderCanceledEvent) {
			controller.loadOrders();
			return;
		}
	}
	
	private function updateOrders(Void):Void {
		var orderList:ListBox = getOrderList();
		orderList.removeAll();
		var orderNames:Array = controller.getOrderNames();
		for (var i:Number = 0; i < orderNames.length; i++) {
			var item:ListItem = orderList.addItem();
			item.value = orderNames[i];
		}
		if (orderNames.length > 0) {
			orderList.selectedIndex = 0;
			getCancelOrderButton().enabled = true;
		}
		else {
			getCancelOrderButton().enabled = false;
		}
		updatePizzas();
	}
	
	public function updatePizzas(Void):Void {
		var orderIndex:Number = getOrderList().selectedIndex;
		var pizzaList:ListBox = getPizzaList();
		pizzaList.removeAll();
		if (orderIndex > -1) {
			var pizzaDetails:Array = controller.getPizzaDetails(orderIndex);
			for (var i:Number = 0; i < pizzaDetails.length; i++) {
				var item:ListItem = pizzaList.addItem();
				item.value = pizzaDetails[i];
			}
		}
	}
	
}