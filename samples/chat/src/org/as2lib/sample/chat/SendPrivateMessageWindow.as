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
import org.aswing.JTextField;

import it.gotoandplay.smartfoxserver.SmartFoxClient;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.chat.SendPrivateMessageWindow extends JFrame {
	
	private var smartFoxClient:SmartFoxClient = null;
	private var messageTextField:JTextField = null;
	private var userId:Number = null;
	
	public function SendPrivateMessageWindow(Void) {
	}
	
	public function setUserId(userId:Number):Void {
		this.userId = userId;
	}
	
	public function sendMessage(Void):Void {
		var message:String = messageTextField.getText();
		if (message != "") {
			smartFoxClient.sendPrivateMessage(message, userId);
			cancel();
		}
	}
	
	public function sendMessageOnEnter(Void):Void {
		if (Key.getCode() == Key.ENTER) {
			sendMessage();
		}
	}
	
	public function cancel(Void):Void {
		messageTextField.setText("");
		userId = null;
		hide();
	}
	
}