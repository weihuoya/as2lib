import org.as2lib.test.unit.TestCase;
import org.as2lib.data.io.conn.ConnectorRequest;

class test.org.as2lib.data.io.conn.TConnectorRequest extends TestCase {
   
	public function TConnectorRequest() {}
   
	public function testRequest():Void{
		var aRequest:ConnectorRequest = new ConnectorRequest("www.as2lib.org","/testConnection","draw",10,25);
		assertEquals(aRequest.getHost(),"www.as2lib.org");
		assertEquals(aRequest.getPath(),"/testConnection");
		assertEquals(aRequest.getMethod(),"draw");
		var aParams:Array = aRequest.getParams();
		assertEquals(aParams[0],10);
		assertEquals(aParams[1],25);
	}
}