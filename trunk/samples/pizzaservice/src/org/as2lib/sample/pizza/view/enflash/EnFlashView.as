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
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.sample.pizza.control.Controller;
import org.as2lib.sample.pizza.event.OrderPlacedEvent;

import com.asual.enflash.EnFlashConfiguration;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.ProgressBar;
import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.SplitPane;
import com.asual.enflash.ui.UI;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.enflash.EnFlashView extends BasicClass implements
		ApplicationListener, MessageSourceAware {
	
	private var messageSource:MessageSource = null;
	private var controller:Controller = null;
	private var progressBar:ProgressBar = null;
	private var statusLabel:Label = null;
	
	public function EnFlashView(Void) {
	}
	
	public function setMessageSource(messageSource:MessageSource):Void {
		this.messageSource = messageSource;
	}
	
	public function getContentSplitPane(Void):SplitPane {
		throw new AbstractOperationException("Implementation must be provided by sub-class or " +
				"IoC container.", this, arguments);
		return null;
	}
	
	public function showOrderForm(Void):Void {
		var contentSplitPane:SplitPane = getContentSplitPane();
		if (contentSplitPane.collapsed == false) {
			toggleContentSplitPane(contentSplitPane);
		}
	}
	
	public function showViewOrdersForm(Void):Void {
		progressBar.visible = true;
		controller.loadOrders();
		var contentSplitPane:SplitPane = getContentSplitPane();
		if (contentSplitPane.collapsed == true) {
			toggleContentSplitPane(contentSplitPane);
		}
	}
	
	private function toggleContentSplitPane(contentSplitPane:SplitPane):Void {
		contentSplitPane.collapsed = !contentSplitPane.collapsed;
		contentSplitPane.setSize(contentSplitPane.w, contentSplitPane.h);
	}
	
	public function onApplicationEvent(event:ApplicationEvent):Void {
		if (event instanceof ErrorEvent) {
			var errorCode:String = ErrorEvent(event).getErrorCode();
			if (errorCode != null) {
				var message:String = messageSource.getMessage(errorCode);
				statusLabel.value = message;
			}
			progressBar.visible = false;
			return;
		}
		if (event instanceof OrderPlacedEvent) {
			showViewOrdersForm();
		}
		if (event instanceof SuccessEvent) {
			var successCode:String = SuccessEvent(event).getSuccessCode();
			if (successCode != null) {
				var message:String = messageSource.getMessage(successCode);
				statusLabel.value = message;
			}
			return;
		}
	}
	
}