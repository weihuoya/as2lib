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
class org.as2lib.sample.chat.NewRoomWindow extends JFrame {
	
	public static var DEFAULT_MAX_USERS:Number = 25;
	
	private var smartFoxClient:SmartFoxClient = null;
	
	private var nameTextField:JTextField = null;
	private var passwordTextField:JTextField = null;
	private var maxUsersTextField:JTextField = null;
	
	public function NewRoomWindow(Void) {
	}
	
	public function createRoom(Void):Void {
		var room:Object = new Object();
		room.name = nameTextField.getText();
		room.password = passwordTextField.getText();
		room.maxUsers = maxUsersTextField.getText();
		smartFoxClient.createRoom(room);
		hide();
		nameTextField.setText("");
		passwordTextField.setText("");
		maxUsersTextField.setText(DEFAULT_MAX_USERS.toString());
	}
	
	public function cancel(Void):Void {
		hide();
	}
	
}