import org.as2lib.test.unit.Test;
import test.org.as2lib.basic.overload.Dummy;
import org.as2lib.basic.BasicClass;

class test.org.as2lib.basic.TOverloading extends Test {
	private var dummy:Dummy;
	
	public function TOverloading(Void) {
		dummy = new Dummy();
	}
	
	public function testOverload(Void):Void {
		trace (dummy.execute(10, "A", new BasicClass()));
		trace (dummy.execute(Function, 20));
		assertTrueWithMessage("error 0", dummy.execute(10, "A", new BasicClass()) == 1);
		assertTrueWithMessage("error 1", dummy.execute(Function, 20) == 2);
		trace (dummy.execute());
	}
}