package GUI 
{
	import Data.INI;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import Logic.Ultility;
	import Logic.GameLogic;
	import Logic.Fish;
	import Logic.User;
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class GUIFishingSuccess extends BaseGUI
	{
		private const BUTTON_GUI_FISHING_SUCCESS_CLOSE:String = "ButtonClose";
		private const BUTTON_GUI_FISHING_SUCCESS_OK:String = "ButtonOk";
		private const BUTTON_GUI_FISHING_SUCCESS_FEEDWALL:String = "FeedWall";
		
		private const BONUS_FOOD:String = "Food";
		private const BONUS_MONEY:String = "Money";
		private const BONUS_EXP:String = "Exp";
		private const BONUS_ENEGRY:String = "EnergyItem";
		private const BONUS_FISH:String = "Fish";
		private const BONUS_MATERIAL:String = "Material";
		//Event 2-9
		private const BONUS_ICON_ND:String = "IconChristmas";
		private var BonusType:String = BONUS_FOOD;
		private var BonusAmount:int = 1;
		private var BonusId:int = -1;
		private var BonusFishName:String = "";
		
		//Collection 
		private const BONUS_ITEM_COLLECTION:String = "ItemCollection";
		
		public function GUIFishingSuccess(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)  
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishingSuccess";
		}
		
		public function SetData(BonusType:String, Amount:int, BonusId:int):void
		{
			this.BonusAmount = Amount;
			this.BonusId = BonusId;
			this.BonusType = BonusType;
		}
		
		/**
		 * Hàm sinh ra phần thưởng ngẫu nhiên
		 * Được gọi khi câu cá thành công
		 */
		public function RandomBonus():void
		{
			//BonusType = Ultility.RandomNumber(0, 4);
			//switch(BonusType)
			//{
				//case BONUS_FOOD:
					//BonusAmount = Ultility.RandomNumber(1, 3);
				//break;
				//case BONUS_MONEY:
					//BonusAmount = Ultility.RandomNumber(1, 5);
				//break;
				//case BONUS_EXP:
					//BonusAmount = 2;
				//break;
				//case BONUS_ENEGRY:
					//BonusAmount = 1;
				//break;
				//case BONUS_FISH:
					//BonusAmount = 1;
				//break;
			//}
			//
			//var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			//if (fishArr.length <= 0)
			//{
				//return;
			//}
			//
			//var randomNumber:int = Ultility.RandomNumber(0, fishArr.length - 1);
			//for (var i:int = 0; i < fishArr.length; i++ )
			//{
				//var fish:Fish = fishArr[i] as Fish;
				//if (i == randomNumber)
				//{
					//BonusId = fish.FishTypeId;
					//BonusFishName = fish.Name;
					//break;
				//}
			//}			
		}
		
		/**
		 * 
		 */
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				//AddImage("", "TienCa", 160, 240);
				AddButton(BUTTON_GUI_FISHING_SUCCESS_CLOSE, "BtnThoat", 340, 53, this);
				//GetButton(BUTTON_GUI_FISHING_SUCCESS_CLOSE).img.scaleX = GetButton(BUTTON_GUI_FISHING_SUCCESS_CLOSE).img.scaleY = 0.6;
				var fmt:TextFormat = new TextFormat("Arial");
				fmt.size = 14;
				fmt.bold = true;
				fmt.color = 0x000000;
				//AddLabel("Chúc mừng", 83, 2).setTextFormat(fmt);			
				
				//Add nút nhận phần thưởng
				fmt.size = 16;
				fmt.bold = true;
				fmt.color = 0x00000;
				var bt:Button = AddButton(BUTTON_GUI_FISHING_SUCCESS_OK, "GuiFishingSuccess_BtnGreen", 150, 298, this);
				bt.img.width = 80;
				bt.img.height = 35;
				AddLabel("Nhận", 138, 270).setTextFormat(fmt);	
				
				// Thong tin phan thuong
				fmt.size = 16;
				fmt.bold = true;
				fmt.color = 0x000000;
				AddLabel("Bạn vừa câu được", 130, 90).setTextFormat(fmt);
				var img:Image;
				
				switch(BonusType)
				{
					// Thuc an
					case BONUS_FOOD:
						img = AddImage("", "ImgFoodBox", 195, 185);
						img.SetScaleX(1.2);
						img.SetScaleY(1.2);
						fmt.size = 24;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 200, 155, 0, 0, 0x26709C).setTextFormat(fmt);
					break;
					// Tien
					case BONUS_MONEY:
						img = AddImage("", "IcGold", 170, 145);
						img.SetScaleX(2.2);
						img.SetScaleY(2.2);
						fmt.size = 24;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 212, 155, 0, 0, 0x26709C).setTextFormat(fmt);
					break;
					// Kinh nghiem
					case BONUS_EXP:
						img = AddImage("", "ImgEXP", 275, 100);
						img.SetScaleX(2.2);
						img.SetScaleY(2.2);
						fmt.size = 28;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 212, 160, 0, 0, 0x26709C).setTextFormat(fmt);					

					break;
					// Nang luong
					case BONUS_ENEGRY:
						img = AddImage("", "EnergyItem" + BonusId , 185, 155);
						//img.SetScaleX(1);
						//img.SetScaleY(1);
						fmt.size = 28;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 200, 160, 0, 0, 0x26709C).setTextFormat(fmt);				
					break;
					// Ca
					case BONUS_FISH:
						fmt.size = 28;
						fmt.bold = true;
						fmt.color = 0xffffff;
						
						var imgNameFish:String;
						var imgAttack:Image;
						var domain:int = Ultility.DomainFish(BonusId);
						if (domain <= 0)
						{
							imgNameFish = "Fish" + BonusId + "_" + Fish.OLD + "_" + Fish.IDLE;
						}
						else 
						{
							imgNameFish = "Fish" + (BonusId - domain) + "_" + Fish.OLD + "_" + Fish.IDLE;
						}
						AddImage("", imgNameFish, 150, 120, true).FitRect(60, 60, new Point(150, 128) );
						AddLabel("x" + BonusAmount.toString() , 220, 160, 0, 0, 0x26709C).setTextFormat(fmt);	
						if (domain > 0)
						{
							imgAttack = AddImage("", Fish.DOMAIN + domain, 175, 125, true, ALIGN_LEFT_TOP);
							imgAttack.FitRect(20, 20);
						}
						
						//Nếu là fish thì chia sẻ
						fmt.size = 16;
						fmt.bold = true;
						fmt.color = 0x00000;
						bt = AddButton(BUTTON_GUI_FISHING_SUCCESS_FEEDWALL, "GuiFishingSuccess_BtnGreen", 150, 298, this);
						bt.img.width = 80;
						bt.img.height = 35;
						AddLabel("Chia sẻ", 138, 270).setTextFormat(fmt);	
					break;
					case BONUS_MATERIAL:
						img = AddImage("", "Material1", 202, 175);
						img.SetScaleX(1.4);
						img.SetScaleY(1.4);
						fmt.size = 28;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 215, 155, 0, 0, 0x26709C).setTextFormat(fmt);
					break;
					case BONUS_ICON_ND:
						img = AddImage("", BonusType + BonusId, 184, 160);
						fmt.size = 28;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 215, 155, 0, 0, 0x26709C).setTextFormat(fmt);
						break;
					case BONUS_ITEM_COLLECTION:
						img = AddImage("", BonusType + BonusId, 184 - 31, 120);
						img.FitRect(60, 60, new Point(184 - 31, 130));
						fmt.size = 28;
						fmt.bold = true;
						fmt.color = 0xffffff;
						AddLabel("x" + BonusAmount.toString() , 215, 155, 0, 0, 0x26709C).setTextFormat(fmt);
						break;
				}	
				
				SetPos(210, 150);
			}
			LoadRes("GuiFishingSuccess_Theme");
		}
		
		/**
		 * Button click
		 * @param	event
		 * @param	buttonID
		 */
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{		
			Hide();
			switch (buttonID)
			{
				case BUTTON_GUI_FISHING_SUCCESS_CLOSE:
					receiveGift();
					break;
				case BUTTON_GUI_FISHING_SUCCESS_OK:
					receiveGift();
					//GuiMgr.getInstance().GuiFishing.Show(Constant.GUI_MIN_LAYER + 1);
					//GuiMgr.getInstance().GuiFishing.Show();
					break;
				case BUTTON_GUI_FISHING_SUCCESS_FEEDWALL:
					
					GuiMgr.getInstance().GuiFeedWall.SetFishType(BonusId);
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_FISHING,Localization.getInstance().getString("Fish" + BonusId));
					break;
			}
		}
		
		
		public function receiveGift():void
		{
			var user:User = GameLogic.getInstance().user;
			switch(BonusType)
			{
				//case "Exp":
					//user.GetMyInfo().Exp += data.Amount;
					//break;
				case "Food":
					//user.GetMyInfo().FoodCount += data.Amount;
					user.UpdateFoodCount(5 * BonusAmount);
					break;
				case "Money":
					//user.GetMyInfo().Money += data.Amount;
					user.UpdateUserMoney(BonusAmount);
					break;
				case "EnergyItem":
					//user.UpdateEnergy(1);
					GuiMgr.getInstance().GuiStore.UpdateStore(BonusType, BonusId, BonusAmount);
					break;
				case "Fish":
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					GuiMgr.getInstance().GuiStore.UpdateStore(BonusType, BonusId, BonusAmount);
					break;
				case "Material":
					GuiMgr.getInstance().GuiStore.UpdateStore(BonusType, BonusId, BonusAmount);
					break;
				case BONUS_ICON_ND:
					GuiMgr.getInstance().GuiStore.UpdateStore(BonusType, BonusId, BonusAmount);
					break;
				case "ItemCollection":
					GuiMgr.getInstance().GuiStore.UpdateStore(BonusType, BonusId, BonusAmount);
					//Hiện thông báo hoàn thành bộ sưu tập
					//if(BonusType == "ItemCollection")
					//{
						//GameLogic.getInstance().checkCompleteCollection(BonusId);
					//}
					break;
			}			
		}
	}

}