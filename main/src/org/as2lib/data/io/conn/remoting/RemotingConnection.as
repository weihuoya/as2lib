import org.as2lib.data.io.conn.remoting.RemotingHeader;

/**
 * RemotingConnection extends the NetConnection class with methods you only can access 
 * in a traditional NetConnection implementation with the inclusion of "NetServices.as"
 * <code>
 * include "NetServices.as"
 * </code>
 * You use this class if you want to establish a connection to a remote service. It is
 * used by the RemotingConnector.
 *
 * @author Christoph Atteneder
 */

class org.as2lib.data.io.conn.remoting.RemotingConnection extends NetConnection {
	
	private var __urlSuffix:String = null;
	
	private var __originalUrl:String = null;
	
	public var uri:String;
	
	/**
	 * Constructs a new RemotingConnection instance.
	 */
	public function RemotingConnection () {
		super();
	}
	
	/**
	 * This method is used to create a proxy to a remote service. The call to getService()
	 * returns a NetServiceProxy object, which dispatches responses from the service
	 * to the client.
	 *
	 * @param serviceName The name of the remote service whose methods you want to access.
	 *					  This varies according to the server model and the type of service,
	 *					  which is accessed.
	 * @param defaultResponder An optional responder object that handles the responses and
	 *						   errors with defined onResult() and onStatus() methods. If no
	 *						   defaultResponder is set, a responder has to be passed in
	 *						   the method calls.
	 */
	public function getService(serviceName:String, defaultResponder):NetServiceProxy {
		//return (new org.amfphp.remoting.NetServiceProxy(this, serviceName, client));
	}
	
	/**
	 * This method is used when you have an authentication routine
	 * on your server that works with a credentials header. After the execution of the 
	 * method the passed credentials header is attached to every AMF packet.
	 *
	 * @param userid A username to be used by the server for authentication.
	 * @param password A password to be used by the server for authentication.
	 */
	public function setCredentials(userid:String, password:String) {
		addHeader("Credentials", false, {userid:userid, password:password});
	}
	
	/**
	 * This method can be initiated by the server-side gateway to tell the Flash
	 * client to add a header to the request packets. It is equivalent to calling
	 * the addHeader() method, but it can be triggered by the server-side gateway
	 * It is useful when the server application desires that a specific header, such
	 * as a session ID, be attached to every AMF packet sent from the client to the
	 * server.
	 * After the server invokes RequestPersistentHeader(), each subsequent AMF packet
	 * form the client on the relevant connection will contain the specified header
	 * information. AMF packets returned from the server do not include this header,
	 * unless your server-side code manually adds it to the return packet.
	 *
	 * @param info A username to be used by the server for authentication.
	 * @param password A password to be used by the server for authentication.
	 */
	public function RequestPersistentHeader(info:RemotingHeader) {
		addHeader(info.getName, info.getMustUnderstand, info.getData);
	}
	
	/**
	 * This method is used to append a additional string to the gateway url.
	 *
	 * @param urlSuffix A url string.
	 */
	public function AppendToGatewayUrl(urlSuffix:String):Void {
		__urlSuffix = urlSuffix;
		if (__originalUrl == null) {
			__originalUrl = uri;
		}
		var u:String = __originalUrl+urlSuffix;
		connect(u);
	}
	
	/**
	 * This method is used to append a additional string to the gateway url.
	 *
	 * @param urlSuffix A url string.
	 */
	public function ReplaceGatewayUrl(newUrl:String):Void {
		connect(newUrl);
	}
	
	/**
	 * This method returns a clone of the RemotingConnection instance
	 *
	 * @return nc A cloned RemotingConnection object
	 */
	public function clone():RemotingConnection {
		var rc:RemotingConnection = new RemotingConnection();
		rc.connect(uri);
		return nc;
	}
} 