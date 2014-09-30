package GUI.ChampionLeague.GuiLeague.itemGui 
{
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	
	/**
	 * cái progress máu của 2 đối thủ trong liên đấu
	 * @author HiepNM2
	 */
	public class ProgressBlood extends BaseGUI 
	{
		
		// const
		private const NUM_OF_PRG:int = 3;
		private const TIME_FOR_DELTA_PERCENT:Number = 0.08;		//thời gian để cập nhật delta%
		private const DELTA_PERCENT:Number = 4;					//delta%
		private const ID_PRGBLOOD:String = "idPrgBlood";
		private const BLOODSIZE:int = 5000;
		// gui
		private var imgBack:Image;	//ảnh đằng sau
		private var imgFace:Image;	//ảnh phía trước (ở giữa là 2 mảng progressbar)
		private var listPrgMe:Array = [];
		private var listPrgHim:Array = [];
		
		private var prgMe3:ProgressBar;//xanh lá cây
		private var prgMe2:ProgressBar;//vàng
		private var prgMe1:ProgressBar;//đỏ
		private var prgHim3:ProgressBar;
		private var prgHim2:ProgressBar;
		private var prgHim1:ProgressBar;
		
		public var prgMe:ProgressBar;
		public var prgHim:ProgressBar;
		
		// logic
		private var totalVitalityMe:int;
		private var totalVitalityHim:int;
		private var scene:Object;			//cảnh đánh nhau, sau mỗi cảnh là 1 lần cập nhật progressbar
		
		private var _maxMe3:int;			//chỉ số lớn nhất với từng mức, giá trị không đổi từ lúc tạo ra
		private var _maxMe2:int;
		private var _maxMe1:int;
		private var _maxHim3:int;
		private var _maxHim2:int;
		private var _maxHim1:int;
		
		private var virtualBloodMe3:Number;			//máu ảo, để cập nhật chạy thanh progress
		private var virtualBloodMe2:Number;
		private var virtualBloodMe1:Number;
		private var virtualBloodHim3:Number;
		private var virtualBloodHim2:Number;
		private var virtualBloodHim1:Number;
		
		private var _dBloodMe3:Number;			// 1 delta% thì ứng với dBlood máu
		private var _dBloodMe2:Number;
		private var _dBloodMe1:Number;
		private var _dBloodHim3:Number;
		private var _dBloodHim2:Number;
		private var _dBloodHim1:Number;
		
		private var bloodMe1:Number;			//máu thật
		private var bloodMe2:Number;			
		private var bloodMe3:Number;			
		private var bloodHim1:Number;			
		private var bloodHim2:Number;			
		private var bloodHim3:Number;			
		
		private var inUpdateMe:Boolean = false;
		private var inUpdateHim:Boolean = false;
		private var _timeGui:Number;
		
		
		public function ProgressBlood(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ProgressBlood";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, 50);
				initProgress(true);		//khởi tạo thanh máu của mình
				initProgress(false);	//khởi tạo thanh máu của đối thủ
				AddImage("", "GuiLeague_PrgBloodFace", -9, -10, true, ALIGN_LEFT_TOP);
			}
			LoadRes("GuiLeague_PrgBloodBackGround");
			
		}
		public function initData(vitalityMe:int, vitalityHim:int):void
		{
			totalVitalityMe = vitalityMe;
			totalVitalityHim = vitalityHim;
			
			trace("máu của tôi : " + vitalityMe);
			trace("máu của đối phương : " + vitalityHim);
		}
		
		private function initProgress(isMe:Boolean):void 
		{
			var strOwn:String = isMe ? "Me" : "Him";
			var vitality:int = isMe ? totalVitalityMe : totalVitalityHim;
			var posY:int = 8;
			var posX:int = isMe ? 226 : 280;			//vị trí đặt progress bar
			var dir:int = isMe ? -1 : 1;			//hướng chạy của thanh progressbar
			
			this["prg" + strOwn] = AddProgress(ID_PRGBLOOD + "_" + strOwn, "GuiLeague_Prg" + strOwn + "1", posX, posY);
			var pgr:ProgressBar = this["prg" + strOwn] as ProgressBar;
			pgr.scaleX = dir;
			pgr.setStatus(1);
			/*
			for (var i:int = 2; i >= 0; i--)
			{
				var dVitality:int = vitality - i * BLOODSIZE;
				if (dVitality > 0)
				{
					for (var j:int = 0; j <= i; j++)
					{
						var kind:int = j + 1;
						this["prg" + strOwn + kind] = AddProgress(ID_PRGBLOOD + "_" + strOwn + "_" + kind,
																"GuiLeague_Prg" + strOwn + kind,
																posX, posY);
						
						var pgr:ProgressBar = this["prg" + strOwn + kind] as ProgressBar;
						pgr.scaleX = dir;
						pgr.setStatus(1);
						this["_max" + strOwn + kind] = dVitality;
						this["_dBlood" + strOwn + kind] = Number(dVitality) * DELTA_PERCENT / 100;
						this["virtualBlood" + strOwn + kind] = dVitality;
						this["blood" + strOwn + kind] = dVitality;
						dVitality = BLOODSIZE;
					}
					break;
				}
			}*/
		}
		
		/**
		 * thực hiện cập nhật lượng máu
		 * @param	isMe : có phải tôi hay không.
		 * @param	dVitality : lượng máu trừ vào thanh
		 */
		public function updateProgress(isMe:Boolean, dVitality:int):void
		{
			if (isMe) 
			{
				inUpdateMe = true;
			}
			else 
			{
				inUpdateHim = true;
			}
			var strOwn:String = isMe ? "Me" : "Him";
			//lấy giá trị cho blood trên các thanh
			for (var i:int = 3; i > 0; i--)
			{
				var bloodHere:int = this["blood" + strOwn + i];
				bloodHere += dVitality;
				if (bloodHere > 0)
				{
					this["blood" + strOwn + i] = bloodHere;
					break;
				}
				else 
				{
					this["blood" + strOwn + i] = 0;
					dVitality = 0 + bloodHere; //lượng máu bị trừ tiếp ở thanh sau
				}
			}
		}
		
		public function updateGui():void
		{
			var strOwn:String;
			var percent:Number;
			var i:int;
			if (inUpdateMe)
			{
				strOwn = "Me";
				percent = 0;
				for (i = 3; i > 0; i--)
				{
					if (this["virtualBlood"+ strOwn + i] > this["blood" + strOwn + i])//cập nhật khi lượng máu ảo chưa đuổi kịp máu thật
					{
						this["virtualBlood" + strOwn + i] -= this["_dBlood" + strOwn + i];
						percent = this["virtualBlood" + strOwn + i] / this["_max" + strOwn + i];
						percent = percent < 0 ? 0 : percent;
						(this["prg" + strOwn + i] as ProgressBar).setStatus(percent);
						break;
					}
					else //đuổi kịp
					{
						inUpdateMe = (i == 1) ? false : true;//nếu cả 3 thanh đều kịp => ko update nữa
					}
				}
			}
			if (inUpdateHim)
			{
				strOwn = "Him";
				percent = 0;
				for (i = 3; i > 0; i--)
				{
					if (this["virtualBlood"+ strOwn + i] > this["blood" + strOwn + i])//cập nhật khi lượng máu ảo chưa đuổi kịp máu thật
					{
						this["virtualBlood" + strOwn + i] -= this["_dBlood" + strOwn + i];
						percent = this["virtualBlood" + strOwn + i] / this["_max" + strOwn + i];
						percent = percent < 0 ? 0 : percent;
						(this["prg" + strOwn + i] as ProgressBar).setStatus(percent);
						break;
					}
					else //đuổi kịp
					{
						inUpdateHim = (i == 1) ? false : true;//nếu cả 3 thanh đều kịp => ko update nữa
					}
				}
			}
		}
		
		/**
		 * thực hiện set các giá trị máu thật, máu ảo, trừ máu về 0
		 */
		override public function OnHideGUI():void 
		{
			var obj:Object = { "1":"Me", "2":"Him" };
			for (var i:String in obj)
			{
				for (var j:int = 1; j <= 3; j++)
				{
					this["blood" + obj[i] + j] = 0;
					this["virtualBlood" + obj[i] + j] = 0;
					this["_dBlood" + obj[i] + j] = 0;
				}
			}
		}
	}

}












