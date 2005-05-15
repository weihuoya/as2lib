import org.as2lib.app.exec.Executable;
import org.as2lib.core.BasicInterface;

interface org.as2lib.app.exec.Impulse extends BasicInterface {
	public function connectExecutable(executable:Executable):Void;
	public function disconnectExecutable(executable:Executable):Void;
	public function isExecutableConnected(executable:Executable):Boolean;
}