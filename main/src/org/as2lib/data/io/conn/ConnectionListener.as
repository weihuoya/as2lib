import org.as2lib.data.io.conn.ConnectionError;
import org.as2lib.data.io.conn.ConnectionResponse;

import org.as2lib.env.event.EventListener;

interface org.as2lib.data.io.conn.ConnectionListener extends EventListener {
	public function onError(error:ConnectionError):Void;
	public function onResponse(response:ConnectionResponse):Void;
}