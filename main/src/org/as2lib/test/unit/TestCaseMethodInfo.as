import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.util.StopWatch;
import org.as2lib.util.StringUtil;

class org.as2lib.test.unit.TestCaseMethodInfo extends BasicClass {
	
	private var methodInfo:MethodInfo;
	private var stopWatch:StopWatch;
	private var testRunner:TestRunner;
	private var errors:TypedArray;
	
	public function TestCaseMethodInfo(methodInfo:MethodInfo, testRunner:TestRunner) {
		this.methodInfo = methodInfo;
		this.stopWatch = new StopWatch();
		this.testRunner = testRunner;
		this.errors = new TypedArray(Object);
	}
	public function getTestRunner(Void):TestRunner {
		return this.testRunner;
	}	
	public function getStopWatch(Void):StopWatch {
		return this.stopWatch;
	}
	public function isFinished(Void):Boolean {
		return testRunner.isTestCaseMethodFinished(this);
	}
	public function hasErrors(Void):Boolean {
		return(getErrors().length>0);
	}
	public function getOperationTime(Void):Number {
		return getStopWatch().getTimeInMilliSeconds();
	}
	public function getMethodInfo(Void):MethodInfo {
		return this.methodInfo;
	}
	public function addError(o):Void {
		this.errors.push(o);
	}
	public function getErrors(Void):TypedArray {
		return this.errors;
	}
	public function toString(Void):String {
		var result:String = getMethodInfo().toString()+" ["+getStopWatch().getTimeInMilliSeconds()+"ms]";
		if(hasErrors()) {
			result += " "+getErrors().length+" error(s)";
		}
		var errorIterator:Iterator = new ArrayIterator(getErrors());
		while(errorIterator.hasNext()) {
			var error = errorIterator.next();
			result+="\n"+StringUtil.addSpaceIndent(error.toString(), 2);
		}
		return result;
	}
}