import org.as2lib.test.unit.TestCase;
import org.as2lib.data.math.Vector;
import org.as2lib.data.math.vector.LimitedVector;

/**
 * @author Christoph Atteneder
 */
class test.unit.org.as2lib.data.math.vector.TLimitedVector extends TestCase {
	
	public function TLimitedVector(Void) {}
	
	public function fillVector(vector:Vector):Void {
		vector.setValue(0, 22);
		vector.setValue(1, 34);
		vector.setValue(2, 66);
	}
	
	public function testSetValue(Void):Void {
		var vector:Vector = new LimitedVector(2);
		fillVector(vector);
		assertSame("Vector.getValue(0) should return 22.", vector.getValue(0), 22);
		assertSame("Vector.getValue(1) should return 34.", vector.getValue(1), 34);
		assertUndefined("Vector.getValue(2) should return undefined.", vector.getValue(3));
	}
}