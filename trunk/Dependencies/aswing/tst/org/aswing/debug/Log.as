
import org.aswing.debug.Logger;
import org.aswing.debug.SOSLogger;
 
/**
 *
 * @author iiley
 */
class org.aswing.debug.Log {
	
	private static var logger:Logger;
	
	public static function log(msg:String, position, file, line):Void{
		if(line != undefined){
			getLogger().log(msg + "\t" + "{" + position + ", " + file + ", " + line + "}");
		}else{
			getLogger().log(msg);
		}
	}
	
	public static function setLogger(l:Logger):Void{
		logger = l;
	}
	
	public static function getLogger():Logger{
		if(logger == null){
			logger = new SOSLogger();
		}
		return logger;
	}
}