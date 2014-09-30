package Event.EventIceCream 
{
	import adobe.utils.CustomActions;
	import com.adobe.images.BitString;
	import com.adobe.utils.IntUtil;
	import com.bit101.components.Text;
	import com.greensock.easing.Cubic;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.motionPaths.MotionPath;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Event.EventIceCream.NetworkPacket.SendBuyItemByDiamond;
	import Event.EventIceCream.NetworkPacket.SendIceCreamBuyItem;
	import Event.EventIceCream.NetworkPacket.SendIceCreamCreateIceCream;
	import Event.EventIceCream.NetworkPacket.SendIceCreamHarvest;
	import Event.EventIceCream.NetworkPacket.SendIceCreamMakeKeavyRain;
	import Event.EventIceCream.NetworkPacket.SendIceCreamMakeRain;
	import Event.EventIceCream.NetworkPacket.SendIceCreamTheft;
	import Event.EventMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.GUIMain;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.CometEmit;
	import particleSys.myFish.IceCreamEmit;
	import particleSys.myFish.WaveEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMainEventIceCream extends BaseGUI 
	{
		public const CTN_ITEM:String = "CtnItem_";
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_HELP:String = "BtnHelp";
		public const BTN_DESTROY_ICE_CREAM:String = "BtnDestroyIceCream_";
		public const BTN_BUY_FAST_ITEM:String = "BtnBuyFastItem_";
		public const BTN_USE_FAST_ITEM:String = "BtnUseFastItem_";
		public const BTN_BUY_FAST_ITEM_BY_DIAMOND:String = "BtnBuyFastItemByDiamond_";
		public const BTN_PLAY_FAST:String = "BtnPlayFast_";
		public const BTN_CREATE_RAIN_ICE_CREAM:String = "BtnCreateIceCream";
		public const BTN_BUY_SHAVED_ICE:String = "BtnBuyFastItem_4";
		public const BTN_BUY_RAIN_HEAVY:String = "BtnBuyRain";
		public const CTN_SLOT_ICE_CREAM:String = "CtnSlotIceCream_";
		public const PRG_SLOT_ICE_CREAM:String = "PrgSlotIceCream";
		public const IMG_SHAVED_ICE:String = "ImgShavedIce";
		public const IMG_LABEL_SHAVED_ICE:String = "ImgLabelShavedIce";
		public const IMG_LOCK:String = "ImgLock";
		public const IMG_HELP:String = "ImgHelp";
		public const IMG_BG_BUY_FAST_ITEM:String = "ImgBgBuyFastItem";
		public const IMG_CONTENT_ICE_CREAM:String = "ImgContentIceCream_";
		public const MAX_SLOT_ICE_CREAM:int = 14;
		public const MAX_ITEM_CAN_BUY:int = 3;
		
		public var DataIceCream:Object;
		public var imgHelp:Image = null;
		public var arrCtnSlotIcream:Array = [];
		public var arrObjHelp:Array = [];
		public var arrDataIceCream:Array = [];
		public var arrTextItemHave:Array = [];
		public var arrTextTimeNeed:Array = [];
		public var arrProgressBarIceCream:Array = [];
		public var arrNumItem:Array = [];
		public var arrNumItemLogic:Array = [];
		public var numSlotOpened:int = 7;
		public var numShavedIce:int = 0;
		public var numShavedIcePerRain:int = 10;
		public var txtNumShavedIce:TextField;
		public var txtNumRainHeavy:TextField;
		public var txtTimeLeftRain:TextField = null;
		public var isLoadContentOK:Boolean = false;
		public var idCurProcess:String = "";
		public var isCanShowRain:Boolean = false;
		
		public function GUIMainEventIceCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMainEventIceCream";
		}
		
		override public function InitGUI():void
		{
			if (DataIceCream == null)	return;
			FakeData();
			this.setImgInfo = function():void
			{
				if(!isLoadContentOK)
				{
					SetPos(17, 8);
					AddButton(BTN_CLOSE, "BtnThoat", 655, 30, this);
					AddButton(BTN_HELP, "EventIceCream_BtnGuide", 620, 30, this);
					isLoadContentOK = true;
					OpenRoomOut();
				}
			}
			isLoadContentOK = false;
			LoadRes("EventIceCream_ImgBgGuiMyEventIceCream");
		}
		
		public var arrTxtBuyG:Array = [];
		override public function EndingRoomOut():void 
		{
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			
			arrTxtBuyG.splice(0, arrTxtBuyG.length);
			// Add các slot để làm kem
			if (GameLogic.getInstance().user.IsViewer())
			{
				Clear();
				LoadRes("EventIceCream_ImgBgGuiMyEventIceCreamFriend");
				SetPos(40, 0);
				AddButton(BTN_CLOSE, "BtnThoat", 655, 30, this);
			}
			AddImage(IMG_LABEL_SHAVED_ICE, "ImgLabelShavedIce", 290, 90, true, ALIGN_LEFT_TOP).img.visible = false;
			var i:int = 0;
			var ctn:Container;
			var startX:int = 85, startY:int = 250;
			var deltaX:int = 86, deltaY:int = 76;
			var dx:int, dy:int;
			var txtFormat:TextFormat;
			var txtFormatG:TextFormat;
			arrCtnSlotIcream = [];
			var objDataIceCream:Object;
			for (i = 0; i < MAX_SLOT_ICE_CREAM; i++) 
			{
				dx = (i % 7) * deltaX;
				dy = Math.floor(i / 7) * deltaY;
				ctn = AddContainer(CTN_SLOT_ICE_CREAM + i, "EventIceCream_ImgBgSlot", startX + dx, startY + dy, true, this);
				ctn.AddButton(BTN_DESTROY_ICE_CREAM + i, "BtnThoat", 60, -45, this);
				ctn.GetButton(BTN_DESTROY_ICE_CREAM + i).SetVisible(false);
				ctn.AddImage(IMG_LOCK, "EventIceCream_ImgLock", 24, -5, true, ALIGN_LEFT_TOP);
				
				objDataIceCream = DataIceCream[String(i + 1)];
				if(objDataIceCream != null)
				{
					ctn.GetImage(IMG_LOCK).img.visible = false;
					ctn.img.buttonMode = true
					arrCtnSlotIcream.push(ctn);
					//if (i < arrDataIceCream.length)
					if (objDataIceCream is Array)
					{
						continue;
					}
					else
					{
						objDataIceCream.IdContainerShow = ctn.IdObject;
						// idObject = ***_indexCtn_idIceCream
						ctn.AddImage(IMG_CONTENT_ICE_CREAM, "EventIceCream_Item" + objDataIceCream.ItemId, 52, 15, true, ALIGN_CENTER_CENTER );
						// add thời gian còn lại mà còn phải chờ
						txtFormat = new TextFormat();
						var numTimeLeft:int = GetTimeNeed(objDataIceCream.StartTime, objDataIceCream.LifeTime, objDataIceCream.IsSuccess);
						var stateCtn:int = GetStateIceCream(objDataIceCream.StartTime, objDataIceCream.LifeTime, objDataIceCream.IsSuccess);
						if (stateCtn == 4 && objDataIceCream.IceCreamNum > 0)	stateCtn = 5;
						(ctn.GetImage(IMG_CONTENT_ICE_CREAM).img as MovieClip).gotoAndStop(stateCtn);
						var hour:int = numTimeLeft / 3600;
						var strHour:String = hour.toString();
						if (hour < 10 && hour >= 0)	strHour = "0" + hour.toString();
						
						var min:int = (numTimeLeft - Math.floor(numTimeLeft / 3600) * 3600) / 60;
						var strMin:String = min.toString();
						if (min < 10 && min >= 0)	strMin = "0" + min.toString();
						
						var sec:int = numTimeLeft - Math.floor(numTimeLeft / 60) * 60;
						var strSec:String = sec.toString();
						if (sec < 10 && sec >= 0)	strSec = "0" + sec.toString();
						
						var prg:ProgressBar = ctn.AddProgress(PRG_SLOT_ICE_CREAM, "EventIceCream_PrgTime", 2, 27, this, true);
						arrProgressBarIceCream.push(prg);
						prg.setStatus(1 - numTimeLeft / objDataIceCream.LifeTime);
						
						var txtField:TextField = ctn.AddLabel(strHour + ":" + strMin + ":" + strSec, -15, 25);
						if (numTimeLeft <= 0)
						{
							txtField.text = "Hoàn thành";
						}
						txtFormat = new TextFormat();
						txtFormat.size = 12;
						txtFormat.color = 0x000000;
						txtField.setTextFormat(txtFormat);
						txtField.defaultTextFormat = txtFormat;
						arrTextTimeNeed.push(txtField);
					}
				}
			}
			if (!GameLogic.getInstance().user.IsViewer())
			{
				// add các nút khác - nút
				//AddButton(BTN_CREATE_RAIN_ICE_CREAM, "BtnCreatIce", 323, 412, this);
				AddButton(BTN_CREATE_RAIN_ICE_CREAM, "BtnCreatIce", 402, 383, this);
				AddButton(BTN_BUY_SHAVED_ICE, "BtnBuyG", 610, 406, this);
				var imgShavedIce:Image = AddImage(IMG_SHAVED_ICE, "EventIceCream_ShavedIce", 245, 385, true, ALIGN_LEFT_TOP);
				imgShavedIce.img.addEventListener(MouseEvent.ROLL_OVER, onMouseMoveShavedIce);
				imgShavedIce.img.addEventListener(MouseEvent.ROLL_OUT, onMouseOutShavedIce);
				// Add các component khi mua nhanh các vật phẩm
				var ctn2:Container;
				//deltaX = 113; deltaY = 0; startX = 219; startY = 448;
				deltaX = 113; deltaY = 0; startX = 219; startY = 420;
				for (i = 0; i < MAX_ITEM_CAN_BUY; i++) 
				{
					dx = deltaX * i; dy = 0;
					AddButton(BTN_BUY_FAST_ITEM + (i + 1), "BtnBuyG", 14 + startX + dx, 110 + startY + dy, this);
					AddButton(BTN_USE_FAST_ITEM + (i + 1), "BtnUseIceCrean", 14 + startX + dx, 110 + startY + dy, this).SetVisible(false);
					AddButton(BTN_BUY_FAST_ITEM_BY_DIAMOND + (i + 1), "BtnBuyByDiamond", 14 + startX + dx, 140 + startY + dy, this);
					ctn2 = AddContainer(CTN_ITEM + i, "EventIceCream_ImgBgSlotBuy", startX + dx, startY + dy, true, this);
					(ctn2.AddImage("", "EventIceCream_Item" + (i + 1), 64, 70, true, ALIGN_CENTER_CENTER).img as MovieClip).gotoAndStop(0);
					
					txtFormat = new TextFormat();
					txtFormat.color = 0xFAE638;
					txtFormat.bold = true;
					txtFormat.size = 14;
					txtFormat.align = "center";
					txtFormatG = new TextFormat();
					txtFormatG.color = 0x264904;
					txtFormatG.bold = true;
					txtFormatG.size = 13;
					txtFormatG.align = "center";
					var txtG:TextField = AddLabel("Mua" + objConfig1[String(i + 1)].ZMoney, -8 + startX + dx, 111 + startY + dy);
					txtG.setTextFormat(txtFormatG);
					txtG.defaultTextFormat = txtFormatG;
					arrTxtBuyG.push(txtG);
					var txtDiamond:TextField = AddLabel(objConfig1[String(i + 1)].Diamond, 10 + startX + dx, 141 + startY + dy);
					txtDiamond.setTextFormat(txtFormatG);
					txtDiamond.defaultTextFormat = txtFormatG;
					var txtItemHave:TextField = ctn2.AddLabel("x" + Ultility.StandardNumber(arrNumItem[i]), 30, 80, 0x264904, 1, 0x000000);
					txtItemHave.setTextFormat(txtFormat);
					txtItemHave.defaultTextFormat = txtFormat;
					arrTextItemHave.push(txtItemHave);
					var strToolTip:String;
				}
				AddButton(BTN_BUY_RAIN_HEAVY, "BtnBuyRain", 575, 509, this);
				if (int(DataIceCream.Rain.HeavyRain) <= 0)
				{
					GetButton(BTN_BUY_RAIN_HEAVY).SetDisable();
				}
				txtFormat = new TextFormat();
				if (numShavedIce >= numShavedIcePerRain)
				{
					txtFormat.color = 0x00FF00;
				}
				else 
				{
					txtFormat.color = 0xFF0000;
				}
				
				txtFormat.bold = true;
				txtFormat.size = 14;
				txtFormat.align = "center";
				txtNumShavedIce = AddLabel(numShavedIce + "/" + numShavedIcePerRain , 275, 391);
				txtNumShavedIce.setTextFormat(txtFormat);
				txtNumShavedIce.defaultTextFormat = txtFormat;
				
				txtFormat = new TextFormat();
				txtFormat.color = 0xFAE638;
				txtFormat.bold = true;
				txtFormat.size = 14;
				txtFormat.align = "center";
				txtNumRainHeavy = AddLabel(String(DataIceCream.Rain.HeavyRain) , 585, 537);
				txtNumRainHeavy.setTextFormat(txtFormat);
				txtNumRainHeavy.defaultTextFormat = txtFormat;
				
				var txtG1:TextField = AddLabel("Mua" + objConfig1[String(i + 1)].ZMoney, 586, 407);
				txtG1.setTextFormat(txtFormatG);
				txtG1.defaultTextFormat = txtFormatG;
				
				var txtG2:TextField = AddLabel(objConfig2.HeavyRainZMoney, 602, 510);
				txtG2.setTextFormat(txtFormatG);
				txtG2.defaultTextFormat = txtFormatG;
			}
			else
			{
				AddLabel("Click vào que kem để ăn trộm!", 100, 120, 0xFFFFFF, 1, 0x000000);
			}
			isCanShowRain = true;
			UpdateBtnBuyUse();
		}
		
		public function UpdateBtnBuyUse():void 
		{
			if (GameLogic.getInstance().user.IsViewer())	return;
			for (var i:int = 0; i < MAX_ITEM_CAN_BUY; i++) 
			{
				if (arrNumItem[i] > 0)
				{
					GetButton(BTN_BUY_FAST_ITEM + (i + 1)).SetVisible(false);
					(arrTxtBuyG[i] as TextField).visible = false;
					GetButton(BTN_USE_FAST_ITEM + (i + 1)).SetVisible(true);
				}
				else
				{
					GetButton(BTN_BUY_FAST_ITEM + (i + 1)).SetVisible(true);
					(arrTxtBuyG[i] as TextField).visible = true;
					GetButton(BTN_USE_FAST_ITEM + (i + 1)).SetVisible(false);
				}
			}
		}
		
		private var ttShavedIce:TooltipFormat;
		public function onMouseOutShavedIce(event:MouseEvent):void 
		{
			if (ttShavedIce != null)
			{
				ActiveTooltip.getInstance().clearToolTip();
			}
		}
		
		public function onMouseMoveShavedIce(event:MouseEvent):void 
		{
			if (ttShavedIce == null)
			{
				ttShavedIce = new TooltipFormat();
				ttShavedIce.text = Localization.getInstance().getString("Tooltip93");
			}
			ActiveTooltip.getInstance().showNewToolTip(ttShavedIce, GetImage(IMG_SHAVED_ICE).img);
		}
		
		public var idItemUse:int = -1;
		public var isStartDrag:Boolean = false;
		override public function OnButtonDown(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_ITEM) >= 0)
			{
				idItemUse = int(buttonID.split("_")[1]) + 1;
				isStartDrag = true;
				var imageContent:Image = GetContainer(buttonID).ImageArr[0];
				GameLogic.getInstance().MouseTransform(imageContent.ImgName);
			}
		}
		
		override public function OnButtonUp(event:MouseEvent, buttonID:String):void 
		{
			if (isStartDrag)
			{
				if(waitDataServerSuccess < 0)
				{
					if (buttonID.search(CTN_SLOT_ICE_CREAM) >= 0)
					{
						ProcessChooseItemCreateCream(buttonID);
					}
					else 
					{
						ProcessChooseItemCreateCream();
					}
					UpdateBtnBuyUse();
				}
			}
		}
		
		public function GetStateIceCream(StartTime:Number, LifeTime:Number, isHaveHeavyRain:Boolean = false):int
		{
			var timeLiveInRain:Number = GetTimeLiveInRain(StartTime);
			if (isHaveHeavyRain)
			{
				timeLiveInRain = LifeTime;
			}
			return Math.min(Math.floor(timeLiveInRain / LifeTime * 3), 3) + 1;
		}
		
		/**
		 * Hàm xử lý cho nguyên liệu vào slot chế tạo kem. buttonId
		 * @param	buttonId
		 */
		public function ProcessChooseItemCreateCream(buttonId:String = ""):void 
		{
			if (waitDataServerSuccess >= 0)	return;
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			
			var txtFormat:TextFormat;
			if (isStartDrag == false || idItemUse == -1)	return;
			if (idItemUse >= 4)	return;
			isStartDrag = false;
			GameLogic.getInstance().MouseTransform();
			// Thực hiện trừ nguyên liệu trong kho đi
			// Thiện hiện cập nhật data logic với các slot đang làm kem
			// Thực hiện show lên GUI
			var ctn:Container = GetContainerProcess(buttonId);
			if (ctn == null || ctn.GetImage(IMG_LOCK).img.visible)	return;
			if (arrNumItem[(idItemUse - 1)] <= 0)
			{
				var posStart:Point;
				var posEnd:Point;
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				txtFormat = new TextFormat(null, 14, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
				var str:String = Localization.getInstance().getString("Tooltip85");
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
				return;
			}
			GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", idItemUse, -1);
			var cmd:SendIceCreamCreateIceCream = new SendIceCreamCreateIceCream(int(ctn.IdObject.split("_")[1]) + 1, idItemUse)
			Exchange.GetInstance().Send(cmd);
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffChooseIceCream", null, 
				ctn.GetPosition().x + ctn.img.width / 2 + 5, ctn.GetPosition().y + ctn.img.height / 2 - 20);
			
			// Cập nhật dữ liệu vào logic
			var slotId:int = int(ctn.IdObject.split("_")[1]) + 1;
			var arr:Array = [1800, 3600, 180];
			var obj:Object = new Object();
			obj.IceCreamNum = 0;
			obj.IdContainerShow = ctn.IdObject;
			obj.IsSuccess = false;
			obj.ItemId = idItemUse;
			obj.StartTime = GameLogic.getInstance().CurServerTime;
			obj.TheftList = new Array();
			obj.LifeTime = objConfig1[idItemUse.toString()].Time;
			DataIceCream[slotId.toString()] = obj;
			
			ctn.AddImage(IMG_CONTENT_ICE_CREAM, "EventIceCream_Item" + obj.ItemId, 52, 15, true, ALIGN_CENTER_CENTER );
			txtFormat = new TextFormat();
			var numTimeLeft:int = GetTimeNeed(obj.StartTime, obj.LifeTime);
			var stateCtn:int = GetStateIceCream(obj.StartTime, obj.LifeTime, obj.IsSuccess);
			if (stateCtn == 4 && obj.NumIceCream > 0)	stateCtn = 5;
			(ctn.GetImage(IMG_CONTENT_ICE_CREAM).img as MovieClip).gotoAndStop(stateCtn);
			var hour:int = numTimeLeft / 3600;
			var strHour:String = hour.toString();
			if (hour < 10 && hour >= 0)	strHour = "0" + hour.toString();
			
			var min:int = (numTimeLeft - Math.floor(numTimeLeft / 3600) * 3600) / 60;
			var strMin:String = min.toString();
			if (min < 10 && min >= 0)	strMin = "0" + min.toString();
			
			var sec:int = numTimeLeft - Math.floor(numTimeLeft / 60) * 60;
			var strSec:String = sec.toString();
			if (sec < 10 && sec >= 0)	strSec = "0" + sec.toString();
			
			var prg:ProgressBar = ctn.AddProgress(PRG_SLOT_ICE_CREAM, "EventIceCream_PrgTime", 2, 27, this, true);
			arrProgressBarIceCream.push(prg);
			prg.setStatus(0);
			
			var txtField:TextField = ctn.AddLabel(strHour + ":" + strMin + ":" + strSec, -15, 25);
			//txtField.textHeight = 12;
			txtFormat = new TextFormat();
			txtFormat.size = 12;
			txtFormat.color = 0x000000;
			txtField.setTextFormat(txtFormat);
			txtField.defaultTextFormat = txtFormat;
			arrTextTimeNeed.push(txtField);
			
			// Cập nhật số nguyên liệu còn lại vào logic và hiển thị
			var i:int = 0;
			for (i = 0; i < arrNumItem.length; i++) 
			{
				if ((i + 1) == idItemUse)
				{
					//arrNumItemLogic[i].Num = arrNumItemLogic[i].Num - 1;
					arrNumItem[i] --;
					break;
				}
			}
			var ctn2:Container = GetContainer(CTN_ITEM + String(idItemUse - 1));
			if(ctn2 != null)
			{
				(ctn2.LabelArr[0] as TextField).text = "x" + Ultility.StandardNumber(arrNumItem[(idItemUse - 1)]);
			}
			
			idItemUse = -1;
		}
		
		public function GetContainerProcess(buttonId:String = ""):Container
		{
			var ctn:Container;
			if (buttonId != "")
			{
				ctn = GetContainer(buttonId);
				if (!ctn.GetImage(IMG_LOCK).img.visible && (ctn.GetImage(IMG_CONTENT_ICE_CREAM) == null))
				{
					return GetContainer(buttonId);
				}
				else 
				{
					return null;
				}
			}
			else
			{
				for (var i:int = 0; i < arrCtnSlotIcream.length; i++) 
				{
					ctn = GetContainer(CTN_SLOT_ICE_CREAM + i);
					if (!ctn.GetImage(IMG_LOCK).img.visible && (ctn.GetImage(IMG_CONTENT_ICE_CREAM) == null))
					{
						return ctn;
					}
				}
				return null;
			}
		}
		
		public var deltaTimeDoubleClick:Number = 0.25;
		public var lastTimeClick:Number = -1;
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if(EventMgr.CheckEvent("IceCream") != EventMgr.CURRENT_IN_EVENT)
			{
				//if (this != null)
				{
					var posStart:Point;
					var posEnd:Point;
					var txtFormat:TextFormat;
					var str:String;
					posStart = GameInput.getInstance().MousePos;
					posEnd = new Point(posStart.x, posStart.y - 100);
					txtFormat = new TextFormat(null, 14, 0xFF0000);
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					str = "Đã hết thời gian diễn ra event ~,~";
					Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
					this.Hide();
					if (GuiMgr.getInstance().GuiToolTipIcreCream.IsVisible)	GuiMgr.getInstance().GuiToolTipIcreCream.Hide();
					if (GameLogic.getInstance().user.machineMakeIceCream != null)	GameLogic.getInstance().user.machineMakeIceCream.Destructor();
				}
				return;
			}
			
			if (waitDataServerSuccess >= 0)	return;
			
			
			if (GuiMgr.getInstance().GuiToolTipIcreCream.IsVisible)
			{
				GuiMgr.getInstance().GuiToolTipIcreCream.Hide();
			}
			if (arrObjHelp != null && arrObjHelp.length > 0) 
			{
				var obj:Object = arrObjHelp[0];
				if (buttonID == obj.Id)
				{
					imgHelp.img.parent.removeChild(imgHelp.img);
					imgHelp.Destructor();
					imgHelp = null;
					arrObjHelp.splice(0, 1);
				}
			}
			// Check double click
			var curTimeServer:Number = GameLogic.getInstance().CurServerTime;
			if (buttonID.search(CTN_ITEM) >= 0)
			{
				if (lastTimeClick == -1)
				{
					lastTimeClick = curTimeServer;
				}
				else
				{
					if (curTimeServer - lastTimeClick < deltaTimeDoubleClick)
					{
						MouseDoubleClick(buttonID);
					}
					lastTimeClick = -1;
				}
				return;
			}
			
			//Click mua item
			if(waitDataServerSuccess < 0)
			{
				if (buttonID.search(BTN_BUY_FAST_ITEM) >= 0 || buttonID.search(BTN_BUY_FAST_ITEM_BY_DIAMOND) >= 0)
				{
					doBuyItem(buttonID);
					idItemUse = buttonID.split("_")[1];
					isStartDrag = true;
					ProcessChooseItemCreateCream();
				}
				else if (buttonID.search(BTN_USE_FAST_ITEM) >= 0 ) 
				{
					idItemUse = buttonID.split("_")[1];
					isStartDrag = true;
					ProcessChooseItemCreateCream();
				}
				UpdateBtnBuyUse();
			}
			MouseClick(buttonID);
		}
		
		public var countBuyItem:int = 0;
		public var MaxItemCanBuy:Object;
		public function doBuyItem(buttonId:String):void 
		{		
			var isDiamond:Boolean = false;
			if (buttonId.search(BTN_BUY_FAST_ITEM_BY_DIAMOND) >= 0)
			{
				isDiamond = true;
			}
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			var maxItemCanBuy:Object = objConfig2.MaxItemCanBuy;
			var maxNumItemCanBuy:int = maxItemCanBuy[String(buttonId.split("_")[1])];
			
			var objTemp:Object = new Object();
			objTemp["ItemType"] = "IceCreamItem";
			objTemp["Event"] = "IceCream";
			objTemp["ItemId"] = int(buttonId.split("_")[1]);
			objTemp["Num"] = 1;
			objTemp["PriceType"] = "ZMoney";
			if (isDiamond)	objTemp["PriceType"] = true;
			if (MaxItemCanBuy[String(buttonId.split("_")[1])] == null)
			{
				MaxItemCanBuy[String(buttonId.split("_")[1])] = maxNumItemCanBuy;
			}
			
			var posStart:Point;
			var posEnd:Point;
			var txtFormat:TextFormat;
			
			var nowNumItemBuy:int = MaxItemCanBuy[String(buttonId.split("_")[1])];
			if (nowNumItemBuy <= 0 && int(buttonId.split("_")[1]) != 4)
			{
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				txtFormat = new TextFormat(null, 12, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
				var str:String = "Một ngày chỉ được mua tối đa\n" + maxNumItemCanBuy + " nguyên liệu loại này\nHôm nay bạn không thể mua thêm nữa";
				str = str.replace("@Value ", ZMoneyNeed.toString());
				//Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
				GuiMgr.getInstance().GuiMessageBox.ShowOK(str);
				return;
			}
			// cap nhat so luong da mua vao logic
			MaxItemCanBuy[String(buttonId.split("_")[1])] = MaxItemCanBuy[String(buttonId.split("_")[1])] - 1;
			
			var objConfig:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var ZMoneyNeed:int = objConfig[String(buttonId.split("_")[1])].ZMoney;
			var ZMoneyHave:int = GameLogic.getInstance().user.GetZMoney();
			var DiamondNeed:int = objConfig[String(buttonId.split("_")[1])].Diamond;
			var DiamondHave:int = GameLogic.getInstance().user.getDiamond();
			if (isDiamond)
			{
				if (DiamondHave < DiamondNeed)
				{
					GuiMgr.getInstance().guiBuyDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					posStart = GameInput.getInstance().MousePos;
					posEnd = new Point(posStart.x, posStart.y - 100);
					txtFormat = new TextFormat(null, 12, 0xFF0000);
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					var str1:String = "Bạn không đủ kim cương\nđể thực hiện hành động này";
					str1 = str1.replace("@Value ", ZMoneyNeed.toString());
					Ultility.ShowEffText(str1, img, posStart, posEnd, txtFormat, 1, 0xffffff);
				}
				else	
				{
					countBuyItem++;
					var cmd:SendBuyItemByDiamond = new SendBuyItemByDiamond(objTemp);
					Exchange.GetInstance().Send(cmd);
					
					EffectMgr.setEffBounceDown("Mua thành công", "EventIceCream_Item" + objTemp["ItemId"], 330, 280);
					GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", objTemp.ItemId);
					GameLogic.getInstance().user.updateDiamond( -DiamondNeed);
					
					if(int(objTemp.ItemId) <= 3)
					{
						var ctn:Container = GetContainer(CTN_ITEM + (int(objTemp.ItemId) - 1));
						arrNumItem[(int(objTemp.ItemId) - 1)]++;
						(ctn.LabelArr[0] as TextField).text = "x" + Ultility.StandardNumber(arrNumItem[(int(objTemp.ItemId) - 1)]);
					}
					else
					{
						numShavedIce++;
						txtNumShavedIce.text = numShavedIce + "/" + numShavedIcePerRain;
						if (numShavedIce >= numShavedIcePerRain)
						{
							txtNumShavedIce.textColor = 0x00FF00;
						}
						else
						{
							txtNumShavedIce.textColor = 0xFF0000;
						}
					}
				}
			}
			else 
			{
				if (ZMoneyHave < ZMoneyNeed)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					posStart = GameInput.getInstance().MousePos;
					posEnd = new Point(posStart.x, posStart.y - 100);
					txtFormat = new TextFormat(null, 12, 0xFF0000);
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					var str2:String = Localization.getInstance().getString("Tooltip83");
					str2 = str2.replace("@Value ", ZMoneyNeed.toString());
					Ultility.ShowEffText(str2, img, posStart, posEnd, txtFormat, 1, 0xffffff);
				}
				else
				{
					countBuyItem++;
					var cmd1:SendIceCreamBuyItem = new SendIceCreamBuyItem(objTemp);
					Exchange.GetInstance().Send(cmd1);
					
					EffectMgr.setEffBounceDown("Mua thành công", "EventIceCream_Item" + objTemp["ItemId"], 330, 280);
					GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", objTemp.ItemId);
					GameLogic.getInstance().user.UpdateUserZMoney( -ZMoneyNeed);
					
					if(int(objTemp.ItemId) <= 3)
					{
						var ctn1:Container = GetContainer(CTN_ITEM + (int(objTemp.ItemId) - 1));
						arrNumItem[(int(objTemp.ItemId) - 1)]++;
						(ctn1.LabelArr[0] as TextField).text = "x" + Ultility.StandardNumber(arrNumItem[(int(objTemp.ItemId) - 1)]);
					}
					else
					{
						numShavedIce++;
						txtNumShavedIce.text = numShavedIce + "/" + numShavedIcePerRain;
						if (numShavedIce >= numShavedIcePerRain)
						{
							txtNumShavedIce.textColor = 0x00FF00;
						}
						else
						{
							txtNumShavedIce.textColor = 0xFF0000;
						}
					}
				}
			}
		}
		
		public function MouseClick(buttonID:String):void 
		{
			if(waitDataServerSuccess >= 0)
			{
				return;
			}									
			//var obj:Object;
			var i:int = 0;
			if (idCurProcess != "" && idCurProcess != buttonID)
			{
				for (i = 0; i < arrCtnSlotIcream.length; i++) 
				{
					var ctn:Container = arrCtnSlotIcream[i];
					var idBtnDestroy:int = ctn.IdObject.split("_")[1];
					ctn.GetButton(BTN_DESTROY_ICE_CREAM + idBtnDestroy).SetVisible(false);
					idCurProcess = "";
				}
			}
			var slotId:int = int(buttonID.split("_")[1]) + 1;
			var posStart:Point = GameInput.getInstance().MousePos;
			var posEnd:Point = new Point(posStart.x, posStart.y - 100);
			var str:String;
			var txtFormat:TextFormat;
			txtFormat = new TextFormat(null, 14, 0xFF0000);
			txtFormat.align = "center";
			txtFormat.bold = true;
			txtFormat.font = "Arial";
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
				case BTN_HELP:
					GuiMgr.getInstance().GuiHelpIceCream.Show(Constant.GUI_MIN_LAYER, 3);
				break;
				case BTN_BUY_RAIN_HEAVY:
					// particale
					if (int(DataIceCream.Rain.HeavyRain) <= 0)
					{
						GetButton(BTN_BUY_RAIN_HEAVY).SetDisable();
						break;
					}
					
					if (GameLogic.getInstance().user.GetZMoney() < int(objConfig2.HeavyRainZMoney))
					{
						GuiMgr.getInstance().GuiNapG.Init();
						str = Localization.getInstance().getString("Tooltip87");
						str = str.replace("@Value ", String(objConfig2.HeavyRainZMoney));
						Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
					}
					else
					{
						var p1:Point = GetButton(BTN_BUY_RAIN_HEAVY).GetPos(); 
						particalStar(new Point(p1.x + 60, p1.y),new Point(360, 120), new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0), doCreateRainHeavy);
					}
				break;
				case BTN_CREATE_RAIN_ICE_CREAM:
					if (numShavedIce >= numShavedIcePerRain)
					{
						var p2:Point = GetButton(BTN_CREATE_RAIN_ICE_CREAM).GetPos(); 
						particalStar(new Point(p2.x + 80, p2.y), new Point(360, 120), new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0), doCreateRainIce);
					}
					else
					{
						str = Localization.getInstance().getString("Tooltip84");
						Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
					}
				break;
				default:
					if (buttonID.search(BTN_DESTROY_ICE_CREAM) >= 0)
					{
						ProcessDestroyIceCream(buttonID);
					}
					if (buttonID.search(CTN_SLOT_ICE_CREAM) >= 0)
					{
						if(GetContainer(buttonID).GetImage(IMG_LOCK).img.visible)
						{
							idCurProcess = buttonID;
							ProcessUnlockSlot(buttonID);
						}
						else
						{
							if(!GetContainer(buttonID).GetButton(BTN_DESTROY_ICE_CREAM + String(buttonID.split("_")[1])).img.visible)
							{
								idCurProcess = buttonID;
								if(GetContainer(buttonID).GetImage(IMG_CONTENT_ICE_CREAM) != null)
								{
									var objCream:Object = DataIceCream[slotId.toString()];
									if(!GameLogic.getInstance().user.IsViewer())
									{
										if (GetTimeLiveInRain(objCream.StartTime) >= objCream.LifeTime || objCream.IsSuccess)
										{
											doHarvestIceCream(slotId, objCream);
										}
										else 
										{
											GetContainer(buttonID).GetButton(BTN_DESTROY_ICE_CREAM + String(buttonID.split("_")[1])).SetVisible(true);
										}
									}
									else 
									{
										if (GetTimeLiveInRain(objCream.StartTime) >= objCream.LifeTime || objCream.IsSuccess)
										{
											doTheftIceCream(slotId, objCream);
										}
										else 
										{
											posStart = GameInput.getInstance().MousePos;
											posEnd = new Point(posStart.x, posStart.y - 100);
											txtFormat = new TextFormat(null, 14, 0xFF0000);
											txtFormat.align = "center";
											txtFormat.bold = true;
											txtFormat.font = "Arial";
											str = Localization.getInstance().getString("Tooltip89");
											Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
										}
									}
								}
							}
							else
							{
								idCurProcess = "";
								GetContainer(buttonID).GetButton(BTN_DESTROY_ICE_CREAM + String(buttonID.split("_")[1])).SetVisible(false);
							}
						}
					}
				break;
			}
		}
		
		public function doTheftIceCream(slotId:int, objCream:Object):void 
		{
			var totalTheft:int = 0;
			var posStart:Point;
			var posEnd:Point;
			var txtFormat:TextFormat;
			var str:String;
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			if (String(GameLogic.getInstance().user.GetMyInfo().Id) in objCream.TheftList)
			{
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				txtFormat = new TextFormat(null, 14, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
				str = Localization.getInstance().getString("Tooltip86");
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
			}
			else if(objCream.ItemId < 3)	
			{
				for (var iStr:String in objCream.TheftList) 
				{
					totalTheft += int(objCream.TheftList[iStr]);
				}
				if (totalTheft >= int(objConfig2.TheftRate) * objConfig1[String(objCream.ItemId)].MaxIceCream / 100)
				{
					posStart = GameInput.getInstance().MousePos;
					posEnd = new Point(posStart.x, posStart.y - 100);
					txtFormat = new TextFormat(null, 14, 0xFF0000);
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					str = Localization.getInstance().getString("Tooltip92");
					Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
				}
				else	// Thực hiện xử lý việc ăn trộm sau khi đã kiểm tra các trường hợp không thể
				{
					Exchange.GetInstance().Send(new SendIceCreamTheft(slotId));
					if(DataIceCream[slotId.toString()].TheftList[GameLogic.getInstance().user.GetMyInfo().Id.toString()] != null)
					{
						DataIceCream[slotId.toString()].TheftList[GameLogic.getInstance().user.GetMyInfo().Id.toString()] += 1;
					}
					else
					{
						DataIceCream[slotId.toString()].TheftList[GameLogic.getInstance().user.GetMyInfo().Id.toString()] = 1;
					}
					var ctn:Container = GetContainer(CTN_SLOT_ICE_CREAM + (slotId - 1));
					(ctn.GetImage(IMG_CONTENT_ICE_CREAM).img as MovieClip).gotoAndStop(5);
				}
			}
			else 
			{
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				txtFormat = new TextFormat(null, 14, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
				str = Localization.getInstance().getString("Tooltip88");
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
			}
		}
		
		public var waitDataServerSuccess:int = -1;
		public function doHarvestIceCream(slotId:int, objCream:Object):void 
		{
			// Gửi gói tin thu hoạch lên server
			Exchange.GetInstance().Send(new SendIceCreamHarvest(slotId));
			waitDataServerSuccess = 0;
			// Xóa slot kem đi
			// Hiển thị
			var ctn:Container = GetContainer(CTN_SLOT_ICE_CREAM	+ (slotId - 1));
			var txtTime:TextField = ctn.LabelArr[0];
			var indexText:int = arrTextTimeNeed.indexOf(txtTime);
			ctn.LabelArr.splice(0, ctn.LabelArr.length);
			arrTextTimeNeed.splice(indexText, 1);
			txtTime.parent.removeChild(txtTime);
			
			var prg:ProgressBar = arrProgressBarIceCream[indexText];
			prg.RemoveAllEvent();
			prg.removeChild(prg.img);
			prg.parent.removeChild(prg);
			prg.img = null;
			arrProgressBarIceCream.splice(indexText, 1);
			ctn.ProgressArr.splice(0, ctn.ProgressArr.length);
			
			var imgContents:Image = ctn.GetImage(IMG_CONTENT_ICE_CREAM);
			ctn.ImageArr.splice(ctn.ImageArr.indexOf(imgContents), 1);
			imgContents.img.parent.removeChild(imgContents.img);
			imgContents.Destructor();
			// Logic
			//DataIceCream[slotId.toString()] = new Array();
			arrDataIceCream.splice(arrDataIceCream.indexOf(objCream), 1);
		}
		
		public var TimeStartHeavy:Number = 0;
		public function doCreateRainHeavy():void 
		{
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			
			if (int(DataIceCream.Rain.HeavyRain) <= 0)
			{
				GetButton(BTN_BUY_RAIN_HEAVY).SetDisable();
				return;
			}
			DataIceCream.Rain.HeavyRain = int(DataIceCream.Rain.HeavyRain) - 1;
			Exchange.GetInstance().Send(new SendIceCreamMakeKeavyRain);
			GameLogic.getInstance().user.UpdateUserZMoney( -int(objConfig2.HeavyRainZMoney));
			
			txtNumRainHeavy.text = String(DataIceCream.Rain.HeavyRain);
			
			for (var i:int = 1; i <= MAX_SLOT_ICE_CREAM; i++) 
			{
				if (DataIceCream[i.toString()] != null && (!(DataIceCream[i.toString()] is Array)))
				{
					DataIceCream[i.toString()].IsSuccess = true;
				}
			}
			for (var j:int = 0; j < arrCtnSlotIcream.length; j++) 
			{
				var ctn:Container = arrCtnSlotIcream[j];
				if (ctn.GetImage(IMG_CONTENT_ICE_CREAM) && ctn.GetImage(IMG_CONTENT_ICE_CREAM).img) 
				{
					(ctn.GetImage(IMG_CONTENT_ICE_CREAM).img as MovieClip).gotoAndStop(4);
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffIceCreamSucces", null, 
								ctn.GetPosition().x + ctn.img.width / 2 + 5, 
								ctn.GetPosition().y + ctn.img.height / 2 - 20);
				}
			}
			for (var k:int = 0; k < arrTextTimeNeed.length; k++) 
			{
				var textTimeNeed:TextField = arrTextTimeNeed[k];
				textTimeNeed.text = "Hoàn thành";
				var prg:ProgressBar = arrProgressBarIceCream[k];
				prg.setStatus(1);
			}
			TimeStartHeavy = GameLogic.getInstance().CurServerTime;
			if(iceCreamEmit == null)
			{
				iceCreamEmit = new IceCreamEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			}
			iceCreamEmit.changeToHeavy();
			
		}
		
		public function doCreateRainIce():void 
		{
			if (numShavedIce >= numShavedIcePerRain)
			{
				numShavedIce -= numShavedIcePerRain;
				txtNumShavedIce.text = numShavedIce + "/" + numShavedIcePerRain;
				if (numShavedIce >= numShavedIcePerRain)
				{
					txtNumShavedIce.textColor = 0x00FF00;
				}
				else
				{
					txtNumShavedIce.textColor = 0xFF0000;
				}
				Exchange.GetInstance().Send(new SendIceCreamMakeRain());
				GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", 4, -numShavedIcePerRain);
			}
			else
			{
				var posStart:Point;
				var posEnd:Point;
				var txtFormat:TextFormat;
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				txtFormat = new TextFormat(null, 14, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
				var str:String = Localization.getInstance().getString("Tooltip84");
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
			}
		}
		
		public function ShowEffHeavy():void 
		{
			if(iceCreamEmit)
			{
				iceCreamEmit.changeToHeavy();
			}
		}
		
		public function MouseDoubleClick(buttonID:String):void 
		{
			if(waitDataServerSuccess < 0)
			{
				ProcessChooseItemCreateCream();
				UpdateBtnBuyUse();
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				default:
					if (buttonID.search(CTN_SLOT_ICE_CREAM) >= 0)
					{
						GetContainer(buttonID).SetHighLight();
						for (var i:int = 0; i < arrDataIceCream.length; i++) 
						{
							var item:Object = arrDataIceCream[i];
							if (item.IdContainerShow == buttonID)
							{
								GuiMgr.getInstance().GuiToolTipIcreCream.Init(item.ItemId);
								if(GameLogic.getInstance().user.IsViewer())
								{
									GameLogic.getInstance().MouseTransform("imgHand");
								}
							}
						}
					}
					if (buttonID.search(CTN_ITEM) >= 0)
					{
						GetContainer(buttonID).SetHighLight();
						GuiMgr.getInstance().GuiToolTipIcreCream.Init(int(buttonID.split("_")[1]) + 1);
					}
				break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				default:
					if (buttonID.search(CTN_SLOT_ICE_CREAM) >= 0)
					{
						GetContainer(buttonID).SetHighLight( -1);
						if (GuiMgr.getInstance().GuiToolTipIcreCream.IsVisible)
						{
							GuiMgr.getInstance().GuiToolTipIcreCream.Hide();
							if(GameLogic.getInstance().user.IsViewer())
							{
								GameLogic.getInstance().BackToIdleGameState();
							}
						}
					}
					if (buttonID.search(CTN_ITEM) >= 0)
					{
						GetContainer(buttonID).SetHighLight( -1);
						if (GuiMgr.getInstance().GuiToolTipIcreCream.IsVisible)
						{
							GuiMgr.getInstance().GuiToolTipIcreCream.Hide();
						}
					}
				break;
			}
		}
		
		public function FakeData():void 
		{
			if (DataIceCream == null)	return;
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			
			MaxItemCanBuy = DataIceCream.MaxItemCanBuy;
			
			txtTimeLeftRain = null;
			arrNumItemLogic = [];
			arrNumItemLogic = GameLogic.getInstance().user.StockThingsArr.IceCreamItem;
			arrNumItem = [];
			numShavedIce = 0;
			countBuyItem = 0;
			// Fake số lượng nguyên liệu kem
			var i:int = 0;
			var j:int = 0;
			var objNumItem:Object;
			for ( i = 0; i < MAX_ITEM_CAN_BUY; i++) 
			{
				var isHaveInData:Boolean = false;
				for (j = 0; j < arrNumItemLogic.length; j++) 
				{
					var item:Object = arrNumItemLogic[j];
					if (item.Id == (i + 1))
					{
						arrNumItem.push(item.Num);
						isHaveInData = true;
						break;
					}
				}
				if (!isHaveInData)
				{
					arrNumItem.push(0);
				}
			}
			for (j = 0; j < arrNumItemLogic.length; j++) 
			{
				objNumItem = arrNumItemLogic[j];
				if (objNumItem[ConfigJSON.KEY_ID] == 4) 
				{
					numShavedIce = objNumItem.Num;	
				}
			}
			
			numShavedIcePerRain = objConfig2.ShavedIceNeed;
			
			// Xác định số slot đã được mở ô
			for (j = 1; j < 15; j++) 
			{
				if (DataIceCream[j.toString()] == null)
				{
					break;
				}
				else if(!(DataIceCream[j.toString()] is Array))
				{
					DataIceCream[j.toString()].LifeTime = objConfig1[DataIceCream[j.toString()].ItemId].Time;
				}
				numSlotOpened = j;
			}
			
			// Fake dữa liệu các que kem đang làm
			arrDataIceCream.splice(0, arrDataIceCream.length);
			arrTextTimeNeed.splice(0, arrTextTimeNeed.length);
			arrProgressBarIceCream.splice(0, arrProgressBarIceCream.length);
			arrTextItemHave.splice(0, arrTextItemHave.length);
			for (i = 0; i < numSlotOpened; i++) 
			{
				if(DataIceCream[String(i+1)] && !(DataIceCream[String(i+1)] is Array))
				{
					arrDataIceCream.push(DataIceCream[String(i+1)]);
				}
			}
		}
		
		public function GetTimeNeed(StartTime:Number, LifeTime:Number, isHaveHeavyRain:Boolean = false):Number
		{
			var timeNeed:Number = 0;
			var curTimeServer:Number = GameLogic.getInstance().CurServerTime;
			var timeLiveRain:Number;
			if (isHaveHeavyRain)	timeLiveRain = LifeTime;
			else	timeLiveRain = GetTimeLiveInRain(StartTime);
			timeNeed = Math.max(LifeTime - timeLiveRain, 0);
			return timeNeed;
		}
		
		public function GetTimeLiveInRain(StartTime:Number):Number
		{
			var objConfig1:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var objConfig2:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"];
			
			var timeLive:Number = 0;
			var rainLifeTime:Array = DataIceCream.Rain.LifeTime;
			if (rainLifeTime == null)
			{
				return 0;
			}
			var curServerTime:Number = GameLogic.getInstance().CurServerTime;
			for (var i:int = 0; i < rainLifeTime.length; i++) 
			{
				var item:Object = rainLifeTime[i];
				if (item.EndTime < StartTime)
				{
					continue;
				}
				else if(item.EndTime < curServerTime && item.StartTime < StartTime)
				{
					timeLive += (item.EndTime - StartTime);
				}
				else if(item.StartTime >= StartTime && item.EndTime < curServerTime)
				{
					timeLive += (item.EndTime - item.StartTime);
				}
				else if(item.StartTime >= StartTime && curServerTime <= item.EndTime)
				{
					timeLive += (curServerTime - item.StartTime);
				}
				else if(item.StartTime <= StartTime && curServerTime <= item.EndTime)
				{
					timeLive += (curServerTime - StartTime);
				}
			}
			return timeLive;
		}
		public function CheckHaveGuiAbove():Boolean
		{
			if (GuiMgr.getInstance().GuiUnlockSlotIceCream.IsVisible)	return true;
			if (GuiMgr.getInstance().GuiDestroyIceCream.IsVisible)	return true;
			if (GuiMgr.getInstance().GuiHarvestIceCream.IsVisible)	return true;
			return false;
		}
		public var iceCreamEmit:IceCreamEmit = null;
		public function Update():void 
		{
			if (DataIceCream == null)	return;
			var obj:Object;
			var btn:Button;
			var btnEx:ButtonEx;
			var ctn:Container;
			var i:int = 0;
			var j:int = 0;
			var curServerTime:Number = GameLogic.getInstance().CurServerTime;
			
			var arrHistoryRain:Array = DataIceCream.Rain.LifeTime;
			var isInRain:Boolean = false;
			var timeEndRain:Number;
			for (i = 0; arrHistoryRain != null && i < arrHistoryRain.length; i++) 
			{
				var objHistoryRain:Object = arrHistoryRain[i];
				timeEndRain = objHistoryRain.EndTime;
				if (curServerTime < timeEndRain)
				{
					isInRain = true;
					break;
				}
			}
			
			if (waitDataServerSuccess >= 0)
			{
				waitDataServerSuccess++;
				if (waitDataServerSuccess >= 500)
				{
					waitDataServerSuccess = -1;
				}
			}
			
			if(isCanShowRain && !CheckHaveGuiAbove())
			{
				var timeLeftRain:Number;
				var hourLeftRain:int;
				var minLeftRain:int;
				var secLeftRain:int;
				var strHourLeftRain:String;
				var strMinLeftRain:String;
				var strSecLeftRain:String;
				if (isInRain)
				{
					if (iceCreamEmit == null)
					{
						iceCreamEmit = new IceCreamEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
					}
					if (txtTimeLeftRain == null)
					{
						timeLeftRain = timeEndRain - curServerTime;
						hourLeftRain = Math.floor(timeLeftRain / 3600);
						if (hourLeftRain < 10 && minLeftRain >= 0)	strHourLeftRain = "0" + String(hourLeftRain);
						else	strHourLeftRain = hourLeftRain.toString();
						
						timeLeftRain = timeLeftRain - 3600 * hourLeftRain;
						minLeftRain = Math.floor(timeLeftRain / 60);
						if (minLeftRain < 10 && minLeftRain >= 0)	strMinLeftRain = "0" + String(minLeftRain);
						else	strMinLeftRain = minLeftRain.toString();
						
						timeLeftRain = timeLeftRain - minLeftRain * 60;
						secLeftRain = timeLeftRain;
						if (secLeftRain < 10 && secLeftRain >= 0)	strSecLeftRain = "0" + String(secLeftRain);
						else	strSecLeftRain = secLeftRain.toString();
						
						//txtTimeLeftRain = AddLabel(strHourLeftRain + ":" + strMinLeftRain + ":" + strSecLeftRain, 330, 120, 0xDD0000, 1, 0xffffff);
						txtTimeLeftRain = AddLabel(strHourLeftRain + ":" + strMinLeftRain + ":" + strSecLeftRain, 330, 120, 0x00ff00, 1, 0x000000);
						GetImage(IMG_LABEL_SHAVED_ICE).img.visible = true;
						var txtFormat:TextFormat = new TextFormat("Arial" , 28, 0x00bb00, true);
						txtTimeLeftRain.setTextFormat(txtFormat);
						txtTimeLeftRain.defaultTextFormat = txtFormat;
					}
					else 
					{
						//txtTimeLeftRain.parent.setChildIndex(txtTimeLeftRain, txtTimeLeftRain.parent.numChildren + 1);
						if(txtTimeLeftRain.parent)
						{
							img.addChild(txtTimeLeftRain);
							GetImage(IMG_LABEL_SHAVED_ICE).img.visible = true;
						}
					}
				}
				else 
				{
					if (iceCreamEmit && TimeStartHeavy == 0)
					{
						iceCreamEmit.destroy();
						iceCreamEmit = null;
						
						if(txtTimeLeftRain && txtTimeLeftRain.parent)
						{
							txtTimeLeftRain.parent.removeChild(txtTimeLeftRain);
							txtTimeLeftRain = null;
							GetImage(IMG_LABEL_SHAVED_ICE).img.visible = false;
						}
					}
				}
				if (iceCreamEmit || TimeStartHeavy > 0)
				{
					if(iceCreamEmit)	iceCreamEmit.updateEmitter();
					if(isInRain)
					{
						timeLeftRain = timeEndRain - curServerTime;
						hourLeftRain = Math.floor(timeLeftRain / 3600);
						if (hourLeftRain < 10 && minLeftRain >= 0)	strHourLeftRain = "0" + String(hourLeftRain);
						else	strHourLeftRain = hourLeftRain.toString();
						
						timeLeftRain = timeLeftRain - 3600 * hourLeftRain;
						minLeftRain = Math.floor(timeLeftRain / 60);
						if (minLeftRain < 10 && minLeftRain >= 0)	strMinLeftRain = "0" + String(minLeftRain);
						else	strMinLeftRain = minLeftRain.toString();
						
						timeLeftRain = timeLeftRain - minLeftRain * 60;
						secLeftRain = timeLeftRain;
						if (secLeftRain < 10 && secLeftRain >= 0)	strSecLeftRain = "0" + String(secLeftRain);
						else	strSecLeftRain = secLeftRain.toString();
						
						if (String(strHourLeftRain + ":" + strMinLeftRain + ":" + strSecLeftRain) != txtTimeLeftRain.text)
						{
							txtTimeLeftRain.text = String(strHourLeftRain + ":" + strMinLeftRain + ":" + strSecLeftRain);
						}
						if(curServerTime - TimeStartHeavy > 5)
						{
							if(iceCreamEmit)	iceCreamEmit.BackToNormal();
							TimeStartHeavy = 0;
						}
					}
					else 
						if(curServerTime - TimeStartHeavy > 5)
						{
							if (iceCreamEmit)
							{
								iceCreamEmit.BackToNormal();
								iceCreamEmit.destroy();
								iceCreamEmit = null;
							}
							TimeStartHeavy = 0;
						}
				}
			}
			if(isInRain)
			{
				for (i = 0; i < arrTextTimeNeed.length; i++) 
				{
					(arrTextTimeNeed[i] as TextField).textColor = 0x000000;
				}
				var txtField:TextField;
				var prg:ProgressBar;
				for (i = 0; i < arrTextTimeNeed.length; i++) 
				{
					txtField = arrTextTimeNeed[i];
					prg = arrProgressBarIceCream[i];
					var ctnContainText:Container;
					for (j = 0; j < arrCtnSlotIcream.length; j++)
					{
						ctnContainText = arrCtnSlotIcream[j];
						var arrTxtInContainer:Array = ctnContainText.LabelArr;
						if (arrTxtInContainer.indexOf(txtField) >= 0)
						{
							obj = DataIceCream[String(int(ctnContainText.IdObject.split("_")[1]) + 1)];
							break;
						}
					}
					var strShow:String = txtField.text;
					var numTimeLeftShow:int = int(strShow.split(":")[0]) * 3600 + int(strShow.split(":")[1]) * 60 + int(strShow.split(":")[2]);
					var numTimeLeft:int = GetTimeNeed(obj.StartTime, obj.LifeTime, obj.IsSuccess);
					var NewState:int = GetStateIceCream(obj.StartTime, obj.LifeTime, obj.IsSuccess);
					prg.setStatus(1 - numTimeLeft / obj.LifeTime);
					if (NewState == 4 && obj.IceCreamNum > 0)	NewState = 5;
					if ((ctnContainText.GetImage(IMG_CONTENT_ICE_CREAM).img as MovieClip).currentFrame != NewState)
					{
						(ctnContainText.GetImage(IMG_CONTENT_ICE_CREAM).img as MovieClip).gotoAndStop(NewState);
					}
					if (numTimeLeft + 1 <= numTimeLeftShow)
					{
						if (numTimeLeft <= 0)
						{
							EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffIceCreamSucces", null, 
								ctnContainText.GetPosition().x + ctnContainText.img.width / 2 + 5, 
								ctnContainText.GetPosition().y + ctnContainText.img.height / 2 - 20);
							txtField.text = "Hoàn thành";
						}
						else
						{
							var hour:int = numTimeLeft / 3600;
							var strHour:String = hour.toString();
							if (hour < 10 && hour >= 0)	strHour = "0" + hour.toString();
							
							var min:int = (numTimeLeft - Math.floor(numTimeLeft / 3600) * 3600) / 60;
							var strMin:String = min.toString();
							if (min < 10 && min >= 0)	strMin = "0" + min.toString();
							
							var sec:int = numTimeLeft - Math.floor(numTimeLeft / 60) * 60;
							var strSec:String = sec.toString();
							if (sec < 10 && sec >= 0)	strSec = "0" + sec.toString();
							
							txtField.text = String(strHour + ":" + strMin + ":" + strSec);
						}
					}
				}
			}	
			else
			{
				for (i = 0; i < arrTextTimeNeed.length; i++) 
				{
					(arrTextTimeNeed[i] as TextField).textColor = 0xFF0000;
				}
			}
			
			//Update particle
			for (i = 0; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;					
				}
			}	
			
			if (arrObjHelp && arrObjHelp.length > 0)
			{
				obj = arrObjHelp[0];
				var posImgHelp:Point = null;
				switch (obj.Type) 
				{
					case "Container":
						ctn = GetContainer(obj.Id);
						if (ctn)
						{
							posImgHelp = ctn.GetPosition();
							posImgHelp.x += (ctn.img.width / 2 + 15);
							posImgHelp.y += (ctn.img.height / 2);
						}
						
					break;
					case "Button":
						btn = GetButton(obj.Id);
						if (btn)
						{
							posImgHelp = btn.GetPos();
							posImgHelp.x += btn.img.width / 2;
						}
					break;
					case "ButtonEx":
						btnEx = GetButtonEx(obj.Id);
						if (btn)
						{
							posImgHelp = btnEx.GetPos();
							posImgHelp.x += btnEx.img.width / 2;
						}
						
					break;
				}
				if (imgHelp == null || imgHelp.img == null)
				{
					if(posImgHelp != null)	imgHelp = AddImage(IMG_HELP, "IcHelper", posImgHelp.x, posImgHelp.y);
				}
				else 
				{
					imgHelp.SetPos(posImgHelp.x, posImgHelp.y);
				}
			}
		}
		
		/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point, mid:int = 0):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
			
			//Random hướng vuông góc
			var n:int;
			if(mid == 0)
			{
				n = Math.round(Math.random()) * 2 - 1;
			}
			else
			{
				n = mid;
			}
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
		
		private var emitStar:Array = [];
		/**
		 * Hàm tạo effect 1 chùm sao bay theo đường cong từ điểm này tới điểm kia
		 * @param	fromPoint : điểm bắt đầu
		 * @param	toPoint : điểm kết thúc
		 * @param	colorTransform : transform màu cho sao
		 * @param	isReverse : có bay ngược từ toPoint đến fromPoint hay không, mặc định là không
		 * @param	completeFunction : hàm thưc hiện khi xong effect
		 * @param	params : tham số cho hàm completeFunction
		 * @param	mid : chọn điểm giữa, 0 là random, 1 là hướng vòng lên, -1 là hướng vòng xuống, 2 là bay thẳng
		 * @param	spawnCount : số sao bay
		 */
		private function particalStar(fromPoint:Point, toPoint:Point, colorTransform:ColorTransform, completeFunction:Function = null, params:Object = null, time:Number = 0.5, isReverse:Boolean = false, mid:int = 0, spawnCount:int = 7):void
		{
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));		
			emit.spawnCount = spawnCount;
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = colorTransform;
			emit.imgList.push(sao);
			emitStar.push(emit);
			if (isReverse)
			{
				var temp:Point = toPoint.clone();
				toPoint = fromPoint.clone();
				fromPoint = temp;
			}
			
			var midPoint:Point = midPoint = getThroughPoint(fromPoint, toPoint, mid);
			
			if (emit)
			{
				img.addChild(emit.sp);
				emit.sp.x = fromPoint.x;
				emit.sp.y = fromPoint.y;
				if(mid != 2)
				{
					emit.velTolerance = new Point(2.5, 2.5);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:midPoint.x, y:midPoint.y }, { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction,params]} );					
				}
				else
				{
					emit.velTolerance = new Point(2.2, 2.2);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction, params] } );					
				}
			}
			
			function onCompleteTween():void
			{
				if (IsVisible)
				{
					if (emit)
					{
						emit.stopSpawn();
					}
					img.removeChild(emit.sp);	
				}
				if(completeFunction != null)
				{
					completeFunction();
				}
			}
		}
		
		override public function OnHideGUI():void 
		{
			isCanShowRain = false;
			if (iceCreamEmit)
			{
				iceCreamEmit.destroy();
				iceCreamEmit = null;
			}
			if (GetImage(IMG_SHAVED_ICE) && GetImage(IMG_SHAVED_ICE).img != null) 
			{
				GetImage(IMG_SHAVED_ICE).img.removeEventListener(MouseEvent.ROLL_OVER, onMouseMoveShavedIce);
				GetImage(IMG_SHAVED_ICE).img.removeEventListener(MouseEvent.ROLL_OUT, onMouseOutShavedIce);
			}
			if (GuiMgr.getInstance().GuiToolTipIcreCream.IsVisible)
			{
				GuiMgr.getInstance().GuiToolTipIcreCream.Hide();
			}
		}
		
		public function CheckShowGuiGetGift():void 
		{
			if (GameLogic.getInstance().user.IsViewer()) return;
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("GUIGetGiftDaily" + GameLogic.getInstance().user.GetMyInfo().Id);
			if (so.data.lastDay != null)
			{
				var lastDay:String = so.data.lastDay;				
				if (lastDay != today)
				{
					so.data.lastDay = today;
					if(EventMgr.CheckEvent("IceCream") == EventMgr.CURRENT_IN_EVENT)
					{
						GuiMgr.getInstance().GuiMainEventIceCream.Show(Constant.GUI_MIN_LAYER, 3);
						GuiMgr.getInstance().GuiGetGiftDaily.Show(Constant.GUI_MIN_LAYER, 3);
					}
				}
			}
			else
			{
				if(EventMgr.CheckEvent("IceCream") == EventMgr.CURRENT_IN_EVENT)
				{
					so.data.lastDay = today;
					GuiMgr.getInstance().GuiIntroHelpEventIceCream.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
		}
		
		public function CreateHelp():void 
		{
			arrObjHelp.splice(0, arrObjHelp.length);
			var obj:Object = new Object();
			obj.Id = "CtnItem_0";
			obj.Type = "Container";
			arrObjHelp.push(obj);
			obj = new Object();
			obj.Id = "BtnCreateIceCream";
			obj.Type = "Button";
			arrObjHelp.push(obj);
		}
		
		private function ProcessDestroyIceCream(buttonId:String):void 
		{
			var objIcream:Object = DataIceCream[String(int(buttonId.split("_")[1]) + 1)];
			GuiMgr.getInstance().GuiDestroyIceCream.init(int(objIcream.ItemId));
		}
		
		private function ProcessUnlockSlot(buttonId:String):void 
		{
			var index:int = buttonId.split("_")[1];
			if (index <= 5)	return;
			if (GameLogic.getInstance().user.IsViewer()) return;
			var idCtn:String = CTN_SLOT_ICE_CREAM + String(index - 1);
			var ctn:Container = GetContainer(buttonId);
			var ctn1:Container = GetContainer(idCtn);
			var objConfig:Object = ConfigJSON.getInstance().GetItemList("Param")["IceCreamInfo"].SlotPrice;
			var ZMoneyRequire:int = objConfig[String(int(buttonId.split("_")[1]) + 1)];
			var ZMoneyUserHave:int = GameLogic.getInstance().user.GetZMoney();
			var posStart:Point;
			var posEnd:Point;
			var txtFormat:TextFormat;
			if (!ctn1.GetImage(IMG_LOCK).img.visible && ctn.GetImage(IMG_LOCK).img.visible) 
			{
				// Kiểm tra xem có đủ xu để thực hiện action không
				if (ZMoneyUserHave >= ZMoneyRequire)
				{
					GuiMgr.getInstance().GuiUnlockSlotIceCream.initGUI(ZMoneyRequire, int(buttonId.split("_")[1]) + 1);
				}
				else 
				{
					GuiMgr.getInstance().GuiNapG.Init();
					posStart = GameInput.getInstance().MousePos;
					posEnd = new Point(posStart.x, posStart.y - 100);
					txtFormat = new TextFormat(null, 12, 0xFF0000);
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					var str:String = Localization.getInstance().getString("Tooltip82");
					str = str.replace("@Value ", ZMoneyRequire.toString());
					Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
				}
			}
			else if (ctn1.GetImage(IMG_LOCK).img.visible) 
			{
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				txtFormat = new TextFormat(null, 12, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
				Ultility.ShowEffText(Localization.getInstance().getString("Tooltip81"), img, posStart, posEnd, txtFormat, 1, 0xffffff);
				idCurProcess = "";
			}
		}
	}

}