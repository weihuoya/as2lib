import test.unit.org.as2lib.data.holder.AbstractTMap
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.PrimitiveTypeMap;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.data.holder.TPrimitiveTypeMap extends AbstractTMap {
	
	public function TPrimitiveTypeMap(Void) {
	}
	
	private function getMap(Void):Map {
		return new PrimitiveTypeMap();
	}
	
}