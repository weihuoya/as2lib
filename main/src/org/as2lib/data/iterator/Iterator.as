import org.as2lib.core.BasicInterface;

interface org.as2lib.data.iterator.Iterator extends BasicInterface {
	public function hasNext(Void):Boolean;
	public function next(Void);
	public function remove(Void):Void;
}