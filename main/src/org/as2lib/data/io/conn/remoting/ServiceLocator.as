import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.remoting.Wrapper;

class org.as2lib.data.io.conn.remoting.ServiceLocator extends BasicClass{
	
	/** Instance of only availiable ServiceLocator */
	private static var INST:ServiceLocator;
	/** To keep count of the number of ServiceLocator objects referenced */
	private static var COUNT:Number = 0;
	
	private static var GATEWAY_URL:String;
	
	private static var RESPONSE_HANDLER:Object;
	
	private static var SERVICE_DIRECTORY:Object;
	
	private static var SERVICE_CACHE:Object;
	
	private function ServiceLocator(gatewayUrl:String,responseHandler:Object) {
		
		GATEWAY_URL = gatewayUrl;
		RESPONSE_HANDLER = responseHandler;
		SERVICE_DIRECTORY = new Object();
		SERVICE_CACHE = new Object();
		
		/* to load "NetServices.as" and "NetDebug.as" */
		Wrapper.getInstance();
		
		NetServices.setDefaultGatewayUrl(GATEWAY_URL);
	}
	
	public static function getInstance(gatewayUrl,responseHandler):ServiceLocator {
		if(INST == null){
			INST = new ServiceLocator(gatewayUrl,responseHandler);
		}
		++COUNT;
		return INST;
	}
	
	public function getRefCount():Number {
		return COUNT;
	}

	public function getGatewayURL(Void):String {
		return GATEWAY_URL;
	}
	
	public function setResponder(responder:Object):Void {
		RESPONSE_HANDLER = responder;
	}
	
	public function addService(serviceName:String, servicePath:String):Void {
		SERVICE_DIRECTORY[serviceName] = servicePath;
	}
	
	public function getServicePath(serviceName:String):String {
		return SERVICE_DIRECTORY[serviceName];
	}
	
	public function getServiceInstance(serviceName:String):Object {
		var resultService:Object = SERVICE_CACHE[serviceName];
		if (resultService != null) {
			return resultService;
		} else {
			resultService = getServiceConnection(serviceName);
			SERVICE_CACHE[serviceName] = resultService;
			return resultService;
		}
	}
	
	private function getServiceConnection(serviceName:String):Object {
		trace("getServiceConnection");
		var connection:NetConnection = NetServices.createGatewayConnection();
		trace(connection);
		var resultService:Object = connection.getService(getServicePath(serviceName), RESPONSE_HANDLER);
		return resultService;
	}
}


