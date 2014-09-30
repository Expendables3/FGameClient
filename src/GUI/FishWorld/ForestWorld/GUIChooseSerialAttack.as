package GUI.FishWorld.ForestWorld 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.Network.ChooseSerialAttackInYellowForest;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIChooseSerialAttack extends BaseGUI 
	{
		public const IMG_SERIAL:String = "ImgSerial_";
		public const BTN_CHOOSE_SERIAL:String = "BtnChooseSerial";
		public const CTN_CHOOSE_SERIAL:String = "CtnChooseSerial";
		public var arrSerialAttack:Array = [1, 2, 3, 4, 5];
		public var arrSerialAttackRandom:Array = [1, 2, 3, 4, 5];
		public var isStartChoose:Boolean = false;
		public var isUpdate:Boolean = false;
		public var count:int = 0;
		private var startChooseSerial:Boolean = false;
		public var isCanChooseSerial:Boolean = true;
		private var lastTimeUpdate:Number;
		public var ctnMain:Container;
		public var btnGet:Button;
		private var imgEffGet:Image;
		public function GUIChooseSerialAttack(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChooseSerialAttack";
		}
		
		override public function InitGUI():void
		{
			super.InitGUI();
			//LoadRes("LoadingForestWorld_BgGuiSerialAttack");
			LoadRes("LoadingForestWorld_ImgFrameFriend");
			SetPos(412, 465);
			btnGet = AddButton(BTN_CHOOSE_SERIAL, "LoadingForestWorld_BtnGetSequence", -150, -30, this);
			imgEffGet = AddImage("", "LoadingForestWorld_EffGetSequence", -120, -10);
			(imgEffGet.img as MovieClip).stop();
			imgEffGet.img.visible = false;
			
			ctnMain = AddContainer(CTN_CHOOSE_SERIAL, "LoadingForestWorld_BgGuiSerialAttack", 0, 0, true, this);
			ctnMain.img.buttonMode = true;
			//GenArrSerialAttack();
			for (var i:int = 1; i <= 5; i++) 
			{
				ctnMain.AddImage(IMG_SERIAL + i, "Element" + i, -140 + 43 * i, -12, true, ALIGN_LEFT_TOP).SetScaleXY(0.8);
				ctnMain.GetImage(IMG_SERIAL + i).img.visible = false;
			}
			startChooseSerial = false;
			isCanChooseSerial = true;
			
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
			if (arrMonster.length == 1)
			{
				(arrMonster[0] as FishSoldier).SetEmotion(FishSoldier.WAR);
			}
			else
			{
				for (var j:int = 0; j < arrMonster.length - 1; j++) 
				{
					(arrMonster[j] as FishSoldier).SetEmotion(FishSoldier.WAR);
				}
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!GuiMgr.getInstance().GuiMainFishWorld.CheckCanCatchEventMouse())	return;
			if (GameLogic.getInstance().countNumEffHoiSinh > 0)	return;
			if (GameLogic.getInstance().efRound3ForestSea != null)	return;
			if (!isCanChooseSerial)	return;
			isCanChooseSerial = false;
			switch (buttonID) 
			{
				case BTN_CHOOSE_SERIAL:
				case CTN_CHOOSE_SERIAL:
					this.ShowDisableScreen(0.01);
					for (var i:int = 1; i <= 5; i++) 
					{
						ctnMain.GetImage(IMG_SERIAL + i).img.visible = true;
					}
					//StartChooseSerial();
					imgEffGet.img.visible = true;
					(imgEffGet.img as MovieClip).play();
					btnGet.SetVisible(false);
				break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CHOOSE_SERIAL:
				case CTN_CHOOSE_SERIAL:
					GetButton(BTN_CHOOSE_SERIAL).SetHighLight( -1);
					ctnMain.SetHighLight(-1);
				break;
			}
		}
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void  
		{
			switch (buttonID) 
			{
				case BTN_CHOOSE_SERIAL:
				case CTN_CHOOSE_SERIAL:
					ctnMain.SetHighLight();
					GetButton(BTN_CHOOSE_SERIAL).SetHighLight();
				break;
			}
		}
		private function StartChooseSerial():void 
		{
			var cmd:ChooseSerialAttackInYellowForest = new ChooseSerialAttackInYellowForest(FishWorldController.GetSeaId());
			Exchange.GetInstance().Send(cmd);
		}
		public var arrSerialAttacked:Array = [];
		public function StartProcessChooseSerial(Data:Object):void 
		{
			var arrTemp1:Array = [];
			arrSerialAttacked = [1, 2, 3, 4, 5];
			arrSerialAttack = [1, 2, 3, 4, 5];
			arrSerialAttackRandom = [1, 2, 3, 4, 5];
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < arrSerialAttack.length; i++) 
			{
				arrTemp1.push(int(Data.Sequence[String(i + 1)]));
				arrSerialAttack[i] = int(Data.Sequence[String(i + 1)]);
			}
			
			for (i = 0; i < arrTemp1.length; i++) 
			{
				var id1:int = arrTemp1[i];
				if (arrSerialAttacked.indexOf(id1) >= 0)
				{
					arrSerialAttacked.splice(arrSerialAttacked.indexOf(id1), 1);
				}
			}
			
			for (i = 0; i < arrSerialAttack.length; ) 
			{
				if (arrSerialAttack[0] == 0)
				{
					arrSerialAttack.splice(0, 1);
				}
				else
				{
					break;
				}
			}
			
			//GetButton(BTN_CHOOSE_SERIAL).SetVisible(false);
			lastTimeUpdate = GameLogic.getInstance().CurServerTime;
			startChooseSerial = true;
		}
		
		public function ShowNewSequence():void
		{
			var i:int;
			for (i = 0; i < 5; i++) 
			{
				//trace("ctnMain = ",ctnMain);
				ctnMain.GetImage(IMG_SERIAL + (i + 1)).img.visible = true;
				if (i < arrSerialAttacked.length)
				{
					ctnMain.GetImage(IMG_SERIAL + (i + 1)).LoadRes("Element" + arrSerialAttacked[i]);
					ctnMain.GetImage(IMG_SERIAL + (i + 1)).SetScaleXY(0.8);
					Ultility.SetEnableSprite(ctnMain.GetImage(IMG_SERIAL + (i + 1)).img, false);
				}
				else
				{
					ctnMain.GetImage(IMG_SERIAL + (i + 1)).LoadRes("Element" + arrSerialAttack[i - arrSerialAttacked.length]);
					ctnMain.GetImage(IMG_SERIAL + (i + 1)).SetScaleXY(0.8);
				}
			}
			
			var objHideGreenDown:Object = GuiMgr.getInstance().GuiMainForest.objHideGreenDown;
			for (var l:String in objHideGreenDown) 
			{
				try 
				{
					ctnMain.GetImage(IMG_SERIAL + objHideGreenDown[l]).img.visible = false;
				}
				catch (err:Error) {
					
				}
			}
		}
		
		public function Update():void
		{
			if (imgEffGet && imgEffGet.img && imgEffGet.img.visible)
			{
				if ((imgEffGet.img as MovieClip).currentFrame == (imgEffGet.img as MovieClip).totalFrames)
				{
					(imgEffGet.img as MovieClip).gotoAndStop(1);
					imgEffGet.img.visible = false;
					btnGet.SetVisible(true);
					btnGet.SetDisable();
					StartChooseSerial();
				}
			}
			if(startChooseSerial)
			{
				//isUpdate = !isUpdate;
				var i:int = 1;
				var k:int = 0;
				var idShow:int;
				var idRandom:int;
				var checkCount:int = 0;
				if(GameLogic.getInstance().CurServerTime - lastTimeUpdate > 0.1)
				{
					lastTimeUpdate = GameLogic.getInstance().CurServerTime;
					count++;
					if(count < 20)
					{
						for (i = 1; i <= 5; i++) 
						{
							if (i < 5 - arrSerialAttack.length)	
								idShow = 0;
							else
								idShow = arrSerialAttack[i - (5 - arrSerialAttack.length) - 1];
							idRandom = Math.floor(5 * Math.random()) + 1;
							arrSerialAttackRandom[(i - 1)] = idRandom;
							ctnMain.GetImage(IMG_SERIAL + i).LoadRes("Element" + idRandom);
							ctnMain.GetImage(IMG_SERIAL + i).SetScaleXY(0.8);
						}
					}
					else
					{
						for (i = 1, k = 0; i <= 5; i++) 
						{
							if (i < 5 - arrSerialAttack.length)	
								idShow = 0;
							else
								idShow = arrSerialAttack[i - (5 - arrSerialAttack.length) - 1];
							
							if(i > (5 - arrSerialAttack.length) && arrSerialAttackRandom[(i-1)] != arrSerialAttack[(i - (5 - arrSerialAttack.length) -1)])
							{
								if (CheckInArrHide(i))
								{
									ctnMain.GetImage(IMG_SERIAL + i).img.visible = false;
								}
								else
								{
									idRandom = Math.floor(5 * Math.random()) + 1;
									arrSerialAttackRandom[(i - 1)] = idRandom;
									ctnMain.GetImage(IMG_SERIAL + i).LoadRes("Element" + idRandom);
									ctnMain.GetImage(IMG_SERIAL + i).SetScaleXY(0.8);
									checkCount++;
								}
								//trace("Slot ", i, " co idRandom ", idRandom);
							}
							else if(i <= (5 - arrSerialAttack.length))
							{
								//trace("Slot ", i);
								ctnMain.GetImage(IMG_SERIAL + i).LoadRes("Element" + arrSerialAttacked[k]);
								ctnMain.GetImage(IMG_SERIAL + i).SetScaleXY(0.8);
								k++;
								Ultility.SetEnableSprite(ctnMain.GetImage(IMG_SERIAL + i).img, false);
							}
						}
						if (checkCount <= 0)
						{
							var objHideGreenDown:Object = GuiMgr.getInstance().GuiMainForest.objHideGreenDown;
							for (var l:String in objHideGreenDown) 
							{
								try 
								{
									ctnMain.GetImage(IMG_SERIAL + objHideGreenDown[l]).img.visible = false;
								}
								catch (err:Error) {
									
								}
							}
							startChooseSerial = false;
							count = 0;
							//arrSerialAttack.splice(0, arrSerialAttacked.length);
							var arr:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
							if(!GameLogic.getInstance().isAttacking)
							{
								if(arr.length > 1)
								{
									for (var j:int = 0; j < arr.length - 1; j++) 
									{
										(arr[j] as FishSoldier).SetEmotion(FishSoldier.WAR);
									}
								}
								else if(arr.length == 1)
								{
									(arr[0] as FishSoldier).SetEmotion(FishSoldier.WAR);
								}
							}
							HideDisableScreen(true);
						}
					}
				}
			}
		}
		
		/**
		 * Kiểm tra xem thứ tự được truyền vào có nằm trong mảng các ô bị ẩn đi không
		 * @param	id
		 * @return
		 */
		public function CheckInArrHide(id:int):Boolean
		{
			var objHideGreenDown:Object = GuiMgr.getInstance().GuiMainForest.objHideGreenDown;
			for (var l:String in objHideGreenDown) 
			{
				if (id == int(objHideGreenDown[l]))
					return true;
			}
			return false;
		}
		
		public function GenArrSerialAttack():void 
		{
			for (var i:int = 0; i < 20; i++) 
			{
				var index1:int = Math.floor(arrSerialAttack.length * Math.random());
				var index2:int = Math.floor(arrSerialAttack.length * Math.random());
				while (index2 == index1) 
				{
					index2 = Math.floor(arrSerialAttack.length * Math.random());
				}
				Swap(index1, index2, arrSerialAttack);
			}
		}
		public function Swap(index1:int, index2:int, arr:Array):void 
		{
			var arrNew:Array = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				arrNew.push(arr[i]);
			}
			arr.splice(0, arr.length);
			for (var j:int = 0; j < arrNew.length; j++) 
			{
				if (j == index1)
				{
					arr.push(arrNew[index2]);
				}
				else if(j == index2) 
				{
					arr.push(arrNew[index1]);
				}
				else 
				{
					arr.push(arrNew[j]);
				}
			}
		}
	}

}