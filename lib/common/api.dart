class API{
  /*static String BaseUrl="https://royalbotanica.in/wp-json/";
  static final String USER_LOGIN = BaseUrl + "wp/v2/users/login";
  static final String HOME_CATEGORIES = BaseUrl + "wc/store/products/categories";
  static final String FEATURED_PRODUCT = BaseUrl + "wp/v2/products/featured_products";
  static  final String PRODUCT_DETAILS=BaseUrl+"wc/store/products/";
  static final String HOME_BANNER = BaseUrl + "wp/v2/banner?_embed";*/


  //static final String SERVICE_LIST = "https://onqanet.co.in/devbi01/zoomm/api/upload/1";
  //static final String RULE_LIST = "https://onqanet.co.in/devbi01/zoomm/api/upload/2";
  //static final String ANNOUNCEMENT_LIST = "https://onqanet.co.in/devbi01/zoomm/api/upload/3";

  static String _BaseUrl="https://onqanet.net/dev_waqueel01/breakfix/api/";
  static final String LOGIN = _BaseUrl + "loginapi.php";
  static final String MOBILE_VALIDATE = _BaseUrl + "mobilevalidationapi.php";
  static final String RESET_PASSWORD = _BaseUrl + "forgotpasswordapi.php";
  static final String SERVICE_OPTIN_LIST = _BaseUrl + "serviceapi.php";
  static final String SERVICE_REQUEST = _BaseUrl + "servicerequestapi.php";
  static final String SERVICE_REQUESTED_LIST = _BaseUrl + "servicerequestlistapi.php";
  static final String EVENT_LIST = _BaseUrl + "eventlistapi.php";
  static final String EVENT_UPDATE = _BaseUrl + "eventupdateapi.php";
  static final String WARDEN_COUNSELLING_LIST = _BaseUrl + "staffcounsellinglistapi.php";
  static final String STUDENT_TRAVELING_LIST = _BaseUrl + "travelrequestlistapi.php";
  static final String WARDEN_TRAVELING_LIST = _BaseUrl + "stafftravelrequestlistapi.php";
  static final String WARDEN_TRAVELING_REPLY = _BaseUrl + "stafftravelrequestupdateapi.php";
  static final String SERVICE_REQUESTED_CLOSE = _BaseUrl + "servicerequestclosureapi.php";
  static final String WARDEN_COUNSELLING_CLOSE = _BaseUrl + "staffcounsellingupdateapi.php";
  static final String WARDEN_SERVICE_LIST = _BaseUrl + "staffrequestapilist.php";
  static final String WARDEN_SERVICE_STATUS_UPDATE = _BaseUrl + "statffrequeststatusupdateapi.php";
  static final String WARDEN_SERVICE_REMARK = _BaseUrl + "serviceremarkapi.php";
  static final String STUDENT_UPLOAD_DOCUMENT = _BaseUrl + "documentuploadapi.php";
  static final String WARDEN_COMMENT_LIST = _BaseUrl + "servicecommentlist.php";
  static final String PROFILE_DETAILS = _BaseUrl + "profileapi.php";
  static final String QRCODE_VALIDATION = _BaseUrl + "qrverification.php";
  static final String ATTENDANCE = _BaseUrl + "attendenceapi.php";
  static final String PERMISSION_OPTION_LIST = _BaseUrl + "permissionlistapi.php";
  static final String PERMISSION_REQUEST = _BaseUrl + "permissionrequestapi.php";
  static final String PERMISSION_REQUEST_DEMO = _BaseUrl + "premissionchkrequest.php";
  static final String COUNSELLING_REQUEST = _BaseUrl + "counsellingrequestapi.php";
  static final String TRAVEL_REQUEST = _BaseUrl + "travelrequestapi.php";
  static final String PERMISSION_LIST = _BaseUrl + "permissionrequestlistapi.php";
  static final String ANNOUNCEMENT_LIST = _BaseUrl + "announcementlistapi.php";
  static final String DOCUMENT_LIST = _BaseUrl + "uploaddocumentlistapi.php";
  static final String RULES_REGULATION_LIST = _BaseUrl + "rulesregulationapi.php";
  static final String MEDICAL_REQUEST = _BaseUrl + "medicalrequestapi.php";
  static final String WARDEN_MEDICAL_REQUEST_LIST = _BaseUrl + "staffmedicalrequestapilist.php";
  static final String ENTRANCE_ALLOW_REQUEST = _BaseUrl + "checkpermissionapi.php";
  static final String ENTRANCE_ALLOW_CHECK_REQUEST = _BaseUrl + "checkallowapi.php";
  static final String PARENT_PERMISSION_LIST = _BaseUrl + "parentpermissionlistapi.php";
  static final String PERMISSION_STATUS_UPDATE = _BaseUrl + "permissionstatusupdateapi.php";
  static final String PERMISSION_STATUS_UPDATE_WITH_WHATSAPP_NOTIFICATION = _BaseUrl + "permissionnumber.php";
  static final String PARENT_STUDENT_LIST = _BaseUrl + "parentstudentlistingapi.php";
  static final String _ABOUTUS = _BaseUrl + "aboutusapi.php";
  static final String ABOUTUS = _BaseUrl + "aboutus2api.php";
  static final String WARDEN_ANNOUNCEMENT_LIST = _BaseUrl + "staffannouncementlistapi.php";
  static final String WARDEN_PERMISSION_LIST = _BaseUrl + "staffpermissionlistapi.php";
  static final String WARDEN_STUDENT_SEARCH = _BaseUrl + "studentsearchapi.php";
  static final String APP_VERSION_CHECK = _BaseUrl + "appversionapi.php";
  static final String NOTIFICATION_LIST = _BaseUrl + "notificationlistapi.php";
  static final String ALL_NOTIFICATION_LIST = _BaseUrl + "notificationalllistapi.php";
  static final String NOTIFICATION_READ = _BaseUrl + "notificationviewedupdate.php";
  static final String WHATSAPP_NOTIFICATION = _BaseUrl + "watsappnotificationsendapi.php";


  static final String WHATSAPP_MESSAGE_BASE_URL = "https://hisocial.in/api/send?number=91";
  static final String WHATSAPP_MESSAGE_TYPE = "&type=text&message=";
  static final String WHATSAPP_MESSAGE_TOKEN = "&instance_id=66E4112469353&access_token=667aa25787de4";
  static final String OTP_BASE_URL = "https://sms.sendmsg.in/smpp?username=Royalhome_OTP&password=HgstDadUIDJb&from=RYLHMS&to=";
  static final String OTP_BASE_TYPE = "&text=Hi ";
  static final String OTP_BASE_MSG = " is the OTP for validating your access request on our App. Do not share the OTP for security reasons - Royal Home.&urlshortening=0";

  //static final String food_menu_src="https://kolkatarbiryani.com/wp-content/uploads/2024/04/A4-Menu-Card-Final-Saltlake.jpg";
  static final String food_menu_src="https://stayzapp.in/registration/foodmenu/FoodMenu.jpg";
  static final String food_menu_path="https://stayzapp.in/registration/foodmenu/FoodMenu_";
  static final String food_menu_extancen=".jpg";
  //static final String food_menu_src="https://www.weddingbellcaterer.com/wp-content/uploads/2020/10/regular-lunch-dinner-home-delivery-service-kolkata.jpg";
  //static final String emergency_contact_src="https://kolkatarbiryani.com/wp-content/uploads/2024/04/A4-Menu-Card-Final-Saltlake.jpg";
  static final String emergency_contact_src="https://stayzapp.in/registration/emergencycontacts//emergencycontacts.jpg";
  static final String emergency_contact_path="https://stayzapp.in/registration/emergencycontacts/EmergencyContacts_";
  static final String emergency_contact_extancen=".jpg";
  static final String download_test_url="https://www.clickdimensions.com/links/TestPDFfile.pdf";
}