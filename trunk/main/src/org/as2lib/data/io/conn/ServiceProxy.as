import org.as2lib.core.BasicInterface;
import org.as2lib.util.Call;

interface org.as2lib.data.io.conn.ServiceProxy extends BasicInterface {
	public function invoke():Void;
	public function invokeWithArgs(method:String, args:Array):Void;
	public function invokeWithoutArgs(method:String):Void;
	public function putCallback(method:String, call:Call):Void;
}