import org.as2lib.basic.Reflections
import org.as2lib.basic.ReflectionObject

/**
 * Testcase for Reflections.
 *
 * @autor Martin Heidegger
 */
 
class test.org.as2lib.basic.TReflections extends test.Test {
	public var tempVar:Array;
	public var testVar:Object;
	public var testVar2:Object;
	public var testClass:Function;
	public var __blockReflection__:Boolean = true;
	public function testInstances () {
		// Creation of test Vars.
		this.testClass = function (name:String) {
			this.name = name;
			return(true);
		}
		
		this.testVar = new this.testClass("hase");
		this.testVar2 = new this.testClass("igel");
		this.tempVar = new Array(this.testVar, this.testVar2);
		this.testVar2.temp = this.testVar;
		
		// Instanciation in an scopeable area.
		// is this really an solution ???
		//_root.tempVar = tempVar;
		
		
		var myTest:ReflectionObject = Reflections.findObject(this);//.tempVar);
		
		_global.myTest = myTest;
		
		trace("--> result:"+myTest);
		
		assertNotUndefined(myTest);
		
		trace("--> obj:"+myTest);
		
		for(var i:Number = 0; i < myTest.properties.length; i++) {
			trace("var "+myTest.properties[i]._path);
		}
		
		trace("--> instanceof:"+myTest.instanceOf);
		
		//throw
		trace(new org.as2lib.basic.exceptions.WrongArgumentException("Error occured!", arguments));
		
		assertEquals(myTest.properties.length, 2);
		trace("--> path: "+myTest._path);
		
		trace("--> props: "+myTest.properties.length);
		trace("--> meths: "+myTest.methods.length);
	}
}