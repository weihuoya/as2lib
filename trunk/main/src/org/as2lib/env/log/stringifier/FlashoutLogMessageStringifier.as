import org.as2lib.env.log.LogMessageStringifier;
import org.as2lib.env.log.LogMessage;

class org.as2lib.env.log.stringifier.FlashoutLogMessageStringifier extends LogMessageStringifier {
	public function execute(target):String {
		var message:LogMessage = target;
		return message.getMessage();
	}
}