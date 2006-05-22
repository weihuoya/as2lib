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
import org.as2lib.sample.chat.EnterPasswordWindow;
import org.as2lib.sample.chat.ErrorWindow;
import org.as2lib.sample.chat.NewRoomWindow;
import org.as2lib.sample.chat.SendPrivateMessageWindow;
import org.aswing.JList;
import org.aswing.JTextArea;
import org.aswing.JTextField;
import org.aswing.JWindow;
import org.aswing.VectorListModel;

import it.gotoandplay.smartfoxserver.Room;
import it.gotoandplay.smartfoxserver.SmartFoxClient;
import it.gotoandplay.smartfoxserver.User;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.chat.Chat extends JWindow implements MessageSourceAware {
	
	private var smartFoxClient:SmartFoxClient = null;
	
	private var chatTextArea:JTextArea = null;
	private var messageTextField:JTextField = null;
	private var roomList:JList = null;
	private var roomVectorListModel:VectorListModel = null;
	private var userList:JList = null;
	private var userVectorListModel:VectorListModel = null;
	
	private var userName:String = null;
	private var newRoomWindow:NewRoomWindow = null;
	private var enterPasswordWindow:EnterPasswordWindow = null;
	private var sendPrivateMessageWindow:SendPrivateMessageWindow = null;
	private var errorWindow:ErrorWindow = null;
	
	private var messageSource:MessageSource = null;
	
	public function Chat(Void) {
	}
	
	public function setMessageSource(messageSource:MessageSource):Void {
		this.messageSource = messageSource;
	}
	
	public function init(Void):Void {
		// TODO: Find proper solution for this workaround.
		newRoomWindow["owner"] = this;
		enterPasswordWindow["owner"] = this;
		sendPrivateMessageWindow["owner"] = this;
		errorWindow["owner"] = this;
		smartFoxClient.onRoomListUpdate = Delegate.create(this, onRoomListUpdate);
		smartFoxClient.onJoinRoom = Delegate.create(this, onJoinRoom);
		smartFoxClient.onJoinRoomError = Delegate.create(this, onJoinRoomError);
		smartFoxClient.onUserCountChange = Delegate.create(this, updateRoomStatus);
		smartFoxClient.onUserEnterRoom = Delegate.create(this, onUserEnterRoom);
		smartFoxClient.onUserLeaveRoom = Delegate.create(this, onUserLeaveRoom);
		smartFoxClient.onUserCountChange = Delegate.create(this, onUserCountChange);
		smartFoxClient.onPublicMessage = Delegate.create(this, onPublicMessage);
		smartFoxClient.onPrivateMessage = Delegate.create(this, onPrivateMessage);
		smartFoxClient.onRoomAdded = Delegate.create(this, onRoomAdded);
		smartFoxClient.onRoomDeleted = Delegate.create(this, onRoomDeleted);
		smartFoxClient.onCreateRoomError = Delegate.create(this, onCreateRoomError);
	}
	
	public function setUserName(userName:String):Void {
		this.userName = userName;
	}
	
	public function show(Void):Void {
		setVisible(true);
		super.show();
	}
	
	public function hide(Void):Void {
		setVisible(false);
		super.hide();
	}
	
	public function selectUser(Void):Void {
		var user:User = User(userList.getSelectedValue());
		var userId:Number = user.getId();
		if (smartFoxClient.myUserId != userId) {
			sendPrivateMessageWindow.setUserId(userId);
			sendPrivateMessageWindow.show();
		}
	}
	
	public function changeRoom(Void):Void {
		var room:Room = Room(roomList.getSelectedValue());
		var roomId:Number = room.getId();
		if (roomId != smartFoxClient.activeRoomId) {
			if (room.isPrivate()) {
				enterPasswordWindow.setRoomId(roomId);
				enterPasswordWindow.show();
			}
			else {
				smartFoxClient.joinRoom(roomId);
			}
		}
	}
	
	private function updateRoomStatus(roomId:Number):Void {
		var room:Room = smartFoxClient.getRoom(roomId);
		for (var i:Number = 0; i < roomVectorListModel.getSize(); i++) {
			var oldRoom:Room = Room(roomVectorListModel.get(i));
			if (oldRoom.getId() == roomId) {
				roomVectorListModel.replaceAt(i, room);
				break;
			}
		}
	}
	
	private function onRoomListUpdate(roomList:Object):Void {
		roomVectorListModel.clear();
		for (var i:String in roomList) {
			roomVectorListModel.append(roomList[i]);
		}
		smartFoxClient.autoJoin();
	}
	
	private function onJoinRoom(room:Room):Void {
		selectRoom(room.getId());
		userVectorListModel.clear();
		var userList:Object = room.getUserList();
		for (var name:String in userList) {
			var user:User = userList[name];
			userVectorListModel.append(user);
		}
		addMessage(messageSource.getMessage("message.joinedRoom", [room.getName()]));
	}
	
	private function onJoinRoomError(errorMessage:String):Void {
		errorWindow.setMessage(errorMessage);
		errorWindow.show();
		selectRoom(smartFoxClient.activeRoomId);
	}
	
	private function selectRoom(roomId:Number):Void {
		for (var i:Number = 0; i < roomVectorListModel.getSize(); i++) {
			var room:Room = Room(roomVectorListModel.get(i));
			if (room.getId() == roomId) {
				roomList.setSelectedIndex(i);
			}
		}
	}
	
	private function onUserEnterRoom(fromRoomId:Number, user:User):Void {
		userVectorListModel.append(user);
		updateRoomStatus(fromRoomId);
		addMessage(messageSource.getMessage("message.userEnteredRoom", [user.getName()]));
	}
	
	private function onUserLeaveRoom(fromRoomId:Number, userId:Number):Void {
		var userName:String;
		for (var i = 0; i < userVectorListModel.getSize(); i++) {
			var user:User = User(userVectorListModel.get(i));
			if (user.getId() == userId) {
				userName = user.getName();
				userVectorListModel.removeAt(i);
				break;
			}
		}
		updateRoomStatus(fromRoomId);
		addMessage(messageSource.getMessage("message.userLeftRoom", [userName]));
	}
	
	private function onUserCountChange(room:Room):Void {
		updateRoomStatus(room.getId());
	}
	
	private function onPublicMessage(message:String, user:User):Void {
		addMessage(messageSource.getMessage("message.public", [user.getName(), message]));
	}
	
	private function onPrivateMessage(message:String, user:User):Void {
		addMessage(messageSource.getMessage("message.private", [user.getName(), message]));
	}
	
	private function onRoomAdded(room:Room):Void {
		roomVectorListModel.append(room);
	}
	
	private function onRoomDeleted(room:Room):Void {
		for (var i:Number = 0; i < roomVectorListModel.getSize(); i++) {
			var tempRoom:Room = Room(roomVectorListModel.get(i));
			if (tempRoom.getId() == room.getId()) {
				roomVectorListModel.removeAt(i);
				break;
			}
		}
	}
	
	private function onCreateRoomError(errorMessage:String):Void {
		errorWindow.setMessage(errorMessage);
		errorWindow.show();
	}
	
	public function sendMessage(Void):Void {
		var message:String = messageTextField.getText();
		if (message != "") {
			smartFoxClient.sendPublicMessage(message);
			messageTextField.setText("");
		}
	}
	
	public function sendMessageOnEnter(Void):Void {
		if (Key.getCode() == Key.ENTER) {
			sendMessage();
		}
	}
	
	private function addMessage(message:String):Void {
		var previousMessages:String = chatTextArea.getText() + "\n";
		chatTextArea.setText(previousMessages + message);
		chatTextArea.scrollToBottomRight();
	}
	
	private function createRoom(Void):Void {
		newRoomWindow.show();
	}
	
	private function exit(Void):Void {
		smartFoxClient.disconnect();
	}
	
}