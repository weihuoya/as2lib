import org.as2lib.test.unit.Test;
import org.as2lib.data.io.conn.ConnectorResponse;
import test.org.as2lib.data.io.conn.response.TPerson;

class test.org.as2lib.data.io.conn.TConnectorResponse extends Test {
	
	public function TConnectorResponse(Void) {}
	
	public function testResponse(Void):Void {
		var aPerson = new TPerson("Christoph","Atteneder");
		var aResponse:ConnectorResponse = new ConnectorResponse(aPerson);
		
		assertEquals("The passed object in constructor doesn´t match aPerson",aResponse.getData(),aPerson);
		assertNotEquals("The passed object in constructor doesn´t match bPerson",aResponse.getData(),new TPerson("Martin","Heidegger"));
		
		assertEquals(aResponse.getName(),"onResponse");
		assertNotEquals(aResponse.getName(),"onError");
	}
}
