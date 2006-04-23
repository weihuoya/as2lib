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

import org.as2lib.sample.chat.Chat;
import org.aswing.JFrame;
import org.aswing.JTextField;

import it.gotoandplay.smartfoxserver.SmartFoxClient;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.chat.EnterPasswordWindow extends JFrame {
	
	private var smartFoxClient:SmartFoxClient = null;
	private var passwordTextField:JTextField = null;
	private var roomId:Number = null;
	
	public function EnterPasswordWindow(Void) {
	}
	
	public function setRoomId(roomId:Number):Void {
		this.roomId = roomId;
	}
	
	public function enterRoom(Void):Void {
		var password:String = passwordTextField.getText();
		if (password != "") {
			smartFoxClient.joinRoom(roomId, password);
			cancel();
		}
	}
	
	public function enterRoomOnEnter(Void):Void {
		if (Key.getCode() == Key.ENTER) {
			enterRoom();
		}
	}
	
	public function cancel(Void):Void {
		passwordTextField.setText("");
		roomId = null;
		hide();
	}
	
}