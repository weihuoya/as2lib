import org.as2lib.core.BasicInterface;

/**
 * OverloadHandler is the interface for all OverloadHandlers. OverloadHandlers
 * are used by the Overload class to identify the corresponding operation for
 * arguments.
 *
 * @author: Simon Wacker
 * @see org.as2lib.core.BasicInterface
 */
interface org.as2lib.env.overload.OverloadHandler extends BasicInterface {
	/**
	 * Checks if the types of the arguments match the arguments types of the 
	 * OverloadHandler.
	 *
	 * @param args the arguments that shall be compared with the arguments types
	 * @return true if the types of the arguments match, otherwise false
	 */
	public function matches(args:Array):Boolean;
	
	/**
	 * Executes the appropriate operation on the given target passing the arguments
	 * in.
	 *
	 * @param target the target to execute the operation on
	 * @param args the arguments to be passed as parameters
	 */
	public function execute(target, args:Array);
	
	/**
	 *
	 */
	public function isMoreExplicitThan(handler:OverloadHandler):Boolean;
	
	/**
	 *
	 */
	public function getArguments(Void):Array;
}