/**
 * Basic Exception with a usefull toString() Implementation.
 * Use this Class to Extend all custom Exception Classes. Itself Extends
 * Flash Class "Error" for future Flash Releases.
 *
 * @author Martin Heidegger
 */

class de.flashforum.basic.Exception extends Error {
	// Name of the Exception
	public var name:String;
	// Message that has been posted to the Exception
	public var message:String;
	// Location String a better Path where the Error occured (missing Stacktrace)
	public var location:String;
	// Location String of the Function where the Error occured
	public var inFunction:String;
	// Arguments that where posted to the Functions
	public var arguments:Array;
	
	/**
	 * @param message		Message for the Output
	 * @param location		Location where the Error occured
	 * @param inFunction	Function at the Location
	 * @param thearguments	Arguments from the Function
	 */
	function Exception (message:String, location:String, inFunction:String, thearguments:Array) {
		this.message = message;
		this.location = location;
		this.arguments = thearguments;
		this.inFunction = inFunction;
	}
	
	/**
	 * Converts the Exception to a Standard Error String
	 * 
	 * @return	Returns the Exception as a String
	 */
	function toString ():String {
		var returnValue:String = "\n\n--- ERROR OCCURED ---\n";
		returnValue += this.getContent();
		return(returnValue);
	}
	
	/**
	 * Converts the Exception to a Warning String
	 *
	 * @return	Returns the Exception as a Warning String
	 */
	public function toWarning ():String {
		var returnValue:String = "\n\n--- WARNING ---\n";
		returnValue += this.getContent();
		return(returnValue);
	}
	
	/**
	 * Private Function to generate the Output
	 *
	 * @return	Content of the Exception as String
	 */
	private function getContent ():String {
		var returnValue:String = "    name: "+this.name
			+"\n    @location: "+this.location+" | "+this.inFunction
			+"\n    with message: "+this.message;
		if(this.arguments){
			returnValue += "\n    arguments["+this.arguments.length+"]: ";
			for(var i in this.arguments) {
				returnValue += "\n        "+(Number(i)+1)+"["+typeof(this.arguments[i])+"]="+String(this.arguments[i]);
			}
		} else {
			returnValue += "\n    arguments not defined";
		}
		returnValue += "\n\n";
		return(returnValue);
	}
}