package GUI.FishWar 
{
	import com.bit101.components.Text;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import Logic.FishSoldier;
	import Logic.Friend;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIDiarySolider extends BaseGUI 
	{
		private var labelLostHonour:TextField;
		private var labelMoney:TextField;
		private var labelHonour:TextField;
		private var labelExp:TextField;
		private var listDiary:ListBox;
		private var scrollBar:ScrollBar;
		private var imageDiaryBg:Container;
		private var btnCloseBox:Button;
		private var fishSolider:FishSoldier;
		private var background:Image;
		private var isShowDetail:Boolean;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const BTN_DETAIL:String = "btnDetail";
		static public const BTN_CLOSE_BOX:String = "btnCloseBox";
		
		public function GUIDiarySolider(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				//LoadRes("GUI_Diary_Solider");
				imageDiaryBg = AddContainer("", "GuiDiarySoldier_BoxDiary_Bg", 20, 100);
				listDiary = imageDiaryBg.AddListBox(ListBox.LIST_Y, 3, 1, 0, 5);
				listDiary.setPos(30, 28);
				scrollBar = imageDiaryBg.AddScroll("", "GuiDiarySoldier_ScrollBarExtendDeco", 397, 25);
				scrollBar.setScrollImage(listDiary.img, 0, 165);
				scrollBar.img.scaleX = scrollBar.img.scaleY = 0.8;
				btnCloseBox = imageDiaryBg.AddButton(BTN_CLOSE_BOX, "GuiDiarySoldier_Btn_Open", 240, -5, this);
				btnCloseBox.img.rotation += 90;
				
				var mask:Sprite = new Sprite();
				mask.graphics.beginFill(0xff0000);
				mask.graphics.drawRect(0, 347, imageDiaryBg.img.width + 10, imageDiaryBg.img.height + 10);
				mask.graphics.endFill();
				img.addChild(mask);
				imageDiaryBg.img.mask = mask;
				imageDiaryBg.img.visible = false;
				imageDiaryBg.img.scaleX = imageDiaryBg.img.scaleY = 0.9;
				
				background = AddImage("", "GuiDiarySoldier_GUI_Diary_Solider", 220, 175);
				
				AddButton(BTN_CLOSE, "BtnThoat", 409, 18, this);
				AddButton(BTN_GET_GIFT, "GuiDiarySoldier_Btn_Get_Gift", 64, 300);
				AddButton(BTN_DETAIL, "GuiDiarySoldier_Btn_Detail", 242, 300);
				
				var txtFormat:TextFormat = new TextFormat("arial", 18, 0xff0000, true);
				labelLostHonour = AddLabel("0", 260, 84, 0xff0000, 1);
				labelLostHonour.setTextFormat(txtFormat);
				labelLostHonour.defaultTextFormat = txtFormat;
				
				txtFormat.color = 0x020268;
				labelMoney = AddLabel("0", 89, 184, 0xffff00, 0);
				labelMoney.setTextFormat(txtFormat);
				labelMoney.defaultTextFormat = txtFormat;
				
				labelHonour = AddLabel("0", 210, 184, 0x35db5b, 0);
				labelHonour.setTextFormat(txtFormat);
				labelHonour.defaultTextFormat = txtFormat;
				
				labelExp = AddLabel("0", 330, 184, 0x71e2ff, 0);
				labelExp.setTextFormat(txtFormat);
				labelExp.defaultTextFormat = txtFormat;
				
				SetPos(200, 25);
				
				var imageSolider:Image = AddImage("", fishSolider.ImgName, 0, 0);
				UpdateFishContent(fishSolider, imageSolider);
				imageSolider.FitRect(73, 73, new Point(52, 90));
				
				if (fishSolider.Bonus == null || fishSolider.Bonus.length == 0)
				{
					GetButton(BTN_GET_GIFT).SetVisible(false);
					GetButton(BTN_DETAIL).SetPos(153, 300);
				}
				//trace(fishSolider.Diary);
				var lostRank:Number = 0;
				for (var i:int = fishSolider.Diary.length - 1; i >= 0; i--)
				{
					var ctn:Container = new Container(listDiary.img, "GuiDiarySoldier_ItemDiary_Bg");
					var friend:Friend = GameLogic.getInstance().user.GetFriend(fishSolider.Diary[i]["Attacker"]);
					var userName:String = "Unknown";
					if(friend != null)
					{
						userName = Ultility.StandardString(friend.NickName, 10);
					}
					if (fishSolider.Diary[i]["GemId"] == null)
					{
						ctn.img.addChild(createLabelDiary(fishSolider.Diary[i]["Time"], userName, !fishSolider.Diary[i]["IsWin"], Math.abs(fishSolider.Diary[i]["RankPoint"]), Math.abs(fishSolider.Diary[i]["Money"]), Math.abs(fishSolider.Diary[i]["Exp"])));
					}
					else
					{
						ctn.img.addChild(createLabelGem(userName, fishSolider.Diary[i]["Time"], fishSolider.Diary[i]["Element"], fishSolider.Diary[i]["GemId"], 1));
					}
					
					if (fishSolider.Diary[i]["IsWin"])
					{
						lostRank += Math.abs(fishSolider.Diary[i]["RankPoint"]);
					}
					listDiary.addItem(i.toString(), ctn);
				}
				
				if (!isNaN(lostRank))
				{
					labelLostHonour.text = lostRank.toString();
				}
				
				var numExp:int;
				var numMoney:int;
				var numHonour:int;
				for each(var obj:Object in fishSolider.Bonus)
				{
					switch(obj["ItemType"])
					{
						case "Exp":
							numExp = obj["Num"];
							break;
						case "Money":
							numMoney = obj["Num"];
							break;
						case "Rank":
							numHonour = obj["Num"];
					}
				}
				
				// Add thông tin về số lần bảo vệ
				var numProtect:int = fishSolider.NumDefendFail;
				var lastTimeProtect:Number = fishSolider.LastTimeDefendFail;
				var curDay:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
				var lastDay:Date = new Date(lastTimeProtect * 1000);
				if (curDay.month != lastDay.month || curDay.day != lastDay.day || curDay.fullYear != lastDay.fullYear)
				{
					numProtect = 0;
				}
				
				var tF:TextFormat = new TextFormat();
				tF.bold = true;
				tF.color = 0x020268;
				tF.size = 18;
				tF.bold = true;
				if (numProtect < fishSolider.MaxTimeFail && fishSolider.Rank > 2)
				{
					AddLabel("Còn " + int(fishSolider.MaxTimeFail - numProtect) + " trận thua để trở về trạng thái Bảo Vệ", 170, 230).setTextFormat(tF);
				}
				else
				{
					AddLabel("Đang ở trạng thái Bảo Vệ", 190, 232).setTextFormat(tF);
					AddImage("", "Protector1", 140, 230).FitRect(35, 35, new Point(95, 230));
				}
				
				AddLabel("Khi đạt trạng thái Bảo Vệ, Ngư Thủ phòng thủ thất bại\nsẽ không bị mất điểm chiến công", 70, 260, 0xff0000, 0);
				
				var maxExp:int;
				var maxHonour:int;
				var configMax:Object = ConfigJSON.getInstance().getItemInfo("DefenceSoldier", fishSolider.Rank);
				maxExp = configMax["LimitExp"];
				maxHonour = configMax["LimitRank"];
				if (numExp >= maxExp)
				{
					labelExp.htmlText = Ultility.StandardNumber(maxExp) + "\n<font color = '#ff0000' size = '11'>(đã đạt tối đa)</font>";
				}
				else
				{
					labelExp.text = Ultility.StandardNumber(numExp);
				}
				if (numHonour >= maxHonour)
				{
					labelHonour.htmlText = Ultility.StandardNumber(maxHonour) + "\n<font color = '#ff0000' size = '11'>(đã đạt tối đa)</font>";
				}
				else
				{
					labelHonour.text = Ultility.StandardNumber(numHonour);
				}
				labelMoney.text = Ultility.StandardNumber(numMoney);
				if (listDiary.numItem < 4)
				{
					scrollBar.visible = false;
				}
				this.fishSolider = fishSolider;
				
				isShowDetail = false;
			}
			
			LoadRes("GuiDiarySoldier_Theme");
		}
		
		private function createLabelDiary(time:Number, userName:String, win:Boolean, honour:int, money:int = 0, exp:int = 0):TextField
		{
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			var distanceTime:Number = GameLogic.getInstance().CurServerTime - time;
			var htmlText:String= "<font color = '#ff00ff'>";
			if (distanceTime < 3600)
			{
				if (distanceTime < 60) distanceTime = 60;
				htmlText += Ultility.ConvertTimeToString(distanceTime, false, false, true);
			}
			else if (distanceTime < 86400)
			{
				htmlText += Ultility.ConvertTimeToString(distanceTime, false, true, false);
			}
			else
			{
				htmlText += Ultility.ConvertTimeToString(distanceTime, true, false, false);
			}
			htmlText += "</font> trước, <font color='#0000ff'><b>" + userName + "</b></font> đã tấn công nhà bạn ";
			if(win)
			{
				htmlText += "nhưng thất bại. Bạn nhận được <font color='#35db5b'>" + Ultility.StandardNumber(money) + "$, "	+ Ultility.StandardNumber(honour) + " điểm chiến công, " + Ultility.StandardNumber(exp) + " kinh nghiệm</font>";
			}
			else
			{
				htmlText += "và chiến thắng. Bạn bị mất <font color='#ff0000'>" + Ultility.StandardNumber(honour) + " điểm chiến công</font>";
			}
			
			textField.htmlText = htmlText;
			var txtFormat:TextFormat = new TextFormat("arial", 13, null, true);
			textField.setTextFormat(txtFormat);
			textField.wordWrap = true;
			//textField.border = true;
			textField.width = 360;
			textField.height = 55;
			return textField;
		}
		
		private function createLabelGem(userName:String, time:Number, gemElement:int, gemLevel:int, num:int):TextField
		{
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			var txtFormat:TextFormat = new TextFormat("arial", 13, null, true);
			textField.defaultTextFormat = txtFormat;
			textField.wordWrap = true;
			//textField.border = true;
			textField.width = 360;
			textField.height = 55;
			
			var htmlText:String = "<font color = '#ff00ff'>";
			var distanceTime:Number = GameLogic.getInstance().CurServerTime - time;
			if (distanceTime < 3600)
			{
				if (distanceTime < 60) distanceTime = 60;
				htmlText += Ultility.ConvertTimeToString(distanceTime, false, false, true);
			}
			else if (distanceTime < 86400)
			{
				htmlText += Ultility.ConvertTimeToString(distanceTime, false, true, false);
			}
			else
			{
				htmlText += Ultility.ConvertTimeToString(distanceTime, true, false, false);
			}
			
			htmlText += "</font> trước, <font color='#0000ff'><b>" + userName + "</b></font> đã cho ngư thủ nhà bạn ăn <font color='#ff0000'>" + num + " đan " 
			+ Ultility.GetNameElement(gemElement) + " cấp " + gemLevel + "</font>.";
			
			textField.htmlText = htmlText;
			return textField;
		}
		
		public function showGUI(fishS:FishSoldier):void
		{
			fishSolider = fishS;
			Show(Constant.GUI_MIN_LAYER, 6);
		}
		
		private function UpdateFishContent(curSoldier:FishSoldier, curSoldierImg:Image):void
		{
			var s:String;
			var i:int;
			
			for (s in curSoldier.EquipmentList)
			{
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(curSoldierImg, eq.Type, eq.imageName);
				}
			}
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, Type:String, resName:String = ""):void
		{
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.loadComp = function f():void
				{
					try
					{
						var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
						dob.name = Type;
						child.parent.removeChild(child);
					}
					catch (e:*)
					{
						trace("Load loi GUIDiarySoldier ", Type, index);
					}
				}
				eq.loadRes(resName);
			}
		}
		
		override public function OnHideGUI():void 
		{
			fishSolider.GetRewards();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_GET_GIFT:
					//fishSolider.GetRewards();
					Hide();
					break;
				case BTN_DETAIL:
					if (isShowDetail)
					{
						TweenMax.to(imageDiaryBg.img, 0.3, { bezierThrough:[ { x:20, y:100 } ], ease:Expo.easeIn } );
					}
					else
					{
						imageDiaryBg.img.visible = true;
						TweenMax.to(imageDiaryBg.img, 0.3, { bezierThrough:[ { x:20, y:355 } ], ease:Expo.easeIn } );
					}
					isShowDetail = !isShowDetail;
					break;
				case BTN_CLOSE_BOX:
					TweenMax.to(imageDiaryBg.img, 0.3, { bezierThrough:[ { x:20, y:100 } ], ease:Expo.easeIn } );
					isShowDetail = false;
					break;
			}
		}
		
		private function finishTween(mc:Sprite):void 
		{
			img.removeChild(mc);
		}
	}

}