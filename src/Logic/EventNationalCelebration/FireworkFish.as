package Logic.EventNationalCelebration 
{
	import adobe.utils.ProductManager;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.component.ProgressBar;
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import NetworkPacket.PacketSend.SendClickGiftFirework;
	import NetworkPacket.PacketSend.SendUpdateSparta;
	import particleSys.sample.MusicEmit;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class FireworkFish extends Fish 
	{
		public static const DEAD:String = "Dead";
		public var bornTime:Number;
		public var receiveGiftTime:Number;
		public var distanceGiftTime:Number = 5;
		public var deadTime:Number = 10;
		public var isExpried:Boolean = false;
		public var progressBar:ProgressBar;
		
		public function FireworkFish(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			bornTime = GameLogic.getInstance().CurServerTime;
			receiveGiftTime = GameLogic.getInstance().CurServerTime;
			ClassName = "FireworkFish";
		}
		
		override public function onClickEmotion():void 
		{
			switch(Emotion)
			{
				case Fish.GIFT:
					if (GameLogic.getInstance().user.IsViewer())
					{
						return;
					}
					receiveGiftTime = GameLogic.getInstance().CurServerTime;
					SetEmotion(IDLE);
					var send:SendClickGiftFirework = new SendClickGiftFirework(Id, LakeId);
					Exchange.GetInstance().Send(send);
					
					//Ẩn gui store
					if (GuiMgr.getInstance().GuiMain.IsVisible)
					{
						GuiMgr.getInstance().GuiMain.img.visible = true;
						GuiMgr.getInstance().GuiMain.imgBgLake.img.visible = true;
					}
					if (GuiMgr.getInstance().GuiFriends.IsVisible)
					{
						GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
					}
					GameLogic.getInstance().BackToIdleGameState();
					GameController.getInstance().UseTool("Default");
					GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
					GuiMgr.getInstance().GuiMain.ShowLakes();
					GuiMgr.getInstance().GuiStore.Hide();
					
					progressBar.visible = true;
					
					//Do roi ra
					/*EffectMgr.getInstance().fallFlyXP(this.CurPos.x, this.CurPos.y, 100, true);
					//GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + 100);
					EffectMgr.getInstance().fallFlyMoney(this.CurPos.x, this.CurPos.y, 1000);
					var object:Object = new Object();
					object["ItemType"] = "Sock";
					object["Num"] = 1;
					object["ItemId"] = 1;
					GameLogic.getInstance().DropActionGift(object, this.CurPos.x, this.CurPos.y, true);
					if (GameLogic.getInstance().user.StockThingsArr["Sock"][0]["Num"] >= Constant.NUM_SOCK_EXCHANGE)
					{
						GuiMgr.getInstance().guiWish.showGUI();
						//GameLogic.getInstance().showEffWish();
					}*/
					break;
			}
		}
		
		override public function UpdateStartTime():void 
		{
			
		}
		
		override public function UpdateHavestTime():void 
		{
			
		}
		
		override public function RefreshImg():void 
		{
			ClearImage();
			{
				switch(Emotion)
				{
					case IDLE:
					case GIFT:
						LoadRes(ImgName);
						SetMovingState(Fish.FS_SWIM);
						SetSpeed(2, 5);
						
						progressBar = new ProgressBar("", "PrgHealth", 0, -25);
						progressBar.visible = false;
						progressBar.setStatus(0);
						img.addChild(progressBar);
						break;
					case DEAD:
						LoadRes("Supper2");
						SetMovingState(Fish.FS_CHASE);
						if (musicEmit != null)
						{
							musicEmit.destroy();
							musicEmit = null;
						}
						break;
				}
				img.scaleX = OrientX*Scale;
				img.scaleY = Scale;
			}
			
			sortContentLayer();			
			
			if(FishType == FISHTYPE_SPECIAL)
			{	
				addSpecialContent();				
			}
			else if (FishType == FISHTYPE_RARE && Emotion != DEAD)
			{
				addRareContent();
				//Vẽ aura bằng glowFilter
				var cl:int = getAuraColor();
				//TweenMax.to(img, 1, { glowFilter: { color:cl, alpha:1, blurX:20, blurY:20, strength:1.5 }} );				
				//Đổi màu aura tỏa tỏa
				var str:String = cl.toString(16).split("").reverse().join("");
				var color:Array = new Array(0, 0, 0);
				for (var i:int = 0; i < str.length; i += 2) 
				{
					color[i/2] = parseInt(str.slice(i, i + 2), 16);				
				}	
				if (effRareFish != null)
				{
					effRareFish.transform.colorTransform = new ColorTransform(0, 0, 0, 1, color[2], color[1], color[0]);
				}		
				
				//Khởi tạo emitter huýt sáo
				if (musicEmit == null && Emotion != DEAD)
				{
					musicEmit = new MusicEmit(img.parent);		
				}
			}		
			
			//Add bóng
			if (shadow == null)
			{
				shadow = ResMgr.getInstance().GetRes("FishShadow") as Sprite;				
				Parent.addChild(shadow);
				shadow.x = img.x;
				shadow.y = GameController.getInstance().GetLakeBottom() - curDeep*SHADOW_SCOPE;
				shadow.scaleY = 0.7;
			}
			
			UpdateColor();		
		}
		
		override public function UpdateFish():void 
		{
			if (IsHide)
			{
				return;
			}
			
			//Update trạng thái di chuyển của cá
			switch(State)
			{
				case FS_IDLE:
					break;
				case FS_SWIM:
					if (Emotion != DEAD)
					{
						Swim();
					}
					break;
				case FS_FALL:
					Fall();
					break;
				case FS_RETURN:
					Return();
					break;
				case FS_HERD:
					Swim();
					break;
			}	
			
			//Update các content khác đi kèm theo cá
			aboveContent.x = underContent.x = img.x;
			aboveContent.y = underContent.y = img.y;
			
			//di chuyển chatbox
			if (chatbox)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			if (musicEmit && Emotion != DEAD)
			{
				musicEmit.pos.x = img.x + OrientX * img.width / 2
				musicEmit.pos.y = img.y;
				musicEmit.updateEmitter();
				musicEmit.vel = new Point(OrientX*(curSpeed+6), 0);
			}
			
			//Update trạng thái cảm xúc của cá
			//UpdateEmotion();	

			
			//update gui status đi kèm theo cá
			if (GuiFishStatus.IsVisible)
			{				
				GuiFishStatus.SetPos(CurPos.x, CurPos.y);
			}			
			
			//updateGushBall();
			updateTime();
			
			if (progressBar.visible)
			{
				if(progressBar.GetStatus() < 1)
				{
					progressBar.setStatus(progressBar.GetStatus() + 0.015);
				}
			}
			
		}
		
		override public function UpdateEmotion():void 
		{
			
		}
		
		public function updateTime():void
		{
			if (Emotion == DEAD)
			{
				if (img.y < GameController.getInstance().GetLakeBottom()-90)
				{
					//img.y += 3;
					SetPosY(GetPos().y+3);
					GuiFishStatus.SetPos(CurPos.x, CurPos.y+120);
					
				}
				return;
			}
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime - bornTime - 30> deadTime)
			{
				SetEmotion(DEAD);
				return;
			}
			if (curTime - receiveGiftTime > distanceGiftTime)
			{
				SetEmotion(GIFT);
			}
			else
			{
				SetEmotion(IDLE);
			}
		}
		
		override public function Init(x:int, y:int):void 
		{
			Dragable = true;			
			Eated = 0
			SetDeep(curDeep);		
			
			SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
			// Dành cho cá có tuổi và trưởng thành khác nhau
			initConstant();
			
			SetPos(x, y);
			if (!IsEgg)
			{
				if (y < SwimingArea.top)
				{
					SetMovingState(FS_FALL);
				}
				else
				{	
					SetMovingState(FS_SWIM);
					FindDes(false);
				}			
			}
			else
			{
				var r:Rectangle = GameController.getInstance().GetDecorateArea();
				SetDeep(1-(CurPos.y + this.img.height - r.top) / (r.height));
			}
			
			SetAgeState(Fish.OLD);
			SetEmotion(Fish.IDLE);
			FishType = Fish.FISHTYPE_RARE;
			FishTypeId = 1;
			initBalloon();
			
			RateOption = new Object();
			RateOption[Fish.OPTION_MONEY] = 20;
			RateOption[Fish.OPTION_EXP] = 20;
			RateOption[Fish.OPTION_TIME] = 20;
			var config:Object = ConfigJSON.getInstance().GetItemList("Param")["TimeGiftSparta"];
			distanceGiftTime = config["Santa"];
			deadTime = 5 * 24 * 3600;
			
			RefreshImg();
		}
		
		override public function getExp(isGift:Boolean = false):int 
		{
			var config:Object = ConfigJSON.getInstance().GetItemList("Param")["FireworkInfo"];
			if (Emotion == DEAD)
			{
				return config["Disable"]["Exp"];
			}
			else
			{
				return config["Active"]["Exp"];
			}
		}
		
		override public function GetValue():Number 
		{
			var config:Object = ConfigJSON.getInstance().GetItemList("Param")["SantaInfo"];
			if (Emotion == DEAD)
			{
				return config["Disable"]["Money"];
			}
			else
			{
				return config["Active"]["Money"];
			}
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (GameLogic.getInstance().user.IsViewer())
			{
				return;
			}
			if (Emotion == DEAD)
			{
				GameLogic.getInstance().SellFireworkFish(this);
				if(GameLogic.getInstance().gameState == GameState.GAMESTATE_SELL_FISH)
				{
					GameLogic.getInstance().cursor.gotoAndPlay(0);
				}
			}
			else if(GameLogic.getInstance().gameState == GameState.GAMESTATE_SELL_FISH)
			{
				GuiMgr.getInstance().GuiMessageBox.showConfirmSellFireworFish(this, Localization.getInstance().getString("GUILabel46"));
			}
		}
		
		override public function SetHighLight(color:Number = 0x00FF00):void 
		{
			if (EmoImg)
			{
				EmoImg.SetHighLight(color);
			}
			
			if (img == null)
			{
				return;
			}
			
			if (color < 0)
			{
				img.filters = null;
				return;
			}
			
			var glow:GlowFilter = new GlowFilter(color, 1, 5, 5, 5);
			img.filters = [glow];
		}
		
		override public function SetEmotion(emotion:String):void 
		{
			if (Emotion == emotion)
			{
				return;
			}
			super.SetEmotion(emotion);
			if (emotion == DEAD)
			{
				if (!isExpried)
				{
					GameLogic.getInstance().user.UpdateOptionLakeObject( -1, this.RateOption, GameLogic.getInstance().user.CurLake.Id);
					Exchange.GetInstance().Send(new SendUpdateSparta(GameLogic.getInstance().user.Id));
					isExpried = true;
				}
				if(!GameLogic.getInstance().user.IsViewer())
				{
					GameLogic.getInstance().SellFireworkFish(this);
				}
			}
		}
	}

}