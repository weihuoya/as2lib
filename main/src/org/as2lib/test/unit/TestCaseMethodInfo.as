import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.util.StopWatch;
import org.as2lib.util.StringUtil;
import org.as2lib.test.unit.AssertInfo;

class org.as2lib.test.unit.TestCaseMethodInfo extends BasicClass {
	
	private var methodInfo:MethodInfo;
	private var stopWatch:StopWatch;
	private var testRunner:TestRunner;
	private var asserts:TypedArray;
	
	public function TestCaseMethodInfo(methodInfo:MethodInfo, testRunner:TestRunner) {
		this.methodInfo = methodInfo;
		this.stopWatch = new StopWatch();
		this.testRunner = testRunner;
		this.asserts = new TypedArray(AssertInfo);
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
		var i:Number = asserts.length;
		while (--i-(-1)) {
			if(asserts[i].isFailed()) {
				return true;
			}
		}
		return false;
	}
	public function getOperationTime(Void):Number {
		return getStopWatch().getTimeInMilliSeconds();
	}
	public function getMethodInfo(Void):MethodInfo {
		return this.methodInfo;
	}
	public function addInfo(o:AssertInfo):Void {
		asserts.push(o);
	}
	public function getInfos(Void):TypedArray {
		return asserts.concat();
	}
	public function getErrors(Void):TypedArray {
		var result:TypedArray = new TypedArray(AssertInfo);
		var i:Number = 0;
		var l:Number = asserts.length;
		while (i<l) {
			if(asserts[i].isFailed()) {
				result.push(asserts[i]);
			}
			i-=(-1);
		}
		return result;
	}
	public function toString(Void):String {
		var result:String = getMethodInfo().toString()+" ["+getStopWatch().getTimeInMilliSeconds()+"ms]";
		if(hasErrors()) {
			result += " "+getErrors().length+" error(s)";
		}
		var errorIterator:Iterator = new ArrayIterator(getErrors());
		while(errorIterator.hasNext()) {
			var error = errorIterator.next();
			result+="\n"+StringUtil.addSpaceIndent(error.getMessage(), 2);
		}
		if(hasErrors()) {
			result+="\n";
		}
		return result;
	}
}