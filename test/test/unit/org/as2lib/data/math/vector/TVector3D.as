import org.as2lib.test.unit.TestCase;
import org.as2lib.util.ConstructorCall;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.math.Vector;
import org.as2lib.data.math.vector.Vector3D;

/**
 * @author Christoph Atteneder
 */
class test.unit.org.as2lib.data.math.vector.TVector3D extends TestCase {
	
	public function TVector3D(Void) {}
	
	public function testConstructor(Void):Void {
		var vector:Vector = new Vector3D(22,34,44);
		assertSame("Vector.getValue(0) should return 22.", vector.getValue(0), 22);
		assertSame("Vector.getValue(1) should return 34.", vector.getValue(1), 34);
		assertSame("Vector.getValue(2) should return 44.", vector.getValue(2), 44);
		assertUndefined("Vector.getValue(3) should return undefined.", vector.getValue(3));

	}
	
	
	public function testSetX(Void):Void {
		var vector:Vector3D = new Vector3D();
		vector.setX(22);
		assertSame("Vector.getX() should return 22.", vector.getX(), 22);

	}
	
	public function testSetY(Void):Void {
		var vector:Vector3D = new Vector3D();
		vector.setY(34);
		assertSame("Vector.getY() should return 34.", vector.getY(), 34);
	}
	
	public function testSetZ(Void):Void {
		var vector:Vector3D = new Vector3D();
		vector.setZ(44);
		assertSame("Vector.getZ() should return 44.", vector.getZ(), 44);
	}
	
	public function testToString(Void):Void {
		var vector:Vector3D = new Vector3D(22,34);
		var str:String = "";
		str += "x = "+vector.getValue(0)+"\n";
		str += "y = "+vector.getValue(1)+"\n";
		str += "z = "+vector.getValue(2)+"\n";
		assertSame(vector.toString(), str);
	}
}