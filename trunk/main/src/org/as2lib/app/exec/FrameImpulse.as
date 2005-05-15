import org.as2lib.core.BasicClass;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.Impulse;
import org.as2lib.env.except.FatalException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ArrayUtil;

class org.as2lib.app.exec.FrameImpulse extends BasicClass implements Impulse {
	
	private static var instance:FrameImpulse;
	
	public static function connect(exe:Executable):Void {
		getInstance().connectExecutable(exe);
	}
	
	public static function disconnect(exe:Executable):Void {
		getInstance().disconnectExecutable(exe);
	}
	
	public static function isExecutableConnected(exe:Executable):Void {
		getInstance().isExecutableConnected(exe);
	}
	
	public static function getInstance(Void):FrameImpulse {
		if(!instance) instance = new FrameImpulse();
		return instance;
	}
	
	private function FrameImpulse(timeline:MovieClip) {
		connectedExecutables = new Array();
		setTimeline(timeline);
	}
	
	private var timeline:MovieClip;
	private var connectedExecutables:Array;
	private var timelineIsGenerated:Boolean;
	
	public function connectExecutable(exe:Executable):Void {
		if (!isExecutableConnected(exe)) {
			connectedExecutables.push(exe);
		}
	}
	
	public function disconnectExecutable(exe:Executable):Void {
		ArrayUtil.removeElement(connectedExecutables, exe);
	}
	
	public function isExecutableConnected(exe:Executable):Boolean {
		return ArrayUtil.contains(connectedExecutables, exe);
	}
	
	public function setTimeline(timeline:MovieClip):Void {
		var c:Array = connectedExecutables;
		if (timeline != null) {
			if (timeline.onEnterFrame === undefined) {
				
				if (this.timeline) {
					if(timelineIsGenerated) {
						this.timeline.removeMovieClip();
					}
					delete this.timeline.onEnterFrame;
				}
				
				this.timeline = timeline;
				timeline.onEnterFrame = function() {
					var i:Number = c.length;
					while (--i-(-1)) {
						c[i].execute();
					}
				}
				
			} else {
				throw new IllegalArgumentException("onEnterFrame method in "+timeline+" has already been overwritten", this, arguments);
			}
		} else {
			timeline = null;
			getTimeline();
		}
	}
	
	public function getTimeline(Void):MovieClip {
		if (!timeline) {
			var name:String = ReflectUtil.getUnusedMemberName(_root);
			if (!name) {
				throw new FatalException("Could not get a free instance name with ObjectUtil.getUnusedChildName(_root), to create a listenercontainer.", this, arguments);
			}
			var mc:MovieClip = _root.createEmptyMovieClip(name, _root.getNextHighestDepth());
			if (mc) {
				setTimeline(mc);
			} else {
				throw new FatalException("Could not generate a timeline for impulse generation", this, arguments);
			}
			var timelineIsGenerated = true;
		}
		return timeline;
	}
}