package GUI 
{
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Ultility;
	import Data.INI;
	import NetworkPacket.PacketSend.SendFishing;
	/**
	 * ...
	 * @author tuan
	 */
	public class GUICharacter extends BaseGUI
	{
		public static const SHIP_TYPE_NOMARL:int = 0;
		public static const SHIP_TYPE_BETA_TEST:int = 1;
		
		public static const ANI_IDLE0:String = "Idle0";
		public static const ANI_IDLE1:String = "Idle1";
		public static const ANI_IDLE2:String = "Idle2";
		public static const ANI_IDLE3:String = "Idle3";
		
		public static const ANI_WALKING:String = "Walking";
		
		public static const ANI_RELEASE_FISH:String = "ReleaseFish";
		
		public static const ANI_FEED:String = "Feed";
		
		public static const ANI_SALE:String = "Sale";
		
		public static const ANI_GIRL_PREPARE_FISH:String = "GirlFishing";
		public static const ANI_GIRL_FISHING_IDLE:String = "GirlWaiting";
		public static const ANI_GIRL_END_FISH:String = "GirlGetFish";
		public static const ANI_GIRL_STAND_UP:String = "GirlStandUp";
		
		public static const ANI_PREPARE_FISH:String = "Fishing";
		public static const ANI_FISH:String = "FishingReady";
		public static const ANI_FISHING_IDLE:String = "FishingIdle";
		public static const ANI_END_FISH:String = "FishingEnd";
		public static const ANI_STAND_UP:String = "StandUp";
		public static const ANI_HAPPY:String = "Happy";
		public static const ANI_SAD:String = "Sad";
		public static const MALE:int = 0;
		public static const FEMALE:int = 1;
		public static var AVATAR_POS_Y_CONST:int = 20;	
		public var AVATAR_POS_Y:int = 20;		

		private var arrMixLake:Array = [];
		
		public var Avatar:MovieClip;
		public var CurAni:String = ANI_IDLE0;
		public var NextAni:String = ANI_IDLE0;
		public var nLoop:int = 1;
		public var IsLoop:Boolean = false;
		public var DesAvaPos:Point = new Point();		
		public var CurAvaPos:Point = new Point();
		public var SpeedVec:Point = new Point();
		public var ReachDes:Boolean = true;
		//Event 2-9
		//private var imageFlag:Image;
		
		public function GUICharacter(parent:Object = null, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUICharacter";
		}
		
		/**
		 * KHởi tạo gui
		 */
		public override function InitGUI() :void
		{
			//Check tham gia beta test
			if (GameLogic.getInstance().user.BoatType == SHIP_TYPE_NOMARL)
			{
				LoadRes("Ship")
				SetPos(580 , GameController.getInstance().GetLakeTop() - 45);
				AVATAR_POS_Y_CONST = 20;
			}
			else
			{
				LoadRes("Ship1");
				SetPos(580 , GameController.getInstance().GetLakeTop() - 100);
				AVATAR_POS_Y_CONST = 73;
			}

		
			
			//init
			IsLoop = false;
			ReachDes = true;
			CurAni = ANI_IDLE0;
			
			//if (GameLogic.getInstance().user.AvatarType == FEMALE)	AVATAR_POS_Y = AVATAR_POS_Y_CONST - 56;
			//else AVATAR_POS_Y = AVATAR_POS_Y_CONST;
			AVATAR_POS_Y = AVATAR_POS_Y_CONST - GameLogic.getInstance().user.AvatarType * 56;
			
			//* dunglb
			// Add ảnh avatar và lưu vào biến Ava
			var Ava:Image = AddImage("", "Character" + GameLogic.getInstance().user.AvatarType, 190, AVATAR_POS_Y_CONST - 
				GameLogic.getInstance().user.AvatarType * 56, true, ALIGN_LEFT_TOP);
			//var Ava:Image = AddImage("", "Character" + 0, 190, AVATAR_POS_Y, true, ALIGN_LEFT_TOP);
			// Lấy biến ảnh của Ava lưu vào movieClip Avatar
			Avatar = Ava.img as MovieClip;
			Avatar.scaleX = Avatar.scaleY = 0.9;
			// khởi tạo vị trí hiện tại của avatar
			CurAvaPos.x = Avatar.x;
			CurAvaPos.y = Avatar.y;			
			
			arrMixLake.splice(0, arrMixLake.length);
			//GoAct(GUICharacter.ANI_FISHING, 200, GUICharacter.AVATAR_POS_Y, 1.5);
			//*/

			/*			
			Character = new Model3D(INI.getInstance().getDataUrl() + "boy.md2");
			Character.AddMaterial(INI.getInstance().getDataUrl() + "boy.jpg");
			Character.AddMaterial(INI.getInstance().getDataUrl() + "boy2.jpg");
			Character.AddMaterial(INI.getInstance().getDataUrl() + "boy3.jpg");
			Character.SetScale(0.5);
			Character.SetState(1);
			Character.SetPos(new Point(250, 162));
			img.addChild(Character);
			*/
			
			//Cắm cờ trên bè cho event 2-9
			/*if (GameLogic.getInstance().isEventND())
			{
				imageFlag = AddImage("", "Flag", 250, -40);
			}*/
		}
		
		/**
		 * Hàm thực hiện play action tương ứng
		 * @param	act	: Hành động của avatar
		 * @param	nloop: số lần lặp
		 */
		public function PlayAni(act:String, nloop:int = 1):void
		{
			//* dunglb
			Avatar.gotoAndPlay(act);
			CurAni = act;
			nLoop = nloop;
			IsLoop = false;
			//*/
			
			//Khi đang câu cá mà chuyển animation cho ăn thì nó không enable nút câu cá lên
			//Enable chỗ này vậy
			if (CurAni == ANI_FEED)
			{
				if (GuiMgr.getInstance().GuiMain.btnHook.img.mouseEnabled == false)
				{				
					GuiMgr.getInstance().GuiMain.btnHook.SetEnable(true);
				}
			}
		}
		
		/**
		 * thiết lập avatar có lặp hành động không
		 * @param	loop
		 */
		public function SetLoopAvatar(loop:Boolean):void
		{
			IsLoop = loop;
		}
		
		/** 
		 * Chuyển sang play action act
		 * */
		public function GoAct(act:String, x:int, y:int, speed:Number):void
		{
			//* dunglb
			NextAni = act;
			ReachDes = false;
			DesAvaPos.x = x;
			DesAvaPos.y = y;
			
			if (x < CurAvaPos.x)
			{
				Avatar.scaleX = -0.9;				
			}
			else
			{
				Avatar.scaleX = 0.9;				
			}
			if (GameLogic.getInstance().user.AvatarType == FEMALE)
			{
				Avatar.scaleX *= ( -1);
			}
				
			SpeedVec = DesAvaPos.subtract(new Point(CurAvaPos.x, CurAvaPos.y));
			SpeedVec.normalize(speed);
			PlayAni(ANI_WALKING);
			SetLoopAvatar(true);
			//*/
		}
		
		/** 
		 * cập nhật các attribute của avatar
		 * */
		public function UpdateAvatar():void
		{
			//* dunglb
			if (ReachDes || CurAni != ANI_WALKING)
			{
				return;
			}
				
			var temp:Point = CurAvaPos.subtract(DesAvaPos);
			if ( temp.length <= SpeedVec.length)
			{
				ReachDes = true;
				AvaReachDes();
				return;
			}

			CurAvaPos = CurAvaPos.add(SpeedVec);
			Avatar.x = CurAvaPos.x;
			Avatar.y = CurAvaPos.y;
			//*/
		}
		
		/** 
		 * Lấy vị trí của avatar
		 * */
		public function GetPosAvatar():Point
		{
			var Pos:Point = new Point;
			if (IsVisible)
			{
				Pos = new Point(CurPos.x + Avatar.x, CurPos.y + Avatar.y);
			}
			return Pos;
		}
		
		/**
		 * Lấy chiều đi của avatar
		 * @return	
		 */
		public function GetDirAvatar():int
		{
			if (Avatar.scaleX >= 0)
			{
				if (GameLogic.getInstance().user.AvatarType == 1) 
					return -1;
				else
					return 1;
			}
			else
			{
				if (GameLogic.getInstance().user.AvatarType == 1) 
					return 1;
				else
					return -1;
			}
		}
		
		/**
		 * cập nhật lại và set lại xem play avatar như thế nào
		 */
		public function UpdateInfo():void
		{
			//* dunglb
			//var Pos:Point = Ultility.PosScreenToLake(275, 150);
			//SetPos(470 , GameController.getInstance().GetLakeTop() - 10);
			UpdateAvatar();
			
			if (Avatar.currentLabel == "End")
			{
				if (IsLoop)
				{
					Avatar.gotoAndPlay(CurAni);
				}
				else
				{
					if (nLoop > 1)
					{
						nLoop--;
						Avatar.gotoAndPlay(CurAni);
					}
					else
					{
						FinishAction();
					}
				}				
			}
			//*/
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{		
				
			}
		}
		
		/**
		 * thực hiện avatar chuyển sang hành động tiếp
		 */
		private function RandomAction():void
		{
			var r:int = Math.round(Math.random() * 10);
			var rate:int = 2;
			if (GameLogic.getInstance().user.AvatarType == FEMALE)
			{
				rate = 11;
			}
			if (r < rate)
			{
				GoAct(RandomIdle(), 40 + Math.random() * 170, AVATAR_POS_Y, 1.5);
			}
			else
			{
				PlayAni(RandomIdle());
			}
		}
		
		/**
		 * Lấy ngẫu nhiên hành động của 
		 * @return	action của avatar
		 */
		private function RandomIdle():String
		{
			var r:int = Math.round(Math.random() * 100);
			if (GameLogic.getInstance().user.AvatarType == FEMALE)
			{
				if(r > 90)
				{
					return ANI_IDLE2;
				}
				else if(r > 60)
				{
					return ANI_IDLE1;
				}	
			}
			else 
			{
				if (r > 95)
				{
					return ANI_IDLE3;
				}
				else if(r > 90)
				{
					return ANI_IDLE2;
				}
				else if(r > 85)
				{
					return ANI_IDLE1;
				}	
			}
			return ANI_IDLE0;
		}
		
		/**
		 * cho avatar thực hiện hành động tiếp theo
		 */
		private function AvaReachDes():void
		{
			PlayAni(NextAni);			
		}
		
		/**
		 * Hàm thực hiện cập nhật action của avatar
		 */
		public function FinishAction():void
		{			
			Avatar.stop();
			if(GameLogic.getInstance().user.AvatarType == 0)
				switch(CurAni)
				{
					case ANI_PREPARE_FISH:
						GuiMgr.getInstance().GuiWaitFishing.setPos(img);
						GuiMgr.getInstance().GuiWaitFishing.Show(Constant.GUI_MIN_LAYER, 3);
						var cmd:SendFishing = new SendFishing(GameLogic.getInstance().user.Id, GameLogic.getInstance().user.CurLake.Id);
						Exchange.GetInstance().Send(cmd);
						
						PlayAni(ANI_FISH);					
						break;
					case ANI_FISH:
						PlayAni(ANI_FISHING_IDLE, 5);
						break;
					case ANI_FISHING_IDLE:
						PlayAni(ANI_END_FISH);
						break;
					case ANI_END_FISH:
						GameLogic.getInstance().finishFishing = true;
						PlayAni(ANI_STAND_UP);
						//Effect nước bắn
						SpeedVec.y = 0.2 * SpeedVec.y;
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNuocBan", null, img.x - 70, img.y + 71);
						break;

					default:
						RandomAction();
						break;
				}
			else 
			{
				if(GameLogic.getInstance().user.AvatarType == 1)
					switch(CurAni)
					{
						case ANI_GIRL_PREPARE_FISH:
							GuiMgr.getInstance().GuiWaitFishing.setPos(img);
							GuiMgr.getInstance().GuiWaitFishing.Show(Constant.GUI_MIN_LAYER, 3);
							var cmd1:SendFishing = new SendFishing(GameLogic.getInstance().user.Id, GameLogic.getInstance().user.CurLake.Id);
							Exchange.GetInstance().Send(cmd1);
							PlayAni(ANI_GIRL_FISHING_IDLE);					
							break;
						case ANI_GIRL_FISHING_IDLE:
							PlayAni(ANI_GIRL_END_FISH);
							break;
						case ANI_GIRL_END_FISH:
							GameLogic.getInstance().finishFishing = true;
							
							//Effect nước bắn
							SpeedVec.y = 0.2 * SpeedVec.y;
							EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNuocBan", null, img.x - 90, img.y + 55);	
							PlayAni(ANI_GIRL_STAND_UP);
							break;

						default:
							RandomAction();
							break;
					}
			}
		}
	}

}