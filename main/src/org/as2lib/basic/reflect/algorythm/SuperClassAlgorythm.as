import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.basic.reflect.algorythm.ClassAlgorythm;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.data.Hashtable;

class org.as2lib.basic.reflect.algorythm.SuperClassAlgorythm extends ClassAlgorythm implements ContentAlgorythm {
	public function SuperClassAlgorythm(cache:Cache) {
		super(cache);
	}
	
	public function execute(info:ReflectInfo):Hashtable {
		findAndStore(cache.getRoot(), ClassInfo(info).getClass().prototype);
		return null;
	}
}