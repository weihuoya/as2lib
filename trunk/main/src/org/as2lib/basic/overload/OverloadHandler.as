/**
 * @author: Simon Wacker
 * @version: 1.0
 */
interface org.as2lib.basic.overload.OverloadHandler {
	/**
	 * Checks if the types of the arguments match the types of the OverloadHandler.
	 * @param someArguments
	 * @return true if the types of the arguments match, otherwise false
	 */
	public function matches(someArguments:Array):Boolean;
	
	/**
	 * Executes the appropriate method on the given object.
	 * @param anObject The object to execute the method on.
	 * @param someArguments The arguments to be passed as parameters.
	 */
	public function execute(anObject:Object, someArguments:Array):Void;
}