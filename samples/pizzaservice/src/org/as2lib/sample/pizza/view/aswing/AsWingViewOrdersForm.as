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
import org.as2lib.sample.pizza.event.OrderCanceledEvent;
import org.as2lib.sample.pizza.event.OrdersLoadedEvent;
import org.aswing.JButton;
import org.aswing.JList;
import org.aswing.JPanel;
import org.aswing.JProgressBar;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.aswing.AsWingViewOrdersForm extends JPanel implements ApplicationListener {
	
	private var controller:Controller = null;
	private var orderList:JList = null;
	private var pizzaList:JList = null;
	private var cancelOrderButton:JButton = null;
	private var progressBar:JProgressBar = null;
	
	public function AsWingViewOrdersForm(Void) {
	}
	
	public function cancelOrder(Void):Void {
		progressBar.setVisible(true);
		var orderIndex:Number = orderList.getSelectedIndex();
		controller.cancelOrder(orderIndex);
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof OrdersLoadedEvent) {
			updateOrders();
			progressBar.setVisible(false);
			return;
		}
		if (event instanceof OrderCanceledEvent) {
			controller.loadOrders();
			return;
		}
	}
	
	private function updateOrders(Void):Void {
		var orderNames:Array = controller.getOrderNames();
		orderList.setListData(orderNames);
		if (orderNames.length > 0) {
			orderList.setSelectedIndex(0);
			cancelOrderButton.setEnabled(true);
		}
		updatePizzas();
	}
	
	public function updatePizzas(Void):Void {
		var orderIndex:Number = orderList.getSelectedIndex();
		var pizzas:Array;
		if (orderIndex > -1) {
			pizzas = controller.getPizzaDetails(orderIndex);
		}
		pizzaList.setListData(pizzas);
	}
	
}