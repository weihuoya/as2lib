import org.as2lib.data.iterator.Iterator;
import org.as2lib.core.BasicInterface;

interface org.as2lib.data.holder.Queue extends BasicInterface {
	public function enqueue(value):Void;
	
	public function dequeue(Void);
	
	public function peek(Void);
	
	public function isEmpty(Void):Boolean;
	
	public function iterator(Void):Iterator;
}