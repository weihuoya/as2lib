import org.as2lib.env.event.EventListener;
import org.as2lib.test.unit.StartInfo;
import org.as2lib.test.unit.ProgressInfo;
import org.as2lib.test.unit.FinishInfo;
import org.as2lib.test.unit.PauseInfo;
import org.as2lib.test.unit.ResumeInfo;

interface org.as2lib.test.unit.TestListener extends EventListener {
	public function onStart(startInfo:StartInfo):Void;
	public function onProgress(progressInfo:ProgressInfo):Void;
	public function onFinish(finishInfo:FinishInfo):Void;
	public function onPause(pauseInfo:PauseInfo):Void;
	public function onResume(resumeInfo:ResumeInfo):Void;
}