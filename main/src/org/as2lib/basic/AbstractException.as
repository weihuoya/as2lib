﻿import org.as2lib.basic.Throwable;
import org.as2lib.data.Stack;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ReflectUtil;
import org.as2lib.basic.reflect.ClassInfo;

class org.as2lib.basic.AbstractException extends Error {
	private var stack:Stack;
	private var cause:Throwable;
	private var message:String;
	private var thrower:Object;
	private var args:FunctionArguments;
	
	private function AbstractException(message:String, thrower, args:FunctionArguments) {
		stack = new Stack();
		this.message = message;
		this.args = args;
		initThrower(thrower);
	}
	
	private function initThrower(thrower):Void {
		if (ObjectUtil.isTypeOf(thrower, "object")) {
			this.thrower = thrower;
			return;
		}
		if (ObjectUtil.isTypeOf(thrower, "function")) {
			this.thrower = new (Function(thrower))();
			return;
		}
	}
	
	public function getStack(Void):Stack {
		return stack;
	}
	
	public function getCause(Void):Throwable {
		return cause;
	}
	
	public function initCause(aCause:Throwable):Void {
		if (ObjectUtil.isAvailable(Object(cause))) {
			throw new Error("The cause has already been set.");
		}
		cause = aCause;
	}
	
	public function getMessage(Void):String {
		return message;
	}
	
	public function getThrower(Void):Object {
		return thrower;
	}
	
	public function getArguments(Void):FunctionArguments {
		return args;
	}
	
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
}