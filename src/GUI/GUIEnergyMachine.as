package GUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author hiepga
	 */
	public class GUIEnergyMachine extends BaseGUI 
	{
		private var numPetrol1:int;
		private var numPetrol2:int;
		private var numPetrol3:int;
		private var numPetrol4:int;
		private var btnExNum1:ButtonEx;
		private var btnExNum2:ButtonEx;
		private var btnExNum3:ButtonEx;
		private var btnExNum4:ButtonEx;
		private var txtNum1:TextField;
		private var txtNum2:TextField;
		private var txtNum3:TextField;
		private var txtNum4:TextField;
		private var ctnChooseType1:ButtonEx;
		private var ctnChooseType2:ButtonEx;
		private var ctnChooseType3:ButtonEx;
		private var ctnChooseType4:ButtonEx;
		private var btnDoXang:Button;
		private var imgSelect:Image;
		public static const ID_BTN_DO_XANG:String = "IdBtnDoXang";
		private static const ID_BTN_MUA_XANG:String = "IdBtnMuaXang";
		private static const ID_BTN_THOAT:String = "IdBtnThoat";
		public var curChooseType:int = 1;
		//private var txtNgayConLai:String = "";
		public function GUIEnergyMachine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				numPetrol1 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 1);
				numPetrol2 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 2);
				numPetrol3 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 3);
				numPetrol4 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 4);
				
				SetPos(140, 120);
				AddButton(ID_BTN_THOAT, "BtnThoat", this.img.width - 35, 20);
				btnDoXang = AddButton(ID_BTN_DO_XANG, "GuiEnergyMachine_BtnDoXang", this.img.width / 2 - 180, this.img.height - 85);

				AddButton(ID_BTN_MUA_XANG, "GuiEnergyMachine_BtnMuaThemXang", this.img.width / 2 + 40, this.img.height - 85);
				
				AddButtonEx("card1", "GuiEnergyMachine_ImgCardPetrol", 84, 211);
				AddButtonEx("card2", "GuiEnergyMachine_ImgCardPetrol", 192, 211);
				AddButtonEx("card3", "GuiEnergyMachine_ImgCardPetrol", 302, 211);
				AddButtonEx("card4", "GuiEnergyMachine_ImgCardPetrol", 412, 211);
				
				btnExNum1 = AddButtonEx("id_btn_petrol1", "Petrol1", 100, 230);
				btnExNum2 = AddButtonEx("id_btn_petrol2", "Petrol2", 210, 230);
				btnExNum3 = AddButtonEx("id_btn_petrol3", "Petrol3", 320, 230);
				btnExNum4 = AddButtonEx("id_btn_petrol4", "Petrol4", 430, 230);
				
				//btnExNum1.SetScaleXY(0.8);
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Bình xăng 1 ngày";
				btnExNum1.setTooltip(tooltip);
				
				//btnExNum2.SetScaleXY(0.8);
				tooltip = new TooltipFormat();
				tooltip.text = "Bình xăng 3 ngày";
				btnExNum2.setTooltip(tooltip);
				
				//btnExNum3.SetScaleXY(0.8);
				tooltip = new TooltipFormat();
				tooltip.text = "Bình xăng 7 ngày";
				btnExNum3.setTooltip(tooltip);
				
				//btnExNum4.SetScaleXY(0.8);
				tooltip = new TooltipFormat();
				tooltip.text = "Bình xăng 30 ngày";
				btnExNum4.setTooltip(tooltip);
				
				txtNum1 = AddLabel("x " + numPetrol1.toString() , btnExNum1.img.x - 40 , btnExNum1.img.y + 66 );
				txtNum2 = AddLabel("x " + numPetrol2.toString() , btnExNum2.img.x - 40, btnExNum2.img.y + 66 );
				txtNum3 = AddLabel("x " + numPetrol3.toString() , btnExNum3.img.x - 40, btnExNum3.img.y + 66 );
				txtNum4 = AddLabel("x " + numPetrol4.toString() , btnExNum4.img.x - 40, btnExNum4.img.y + 66 );
				
				//var textLbl:TextField = AddLabel("Bình xăng 7 ngày", this.img.width / 2 - 40, this.img.height / 2 - 30);
				var format:TextFormat = new TextFormat();
				format.bold = true;
				format.color = 0xFF0000;
				format.size = 20;
				txtNum1.setTextFormat(format);
				txtNum2.setTextFormat(format);
				txtNum3.setTextFormat(format);
				txtNum4.setTextFormat(format);
				
				ctnChooseType1 = AddButtonEx("choose1", "GuiEnergyMachine_CtnChooseType", btnExNum1.img.x , btnExNum1.img.y + 90);
				ctnChooseType1.SetScaleXY(0.8);
				ctnChooseType2 = AddButtonEx("choose2", "GuiEnergyMachine_CtnChooseType", btnExNum2.img.x, btnExNum1.img.y + 90);
				ctnChooseType2.SetScaleXY(0.8);
				ctnChooseType3 = AddButtonEx("choose3", "GuiEnergyMachine_CtnChooseType", btnExNum3.img.x, btnExNum1.img.y + 90);
				ctnChooseType3.SetScaleXY(0.8);
				ctnChooseType4 = AddButtonEx("choose4", "GuiEnergyMachine_CtnChooseType", btnExNum4.img.x, btnExNum1.img.y + 90);
				ctnChooseType4.SetScaleXY(0.8);
				curChooseType = 1;
				imgSelect = AddImage("", "GuiEnergyMachine_IcComplete2", ctnChooseType1.img.x + 17, ctnChooseType1.img.y + ctnChooseType1.img.height - 16);
				if (numPetrol1 == 0)
				{
					btnDoXang.SetDisable();
				}
				
				numPetrol1 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 1);
				numPetrol2 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 2);
				numPetrol3 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 3);
				numPetrol4 = GameLogic.getInstance().user.GetStoreItemCount("Petrol", 4);
				txtNum1.text = "x " + numPetrol1.toString();
				txtNum2.text = "x " + numPetrol2.toString();
				txtNum3.text = "x " + numPetrol3.toString();
				txtNum4.text = "x " + numPetrol4.toString();
				var format1:TextFormat = new TextFormat();
				format1.bold = true;
				format1.color = 0xFF0000;
				format1.size = 20;
				txtNum1.setTextFormat(format1);
				txtNum2.setTextFormat(format1);
				txtNum3.setTextFormat(format1);
				txtNum4.setTextFormat(format1);
			}
			
			LoadRes("GuiEnergyMachine_Theme");
		}
		
		public function ShowPetrol():void
		{
			//var myId:Number = GameLogic.getInstance().user.GetMyInfo().Id;
			//var uId:Number = GameLogic.getInstance().user.Id;
			//if (myId == uId)
			//{
				Show(Constant.GUI_MIN_LAYER, 6);
			//}
			
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case ID_BTN_THOAT:
					Hide();
					break;
				case ID_BTN_DO_XANG:
					GameLogic.getInstance().UsePetrol(curChooseType);
					Hide();
					break;
				case ID_BTN_MUA_XANG:
					//GuiMgr.getInstance().GuiShop.InitGUI();
					GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
					GuiMgr.getInstance().GuiShop.curPage = 0;
					GuiMgr.getInstance().GuiShop.Show(Constant.GUI_MIN_LAYER, 6);
					Hide();
					//StateBuyShop = 1;
					//GuiMgr.getInstance().GuiShop.showTab("Special");
					break;
				case"id_btn_petrol1":
				case"card1":
				case "choose1":
					curChooseType = 1;
					imgSelect.SetPos(ctnChooseType1.img.x + 17, ctnChooseType1.img.y + ctnChooseType1.img.height - 16);
					//if(GameLogic.getInstance().user.GetMyInfo().energyMachine.IsExpired)
						if (numPetrol1 > 0)
						{
							btnDoXang.SetEnable();
						}
						else
						{
							btnDoXang.SetEnable(false);
						}
					break;
				case"id_btn_petrol2":
				case"card2":
				case "choose2":
					curChooseType = 2;
					imgSelect.SetPos(ctnChooseType2.img.x + 17, ctnChooseType2.img.y + ctnChooseType2.img.height - 16);
					//if(GameLogic.getInstance().user.GetMyInfo().energyMachine.IsExpired)
						if (numPetrol2 > 0)
						{
							btnDoXang.SetEnable();
						}
						else
						{
							btnDoXang.SetEnable(false);
						}
						break;
				case"id_btn_petrol3":
				case"card3":
				case "choose3":
					curChooseType = 3;
					imgSelect.SetPos(ctnChooseType3.img.x + 17, ctnChooseType3.img.y + ctnChooseType3.img.height - 16);
					//if(GameLogic.getInstance().user.GetMyInfo().energyMachine.IsExpired)
						if (numPetrol3 > 0)
						{
							btnDoXang.SetEnable();
						}
						else
						{
							btnDoXang.SetEnable(false);
						}
					break;
				case"id_btn_petrol4":
				case"card4":
				case "choose4":
					curChooseType = 4;
					imgSelect.SetPos(ctnChooseType4.img.x + 17, ctnChooseType4.img.y + ctnChooseType4.img.height - 16);
					//if(GameLogic.getInstance().user.GetMyInfo().energyMachine.IsExpired)
						if (numPetrol4 > 0)
						{
							btnDoXang.SetEnable();
						}
						else
						{
							btnDoXang.SetEnable(false);
						}
					break;
				
			}
		}
		
		
	}

}