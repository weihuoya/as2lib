import org.as2lib.data.io.conn.remoting.RemotingConnection;

dynamic class org.as2lib.data.io.conn.remoting.NetServiceProxy {
	
	public var _nc:RemotingConnection = null;
	public var _serviceName:String = null;
	private var _client = null;
	
	function NetServiceProxy(ncObj:NetConnectionAS2, serviceName:String, client:Object) {
		if (ncObj != null) {
			_nc = ncObj;
			_serviceName = serviceName;
			_client = client;
		}
	}
    public function get client():Object {
      return _client;
    }
	public function _setParentService(service:Object):Void {
trace("called");
		_nc = service.nc;
		_client = service.client;
	}
	public function __resolve(methodName:String):Function {
		var f:Function = function ():Object {
			if (_client != null) {
				arguments.unshift(new NetServiceProxyResponder(this, methodName));
			} else {
				if (typeof (arguments[0].onResult) != "function") {
					arguments.unshift(new NetServiceProxyResponder(this, methodName));
				}
			}
			arguments.unshift(_serviceName+"."+methodName);
			return _nc.call.apply(_nc, arguments);
		};
		return f;
	}
}
