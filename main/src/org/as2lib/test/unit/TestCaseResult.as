import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.Out;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.util.StringUtil;


class org.as2lib.test.unit.TestCaseResult extends BasicClass implements TestResult {
	
	private var testCase:TestCase;
	private var testRunner:TestRunner;
	private var testCaseMethodInfos:TypedArray;
	private var finished:Boolean;
	private var started:Boolean;
	private static var out:OutAccess;
	
	public function TestCaseResult(testCase:TestCase, testRunner:TestRunner) {
		this.testRunner = testRunner;
		this.testCase = testCase;
		this.started = false;
		this.finished = false;
	}
	public function getMethodInfos(Void):TypedArray {
		// Lacy Initialisation for load balancing. All Methods get evaluated by starting this TestCaseResult
		// But not by starting all Available TestCaseResult, as it wood if this would be directly inside the
		// Constructor.
		if(!testCaseMethodInfos){
			testCaseMethodInfos = fetchTestCaseMethodInfos();
		}
		return testCaseMethodInfos;
	}
	
	private function fetchTestCaseMethodInfos(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseMethodInfo);
		var methods:Array = ReflectUtil.getClassInfo(this.testCase).getMethods();
		for (var i:Number = 0; i < methods.length; i++) {
			var method:MethodInfo = methods[i];
			if (StringUtil.startsWith(method.getName(), 'test')) {
				result.unshift(new TestCaseMethodInfo(method, getTestRunner()));
			}
		}
		return result;
	}
	
	public function getTestRunner(Void):TestRunner {
		return testRunner;
	}
	
	public function getTestCase(Void):TestCase {
		return testCase;
	}
	
	public function getName(Void):String {
		return getTestCase().getClass().getFullName();
	}
	public function getTestResults(Void):TypedArray {
		var result = new TypedArray(TestResult);
		result.push(this);
		return result;
	}
	public function getPercentage(Void):Number {
		var finished:Number = 0;
		var total:Number = 0;
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(methodIterator.next().isFinished()) {
				finished ++;
			}
			total ++;
		}
		return(100/total*finished);
	}
	public function isFinished(Void):Boolean {
		if(this.finished) return true;
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(!methodIterator.next().isFinished()) {
				return false;
			}
		}
		return(this.finished=true);
	}
	public function isStarted(Void):Boolean {
		if(this.started) return true;
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(methodIterator.next().isFinished()) {
				return(this.started=true);
			}
		}
		return false;
	}
	public function getOperationTime(Void):Number {
		var result:Number = 0;
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			result += methodIterator.next().getStopWatch().getTimeInMilliSeconds();
		}
		return result;
	}
	public function hasErrors(Void):Boolean {
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(methodIterator.next().hasErrors()) {
				return true;
			}
		}
		return false;
	}
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	public static function getOut(Void):OutAccess {
		if(!out) {
			out = new Out();
			Out(out).addHandler(new TraceHandler());
		}
		return out;
	}
	public function toString(Void):String {
		var result:String;
		var methodResult:String="";
		var ms:Number=0;
		var errors:Number=0;
		
		var iter:Iterator=new ArrayIterator(getMethodInfos());
		while(iter.hasNext()) {
			var method:TestCaseMethodInfo = TestCaseMethodInfo(iter.next());
			ms += method.getStopWatch().getTimeInMilliSeconds();
			if(method.hasErrors()) {
				errors += method.getErrors().length;
				methodResult += "\n"+StringUtil.addSpaceIndent(method.toString(), 3);
			}
		}
		
		var result = getName()+" run in ["+ms+"ms]. ";
		
		result += (errors>0) ? errors+" error(s)"+methodResult : "no error occured";
		
		return(result);
	}
	
	public function getTestCaseResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseResult);
		result.push(this);
		return result;
	}
	public function print(Void):Void {
		getOut().info(this.toString());
	}
}