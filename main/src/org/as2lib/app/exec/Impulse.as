import org.as2lib.core.BasicInterface;
import org.as2lib.app.exec.Executable;
import org.as2lib.env.except.FatalException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ArrayUtil;

class org.as2lib.app.exec.Impulse implements BasicInterface {
	
	private static var code:String = "as2libImpulse";
	private static var instance:Impulse;
	public static function connect(exe:Executable):Void {
		getInstance().addListener(exe);
	}
	public static function disconnect(exe:Executable):Void {
		getInstance().removeListener(exe);
	}
	public static function getInstance(timeline:MovieClip):Impulse {
		if (!instance) instance = new Impulse(timeline);
		return instance;
	}
	
	public function createContainerMovieClip(timeline:MovieClip):MovieClip {
		var name:String = ReflectUtil.getUnusedMemberName(timeline);
		if (!name) {
			throw new FatalException("No free Timeline available", this, arguments);
		}
		return timeline.createEmptyMovieClip(name, timeline.getNextHighestDepth());
	}
	
	private var timeline:MovieClip;
	private var l:Array;
	
	public function Impulse(timeline:MovieClip) {
		var inst:Impulse = instance;
		if (!inst) {
			l = new Array();
			inst = this;
			if (!timeline) {
				timeline = createContainerMovieClip(_root);
			}
			if (typeof timeline.onEnterFrame == "function") {
				throw new IllegalArgumentException("onEnterFrame is already used within the timeline: '"+timeline._target, this, arguments);
			}
			timeline.onEnterFrame = function() {
				var l:Array = inst["l"];
				var i:Number = l.length;
				while(--i-(-1)) {
					l[i].execute();
				}
			}
		}
	}
	
	private function addListener(exe:Executable):Void {
		if (!ArrayUtil.contains(l,exe)) {
			l.push(exe);
		} 
	}
	
	private function removeListener(exe:Executable):Void {
		ArrayUtil.removeElement(l,exe);
	}
	
	public function connectExecutable(exe:Executable):Void {
		getInstance().addListener(exe);
	}
	
	public function disconnectExecutable(exe:Executable):Void {
		getInstance().removeListener(exe);
	}
}