import org.as2lib.core.BasicInterface;

interface org.as2lib.data.io.conn.local.LocalServer extends BasicInterface {
	public function run(Void):Void;
	public function stop(Void):Void;
	public function putPath(path:String, object):Void;
	public function getHost(Void):String;
	public function isRunning(Void):Boolean;
}