import org.as2lib.core.BasicInterface;
import org.as2lib.app.exec.ProcessListener;

interface org.as2lib.app.exec.Process extends BasicInterface{
    public function addProcessListener(listener:ProcessListener):Void;
	public function removeProcessListener(listener:ProcessListener):Void;
	public function removeAllProcessListener(Void):Void;
	public function addAllProcessListener(list:Array):Void;
	public function getAllProcessListener(Void):Array;
    public function getPercent(Void):Number; // may return null - equal to not evaluable
    public function isFinished(Void):Boolean;
    public function isStarted(Void):Boolean;
    public function start(Void):Void;
}