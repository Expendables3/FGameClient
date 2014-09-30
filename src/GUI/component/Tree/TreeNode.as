package GUI.component.Tree 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.Container;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class TreeNode extends Container 
	{
		static public const TYPE_NON_LEAFT:String = "typeNonLeaft";
		static public const TYPE_LEAFT:String = "typeLeaft";
		static public const CHILD_NODE:String = "childNode";
		static public const CTN_BG:String = "ctnBg";
		public var bgImage:Container;
		public var iconImage:Image;
		public var labelName:TextField;
		public var ctnChild:Container;
		public var isClose:Boolean = true;
		public var listChild:Array;
		private var _isSelected:Boolean = false;
		public var fatherNode:TreeNode;
		public var tree:Tree;
		public var data:Object;
		
		public function TreeNode(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initNode(value:Object, childArr:Array = null):void
		{
			LoadRes("");
			if(childArr == null)
			{
				bgImage = AddContainer(CTN_BG, "TreeChildSkin", 0, 0);
			}
			else
			{
				bgImage = AddContainer(CTN_BG, "TreeFatherSkin", 0, 0);
			}
			bgImage.img.buttonMode = true;
			var iconName:String;
			if (childArr == null || childArr.length == 0)
			{
				iconName = "leafIcon";
				labelName = AddLabel(value["name"], 15, 2, 0x1144b63, 0);
			}
			else
			{
				
				iconName = "closedBranchIcon";
				ctnChild = AddContainer("", "", 15, Tree.NODE_HEIGHT);
				ctnChild.LoadRes("");
				for (var i:int = 0; i < childArr.length; i++)
				{
					var node:TreeNode = new TreeNode(ctnChild.img);
					node.initNode(childArr[i]);
					node.IdObject = CHILD_NODE + "_" + i.toString();
					node.fatherNode = this;
					ctnChild.AddContainer2(node, 0, i * Tree.NODE_HEIGHT, this);
				}
				ctnChild.img.mouseEnabled = false;
				ctnChild.SetVisible(false);
				labelName = AddLabel(value["name"], 15, 2, 0xfbb004, 0, 0x000000);
			}
			iconImage = AddImage("Icon", iconName, 10, bgImage.img.height/2, true, Image.ALIGN_CENTER_CENTER);
			if(labelName.width + 20 > bgImage.img.width)
			{
				bgImage.img.width = labelName.width + 15;
			}
			if(value["data"] != null)
			{
				data = value["data"];
			}
		}
		
		public function setClose(_isClose:Boolean):void
		{
			isClose = _isClose;
			if (isClose)
			{
				ctnChild.SetVisible(false);
				iconImage.LoadRes("closedBranchIcon");
			}
			else
			{
				ctnChild.SetVisible(true);
				iconImage.LoadRes("openBranchIcon");
			}
			if (tree != null)
			{
				tree.updatePosition();
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CHILD_NODE) >= 0)
			{
				var index:int = buttonID.split("_")[1];
				var childNode:TreeNode = ctnChild.ContainerArr[index] as TreeNode;
				if(!childNode.isSelected)
				{
					childNode.bgImage.SetHighLight(0xffff00);
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!tree.isListen)
			{
				return;
			}
			if (buttonID.search(CHILD_NODE) >= 0)
			{
				//Set trang thai cac nut con
				var index:int = buttonID.split("_")[1];
				for (var i:int = 0; i < ctnChild.ContainerArr.length; i++)
				{
					var childNode:TreeNode = ctnChild.ContainerArr[i] as TreeNode;
					if (i == index)
					{
						childNode.isSelected = true;
						if (tree != null)
						{
							tree.onClickChild(childNode);
						}
					}
					else
					{
						childNode.isSelected = false;
					}
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			//Tắt over ở các con
			if (buttonID.search(CHILD_NODE) >= 0)
			{
				var index:int = buttonID.split("_")[1];
				var childNode:TreeNode = ctnChild.ContainerArr[index] as TreeNode;
				if(!childNode.isSelected)
				{
					childNode.bgImage.SetHighLight(-1);
				}
			}
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
			if (!value)
			{
				bgImage.SetHighLight( -1);
			}
			else
			{
				bgImage.SetHighLight(0x0000ff);
				//Set nut cha not selected
				if (fatherNode != null)
				{
					fatherNode.isSelected = false;
					for each(var n:TreeNode in fatherNode.tree.listNode)
					{
						if (n != fatherNode)
						{
							n.isSelected = false;
							n.disableAllChild();
						}
					}
				}
				//Set tat ca nut con not selected
				if (ctnChild != null)
				{
					for (var i:int = 0; i < ctnChild.ContainerArr.length; i++)
					{
						var childNode:TreeNode = ctnChild.ContainerArr[i] as TreeNode;
						childNode.isSelected = false;
					}
				}
			}
		}
		
		public function getSelectedChild():TreeNode
		{
			if (ctnChild != null)
			{
				for (var i:int = 0; i < ctnChild.ContainerArr.length; i++)
				{
					var childNode:TreeNode = ctnChild.ContainerArr[i] as TreeNode;
					if (childNode.isSelected)
					{
						return childNode;
					}
				}
			}
			return null;
		}
		
		public function disableAllChild():void
		{
			if (ctnChild != null)
			{
				for (var i:int = 0; i < ctnChild.ContainerArr.length; i++)
				{
					var childNode:TreeNode = ctnChild.ContainerArr[i] as TreeNode;
					childNode.isSelected = false;
				}
			}
		}
	}

}