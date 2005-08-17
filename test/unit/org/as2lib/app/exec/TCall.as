import org.as2lib.test.unit.TestCase;
import org.as2lib.app.exec.Call;

class org.as2lib.app.exec.TCall extends TestCase {
	private var call:Call;
	private var list:Array;
	private var varA:String;
	private var varB:String;
	private var varC:String;
	private var varD:String;
	
	public function setUp(){
		call = new Call(this, properForEachExec);
		varA = new String("a");
		varB = new String("b");
		varC = new String("c");
		varD = new String("d");
		list = [varA,varB,varC,varD];
	}
	
	public function testForEach() {
		var call = new Call(this, properForEachExec);
		var result:Array = call.forEach(list);
		assertEquals("Result must have the length of the applied list", result.length, list.length);
		for(var i=0; i<result.length; i++) {
			switch(i) {
				case 0:
				case 1:
				case 2:
				case 3:
					assertEquals("result["+i+"] should be "+(result.length-(i+1)), result[i], (result.length-(i+1)));
					break;
				default:
					fail("Unexpected element "+i+" found");
					break;
			}
		}
	}
	
	private function properForEachExec(obj, name, inst) {
		assertEquals("'inst' has always to be 'list'", inst, list);
		switch(name) {
			case "0":
				assertSame("obj should be 'varA'", obj, varA);
				return 0;
				break;
			case "1":
				assertSame("obj should be 'varB'", obj, varB);
				return 1;
				break;
			case "2":
				assertSame("obj should be 'varC'", obj, varC);
				return 2;
				break;
			case "3":
				assertSame("obj should be 'varD'", obj, varD);
				return 3;
				break;
			default:
				fail("'"+name+"' is no expected name");
		}
	}
}