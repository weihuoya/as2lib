import org.as2lib.util.ReflectUtil;

/**
 * Failure Class if an Failure was caused by an Testcase.
 *
 * @autor Martin Heidegger
 * @date 16.11.2003
 */

class org.as2lib.test.unit.Failure {
	
	// Function where the Failure occured
	private var atFunction:String;
	
	// Class where the Faliure occured
	private var atClass:String;
	
	// Time when the Failure occured
	private var atTime:Number;
	
	// Message to the Failure
	private var message:String;
	
	function Failure (atFunction:String, atClass:String, atTime:Number, message:String) {
		this.atFunction = atFunction;
		this.atClass = atClass;
		this.atTime = atTime;
		this.message = message;
	}
	
	/**
	 * Function to print the Failure as String-
	 * 
	 * @return	Failure as String.
	 */
    public function toString ():String {
		var returnValue:String = "   Error @ "+ReflectUtil.getClassInfo(this.atClass).getFullName()+"."+this.atFunction+"() occured ["+this.atTime+"ms]";
		returnValue += "\n      "+message;
		return(returnValue);
	}
}