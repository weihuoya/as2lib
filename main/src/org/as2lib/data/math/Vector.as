import org.as2lib.core.BasicInterface;
import org.as2lib.data.math.Matrix;

interface org.as2lib.data.math.Vector extends BasicInterface {
	
	public function set(index:Number, value:Number):Boolean;
	
	public function clear(Void):Void;
	
	public function get(index:Number);
	
	public function size(Void):Number;
	
	public function toArray(Void):Array;
}