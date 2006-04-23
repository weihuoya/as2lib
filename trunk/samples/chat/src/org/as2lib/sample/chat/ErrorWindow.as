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

import org.aswing.JFrame;
import org.aswing.JLabel;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.chat.ErrorWindow extends JFrame {
	
	private var message:String = null;
	private var messageLabel:JLabel = null;
	
	public function ErrorWindow(Void) {
	}
	
	public function setMessage(message:String):Void {
		this.message = message;
	}
	
	public function show(Void):Void {
		messageLabel.setText(message);
		super.show();
	}
	
	public function hide(Void):Void {
		messageLabel.setText("");
		message = null;
		super.hide();
	}
	
}