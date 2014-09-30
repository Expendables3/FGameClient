package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.FishWorld.Network.SendUnlockSea;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIUnlockOcean extends BaseGUI 
	{
		private var dataAllSea:Object;
		private var objJsonAllSea:Object;
		private var data:Object;
		private var nameImageOcean:String;
		private var seaId:int;
		public const BTN_UNLOCK_BY_XU:String = "BtnUnlockByXu";
		public const BTN_UNLOCK:String = "BtnUnlock";
		
		public const IMG_SLOT_UNLOCK:String = "ImgSlotUnlock";
		public const IMG_SLOT_UNLOCK_FAST:String = "ImgSlotUnlockFast";
		public const IMG_UNLOCK_NEED_1:String = "ImgNeed1";
		public const IMG_UNLOCK_NEED_2:String = "ImgNeed2";
		public const IMG_OCEAN_SEA:String = "ImgOceanSea";
		public const IMG_OCEAN_SEA_LABEL:String = "ImgOceanSeaLabel";
		
		public function GUIUnlockOcean(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIUnlockOcean";
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				var fm:TextFormat = new TextFormat();
				fm.size = 12;
				fm.color = 0x66FFFF;
				SetPos(Constant.STAGE_WIDTH / 2 - 285, Constant.STAGE_HEIGHT / 2 - 220);
				AddImage(IMG_OCEAN_SEA, "GuiUnlockOcean_ImgOceanSea" + seaId, 200 + 175 / 2, 65 + 175 / 2);
				if(int(data.Id) <= 4)	// ở biển có 1 điều kiện
				{
					AddImage(IMG_SLOT_UNLOCK_FAST + "1", "GuiUnlockOcean_CtnFrameSlotUnlockOcean", 200 + 72 / 2, 320 + 72 / 2);
					AddImage(IMG_UNLOCK_NEED_1, "GuiUnlockOcean_ImgNeed" + data.Id, 215 + 44 / 2, 335 + 38 / 2);
					AddButton(BTN_UNLOCK, "GuiUnlockOcean_BtnDiscovery", 201, 404, this, "BtnUnlock").SetEnable(CheckUnlock());
					switch (int(data.Id)) 
					{
						case Constant.OCEAN_NEUTRALITY:
							AddLabel(GameLogic.getInstance().user.FriendArr.length + "/" + data.FriendNum + " bạn", 185, 375, 0xffffff, 1, 0x000000).setTextFormat(fm);
						break;
					}
					
				}
				// Khai phá nhanh bằng G
				AddImage(IMG_SLOT_UNLOCK_FAST, "GuiUnlockOcean_CtnFrameSlotUnlockOcean", 315 + 72 / 2, 320 + 72 / 2);
				AddImage("IcZingXu", "IcZingXu", 252, 270).FitRect(30, 30, new Point(335, 345));
				AddImage("IcZingXuLabel", "GuiUnlockOcean_ImgChooseFast", 322 + 74 / 2, 307 + 48 / 2);
				//AddLabel(GameLogic.getInstance().user.GetZMoney() + "/" + data.ZMoney, 260, 315, 0xffffff, 1, 0xCC33CC).setTextFormat(fm);
				//AddLabel(GameLogic.getInstance().user.GetZMoney() + "/" + data.ZMoney, 300, 375, 0xffffff, 1, 0x000000).setTextFormat(fm);
				AddLabel(data.ZMoney, 300, 375, 0xffffff, 1, 0x000000).setTextFormat(fm);
				AddButton(BTN_UNLOCK_BY_XU, "GuiUnlockOcean_BtnDiscoveryFast", 300, 405, this);
				AddButton("BtnClose", "BtnThoat", img.width - 20, 0, this)
			}
			LoadRes("GuiUnlockOcean_Theme");
		}
		
		public function CheckUnlockByZMoney():Boolean 
		{
			if (int(data.Id) == 1)
			{
				if (GameLogic.getInstance().user.GetLevel() >= int(data.LevelRequire))
				{
					return true;
				}
				else 
				{
					return false;
				}
			}
			return true;
		}
		
		public function CheckUnlock():Boolean 
		{
			var objSea:Object;
			var idSeaNeed:int = -1;
			switch (int(data.Id)) 
			{
				case Constant.OCEAN_NEUTRALITY:
					if (GameLogic.getInstance().user.FriendArr.length >= int(data.FriendNum) 
						&& GameLogic.getInstance().user.GetLevel() >= int(data.LevelRequire))
					{
						return true;
					}
					else 
					{
						return false;
					}
				break;
				case Constant.OCEAN_METAL:
				case Constant.OCEAN_ICE:
				case Constant.OCEAN_FOREST:
					objSea = objJsonAllSea[String(data.Id)];
					idSeaNeed = objSea["PassedSea"];
					if (!(dataAllSea is Array) && dataAllSea[idSeaNeed.toString()])
					{
						if (dataAllSea[idSeaNeed.toString()]["KillBossNum"] > 0)
						{
							return true;
						}
					}
					return false;
				break;
			}
			return true;
		}
		
		public function	setInfoOcean(objAllSea:Object, obj:Object, str:String):void
		{
			objJsonAllSea = ConfigJSON.getInstance().GetItemList("Sea");
			dataAllSea = objAllSea;
			data = new Object();
			data = obj;
			seaId = str.split("_")[1];
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var ZXuUser:int = GameLogic.getInstance().user.GetZMoney();
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case "BtnClose":
					GuiMgr.getInstance().GuiMapOcean.isComingOcean = false;
					Hide();
				break;
				case BTN_UNLOCK:
					GuiMgr.getInstance().GuiMapOcean.isComingOcean = false;
					var cmd:SendUnlockSea = new SendUnlockSea(int(data.Id));
					Exchange.GetInstance().Send(cmd);
					GetButton(BTN_UNLOCK).SetDisable();
					GetButton(BTN_UNLOCK_BY_XU).SetDisable();
					GetButton("BtnClose").SetDisable();
				break;
				case BTN_UNLOCK_BY_XU:
					if (!CheckUnlockByZMoney())	
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Tooltip70"));
						break;
					}
					
					if (ZXuUser < data.ZMoney)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						var posStart:Point = GameInput.getInstance().MousePos;
						Ultility.ShowEffText("Bạn không đủ xu để thực hiện\nHãy nạp thêm nhé", GetButton(BTN_UNLOCK_BY_XU).img, posStart,
							new Point(posStart.x, posStart.y - 100));
						break;
					}
					GuiMgr.getInstance().GuiMapOcean.isComingOcean = false;
					var cmdZMoney:SendUnlockSea = new SendUnlockSea(int(data.Id), "ZMoney");
					Exchange.GetInstance().Send(cmdZMoney);
					GameLogic.getInstance().user.UpdateUserZMoney( -(int(data.ZMoney)));
					GetButton(BTN_UNLOCK_BY_XU).SetDisable();
					GetButton(BTN_UNLOCK).SetDisable();
					GetButton("BtnClose").SetDisable();
				break;
			}
		}
	}

}