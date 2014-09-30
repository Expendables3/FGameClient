package GUI.GuiGetStatus 
{
	import flash.display.Sprite;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	
	/**
	 * định nghĩa tập hợp những gui được khởi tạo sau khi lấy dữ liệu từ server về
	 * kế thừa thì sẽ override những hàm sau để xử lý:
	 * 		onInitGuiBeforeServer : vẽ gui trước khi nhận dữ liệu
	 * 		onLoadSomeThing : Thực hiện load file từ bên ngoài nếu cần
	 * 		onInitGuiAfterServer  : vẽ tiếp gui sau khi nhận dữ liệu
	 * 		onInitData:			  : khởi tạo cho các dữ liệu logic	
	 * 		onUpdateGui			  : cập nhật gui tại thời điểm curtime
	 * @author HiepNM2
	 */
	public class GUIGetStatusAbstract extends BaseGUI 
	{
		// const
		
		// gui
		[Embed(source = '../../../content/dataloading.swf', symbol = 'DataLoading')]
		protected var DataLoading:Class;
		protected var WaitData:Sprite = new DataLoading();
		// logic
		protected var _imgThemeName:String = "";
		protected var _urlService:String;
		protected var _idPacket:String;
		protected var _dataPacket:Object = null;
		protected var IsInitFinish:Boolean = false;
		protected var IsDataReady:Boolean;
		protected var IsLoadFileComp:Boolean = true;
		
		//protected var IsExternSend:Boolean = false;	//gói tin được gửi lên từ ngoài gui, ví dụ gửi gói getstatus từ 1 gui khác
		//protected var IsExternDataReady:Boolean = false;	//dữ liệu đã có, không cần gửi gói tin lên nữa, mà lấy dữ liệu từ nguồn ngoài
		public function GUIGetStatusAbstract(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGetStatusAbstract";
		}
		
		public function initData(imgTheme:String, urlService:String, idPacket:String):void
		{
			_imgThemeName = imgTheme;
			_urlService = urlService;
			_idPacket = idPacket;
		}
		
		override public function InitGUI():void 
		{
			
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
				onInitGuiBeforeServer();
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 10;
				WaitData.y = img.height / 2 - 10;
				IsFinishRoomOut=false;
				//if (IsDataReady && IsLoadFileComp && IsExternDataReady)//mở gui lần 2, trong trường hợp dữ liệu nhận từ ngoài
				//{
					//onGetReadyData();
				//}
				//else
				//{
					IsInitFinish = false;
					IsDataReady = false;
					IsLoadFileComp = true;//vì có thể có những gui không cần load file
					onLoadSomeThing();
					//if (!IsExternSend)
					//{
						var pk:SendGetStatus = SendGetStatus.createPacket(_urlService, _idPacket, _dataPacket);
						Exchange.GetInstance().Send(pk);
					//}
					//if (IsExternDataReady)
					//{
						//onGetReadyData();
					//}
				//}
				OpenRoomOut();
			}
			LoadRes(_imgThemeName);
		}
		
		/**
		 * hàm này để thực hiện load về dữ liệu bên ngoài ví dụ load file (xml, swf...)
		 */
		protected virtual function onLoadSomeThing():void 
		{
			
		}
		
		protected virtual function onInitGuiBeforeServer():void 
		{
			
		}
		
		/**
		 * lấy dữ liệu đã sẵn có từ nguồn ngoài
		 * Sau khi lấy xong thì gọi processData
		 */
		//protected virtual function onGetReadyData():void
		//{
			//
		//}
		/**
		 * xử lý dữ liệu nhận về từ server
		 * @param	data1 : dữ liệu nhận về từ server
		 */
		public function processData(data1:Object):void
		{
			onInitData(data1);
			IsDataReady = true;
			var initOk:Boolean = IsFinishRoomOut && IsLoadFileComp;
			if (initOk){
				initGui();
			}
		}
		
		/**
		 * khởi tạo cho các dữ liệu logic
		 * @param	data1 : dữ liệu từ server
		 */
		protected virtual function onInitData(data1:Object):void 
		{
			
		}
		
		override public function EndingRoomOut():void 
		{
			var initOk:Boolean = IsDataReady && IsLoadFileComp;
			if (initOk)
			{
				initGui();
			}
		}
		
		/**
		 * khởi tạo toàn bộ gui khi đầy đủ dữ liệu
		 */
		private function initGui():void 
		{
			//xóa cái vòng xoáy
			if (img == null)//nếu đã hide gui
			{
				return;
			}
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			// khởi tạo toàn bộ gui
			onInitGuiAfterServer();
			
			IsInitFinish = true;
		}
		
		/**
		 * vẽ gui sau khi đã có toàn bộ dữ liệu từ server
		 */
		protected virtual function onInitGuiAfterServer():void 
		{
			
		}
		/**
		 * cập nhật gui theo vòng lặp game
		 */
		public function updateGUI():void
		{
			if (IsInitFinish) {
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				onUpdateGui(curTime);
			}
		}
		
		/**
		 * cập nhật gui tại thời điểm curtime
		 * @param	curTime : thời điểm cập nhật
		 */
		protected virtual function onUpdateGui(curTime:Number):void 
		{
			
		}
		
	}

}
















