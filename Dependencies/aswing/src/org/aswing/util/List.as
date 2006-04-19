import org.aswing.util.ListNode;
import org.aswing.util.ObjectUtils;


// add more needed methods~!!!


/**
 * List
 * @author Tomato
 */
class org.aswing.util.List{
	
	/**
	 * the head node in this list	 */
	private var head:ListNode;
	/**
	 * the tail node in this list	 */
	private var tail:ListNode;
	/**
	 * the current node in this list	 */
	private var current:ListNode;
	
	/**
	 * the number of nodes in this list	 */
	private var count:Number;
	 
	 
	//constructor
	public function List(){
	 	this.count = 0;
	 	this.head = null;
	 	this.tail = null;
	}
	
	
	public function size():Number{
		return this.count;
	}
	
	public function getHead():ListNode{
		return this.head;
	}
	
	public function getTail():ListNode{
		return this.tail;	
	}
	
	public function append(data:Object):Void{
		if(this.size() == 0){
			this.setFirstNode(data);
			return;
		}
		
		var newNode:ListNode = new ListNode(data , this.tail , null);
		this.tail.setNextNode(newNode);
		this.tail = newNode;
		this.count += 1;
	}
	
	public function prepend(data:Object):Void{
		if(this.size() == 0){
			this.setFirstNode(data);
			return;
		}
		var newNode:ListNode = new ListNode(data , null , this.head);
		this.head.setPreNode(newNode);
		this.head = newNode;
		this.count += 1;
	}
	
	private function setFirstNode(data:Object):Void{
		var newNode:ListNode = new ListNode(data , null , null);
		this.head = newNode;
		this.tail = newNode;
		this.count = 1;
	}
		
	
	public static function clone(existList:List):List{
		if(existList == null){
			return null;
		}
		if(existList.size() <= 0){
			return null;
		}
		var list:List = new List();
		var loopNode:ListNode = existList.getHead();
		while(loopNode != null){
			list.append(ObjectUtils.baseClone(loopNode.getData()));
			loopNode = loopNode.getNextNode();
		}
		return list;
	}
	
		
}