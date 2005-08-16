import org.as2lib.test.unit.TestCaseHelper;
import org.as2lib.test.unit.TestCase;
import org.as2lib.env.event.distributor.CompositeDistributorControl;
import org.as2lib.test.mock.MockControl;
import org.as2lib.data.type.Radian;
import org.as2lib.env.except.IllegalArgumentException;

class org.as2lib.env.event.distributor.TCompositeEventDistributor extends TestCaseHelper {
	
	public function TCompositeEventDistributor(t:TestCase) {
		super(t);
	}

	public function executeProperBroadcasting(instance:CompositeDistributorControl) {
		
		// Validator Object.
		var param:Function = function(){};
		
		// Listener that supports Number
		var l1Control:MockControl = new MockControl(Number);
		var l1:Number = l1Control.getMock();
		l1.addProperty("prop", param, param);
		l1.addProperty("prop2", param, param);
		l1Control.replay();
		
		assertThrows("Listener should not be addable if the type is not defined", IllegalArgumentException, instance, instance.addListener, [l1]);
		
		instance.acceptListenerType(Number);
		instance.addListener(l1);
		
		
		// Validation if adding worked.
		assertSameWithMessage("Listener legth should be 1 after adding first listener", instance.getAllListeners()[0], l1);
		assertTrue("Listener 1 should be marked as added", instance.hasListener(l1));
		
		// Test if mulitple adding works
		instance.addListener(l1);
		assertEquals("Listener length should be 1 after additional adding first listener", instance.getAllListeners().length, 1);
		
		// More concrete listener that supports Radian
		var l2Control:MockControl = new MockControl(Radian);
		var l2:Radian = l2Control.getMock();
		l2.toDegree();
		l2.addProperty("prop", param, param);
		l2.toRadian();
		l2.addProperty("prop2", param, param);
		l2Control.replay();
		instance.acceptListenerType(Radian);
		instance.addListener(l2);
		
		// Proof of correct list sorting
		assertSameWithMessage("Listener 2 from getAllListeners should be same as second listener", instance.getAllListeners()[1], l2);
		
		// Additional adding of both listeners should not make any effect.
		instance.addAllListeners([l1, l2]);
		assertEquals("There should not be more listeners if all added listeners are currently added", instance.getAllListeners().length, 2);
		
		// Event Execution for Radian only
		var e1:Radian = instance.getDistributor(Radian);
		e1.toDegree();
		
		// Event Execution for Number and Radian
		var e2:Number = instance.getDistributor(Number);
		e2.addProperty("prop", param, param);
		
		// Event Execution for no added Listener
		instance.acceptListenerType(TestCase);
		var e3:TestCase = instance.getDistributor(TestCase);
		e3.run();
		
		// Test if a listener that was removed from the instance also gets removed from event.
		instance.removeListener(l2);
		e1.toDegree();
		
		// Test if removing a reseted distributor has effect to the event.
		
		// Test if additional adding is possible
		instance.addListener(l2);
		e1.toRadian();
		
		// Test if removing all listeners works proper.
		instance.removeAllListeners();
		e2.addProperty("prop3", param, param);
		
		// Test if readding works proper.
		instance.addAllListeners([l1,l2]);
		e2.addProperty("prop2", param, param);
		
		// Event Validation
		l1Control.verify();
		l2Control.verify();
	}
	
	public function executeWithDifferentDistributor(instance:CompositeDistributorControl) {
	}
	
	public function executeWithException(instance:CompositeDistributorControl) {
		
		var expectedException:IllegalArgumentException = new IllegalArgumentException("test", this, arguments);
		var l1Control:MockControl = new MockControl(Radian);
		var l1:Radian = l1Control.getMock();
		
		l1.toDegree();
		l1Control.setThrowable(expectedException);
		l1Control.replay();
		
		instance.acceptListenerType(Radian);
		instance.addListener(l1);
		
		var e1:Radian = instance.getDistributor(Radian);
		var eThrown:Boolean = false;
		try {
			e1.toDegree();
		} catch(e:org.as2lib.env.event.EventExecutionException) {
			assertSame("Cause of the expected exception should match the Mock Exception", e.getCause(), expectedException);
			eThrown = true;
		} catch(e) {
			fail("Unexpected Exception thrown during valdation of the event: "+e.toString());
			eThrown = true;
		}
		
		assertTrue("There should be an exception thrown if event excution fails!", eThrown);
	}
}	