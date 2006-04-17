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

import org.actionstep.ASLabel;
import org.actionstep.NSFont;
import org.actionstep.NSProgressIndicator;
import org.actionstep.NSView;
import org.as2lib.context.ApplicationEvent;
import org.as2lib.context.ApplicationListener;
import org.as2lib.context.event.ErrorEvent;
import org.as2lib.context.event.SuccessEvent;
import org.as2lib.context.MessageSource;
import org.as2lib.context.MessageSourceAware;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderPlacedEvent;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.actionstep.ActionStepView extends NSView implements ApplicationListener, MessageSourceAware {
	
	private var messageSource:MessageSource = null;
	private var controller:Controller = null;
	private var orderForm:NSView = null;
	private var viewOrdersForm:NSView = null;
	private var progressBar:NSProgressIndicator = null;
	private var statusText:ASLabel = null;
	
	public function ActionStepView(Void) {
	}
	
	public function setMessageSource(messageSource:MessageSource):Void {
		this.messageSource = messageSource;
	}
	
	public function init(Void):Void {
		addSubview(orderForm);
		addSubview(viewOrdersForm);
	}
	
	public function showOrderForm(Void):Void {
		viewOrdersForm.setHidden(true);
		orderForm.setHidden(false);
	}
	
	public function showViewOrdersForm(Void):Void {
		progressBar.setHidden(false);
		controller.loadOrders();
		orderForm.setHidden(true);
		viewOrdersForm.setHidden(false);
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof ErrorEvent) {
			var errorCode:String = ErrorEvent(event).getErrorCode();
			if (errorCode != null) {
				var message:String = messageSource.getMessage(errorCode);
				statusText.setStringValue(message);
			}
			progressBar.setHidden(true);
			return;
		}
		if (event instanceof OrderPlacedEvent) {
			showViewOrdersForm();
		}
		if (event instanceof SuccessEvent) {
			var successCode:String = SuccessEvent(event).getSuccessCode();
			if (successCode != null) {
				var message:String = messageSource.getMessage(successCode);
				statusText.setStringValue(message);
			}
			return;
		}
	}
	
}