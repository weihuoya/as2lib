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

import org.as2lib.context.MessageSource;
import org.as2lib.context.MessageSourceAware;
import org.as2lib.env.reflect.Delegate;
import org.as2lib.sample.chat.Chat;
import org.aswing.JButton;
import org.aswing.JPanel;
import org.aswing.JTextField;
import org.aswing.JWindow;

import it.gotoandplay.smartfoxserver.SmartFoxClient;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.chat.Login extends JWindow implements MessageSourceAware {
	
	private var ip:String = null;
	private var port:Number = null;
	private var zone:String = null;
	private var smartFoxClient:SmartFoxClient = null;
	
	private var loginPanel:JPanel = null;
	private var userNameTextField:JTextField = null;
	private var statusTextField:JTextField = null;
	private var submitButton:JButton = null;
	private var clearButton:JButton = null;
	
	private var chat:Chat = null;
	private var messageSource:MessageSource;
	
	public function Login(Void) {
	}
	
	public function setMessageSource(messageSource:MessageSource):Void {
		this.messageSource = messageSource;
	}
	
	public function init(Void):Void {
		smartFoxClient.connect(ip, port);
		smartFoxClient.onConnection = Delegate.create(this, onConnection);
		smartFoxClient.onConnectionLost = Delegate.create(this, onConnectionLost);
		smartFoxClient.onLogin = Delegate.create(this, onLogin);
	}
	
	private function onConnection(success:Boolean):Void {
		if (success) {
			statusTextField.setText(messageSource.getMessage("status.connected"));
			loginPanel.setVisible(true);
		}
		else {
			statusTextField.setText(messageSource.getMessage("status.cantConnect"));
		}
	}
	
	private function onConnectionLost(Void):Void {
		statusTextField.setText(messageSource.getMessage("status.connecting"));
		loginPanel.setVisible(false);
		smartFoxClient.connect(ip, port);
		setVisible(true);
		chat.hide();
	}
	
	private function onLogin(result:Object):Void {
		if (result.success) {
			setVisible(false);
			var userName:String = userNameTextField.getText();
			chat.setUserName(userName);
			chat.show();
		}
		else {
			userNameTextField.setEnabled(true);
			var message:String = messageSource.getMessage("error.login", [result.error]);
			statusTextField.setText(message);
		}
	}
	
	public function onUserNameChanged(Void):Void {
		if (userNameTextField.getText() == "") {
			submitButton.setEnabled(false);
			clearButton.setEnabled(false);
		}
		else {
			submitButton.setEnabled(true);
			clearButton.setEnabled(true);
		}
	}
	
	public function submit(Void):Void {
		userNameTextField.setEnabled(false);
		var userName:String = userNameTextField.getText();
		smartFoxClient.login(zone, userName);
	}
	
	public function submitOnEnter(Void):Void {
		if (Key.getCode() == Key.ENTER) {
			submit();
		}
	}
	
	public function clear(Void):Void {
		userNameTextField.setText("");
		onUserNameChanged();
	}
	
	public function getUserName(Void):String {
		return userNameTextField.getText();
	}
	
}