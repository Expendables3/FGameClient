package GUI 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import GUI.component.Container;
	import GUI.component.Image;
	
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
	import flash.events.*;
	import GUI.component.BaseGUI;
	import Logic.*;
	import Data.*;
	import flash.utils.*;
	import NetworkPacket.PacketSend.SendSlotMachine;
	
	/**
	 * Slot Machine Mini Game GUI
	 * @author Tien Ga
	 */
	
	public class GUISlotMachine extends BaseGUI
	{
		private const GUI_SLOT_BTN_SPIN:String = "ButtonSpin";
		private const GUI_SLOT_BTN_CLOSE:String = "ButtonClose";
		
		private var Slot:Array;
		private var SlotShadow:Array;
		private const MAX_SLOT:uint = 3;
		private const MAX_SLOT_ITEM:uint = 4;
		private var SlotContainer:Array;
		private var ShadowContainer:Array;
		private var FullContainer:Container;
		private var StartTime:Array;
		private const RUN_TIME:uint = 1000;
		private var Move:Array;
		private var GetValue:int;
		
		private const SPEED_SHOW_SHADOW:int = 5;
		private const MIN_SPEED:int = 4;
		private var SlotState:String;
		private const SlotStateStart:String = "START";
		private const SlotStateNoResult:String = "START_NO_RESULT";
		private const SlotStateStop:String = "STOP";
		
		private var SlotResult:Array;
		private const NO_RESULT:uint = 0;
		private const RESULT_1:uint = 1;
		private const RESULT_2:uint = 2;
		private const RESULT_3:uint = 3;
		
		private var CurrentStopSlot:uint;
		private var StopTimer:uint;
		
		
		public function GUISlotMachine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISlotMachine";
		}
		
		public override function InitGUI() :void
		{
			SlotState = SlotStateStop;
			
			LoadRes("Mayquay");
			SetPos(200, 100);
			// add 1 dong button o day
			AddButton(GUI_SLOT_BTN_SPIN, "ButtonSpin", 165, 322, this);
			AddButton(GUI_SLOT_BTN_CLOSE, "BtnThoat", 390, 30, this);
					
			Slot = new Array();
			SlotShadow = new Array();
			SlotContainer = new Array();
			ShadowContainer = new Array();
			SlotResult = new Array();
			SlotResult.push(RESULT_1);
			SlotResult.push(RESULT_1);
			SlotResult.push(RESULT_1);
			Move = new Array();
			Move.push(true);
			Move.push(true);
			Move.push(true);
			StartTime = new Array();
			StartTime.push(0);
			StartTime.push(0);
			StartTime.push(0);
			
			
			FullContainer = AddContainer("", "ButtonFeed", 55, 40);
			
			var StartX:int = 50;
			
			var MaskClip:MovieClip;
			MaskClip = new MovieClip();
			MaskClip.graphics.beginFill(0xFF0000,1);
			MaskClip.graphics.drawRect(0, 70 , 350, 170);
			MaskClip.graphics.endFill();
			FullContainer.img.addChild(MaskClip);
			FullContainer.img.mask = MaskClip;
						
			var j:uint;
			var i:uint;
			var container:Container;
			var InputSlot:Array = new Array();
			var InputImage:Image;
			// Init Shadow Slot:
			for (j = 0; j < MAX_SLOT; j++)
			{
				container = FullContainer.AddContainer("Original"+j, "ButtonFeed", 125*j, 10);
				
				var filter:BitmapFilter = new BlurFilter(0, 50, BitmapFilterQuality.HIGH);
				var myFilters:Array = new Array();
				myFilters.push(filter);
				
				container.img.filters = myFilters;
				
				InputSlot = [];
				InputSlot.length = 0;
				
				for (i= 1; i < MAX_SLOT_ITEM+1; i++)
				{
					switch (i)
					{
						case 1:
							InputImage = container.AddImage(i.toString(), "so10", StartX, 50 * i) as Image;
							break;
						case 2:
							InputImage = container.AddImage(i.toString(), "so20", StartX, 50 * i) as Image;
							break;
						case 3:
							InputImage = container.AddImage(i.toString(), "so50", StartX, 50 * i) as Image;
							break;
						case 4:
							InputImage = container.AddImage(i.toString(), "so100", StartX, 50 * i) as Image;
							break;						
					}
					
					InputSlot.push(InputImage);
				}
				SlotShadow.push(InputSlot);
				
				ShadowContainer.push(container);
			}
							
			// Init Normal Slot:
			
			for (j = 0; j < MAX_SLOT; j++)
			{
				container = FullContainer.AddContainer("Shadow"+j, "ButtonFeed", 125*j, 10);
			
				InputSlot = [];
				InputSlot.length = 0;
				for (i= 1; i < MAX_SLOT_ITEM+1; i++)
				{
					switch (i)
					{
						case 1:
							InputImage = container.AddImage(i.toString(), "so10", StartX, 50 * i) as Image;
							break;
						case 2:
							InputImage = container.AddImage(i.toString(), "so20", StartX, 50 * i) as Image;
							break;
						case 3:
							InputImage = container.AddImage(i.toString(), "so50", StartX, 50 * i) as Image;
							break;
						case 4:
							InputImage = container.AddImage(i.toString(), "so100", StartX, 50 * i) as Image;
							break;						
					}
					InputSlot.push(InputImage);
				}
				Slot.push(InputSlot);
				
				SlotContainer.push(container);
			}
			
			
			
			SetDragable(new Rectangle(100, 0, 300, 30));
			
			
			
			ShowShadow(false, 0);
			ShowShadow(false, 1);
			ShowShadow(false, 2);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_SLOT_BTN_SPIN:
					Spin();
				break;
				case GUI_SLOT_BTN_CLOSE:
					GuiMgr.getInstance().GuiSlotMachine.Hide();
					Hide();
				break;
			}
		}
		
		public function Spin():void
		{
			ResetSpin();
			
			// Start Spin
			SlotState = SlotStateNoResult;
			
			var SendSlotCmd:SendSlotMachine = new SendSlotMachine();
			Exchange.GetInstance().Send(SendSlotCmd);
			// Get Result from server
			//SlotResult[0] = Ultility.RandomNumber(1, 3);
			//SlotResult[1] = Ultility.RandomNumber(1, 3);
			//SlotResult[2] = Ultility.RandomNumber(1, 3);
			
			Move[0] = true;
			Move[1] = true;
			Move[2] = true;
			
			CurrentStopSlot = 0;
			
			ShowShadow(true, 0);
			ShowShadow(true, 1);
			ShowShadow(true, 2);
			
			// StartTime
			StartTime[0] = getTimer();
		}
		
		public function SetResult(SlotValue:Array):void
		{
			SlotState = SlotStateStart;
			GetValue = 0;
			for (var i:int = 0; i < MAX_SLOT; i++)
			{
				GetValue += SlotValue[i];
				switch (SlotValue[i])
				{
					case 10:
					{
						SlotResult[i] = 1;
					}
					break;
					case 20:
					{
						SlotResult[i] = 2;
					}
					break;
					case 50:
					{
						SlotResult[i] = 3;
					}
					break;
					case 100:
					{
						SlotResult[i] = 4;
					}
					break;
				}
			}
		}
		
		private function ResetSpin():void
		{
			var i:uint;
			var j:uint;
			
			for (i = 0; i < Slot.length; i++)
			{
				for (j = 0; j < Slot[i].length; j++)
				{						
					Slot[i][j].SetPosY(50 * j);
				}
			}
			
			for (i = 0; i < SlotShadow.length; i++)
			{
				for (j = 0; j < SlotShadow[i].length; j++)
				{						
					SlotShadow[i][j].SetPosY(50 * j);
				}
			}
		}
		
		public function ProcessSpin():void 
		{
			// Process Animation:
			var Speed:uint = 10;
			if ((SlotState != SlotStateStop) && (SlotState != null))
			{
				var StopSlotNum:int = 0;
				for (var i:int = 0; i < MAX_SLOT; i++)
				{
					Speed = 10;
					// If there is no result yet, keep running:
					if (SlotState == SlotStateNoResult)
					{
						MoveSingleSlot(Speed, i);
					}
					else
					{
						// slot 1 stops first, then others
						if (CurrentStopSlot == i)
						{
							var ElapseTime:uint = (getTimer() - StartTime[i]);
							Speed = ElapseTime < RUN_TIME?Speed *(100-ElapseTime / RUN_TIME)/100:MIN_SPEED; 
							MoveSingleSlot(Speed, i);
						}
						else
						{
							MoveSingleSlot(Speed, i);
						}
					}
					if (!Move[i]) 
						StopSlotNum++;
				}
				
				if (StopSlotNum == MAX_SLOT)
					SlotState = SlotStateStop;	
				
				if (SlotState == SlotStateStop)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Nhận được " + GetValue +" vàng");
					GameLogic.getInstance().user.UpdateUserMoney(GetValue);
				}
			}	
		}
		
		private function MoveSingleSlot(Speed:int, SlotNumber:uint):void
		{
			if (!Move[SlotNumber])
				return;
				
			var j:uint;	
			for (j = 0; j < Slot[SlotNumber].length; j++)
			{					
				Slot[SlotNumber][j].IncrePosY(Speed);
				// Wrap back
				if (Slot[SlotNumber][j].CurPos.y >=(50 +50*MAX_SLOT_ITEM))
				{
					Slot[SlotNumber][j].SetPosY(50 - (50 +50*MAX_SLOT_ITEM) + Slot[SlotNumber][j].CurPos.y);
				}
				
				// If at min speed, and got result, stop
				if ((Speed <= MIN_SPEED) && (SlotState == SlotStateStart))
				{
					if (CurrentStopSlot == SlotNumber)
					{
						// if the right slot
						if (j + 1 == SlotResult[SlotNumber])
						{
							// if in the right threshold
							if (Slot[SlotNumber][j].CurPos.y > 150 && Slot[SlotNumber][j].CurPos.y < 170)
							{
								// Stop the movement
								var Space:int = 150 - Slot[SlotNumber][j].CurPos.y;
								for (var k:int = 0; k < Slot[SlotNumber].length; k++)
								{
									Slot[SlotNumber][k].IncrePosY(Space);
								}
								
								Move[SlotNumber] = false;
								if (CurrentStopSlot != MAX_SLOT)
								{
									CurrentStopSlot++;
									StartTime[CurrentStopSlot] = getTimer();
								}
								break;
							}
						}
					}
				}
				
			}
			
			// Show shadow only at high speed
			if (Speed >= SPEED_SHOW_SHADOW)
			{
				for (j = 0; j < MAX_SLOT; j++)
				{
					SlotShadow[SlotNumber][j].img.y += (Speed +Speed*1.9);
					if (SlotShadow[SlotNumber][j].img.y >=(50 +50*MAX_SLOT_ITEM))
					{
						SlotShadow[SlotNumber][j].img.y = 50 + (50 +50*MAX_SLOT_ITEM) - SlotShadow[SlotNumber][j].img.y;
					}
				}
			}
			else
			{
				ShowShadow(false, SlotNumber);
			}
		}
		
		private function ShowShadow(Visible:Boolean, SlotNumber:uint):void
		{
			var i:uint;
			ShadowContainer[SlotNumber].img.visible = Visible;
			
		}	

	}

}