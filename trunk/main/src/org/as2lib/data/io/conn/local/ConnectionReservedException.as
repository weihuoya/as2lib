import org.as2lib.env.except.FatalException;

/**
 * ConnectionReservedException gets thrown to indicate that a connection is already used.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.ConnectionReservedException extends FatalException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function ConnectionReservedException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}