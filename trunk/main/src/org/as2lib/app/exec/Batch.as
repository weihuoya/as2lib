import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.BatchListener;

interface org.as2lib.app.exec.Batch extends Process {
	public function addProcess(process:Process):Void;
    public function removeProcess(process:Process):Void;
    public function getCurrentProcess(Void):Process;
    public function addBatchListener(listener:BatchListener):Void;
	public function addAllBatchListeners(list:Array):Void;
	public function removeBatchListener(listener:BatchListener):Void;
	public function removeAllBatchListeners(Void):Void;
	public function getAllBatchListeners(Void):Array;
}