package GUI.Tournament
{
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.Tournament.SendGetGiftTournament;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUITournamentCongratLoser extends BaseGUI
	{
		private static const BTN_CLOSE:String = "BtnClose";
		private static const CTN_DRAGON:String = "1";
		private static const CTN_TIGER:String = "2";
		private static const CTN_PHOENIX:String = "3";
		private static const CTN_SNAKE:String = "4";
		
		private var maxChoose:int = 0;
		private var numChoose:int = 0;
		private var numStar:int = 0;
		private var groupId:int = 0;
		private var lastCardId:Array;
		
		public function GUITournamentCongratLoser(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUITournamentCongratLoser";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				AddButton(BTN_CLOSE, "BtnThoat", 706, 20).SetDisable();
				numChoose = 0;
				setStartByResult();
				var fm:TextFormat = new TextFormat();
				fm.bold = true;
				fm.size = 18;
				var st:String = Localization.getInstance().getString("tourLoser");
				AddLabel(st, 323, 90).setTextFormat(fm);
				
				fm.size = 24;
				st = Localization.getInstance().getString("tourNumChoose");
				st = st.replace("@max", maxChoose);
				AddLabel("Bạn có " + maxChoose + " lần chọn", 259, 174, 0, 0).setTextFormat(fm);
				OpenRoomOut();
			}
			
			LoadRes("GuiTournament_CongratLoser");
		}
		
		private function setStartByResult():void
		{
			if (groupId > 0 && groupId <= 3)
			{
				var tourName:String;
				switch(groupId)
				{
					case 1:
						tourName = "imgNemo";
						break;
					case 2:
						tourName = "imgDolphin";
						break;
					case 3:
						tourName = "imgWhale";
						break;
				}
				AddContainer(CTN_SNAKE, tourName, 62, 243, true, this);
				AddContainer(CTN_TIGER, tourName, 225, 243, true, this);
				AddContainer(CTN_PHOENIX, tourName, 385, 243, true, this);
				AddContainer(CTN_DRAGON, tourName, 543, 243, true, this);
			}
			else
			{
				AddContainer(CTN_SNAKE, "imgSnake", 62, 243, true, this);
				AddContainer(CTN_TIGER, "imgTiger", 225, 243, true, this);
				AddContainer(CTN_PHOENIX, "imgPhoenix", 385, 243, true, this);
				AddContainer(CTN_DRAGON, "imgDragon", 543, 243, true, this);
			}
			
			var i:int;
			var x:int = 17;
			var dx:int = 21;
			for (i = 0; i < numStar; i++)
			{
				GetContainer(CTN_SNAKE).AddImage("", "imgStarSmall", x + dx * i, 29, true, ALIGN_LEFT_TOP);
				GetContainer(CTN_TIGER).AddImage("", "imgStarSmall", x + dx * i, 29, true, ALIGN_LEFT_TOP);
				GetContainer(CTN_PHOENIX).AddImage("", "imgStarSmall", x + dx * i, 29, true, ALIGN_LEFT_TOP);
				GetContainer(CTN_DRAGON).AddImage("", "imgStarSmall", x + dx * i, 29, true, ALIGN_LEFT_TOP);
			}
			
			for (i = 0; lastCardId && i < lastCardId.length; i++)
			{
				if (GetContainer(lastCardId[i]) != null)
				{
					Ultility.SetEnableSprite(GetContainer(lastCardId[i].toString()).img, false);
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE: 
					Hide();
					break;
				
				case CTN_DRAGON: 
				case CTN_SNAKE: 
				case CTN_PHOENIX: 
				case CTN_TIGER: 
					PickGift(buttonID);
					break;
			}
		}
		
		private function PickGift(buttonID:String):void
		{
			if (numChoose >= maxChoose)
			{
				return;
			}
			numChoose++;
			
			var mc:Sprite = GetContainer(buttonID).img;
			var p:Point = GetContainer(buttonID).CurPos;
			var width:int = GetContainer(buttonID).img.width;
			TweenMax.to(mc, 0.2, { bezier:[ { x:p.x + width / 2, y:p.y } ], scaleX:0 } );
			
			var card:int = int(buttonID);			
			var cmd:SendGetGiftTournament = new SendGetGiftTournament(card);
			Exchange.GetInstance().Send(cmd);
			
			//Ultility.SetEnableSprite(GetContainer(CTN_DRAGON).img, false);
			//Ultility.SetEnableSprite(GetContainer(CTN_SNAKE).img, false);
			//Ultility.SetEnableSprite(GetContainer(CTN_TIGER).img, false);
			//Ultility.SetEnableSprite(GetContainer(CTN_PHOENIX).img, false);	
			lastCardId.push(card);
		}
		
		public function afterChoose():void
		{
			if (numChoose >= maxChoose)
			{
				this.Hide();
				return;
			}
			var i:int;
			for (i = 0; lastCardId && i < lastCardId.length; i++)
			{
				if (GetContainer(lastCardId[i]) != null)
				{
					Ultility.SetEnableSprite(GetContainer(lastCardId[i].toString()).img, false);
				}
			}
			//Ultility.SetEnableSprite(GetContainer(CTN_DRAGON).img, true);
			//Ultility.SetEnableSprite(GetContainer(CTN_SNAKE).img, true);
			//Ultility.SetEnableSprite(GetContainer(CTN_TIGER).img, true);
			//Ultility.SetEnableSprite(GetContainer(CTN_PHOENIX).img, true);
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case CTN_DRAGON: 
				case CTN_SNAKE: 
				case CTN_PHOENIX: 
				case CTN_TIGER: 
					if (numChoose < maxChoose)
					{
						GetContainer(buttonID).SetHighLight();
					}
					break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case CTN_DRAGON: 
				case CTN_SNAKE: 
				case CTN_PHOENIX: 
				case CTN_TIGER: 
					if (numChoose < maxChoose)
					{
						GetContainer(buttonID).SetHighLight(-1);
					}
					break;
			}
		}
		
		public function ShowGui(star:int, num:int, lastCard:Array, group:int):void 
		{
			maxChoose = num;
			numStar = star;
			lastCardId = lastCard;
			groupId = group;
			Show(Constant.GUI_MIN_LAYER, 1);
		}
	}

}