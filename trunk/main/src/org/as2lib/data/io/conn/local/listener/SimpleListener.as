﻿import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;

class test.org.as2lib.data.io.conn.local.SimpleListener extends BasicClass implements ConnectorListener {
	
	/* Standard debug output */
	private var aOut:OutAccess;
	
	public function ClientListener(Void) {
		aOut = Config.getOut();
	}
	
	/**
	 * Executes a call.
	 */
	public function onError(error:ConnectorError):Void{
		aOut.warning(getClass().getName()+".onError");
		aOut.error(error.getException());
	}
	
	public function onResponse(response:ConnectorResponse):Void{
		aOut.debug(getClass().getName()+".onResponse");
		aOut.debug(response.getData().toString());
	}
}