import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.Iterator;
import test.unit.org.as2lib.data.holder.AbstractTMap;

class test.unit.org.as2lib.data.holder.map.THashMap extends AbstractTMap {
	public function THashMap(Void) {
	}
	public function getMap(Void):Map {
		return new HashMap();
	}
}