package Logic 
{
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GameControl.GameController;
	import GUI.component.Tooltip;
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import GUI.GUIMixFish;
	/**
	 * ...
	 * @author MinhT
	 */
	public class MixLake extends BaseObject
	{
		// Hằng số
		public static const ItemType:String = "MixLake";
		public static const ErrCooldown:String = "Cooldown"
		public static const ErrFull:String = "Full"
		
		// thong tin lấy từ db về
		public var Id:int;
		public var LastResetTime:int;
		public var TypeId:int;
		public var CreateTime:Number;
		
		// Dữ liệu riêng
		public var TooltipText:String = "";
		public var IsMouseDown:Boolean;
		public var Dragging:Boolean;
		
		public function MixLake(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "MixLake";
			LastResetTime = 0;
			IsMouseDown = false;
			Dragging = false;
		}
		
		public function UpdatePos(stt:int):void
		{
			var pos:Point = new Point(830 + 80 * stt, GameController.getInstance().GetLakeTop()-42);
			this.SetPos(pos.x, pos.y);
		}
		
		public override function OnMouseOver(event:MouseEvent):void
		{
			if (Dragging)
			{
				return;
			}
			IsMouseDown = false;
			var scale:Number = 1.1;
			this.SetScaleX(scale);
			this.SetScaleY(scale);
			Check();
		}
		
		public override function OnMouseOut(event:MouseEvent):void
		{
			IsMouseDown = false;
			var scale:Number = 1;
			this.SetScaleX(scale);
			this.SetScaleY(scale);
		}
		
		public function OnMouseClickMixLake():void
		{
			if (this.Dragging)
			{
				Dragging = false;
				return;
			}
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GameLogic.getInstance().BackToIdleGameState();
				GuiMgr.getInstance().GuiStore.Hide();
			}
			
			//if (!GameLogic.getInstance().user.IsViewer() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
			//{	
				//if(Check() != ErrFull)
				//{
					//GameLogic.getInstance().BackToIdleGameState();
					//GameLogic.getInstance().SetState(GameState.GAMESTATE_XXX);
					//GameLogic.getInstance().MouseTransform("MouseMix", 1, 0, 10, -5);
					//GuiMgr.getInstance().GuiMixFish.Show(Constant.OBJECT_LAYER);
					//GuiMgr.getInstance().GuiMixFish.SetAlign(Image.ALIGN_CENTER_CENTER);
					//GuiMgr.getInstance().GuiMixFish.SetPos(this.CurPos.x-70, this.CurPos.y-115)
					//GuiMgr.getInstance().GuiMixFish.Prepare(this);
					//
					//
					//Show thông tin của fish
					//var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
					//for (var i:int = 0; i < fishArr.length; i++ )
					//{
						//var fish:Fish = fishArr[i] as Fish;
						//if (!fish.IsEgg)
						//{
							//fish.GuiFishStatus.Show(Constant.OBJECT_LAYER);
							//fish.GuiFishStatus.ShowStatus(fish, GUIFishStatus.STATUS_SELL);
							//fish.HideEmotion();
						//}
					//}	
				//}
			//}
			GuiMgr.getInstance().GuiAvatar.Show(Constant.GUI_MIN_LAYER, 6);
			//GuiMgr.getInstance().GuiRawFish.Show(Constant.GUI_MIN_LAYER, 6);
			GuiMgr.getInstance().GuiMateFish.Show(Constant.GUI_MIN_LAYER, 6);
			GameLogic.getInstance().BackToIdleGameState();
		}
		
		public function Check():String
		{		
			if (!GameLogic.getInstance().user.IsViewer())
			{				
				//var cooldown:int = INI.getInstance().getItemInfo(TypeId.toString(), ItemType)["Cooldown"];
				//var cooldown:int = ConfigJSON.getInstance().GetItemInfo(ItemType, TypeId)["Cooldown"];
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				var pos:Point = Ultility.PosLakeToScreen(this.CurPos.x, this.CurPos.y);
				//if (curTime - LastResetTime <= cooldown)
				//{
					//var second:int = cooldown - (curTime - LastResetTime);
					//var minute:int = Math.ceil(second / 60);
					//TooltipText = "Còn " + minute + " phút";
					//Tooltip.getInstance().ShowNewToolTip(TooltipText, pos.x, pos.y);
					//Tooltip.getInstance().SetTimeOut(1000);
					//return ErrCooldown;
				//}
				// hiện tại, tính số lượng trứng vào cá nên check thế này, sau này bỏ cái commnent đi là ok
				if (GameLogic.getInstance().user.CurLake.TotalEgg >= GameLogic.getInstance().user.CurLake.CurCapacity)
				//if (GameLogic.getInstance().user.CurLake.NumFish >= GameLogic.getInstance().user.CurLake.CurCapacity)
				{
					TooltipText = Localization.getInstance().getString("MixErr1");
					
					Tooltip.getInstance().ShowNewToolTip(TooltipText, pos.x, pos.y);
					Tooltip.getInstance().SetTimeOut(1000);
					return ErrFull;
				}
			}
			return "";
		}
	}

}