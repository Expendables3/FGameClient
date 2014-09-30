package GUI.EventMagicPotions 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * congrat kill boss herb!
	 * @author longpt
	 */
	public class GUICongratKillBossHerb extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_NEXT:String = "BtnNext";
		public const BTN_PRE:String = "BtnBack";
		public const BTN_ACCEPT_GIFT:String = "BtnAcceptGift";
		
		public const IMG_GIFT:String = "ImgGift";
		public const ELEMENT_GIFT:String = "ElementGift_";
		
		public var ListGift:ListBox;
		
		public var nameGift:String;
		public var domainNameGift:String;
		public var numGift:int;
		public var isRare:Boolean = false;
		
		public var GiftList:Array = [];
		
		public function GUICongratKillBossHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUICongratKillBossHerb";
		}
		
		public function InitData(objAllGift:Array):void 
		{
			GiftList = objAllGift;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		private function UpdateStateBtnNextBack():void 
		{
			var curPage:int = ListGift.curPage + 1;
			var totalPage:int = ListGift.getNumPage();
			if (totalPage <= 1)
			{
				GetButton(BTN_NEXT).SetVisible(false);
				GetButton(BTN_PRE).SetVisible(false);
			}
			else if (curPage == 1) 
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_PRE).SetVisible(true);
				GetButton(BTN_NEXT).SetEnable();
				GetButton(BTN_PRE).SetEnable(false);
			}
			else if (curPage == totalPage) 
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_PRE).SetVisible(true);
				GetButton(BTN_NEXT).SetEnable(false);
				GetButton(BTN_PRE).SetEnable(true);
			}
			else 
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_PRE).SetVisible(true);
				GetButton(BTN_NEXT).SetEnable();
				GetButton(BTN_PRE).SetEnable();
			}
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos((Constant.STAGE_WIDTH - img.width) / 2, (Constant.STAGE_HEIGHT - img.height) / 2);
				
				var txtFm:TextFormat = new TextFormat();
				var str:String = "Bạn đã đánh thắng Boss Thảo Dược!\nBạn nhận được các quà tặng sau!";
				var lbToolTip:TextField = AddLabel(str, 222, 123, 0xFFFF00, 0);
				txtFm.color = 0xD80506;
				txtFm.bold = true;
				txtFm.size = 18;
				lbToolTip.setTextFormat(txtFm);
				
				var strLb:String = "Phần thưởng sau khi đánh thắng Boss Thảo Dược";
				var lbComment:TextField = AddLabel(strLb, 163, 308, 0xFFFF00, 0);
				txtFm = new TextFormat();
				txtFm.color = 0x1F4B69;
				txtFm.bold = true;
				txtFm.size = 18;
				lbComment.setTextFormat(txtFm);
				
				//AddImage("ImgBoss", "GuiFinalKillBoss_ImgBoss" + FishWorldController.GetSeaId(), 220, 80,true, Image.ALIGN_LEFT_BOTTOM);
				
				AddAllButton();
				
				ListGift = AddListBox(ListBox.LIST_X, 2, 6, 20, 20, true);
				ListGift.setPos(85, 340);
				InitListGift();
				
				UpdateStateBtnNextBack();
				
				OpenRoomOut();
			}
			LoadRes("GuiCongratKillBossHerb_Theme");
		}
		
		public function AddAllButton(isHaveNextBack:Boolean = true):void 
		{
			AddButton(BTN_ACCEPT_GIFT, "BtnFeed", img.width / 2 - 50, img.height - 50, this);
			AddButton(BTN_PRE, "GuiCongratKillBossHerb_Btn_Next", 60, 420, this).SetVisible(isHaveNextBack);
			AddButton(BTN_NEXT, "GuiCongratKillBossHerb_Btn_Pre", 665, 420, this).SetVisible(isHaveNextBack);
		}
		
		public function InitListGift():void 
		{
			for (var i:int = 0; i < GiftList.length; i++) 
			{
				var ctn:Container = new Container(ListGift, "GuiCongratKillBossHerb_CtnSlot");
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.bold = true;
				txtFormat.color = 0xFFFF00;
				txtFormat.size = 16;
				var txtField:TextField;
				var ttip:TooltipFormat;
				switch(GiftList[i].ItemType)
				{
					case "Exp":
						ctn.AddImage("", "ImgEXP", 0, 0).FitRect(50, 50, new Point(10, 5));
						txtField = ctn.AddLabel("x" + Ultility.StandardNumber(GiftList[i].Num), - 15, 54, 0xFFFF00, 1, 0x26709C);
						txtField.setTextFormat(txtFormat);
						ttip = new TooltipFormat();
						ttip.text = "Kinh nghiệm";
						ctn.setTooltip(ttip);
						break;
					case "Material":
					case "RankPointBottle":
					case "Herb":
						ctn.AddImage("", GiftList[i].ItemType + GiftList[i].ItemId, 0, 0).FitRect(50, 50, new Point(10, 5));
						txtField = ctn.AddLabel("x" + GiftList[i].Num, - 15, 54, 0xFFFF00, 1, 0x26709C);
						txtField.setTextFormat(txtFormat);
						ttip = new TooltipFormat();
						ttip.text = Localization.getInstance().getString(GiftList[i].ItemType + GiftList[i].ItemId);
						ctn.setTooltip(ttip);
						break;
					default:
						// Equipment
						var imagee:Image = ctn.AddImage("Equipment", GiftList[i].Type + GiftList[i].Rank + "_Shop", 0, 0);
						imagee.FitRect(50, 50, new Point(10, 5));
						FishSoldier.EquipmentEffect(imagee.img, GiftList[i].Color);
						txtField = ctn.AddLabel("x1", - 15, 54, 0xFFFF00, 1, 0x26709C);
						txtField.setTextFormat(txtFormat);
						ttip = new TooltipFormat();
						ttip.text = Localization.getInstance().getString(GiftList[i].Type + GiftList[i].Rank);
						ctn.setTooltip(ttip);
						break;
				}
				ListGift.addItem(ELEMENT_GIFT + i.toString(), ctn, this)
			}
		} 
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_NEXT:
					ListGift.showNextPage();
					UpdateStateBtnNextBack();
				break;
				case BTN_PRE:
					ListGift.showPrePage();
					UpdateStateBtnNextBack();
				break;
				case BTN_ACCEPT_GIFT:
					GetButton(BTN_ACCEPT_GIFT).SetDisable();
					Feed();
					Hide();
				break;
			}
		}
		public function Feed():void 
		{
			/*switch (FishWorldController.GetSeaId()) 
			{
				case Constant.OCEAN_NEUTRALITY:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_SO, "Tua Rua");
				break;
				case Constant.OCEAN_METAL:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_KIM, "Hoàng Kim");
				break;
			}
			
			GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();*/
		}
	}

}