import org.as2lib.env.event.EventListener;
import org.as2lib.app.exec.Process;

interface org.as2lib.app.exec.ProcessListener extends EventListener {
	public function onStartProcess(process:Process):Void;
	public function onPauseProcess(process:Process):Void;
	public function onResumeProcess(process:Process):Void;
	public function onUpdateProcess(process:Process):Void;
    public function onFinishProcess(process:Process):Void;
}