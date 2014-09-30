package GUI.component.Tree 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import GUI.component.Container;
	import GUI.component.ScrollBar;
	import GUI.component.Tree.TreeNode;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class Tree extends Container 
	{
		static public const TREE_NODE:String = "treeNode";
		static public const NODE_HEIGHT:int = 28;
		public var isListen:Boolean = true;
		public var listNode:Array;
		
		public function Tree(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initTree(arrFather:Array, arrayChild:Array):void
		{
			LoadRes("");
			
			listNode = new Array();
			for (var i:int = 0; i < arrFather.length; i++)
			{
				var node:TreeNode = new TreeNode(img);
				node.initNode(arrFather[i], arrayChild[i]);
				node.tree = this;
				node.IdObject = TREE_NODE + "_" + i.toString();
				AddContainer2(node, 0, i * NODE_HEIGHT, this);
				listNode.push(node);
			}
			
			//Vẽ hình vuông bằng kích thước tree khi open tất cả các nút(để dùng cho việc scroll)
			var totalNode:int;
			for (var h:int = 0; h < arrFather.length; h++)
			{
				totalNode += arrayChild[h].length + 1;
			}
			//trace("total", totalNode);
			var size:Sprite = new Sprite();
			size.graphics.beginFill(0xffff00, 0);
			size.graphics.drawRect(0, 0, img.width, totalNode*NODE_HEIGHT);
			size.graphics.endFill();
			img.addChild(size);
			img.setChildIndex(size, 0);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!isListen)
			{
				return;
			}
			if (buttonID.search(TREE_NODE) >= 0)
			{
				var index:int = buttonID.split("_")[1];
				var node:TreeNode = listNode[index] as TreeNode;
				
				if (event.target == node.labelName || event.target == node.bgImage.img || event.target == node.iconImage.img)
				{
					node.setClose(!node.isClose);
					node.isSelected = true;
					//updatePosition();
					
					for (var i:int = 0; i < listNode.length; i++)
					{
						if (i != index)
						{
							var other:TreeNode = TreeNode(listNode[i]);
							other.isSelected = false;
							if(other.ctnChild != null)
							{
								for (var j:int = 0; j < other.ctnChild.ContainerArr.length; j++)
								{
									TreeNode(other.ctnChild.ContainerArr[j]).isSelected = false;
								}
							}
						}
					}
				}
			}
		}
		
		public function updatePosition():void
		{
			for (var i:int = listNode.length -1 ; i >= 0; i--)
			{
				var totalNode:int = 0;
				for (var j:int = i-1 ; j >= 0; j--)
				{
					var other:TreeNode = listNode[j] as TreeNode;
					if(!other.isClose)
					{
						totalNode += other.ctnChild.ContainerArr.length;
					}
					totalNode += 1;
				}
				var node:TreeNode = listNode[i] as TreeNode;
				node.img.y = totalNode * NODE_HEIGHT;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(TREE_NODE) >= 0)
			{
				var index:int = buttonID.split("_")[1];
				var node:TreeNode = listNode[index] as TreeNode;
				if(!node.isSelected)
				{
					node.bgImage.SetHighLight(0xff0000);
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(TREE_NODE) >= 0)
			{
				var index:int = buttonID.split("_")[1];
				var node:TreeNode = listNode[index] as TreeNode;
				if (!node.isSelected)
				{
					node.bgImage.SetHighLight( -1);
				}
			}
		}
		
		public function getSelectedNode():TreeNode
		{
			for (var i:int = 0; i < listNode.length; i++)
			{
				var node:TreeNode = TreeNode(listNode[i]);
				if (node.isSelected)
				{
					return node;
				}
			}
			return null;
		}
		
		public function onClickChild(childNode:TreeNode):void 
		{
			EventHandler.onClickTreeNode(childNode);
		}
		
	}

}