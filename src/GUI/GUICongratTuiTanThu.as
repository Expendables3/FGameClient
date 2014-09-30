package GUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.Container;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Logic.Ultility;
	import flash.geom.Point;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUICongratTuiTanThu extends BaseGUI 
	{
		private var BTN_CLOSE:String = "buttonClose";
		private var BTN_NHAN:String = "buttonNhan";
	
		private var buttonClose:Button;
		private var buttonShare:Button;
		
		
		public function GUICongratTuiTanThu(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUICongratTuiTanThu";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButtons();
				if(GameLogic.getInstance().user.tuiTanThu.giftList)
				AddImgs(GameLogic.getInstance().user.tuiTanThu.giftList);
				ShowDisableScreen(0.5);
				SetPos(200, 125);
			}
			LoadRes("GuiCongratTuiTanThu_Theme");
		}
		
		public function ShowGui():void 
		{
			Show();
		}
		
		private function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 340, 55, this);
			AddButton(BTN_NHAN, "GuiCongratTuiTanThu_BtnNhanThuong", 130, 260, this)
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
					GameLogic.getInstance().user.tuiTanThu.UpdateBonus();
					HideDisableScreen();
					Hide();
				break;
				case BTN_NHAN:
					GameLogic.getInstance().user.tuiTanThu.UpdateBonus();
					Hide();
					HideDisableScreen();

				break;
			}
		}
		
		private function AddImgs(a:Array):void 
		{
			if (!a)
			return;
			//Add ảnh
						//imgName = bonus.ItemType + bonus.ItemId;
						//image = conAward.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(-5, 0));
						//
						//Add số lượng
						//tf = conAward.AddLabel(Ultility.StandardNumber(bonus.Num), 5, 40, 0xffffff, 1, 0x26709C);
						//format.size = 11;
						//format.color = 0xffffff;
						//tf.setTextFormat(format);	
						
			var image:Image;
			var imgName:String;
			var tf:TextField= new TextField();
			var format:TextFormat = new TextFormat();
			var ttipText:String = "";
			var xPos:int = 101 - 67;
			var yPost:int = 0;
			
			yPost = 145;
			if (a)
			{
				for (var i:int = 0; i < a.length; i++) 
				{
					if ("ItemType" in a[i] )
					{
						var s:String = a[i]["ItemType"];
						//var ct:Container = AddContainer("", "", 90 + i * 60, 140);
						xPos += 67;
						switch(s)
						{
							case "Money":
								//Add ảnh
								imgName = "IcGold";
								image = AddImage("", imgName, xPos, yPost,true,ALIGN_LEFT_TOP);
								//image.SetScaleXY(2);
								
								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								break;
							case "Exp":
								imgName = "ImgEXP";
								//ct.LoadRes(imgName);
								image = AddImage("", "ImgEXP", xPos, yPost,true,ALIGN_LEFT_TOP);
								//image.SetScaleXY(1.5);
								//conAward.AddImage("", "BGSoLuong", 55, 50);
								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								break;
							case "Samurai":
								image = AddImage("", s + a[i].ItemId, xPos, yPost, true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.7);
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								break;
							case "Other":				
							case "OceanTree":
								imgName = a[i]["ItemType"] + a[i]["ItemId"];
								//ct.LoadRes(imgName);
								image = AddImage("", imgName, xPos + 25, yPost + 55, true, ALIGN_LEFT_TOP);
								//image.FitRect(72, 69, new Point(60, 58));
								if (a[i]["ItemId"] == 42)
								{
									image.SetScaleXY(0.3);
									
								}
								else
								{
									image.SetScaleXY(0.5);
								}
								if (a[i]["Num"] && a[i]["Num"] > 0)
								{
									tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
									format.size = 14;
									format.color = 0xffffff;
									tf.setTextFormat(format);
								}
								
								break;
							case "Material":
							case "RecoverHealthSoldier":
							case "Samurai":
							case "RankPointBottle":
							case "Ginseng":
							case "Gem":
								//Add ảnh
								imgName = a[i]["ItemType"] + a[i]["ItemId"];
								//ct.LoadRes(imgName);
								image = AddImage("", imgName, xPos, yPost, true, ALIGN_LEFT_TOP);
								
								//image.FitRect(55,55,new Point(xPos+40-image.img.width/2 - 30, yPost + (40 - image.img.height / 2) -27 ));
								//image.SetPos(xPos+40-image.img.width/2, yPost + (40 - image.img.height / 2) );

								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								//
								//tooltip txt
								//ttipText = "\n" + Localization.getInstance().getString("Tooltip30");					
								break;
								
							case "EnergyItem":
								//Add ảnh
								imgName = a[i]["ItemType"] + a[i]["ItemId"];
								
								image = AddImage("", imgName, xPos+10, yPost+10, true, ALIGN_LEFT_TOP);
								
								
								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);	
								break;
							case "ZMoney":
								imgName = "IcZingXu";
								
								image = AddImage("", imgName, xPos, yPost,true,ALIGN_LEFT_TOP);
								//image.SetScaleXY(2);
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							//	image.SetScaleX(2.2);
								//image.SetScaleY(2.2);
							break;
							case "FairyDrop":
								imgName = "IconFairy";
								image = AddImage("", imgName, xPos + 10, yPost , true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.9);
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							break;
							case "SpecialFish":
								imgName = "Fish" + a[i]["ItemId"] + "_Old_Idle";
								image = AddImage("", imgName, xPos+30, yPost+30, true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.8);
							
							break;
							case "RareFish":
							case "BabyFish":
								
							//if (a[[i]["ItemId"] == "")
								//{
									 //Lấy ID cá theo level hiện tại
									//a[[i]["ItemId"] = ConfigJSON.getInstance().GetLevelFish(GuiMgr.getInstance().GuiDailyBonus.GiftList["4"]["Level"]);
								//}
								imgName = "Fish" + a[i]["ItemId"] + "_Old_Idle";
								
								image = AddImage("", imgName, xPos+25, yPost+25, true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.8);
								//tt.text = Localization.getInstance().getString("Fish" + giftObject["ItemId"]);	
							break;	
							
							case "PowerTinh":
							case "Iron":
							case "Jade":
							
							case "SixColorTinh":
								imgName = a[i]["ItemType"];
								//ct.LoadRes(imgName);
								image = AddImage("", imgName, xPos, yPost, true, ALIGN_LEFT_TOP);
								//image.FitRect(45,45,new Point(xPos+40-image.img.width/2 - 18, yPost + (40 - image.img.height / 2) - 17) );
								
								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							break;
							case "SoulRock":
								imgName = a[i]["ItemType"];
								image = AddImage("", imgName, xPos, yPost, true, ALIGN_LEFT_TOP);
								var imageRank:Image = AddImage("", "Number_" + a[i]["ItemId"], -5, 0, true, ALIGN_LEFT_TOP);
								imageRank.FitRect(20, 20, new Point( xPos+14, yPost+18));
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-23, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							break;
						};
						
						image.FitRect(45, 45, new Point(xPos, yPost));
					}
					
				}	
			}	
		}
		
		
		
	}

}