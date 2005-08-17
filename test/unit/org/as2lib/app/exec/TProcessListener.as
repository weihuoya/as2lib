import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.app.exec.ProcessInfo;
import org.as2lib.core.BasicClass;
import org.as2lib.test.unit.TestCaseHelper;
import org.as2lib.test.unit.TestCase;

class org.as2lib.app.exec.TProcessListener extends TestCaseHelper implements ProcessListener {
	
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
	
	public function onStartProcess(info:ProcessInfo):Void {
		if(started && !stopped) {
			fail("Start may only be executed to a stopped process");
		}
		started = true;
		stopped = false;
		assertSame("Submitted Process should match given process", info.getProcess(), process);
		assertFalse("Process should not be started", process.isStarted());
		assertFalse("Process should not be finished", process.isFinished());
		
		var percent:Number = process.getPercent();
		if(percent == null) {
			percentStayNull = true;
		} else {
			assertEquals("Startpercent have to be 0 or null", percent, 0);
			percentStayNull = false;
		}
		
		pause();
	}
	public function onUpdateProcess(info:ProcessInfo):Void {
		assertTrue("Process should already be started", process.isStarted());
		assertFalse("Process should not be finished", process.isFinished());
		assertSame("Submitted Process should match given process", info.getProcess(), process);
		var percent:Number = process.getPercent();
		if(percentStayNull) {
			assertNull("Percent may not be something different than null if the execution started with null", percent);
		} else {
			if(percent < 0 || percent > 100) {
				fail("Current percentage has to be bigger than zero and smaller than 100");
			}
		}
	}
	public function onStopProcess(info:ProcessInfo):Void {
		assertSame("Submitted Process should match given process", info.getProcess(), process);
		assertTrue("Process should already be started", process.isStarted());
		assertTrue("Process should already be finished", process.isFinished());
		var percent:Number = process.getPercent();
		if(percentStayNull) {
			assertNull("Percent may not be something different than null if the execution started with null", percent);
		} else {
			assertEquals("Percent should be exactly 100 by stop", percent, 100);
		}
		if(started && !stopped) {
			stopped = true;
		} else {
			fail("Stop has to be executed after start and only once");
		}
		resume();
	}
	
	public function __resolve(name:String) {
		fail("Called Method/Property not available: "+name);
	}
	
	public function verify(Void):Void {
		if(!started) {
			fail("Process has never started!");
			return;
		}
		if(!stopped) {
			fail("Process has never stopped!");
		}
	}
}