import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;

import org.as2lib.env.event.EventListener;

interface org.as2lib.data.io.conn.ConnectorListener extends EventListener {
	public function onError(error:ConnectionError):Void;
	public function onResponse(response:ConnectionResponse):Void;
}