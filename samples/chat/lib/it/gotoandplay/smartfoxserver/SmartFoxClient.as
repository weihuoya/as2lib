/**
* 
*	SmartFoxClient API
*	Actionscript 2.0 Client API
*
*	ver 0.8.0 -- November 25th, 2004
*
*	(c) gotoAndPlay --- www.gotoandplay.it
*	
*	--------------------------------------------------------------------------------------------------------------
*	
*/

class it.gotoandplay.smartfoxserver.SmartFoxClient extends XMLSocket
{
	private var objRef:Object;
	private var t1:Number, t2:Number;
	private var isConnected:Boolean;
	private var changingRoom:Boolean;	
	private var majVersion:Number = 0;
	private var minVersion:Number = 8;
	private var subVersion:Number = 0;
	
	private var arrayTags:Object;
	private var messageHandlers:Object;
	private var os:it.gotoandplay.smartfoxserver.ObjectSerializer;

	public var roomList:Object;
	public var activeRoomId:Number;
	public var myUserId:Number;
	public var myUserName:String;
	public var debug:Boolean;
	public var playerId:Number;
	
	public var evtHandler:Object;
	
	// Event handlers methods
	public var onConnectionLost:Function;
	public var onCreateRoomError:Function;
	private var onConnect:Function;
	public var onConnection:Function;
	public var onJoinRoom:Function;
	public var onJoinRoomError:Function;
	public var onLogin:Function;
	public var onObjectReceived:Function;
	public var onPublicMessage:Function;
	public var onPrivateMessage:Function;
	public var onRoomAdded:Function;
	public var onRoomDeleted:Function;
	public var onRoomListUpdate:Function;	
	public var onRoomVariablesUpdate:Function;
	public var onRoundTripResponse:Function;
	public var onUserCountChange:Function;
	public var onUserEnterRoom:Function;
	public var onUserLeaveRoom:Function;
	public var onUserVariablesUpdate:Function;
	
	
	
	//-----------------------------------------------------------------------------------//
	// Class constructor
	//-----------------------------------------------------------------------------------//
	function SmartFoxClient(objRef:Object)
	{
		super();
		
		// Object Reference:
		// optional param to keep a reference to a parent object
		this.objRef 		= objRef;
		this.os 		= it.gotoandplay.smartfoxserver.ObjectSerializer.getInstance();
	
		// Server XMLSocket
		this.roomList		= new Object();
		
		// The currently active room
		this.activeRoomId	= null;
		this.myUserId		= null;
		this.myUserName		= "";
		this.playerId		= null;
		this.debug 		= false;
		
		this.isConnected 	= false;
		this.changingRoom	= false;
		
		// Array of tag names that should transformed in arrays by the messag2Object method
		this.arrayTags		= { userList:true, rmList:true, vars:true };
	
		// Message Handlers
		this.messageHandlers 	= new Object();
		
		
		// Override default XMLSocket methods
		onConnect 	= connectionEstablished;
		onData  	= gotData;
		onXML   	= xmlReceived;
		onClose 	= connectionClosed;
		
		setupMessageHandlers();		
	}
	
	
	
	//-----------------------------------------------------------------------------------//
	// Setup the core message handlers
	//-----------------------------------------------------------------------------------//
	private function setupMessageHandlers()
	{
		addMessageHandler("sys", this.handleSysMessages);
	}
	
	
	
	//-----------------------------------------------------------------------------------//
	// Add more MessageHanlders to the MessageHandler collection
	// All MessageHandlers object must implement a handleMessage() method
	//-----------------------------------------------------------------------------------//
	private function addMessageHandler(handlerId:String, handlerMethod:Function)
	{
		// Add the new handler only if it does not exist already
		if (this.messageHandlers[handlerId] == undefined)
		{
			this.messageHandlers[handlerId] = new Object();
			this.messageHandlers[handlerId].handleMessage = handlerMethod;
		}
		else
		{
			trace("Warning: [" + handlerId + "] handler could not be created. A handler with this name already exist!");
		}
	
	}
	
	
	
	//-----------------------------------------------------------------------------------//
	// System Messages Handler
	//-----------------------------------------------------------------------------------//
	private function handleSysMessages(xmlObj:Object, scope:Object)
	{
		// get "action" and "r" attributes
		var action:String		= xmlObj.attributes.action;
		var fromRoom			= xmlObj.attributes.r;
		
		/*
		if (scope.debug)
			trace("[ sysHandler action: " + action + ", from room: " + fromRoom + " ]" + newline)
		*/
		
		// Connection Handler
		// The client app must implement the onLoad(obj)
		//
		// The passed object contains 3 properties
		// success 	= boolean, tells if user was logged in succesfully
		// name		= user name
		// error	= if not logged, this will contain the error message
		//
		
		// logOK => login successfull
		if (action == "apiOK")
		{
			scope.onConnection(true);
		}
		else if (action == "apiKO")
		{
			scope.onConnection(false);
			trace("--------------------------------------------------------");
			trace(" WARNING! The API you are using are not compatible with ");
			trace(" the SmartFoxServer you're trying to connect to");
			trace("--------------------------------------------------------");
		}
		else if (action == "logOK")
		{
			// store the uid that was assigned by the server
			scope.myUserId 	= xmlObj.login.attributes.id;
			scope.myUserName = xmlObj.login.attributes.n;

			scope.onLogin({success:true, name:scope.myUserName, error:""});
	
			// autoget RoomList
			scope.getRoomList();
		}
		
		// logKO => login failed
		else if (action == "logKO")
		{
			var errorMsg = xmlObj.login.attributes.e;
			scope.onLogin({success:false, name:"", error: errorMsg});
		}
		
		// rmList => list of active rooms coming from server
		else if (action == "rmList")
		{
			var roomList = xmlObj.rmList.rmList;
	
			// Pack data into a simpler format
			scope.roomList = new Array();
	
			for (var i:String in roomList)
			{
				// get ID for curr room
				var currRoomId = roomList[i].attributes.id;
				
				// Grab Room Data
				var serverData = roomList[i].attributes;
				
				var id 		= serverData.id;
				var name 	= roomList[i].n.value;
				var maxUsers 	= Number(serverData.max);
				var isTemp 	= (serverData.temp) ? true : false;
				var isGame 	= (serverData.game) ? true : false;
				var isPrivate	= (serverData.priv) ? true : false;
				var userCount	= Number(serverData.ucnt);
				
				scope.roomList[currRoomId] = new it.gotoandplay.smartfoxserver.Room(id, name, maxUsers, isTemp, isGame, isPrivate);
				scope.roomList[currRoomId].userCount = userCount;
				
				// Point to the <vars></vars> node
				var roomVars = roomList[i].vars.vars;
	
				// Generate Room Variables
				// Cycle through all variables in the XML
				// and recreate them in the room casting them to the right datatype
				for (var j = 0; j < roomVars.length; j++)
				{
					var vName = roomVars[j].attributes.n; 
					var vType = roomVars[j].attributes.t;
					var vVal  = roomVars[j].value;
					
					var fn = null;
					// Dynamically cast the variable value to its original datatype
					if (vType == "b")
						fn = Boolean;
					else if (vType == "n")
						fn = Number;
					else if (vType == "s")
						fn = String;
					else if (vType== "x")
						fn = function(n) { return null; };
					
					scope.roomList[currRoomId].variables[vName] = fn(vVal);
					
					//trace("var: " + vName + " = " + vVal)
				}
			}
	
			// Fire event
			scope.onRoomListUpdate(scope.roomList);
		}
		
		// joinOK => room joined succesfully
		else if (action == "joinOK")
		{
			//this.xmlObj 	= xmlObj
			var roomId 	= xmlObj.userList.attributes.r;
			var userList 	= xmlObj.userList.userList;
			
			//
			// Set as the activeRoom the last joined room
			// -------------------------------------------
			// NOTE:
			// Since multiple room join is allowed the app. developer
			// has to specify the room in which the action takes place 
			// if it is different from the activeRoomId
			//
			scope.activeRoomId = Number(roomId);
	
			// get current Room and populates usrList
			var currRoom	= scope.roomList[roomId];
	
			currRoom.userList = new Object();
			
			// Get the playerId
			// -1 = no game room
			scope.playerId = xmlObj.pid.attributes.id;
			
			// Populate Room userList
			for (var i = 0; i < userList.length; ++i)
			{
				// grab the user properties
				var name = userList[i].attributes.name;
				var id   = userList[i].attributes.id;
	
				// set user Object (id, name ...)
				currRoom.userList[id] = new it.gotoandplay.smartfoxserver.User(id, name);
				
				// Point to the <vars></vars> node
				var userVars = userList[i].vars.vars;
				
				// Setup user variables Object
				currRoom.userList[id].variables = {};
	
				var item = currRoom.userList[id].variables;
				
				// Cycle through all variables in the XML
				// and recreate them in the user casting them to the right datatype
				for (var j = 0; j < userVars.length; j++)
				{
					var vName = userVars[j].attributes.n; 
					var vType = userVars[j].attributes.t;
					var vVal  = userVars[j].value;
					
					var fn = null;
					// Dynamically cast the variable value to its original datatype
					if (vType == "b")
						fn = Boolean;
					else if (vType == "n")
						fn = Number;
					else if (vType == "s")
						fn = String;
					else if (vType== "x")
						fn = function(n) { return null; };
					
					item[vName] = fn(vVal);
					
					//trace("var: " + vName + " = " + vVal)
				}
	
	
			}
			
			scope.changingRoom = false;
	
			// Fire event!
			// Return a Room obj (with its id and name)
			scope.onJoinRoom(scope.roomList[roomId]);
		}
		
		// joinKO => A problem was found when trying to join a room
		else if (action == "joinKO")
		{
			scope.changingRoom = false;
			var error = xmlObj.error.attributes.msg;
			scope.onJoinRoomError(error);
		}
		
		// userEntersRoom => a new user has joined the room
		else if (action == "userEnterRoom")
		{
			// Get user param
			var usrId 	= xmlObj.user.attributes.id;
			var usrName 	= xmlObj.user.attributes.name;
			
			// get current Room and populates usrList
			var currRoom	= scope.roomList[fromRoom];
			
			// add new client
			// 
			// Note:
			// a shortcut would to do 
			// currRoom.usrList[uid] = xmlObj.user.attributes
			//
			// because attributes = {id, name}
			
			currRoom.userList[usrId] = new it.gotoandplay.smartfoxserver.User(usrId, usrName);
			//currRoom.usrCount++;
			
			// Point to the <vars></vars> node
			var userVars = xmlObj.user.vars.vars;
			
			// Setup user variables Object
			currRoom.userList[usrId].variables = {};
	
			var item = currRoom.userList[usrId].variables;
			
			// Cycle through all variables in the XML
			// and recreate them in the user casting them to the right datatype
			for (var j = 0; j < userVars.length; j++)
			{
				var vName = userVars[j].attributes.n; 
				var vType = userVars[j].attributes.t;
				var vVal  = userVars[j].value;
				
				var fn = null;
				// Dynamically cast the variable value to its original datatype
				if (vType == "b")
					fn = Boolean;
				else if (vType == "n")
					fn = Number;
				else if (vType == "s")
					fn = String;
				else if (vType== "x")
					fn = function(n) { return null; };
				
				item[vName] = fn(vVal);
				
				//trace("var: " + vName + " = " + vVal)
			}
			
			scope.onUserEnterRoom(fromRoom, currRoom.userList[usrId]);
		}
		
		// A user has left the room
		else if (action == "userGone")
		{
			//var roomId 	= xmlObj.user.attributes.r
			var usrId 		= xmlObj.user.attributes.id;
			
			// get current Room
			var currRoom		= scope.roomList[fromRoom];
			var usrName		= currRoom.userList[usrId].name;
			
			delete currRoom.userList[usrId];
			
			//currRoom.usrCount--;
			
			// Send name and id to the application
			// because the user entry in the UserList has already been deleted
			
			scope.onUserLeaveRoom(fromRoom, usrId, usrName);
		}
		
		// You have a new public message
		else if (action == "pubMsg")
		{
			// sender id
			var usrId 	= xmlObj.user.attributes.id;
			var textMsg	= xmlObj.txt.value;
			
			
			textMsg		= scope.os.decodeEntities(textMsg.toString());
	
			// fire event 
			scope.onPublicMessage(textMsg.toString(), scope.roomList[fromRoom].userList[usrId]);
		}
		
		// You have a new private message
		else if (action == "prvMsg")
		{
			// sender id
			var usrId 	= xmlObj.user.attributes.id;
			var textMsg	= xmlObj.txt.value;
	
			textMsg		= scope.os.decodeEntities(textMsg);
	
			// fire event 
			scope.onPrivateMessage(textMsg.toString(), scope.roomList[fromRoom].userList[usrId]);
		}
		
		// You have a new AS Object
		else if (action == "dataObj")
		{
			var senderId 	= xmlObj.user.attributes.id;
			var obj		= xmlObj.dataObj.value;
			
			trace("XML: " + obj);
				
			var asObj	= scope.os.deserialize(obj);
			
			trace("GOT OBJECT : " + asObj);
			scope.dumpObj(asObj);
			
			scope.onObjectReceived(asObj, scope.roomList[fromRoom].userList[senderId]);			
		}
		
		// A user has changed his/her variables
		else if (action == "uVarsUpdate")
		{
			var usrId 	= xmlObj.user.attributes.id;
			var variables 	= xmlObj.vars.vars;
	
			var user = scope.roomList[fromRoom].userList[usrId];
			
			if (user.variables == undefined)
				user.variables = {};
			
			for (var j = 0; j < variables.length; j++)
			{
				var vName = variables[j].attributes.n; 
				var vType = variables[j].attributes.t;
				var vVal  = variables[j].value;
				
				var fn = null;
				// Dynamically cast the variable value to its original datatype
				if (vType == "b")
					fn = Boolean;
				else if (vType == "n")
					fn = Number;
				else if (vType == "s")
					fn = String;
				else if (vType== "x")
					fn = function(n) { return null; };
				
				user.variables[vName] = fn(vVal);
				
				//trace("var: " + vName + " = " + vVal)
			}
			
			scope.onUserVariablesUpdate(user);
		}
		
		// Notifies the roomVars update
		else if (action == "rVarsUpdate")
		{
			var variables 	= xmlObj.vars.vars;
			
			var currRoom = scope.roomList[fromRoom];
			
			currRoom.variables = new Object();
			
			for (var j = 0; j < variables.length; j++)
			{
				var vName = variables[j].attributes.n; 
				var vType = variables[j].attributes.t;
				var vVal  = variables[j].value;
				
				var fn = null;
				// Dynamically cast the variable value to its original datatype
				if (vType == "b")
					fn = Boolean;
				else if (vType == "n")
					fn = Number;
				else if (vType == "s")
					fn = String;
				else if (vType== "x")
					fn = function(n) { return null; };
				
				currRoom.variables[vName] = fn(vVal);
				
				//trace("var: " + vName + " = " + vVal)
			}
			
			scope.onRoomVariablesUpdate(currRoom);
		}
		
		// Room Create Request Failed
		else if (action == "createRmKO")
		{
			var errorMsg = xmlObj.room.attributes.e;
			scope.onCreateRoomError(errorMsg);
		}
		
		// Receive and update about the user number in the other rooms
		else if (action == "uCount")
		{
			var count = xmlObj.attributes.c;
			var room = scope.roomList[fromRoom];
			
			room.userCount = Number(count);
			scope.onUserCountChange(room);
		}
		
		// A dynamic room was created
		else if (action == "roomAdd")
		{
			var xmlRoom 	= xmlObj.rm.attributes;
			
			var rmId	= xmlRoom.id;
			var rmName 	= xmlObj.rm.name.value;
			var rmMax	= Number(xmlRoom.max);
			var isTemp	= (xmlRoom.temp) ? true : false;
			var isGame	= (xmlRoom.game) ? true : false;
			var isPriv	= (xmlRoom.priv) ? true : false;
			
			var newRoom 	= new it.gotoandplay.smartfoxserver.Room(rmId, rmName, rmMax, isTemp, isGame, isPriv);
			
			scope.roomList[rmId] = newRoom;
			
			/*
			trace("GOT NEW ROOM: ")
			this.dumpObj(this.roomList[newRoom.id])
			*/
			
			scope.onRoomAdded(newRoom);
		}
		
		// A dynamic room was deleted
		else if (action == "roomDel")
		{
			var deletedId = xmlObj.rm.attributes.id;
			
			var almostDeleted = scope.roomList[deletedId];
			
			delete scope.roomList[deletedId];
			
			scope.onRoomDeleted(almostDeleted);
			
		}
		
		// RoundTrip response, for benchmark purposes only!
		else if (action == "roundTripRes")
		{
			scope.t2 = getTimer();
			scope.onRoundTripResponse(scope.t2 - scope.t1);
		}
	}
	
	
	//-----------------------------------------------------------------------------------
	// Debug ONLY
	//-----------------------------------------------------------------------------------
	private function dumpObj(obj:Object)
	{
		if (this.debug)
		{
			trace("------------------------------------------------");
			trace("+ Object Dump                                  +");
			trace("------------------------------------------------");
			trace("Obj TYPE:" + typeof obj);
			
			for (var i:String in obj)
				trace(i + " > " + obj[i]);
	
		}
		else
			trace("nodebug");
	}
	
	
	
	//-----------------------------------------------------------------------------------
	// Login Request
	//-----------------------------------------------------------------------------------
	public function login(zone:String, nick:String, pass:String)
	{
		var header 	= {t:"sys"};
		var message 	= "<login z='" + zone + "'><nick><![CDATA[" + nick + "]]></nick><pword><![CDATA[" + pass + "]]></pword></login>";

		this.send(header, "login", 0, message);
	}
	
	
	
	//-----------------------------------------------------------------------------------
	// Request Room List
	//-----------------------------------------------------------------------------------
	public function getRoomList()
	{
		var header 	= {t:"sys"};
		this.send(header, "getRmList", this.activeRoomId ? this.activeRoomId : -1, "");
	}
	
	//-----------------------------------------------------------------------------------
	// Request autoJoin in defaultRoom
	//-----------------------------------------------------------------------------------
	public function autoJoin()
	{
		var header 	= {t:"sys"};
		this.send(header, "autoJoin", this.activeRoomId ? this.activeRoomId : -1 , "");
	}
	
	
	
	//-----------------------------------------------------------------------------------
	// Join a new room:
	// 
	// roomId 		= id of the new room to join
	// pword		= (OPTIONAL) password (if any) for room
	// dontLeave		= (OPTIONAL) leave the current room ? (true/false). Allow multiple room presence
	// oldRoom		= (OPTIONAL) the id of a room to disconnect before entering the new one
	// 
	// NOTE:
	// the server always disconnect the ActiveRoom before enetering a new one
	// if you don't want to leave the ActiveRoom, set the leaveCurrRoom = false
	// Multiple rooms can be used for special sub-room group chat etc...
	//
	// UPDATE:
	// the newRoom param accepts both a Number ( the room Id ) or a String ( the room name, case sensitive )
	//-----------------------------------------------------------------------------------
	public function joinRoom(newRoom, pword:String, dontLeave:Boolean, oldRoom:Number)
	{
		var newRoomId = null;
		
		if (!this.changingRoom)
		{
			if (typeof newRoom == "number")
			{
				newRoomId = newRoom;
			}
			else
			{
				// Search the room
				for (var i:String in this.roomList)
				{
					//trace("scanning " + this.roomList[i].getName())
					if (this.roomList[i].name == newRoom)
					{
						newRoomId = this.roomList[i].id;
						break;
					}
				}
			}
			
			if (newRoomId != null)
			{
				var header:Object = {t:"sys"}; 
				
				// By default, disconnect active room
				//var leaveCurrRoom = 1
				
				
				//if (leaveRoomFlag != undefined)
				var leaveCurrRoom:String = (dontLeave) ? "0": "1";
				
				// Send oldroom id, even if you don't want to disconnect
				var roomToLeave:Number;
				
				if (oldRoom)
					roomToLeave = oldRoom;			
				else
					roomToLeave = this.activeRoomId;
			
				// CHECK:
				// if this.activeRoomId is null no room has already been entered
				if (this.activeRoomId == null)
				{
					leaveCurrRoom = "0";
					roomToLeave = -1;
				}
				
				var message:String = "<room id='" + newRoomId + "' pwd='" + pword + "' leave='" + leaveCurrRoom + "' old='" + roomToLeave + "' />";
				
				this.send(header, "joinRoom", ((this.activeRoomId) ? this.activeRoomId:-1), message);
				this.changingRoom = true;
			}
			else
			{
				trace("SmartFoxError: requested room to join does not exist!");
			}
		}
	}
	
	
	
	
	//-----------------------------------------------------------------------------------//
	// Send a [PUBLIC] text message to the users
	// msg 	= the txt
	// roomId	= (OPTIONAL) the id of the room, if working with multirooms
	//-----------------------------------------------------------------------------------//
	public function sendPublicMessage(msg:String, roomId:Number)
	{
		if (roomId == undefined)
			roomId = this.activeRoomId;
			
		var header:Object = {t:"sys"};
		
		// Encapsulate message
		var xmlmsg:String = "<txt><![CDATA[" + os.encodeEntities(msg) + "]]></txt>";
	
		this.send(header, "pubMsg", roomId, xmlmsg);
		
	}
	
	
	
	//-----------------------------------------------------------------------------------//
	// Send a [PRIVATE] text message to one user
	// msg 	= the txt
	// userId	= the id of the recipient user
	// roomId	= (OPTIONAL) the id of the room, if working with multirooms
	//-----------------------------------------------------------------------------------//
	public function sendPrivateMessage(msg:String, userId:Number, roomId:Number)
	{
		if (roomId == undefined)
			roomId = this.activeRoomId;
			
		var header:Object = {t:"sys"};
		
		// Encapsulate message
		var xmlmsg:String = "<txt rcp='" + userId + "'><![CDATA[" + os.encodeEntities(msg) + "]]></txt>";
	
		this.send(header, "prvMsg", roomId, xmlmsg);
		
	}
	
	
	
	//-----------------------------------------------------------------------------------//
	// Serialize Actionscript Object and send it
	// Requires ObjectSerializerClass
	//-----------------------------------------------------------------------------------//
	public function sendObject(obj:Object, roomId:Number)
	{
		// If roomId is passed then use it
		// otherwise just use the current active room id
		if (roomId == undefined)
			roomId = this.activeRoomId;
	
		var xmlPacket:String = "<![CDATA[" + os.serialize(obj) + "]]>";
		var header:Object = {t:"sys"};
	
		this.send(header, "asObj", roomId, xmlPacket);
	}
	
	
	
	//
	// Create / Update user variables on server
	// the varObj is an Objects of variables
	// 
	// Ex:
	// vObj = new Object
	// vObj.name = "test"
	// vObj.score= 1000
	// 
	// setUserVariables (vObj)
	//
	public function setUserVariables(varObj:Object, roomId:Number)
	{
		if (roomId == undefined)
			roomId = this.activeRoomId;
			
		var header:Object = {t:"sys"};
		
		// Encapsulate Variables
		var xmlMsg:String = "<vars>";
		
		for (var vName:String in varObj)
		{
			var vValue = varObj[vName];
			var t = null;
			
			// Check type
			if (typeof vValue == "boolean")
			{
				t = "b";
				vValue = (vValue) ? 1:0;			// transform in number before packing in xml
			}
			else if (typeof vValue == "number")
				t = "n";
			else if (typeof vValue == "string")
				t = "s";
			else if (typeof vValue == "null")
				t = "x";
			
			//
			// Ignore objects, arrays etc...
			//
			// NOTE:
			// it would not be necessary to add the <![CDATA[...]]> block for numbers, bools, and nulls
			//
			if (t != null)
				xmlMsg += "<var n='" + vName + "' t='" + t + "'><![CDATA[" + vValue + "]]></var>";
		}
		
		xmlMsg += "</vars>";
	
		this.send(header, "setUvars", roomId, xmlMsg);
	}
	
	
	//-----------------------------------------------------------------------------------//
	// Request a new room creation to the server
	// the roomObj can have these properties:
	//
	// name 	= room name
	// password 	= room password
	// description 	= a brief room description (optional) || NON IMPLEMENTED FOR NOW ||
	// maxUsers 	= max number of users ( <= 40 )
	// updatable 	= boolean to check if room is updatable
	// variables 	= an object filled with vars
	//
	// --- Private memebers ---------------------------
	// isTemp 	= all room created are runtime should be temporary 
	// isGame 	= mark the room as a game room
	//-----------------------------------------------------------------------------------//
	public function createRoom(roomObj:Object)
	{
	
		var roomId:Number	= this.activeRoomId;
			
		var header:Object 	= {t:"sys"};
			
		var updatable:Number 	= (roomObj.updatable) ? 1 : 0;
		var isGame:Number 	= (roomObj.isGame) ? 1 : 0;
		var exitCurrent:Number	= 1;
		
		// If this is a Game Room you will leave the current room
		// and log into the new game room
		// If you specify exitCurrentRoom = false you will not be logged out of the curr room.
		if (isGame && roomObj.exitCurrentRoom != undefined)
		{
			exitCurrent	= (roomObj.exitCurrentRoom) ? 1:0;
		}
		
		var xmlMsg:String  = "<room upd='" + updatable + "' tmp='1' gam='" + isGame + "' exit='" + exitCurrent + "'>";
		
		xmlMsg += "<name><![CDATA[" + roomObj.name + "]]></name>";
		xmlMsg += "<pwd><![CDATA[" + roomObj.password + "]]></pwd>";
		xmlMsg += "<max>" + roomObj.maxUsers + "</max>";
		//xmlMsg += "<desc><![CDATA[" + roomObj.description + "]]></desc>"
		xmlMsg += "<vars></vars>";
		
		xmlMsg += "</room>";
			
		this.send(header, "createRoom", roomId, xmlMsg);
	}
	
	
	
	//-----------------------------------------------------------------------------------
	//  Search for a room
	//  you can pass as the roomId, both its numeric Id or its name
	//-----------------------------------------------------------------------------------
	public function getRoom(roomId)
	{
		if (typeof roomId == "number")
		{
			return this.roomList[roomId];
		}
		else if (typeof roomId == "string")
		{
			for (var i:String in this.roomList)
			{
				var r = this.roomList[i];
	
				if (r.getName() == roomId)
				{
					return r;
				}
			}
		}
	}
	
	
	
	//-----------------------------------------------------------------------------------
	// Returns the currently active Room object
	//
	// NOTE: You can use this only if you're not using
	// the multiRoom feature.
	//-----------------------------------------------------------------------------------
	public function getActiveRoom():Number
	{
		return this.roomList[this.activeRoomId];
	}
	
	
	
	public function setRoomVariables(varObj:Object, roomId:Number)
	{
		if (roomId == undefined)
			roomId = this.activeRoomId;
			
		var header:Object 	= {t:"sys"};
		
		// Encapsulate Variables
		var xmlMsg:String 	= "<vars>";
		
		for (var i:String in varObj)
		{
			var rVar	= varObj[i];
			
			// Get properties for this var
			var vName	= rVar.name;
			var vValue 	= rVar.val;
			var vPrivate	= (rVar.priv) ? "1":"0";
			var vPersistent = (rVar.persistent) ? "1":"0";
			
			var t = null;
			
			// Check type
			if (typeof vValue == "boolean")
			{
				t = "b";
				vValue = (vValue) ? 1:0;			// transform in number before packing in xml
			}
			else if (typeof vValue == "number")
				t = "n";
			else if (typeof vValue == "string")
				t = "s";
			else if (typeof vValue == "null")
				t = "x";
			
			//
			// Ignore objects, arrays etc...
			//
			// NOTE:
			// it would not be necessary to add the <![CDATA[...]]> block for numbers, bools, and nulls
			//
			if (t != null)
				xmlMsg += "<var n='" + vName + "' t='" + t + "' pr='" + vPrivate + "' pe='" + vPersistent + "'><![CDATA[" + vValue + "]]></var>";
		}
		
		xmlMsg += "</vars>";
	
		this.send(header, "setRvars", roomId, xmlMsg);
	}
	
	
	
	public function roundTripBench()
	{
		this.t1 		= getTimer();
		
		var header:Object	= {t:"sys"};
		this.send(header, "roundTrip", this.activeRoomId, "");
	}
	
	
	
	private function send(header:Object, action:String, fromRoom:Number, message:String)
	{
		// Setup Msg Header
		var xmlMsg:String = this.makeHeader(header);
		
		// Setup Body
		xmlMsg += "<body action='" + action + "' r='" + fromRoom + "'>" + message + "</body>" + this.closeHeader();
	
		if (this.debug)
			trace("[Sending]: " + xmlMsg + newline);
	
		super.send(xmlMsg);
	}
	
	
	
	//-----------------------------------------------------------------------------------
	// sendString sends a string formatted message instead of an XML one
	// The string is separated by "%" characters
	// The first two fields are mandatory:
	//
	// % handlerId % actionName % param % param % ... % ... %
	//-----------------------------------------------------------------------------------
	private function sendString(message:String)
	{
		super.send(message);
	}
	
	
	private function gotData(message:String) 
	{
		if (message.charAt(0) == "%")
			strReceived(message);

		else if (message.charAt(0) == "<")
			onXML(new XML(message));
	}
	
	
	
	public function connectionEstablished()
	{
		var header:Object = {t:"sys"};
		var xmlMsg:String = "<ver v='" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "' />";	
				this.send(header, "verChk", 0, xmlMsg);
	}
	
	
	private function connectionClosed()
	{
		// Fire client event
		onConnectionLost();
	}
	
	
	
	public function connect(serverIp:String, serverPort:Number)
	{
		/*
		this.server.onXML		= this.xmlReceived
		
		this.server.onConnect 		= this.onConnect
		this.server.onClose		= this.onClose
		//this.server.onXML		= this.xmlReceived
		*/
		super.connect(serverIp, serverPort);
	}
	
	
	
	public function disconnect()
	{
		close();
		onConnectionLost();
	}
	
	
	
	private function xmlReceived(message:XML)
	{
		var xmlObj:Object = new Object();
	
		message2Object(message.childNodes, xmlObj);
	
		if (this.debug)
		{
			trace("[Received]: " + message);
		}
	
		// get Handler
		var id:String = xmlObj.msg.attributes.t;
	
		messageHandlers[id].handleMessage(xmlObj.msg.body, this, "xml");
	}
	
	
	
	
	//-----------------------------------------------------------------------------------
	// Handle string message from server
	//-----------------------------------------------------------------------------------
	private function strReceived(message:String)
	{
		var params:Array = message.substr(1, message.length - 2).split("%");
	
		if (this.debug)
		{
			trace("[Received - Str]: " + message + "\n");
		}
		
		// get Handler
		var id:String = params[0];

		// the last parameter specify that we have a string formatted message
		messageHandlers[id].handleMessage(params.splice(1, params.length -1), this, "str");
	}

	
	
	//-------------------------------------------------------
	// Message Parser :
	// parses the xml message into an Actionscript Object
	//
	// Retrieve attributes = xmlObj.node.attributs.attrName
	// Retrieve tag value  = xmlObj.node.value
	//-------------------------------------------------------
	private function message2Object(xmlNodes, parentObj)
	{
		// counter
		var i = 0;
		var currObj = null;
	
		while(i < xmlNodes.length)
		{
			// get first child inside XML object
			var node	= xmlNodes[i];
			var nodeName	= node.nodeName; //trace("tag: " + nodeName);
			var nodeValue	= node.nodeValue;
	
			// Check if parent object is an Array or an Object
			if (parentObj instanceof Array)
			{
				currObj = new Object();
				parentObj.push(currObj);
				currObj = parentObj[parentObj.length - 1];
	
			}
			else
			{
				parentObj[nodeName] = new Object();
				currObj = parentObj[nodeName];
			}
	
			//-------------------------------------------
			// Save attributes
			//-------------------------------------------
			for (var j:String in node.attributes)
			{
				if (typeof currObj.attributes == "undefined")
				{
					currObj.attributes = new Object();
				}
	
				var attVal = node.attributes[j];
	
				// Check if it's number
				if (!isNaN(attVal))
				{
					attVal = Number(attVal);
				}
	
				// Check if it's a boolean
				if (attVal.toLowerCase() == "true")
				{
					attVal = true;
				}
				else if (attVal.toLowerCase() == "false")
				{
					attVal = false;
				}
	
				// Store the attribute
				currObj.attributes[j] = attVal;
			}
	
			// If this node is present in the arrayTag Object
			// then a new Array() is created to hold its memebers
			if (this.arrayTags[nodeName])
			{
				currObj[nodeName] = new Array();
				currObj = currObj[nodeName];
			}
	
			// Check if we have more subnodes
			if (node.hasChildNodes() && node.firstChild.nodeValue == undefined)
			{
				// Call this function recursively until node has no more children
				var subNodes = node.childNodes;
				message2Object(subNodes, currObj);
			}
			else
			{
				nodeValue = node.firstChild.nodeValue;
	
				if (!isNaN(nodeValue))
					nodeValue = Number(nodeValue);
	
				currObj.value = nodeValue;
			}
	
			i++;
		}
	
	}
	
	
	
	private function makeHeader(headerObj:Object):String
	{
		var xmlData:String = "<msg";
	
		for (var item:String in headerObj)
		{
			xmlData += " " + item + "='" + headerObj[item] + "'";
		}
	
		xmlData += ">";
	
		return xmlData;
	}
	
	
	
	private function closeHeader():String
	{
		return "</msg>";
	}
}





