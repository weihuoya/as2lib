﻿import org.as2lib.test.speed.TestCase;
import test.speed.broadcasting.ExampleCall;

class test.speed.broadcasting.ASBroadcasterTest implements TestCase{
	private var _listener:Array;
	private var addListener:Function;
	private var removeListener:Function;
	private var broadcastMessage:Function;
	
	function ASBroadcasterTest () {
		AsBroadcaster.initialize(this);
		addListener(new ExampleCall());
		addListener(new ExampleCall());
		addListener(new ExampleCall());
		addListener(new ExampleCall());
		addListener(new ExampleCall());
		addListener(new ExampleCall());
	}
	public function run(Void):Void {
		broadcastMessage('call');
	}
}