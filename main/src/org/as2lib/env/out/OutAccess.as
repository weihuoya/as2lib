﻿import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;

/**
 * OutAccess defines all possible operations to write output at specific OutLevels.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutAccess extends BasicInterface {
	/**
	 * Outputs a message. The output will only be made when the OutLevel is set to
	 * Out.ALL.
	 *
	 * @param message the message to be written out
	 */
	public function log(message:String):Void;
	
	/**
	 * Outputs a message. The output will only be made when the OutLevel is set to
	 * Out.DEBUG or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message to be written out
	 */
	public function debug(message:String):Void;
	
	/**
	 * Outputs a message. The output will only be made when the OutLevel is set to
	 * Out.INFO or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message to be written out
	 */
	public function info(message:String):Void;
	
	/**
	 * Outputs a message. The output will only be made when the OutLevel is set to
	 * Out.WARNING or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message to be written out
	 */
	public function warning(message:String):Void;
	
	/**
	 * Outputs a Throwable. The output will only be made when the OutLevel is set to
	 * Out.ERROR or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param throwable the Throwable to be written out
	 */
	public function error(throwable:Throwable):Void;
	
	/**
	 * Outputs a Throwable. The output will only be made when the OutLevel is set to
	 * Out.FATAL or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param throwable the Throwable to be written out
	 */
	public function fatal(throwable:Throwable):Void;
}