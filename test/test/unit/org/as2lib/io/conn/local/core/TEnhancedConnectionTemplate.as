import org.as2lib.test.unit.TestCase;

import org.as2lib.io.conn.local.core.EnhancedLocalConnection;
import org.as2lib.io.conn.local.core.ReservedConnectionException;
import org.as2lib.io.conn.local.core.ConnectionAlreadyOpenException;
import org.as2lib.io.conn.local.core.ConnectionNotOpenException;
import org.as2lib.io.conn.local.core.UnknownConnectionException;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.io.conn.local.core.TEnhancedLocalConnection extends TestCase {
	
	public function TEnhancedLocalConnection(Void) {
	}
	
	public function testConnect(Void):Void {
		var server:EnhancedLocalConnection = new EnhancedLocalConnection();
		assertNotThrows(ReservedConnectionException, server, server.connect, ["testServer"]);
		assertThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		assertNotThrows(ConnectionNotOpenException, server, server.close, []);
		assertThrows(ConnectionNotOpenException, server, server.close, []);
		assertNotThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		
		var server2:EnhancedLocalConnection = new EnhancedLocalConnection();
		assertThrows(ReservedConnectionException, server2, server2.connect, ["testServer"]);
		assertNotThrows(ReservedConnectionException, server2, server2.connect, ["testServer2"]);
		
		server.close();
		server2.close();
	}
	
	public function testSend(Void):Void {
		var client:EnhancedLocalConnection = new EnhancedLocalConnection();
		assertThrows(UnknownConnectionException, client, client.send, ["notExistingServer", "notExistingMethod"]);
		var server:EnhancedLocalConnection = new EnhancedLocalConnection();
		server.connect("testServer");
		assertNotThrows(UnknownConnectionException, client, client.send, ["testServer", "notExistingMethod"]);
		server.close();
	}
	
	public function testClose(Void):Void {
		var server:EnhancedLocalConnection = new EnhancedLocalConnection();
		assertNotThrows(ReservedConnectionException, server, server.connect, ["testServer"]);
		assertThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		assertNotThrows(ConnectionNotOpenException, server, server.close, []);
		assertThrows(ConnectionNotOpenException, server, server.close, []);
		assertNotThrows(ConnectionAlreadyOpenException, server, server.connect, ["testServer"]);
		
		var server2:EnhancedLocalConnection = new EnhancedLocalConnection();
		assertThrows(ReservedConnectionException, server2, server2.connect, ["testServer"]);
		assertNotThrows(ReservedConnectionException, server2, server2.connect, ["testServer2"]);
		
		server.close();
		server2.close();
	}
	
}