import org.as2lib.data.iterator.Iterator;
import org.as2lib.core.BasicInterface;

interface org.as2lib.data.holder.Stack extends BasicInterface {
	public function push(value):Void;
	
	public function pop(Void);
	
	public function peek(Void);
	
	public function iterator(Void):Iterator;
	
	public function isEmpty(Void):Boolean;
}