import org.as2lib.test.unit.TestCase;
import org.as2lib.data.math.Vector;
import org.as2lib.data.math.vector.AbstractVector;

/**
 * @author Christoph Atteneder
 */
class org.as2lib.data.math.vector.TAbstractVector extends TestCase {
	
	public function TAbstractVector(Void) {}
	
	public function fillVector(vector:Vector):Void {
		vector.setValue(0, 22);
		vector.setValue(1, 34);
		vector.setValue(2, 66);
	}
	
	public function testGetValue(Void):Void {
		var vector:Vector = new AbstractVector();
		fillVector(vector);
		assertSame("Vector.getValue(0) should return 22.", vector.getValue(0), 22);
		assertSame("Vector.getValue(1) should return 34.", vector.getValue(1), 34);
		assertSame("Vector.getValue(2) should return 66.", vector.getValue(2), 66);
		assertUndefined("Vector.getValue(3) should return undefined.", vector.getValue(3));
	}
	
	public function testClear(Void):Void {
		var vector:Vector = new AbstractVector();
		fillVector(vector);
		vector.clear();
		assertEquals(vector.toArray().length, 0);
		assertEquals(vector.size(), 0);
	}
	
	public function testSize(Void):Void {
		var vector:Vector = new AbstractVector();
		assertEquals(vector.size(), 0);
		fillVector(vector);
		assertEquals(vector.size(), 3);
		vector.clear();
		assertEquals(vector.size(), 0);
	}
	
	public function testToArray(Void):Void {
		var vector:Vector = new AbstractVector();
		fillVector(vector);
		var values:Array = vector.toArray();
		assertEquals(values[0], 22);
		assertEquals(values[1], 34);
		assertEquals(values[2], 66);
		
		values[0] = 44;
		if(vector.toArray()[0]==44) {
			fail("Changes made to the Array returned by Vector.toArray() do alter the Vector's actual values!");
		}
	}
}