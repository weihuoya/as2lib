import org.as2lib.test.unit.Test;
import org.as2lib.data.io.conn.local.LocalConnector;
import org.as2lib.data.io.conn.ConnectorRequest;

class test.org.as2lib.data.io.conn.local.TLocalConnector extends Test{
   
	public function TLocalConnectorImplementation() {
	}
   
	public function testConnection():Void{
	   	var connector:LocalConnector = new LocalConnector();
		
		connector.setHost("www.as2lib.org");
		connector.setPath("/testConnection");
		connector.setMethod("draw");
		connector.setParams(10,25);
		
		assertEquals(connector.getHost(),"www.as2lib.org");
		assertEquals(connector.getPath(),"/testConnection");
		assertEquals(connector.getMethod(),"draw");
		
		var aParams:Array = connector.getParams();
		assertEquals(aParams[0],10);
		assertEquals(aParams[1],25);
		
		connector.handleRequest(new ConnectorRequest("www.as2lib.org","/anotherConnection","walk",40,33));
		
		assertEquals(connector.getHost(),"www.as2lib.org");
		assertEquals(connector.getPath(),"/anotherConnection");
		assertEquals(connector.getMethod(),"walk");
		
		var aParams:Array = connector.getParams();
		assertEquals(aParams[0],40);
		assertEquals(aParams[1],33);
   }
}