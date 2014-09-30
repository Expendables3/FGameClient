package GUI 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUITanThuDetailClickWait extends BaseGUI 
	{
		private var BTN_CLOSE:String = "btnClose";
		private var BTN_DONG:String = "btnDong";
		
		private var timeClock:TextField= new TextField();
		private var format1:TextFormat= new TextFormat();
		public function GUITanThuDetailClickWait(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				this.ClassName = "GUITanThuDetailClick";	
				
				AddButtons();
				AddDetail();
				AddImgs(GameLogic.getInstance().user.tuiTanThu.giftList);
				
				ShowDisableScreen(0.5);
				SetPos(180, 80);
			}
			LoadRes("GuiTanThuDetailClickWait_Theme");
		}
		
		public function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 455, 20, this);
			AddButton(BTN_DONG, "BtnDong", 200, 310, this);
			
		}
		
		public function ShowGui():void 
		{
			Show();
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
				case BTN_DONG:
					Hide();
					HideDisableScreen();
				break;
				default:
					
				break;
			}
		}
		
		public function AddDetail():void 
		{
			var f:TextFormat = new TextFormat();
			var lv:int = GameLogic.getInstance().user.Level;
			var times:int = GameLogic.getInstance().user.tuiTanThu.timesOpen;
			timeClock = AddLabel("", 210, 177, 0x096791);
			var t1:TextField=AddLabel("Hiện tại là lần nhận quà thứ "+times+" ở cấp độ thứ "+lv, 190, 138);
			f.size = 18;
			f.color = 0x004080;
			t1.setTextFormat(f);
		}
		
		public function Update(time:String):void 
		{
			timeClock.text ="Còn "+time+" sẽ nhận được  " ;
			format1.size = 18;
			format1.color = 0x004080;
			timeClock.setTextFormat(format1);
		}
		
		public  function  AddImgs(a:Array):void 
		{
			if (!a)
			return;	
			var image:Image;
			var imgName:String;
			var tf:TextField= new TextField();
			var format:TextFormat = new TextFormat();
			var ttipText:String = "";
			var xPos:int = 128 - 94;
			var yPost:int = 0;
		
			yPost = 245;
			if (a)
			{
				for (var i:int = 0; i < a.length; i++) 
				{
					if ("ItemType" in a[i] )
					{
						var s:String = a[i]["ItemType"];
						//var ct:Container = AddContainer("", "", 90 + i * 60, 140);
						xPos += 94;
						switch(s)
						{
							case "Money":
								//Add ảnh
								imgName = "IcGold";
								image = AddImage("", imgName, xPos, yPost,true,ALIGN_LEFT_TOP);
								//image.SetScaleXY(1.8);
							//	image.FitRect(70, 60, new Point(-5, 0));
								
								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								break;
							case "Exp":
								imgName = "ImgEXP";
								//ct.LoadRes(imgName);
								image = AddImage("", "ImgEXP", xPos, yPost,true,ALIGN_LEFT_TOP);
								//image.SetScaleXY(1.3);
								//conAward.AddImage("", "BGSoLuong", 55, 50);
								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								break;
							case "Samurai":
								image = AddImage("", a[i].ItemType + a[i].ItemId, xPos, yPost - 8, true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.8);
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
								break;
							case "Other":				
							case "OceanTree":
								imgName = a[i]["ItemType"] + a[i]["ItemId"];
								//ct.LoadRes(imgName);
								image = AddImage("", imgName, xPos + 25, yPost+35 , true, ALIGN_LEFT_TOP);
							
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
									tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
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
								//image.FitRect(55,55,new Point(xPos+40-image.img.width/2 - 23, yPost + (40 - image.img.height / 2) - 18));
								//image.SetPos(xPos+40-image.img.width/2, yPost + (40 - image.img.height / 2) );

								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
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
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);	
								break;
							case "ZMoney":
								imgName = "IcZingXu";
								
								image = AddImage("", imgName, xPos, yPost,true,ALIGN_LEFT_TOP);
								//image.SetScaleXY(1.8);
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							//	image.SetScaleX(2.2);
								//image.SetScaleY(2.2);
							break;
							case "FairyDrop":
								imgName = "IconFairy";
								image = AddImage("", imgName, xPos + 10, yPost , true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.7);
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							break;
							case "SpecialFish":
								imgName = "Fish" + a[i]["ItemId"] + "_Old_Idle";
								image = AddImage("", imgName, xPos+30, yPost+30, true, ALIGN_LEFT_TOP);
								//image.SetScaleXY(0.5);
							
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
								//image.SetScaleXY(0.5);
								//tt.text = Localization.getInstance().getString("Fish" + giftObject["ItemId"]);	
							break;	
							case "PowerTinh":
							case "Iron":
							case "Jade":
							
							case "SixColorTinh":
								imgName = a[i]["ItemType"];
								//ct.LoadRes(imgName);
								image = AddImage("", imgName, xPos, yPost, true, ALIGN_LEFT_TOP);
								//image.FitRect(55,55,new Point(xPos+40-image.img.width/2 - 23, yPost + (40 - image.img.height / 2) - 18));

								//Add số lượng
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							break;
							case "SoulRock":
								imgName = a[i]["ItemType"];
								image = AddImage("", imgName, xPos, yPost, true, ALIGN_LEFT_TOP);
								var imageRank:Image = AddImage("", "Number_" + a[i]["ItemId"], 0, 0, true, ALIGN_LEFT_TOP);
								imageRank.FitRect(20, 20, new Point( xPos + 14, yPost + 18));
								tf = AddLabel(Ultility.StandardNumber(a[i]["Num"]), xPos-25, yPost+38, 0xffffff, 1, 0x26709C);
								format.size = 14;
								format.color = 0xffffff;
								tf.setTextFormat(format);
							break;
						}
						image.FitRect(45, 45, new Point(xPos, yPost));
					}
				}
					
			}
		}
		
	}

}