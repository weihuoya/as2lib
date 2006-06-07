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
import org.actionstep.NSProgressIndicator;
import org.actionstep.NSView;
import org.as2lib.sample.pizza.view.View;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.actionstep.ActionStepView extends View {

	private var orderForm:NSView = null;
	private var viewOrdersForm:NSView = null;
	private var progressBar:NSProgressIndicator = null;
	private var statusText:ASLabel = null;

	public function ActionStepView(Void) {
	}

	public function showOrderForm(Void):Void {
		viewOrdersForm.setHidden(true);
		orderForm.setHidden(false);
	}

	public function showViewOrdersForm(Void):Void {
		super.showViewOrdersForm();
		orderForm.setHidden(true);
		viewOrdersForm.setHidden(false);
	}

	private function setStatusMessage(message:String):Void {
		statusText.setStringValue(message);
	}

	private function hideProgressBar(Void):Void {
		progressBar.setHidden(true);
	}

	private function showProgressBar(Void):Void {
		progressBar.setHidden(false);
	}

}