import org.as2lib.env.except.Throwable;

interface org.as2lib.data.io.conn.ConnectionError extends Throwable{
	public function isConnectionError(Void):Boolean;
	public function isServerError(Void):Boolean;
}