import org.as2lib.core.BasicInterface;

/**
 * OverloadHandler is the interface for all OverloadHandlers. OverloadHandlers
 * are used by the Overload class to identify the corresponding operation for
 * a specific list of arguments.
 *
 * @author Simon Wacker
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
	 * Compares the OverloadHandler passed in with this OverloadHandler for explicity.
	 * The operation returns true when this OverloadHandler is more explicit than
	 * the passed in. Otherwise false will be returned.
	 * What means more explicit? The class SimpleOverloadHandler is for example more
	 * explicit than the class Object.
	 *
	 * @param handler the OverloadHandler that shall be compared with this OverloadHandler
	 * @return true if this OverloadHandler is more explicit else false
	 * @throws org.as2lib.env.overload.IllegalTypeException if the two OverloadHandler have the same explicity
	 */
	public function isMoreExplicitThan(handler:OverloadHandler):Boolean;
	
	/**
	 * Returns the arguments Array that contains the type siganture of the
	 * OverloadHandler.
	 *
	 * @return an Array containing the OverloadHandler's type signature
	 */
	public function getArguments(Void):Array;
}