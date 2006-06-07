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

import org.as2lib.sample.pizza.view.View;
import org.aswing.JFrame;
import org.aswing.JLabel;
import org.aswing.JPanel;
import org.aswing.JProgressBar;
import org.aswing.WindowLayout;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.view.aswing.AsWingView extends View {

	private var view:JFrame = null;
	private var orderForm:JPanel = null;
	private var viewOrdersForm:JPanel = null;
	private var progressBar:JProgressBar = null;
	private var statusLabel:JLabel = null;

	public function AsWingView(Void) {
	}

	public function showOrderForm(Void):Void {
		view.remove(viewOrdersForm);
		view.append(orderForm, WindowLayout.CONTENT);
	}

	public function showViewOrdersForm(Void):Void {
		super.showViewOrdersForm();
		view.remove(orderForm);
		view.append(viewOrdersForm, WindowLayout.CONTENT);
	}

	private function setStatusMessage(message:String):Void {
		statusLabel.setText(message);
	}

	private function hideProgressBar(Void):Void {
		progressBar.setVisible(false);
	}

	private function showProgressBar(Void):Void {
		progressBar.setVisible(true);
	}

}