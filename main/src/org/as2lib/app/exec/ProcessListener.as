import org.as2lib.env.event.EventListener;
import org.as2lib.app.exec.ProcessInfo;

interface org.as2lib.app.exec.ProcessListener extends EventListener {
	public function onStartProcess(info:ProcessInfo):Void;
	public function onUpdateProcess(info:ProcessInfo):Void;
    public function onStopProcess(info:ProcessInfo):Void;
}