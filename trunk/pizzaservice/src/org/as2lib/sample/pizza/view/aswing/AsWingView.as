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
import org.as2lib.context.event.ErrorEvent;
import org.as2lib.context.event.SuccessEvent;
import org.as2lib.context.MessageSource;
import org.as2lib.context.MessageSourceAware;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderPlacedEvent;
import org.aswing.JFrame;
import org.aswing.JLabel;
import org.aswing.JPanel;
import org.aswing.JProgressBar;
import org.aswing.WindowLayout;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.aswing.AsWingView extends JFrame implements ApplicationListener, MessageSourceAware {
	
	private var messageSource:MessageSource = null;
	private var controller:Controller = null;
	private var orderForm:JPanel = null;
	private var viewOrdersForm:JPanel = null;
	private var progressBar:JProgressBar = null;
	private var statusLabel:JLabel = null;
	
	public function AsWingView(Void) {
	}
	
	public function setMessageSource(messageSource:MessageSource):Void {
		this.messageSource = messageSource;
	}
	
	public function show(Void):Void {
		showOrderForm();
		super.show();
	}
	
	public function showOrderForm(Void):Void {
		remove(viewOrdersForm);
		append(orderForm, WindowLayout.CONTENT);
	}
	
	public function showViewOrdersForm(Void):Void {
		progressBar.setVisible(true);
		controller.loadOrders();
		remove(orderForm);
		append(viewOrdersForm, WindowLayout.CONTENT);
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof ErrorEvent) {
			var errorCode:String = ErrorEvent(event).getErrorCode();
			if (errorCode != null) {
				var message:String = messageSource.getMessage(errorCode);
				statusLabel.setText(message);
			}
			progressBar.setVisible(false);
			return;
		}
		if (event instanceof OrderPlacedEvent) {
			showViewOrdersForm();
		}
		if (event instanceof SuccessEvent) {
			var successCode:String = SuccessEvent(event).getSuccessCode();
			if (successCode != null) {
				var message:String = messageSource.getMessage(successCode);
				statusLabel.setText(message);
			}
			return;
		}
	}
	
}