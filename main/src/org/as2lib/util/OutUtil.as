﻿import org.as2lib.core.BasicClass;
import org.as2lib.out.info.OutWriteInfo;
import org.as2lib.out.info.OutErrorInfo;
import org.as2lib.core.string.Stringifier;
import org.as2lib.out.string.WriteStringifier;
import org.as2lib.out.string.ErrorStringifier;
import org.as2lib.out.OutConfig;

class org.as2lib.util.OutUtil extends BasicClass {
	private static var writeStringifier:Stringifier = new WriteStringifier();
	private static var errorStringifier:Stringifier = new ErrorStringifier();
	
	private function OutUtil(Void) {
	}
	
	public static function stringifyWriteInfo(info:OutWriteInfo):String {
		return OutConfig.getWriteStringifier().execute(info);
	}
	
	public static function stringifyErrorInfo(info:OutErrorInfo):String {
		return OutConfig.getErrorStringifier().execute(info);
	}
}