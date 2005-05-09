import org.as2lib.core.BasicInterface;
import org.as2lib.app.exec.ProcessListener;

interface org.as2lib.app.exec.Process extends BasicInterface {
    public function addProcessListener(listener:ProcessListener):Void;
	public function removeProcessListener(listener:ProcessListener):Void;
	public function removeAllProcessListeners(Void):Void;
	public function addAllProcessListeners(list:Array):Void;
	public function getAllProcessListeners(Void):Array;
    public function getPercentage(Void):Number; // may return null - equal to not evaluable
    public function hasFinished(Void):Boolean;
    public function isPaused(Void):Boolean;
    public function isRunning(Void):Boolean;
    public function hasStarted(Void):Boolean;
    public function start();
}