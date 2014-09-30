package GUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.User;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendUseItem;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIAddEnergy extends BaseGUI 
	{
		public const NUM_CTN_ENERGY:int = 4;
		
		public const CTN_ENERGY:String = "ctnEnergy_";
		public const BTN_CLOSE:String = "btnClose";
		public const BTN_NEXT:String = "btnNext_";
		public const BTN_PRE:String = "btnPre_";
		public const BTN_USE:String = "btnUse_";
		public const BTN_BUY:String = "btnBuy_";
		public const SEPARATE:String = "_";
		
		public const START_CTN_X:int = 35;
		public const START_CTN_Y:int = 105;
		public const START_BTN_X:int = 40;
		public const START_BTN_Y:int = 245;
		public const DISTANCE_CTN_BTN_X:int = 140;
		
		public var txtNumEnergy:TextField ;
		public var arrXu:Array = ["0", "3", "10", "18"];
		public var arrEnergy:Array;
		public var arrEnergyCanChoose:Array;
		public var arrCtn:Array;
		public var arrBtn:Array;
		public var maxEnergyUse:Object;
		public var user:User;
		
		public var imgEXP:Image;
		
		public function GUIAddEnergy(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAddEnergy";
		}
		
		public override function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var i:int = 0;
				user = GameLogic.getInstance().user;
				arrEnergy = user.StockThingsArr.EnergyItem;
				arrCtn = [];
				arrBtn = [];
				maxEnergyUse = user.GetMyInfo().MaxEnergyUse;
				
				txtNumEnergy = new TextField();
				//super.InitGUI();
				// load anh nen
				
				// set vi tri
				//if (GuiMgr.IsFullScreen)
				//{
					//SetPos(LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth / 2 - img.width / 2, LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight / 2 - img.height / 2);
				//}
				//else 
				{
					SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				}
				// Add cac container chua energy
				for (i = 0; i < NUM_CTN_ENERGY; i++) 
				{
					AddCtnEnergy(i);
				}
				// Add nut thoat
				AddButton(BTN_CLOSE, "BtnThoat", img.width - 43, 21, this);
				AddLabel("Bạn không đủ năng lượng để thực hiện hành động này!", img.width / 2 - 45, START_CTN_Y - 38, 0xCC3333 );
				AddLabel("Hãy nạp thêm nhé ^_^", img.width / 2 - 45, START_CTN_Y - 23, 0xCC3333 );
			}
			
			LoadRes("GuiAddEnergy_Theme");
		}
		
		public function AddCtnEnergy(id:int):void 
		{
			var ctn:Container = AddContainer(CTN_ENERGY + id, "GuiAddEnergy_CtnEnergy", START_CTN_X + DISTANCE_CTN_BTN_X * id, START_CTN_Y);
			arrCtn.push(ctn);
			if (id == 0)
			{
				InitCtnUse(ctn);
			}
			else 
			{
				var tip:TooltipFormat = new TooltipFormat();
				var btnBuy:Button = AddButton(BTN_BUY + (id + 2), "GuiAddEnergy_BtnBuyNewEnergy", START_BTN_X + id * DISTANCE_CTN_BTN_X, START_BTN_Y, this);
				arrBtn.push(btnBuy);
				var txtXu:TextField = AddLabel(arrXu[id], START_BTN_X + id * DISTANCE_CTN_BTN_X + 14, START_BTN_Y + 4, 0xffffff);
				var txtFormatMat:TextFormat = new TextFormat();
				txtFormatMat.size = 17;
				txtXu.setTextFormat(txtFormatMat);
				var imgEnergy:Image = ctn.AddImage("", "EnergyItem" + (id + 2), ctn.img.width / 2, ctn.img.height / 2);
			
				if (imgEnergy)
				{
					imgEnergy.SetScaleXY(1.5);
					imgEnergy.SetPos(ctn.img.width / 2, ctn.img.height / 2);
					tip = null;
				}
				
				if (arrEnergy[(id + 2).toString()] <= 0) 
				{
					btnBuy.SetDisable();
					txtFormatMat.bold = true;
					txtFormatMat.color = 0xff0000;
					tip.text = "Bạn đã dùng quá số bình\nnăng lượng của ngày hôm nay";
					tip.setTextFormat(txtFormatMat);
				}
				
				btnBuy.setTooltip(tip);
			}
		}
		
		public function InitCtnUse(ctn:Container, idEnergyChoose:int = -1, idEnergyOld:int = -1):void 
		{
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
			var id:int = ctn.IdObject.split(SEPARATE)[1];
			var imgEnergy:Image;
			var format:TextFormat = new TextFormat();
			
			ctn.RemoveAllImage();
			imgEXP = ctn.AddImage("", "GuiAddEnergy_ImgLvRequire", 5, 5, true, ALIGN_LEFT_TOP);
			//format.color = 0x00CCFF;
			format.align = "center";
			//txtNumEnergy = ctn.AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 6, 0x00CCFF, 1, 0x26709C);
			txtNumEnergy = ctn.AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 6, 0xFFFF00, 1, 0x26709C);
			txtNumEnergy.setTextFormat(format);
			
			var i:int = 0;
			var tip:TooltipFormat = new TooltipFormat();
			
			var idEnergy:int = idEnergyChoose;
			
			if(idEnergyChoose == -1)
			{
				arrEnergyCanChoose = new Array();
				for (i = arrEnergy.length - 1; i >= 0; i--) 
				{
					var item:Object = arrEnergy[i];
					//if (item[ConfigJSON.KEY_ID] == "6" || maxEnergyUse[item[ConfigJSON.KEY_ID]] > 0) 
					if (maxEnergyUse[item[ConfigJSON.KEY_ID]] > 0) 
					{
						if(item["Num"] > 0)
						{
							//if(idEnergy == -1)
							{
								if (item["Id"] == 6 && user.GetMyInfo().Energy >= maxEnergy)
								{
									continue;
								}
								else
								{
									if(idEnergy < item[ConfigJSON.KEY_ID])
									{
										idEnergy = item[ConfigJSON.KEY_ID];
									}
								}
							}
							
							
							//else 
							{
								arrEnergyCanChoose.push(int(item[ConfigJSON.KEY_ID]));
							}
						}
					}
				}
				arrEnergyCanChoose.sort();
				ctn.AddButton(BTN_NEXT + idEnergy, "GuiAddEnergy_BtnNext", ctn.img.width - 15, ctn.img.height / 2 - 10, this).SetDisable();
				ctn.AddButton(BTN_PRE + idEnergy, "GuiAddEnergy_BtnPrev", -15, ctn.img.height / 2 - 10, this).SetDisable();
			}
			else 
			{
				ctn.GetButton(BTN_NEXT + idEnergyOld).ButtonID = BTN_NEXT + idEnergyChoose;
				ctn.GetButton(BTN_PRE + idEnergyOld).ButtonID = BTN_PRE + idEnergyChoose;
				imgEnergy = ctn.ImageArr[1];
				ctn.RemoveImage(imgEnergy);
			}
			
			var objCurEnergy:Object;
			for (var j:int = 0; j < arrEnergy.length; j++) 
			{
				if (int(arrEnergy[j].Id) == idEnergy)
				{
					objCurEnergy = arrEnergy[j];
					break;
				}
			}
			
			if (idEnergy > 0)
			{
				txtNumEnergy.text = objCurEnergy["Num"];
				imgEnergy = ctn.AddImage("", "EnergyItem" + idEnergy, ctn.img.width / 2 - 20, ctn.img.height / 2 - 10);
				tip = null;
			}
			else 
			{
				var txtFormatMat:TextFormat = new TextFormat();
				txtFormatMat.bold = true;
				txtFormatMat.color = 0xff0000;
				tip.text = "Bạn đã hết bình có thể dùng được!";
				tip.setTextFormat(txtFormatMat);
				imgEnergy = ctn.AddImage("", "EnergyItem1", ctn.img.width / 2 - 20, ctn.img.height / 2 - 10);
				//ActiveTooltip.getInstance().showNewToolTip(tip, ctn.img);
			}
			//var btnUse:Button = AddButton(BTN_USE + idEnergy, "BtnUse", START_BTN_X + id * DISTANCE_CTN_BTN_X, START_BTN_Y, this);
			var btnUse:Button
			if (idEnergy > 0)	
			{
				btnUse = AddButton(BTN_USE + idEnergy, "GuiAddEnergy_BtnUse", START_BTN_X + id * DISTANCE_CTN_BTN_X, START_BTN_Y, this);
			}
			else 
			{
				btnUse = AddButton(BTN_USE + "0", "GuiAddEnergy_BtnUse", START_BTN_X + id * DISTANCE_CTN_BTN_X, START_BTN_Y, this);
			}
			btnUse.setTooltip(tip);
			if (idEnergy <= 0 || objCurEnergy["Num"] <= 0)
			{
				btnUse.SetDisable();
			}
			arrBtn.push(btnUse);
			
			if (imgEnergy)
			{
				imgEnergy.SetScaleXY(1.5);
				imgEnergy.SetPos(ctn.img.width / 2 - 20, ctn.img.height / 2);
			}
			if(arrEnergyCanChoose.length > 0)
			{
				if (arrEnergyCanChoose.indexOf(idEnergy) > 0 && arrEnergyCanChoose.indexOf(idEnergy) < arrEnergyCanChoose.length - 1)
				{
					ctn.GetButton(BTN_PRE + idEnergy).SetEnable();
					ctn.GetButton(BTN_NEXT + idEnergy).SetEnable();
				}
				else if (arrEnergyCanChoose.indexOf(idEnergy) > 0)
				{
					ctn.GetButton(BTN_PRE + idEnergy).SetEnable(false);
					ctn.GetButton(BTN_NEXT + idEnergy).SetEnable();
				}
				else 
				{
					ctn.GetButton(BTN_PRE + idEnergy).SetEnable();
					ctn.GetButton(BTN_NEXT + idEnergy).SetEnable(false);
				}
			}
			else 
			{
				ctn.GetButton(BTN_PRE + idEnergy).SetEnable(false);
				ctn.GetButton(BTN_NEXT + idEnergy).SetEnable(false);
			}
		}
		
		public function GetType(id:int):String 
		{
			switch (id) 
			{
				case 0:
					return "1";
				break;
				case 1:
					return "5";
				break;
				case 2:
					return "10";
				break;
				case 3:
					return "50";
				break;
			}
			return "*";
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					updateAllGUI();
					Hide();
				break;
				
				default:
					if (buttonID.search(BTN_USE) >= 0)
						doUseEnergy(buttonID);
					if(buttonID.search(BTN_BUY) >= 0)
						doBuyEnergy(buttonID);
					if (buttonID.search(BTN_NEXT) >= 0 || buttonID.search(BTN_PRE) >= 0)
						doSwapEnergyUse(buttonID);
					updateAllGUI();
				break;
			}
		}
		
		public function updateAllGUI():void
		{
			/*if (GuiMgr.getInstance().GuiMixFish.IsVisible)
			{
				GuiMgr.getInstance().GuiMixFish.updateFillEnergy();
			}*/
			if (GuiMgr.getInstance().guiMateFish.IsVisible)
			{
				GuiMgr.getInstance().guiMateFish.updateFillEnergy();
			}
		}
		
		private function doSwapEnergyUse(btnId:String):void 
		{
			var idEnergy:int = btnId.split("_")[1];
			var indexIdEnergy:int = arrEnergyCanChoose.indexOf(idEnergy);
			if(indexIdEnergy >= 0)
			{
				if (btnId.search(BTN_NEXT) >= 0 && indexIdEnergy > 0)
				{
					InitCtnUse(GetContainer(CTN_ENERGY + "0"), arrEnergyCanChoose[indexIdEnergy - 1], idEnergy);
				}
				else if(btnId.search(BTN_PRE) >= 0 && indexIdEnergy < arrEnergyCanChoose.length - 1)
				{
					InitCtnUse(GetContainer(CTN_ENERGY + "0"), arrEnergyCanChoose[indexIdEnergy + 1], idEnergy);
				}
			}
		}
		
		public function doUseEnergy(buttonId:String):void 
		{
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
			var maxBonusMachine:int = ConfigJSON.getInstance().GetItemList("Param")["MaxBonusMachine"];
			var type:int = buttonId.split(SEPARATE)[1];
			var msg:String;
			
			if (user.GetMyInfo().Energy >= maxEnergy && user.GetMyInfo().bonusMachine >= maxBonusMachine)
			{
				msg = Localization.getInstance().getString("Tooltip60");
				GuiMgr.getInstance().GuiMessageBox.ShowOK(msg, 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
				Hide();
				return;
			}
			
			if (int(txtNumEnergy.text) <= 0)
			{
				return;
			}
			
			var numEnergy:int = int(txtNumEnergy.text);
			numEnergy--;
			txtNumEnergy.text = numEnergy.toString();
			
			// update energy
			var obj:Object = ConfigJSON.getInstance().getItemInfo("EnergyItem", type)
			//user.UpdateEnergy(obj["Num"]);
			
			var isUseFull:Boolean = false;
			if (type == Constant.ID_FULL_ENERGY)
			{
				isUseFull = true;
				if (user.GetMyInfo().Energy >= maxEnergy)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đang đầy năng lượng mà", 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
					Hide();
					return;
				}
			}
			
			var test:SendUseItem = new SendUseItem(user.CurLake.Id);
			test.AddNew(0, type, "EnergyItem", 0, 0, 0);
			Exchange.GetInstance().Send(test);
			
			GameLogic.getInstance().updateEnergyOver(obj["Num"], isUseFull);
			
			// update kho
			//GuiMgr.getInstance().GuiStore.UpdateStore("EnergyItem", type, -1);
			GameLogic.getInstance().user.UpdateStockThing("EnergyItem", type, -1);
			maxEnergyUse[type.toString()] --;
			if (numEnergy <= 0 || maxEnergyUse[type.toString()] <= 0 || isUseFull)
			{
				var ctnTemp:Container = arrCtn[0];
				ctnTemp.ClearComponent();
				InitCtnUse(ctnTemp);
			}
			var posEff:Point = img.localToGlobal(new Point(img.width / 2, img.height / 2));
			//EffectMgr.setEffBounceDown("Nạp thành công", "EnergyItem" + type, 330, 280);
			EffectMgr.setEffBounceDown("Nạp thành công", "EnergyItem" + type, posEff.x - 80, posEff.y - 90);
		}
		
		public function doBuyEnergy(buttonId:String):void 
		{
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
			var maxBonusMachine:int = ConfigJSON.getInstance().GetItemList("Param")["MaxBonusMachine"];
			var type:int = buttonId.split(SEPARATE)[1];
			var msg:String;
			var btnBuy:Button;
			
			if (user.GetMyInfo().Energy >= maxEnergy && user.GetMyInfo().bonusMachine >= maxBonusMachine)
			{
				msg = Localization.getInstance().getString("Tooltip60");
				GuiMgr.getInstance().GuiMessageBox.ShowOK(msg, 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
				Hide();
				return;
			}
			
			if (user.GetMyInfo().ZMoney < int(arrXu[type - 2]))
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
			
			if (maxEnergyUse[type.toString()] <= 0) 
			{
				msg = "Bạn đã dùng quá số bình năng lượng " + GetType(type - 1) + " của ngày hôm nay";
				GuiMgr.getInstance().GuiMessageBox.ShowOK(msg, 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
				btnBuy = arrBtn[type - 2] as Button;
				btnBuy.SetDisable();
				var ctnTemp:Container = arrCtn[0] as Container;
				ctnTemp.ClearComponent();
				InitCtnUse(ctnTemp);
				return;
			}
			
			maxEnergyUse[type.toString()] = maxEnergyUse[type.toString()] - 1;
			
			var testBuy:SendBuyOther = new SendBuyOther();
			testBuy.AddNew("EnergyItem", type, 1, "ZMoney");
			user.UpdateUserZMoney( -arrXu[type - 2]);
			Exchange.GetInstance().Send(testBuy);
			
			var testUse:SendUseItem = new SendUseItem(user.CurLake.Id);
			testUse.AddNew(0, type, "EnergyItem", 0, 0, 0);
			Exchange.GetInstance().Send(testUse);
		
			// update energy
			var obj:Object = ConfigJSON.getInstance().getItemInfo("EnergyItem", type)
			//user.UpdateEnergy(obj["Num"]);
			GameLogic.getInstance().updateEnergyOver(obj["Num"]);
			
			var posEff:Point = img.localToGlobal(new Point(img.width / 2, img.height / 2));
			//EffectMgr.setEffBounceDown("Nạp thành công", "EnergyItem" + type, 330, 280);
			EffectMgr.setEffBounceDown("Nạp thành công", "EnergyItem" + type, posEff.x - 80, posEff.y - 90);
		}
	}

}