class org.as2lib.data.io.conn.remoting.ServiceLocator {
	
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
		
		// TODO: Initialization of NetConnection
	}
	
	public function getInstance(aGatewayURL):ServiceLocator {
		if(INST == null){
			INST = new ServiceLocator();
		}
		++COUNT;
		return INST;
	}
	
	public function getRefCount():Number {
		return COUNT;
	}

//------------------------------------------------------------------------------
	
	public function getService( serviceName:String )
	{
		if ( serviceExists( serviceName ) )
			return getServiceInstance( serviceName );
		else
			trace( "ServiceLocator: No Such Service - " + serviceName );
	}

//------------------------------------------------------------------------------

	private function initialiseServices()
	{		
      addService( "AmazonService", "com.iterationtwo.amazonria.flash.AmazonService" );
	}	
	
//------------------------------------------------------------------------------

	private function addService( serviceName:String, servicePath:String )
   {
	   serviceDirectory[ serviceName ] = servicePath;
	}

//------------------------------------------------------------------------------

	private function serviceExists( serviceName:String ):Boolean
	{
		return getServicePath( serviceName ) != null;
	}

//------------------------------------------------------------------------------

	private function getServicePath( serviceName:String ):String
	{
		return serviceDirectory[ serviceName ];
	}
	
//------------------------------------------------------------------------------

	private function getServiceInstance( serviceName:String )
	{
		var service:String = serviceCache[ serviceName ];
	
		var serviceInstantiated:Boolean = ( service != null );
		if ( !serviceInstantiated )
		{
			service = getServiceConnection( serviceName );
			serviceCache[ serviceName ] = service;
		}
		return service;
	}


//------------------------------------------------------------------------------

	private function getServiceConnection( serviceName:String )
   {
		if ( ServiceLocator.connection == undefined )
		   ServiceLocator.connection = NetServices.createGatewayConnection();
			
		return connection.getService( getServicePath( serviceName ), responseHandler );
   }

//------------------------------------------------------------------------------

   private static var connection;
	
	private var responseHandler;
	private var serviceDirectory:Array;
	private var serviceCache:Array;
}


