/* See LICENSE for copyright and terms of use */

import org.actionstep.*;
import org.actionstep.remoting.*;

/**
 * @author Tay Ray Chuan
 */

class remoting.ASTestRemotingDist {
	public static function main():Void {
		var mc:MovieClip = _root.createEmptyMovieClip("lib", _root.getNextHighestDepth());
		var mcl:MovieClipLoader = new MovieClipLoader();
		mcl.addListener({
		onLoadInit:	function() {
			(new ASTestRemotingDist()).init();
		}});
		mcl.loadClip("ANSRemotingLib.swf", mc);
	}

	public function init():Void {
		Stage.align = "TL";
		Stage.scaleMode = "noScale";

		ASDraw.drawRect(_root, .25, 0xff0000, 0, 0, 550-1, 400-1);

		trace(ASDebugger.info("- ASTestRemotingDist: "+(new Date()).toString()));

		try {
			GoRemoting();
		} catch (e:Error) {	trace(ASDebugger.fatal(e.message));	}
	}

	public function GoRemoting():Void {
		var service:ASService = (new ASService()).initWithNameGatewayURLTracing(
			"MyRecordSet",  // service name
			"http://localhost/amfphp/gateway.php", // gateway URL
			false); // will trace status messages

		service.setTimeout(ASService.ASNoTimeOut);

		var call:ASPendingCall = service.data();
		call.setResponder(this);
	}

	private function didReceiveResponse(res:ASResponse):Void {
		var o:Object = {
		didGetItemSuccess: function(foo:ASRecordSet, index:Number) {
			trace(foo.valueForFieldAtIndex("name", index));
		}};

		var rs:ASRecordSet = ASRecordSet(res.response());
		rs.setResponder(o);
		trace(rs);
		try {
//			ASDebugger.enableMethodLogging();
			trace(rs.valueForFieldAtIndex("name", 0));
		} catch(e:Error) {
			trace(e.message);
		}
		trace(rs);
	}
}