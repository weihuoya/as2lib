import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.test.unit.TestCaseHelper;
import org.as2lib.test.unit.TestCase;

class org.as2lib.app.exec.TProcessListener extends TestCaseHelper
	implements ProcessStartListener,
		ProcessErrorListener,
		ProcessFinishListener,
		ProcessPauseListener,
		ProcessResumeListener,
		ProcessUpdateListener {
	
	private var started:Boolean = null;
	private var percentStayNull:Boolean;
	private var stopped:Boolean = null;
	private var process:Process;
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function TProcessListener(process, testCase:TestCase) {
		super(testCase);
		this.process = process;
	}
	

	public function onProcessError(process : Process, error) : Boolean {
		fail("Unexpected onProcessError");
		return false;
	}
	
	public function onProcessResume(info:Process):Void {
		fail("Unexpected onResumeProcess");
	}
	
	public function onProcessPause(info:Process):Void {
		fail("Unexpected onPauseProcess");
	}
	
	public function onProcessStart(info:Process):Void {
		if(started && !stopped) {
			fail("Start may only be executed to a stopped process");
		}
		started = true;
		stopped = false;
		assertSame("Submitted Process should match given process", info, process);
		assertFalse("onStart: Process should not be started", process.hasStarted());
		assertFalse("onStart: Process should not be finished", process.hasFinished());
		
		var percent:Number = process.getPercentage();
		if(percent == null) {
			percentStayNull = true;
		} else {
			assertEquals("Startpercent have to be 0 or null", percent, 0);
			percentStayNull = false;
		}
	}
	public function onProcessUpdate(info:Process):Void {
		assertTrue("onUpdate: Process should already be started", process.hasStarted());
		assertFalse("onUpdate: Process should not be finished", process.hasFinished());
		assertSame("onUpdate:Submitted Process should match given process", info, process);
		var percent:Number = process.getPercentage();
		if(percentStayNull) {
			assertNull("onUpdate:Percent may not be something different than null if the execution started with null", percent);
		} else {
			if(percent < 0 || percent > 100) {
				fail("onUpdate:Current percentage has to be bigger than zero and smaller than 100");
			}
		}
	}
	public function onProcessFinish(info:Process):Void {
		assertSame("onFinish: Submitted Process should match given process", info, process);
		assertFalse("onFinish: Process should not be started", process.hasStarted());
		assertTrue("onFinish: Process should already be finished", process.hasFinished());
		var percent:Number = process.getPercentage();
		if(percentStayNull) {
			assertNull("onFinish: Percent may not be something different than null if the execution started with null", percent);
		} else {
			assertEquals("onFinish: Percent should be exactly 100 by stop", percent, 100);
		}
		if(started && !stopped) {
			stopped = true;
		} else {
			fail("onFinish: Stop has to be executed after start and only once");
		}
	}
	
	public function __resolve(name:String) {
		if (name != "testCase" && name != "testExecutionProcess") {
			fail("Called Method/Property not available: "+name);
		}
	}
	
	public function verify(Void):Void {
		if (!started) {
			fail("Process has never started!");
			return;
		}
		if (!stopped) {
			fail("Process has never stopped!");
		}
	}
}