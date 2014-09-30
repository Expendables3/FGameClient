package GUI.GUIGemRefine.GemGUI 
{
	import Data.ConfigJSON;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GUIGemRefine.GemLogic.GemMgr;
	import GUI.GUIGemRefine.GemLogic.UpgradingGem;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * Container chứa 1 viên đan và hệ thống control ở khu luyện
	 * @author HiepNM2
	 */
	public class CtnRefine extends Container 
	{
		public const ID_PROGRESSBAR:String = "idProgressBar";
		public const ID_BTN_REFINE:String = "cmdRefine";
		public const CMD_RECEIVE:String = "cmdGetGem";
		public const ID_BTN_DELETE_UPGRADING_GEM:String = "cmdDelUpgradingGem";
		public const ID_BTN_REFINE_BY_MONEY:String = "cmdRefineByMoney";
		public const ID_BTN_REFINE_BY_ZMONEY:String = "cmdRefineByZMoney";
		public const CTN_REFINE_SOURCE:String = "CtnRefine";
		public const CTN_REFINE_DES:String = "CtnRefineDes";
		// logic
		private var _slotId:int;
		private var _isBusy:Boolean = false;	//slot này đang bận luyện đan hay đang đợi lấy đan luyện xong
		public function get SlotId():int
		{
			return _slotId;
		}
		public function set SlotId(value:int):void
		{
			_slotId = value;
		}
		public var _listGem:Array = [];
		private var _uGem:UpgradingGem;
		public function set uGem(value:UpgradingGem):void
		{
			_uGem = value;
		}
		public function get uGem():UpgradingGem
		{
			return _uGem;
		}
		// gui
		public var ctnSource:Container;
		public var ctnDes:Container;
		public var prgRefine:ProgressBar;
		public var tfTime:TextField;
		public var btnRefine:Button;
		public var btnReceive:Button;
		public var btnDelRefine:Button;
		public var btnQuickRefineMoney:Button;
		public var btnQuickRefineZMoney:Button;
		
		public function CtnRefine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "CtnGem";
		}
		
		public function drawBackGround():void
		{
			/*2 cái ảnh slot nguồn và đích*/
			ctnSource = AddContainer(CTN_REFINE_SOURCE + "_" + SlotId, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", 0, 0, true, EventHandler);
			ctnDes = AddContainer(CTN_REFINE_DES + "_" + SlotId, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", 205, 0);
			/*progress bar*/
			prgRefine = AddProgress(ID_PROGRESSBAR + "_" + SlotId, "GuiPearlRefine_ProbarTuLuyenNgoc", 75, 15, null, true);
			prgRefine.setStatus(0);
		}
		public function drawGem():void
		{
			var nameSource:String = Ultility.GetNamePearl(_uGem.Element, _uGem.Level);
			var tfNameSource:TextField = ctnSource.AddLabel(nameSource, -27, -20);
			//tfNameSource.scaleX = tfNameSource.scaleY = 1.4;
			var imgGem:Image = ctnSource.AddImage("", Ultility.GetNameImgPearl(_uGem.Element, _uGem.Level), 0, 0);
			if (_uGem.Level >= 0 && _uGem.Level <= 10)
			{
				imgGem.FitRect(45, 45, new Point(0, 0));
			}
			else if (_uGem.Level >= 11 && _uGem.Level <= 20)
			{
				imgGem.FitRect(53, 53, new Point(-1, -5));
			}
			var num:int = _uGem.ListGemSource.length;
			var tf:TextField = AddLabel("x" + num.toString(), -2, 15);
			tf.scaleX = tf.scaleY = 1.2;
			
			//enable nút luyện
			if (_uGem.IsWaitingPress)//đang trong trạng thái đợi để luyện
			{
				btnRefine = AddButton(ID_BTN_REFINE + "_" + SlotId, "GuiPearlRefine_Btn_Luyen_TuLuyenNgoc", -14, 55, EventHandler);
				if((_uGem.Level == 0 && _uGem.ListGemSource.length == 10) ||(_uGem.Level > 0 && _uGem.ListGemSource.length == 1))
				{
					btnRefine.SetEnable(true);
				}
				else
				{
					btnRefine.SetEnable(false);
				}
			}
			else//đang luyện hoặc đã luyện xong
			{
				//if (!_isBusy)
				//{
					//_isBusy = true;
					ctnSource.EventHandler = null;
					var isRefined:Boolean = GemMgr.getInstance().isRefined(_uGem);
					var strTime:String, percent:Number;
					if (isRefined)
					{
						//chỉ thêm nút nhận
						if (_uGem.TimeRefine < 0)
						{
							trace("TimeRefine = " + _uGem.TimeRefine + ". Hàm isRefined có vấn đề, tại sao TimeRefine < 0");
						}
						btnReceive = AddButton(CMD_RECEIVE + "_" + _uGem.SlotId, "GuiPearlRefine_Btn_Nhan_TuLuyenNgoc", 190, 55, EventHandler);
						percent = 1;
						strTime = "Xong";
					}
					else//viên đan này chưa luyện xong
					{
						//thêm nút Hủy và nút luyện ngay
						AddButtonDelAndRefine(_uGem.Level, _uGem.SlotId, 75, 55);
						/*tính toán thời gian luyện*/
						var objVar:Object = { TimeWait:0, Percent:0 };
						GemMgr.countInGem(_uGem.TimeRefine, _uGem.StartTimeRefine, objVar);
						strTime = Ultility.convertToTime((int)(objVar["TimeWait"]));
						percent = objVar["Percent"];
					}
					prgRefine.setStatus(percent);
					//nhãn thời gian
					tfTime = AddLabel(strTime, 80, -10);
					//vien dan destination
					var nameDes:String = Ultility.GetNamePearl(_uGem.Element, _uGem.LevelDone);
					var tfNameDes:TextField = ctnDes.AddLabel(nameDes, -27, -20);
					var imgGemDes:Image = ctnDes.AddImage("", Ultility.GetNameImgPearl(_uGem.Element, _uGem.LevelDone), 0, 0);
					if (_uGem.LevelDone >= 0 && _uGem.LevelDone <= 10)
					{
						imgGemDes.FitRect(45, 45, new Point(0, 0));
					}
					else if (_uGem.LevelDone >= 11 && _uGem.LevelDone <= 20)
					{
						imgGemDes.FitRect(53, 53, new Point(-1, -5));
					}
				//}
				
			}
		}

		private function AddButtonDelAndRefine(level:int, slotId:int, x:int, y:int):void
		{
			//thêm nút G hoặc Gold
			var tf:TextField;
			btnDelRefine = AddButton(ID_BTN_DELETE_UPGRADING_GEM + "_" + _uGem.SlotId, "GuiPearlRefine_Btn_Huy_TuLuyenNgoc", -14, 55, EventHandler);
			var money:int;
			var config:Array = ConfigJSON.getInstance().getItemInfo("Gem") as Array;
			if (config[level]["MoneyQuickUpgrade"]!=null)
			{
				//thêm nút Gold
				money = config[level]["MoneyQuickUpgrade"];
				btnQuickRefineMoney = AddButton(ID_BTN_REFINE_BY_MONEY + "_" + _slotId + "_1" + "_" + money, 
												"GuiPearlRefine_Btn_BuyGold_TuLuyenNgoc_1", 
												x, y, 
												EventHandler);
				
				//thêm giá tiền
				
				tf = AddLabel(Ultility.StandardNumber(money), x + 45, y);
				tf.name = "Money_" + slotId;
			}
			else
			{
				//thêm nút G
				money = config[level]["ZMoneyQuickUpgrade"];
				btnQuickRefineZMoney = AddButton(ID_BTN_REFINE_BY_ZMONEY + "_" + _slotId + "_0" + "_" + money, 
													"GuiPearlRefine_Btn_BuyG_TuLuyenNgoc_1", 
													x, y, 
													EventHandler);
				
				//thêm giá tiền
				tf = AddLabel(Ultility.StandardNumber(money), x + 45, y);
				tf.name = "ZMoney_" + slotId;
			}
		}
		/**
		 * thực hiện luyện gem ở thời điểm startTime
		 * @param	startTime
		 */
		public function refineGem(startTime:Number):void
		{
			
		}
		/**
		 * chuyển từ trạng thái đợi sang trạng thái luyện
		 */
		public function startRefine():void
		{
			/*remove nut luyen*/
			ctnSource.EventHandler = null;
			RemoveButton(ID_BTN_REFINE + "_" + _slotId);
			/*add nut huy va nut nhan*/
			AddButtonDelAndRefine(_uGem.Level, _uGem.SlotId, 75, 55);
			/*bắt đầu chạy thời gian*/
			if (_uGem.IsWaitingPress)
			{
				_uGem.StartTimeRefine = GameLogic.getInstance().CurServerTime;
			}
			var strTime:String, percent:Number;
			var objVar:Object = { TimeWait:0, Percent:0 };
			GemMgr.countInGem(_uGem.TimeRefine, _uGem.StartTimeRefine, objVar);
			strTime = Ultility.convertToTime((int)(objVar["TimeWait"]));
			prgRefine.setStatus(objVar["Percent"]);
			//nhãn thời gian
			tfTime = AddLabel(strTime, 80, -10);
			/*hiện ảnh của gem tiếp theo*/
			var nameDes:String = Ultility.GetNamePearl(_uGem.Element, _uGem.LevelDone);
			var tfNameDes:TextField = ctnDes.AddLabel(nameDes, -27, -20);
			var imgGem:Image = ctnDes.AddImage("", Ultility.GetNameImgPearl(_uGem.Element, _uGem.LevelDone), 0, 0);
			if (_uGem.LevelDone >= 0 && _uGem.LevelDone <= 10)
			{
				imgGem.FitRect(45, 45, new Point(0, 0));
			}
			else if (_uGem.LevelDone >= 11 && _uGem.LevelDone <= 20)
			{
				imgGem.FitRect(53, 53, new Point(-1, -5));
			}
			_uGem.JustRefined = false;
		}

		/**
		 * thực hiện update liên tục khi đan đan luyện
		 * mỗi second sẽ thực hiện update 1 lần
		 */
		public function updateRefine():void
		{
			if (_uGem == null || _uGem.TimeRefine < 0)
			{
				return;
			}
			if (_uGem.StepRefine == 0)//nếu đang luyện
			{
				//thực hiện update tfTime và prgRefine
				var objVar:Object = { TimeWait:0, Percent:0 };
				GemMgr.countInGem(_uGem.TimeRefine, _uGem.StartTimeRefine, objVar);
				tfTime.text = Ultility.convertToTime((int)(objVar["TimeWait"]));
				prgRefine.setStatus(objVar["Percent"]);
			}
			else if (_uGem.StepRefine == 1)//nếu đã luyện xong
			{
				trace("finish luyện đan nhờ tick count tại slot có id = " + SlotId);
				if (_uGem.TimeRefine < 0)
				{
					_uGem.JustRefined = true;
					trace("aaaaaaaaaaaaaaaaaaaaaaaa");
					return;
				}
				finishRefine();
			}
			else	//nếu chưa bấm nút luyện
			{
				return;
			}
		}
		/**
		 * sau khi luyen dan xong
		 */
		public function finishRefine():void
		{
			_uGem.JustRefined = true;
			GemMgr.getInstance().finishRefine(_uGem);
			/*xóa nút luyện nhanh và hủy*/
			RemoveButton(btnDelRefine.ButtonID);
			if (btnQuickRefineMoney)
			{
				delLabel("Money");
				RemoveButton(btnQuickRefineMoney.ButtonID);
			}
			if (btnQuickRefineZMoney)
			{
				delLabel("ZMoney");
				RemoveButton(btnQuickRefineZMoney.ButtonID);
			}
			/*thêm vào nút nhận*/
			btnReceive = AddButton(CMD_RECEIVE + "_" + _uGem.SlotId, "GuiPearlRefine_Btn_Nhan_TuLuyenNgoc", 190, 55, EventHandler);
			/*cập nhật progressbar*/
			prgRefine.setStatus(1);
			tfTime.text = "Xong";

			/*vô hiệu hóa bắt sự kiện vào ctnSource*/
			ctnSource.EventHandler = null;

		}
		
		private function delLabel(type:String):void
		{
			var nameTf:String = type + "_" + _uGem.SlotId;
			for (var i:int = 0; i < LabelArr.length; i++)
			{
				var tf:TextField = LabelArr[i] as TextField;
				if (tf.name == nameTf)
				{
					img.removeChild(tf);
					LabelArr.splice(i, 1);
					break;
				}
			}
		}
		
		private function processQuickUpgrade():void
		{
			//finishRefine();
		}
	}

}


























