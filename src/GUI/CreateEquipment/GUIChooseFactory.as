package GUI.CreateEquipment 
{
	import Data.ConfigJSON;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.QuestMgr;
	import NetworkPacket.PacketSend.CreateEquipment.SendGetIngradient;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIChooseFactory extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_CREATE:String = "btnCreate";
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var listSkill:ListBox;
		
		public function GUIChooseFactory(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 418 + 281, 19, this);
				SetPos(40, 30);
				WaitData.x = img.width/2 - 5;
				WaitData.y = img.height/2 + 5;
				img.addChild(WaitData);
				listSkill = AddListBox(ListBox.LIST_X, 1, 5, 0, 40);
				listSkill.setPos(70, 118 - 12);
				var craftingData:Object = GameLogic.getInstance().user.craftingSkills;
				if(craftingData != null)
				{
					updateSkillCreate(craftingData);
				}
				else
				{
					Exchange.GetInstance().Send(new SendGetIngradient());
				}
				
				//tutorial
				//var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
				//if (curTutorial.search("CreateWeaponSkill") >= 0)
				//{
					//AddImage("", "IcHelper", 50 + 95, 50 + 96);
				//}
			}
			LoadRes("GuiChooseFactory_Theme");
		}
		
		public function updateSkillCreate(data:Object):void
		{
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			listSkill.removeAllItem();
			var config:Object = ConfigJSON.getInstance().GetItemList("Crafting_Exp")["Require"]["Exp"];
			var listType:Array = ["Weapon", "Armor", "Helmet", "Jewel", "Magic"];
			for (var i:int = 0; i < listType.length; i++)
			{
				var s:String = listType[i];
				var itemSkill:ItemSkillCreate = new ItemSkillCreate(listSkill.img, "");
				itemSkill.initSkill(s, data[s]["Level"], data[s]["Exp"]);
				listSkill.addItem(i.toString(), itemSkill);
				
				if (s == "Helmet")
				{
					itemSkill.setHelper("CreateWeaponSkill");
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
			}
		}
	}

}