import org.as2lib.env.except.Exception;

/**
 *
 * @author Christoph Atteneder
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.data.io.conn.ConnectorError extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function ConnectorError(message:String, thrower
											 , args:FunctionArguments) {
		super (message, thrower, args);
	}
}