import org.as2lib.data.math.Vector;
import org.as2lib.data.math.vector.AbstractVector;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.math.Matrix;

class org.as2lib.data.math.vector.LimitedVector extends AbstractVector implements Vector {
	
	private var limit:Number;
	
	public function LimitedVector(limit:Number) {
		this.limit = limit;
	}
	
	public function setValue(index:Number, value:Number) {
		if(index<limit)	v[index] = value;
	}

}