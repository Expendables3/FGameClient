package GUI 
{
	import Data.ConfigJSON;
	import Data.INI;
	import flash.display.PixelSnapping;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	/**
	 * ...
	 * @author tuan
	 */
	public class GUIBuyFish extends BaseGUI
	{
		private const GUI_SETFISHINFO_BTN_MALE:String = "ButtonMale";
		private const GUI_SETFISHINFO_BTN_FEMALE:String = "ButtonFemale";
		private const GUI_SETFISHINFO_BTN_CLOSE:String = "ButtonClose";
		private const GUI_SETFISHINFO_BTN_BUY:String = "ButtonBuy";
		private const GUI_SETFISHINFO_BTN_CANCEL:String = "ButtonCancel";
		private const GUI_SETFISHINFO_TB_NAME:String = "1";
		
		private var TextboxName:TextBox;
		public var sexFish:int = 1;
		public var fish:Fish = null;
		public var nFish:int = 0;
		public var randomSex:Boolean = true;
						
		public function GUIBuyFish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISetFishInfo";
		}
		
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				//img = new Sprite();
				//Parent.addChild(img);
				//var Img:Image = AddImage(gjslgjjs);
				
				//LoadRes("GUI_SetFishInfo");
				AddButton(GUI_SETFISHINFO_BTN_MALE, "GuiBuyFish_BtnMale", 165, 120, this);
				AddButton(GUI_SETFISHINFO_BTN_FEMALE, "GuiBuyFish_BtnFemale", 215, 120, this);
				var button:Button = AddButton(GUI_SETFISHINFO_BTN_CLOSE, "BtnThoat", 279, 20, this);
				//button.img.scaleX = button.img.scaleY = 0.6;
				button = AddButton(GUI_SETFISHINFO_BTN_BUY, "GuiBuyFish_BtnGreen", 100, 248, this, INI.getInstance().getHelper("helper10"));
				button.img.width = 50;
				button.img.height = 28;
				//button.img.scaleX = button.img.scaleY = 0.8;
				AddLabel("Mua", 75, 225)
				button = AddButton(GUI_SETFISHINFO_BTN_CANCEL, "GuiBuyFish_BtnRed", 165, 248, this);
				button.img.width = 50;
				button.img.height = 28;
				AddLabel("Hủy", 140, 225)
				//button.img.scaleX = button.img.scaleY = 0.8;
				
				
				//random giới tính cá
				if (randomSex)
				{
					sexFish = 1 - sexFish;
				}
				if (sexFish == 1)
				{
					GetButton(GUI_SETFISHINFO_BTN_MALE).SetHighLight(0xa500b8);
				}
				else
				{
					GetButton(GUI_SETFISHINFO_BTN_FEMALE).SetHighLight(0xa500b8);
				}
				
				/*TextboxName = AddTextBox(GUI_SETFISHINFO_TB_NAME, "a", 13, 25, 120, 20, this);
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.align = TextFormatAlign.CENTER;
				txtFormat.font = "Arial";
				txtFormat.size = 14;
				TextboxName.SetTextFormat(txtFormat);*/
				
				
				
				//Add hình con cá
				if (fish != null)
				{
					var image1:Image = AddImage("",  "GuiBuyFish_CtnMuaCaBg", 100, 135);
					var image2:Image = AddImage("",  Fish.ItemType + fish.FishTypeId + "_Baby_Idle", 130, 155);
					image2.FitRect(75, 75, new Point(image1.img.x + 10, image1.img.y - 5));
				}
				
				
				var format:TextFormat = new TextFormat(null, 20, 0x954200, true);			
				format.size = 13;
				format.color = 0xffffff;
				format.bold = true;
				
				//var obj:Object = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
				var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
							
				//Add giá tiền
				//var BuyType:String = GuiMgr.getInstance().GuiBuyShop.BuyType;
				var BuyType:String = GuiMgr.getInstance().GuiShop.BuyType;
				if (BuyType == "Money")
				{
					AddImage("", "IcGold", 95, 198);
				}
				else
				{
					AddImage("", "IcZingXu", 95, 198);
				}
				var nMoney:int = obj[BuyType];
				format.color = 0xe55600;
				format.size = 17;
				var txt:TextField = AddLabel(Ultility.StandardNumber(nMoney), 110, 188, 0xFFFFFF, 0);
				txt.setTextFormat(format);
				
				
				//Add số lượng cá đã  mua
				txt = AddLabel(nFish.toString(), 220, 188, 0xFFFFFF, 0);
				txt.setTextFormat(format);
				
				//Add 1 số text lên gui
				format.color = 0xCC3333;
				format.bold = true;
				format.size = 18;
				//Add tên cá
				//txt = AddLabel(obj[ConfigJSON.KEY_NAME], 100, 70, 0xFFFFFF);
				txt = AddLabel(obj[ConfigJSON.KEY_NAME], 95, 72, 0xCC3333);
				txt.setTextFormat(format);
				
				format.size = 13;
				format.color = 0x000000;
				txt = AddLabel("Đã mua: ", 140, 188, 0x000000);
				txt.setTextFormat(format);
				
				txt = AddLabel("Giới tính", 160, 95, 0x000000);
				txt.setTextFormat(format);
				
				txt = AddLabel("Đực", 135, 160, 0x000000);
				txt.setTextFormat(format);
				
				txt = AddLabel("Cái", 180, 160, 0x000000);
				txt.setTextFormat(format);
				
				format.size = 17;
				txt = AddLabel("Giá: ", 20, 188, 0x000000);
				txt.setTextFormat(format);
				
				if (Main.imgRoot.stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					//if (!GameController.getInstance().isSmallBackGround)
					//{
						//var p:Point = Ultility.PosLakeToScreen(GuiMgr.getInstance().GuiCharacter.GetPosition().x, 0);
						//var dx:int = 490 - p.x;			
						//GameController.getInstance().PanScreenX(dx);
					//}
					
					SetPos(100, 40);
				}
				else
				{
					SetPos(-170, 40)
				}
			}
			
			LoadRes("GuiBuyFish_Theme");
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_SETFISHINFO_BTN_MALE:
					randomSex = false;
					sexFish = 1;
					GetButton(GUI_SETFISHINFO_BTN_MALE).SetHighLight(0xa500b8);
					(GetButton(GUI_SETFISHINFO_BTN_FEMALE)).SetHighLight(-1);
					break;
				case GUI_SETFISHINFO_BTN_FEMALE:
					randomSex = false;
					sexFish = 0;
					GetButton(GUI_SETFISHINFO_BTN_FEMALE).SetHighLight(0xa500b8);
					GetButton(GUI_SETFISHINFO_BTN_MALE).SetHighLight(-1);
					break;
				case GUI_SETFISHINFO_BTN_CLOSE:
					Close();
					break;
				case GUI_SETFISHINFO_BTN_BUY:
					GameLogic.getInstance().BuyFish(fish);
					break;
				case GUI_SETFISHINFO_BTN_CANCEL:
					Close();
					break;
				default:
					break;
			}
		}
		
		public function Close():void
		{
			Hide();
			GameLogic.getInstance().BackToIdleGameState();
			nFish = 0;
			randomSex = true;
			
			GameController.getInstance().blackHole.img.visible = false;
		}
		
		public function GetNameFish():String
		{
			//return (TextboxName.GetText());
			return "";
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
		}
		
		public function UpdateInfo():void
		{
			//GameController.getInstance().PanScreenX(5);
		}
	}

}