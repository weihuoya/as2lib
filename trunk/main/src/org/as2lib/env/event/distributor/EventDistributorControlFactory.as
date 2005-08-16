import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.distributor.EventDistributorControl;

interface org.as2lib.env.event.distributor.EventDistributorControlFactory extends BasicInterface {
	public function createEventDistributorControl(type:Function):EventDistributorControl;
}