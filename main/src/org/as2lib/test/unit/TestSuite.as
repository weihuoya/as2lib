import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.holder.Stack;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ArrayUtil;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResult;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * 
 * 
 * @see org.as2lib.test.unit.TestSuite
 * @autor Martin Heidegger
 */
class org.as2lib.test.unit.TestSuite extends BasicClass implements Test {

	private var tests:TypedArray;
	private var name:String;

	/**
	 * Constructs 
	 */
	public function TestSuite(name:String) {
		this.tests = new TypedArray(Test);
		this.name = name;
	}
	
	public function addTest(test:Test):Void {
		if(test == this) {
			throw new IllegalArgumentException("A testsuite may not include itself.", this, arguments);
		}
		tests.push(test);
	}
	
	public function getName(Void):String {
		if(!name) return "";
		return name;
	}
	
	public function run(doNotPrintResult:Boolean):TestResult {
		if(!doNotPrintResult) {
			 doNotPrintResult = false;
		}
		return new TestRunner().run(this, doNotPrintResult);
	}
	
	public function getTests(Void):TypedArray {
		return this.tests;
	}
}