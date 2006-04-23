/*
	SmartFoxServer Client API -- Room Object
	Actionscript 2.0
	
	version 2.5
	
	Last update: October 26, 2004
*/

class it.gotoandplay.smartfoxserver.User
{
	private var id:Number;
	private var name:String;
	private var variables:Object;
	
	function User(id, name)
	{
		this.id = id;
		this.name = name;
		this.variables = new Object();
	}
	
	public function getId():Number
	{
		return this.id;
	}
	
	public function getName():String
	{
		return this.name;
	}
	
	public function getVariable(varName:String)
	{
		return this.variables[varName];
	}
	
	public function getVariables():Object
	{
		return this.variables;
	}
	
	public function toString(Void):String{
		return this.name;		
	}
}