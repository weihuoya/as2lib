import test.unit.org.as2lib.data.holder.AbstractTMap
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.PrimitiveTypeMap;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.data.holder.TPrimitiveTypeMap extends AbstractTMap {
	
	public function TPrimitiveTypeMap(Void) {
	}
	
	private function getFilledMap(Void):Map {
		var result:Map = new PrimitiveTypeMap();
		fillMap(result);
		return result;
	}
	
	public function testContainsKey(Void):Void {
		super.parameterizedTestContainsKey(getFilledMap());
	}
	
	public function testContainsValue(Void):Void {
		super.parameterizedTestContainsValue(getFilledMap());
	}
	
	public function testGetKeys(Void):Void {
		super.parameterizedTestGetKeys(getFilledMap());
	}
	
	public function testGetValues(Void):Void {
		super.parameterizedTestGetValues(getFilledMap());
	}
	
	public function testGet(Void):Void {
		super.parameterizedTestGet(getFilledMap());
	}
	
	public function testPut(Void):Void {
		super.parameterizedTestPut(getFilledMap());
	}
	
	public function testPutAll(Void):Void {
		super.parameterizedTestPutAll(new PrimitiveTypeMap(), getFilledMap());
	}
	
	public function testRemove(Void):Void {
		super.parameterizedTestRemove(getFilledMap());
	}
	
	public function testClear(Void):Void {
		super.parameterizedTestClear(getFilledMap());
	}
	
	public function testSize(Void):Void {
		super.parameterizedTestSize(getFilledMap());
	}
	
	public function testIsEmpty(Void):Void {
		super.parameterizedTestIsEmpty(getFilledMap());
	}
	
	public function testIterator(Void):Void {
		super.parameterizedTestIterator(getFilledMap());
	}
	
}