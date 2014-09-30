package GUI.EventEuro 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.EventEuro.ItemFixture;
	import GUI.EventEuro.Packet.SendBuyBall;
	import GUI.EventEuro.Packet.SendPrediction;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIPrediction extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_NORMAL_PREDICTION:String = "btnNormalPrediction";
		static public const BTN_VIP_PREDICTION:String = "btnVipPrediction";
		static public const BTN_TAB_CHOOSE_A:String = "predictionA";
		static public const BTN_TAB_DRAW:String = "predictionDraw";
		static public const BTN_TAB_CHOOSE_B:String = "predictionB";
		static public const BTN_BUY_NORMAL_BALL:String = "btnBuyNormalBall";
		static public const TXT_BOX_NORMAL_LEVEL:String = "txtBoxNormalLevel";
		static public const BTN_MAX_NORMAL_LEVEL:String = "btnMaxNormalLevel";
		static public const CTN_NORMAL_GIFT:String = "ctnNormalGift";
		static public const BTN_BUY_VIP_BALL:String = "btnBuyVipBall";
		static public const TXT_BOX_VIP_LEVEL:String = "txtBoxVipLevel";
		static public const CTN_VIP_GIFT:String = "ctnVipGift";
		static public const BTN_NORMAL_ACCEPT:String = "btnNormalAccept";
		static public const BTN_CANCEL:String = "btnCancel";
		static public const BTN_VIP_ACCEPT:String = "btnVipAccept";
		static public const BTN_MAX_VIP_LEVEL:String = "btnMaxVipLevel";
		static public const BTN_BUY_MANY_VIP_BALL:String = "btnBuyManyVipBall";
		static public const BTN_BUY_MANY_NORMAL_BALL:String = "btnBuyManyNormalBall";
		static public const CNT_VIP_EFF:String = "cntVipEff";
		static public const CNT_NORMAL_EFF:String = "cntOrdEff";
		private var ctnDetailInfo:Container;
		private var imgNormalPrection:Image;
		private var btnNormalPrection:Button;
		private var imgVIPPrediction:Image;
		private var btnVIPPrediction:Button;
		private var itemFixture:ItemFixture;
		private var background:Image;
		private var imgChooseA:Image;
		private var btnChooseA:Button;
		private var imgDraw:Image;
		private var btnDraw:Button;
		private var imgChooseB:Image;
		private var btnChoseB:Button;
		private var ctnNormalInfo:Container;
		private var labelNormalBall:TextField;
		private var textBoxNormalLevel:TextBox;
		private var ctnVipInfo:Container;
		private var labelVipBall:TextField;
		private var textBoxVipLevel:TextBox;
		private var _isNormal:Boolean;
		private var _numNormalLevel:int;//Số bóng thường đặt cược
		private var _numVipLevel:Number;//Số bóng vip đặt cược
		private var predict:int;//1,2,3 du doan thang, hoa, thua
		private var _numVipBall:int;//Số bóng vip
		private var _numNormalBall:int;//Số bóng thường
		private var labelNormalMedalReward:TextField;
		private var labelVipMedalReward:TextField;
		
		public function GUIPrediction(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(35 + 17, 5);
				//Thông tin chọn cá cược
				ctnDetailInfo = AddContainer("", "GuiPrediction_DetailInfoBg", 62, 0);
				imgNormalPrection= ctnDetailInfo.AddImage("", "GuiPrediction_SelectedNormalPredict", 108 - 30, 18, true, ALIGN_LEFT_TOP);
				btnNormalPrection = ctnDetailInfo.AddButton(BTN_NORMAL_PREDICTION, "GuiPrediction_BtnTabNormalPredict", imgNormalPrection.img.x, imgNormalPrection.img.y, this);
				imgVIPPrediction = ctnDetailInfo.AddImage("", "GuiPrediction_SelectedVIPPredict", imgNormalPrection.img.x + imgNormalPrection.img.width + 6, imgNormalPrection.img.y, true, ALIGN_LEFT_TOP);
				btnVIPPrediction = ctnDetailInfo.AddButton(BTN_VIP_PREDICTION, "GuiPrediction_BtnTabVIPPredict", imgVIPPrediction.img.x, imgVIPPrediction.img.y, this);
				
				var config:Object = ConfigJSON.getInstance().GetItemList("EventEuro_BetLevel");
				//Cược bóng thường
				var i:int;
				var txtFormat:TextFormat = new TextFormat("arial", 17, 0xffffff, true);
				ctnNormalInfo = new Container(ctnDetailInfo.img, "", -29, 10);
				ctnNormalInfo.LoadRes("");
				ctnNormalInfo.AddImage("", "GuiPrediction_TxtBg", 200 + 138, 62);
				ctnNormalInfo.AddImage("", "Ic_ORDBall", 200 + 138, 40).FitRect(30, 30, new Point(200 + 138 - 91, 46));
				ctnNormalInfo.AddLabel("Mức cược: ", 150, 55, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				textBoxNormalLevel = ctnNormalInfo.AddTextBox(TXT_BOX_NORMAL_LEVEL, "Nhập số bóng", 263, 52, 150, 30, this);
				textBoxNormalLevel.textField.autoSize = "center";
				textBoxNormalLevel.textField.alpha = 0.5;
				textBoxNormalLevel.SetDefaultFormat(txtFormat);
				textBoxNormalLevel.SetTextFormat(txtFormat);
				ctnNormalInfo.AddButton(BTN_MAX_NORMAL_LEVEL, "GuiPrediction_BtnAll", 150 + 273, 50, this);
				var configORD:Object = config["ORD"][itemFixture.numStar];
				for (i = 1; i <= 3; i ++)
				{
					var eff:Image = ctnNormalInfo.AddImage(CNT_NORMAL_EFF + "_" + i, "GuiPrediction_EffectTrunk", i * 180 - 44 + 171, 245);
					eff.img.scaleX = eff.img.scaleY = 0.7;
					eff.img.mouseEnabled = false;
					eff.img.mouseChildren = false;
					eff.img.visible = false;
					ctnNormalInfo.AddContainer(CTN_NORMAL_GIFT +"_" + i, "TrunkORD" + i, i * 180 -44, 100, true, this).enable = false;
					ctnNormalInfo.AddImage("", "Ic_ORDBall", i * 180 - 76, 151).FitRect(30, 30, new Point(i * 180 -76, 151));
					if(i <3)
					{
						var temp:int = configORD[i+1];
						temp --;
						ctnNormalInfo.AddLabel(Ultility.StandardNumber(configORD[i]) + " - " + Ultility.StandardNumber(temp) , i * 180 - 45, 155, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
					}
					else
					{
						ctnNormalInfo.AddLabel("> " + Ultility.StandardNumber(configORD[i]-1), i * 180 - 45, 155, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
					}
				}
				labelNormalMedalReward = ctnNormalInfo.AddLabel("Thưởng: ", 250, 189, 0xffffff, 2, 0x000000);
				labelNormalMedalReward.autoSize = "right";
				labelNormalMedalReward.defaultTextFormat = txtFormat;
				labelNormalMedalReward.setTextFormat(txtFormat);
				//numNormalLevel = 0;
				ctnNormalInfo.AddButton(BTN_NORMAL_ACCEPT, "GuiPrediction_BtnAccept", 188, 225, this);
				ctnNormalInfo.AddButton(BTN_CANCEL, "BtnDong", 220 + 145, 227, this);
				
				//Cược bóng VIP
				ctnVipInfo = new Container(ctnDetailInfo.img, "", -29, 10);
				ctnVipInfo.LoadRes("");
				ctnVipInfo.AddImage("", "GuiPrediction_VipTxtBg", 200 + 138, 62);
				ctnVipInfo.AddImage("", "Ic_VIPBall", 200 + 138, 40).FitRect(30, 30, new Point(200 + 138 - 91, 46));
				ctnVipInfo.AddLabel("Mức cược: ", 150, 55, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				textBoxVipLevel = ctnVipInfo.AddTextBox(TXT_BOX_VIP_LEVEL, "Nhập số bóng", 263, 30 + 22, 150, 30, this);
				textBoxVipLevel.textField.alpha = 0.5;
				textBoxVipLevel.textField.autoSize = "center";
				textBoxVipLevel.SetDefaultFormat(txtFormat);
				textBoxVipLevel.SetTextFormat(txtFormat);
				ctnVipInfo.AddButton(BTN_MAX_VIP_LEVEL, "GuiPrediction_BtnAll", 150 + 273, 50, this);
				var configVIP:Object = config["VIP"][itemFixture.numStar];
				for (i = 1; i <= 3; i ++)
				{
					var effImage:Image = ctnVipInfo.AddImage(CNT_VIP_EFF + "_" + i, "GuiPrediction_EffectTrunk", i * 180 - 44 + 171, 245);
					effImage.img.scaleX = effImage.img.scaleY = 0.7;
					effImage.img.mouseEnabled = false;
					effImage.img.mouseChildren = false;
					effImage.img.visible = false;
					ctnVipInfo.AddContainer(CTN_VIP_GIFT + "_" + i, "TrunkVIP" + i , i * 180 -44, 100, true, this).enable = false;
					ctnVipInfo.AddImage("", "Ic_VIPBall", i * 180 - 76, 151).FitRect(30, 30, new Point(i * 180 -76, 151));
					if(i <3)
					{
						var temp2:int = configVIP[i+1];
						temp2--;
						ctnVipInfo.AddLabel(Ultility.StandardNumber(configVIP[i]) + " - " + Ultility.StandardNumber(temp2), i * 180 -45, 155, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
					}
					else
					{
						ctnVipInfo.AddLabel("> " + Ultility.StandardNumber(configVIP[i] -1), i * 180 -45, 155, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
					}
				}
				labelVipMedalReward = ctnVipInfo.AddLabel("Thưởng: ", 250, 189, 0xffffff, 2, 0x000000);
				labelVipMedalReward.autoSize = "right";
				labelVipMedalReward.defaultTextFormat = txtFormat;
				labelVipMedalReward.setTextFormat(txtFormat);
				//numVipLevel = 0;
				ctnVipInfo.AddButton(BTN_VIP_ACCEPT, "GuiPrediction_BtnAccept", 188, 225, this);
				ctnVipInfo.AddButton(BTN_CANCEL, "BtnDong", 220 + 145, 227, this);
				
				isNormal = true;
				
				var mask:Sprite = new Sprite();
				mask.graphics.beginFill(0xff0000);
				mask.graphics.drawRect(62, 305, ctnDetailInfo.img.width + 10, ctnDetailInfo.img.height + 10);
				mask.graphics.endFill();
				img.addChild(mask);
				ctnDetailInfo.img.mask = mask;
				ctnDetailInfo.img.visible = false;
				
				//Vẽ background và thông tin 2 đội
				background = AddImage("", "GuiPrediction_Theme", 0, 0, true, ALIGN_LEFT_TOP);
				
				txtFormat = new TextFormat("arial", 18, 0xffffff);
				var teamAName:String = Localization.getInstance().getString(itemFixture.teamA);
				var teamBName:String = Localization.getInstance().getString(itemFixture.teamB);
				AddLabel(teamAName, 128 + 118 -68, 85+31, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				AddLabel(teamBName, 328 + 103 + 45,85 +30, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				AddImage("", "Flag_" + itemFixture.teamA, 227, 170);
				AddImage("", "Effect_Flag", 297, 215).GoToAndPlay(15 + Math.random()*60);
				AddImage("", "Ic_VS", 444, 190);
				AddImage("", "Flag_" + itemFixture.teamB, 523, 170);
				AddImage("", "Effect_Flag", 593, 215).GoToAndPlay(15 + Math.random()*60);;
				var x00:int = 332;
				var dxx:int = 20;
				for (i = 0; i < 5; i++)
				{
					if(i < itemFixture.numStar)
					{
						AddImage("", "Ic_Star", x00 + dxx * i, 49 + 81, true, ALIGN_LEFT_TOP).SetScaleXY(0.5);
					}
					else
					{
						AddImage("", "Ic_DarkStar", x00 + dxx * i, 49+ 81, true, ALIGN_LEFT_TOP).SetScaleXY(0.5);
					}
				}
				
				AddContainer(BTN_TAB_CHOOSE_A, "GuiPrediction_IcTick", 217, 211, true, this).img.buttonMode = true;
				imgChooseA = AddImage("", "IcComplete", 212, 201, true, ALIGN_LEFT_TOP);
				btnChooseA = AddButton(BTN_TAB_CHOOSE_A, "GuiPrediction_BtnWin", 190, 241, this);
				if(itemFixture.matchType == ItemFixture.MATCH_TYPE_BOARD)
				{
					btnDraw = AddButton(BTN_TAB_DRAW, "GuiPrediction_BtnDraw", 226 + 114, 240, this);
					AddContainer(BTN_TAB_DRAW, "GuiPrediction_IcTick", 366, 211, true, this).img.buttonMode = true;
				}
				imgDraw = AddImage("", "IcComplete", 248 + 114, 200, true, ALIGN_LEFT_TOP);
				btnChoseB = AddButton(BTN_TAB_CHOOSE_B, "GuiPrediction_BtnWin", 266 + 2 * 114, 240, this);
				AddContainer(BTN_TAB_CHOOSE_B, "GuiPrediction_IcTick", 519, 211, true, this).img.buttonMode = true;
				imgChooseB = AddImage("", "IcComplete", 286 + 2*114, 200, true, ALIGN_LEFT_TOP);
				imgChooseA.img.visible = false;
				imgChooseB.img.visible = false;
				imgDraw.img.visible = false;
				
				//So Bong thuong
				AddImage("", "GuiPrediction_NumberBg", 80 + 77 , 33 + 55);
				var ctnOrdBall:Container = AddContainer("", "Ic_ORDBall", 80 + 77, 21);
				ctnOrdBall.FitRect(30, 30, new Point(67, 19 + 55));
				tooltip = new TooltipFormat();
				tooltip.text = Localization.getInstance().getString("TooltipORDBall");
				ctnOrdBall.setTooltip(tooltip);
				labelNormalBall = AddLabel("", 80 + 34, 21 + 55, 0xffffff, 1, 0x000000);
				labelNormalBall.defaultTextFormat = txtFormat;
				numNormalBall = GuiMgr.getInstance().guiEventEuro.numNormalBall;
				AddButton(BTN_BUY_MANY_NORMAL_BALL, "GuiPrediction_BtnBuyBall", 190 + 50, 78, this);
				
				//So bong vang
				AddImage("", "GuiPrediction_VipNumberBg", 80 + 177 + 245, 88);
				var ctnVipBall:Container = AddContainer("", "Ic_VIPBall", 80 + 177, 21);
				ctnVipBall.FitRect(30, 30, new Point(167 + 245, 55 + 19));
				tooltip = new TooltipFormat();
				tooltip.text = Localization.getInstance().getString("TooltipVIPBall");
				ctnVipBall.setTooltip(tooltip);
				labelVipBall = AddLabel("", 180 + 34 + 245,55+ 21, 0xffffff, 1, 0x000000);
				labelVipBall.defaultTextFormat = txtFormat;
				numVipBall = GuiMgr.getInstance().guiEventEuro.numVipBall;
				AddButton(BTN_BUY_MANY_VIP_BALL, "GuiPrediction_BtnBuyBall", 190 + 150 + 245, 78, this);
				
				//Ti le nguoi du doan
				var ctn:Container = AddContainer("", "GuiPrediction_IcPerson", 197, 267);
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Tỉ lệ người chơi\ndự đoán đội " + teamAName + " thắng";
				ctn.setTooltip(tooltip);
				AddLabel(itemFixture.dataFixture["BetStat"][1] + " %", 197 + 20, 271, 0x33ffff, 0, 0x000000);
				if (itemFixture.matchType == ItemFixture.MATCH_TYPE_BOARD)
				{
					ctn = AddContainer("", "GuiPrediction_IcPerson", 192 + 150, 267);
					tooltip = new TooltipFormat();
					tooltip.text = "Tỉ lệ người chơi\ndự đoán 2 đội hòa";
					ctn.setTooltip(tooltip);
					AddLabel(itemFixture.dataFixture["BetStat"][2] + " %", 197 + 170, 271, 0x33ffff, 0, 0x000000);
				}
				ctn = AddContainer("", "GuiPrediction_IcPerson", 192 + 2*150, 267);
				tooltip = new TooltipFormat();
				tooltip.text = "Tỉ lệ người chơi\ndự đoán đội " + teamBName + " thắng";
				ctn.setTooltip(tooltip);
				AddLabel(itemFixture.dataFixture["BetStat"][3] + " %", 197 + 320, 271, 0x33ffff, 0, 0x000000);
				
				//Huy chuong thuong
				tooltip = new TooltipFormat();
				tooltip.text = "Huy chương Euro\nđược thưởng thêm dựa trên mức cược của bạn.\nDùng để đua TOP dự đoán";
				var ctnMedal:Container = ctnDetailInfo.AddContainer("", "Ic_Medal", 257 + 104 - 29, 222 - 30);
				ctnMedal.img.scaleX = ctnMedal.img.scaleY = 0.4;
				ctnMedal.setTooltip(tooltip);
				
				AddButton(BTN_CLOSE, "BtnThoat", 409 + 293, 18, this);
				
				//Khoi tao cac bien
				_numVipLevel = 0;
				_numNormalLevel = 0;
			}
			
			LoadRes("GuiPrediction_Theme");
		}
		
		public function showGUI(_itemFixture:ItemFixture):void
		{
			itemFixture = _itemFixture;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnHideGUI():void 
		{
			GuiMgr.getInstance().guiEventEuro.img.visible = true;
			GuiMgr.getInstance().guiEventEuro.numNormalBall = numNormalBall;
			GuiMgr.getInstance().guiEventEuro.numVipBall = numVipBall;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var dataPrediction:Object;
			var config:Object;
			var cost:int;
			var guiEventEuro:GUIEventEuro = GuiMgr.getInstance().guiEventEuro;
			switch(buttonID)
			{
				case BTN_BUY_MANY_NORMAL_BALL:
					GuiMgr.getInstance().guiBuyBalls.showGUI("ORD", function f(num:int, priceType:String):void
					{
						if (num > 0)
						{
							config = ConfigJSON.getInstance().GetItemList("Param");
							config = config["EventEuro"]["BuyBall"]["ORD"][priceType];
							cost = Number(config) * num;
							if(priceType == "ZMoney")
							{
								if (cost <= GameLogic.getInstance().user.GetZMoney())
								{
									Exchange.GetInstance().Send(new SendBuyBall("ORD", num, priceType));
									numNormalBall += num;
									
									GameLogic.getInstance().user.UpdateUserZMoney( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng thường", "Ic_ORDBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
								}
							}
							else
							if (priceType == "Money")
							{
								if (cost <= GameLogic.getInstance().user.GetMoney())
								{
									GuiMgr.getInstance().guiEventEuro.numBuyGoldOrd -= num;
									Exchange.GetInstance().Send(new SendBuyBall("ORD", num, priceType));
									numNormalBall += num;
									
									GameLogic.getInstance().user.UpdateUserMoney( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng thường", "Ic_ORDBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng");
								}
							}
						}
					});
					break;
				case BTN_BUY_MANY_VIP_BALL:
					GuiMgr.getInstance().guiBuyBalls.showGUI("VIP", function f(num:int, priceType:String):void
					{
						if (num > 0)
						{
							config = ConfigJSON.getInstance().GetItemList("Param");
							config = config["EventEuro"]["BuyBall"]["VIP"][priceType];
							cost = Number(config) * num;
							if(priceType == "ZMoney")
							{
								if (cost <= GameLogic.getInstance().user.GetZMoney())
								{
									Exchange.GetInstance().Send(new SendBuyBall("VIP", num, priceType));
									numVipBall += num;
									
									GameLogic.getInstance().user.UpdateUserZMoney( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng vàng", "Ic_VIPBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
								}
							}
							else
							if (priceType == "Diamond")
							{
								if (cost <= GameLogic.getInstance().user.getDiamond())
								{
									Exchange.GetInstance().Send(new SendBuyBall("VIP", num, priceType));
									numVipBall += num;
									
									GameLogic.getInstance().user.updateDiamond( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng vàng", "Ic_VIPBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
								}
							}
						}
					});
					break;
				case BTN_MAX_NORMAL_LEVEL:
					numNormalLevel = numNormalBall;
					break;
				case BTN_MAX_VIP_LEVEL:
					numVipLevel = numVipBall;
					break;
				//case BTN_BUY_NORMAL_BALL:
					//Exchange.GetInstance().Send(new SendBuyBall("ORD", 1));
					//numNormalBall++;
					//GameLogic.getInstance().user.UpdateUserZMoney( -1);
					//break;
				//case BTN_BUY_VIP_BALL:
					//Exchange.GetInstance().Send(new SendBuyBall("VIP", 1));
					//numVipBall++;
					//GameLogic.getInstance().user.UpdateUserZMoney( -1);
					//break;
				case BTN_CANCEL:
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TAB_CHOOSE_A:
					imgChooseA.img.visible = true;
					imgChooseB.img.visible = false;
					imgDraw.img.visible = false;
					
					ctnDetailInfo.img.visible = true;
					TweenMax.to(ctnDetailInfo.img, 0.3, { bezierThrough:[ { x:62, y:310} ], ease:Expo.easeIn } );
					predict = 1;
					isNormal = _isNormal;
					break;
				case BTN_TAB_CHOOSE_B:
					imgChooseA.img.visible = false;
					imgChooseB.img.visible = true;
					imgDraw.img.visible = false;
					
					ctnDetailInfo.img.visible = true;
					TweenMax.to(ctnDetailInfo.img, 0.3, { bezierThrough:[ { x:62, y:310 } ], ease:Expo.easeIn } );
					predict = 3;
					isNormal = _isNormal;
					break;
				case BTN_TAB_DRAW:
					imgChooseA.img.visible = false;
					imgChooseB.img.visible = false;
					imgDraw.img.visible = true;
					
					ctnDetailInfo.img.visible = true;
					TweenMax.to(ctnDetailInfo.img, 0.3, { bezierThrough:[ { x:62, y:310 } ], ease:Expo.easeIn } );
					predict = 2;
					isNormal = _isNormal;
					break;
				case BTN_NORMAL_PREDICTION:
					isNormal = true;
					break;
				case BTN_VIP_PREDICTION:
					isNormal = false;
					break;
				case BTN_NORMAL_ACCEPT:
					if (GameLogic.getInstance().CurServerTime > itemFixture.matchTimeBegin)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể cược vì trận đấu đã bắt đầu!");
						break;
					}
					var levelNormal:int = getGiftLevel("ORD", itemFixture.numStar, numNormalLevel);
					if (levelNormal < 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn phải cược tối thiểu " + int(-levelNormal) + " bóng thường");
						break;
					}
					trace(numNormalLevel, predict);
					itemFixture.setPrediction(predict, numNormalLevel, "ORD");
					dataPrediction = new Object();
					dataPrediction = itemFixture.dataFixture;
					dataPrediction["BetInfo"] = new Object();
					dataPrediction["BetInfo"]["Bet"] = predict;
					dataPrediction["BetInfo"]["BallNum"] = numNormalLevel;
					dataPrediction["BetInfo"]["BetType"] = "ORD";
					guiEventEuro.addPredictionData(itemFixture.matchId, dataPrediction);
					numNormalBall -= numNormalLevel;
					Exchange.GetInstance().Send(new SendPrediction(itemFixture.matchId, numNormalLevel, "ORD", predict));
					
					//Show so huy chuong nhan duoc
					var rateORD:Number = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MedalExchange"]["ORD"];
					var numORDMedal:Number = Math.floor(numNormalLevel*rateORD);
					//GuiMgr.getInstance().guiNewCongratulation.showGUI("Ic_Medal", numORDMedal, "Đoán đúng sẽ được nhận thêm " +
					//Ultility.StandardNumber(numORDMedal) + " huy chương nữa",
					//function f():void
					//{
						//guiEventEuro.numMedal += numORDMedal;
					//});
					GuiMgr.getInstance().guiRecieveMedal.showGUI(numORDMedal, 
					function f():void
					{
						guiEventEuro.numMedal += numORDMedal;
					});
					Hide();
					break;
				case BTN_VIP_ACCEPT:
					if (GameLogic.getInstance().CurServerTime > itemFixture.matchTimeBegin)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể cược vì trận đấu đã bắt đầu!");
						break;
					}
					var levelVIP:int = getGiftLevel("VIP", itemFixture.numStar, numVipLevel);
					if (levelVIP < 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn phải cược tối thiểu " + int(-levelVIP) + " bóng vàng");
						break;
					}
					trace(numVipLevel, predict);
					itemFixture.setPrediction(predict, numVipLevel, "VIP");
					dataPrediction = new Object();
					dataPrediction = itemFixture.dataFixture;
					dataPrediction["BetInfo"] = new Object();
					dataPrediction["BetInfo"]["Bet"] = predict;
					dataPrediction["BetInfo"]["BallNum"] = numVipLevel;
					dataPrediction["BetInfo"]["BetType"] = "VIP";
					guiEventEuro.addPredictionData(itemFixture.matchId, dataPrediction);
					numVipBall -= numVipLevel;
					
					Exchange.GetInstance().Send(new SendPrediction(itemFixture.matchId, numVipLevel, "VIP", predict));
					
					//Show so huy chuong nhan duoc
					var rateVIP:Number = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MedalExchange"]["VIP"];
					var numVIPMedal:Number = Math.floor(numVipLevel*rateVIP);
					//GuiMgr.getInstance().guiNewCongratulation.showGUI("Ic_Medal", numVIPMedal, "Đoán đúng sẽ được nhận thêm " 
					//+ Ultility.StandardNumber(numVIPMedal) + " huy chương nữa",
					//function f():void
					//{
						//guiEventEuro.numMedal += numVIPMedal;
					//});
					GuiMgr.getInstance().guiRecieveMedal.showGUI(numVIPMedal, 
					function f():void
					{
						guiEventEuro.numMedal += numVIPMedal;
					});
					Hide();
					break;
			}
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var text:String;
			switch(txtID)
			{
				case TXT_BOX_NORMAL_LEVEL:
					text = textBoxNormalLevel.GetText();
					text = text.split(",").join("");
					numNormalLevel = int(text);
					break;
				case TXT_BOX_VIP_LEVEL:
					text = textBoxVipLevel.GetText();
					text = text.split(",").join("");
					numVipLevel = int(text);
					break;
			}
		}
		
		public function get isNormal():Boolean 
		{
			return _isNormal;
		}
		
		public function set isNormal(value:Boolean):void 
		{
			_isNormal = value;
			ctnNormalInfo.SetVisible(value);
			ctnVipInfo.SetVisible(!value);
			btnNormalPrection.SetFocus(value);
			btnVIPPrediction.SetFocus(!value);
			if(value)
			{
				textBoxNormalLevel.textField.stage.focus = textBoxNormalLevel.textField;
				textBoxNormalLevel.textField.setSelection(0, textBoxNormalLevel.textField.length);
			}
			else
			{
				textBoxVipLevel.textField.stage.focus = textBoxVipLevel.textField;
				textBoxVipLevel.textField.setSelection(0, textBoxVipLevel.textField.length);
			}
		}
		
		public function get numNormalLevel():int 
		{
			return _numNormalLevel;
		}
		
		public function set numNormalLevel(value:int):void 
		{
			if (value > numNormalBall)
			{
				value = numNormalBall;
				if(value == 0)
				{
					var txtFormat:TextFormat = new TextFormat("arial", 16, 0xff0000, true);
					txtFormat.align = "center";
					EffectMgr.getInstance().textFly("Mua thêm bóng để đặt cược!", new Point(425, 375), txtFormat);
				}
			}
			_numNormalLevel = value;
			textBoxNormalLevel.textField.alpha = 1;
			textBoxNormalLevel.SetText(Ultility.StandardNumber(value));
			
			var level:int = getGiftLevel("ORD", itemFixture.numStar, value);
			for (var i:int = 1; i <= 3; i++)
			{
				ctnNormalInfo.GetContainer(CTN_NORMAL_GIFT + "_" +i).enable = false;
				ctnNormalInfo.GetImage(CNT_NORMAL_EFF + "_" + i).img.visible = false;
			}
			if(level > 0)
			{
				ctnNormalInfo.GetImage(CNT_NORMAL_EFF + "_" + level).img.visible = true;
				ctnNormalInfo.GetContainer(CTN_NORMAL_GIFT + "_" + level).enable = true;
				//TweenMax.to(ctnNormalInfo.GetContainer(CTN_NORMAL_GIFT + "_"+level).img, 0, { glowFilter: { color:0xff0000, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
			}
			
			var rateNormal:Number = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MedalExchange"]["ORD"];
			labelNormalMedalReward.text = "Thưởng:  " + Ultility.StandardNumber(Math.floor(value*rateNormal));
		}
		
		public function get numVipLevel():Number 
		{
			return _numVipLevel;
		}
		
		public function set numVipLevel(value:Number):void 
		{
			if (value > numVipBall)
			{
				value = numVipBall;
				if(value == 0)
				{
					var txtFormat:TextFormat = new TextFormat("arial", 14, 0xff0000, true);
					txtFormat.align = "center";
					EffectMgr.getInstance().textFly("Mua thêm bóng để đặt cược!", new Point(425, 375), txtFormat);
				}
			}
			_numVipLevel = value;
			textBoxVipLevel.textField.alpha = 1;
			textBoxVipLevel.SetText(Ultility.StandardNumber(value));
			
			var level:int = getGiftLevel("VIP", itemFixture.numStar, value);
			
			for (var i:int = 1; i <= 3 ; i ++)
			{
				ctnVipInfo.GetContainer(CTN_VIP_GIFT + "_" + i).enable = false;
				ctnVipInfo.GetImage(CNT_VIP_EFF + "_" + i).img.visible = false;
			}
			if(level > 0)
			{
				ctnVipInfo.GetImage(CNT_VIP_EFF + "_" + level).img.visible = true;
				ctnVipInfo.GetContainer(CTN_VIP_GIFT + "_" + level).enable = true;
				//TweenMax.to(ctnVipInfo.GetContainer(CTN_VIP_GIFT + "_"+level).img, 0, { glowFilter: { color:0xff0000, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
			}
			var rateVIP:Number = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MedalExchange"]["VIP"];
			labelVipMedalReward.text = "Thưởng:  " + Ultility.StandardNumber(Math.floor(rateVIP*value));
		}
		
		public function get numVipBall():int 
		{
			return _numVipBall;
		}
		
		public function set numVipBall(value:int):void 
		{
			_numVipBall = value;
			labelVipBall.text = Ultility.StandardNumber(value);
		}
		
		public function get numNormalBall():int 
		{
			return _numNormalBall;
		}
		
		public function set numNormalBall(value:int):void 
		{
			_numNormalBall = value;
			labelNormalBall.text = Ultility.StandardNumber(value);
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var giftConfig:Object;
			var levelGift:int;
			if (buttonID.search(CTN_NORMAL_GIFT) >= 0)
			{
				levelGift = buttonID.split("_")[1];
				giftConfig = ConfigJSON.getInstance().GetItemList("EventEuro_BetGifts")["ORD"][levelGift][itemFixture.numStar][1];
				GuiMgr.getInstance().guiGiftTooltip.showGUI(event.stageX, event.stageY, giftConfig);
			}
			else if(buttonID.search(CTN_VIP_GIFT) >= 0)
			{
				levelGift = buttonID.split("_")[1];
				giftConfig = ConfigJSON.getInstance().GetItemList("EventEuro_BetGifts")["VIP"][levelGift][itemFixture.numStar][1];
				GuiMgr.getInstance().guiGiftTooltip.showGUI(event.stageX, event.stageY, giftConfig);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_NORMAL_GIFT) >= 0 || buttonID.search(CTN_VIP_GIFT) >= 0)
			{
				GuiMgr.getInstance().guiGiftTooltip.Hide();
			}
		}
		
		static public function getGiftLevel(typePredict:String, numStar:int, numBall:int):int
		{
			var config:Object = ConfigJSON.getInstance().GetItemList("EventEuro_BetLevel");
			config = config[typePredict][numStar];
			if (numBall >= config[3])
			{
				return 3;
			}
			else if (numBall >= config[2])
			{
				return 2;
			}
			else if(numBall >= config[1])
			{
				return 1;
			}
			return -int(config[1]);
		}
		
	}

}