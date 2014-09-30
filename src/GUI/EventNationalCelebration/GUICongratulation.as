package GUI.EventNationalCelebration 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	//import GUI.GUICharacter;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.EventNationalCelebration.FireworkFish;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendUseItem;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUICongratulation extends BaseGUI 
	{
		public static const BTN_GET_GIFT:String = "BtnGetGift";
		static public const BTN_CLOSE:String = "btnClose";
		private var imageGift:Image;
		private var textField:TextField;
		private var itemType:String;
		private var itemId:int;
		private var itemNum:int;
		private var wishResult:Boolean;
		private var message:String;
		
		private var onlyShow:Boolean = false;
		private var imageName:String;
		private var feedFunction:Function;
		
		public function GUICongratulation(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 500 - 155, 44);
				textField = AddLabel("Bạn nhận được", 145, 100, 0x0c6298);
				var format:TextFormat = new TextFormat("Arial", 20, 0x0c6298, true);
				textField.defaultTextFormat = format;
				if (message != "")
				{
					textField.text = message;
				}
				SetPos(220, 100);
				
				if (!onlyShow)
				{
					//var name:String;
					if (wishResult && itemType == "BabyFish")
					{
						imageName = Ultility.getImgNameFish(itemId);
						GameLogic.getInstance().wishRespond = false;
						GameLogic.getInstance().endEff = false;
					}
					else if (itemType == "Island_Item")
					{
						imageName = ItemGift.getImgName("IslandItem", itemId);
					}
					else
					{
						imageName = ItemGift.getImgName(itemType, itemId);
					}
					
					imageGift = AddImage("", imageName, 165, 150);
					imageGift.FitRect(60, 60, new Point(165, 150));
					
					
					if (wishResult && message == "")
					{
						if (itemType == "BabyFish")
						{
							if(itemNum ==2)
							{
								label.text = "Cá quí";
							}
							else
							{
								label.text = "Cá đặc biệt";
								label.x -= 10;
							}
						}
						textField.text = "Quà Tất Noel";
						switch(itemType)
						{
							case "Exp":
								textField.text = "Món quà kinh nghiệm";
								break;
							case "Material":
								textField.text = "Món quà ngư thạch";
								break;
							case "EnergyItem":
								textField.text = "Món quà năng lượng";
								break;
							case "Spiderman":
							case "Batman":
							case "BabyFish":
							case "Sparta":
							case "Swat":
							case "Ironman":
								textField.text = "Món quà cá";
								GameLogic.getInstance().user.GenerateNextID();
								break;
						}
					}
				}
				else
				{
					imageGift = AddImage("", imageName, 0, 0);
					imageGift.FitRect(60, 60, new Point(165, 140));
				}
				
				
				if (itemNum > 0)
				{
					var label:TextField = AddLabel("x" + Ultility.StandardNumber(itemNum), 165, 140, 0, 0, 0x26709c);
					var txtFormat:TextFormat = new TextFormat("Arial", 15, 0xffffff, true);
					label.setTextFormat(txtFormat);
					AddButton(BTN_GET_GIFT, "BtnNhanThuong", 130, 245);
				}
				else
				{
					AddButton(BTN_GET_GIFT, "BtnFeed", 150, 245);
				}
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		public function showGUI(itemType:String, itemId:int, itemNum:int, wishResult:Boolean = false, message:String = ""):void
		{
			this.itemType = itemType;
			this.itemId = itemId;
			this.itemNum = itemNum;
			this.wishResult = wishResult;
			this.message = message;
			
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (onlyShow)
			{
				onlyShow = false;
				Hide();
				if (imageGift.ImgName.search("LiXi_") >= 0)
				{
					if (message == "Phần thưởng may mắn")
					{
						// Feed cho giai may mắn
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WAR_CHAMPION_1);
					}
					else if ( message == "Phần thưởng top 100 tuần")
					{
						// Feed cho giai ghi danh
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WAR_CHAMPION_2);
					}
					else if(message.search("Phần thưởng top ") >= 0)
					{
						if (message.search("tuần") >= 0)
						{						
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WAR_CHAMPION_3);
						}
						else if (message.search("tháng") >= 0)
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WAR_CHAMPION_4);
						}
					}
				}
				if (feedFunction != null && buttonID != BTN_CLOSE)
				{
					feedFunction();
					feedFunction = null;
				}
				return;
			}
			
			switch(itemType)
			{
				case "Exp":
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + itemNum, false, true);
					if (itemNum >= 1000)
					{
						if (wishResult)
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WISH_ND_1);
						}
						else
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_ND_3);
						}
					}
					break;
				case "Money":
					GameLogic.getInstance().user.UpdateUserMoney(itemNum);
					break;
				case "Firework":
				case "Santa":
					createFireworkFish();
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_ND_4);
					break;
				case "Material":
					GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, itemNum);
					if (itemId == 7 || itemId == 6)
					{
						if (wishResult)
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WISH_ND_2);
						}
						else
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_ND_1);
						}
					}
					break;
				case "EnergyItem":
					GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, itemNum);
					if (itemId == 6)
					{
						if(wishResult)
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WISH_ND_3);
						}
						else
						{
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_ND_2);
						}
					}
					break;
				case "RebornMedicine":
					GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, itemNum);
					if (itemId == 3)
					{
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_ND_5);
					}
					break;
				case "BabyFish":
				case "Spiderman":	
				case "Sparta":
				case "Batman":
				case "Swat":
				case "Ironman":
					//Ẩn gui store
					if (GuiMgr.getInstance().GuiMain.IsVisible)
					{
						GuiMgr.getInstance().GuiMain.img.visible = true;
						GuiMgr.getInstance().GuiMain.imgBgLake.img.visible = true;
					}
					if (GuiMgr.getInstance().GuiFriends.IsVisible)
					{
						GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
					}
					GameLogic.getInstance().BackToIdleGameState();
					GameController.getInstance().UseTool("Default");
					GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
					GuiMgr.getInstance().GuiMain.ShowLakes();
					GuiMgr.getInstance().GuiStore.Hide();
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_WISH_ND_4);
					break;
				case "Gem":
					GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, itemNum);
					break;
				default:
					GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, itemNum);
					
					//Kiểm tra hoàn thành bộ sưu tập
					//if (itemType == "ItemCollection")
					//{
						//GameLogic.getInstance().checkCompleteCollection(itemId);
					//}
					break;
			}
			Hide();
			if(!wishResult)
			{
				//GuiMgr.getInstance().guiGetEventGift.startEffect();
				if (GuiMgr.getInstance().guiGetEventGift.canGetGift())
				{
					GuiMgr.getInstance().guiGetEventGift.startEffect();
				}
				else
				{
					GuiMgr.getInstance().guiGetEventGift.resetEff();	
					GuiMgr.getInstance().guiGetEventGift.timer.stop();
				}
			}
		}
		
		private function createFireworkFish():void
		{
			var Id:int = GameLogic.getInstance().user.GenerateNextID();
			
			if (!GameLogic.getInstance().user.IsViewer())
			{
				var sound:Sound;
				var imgName:String;
				var pos:Point;
				var dir:int;
				var obj:Object;
				// Play sound
				sound = SoundMgr.getInstance().getSound("MuaCa") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				imgName = "Santa";
				
				//pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
				//dir = GuiMgr.getInstance().GuiCharacter.GetDirAvatar();
				pos = Ultility.PosScreenToLake(GameController.getInstance().blackHole.CurPos.x, GameController.getInstance().blackHole.CurPos.y);
				dir = 1;
				var fish:FireworkFish = new FireworkFish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
				fish.Init(pos.x + dir * 40, pos.y - 10);
				fish.Id = Id;
				fish.LakeId = GameLogic.getInstance().user.CurLake.Id;
				fish.bornTime = GameLogic.getInstance().CurServerTime;
				fish.receiveGiftTime = GameLogic.getInstance().CurServerTime;
				fish.SetMovingState(Fish.FS_FALL);
				fish.SetDirFall(dir);
				GameLogic.getInstance().user.arrFireworkFish.push(fish);	
				//GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_RELEASE_FISH);
				
				//GameLogic.getInstance().user.UpdateOptionLake(1, fish);
				GameLogic.getInstance().user.UpdateOptionLakeObject( -1, fish.RateOption, -1, GameLogic.getInstance().user.CurLake.Id);
				//Cập nhật havest time cá
				//GameLogic.getInstance().user.UpdateHavestTime();
			}
			
			//var useItem:SendUseItem = new SendUseItem(GameLogic.getInstance().user.CurLake.Id);
			//obj = new Object();
			//obj["Id"] = Id;
			//obj["ItemType"] = "Santa";
			//useItem.ItemList.push(obj);
			//Exchange.GetInstance().Send(useItem);
		}
		
		public function showReward(_imageName:String, _num:int, _message:String, _feedFunction:Function = null):void
		{
			onlyShow = true;
			message = _message;
			imageName = _imageName;
			itemNum = _num;
			feedFunction = _feedFunction;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
	}

}