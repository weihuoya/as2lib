import org.as2lib.test.unit.TestCase;

import org.as2lib.data.io.conn.local.core.LocalConnectionTemplate;
import org.as2lib.data.io.conn.local.core.ReservedConnectionException;
import org.as2lib.data.io.conn.local.core.ConnectionAlreadyOpenException;
import org.as2lib.data.io.conn.local.core.ConnectionNotOpenException;
import org.as2lib.data.io.conn.local.core.UnknownConnectionException;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.data.io.conn.local.core.TLocalConnectionTemplate extends TestCase {
	
	public function TLocalConnectionTemplate(Void) {
	}
	
	public function testConnect(Void):Void {
		var server:LocalConnectionTemplate = new LocalConnectionTemplate();
		assertNotThrows(ReservedConnectionException, server, server.connect, ["testServer"]);
		assertThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		assertNotThrows(ConnectionNotOpenException, server, server.close, []);
		assertThrows(ConnectionNotOpenException, server, server.close, []);
		assertNotThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		
		var server2:LocalConnectionTemplate = new LocalConnectionTemplate();
		assertThrows(ReservedConnectionException, server2, server2.connect, ["testServer"]);
		assertNotThrows(ReservedConnectionException, server2, server2.connect, ["testServer2"]);
		
		server.close();
		server2.close();
	}
	
	public function testSend(Void):Void {
		var client:LocalConnectionTemplate = new LocalConnectionTemplate();
		assertThrows(UnknownConnectionException, client, client.send, ["notExistingServer", "notExistingMethod"]);
		var server:LocalConnectionTemplate = new LocalConnectionTemplate();
		server.connect("testServer");
		assertNotThrows(UnknownConnectionException, client, client.send, ["testServer", "notExistingMethod"]);
		server.close();
	}
	
	public function testClose(Void):Void {
		var server:LocalConnectionTemplate = new LocalConnectionTemplate();
		assertNotThrows(ReservedConnectionException, server, server.connect, ["testServer"]);
		assertThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		assertNotThrows(ConnectionNotOpenException, server, server.close, []);
		assertThrows(ConnectionNotOpenException, server, server.close, []);
		assertNotThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		
		var server2:LocalConnectionTemplate = new LocalConnectionTemplate();
		assertThrows(ReservedConnectionException, server2, server2.connect, ["testServer"]);
		assertNotThrows(ReservedConnectionException, server2, server2.connect, ["testServer2"]);
		
		server.close();
		server2.close();
	}
	
}