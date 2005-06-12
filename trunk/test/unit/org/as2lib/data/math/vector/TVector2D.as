import org.as2lib.test.unit.TestCase;
import org.as2lib.app.exec.ConstructorCall;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.math.Vector;
import org.as2lib.data.math.vector.Vector2D;

/**
 * @author Christoph Atteneder
 */
class org.as2lib.data.math.vector.TVector2D extends TestCase {
	
	public function TVector2D(Void) {}
	
	public function testConstructor(Void):Void {
		var vector:Vector = new Vector2D(22,34);
		assertSame("Vector.getValue(0) should return 22.", vector.getValue(0), 22);
		assertSame("Vector.getValue(1) should return 34.", vector.getValue(1), 34);
		assertUndefined("Vector.getValue(2) should return undefined.", vector.getValue(2));

	}
	
	
	public function testSetX(Void):Void {
		var vector:Vector2D = new Vector2D();
		vector.setX(22);
		assertSame("Vector.getX() should return 22.", vector.getX(), 22);

	}
	
	public function testSetY(Void):Void {
		var vector:Vector2D = new Vector2D();
		vector.setY(34);
		assertSame("Vector.getX() should return 34.", vector.getY(), 34);
	}
	
	
	
	public function testToString(Void):Void {
		var vector:Vector2D = new Vector2D(22,34);
		var str:String = "";
		str += "x = "+vector.getValue(0)+"\n";
		str += "y = "+vector.getValue(1)+"\n";
		assertSame(vector.toString(), str);
	}
}