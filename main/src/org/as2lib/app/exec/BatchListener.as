import org.as2lib.app.exec.ProcessListener;
import org.as2lib.app.exec.BatchInfo;

interface org.as2lib.app.exec.BatchListener extends ProcessListener {
	public function onStartBatch(info:BatchInfo):Void;
	public function onUpdateBatch(info:BatchInfo):Void;
    public function onStopBatch(info:BatchInfo):Void;
}