package GUI.FishWar
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendGetGiftEventSoldier;
	import Sound.SoundMgr;
	
	/**
	 * GUI event choi ca
	 * @author longpt
	 */
	public class GUIEventFishWar extends BaseGUI 
	{
		private static const BTN_CLOSE:String = "BtnClose";
		private static const PRG_10:String = "Prg_1";
		private static const PRG_100:String = "Prg_2";
		private static const PRG_250:String = "Prg_3";
		private static const PRG_500:String = "Prg_4";
		private static const BTN_DETAIL:String = "BtnDetail";
		private static const BTN_GET_GIFT_1:String = "BtnGetGift_1";
		private static const BTN_GET_GIFT_2:String = "BtnGetGift_2";
		private static const BTN_GET_GIFT_3:String = "BtnGetGift_3";
		private static const BTN_GET_GIFT_4:String = "BtnGetGift_4";
		
		public static const EVENT_NAME:String = "SoldierEvent";
		
		private var cfg:Object;
		private var EventSoldierInfo:Object;
		
		public function GUIEventFishWar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIEventFishWar";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				SetPos(65, 20);
				
				RefreshGUI(cfg);
			}
			
			LoadRes("GuiEventFishWar_Theme");
		}
		
		public function Init():void
		{
			// Get config
			cfg = ConfigJSON.getInstance().GetSoldierEventConfig("Win", -1);
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public function RefreshGUI(cfg:Object):void
		{
			ClearComponent();
			AddBonus(cfg);
			AddProgressBars(cfg);
			AddButtons();
			AddTime();
			AddNPC();
			
			var EventSoldier:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"];
		}
		
		public function AddNPC():void
		{
			var npcImg:Image = AddImage("", "NPC_Mermaid_War", 60, 255, true, ALIGN_LEFT_TOP);
			npcImg.SetScaleXY(0.8);
		}
		
		public function AddButtons():void
		{
			AddButton(BTN_CLOSE, "BtnThoat", 647, 20);
			AddButton(BTN_DETAIL, "GuiEventFishWar_BtnChiTietGiaiThuong", 460, 525);
		}
		
		public function AddProgressBars(o:Object):void
		{
			var myEventInfo:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo;
			EventSoldierInfo = myEventInfo["SoldierEvent"];
			var WinTotal:int = EventSoldierInfo["WinTotal"];
			var prg:ProgressBar;
			var tF:TextField;
			var ratio:Number;
			var x0:int = 243;
			var y0:int = 163;
			var dy:int = 90;
			//var isVisible:Boolean = true;
			
			for (var s:String in o)
			{
				if (getQualifiedClassName(o[s]) == "Object")
				{
					//tF = AddLabel(s, x0 - 45, y0 + dy * (int(s) - 1) - 7, 0xFFF100, 0, 0x603813);
					//tF.scaleX = tF.scaleY = 2;
					//if (isVisible)
					{
						tF = AddLabel("Hoàn thành đủ " + o[s]["WinNum"] + " trận chiến", x0, y0 + dy * (int(s) - 1) - 30, 0x000000, 0);
						var txtF:TextFormat = new TextFormat();
						txtF.size = 12;
						txtF.bold = true;
						txtF.color = 0x333366;
						tF.setTextFormat(txtF);
						
						prg = AddProgress("GuiEventFishWar_Prg_" + s, "PrgEventFishWar" + s, x0, y0 + dy * (int(s) - 1), null, true);
						ratio = WinTotal / o[s]["WinNum"];
						if (ratio > 1) ratio = 1;
						if (ratio == 0)
						{
							prg.setStatus(0);
							//isVisible = false;
						}
						else if (ratio < 1)
						{
							prg.setStatusProgress(ratio, 0.5);
							//isVisible = false;
						}
						else
						{
							if (ratio > 1) ratio = 1;
							
							// Kiểm tra xem đã nhận quà chưa
							if (!EventSoldierInfo["GaveGift"])
							{
								EventSoldierInfo["GaveGift"] = new Object();
							}
							if (!EventSoldierInfo["GaveGift"][s]) //------------------------------------------ check!
							{
								AddButton("BtnGetGift_" + s, "GuiEventFishWar_BtnNhanQuaCaLinh", x0 + 283,  y0 + dy * (int(s) - 1));
								//isVisible = false;
							}
							else
							{
								AddImage("", "GuiEventFishWar_ImgDaNhan", x0 + 310, y0 + dy * (int(s) - 1) + 27).img.rotation = -30;
							}
						}
						var num:int = WinTotal;
						if (WinTotal > o[s]["WinNum"])	num = o[s]["WinNum"];
						tF = AddLabel(num + "/" + o[s]["WinNum"], x0 + prg.img.width / 2 - 68, y0 + dy * (int(s) - 1), 0xFFF100, 1, 0x603813);
						tF.scaleX = tF.scaleY = 1.4;
					}
					//else
					//{
						//prg = AddProgress("Prg_" + s, "PrgEventFishWar" + s, x0, y0 + dy * (int(s) - 1), null, true);
						//prg.setStatus(0);
						
						//tF = AddLabel("Nhận khi hoàn thành nhiệm vụ " + (int(s) - 1), x0 + 43, y0 + dy * (int(s) - 1), 0xFFF100, 1, 0x603813);
						//tF.scaleX = tF.scaleY = 1.4;
					//}
				}
			}
		}
		
		public function AddTime():void
		{
			var str:String = "Sự kiện sẽ diễn ra từ ngày: @begin đến ngày @end";
			var cfg:Object = ConfigJSON.getInstance().getEventInfo(EVENT_NAME);
			var beginDate:Date = new Date(cfg["BeginTime"] * 1000);
			var endDate:Date = new Date(cfg["ExpireTime"] * 1000);
			str = str.replace("@begin", beginDate.date + "/" + (int(beginDate.month) + 1));
			str = str.replace("@end", endDate.date + "/" + (int(endDate.month) + 1));
			var t:TextField = AddLabel(str, 365, 70);
			var txF:TextFormat = new TextFormat();
			txF.size = 18;
			txF.color = 0xFF6600;
			t.setTextFormat(txF);
		}
		
		public function AddBonus(o:Object):void
		{
			var i:int;
			var s:String;
			var ctn:Container;
			var x0:int = 446;
			var y0:int = 48;
			var dy:int = 89;
			var tooltip:TooltipFormat;
			
			for (s in o)
			{
				if (getQualifiedClassName(o[s]) == "Object")
				{
					var gift:Object = o[s]["bonus"]["1"];
					var t:TextField;
					var cfg:Object;
					if (s != "4")
					{
						ctn = AddContainer("", "GuiEventFishWar_ImgBgGiftNormal", x0, y0 + dy * parseInt(s));
						ctn.AddImage("", gift["ItemType"] + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2).FitRect(50, 50, new Point( 5, 5));
						t = ctn.AddLabel(gift["Num"], ctn.img.width / 2 + 5, ctn.img.height - 20, 0xFFF100, 0, 0x603813);
						t.scaleX = 1.4;
						t.scaleY = 1.4;
						tooltip = new TooltipFormat();
						tooltip.text = Localization.getInstance().getString(gift["ItemType"] + gift["ItemId"]);
						if (gift.ItemType == "Samurai")
						{
							cfg = ConfigJSON.getInstance().GetItemList("BuffItem")[gift.ItemType][gift.ItemId];
							tooltip.text = tooltip.text.replace("@Value@", cfg.Num + "");
						}
						else if (gift.ItemTYpe == "RecoverHealthSoldier")
						{
							cfg = ConfigJSON.getInstance().GetItemList("RecoverHealthSoldier")[gift.ItemId];
							tooltip.text = tooltip.text.replace("@Value@", cfg.Num + "");
						}
						ctn.setTooltip(tooltip);
					}
					else
					{
						ctn = AddContainer("", "GuiEventFishWar_ImgBgGiftSpecial", x0, y0 + dy * parseInt(s) + 2);
						ctn.AddImage("", gift["ItemType"] + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2);
						t = ctn.AddLabel(gift["Num"], ctn.img.width / 2 + 5, ctn.img.height - 20, 0xFFF100, 0, 0x603813);
						t.scaleX = 1.4;
						t.scaleY = 1.4;
						tooltip = new TooltipFormat();
						tooltip.text = "Ngôi sao May mắn \n Sưu tầm để đổi phần thưởng đặc biệt";
						ctn.setTooltip(tooltip);
					}
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					this.Hide();
					break;
				case BTN_DETAIL:
					GuiMgr.getInstance().GuiEventFishWar2.Init();
					this.Hide();
					break;
				case BTN_GET_GIFT_1:
				case BTN_GET_GIFT_2:
				case BTN_GET_GIFT_3:
				case BTN_GET_GIFT_4:
					// Ẩn nút lun
					GetButton(buttonID).SetVisible(false);
					// Hiển thị đã nhận
					AddImage("", "GuiEventFishWar_ImgDaNhan", GetButton(buttonID).img.x + 27, GetButton(buttonID).img.y + 25).img.rotation = -30;
					
					var a:Array = buttonID.split("_");
					
					EventSoldierInfo["GaveGift"][a[1]] = true;
					
					// Gửi gói lên
					var cmd:SendGetGiftEventSoldier = new SendGetGiftEventSoldier(int(a[1]));
					Exchange.GetInstance().Send(cmd);
					
					// Cộng quà
					var Gift:Object = cfg[a[1]]["bonus"]["1"];
					
					// Effect nhận quà
					EffectMgr.setEffBounceDown("Nhận quà thành công", Gift["ItemType"] + Gift["ItemId"], 330, 280);
					
					if (Gift["ItemType"] == "LuckyStar")
					{
						if (!EventSoldierInfo["LuckyStar"])
						{
							EventSoldierInfo["LuckyStar"] = 0;
						}
						EventSoldierInfo["LuckyStar"] += 1;
						
						// Feed
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventFishWar@1");
						
						//// Show gui chọn quà cá lính
						//if (EventSoldierInfo["LuckyStar"] > 7)
						//{
							//GuiMgr.getInstance().guiChooseSolider.Show(Constant.GUI_MIN_LAYER, 10);
						//}
						//return;
					}
					else
					{
						// Add kho
						GuiMgr.getInstance().GuiStore.UpdateStore(Gift["ItemType"], Gift["ItemId"], Gift["Num"]);
					}
					
					RefreshGUI(ConfigJSON.getInstance().GetSoldierEventConfig("Win", -1));
					break;
			}
		}
	}

}