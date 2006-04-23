/*
	SmartFoxServer Client API -- Room Object
	Actionscript 2.0
	
	version 2.5
	
	Last update: October 22, 2004
*/


class it.gotoandplay.smartfoxserver.Room
{

	private var id:Number;
	private var name:String;
	private var maxUsers:Number;
	private var temp:Boolean;
	private var game:Boolean;
	private var priv:Boolean;
	private var updatable:Boolean;
	private var description:String;
	private var userCount:Number;
	
	private var userList:Object;
	private var variables:Object;
	
	public function Room(id, name, maxUsers, isTemp, isGame, isPrivate)
	{
		this.id			= id;
		this.name 		= name;
		this.maxUsers 		= maxUsers;
		this.temp 		= isTemp;
		this.game 		= isGame;
		this.priv 		= isPrivate;
		
		this.updatable 		= false;
		this.description 	= "";
		this.userCount 		= 0;
		
		this.userList		= new Object();
		this.variables		= new Array();
		
	}
	
	
	//-----------------------------------------------------------------------------------
	// Returns the userList
	//-----------------------------------------------------------------------------------
	public function getUserList():Object
	{
		return this.userList;
	}
	
	
	
	/*
	* Return the user specified, if exist
	* userId can be the unique user Id, or the user name as well
	*/
	public function getUser(userId)
	{
		if (typeof userId == "number")
		{
			return this.userList[userId];
		}
		else if (typeof userId == "string")
		{
			for (var i:String in this.userList)
			{
				var u = this.userList[i];
	
				if (u.getName() == userId)
				{
					return u;
				}
			}
		}
	}
	
	
	//-----------------------------------------------------------------------------------
	// Return a variable
	//-----------------------------------------------------------------------------------
	public function getVariable(varName:String)
	{
		return this.variables[varName];
	}
	
	
	//-----------------------------------------------------------------------------------
	// Return the variables object
	//-----------------------------------------------------------------------------------
	public function getVariables():Object
	{
		return this.variables;
	}
	
	
	//-----------------------------------------------------------------------------------
	// Get propeties values
	//-----------------------------------------------------------------------------------
	public function getName():String
	{
		return this.name;
	}
	
	public function getId():Number
	{
		return this.id;
	}
	
	public function isTemp():Boolean
	{
		return this.temp;
	}
	
	public function isGame():Boolean
	{
		return this.game;
	}
	
	public function isPrivate():Boolean
	{
		return this.priv;
	}
	
	public function getUserCount():Number
	{
		return this.userCount;
	}
	
	public function getMaxUsers():Number
	{
		return this.maxUsers;
	}
}



