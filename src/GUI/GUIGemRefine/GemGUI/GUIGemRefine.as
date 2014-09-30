package GUI.GUIGemRefine.GemGUI 
{
	import com.flashdynamix.utils.SWFProfiler;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GUIGemRefine.GemLogic.Gem;
	import GUI.GUIGemRefine.GemLogic.GemMgr;
	import GUI.GUIGemRefine.GemLogic.UpgradingGem;
	import GUI.GUIGemRefine.GemPackage.SendDeleteGem;
	import GUI.GUIGemRefine.GemPackage.SendGetGem;
	import GUI.GUIGemRefine.GemPackage.SendQuickUpgrade;
	import GUI.GUIGemRefine.GemPackage.SendRecoverGem;
	import GUI.GUIGemRefine.GemPackage.SendUpgradeGem;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * GUI đan chính gồm khu đan và khu luyện
	 * @author HiepNM2
	 */
	public class GUIGemRefine extends BaseGUI 
	{
		/*id nut*/
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_HELP:String = "idBtnHelp";
		public const ID_BTN_ARRANGE_AUTO:String = "idBtnArrangeAuto";
		public const ID_BTN_DELETE_GEM:String = "idBtnDeleteGem";
		public const ID_BTN_DELETE_ALL_GEM:String = "idBtnDeleteAllGem";
		public const ID_BTN_RECOVER_GEM:String = "idBtnRecoverGem";
		public const ID_BTN_DELETE_UPGRADING_GEM:String = "cmdDelUpgradingGem";
		public const ID_BTN_REFINE_BY_MONEY:String = "cmdRefineByMoney";
		public const ID_BTN_REFINE_BY_ZMONEY:String = "cmdRefineByZMoney";
		public const ID_BTN_REFINE:String = "cmdRefine";
		public const ID_PROGRESSBAR:String = "idProgressBar";
		public const ID_CELL:String = "idCell";
		public const CMD_RECEIVE:String = "cmdGetGem";
		public const ID_CTN_REFINE:String = "idCtnRefine";
		public const CTN_REFINE_SOURCE:String = "CtnRefine";
		public const ID_IMG_TEMPORARY:String = "idImgTemp";
		public const DOUBLE_CLICK_TIME:Number = 0.5;
		public const SLOT_UPGRADE:int = 3;
		public const MAX_GEM_IN_PAGE:int = 30;
		static public const ICON_HELPER:String = "iconHelper";
		private const MAX_GEM_LEVEL:int = 20;
		/*logic*/
		private var IsDataReady:Boolean;
		private var CtnGemArr:Array=[];				//Mảng những đan ở gui đan
		private var config:Array;					//mảng gem tĩnh từ config
		private var curGem:Gem;
		private var curCtnId:String;
		private var clickTime:Number = -1;
		private var isFromGemBox:Boolean = false;
		private var curUpgradingGem:UpgradingGem;
		public var TickCount:Number = 0;
		private var timeGui:Number;
		/*gui*/
		private var guiConfirmCancelUpgrade:GUICancelUpgrade = new GUICancelUpgrade(null, "");
		private var guiConfirmDelGem:GUIDelGem = new GUIDelGem(null, "");
		//private var guiRecoverPearl:GUIRecoverPearl = new GUIRecoverPearl(null, "");
		private var guiRecoverGem:GUIRecoverGem = new GUIRecoverGem(null, "");
		//private var guiDeletePearl:GUIDeletePearl = new GUIDeletePearl(null, "");
		private var guiGuide:GUIGuidePearlRefine = new GUIGuidePearlRefine(null, "");
		
		private var CtnRefine0:CtnRefine;
		private var CtnRefine1:CtnRefine;
		private var CtnRefine2:CtnRefine;
		
		private var imgDrag:Image;
		private var preCell:CtnGem;
		private var arrow:Image = null;
		private var btnRecover:Button;
		private var btnDelete:Button;
		private var btnDeleteAll:Button;
		
		private var _scroll:ScrollPane = new ScrollPane();
		private var Content: Sprite = new Sprite();
		
		[Embed(source = '../../../../content/dataloading.swf', symbol = 'DataLoading')]
		private var DataLoading:Class;
		private var WaitDataStore:Sprite = new DataLoading();
		
		public function GUIGemRefine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGemRefine";
			WaitDataStore.name = "LoadingCircle";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				
				IsDataReady = false;
				var pk:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(pk);
				img.addChild(WaitDataStore);
				WaitDataStore.x = img.width / 2 - img.getChildByName("LoadingCircle").width / 2;
				WaitDataStore.y = img.height / 2 - img.getChildByName("LoadingCircle").height / 2;
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
				arrow = new Image(layer, "IcHelper", 354, 458);
				arrow.img.visible = false;
				//OpenRoomOut();
				EndingRoomOut();
			}
			
			LoadRes("GuiPearlRefine_Theme");
		}
		
		public function refreshComponent(dataAvailable:Boolean = false):void
		{
			timeGui = GameLogic.getInstance().CurServerTime;
			config = ConfigJSON.getInstance().getItemInfo("Gem") as Array;
			IsDataReady = dataAvailable;
			if (img.contains(WaitDataStore))
			{
				img.removeChild(WaitDataStore);
			}
			ClearLabel();
			addBgr();
			initScroll();
			refreshAllGem();
		}
		
		override public function EndingRoomOut():void 
		{
			if (IsDataReady)
			{
				checkCookie("OpenGemGUI");
				timeGui = GameLogic.getInstance().CurServerTime;
				refreshComponent(true);
			}
		}
		
		/**
		 * add vào gui các nút cơ bản
		 */
		private function addBgr():void
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 706, 18, this);
			AddButton(ID_BTN_HELP, "GuiPearlRefine_BtnGuide", 670, 19, this);
			AddButton(ID_BTN_ARRANGE_AUTO, "GuiPearlRefine_Btn_TuXep_TuLuyenNgoc", 50, 447, this);
			btnDelete = AddButton(ID_BTN_DELETE_GEM, "GuiPearlRefine_Btn_HuyNgoc_TuLuyenNgoc", 133, 447, this);
			btnDeleteAll = AddButton(ID_BTN_DELETE_ALL_GEM, "GuiPearlRefine_BtnDelAllExpiredGem", 217, 447, this);
			btnRecover = AddButton(ID_BTN_RECOVER_GEM, "GuiPearlRefine_Btn_KhoiPhuc_TuLuyenNgoc", 301, 447, this);
			//if (!GemMgr.getInstance().hasExpiredGem())
			//{
				var tip:TooltipFormat = new TooltipFormat();
				tip.text = "Khôi phục đan/tán phế";
				btnRecover.setTooltip(tip);
			//}
			//else
			//{
				//btnRecover.clearTooltip();
			//}
		}
		
		private function initScroll():void
		{//tạm thời để đó, chưa chỉnh vội
			_scroll.visible = true;
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 200, 200);
			bg.graphics.endFill();
			_scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiPearlRefine_ImgUpArrowNone") as Sprite;
			var over: Sprite = ResMgr.getInstance().GetRes("GuiPearlRefine_ImgUpArrowOver") as Sprite;
			_scroll.setStyle("upArrowUpSkin", up);
			_scroll.setStyle("upArrowDownSkin", up);
			_scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiPearlRefine_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiPearlRefine_ImgDownArrowOver") as Sprite;
			_scroll.setStyle("downArrowUpSkin", up);
			_scroll.setStyle("downArrowDownSkin", up);
			_scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiPearlRefine_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiPearlRefine_ImgTrackBarOver") as Sprite;
			_scroll.setStyle("thumbUpSkin", up);
			_scroll.setStyle("thumbDownSkin", up);
			_scroll.setStyle("thumbOverSkin", over);
			_scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiPearlRefine_BtnKhungKeo") as Sprite;
			_scroll.setStyle("trackUpSkin", up);
			_scroll.setStyle("trackDownSkin", up);
			_scroll.setStyle("trackOverSkin", up);
			
			_scroll.setSize(375, 328);
			_scroll.verticalScrollBar.setScrollPosition(0);
			_scroll.horizontalScrollBar.visible = false;
			
			img.addChild(_scroll);
			_scroll.x = -15;
			_scroll.y = 106;
			_scroll.horizontalScrollBar.visible = false;
		}
		
		/**
		 * thêm những gem ở khu đan
		 */
		private function addAllGem():void
		{
			removeAllCtnGem();
			var lstGem:Array = GemMgr.getInstance().GemArr;
			var length:int = (lstGem.length<=MAX_GEM_IN_PAGE)?MAX_GEM_IN_PAGE:lstGem.length + 5 - (lstGem.length % 5);
			var i:int;
			var gem:Gem;
			for (i = 0; i < length; i++)
			{
				gem = lstGem[i] as Gem;
				addGem(gem, i/*x, y*/);
			}
			_scroll.source = Content;
		}
		
		private function addGem(gem:Gem, index:int/* x:int,y:int*/):void
		{
			//add cai container
			var ctnCell:CtnGem = new CtnGem(Content, "GuiPearlRefine_Img_Cell_TuLuyenNgoc" /*, x, y*/);
			var dataStatic:Object = (gem == null)?null:config[gem.Level];
			ctnCell.initData(gem, dataStatic, index);
			ctnCell.drawGem(this);
			CtnGemArr.push(ctnCell);
		}
		/**
		 * thêm những gem ở khu luyện
		 */
		private function addAllUpgradingGem():void
		{
			clearAllRefineBox();
			var lstUGem:Array = GemMgr.getInstance().UpgradingGemArr;
			var length:int = lstUGem.length;
			var i:int;
			var upgradingGem:UpgradingGem;
			var x:int = 393;
			var y:int = 0;
			for (i = 0; i < SLOT_UPGRADE; i++)
			{
				y = 107 + 120 * i;
				this["CtnRefine" + i] = new CtnRefine(this.img, "KhungFriend", x + 20, y + 27);
				var ctnRefine:CtnRefine = this["CtnRefine" + i];
				ctnRefine.IdObject = ID_CTN_REFINE + "_" + i;
				ctnRefine.SlotId = i;
				ctnRefine.EventHandler = this;
				ctnRefine.drawBackGround();
			}
			for (i = 0; i < length; i++)
			{
				upgradingGem = lstUGem[i] as UpgradingGem;
				addUpgradingGem(upgradingGem);
			}
		}
		
		private function addUpgradingGem(uGem:UpgradingGem):void
		{
			//xác định tọa độ add vào
			var ctnGem:CtnRefine = this["CtnRefine" + uGem.SlotId] as CtnRefine;
			ctnGem.uGem = uGem;
			if (uGem.TimeRefine < 0)
			{
				trace("leng list Upgrading gem = " + GemMgr.getInstance().UpgradingGemArr.length);
				trace("uGem ở slot id = " + uGem.SlotId + " có TimeRefine =  " + uGem.TimeRefine);
				if (!uGem.JustRefined)
				{
					uGem.TimeRefine = config[uGem.Level]["TimeUpgrade"];
				}
			}
			ctnGem.drawGem();
			
			//Tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("BtnRefine") >= 0)
			{
				RemoveImage(GetImage(ICON_HELPER));
				AddImage(ICON_HELPER, "IcHelper", 451, 197);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var idSlot:int;
			var command:String = data[0];
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_HELP:
					guiGuide.ShowGui();
					//hiện gui help
				break;
				case ID_BTN_ARRANGE_AUTO:
					smartSort();
				break;
				case ID_BTN_DELETE_GEM:
					//hiện gui hủy đan
					delGem();
				break;
				case ID_BTN_DELETE_ALL_GEM:
					var msg:String = Localization.getInstance().getString("Message42");
					GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(msg);
				break;
				case ID_BTN_RECOVER_GEM:
					//hiện gui khôi phục đan
					recoverGem();
				break;
				case CMD_RECEIVE:
					idSlot = (int)(data[1]);
					getRefinedGem(idSlot);
					//Tutorial
					if (GetImage(ICON_HELPER) != null)
					{
						RemoveImage(GetImage(ICON_HELPER));
					}
					//tắt đi thì mới bật phần nhận thưởng quest
					var questArr:Array = QuestMgr.getInstance().finishedQuest;
					if (questArr.length > 0)
					{
						GameLogic.getInstance().OnQuestDone(questArr[0]);		
						questArr.splice(0, 1);
					}
				break;
				case ID_BTN_REFINE:
					idSlot = (int)(data[1]);
					refineGem(idSlot);
					trace("luyện đan ở slot số " + idSlot);
					//Tutorial
					var tutorial:String = QuestMgr.getInstance().GetCurTutorial();
					if (tutorial.search("BtnRefine") >= 0)
					{
						RemoveImage(GetImage(ICON_HELPER));
						AddImage(ICON_HELPER, "IcHelper", 451 + 202, 197);
					}
				break;
				case ID_BTN_REFINE_BY_MONEY:
				case ID_BTN_REFINE_BY_ZMONEY:
					idSlot = (int)(data[1]);
					var isMoney:Boolean = (int)(data[2]) && 0x000001;
					var price:int = (int)(data[3]);
					quickRefine(idSlot, isMoney, price);
				break;
				case ID_BTN_DELETE_UPGRADING_GEM:
					idSlot = (int)(data[1]);
					cancelRefiningGem(idSlot);
				break;
				case ID_CELL:
					var curCell:CtnGem = getCtnGem(buttonID);
					curCtnId = buttonID;
					btnDelete.clearTooltip();
					if (preCell!=null)
					{
						preCell.SetHighLight( -1);
					}
					curCell.SetHighLight();
					preCell = curCell;
				break;
			}
		}
		/**
		 * @param	data: dữ liệu các loại Gem
		 */
		public function receiveAllGem(data:Object):void
		{
			IsDataReady = true;
			GemMgr.getInstance().receiveData(data);
			//if(IsFinishRoomOut)
				refreshComponent(true);
			//Tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("ChoosePearl") >= 0)
			{
				//Tim vi tri gem
				var p:Point;
				for (var i:int = 0; i < CtnGemArr.length; i++)
				{
					var gem:Gem  = CtnGem(CtnGemArr[i]).gem;
					if (gem && gem.Level == 0 && gem.Num >= 10)
					{
						p = CtnGem(CtnGemArr[i]).CurPos;
						break;
					}
				}
				AddImage(ICON_HELPER, "IcHelper", p.x + 22, p.y + 122);
			}
			
		}
		private function refineGem(idSlot:int):void
		{
			/*send du lieu len server*/
			var ctnRefine:CtnRefine = this["CtnRefine" + idSlot];
			var uGem:UpgradingGem = ctnRefine.uGem;
			var list:Array = [];
			var gem:Gem;
			for (var i:int = 0; i < uGem.ListGemSource.length; i++)
			{
				gem = uGem.ListGemSource[i] as Gem;
				var obj:Object = new Object();
				obj["Element"] = gem.Element;
				obj["GemId"] = gem.Level;
				obj["Day"] = gem.DayLife;
				obj["Num"] = gem.Num;
				list.push(obj);
			}
			var pk:SendUpgradeGem = new SendUpgradeGem(uGem.Element, list, uGem.LevelDone, uGem.SlotId);
			Exchange.GetInstance().Send(pk);
			/*bien doi ctnRefine*/
			//trace("bắt đầu chạy timer trong ctnRefine");
			ctnRefine.startRefine();
		}
		
		private function getRefinedGem(idSlot:int):void
		{
			//send dữ liệu lên server
			var pk:SendGetGem = new SendGetGem(idSlot);
			Exchange.GetInstance().Send(pk);
			//cập nhật logic 2 mảng đan trong GemMgr
			GemMgr.getInstance().levelUp(idSlot);
			var uGem:UpgradingGem = GemMgr.getInstance().getUpgradingGemById(idSlot);
			GemMgr.getInstance().transferUgradingGem(uGem);
			refreshAllGem();
		}
		
		private function quickRefine(idSlot:int, isMoney:Boolean, price:int):void
		{
			var ctnRefine:CtnRefine = this["CtnRefine" + idSlot];
			//var level:int = ctnRefine.uGem.LevelDone;
			var money:Number;
			if (isMoney)
			{
				money = GameLogic.getInstance().user.GetMoney();
				if (money < price)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không có đủ vàng. ", 310, 215, GUIMessageBox.NPC_MERMAID_NORMAL);
					return;
				}
				else
				{
					GameLogic.getInstance().user.UpdateUserMoney(0 - price);
				}
			}
			else
			{
				money = GameLogic.getInstance().user.GetZMoney();
				if (money < price)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
				else
				{
					GameLogic.getInstance().user.UpdateUserZMoney(0 - price);
				}
			}
			var pk:SendQuickUpgrade = new SendQuickUpgrade(idSlot, isMoney);
			Exchange.GetInstance().Send(pk);
			trace("finish luyện đan nhờ quick refine tại slot có id = " + idSlot);
			ctnRefine.finishRefine();
		}
		public function processQuickRefine(oldData:Object):void
		{
			var oldPackage:SendQuickUpgrade = oldData as SendQuickUpgrade;
			var idSlot:int = oldPackage["GemId"];
			//var ctnRefine:CtnRefine = this["CtnRefine" + idSlot];
			GemMgr.getInstance().quickRefine(idSlot);
			
		}
		private function smartSort():void
		{
			//trace("sắp xếp nhanh mảng đan: phế -> element -> level -> num");
			GemMgr.getInstance().smartSort();
			refreshGemBox();
		}
		private function delGem():void
		{
			trace(curCtnId);
			if (curCtnId)
			{
				var data:Array = curCtnId.split("_");
				var command:String = data[0];
				if (command == ID_CELL)
				{
					guiConfirmDelGem.Data = data[1] + "_" + data[2] + "_" + data[3] + "_" + data[4];
					guiConfirmDelGem.Show(Constant.GUI_MIN_LAYER, 5);
				}
				else
				{
					trace("không thể xóa đan");
				}
			}
		}
		
		/**
		 * xóa tất cả đan phế
		 */
		public function delAllGem():void 
		{
			var listDel:Array = [];
			var g:Object;
			var listGem:Array = GemMgr.getInstance().GemArr;
			var len:int = listGem.length;
			var i:int;
			var gem:Gem;
			for (i = 0; i < len; i++)
			{
				gem = listGem[i] as Gem;
				if (gem.IsExpired)
				{
					g = new Object();
					g["Element"] = gem.Element;
					g["GemId"] = gem.Level;
					g["Day"] = gem.DayLife;
					g["Num"] = gem.Num;
					listDel.push(g);
				}
			}
			len = listDel.length;
			if (len > 0)
			{
				var pk:SendDeleteGem = new SendDeleteGem(listDel);
				Exchange.GetInstance().Send(pk);
			}
			//xử lý xóa luôn trên client
			for (i = 0; i < len; i++)
			{
				g = listDel[i];
				gem = new Gem(g["Element"], g["GemId"], g["Day"], g["Num"]);
				GemMgr.getInstance().delGem(gem);
			}
			refreshGemBox();
		}
		
		public function processDelGem(oldData:Object):void
		{
			var lstGem:Array = (oldData as SendDeleteGem).ListGem;
			var obj:Object = lstGem[0];
			var gem:Gem = new Gem(obj["Element"], obj["GemId"], obj["Day"], obj["Num"]);
			GemMgr.getInstance().delGem(gem);
			refreshGemBox();
		}
		private function recoverGem():void
		{
			trace(curCtnId);
			if (curCtnId && arrow.img.visible)
			{
				var data:Array = curCtnId.split("_");
				var command:String = data[0];
				if (command == ID_CELL)
				{
					var szData:String = data[1] + "_" + data[2] + "_" + data[3] + "_" + data[4];
					var objStatic:Object = config[(int)(data[2])];
					guiRecoverGem.initGem(szData, objStatic);
					guiRecoverGem.Show(Constant.GUI_MIN_LAYER, 5);
				}
				else
				{
					trace("không thể khôi phục đan");
				}
			}
			else
			{
				trace("không thể khôi phục đan");
			}
		}
		public function processRecoverGem(oldData:Object):void
		{
			var lstGem:Array = (oldData as SendRecoverGem).ListGem;
			var obj:Object = lstGem[0];
			var gem:Gem = new Gem(obj["Element"], obj["GemId"], obj["Day"], obj["Num"]);
			GemMgr.getInstance().recoverGem(gem);
			refreshGemBox();
		}
		private function cancelRefiningGem(idSlot:int):void
		{
			//hiện gui confirm
			guiConfirmCancelUpgrade.IdSlot = idSlot;
			guiConfirmCancelUpgrade.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public function processCanCelUpgrading(idSlot:int):void
		{
			/*cập nhật lại 2 mảng logic nếu hủy luyện thành công*/
			//var uGem:UpgradingGem = GemMgr.getInstance().getUpgradingGemById(idSlot);
			//GemMgr.getInstance().transferUgradingGem(uGem);
			//refreshAllGem();
		}
		
		override public function OnButtonDown(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var gem:Gem;
			var curTime:Number;
			
			switch(cmd)
			{
				case ID_CELL://mouse down cell
					var curCell:CtnGem = getCtnGem(buttonID);
					curCtnId = buttonID;
					btnDelete.clearTooltip();
					if (preCell!=null)
					{
						preCell.SetHighLight( -1);
					}
					curCell.SetHighLight();
					preCell = curCell;
					
					arrow.img.visible = false;
					gem = new Gem((int)(data[1]), (int)(data[2]), (int)(data[4]), (int)(data[3]));
					var indexCell:int = (int)(data[5]);
					curTime = GameLogic.getInstance().CurServerTime;
					if (curTime-clickTime < DOUBLE_CLICK_TIME && curGem.equal(gem))
					{
						doubleClickGem(indexCell, gem);
						clickTime = -1;
						return;
					}
					curGem = gem;
					clickTime = -1;
					if (!gem.IsExpired)
					{
						isFromGemBox = true;
						if (curGem.Level == MAX_GEM_LEVEL)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Không luyện được nữa!\n Sử dụng cho ngư chiến thui!", 310, 215, GUIMessageBox.NPC_MERMAID_WAR);
							return;
						}
						beginDrag(gem, event.stageX - 50, event.stageY);
					}
					else
					{
						arrow.img.visible = true;
					}
				break;
				case CTN_REFINE_SOURCE:
					var ctnGem:CtnRefine = this["CtnRefine" + data[1]] as CtnRefine;
					if (ctnGem.uGem == null) return;
					curTime = GameLogic.getInstance().CurServerTime;
					if (curTime - clickTime < DOUBLE_CLICK_TIME)
					{
						GemMgr.getInstance().transferUgradingGem(ctnGem.uGem);
						refreshAllGem();
						clickTime = -1;
						return;
					}
					clickTime = -1;
					curUpgradingGem = ctnGem.uGem;
					gem = ctnGem.uGem.ListGemSource[0] as Gem;
					isFromGemBox = false;
					beginDrag(gem, event.stageX - 50, event.stageY);
				break;
				default:
					break;
			}
		}
		
		private function beginDrag(gem:Gem,startX:int,startY:int):void
		{
			var imgName:String = Ultility.GetNameImgPearl(gem.Element, gem.Level);
			imgDrag = new Image(img, imgName);
			imgDrag.img.x = startX;
			imgDrag.img.y = startY;
			imgDrag.img.startDrag();
			//add mouse up event
			img.addEventListener(MouseEvent.MOUSE_UP, dropGem);
		}
		
		private function dropGem(event:MouseEvent):void
		{
			clickTime = GameLogic.getInstance().CurServerTime;
			imgDrag.img.stopDrag();
			var ctnRefine:CtnRefine;
			for (var i:int = 0; i < 3; i++)
			{
				ctnRefine = this["CtnRefine" + i] as CtnRefine;
				if (ctnRefine.img.hitTestObject(imgDrag.img))//cái viên đan lơ lửng trên cái container
				{
					if (isFromGemBox)
					{
						var gem1:Gem = curGem.clone();
						GemMgr.getInstance().transferGem(curGem);
						refreshAllGem();
						//addAllUpgradingGem();
						//transferGem(gem1);
					}
				}
			}
			if (!isFromGemBox)//drag từ gui luyện sang gui đan
			{
				if (Content.hitTestObject(imgDrag.img))
				{
					GemMgr.getInstance().transferUgradingGem(curUpgradingGem);
					refreshAllGem();
				}
			}
			img.removeChild(imgDrag.img);
			img.removeEventListener(MouseEvent.MOUSE_UP, dropGem);
			imgDrag = null;
		}
		
		private function doubleClickGem(indexCell:int, gem:Gem):void
		{
			var gem1:Gem = gem.clone();
			GemMgr.getInstance().transferGem(gem);
			//refreshAllGem();
			addAllUpgradingGem();
			transferGem(indexCell);
		}

		private function transferGem(index:int):void
		{
			curCtnId = null;
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Vui lòng chọn đan muốn hủy";
			btnDelete.setTooltip(tip);
			var i:int;
			var isClear:Boolean = true;
			var ctnGem:CtnGem = CtnGemArr[index] as CtnGem;
			var gemInCtn:Gem = ctnGem.gem.clone();
			
			if (GemMgr.getInstance().GemArr[index] != null)
			{
				var gemLogic:Gem = (GemMgr.getInstance().GemArr[index] as Gem).clone();
				if (gemInCtn.Element == gemLogic.Element && 
					gemInCtn.Level == gemLogic.Level && 
					gemInCtn.DayLife == gemLogic.DayLife)
				{
					ctnGem.ClearComponent();
					ctnGem.initData(gemLogic, config[gemLogic.Level], index);
					ctnGem.drawGem(this);
					isClear = false;
					return;
				}
			}
			ctnGem.Clear();
			removeCtnGem(index);
		}
		private function appendEmptySlot():void
		{
			var ctnGem:CtnGem = new CtnGem(Content, "GuiPearlRefine_Img_Cell_TuLuyenNgoc");
			var index:int = CtnGemArr.length;
			ctnGem.initData(null, null, index);
			ctnGem.drawGem(this);
			CtnGemArr.push(ctnGem);
		}
		override public function Clear():void 
		{
			removeAllCtnGem();
			super.Clear();
		}
		
		private function clearAllRefineBox():void
		{
			var i:int;
			for (i = 0; i < 3; i++)
			{
				if (this["CtnRefine" + i])
				{
					var ctnRefine:CtnRefine = this["CtnRefine" + i] as CtnRefine;
					ctnRefine.Destructor();
				}
			}
		}
		
		private function removeAllCtnGem():void
		{
			var i:int;
			for (i = 0; i < CtnGemArr.length; i++)
			{
				var ctnGem:CtnGem = CtnGemArr[i] as CtnGem;
				ctnGem.Destructor();
			}
			CtnGemArr.splice(0, CtnGemArr.length);
		}
		
		private function getCtnGem(id:String):CtnGem
		{
			for (var i:int = 0; i < CtnGemArr.length; i++)
			{
				var ctnGem:CtnGem = CtnGemArr[i] as CtnGem;
				if (ctnGem.IdObject == id)
				{
					return CtnGemArr[i] as CtnGem;
				}
			}
			return null;
		}
		
		public function updateGUI():void 
		{
			var curTime:int = GameLogic.getInstance().CurServerTime;
			var s:int = curTime - timeGui;
			if (s >= 1)
			{
				updateRefiningGem();
				timeGui = curTime;
			}
		}
		
		public function updateRefiningGem():void
		{
			var i:int;
			var lstUGem:Array = GemMgr.getInstance().UpgradingGemArr;
			var leng:int = lstUGem.length;
			for (i = 0; i < leng; i++)
			{
				var uGem:UpgradingGem = lstUGem[i] as UpgradingGem;
				if (uGem.StepRefine == -1 || uGem.JustRefined) continue;
				var idSlot:int = uGem.SlotId;
				var ctnRefine:CtnRefine = this["CtnRefine" + idSlot] as CtnRefine;
				if (ctnRefine)
				{
					ctnRefine.updateRefine();
				}
			}
		}
		
		public function refreshAllGem():void
		{
			addAllUpgradingGem();
			refreshGemBox();
		}
		
		public function refreshGemBox():void
		{
			addAllGem();
			curCtnId = null;
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Vui lòng chọn đan muốn hủy";
			btnDelete.setTooltip(tip);
			arrow.img.visible = false;
		}
		
		private function removeCtnGem(index:int):void
		{
			CtnGemArr.splice(index, 1);
			updateAllGemPos();
			appendEmptySlot();
			var lengLogic:int = GemMgr.getInstance().GemArr.length;
			if (lengLogic == CtnGemArr.length - 5 && lengLogic > 30)
			{
				for (var i:int = lengLogic; i < lengLogic + 5; i++)
				{
					var ctnGem:CtnGem = CtnGemArr[i] as CtnGem;
					Content.removeChild(ctnGem.img);
				}
				CtnGemArr.splice(lengLogic, 5);
				_scroll.source = Content;
			}
		}
		
		private function updateAllGemPos():void
		{
			var length:int = CtnGemArr.length;
			var i:int;
			for (i = 0; i < length; i++)
			{
				updateGemPos(i);
			}
		}
		
		private function updateGemPos(index:int):void
		{
			var ctnGem:CtnGem = CtnGemArr[index] as CtnGem;
			ctnGem.Index = index;
		}
		
		private function checkCookie(nameCookie:String = "OpenGemGUI"):void
		{
			var id:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var fileName:String = nameCookie + id;
			var so:SharedObject = SharedObject.getLocal(fileName);
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var date:Date = new Date(curTime * 1000);
			var today:String = date.getDate() + "-" + date.getMonth() + "-" + date.getFullYear();
			if (so.data.lastDay != null)
			{
				var lastDay:String = so.data.lastDay;
				if (lastDay != today)
				{
					so.data.lastDay = today;
					guiGuide.ShowGui();
				}
			}
			else
			{
				so.data.lastDay = today;
				guiGuide.ShowGui();
			}
			Ultility.FlushData(so);
		}
		
		override public function OnHideGUI():void 
		{
			arrow.img.visible = false;
			arrow.Destructor();
			super.OnHideGUI();
			
			//tắt đi thì mới bật phần nhận thưởng quest
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
		}
		
		
	}
}
































