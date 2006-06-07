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

import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.sample.pizza.view.View;

import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.ProgressBar;
import com.asual.enflash.ui.SplitPane;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.enflash.EnFlashView extends View {

	private var progressBar:ProgressBar = null;
	private var statusLabel:Label = null;

	public function EnFlashView(Void) {
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
		super.showViewOrdersForm();
		var contentSplitPane:SplitPane = getContentSplitPane();
		if (contentSplitPane.collapsed == true) {
			toggleContentSplitPane(contentSplitPane);
		}
	}

	private function toggleContentSplitPane(contentSplitPane:SplitPane):Void {
		contentSplitPane.collapsed = !contentSplitPane.collapsed;
		contentSplitPane.setSize(contentSplitPane.w, contentSplitPane.h);
	}

	private function setStatusMessage(message:String):Void {
		statusLabel.value = message;
	}

	private function hideProgressBar(Void):Void {
		progressBar.visible = false;
	}

	private function showProgressBar(Void):Void {
		progressBar.visible = true;
	}

}