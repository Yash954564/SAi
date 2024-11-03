library constants;

import 'dart:core';

String APP_NAME = 'SAi';

/// Your wordpress website URLs
/// Replace the following fields with your website URL
///
/// For Example Your Website URL: http://subdomain.domain.com/subpath

/// const String WORDPRESS_URL_SCHEME = "http";
/// const String WORDPRESS_URL_DOMAIN = "subdomain.domain.com";
/// const String WORDPRESS_URL_PATH = "/subpath";
///
/// if your website URL does not contain path then leave WORDPRESS_URL_PATH empty.

String WORDPRESS_URL_SCHEME = "https";
String WORDPRESS_URL_DOMAIN = "subdomain.domain.com";
String WORDPRESS_URL_PATH = "";

String APP_TERMS_URL = "https://houzi.booleanbites.com/terms.html";
String APP_PRIVACY_URL = "https://houzi.booleanbites.com/privacy.html";
String APP_TERMS_OF_USE_URL = "https://houzi.booleanbites.com/terms.html";
String WORDPRESS_URL_GDPR_AGREEMENT =
    "https://houzi.booleanbites.com/terms.html";

/// Your Company Related
String COMPANY_URL = "https://booleanbites.com";

///Some website use 'wp/v2/properties' and some 'wp/v2/property' and some 'wp/v2/translated_property_name'
// const String REST_API_PROPERTIES_ROUTE = 'property';
String REST_API_PROPERTIES_ROUTE = 'properties';

///Some website use 'wp/v2/agents' and some 'wp/v2/houzez_agent' and some 'wp/v2/translated_agent_name'
String REST_API_AGENT_ROUTE = 'agents';

///Some website use 'wp/v2/agencies' and some 'wp/v2/houzez_agency' and some 'wp/v2/translated_agency_name'
String REST_API_AGENCY_ROUTE = 'agencies';

/// Provide google map api here
String GOOGLE_MAP_API_KEY = "AIzaSyB97Doab8QwQI07LoPR-0ypU-DLYzhrnvw";
// /// Provide android app id for googleMobAds here
// const String ANDROID_APP_ID = "";
// /// Provide ios app id for googleMobAds here
// const String IOS_APP_ID = "";

/// Provide google android banner ad id here
String ANDROID_BANNER_AD_ID = "ca-app-pub-3940256099942544/6300978111";

/// Provide google ios banner ad id here
String IOS_BANNER_AD_ID = "ca-app-pub-3940256099942544/6300978111";

/// Provide google android banner ad id here
String ANDROID_NATIVE_AD_ID = "ca-app-pub-3940256099942544/2247696110";

/// Provide google ios banner ad id here
String IOS_NATIVE_AD_ID = "ca-app-pub-3940256099942544/2247696110";

/// Insert your one signal app id here.
String ONE_SIGNAL_APP_ID = "";

/// Provide Service Id here
const String APPLE_SIGN_ON_CLIENT_ID = "com.houzi.app.signin";

/// Provide Redirect Uri here
String APPLE_SIGN_ON_REDIRECT_URI = "https://example-app.com/redirect";

/// Provide Tabbed Home Quote here
String TABBED_HOME_QUOTE = "What are you looking for?";

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const String HOUZI_VERSION = "1.0.0";

const String COMPANY_NAME = "BooleanBites Ltd.";

/// Communication Protocol Related
const String HTTP = 'http';
const String HTTPS = 'https';

const String APP_BASE_URL = 'app_base_url';
const String APP_INFO = 'AppInfo';
const String HIVE_BOX_OLD = 'Hive_Storage_Box';
const String HIVE_BOX = 'Hive_Storage_Box_V1';

const String APP_CONFIG_JSON_PATH = "assets/configurations/configurations.json";

const List<String> sortDropDown = [
  "Price - Low To High",
  'Price - High To Low',
  'Date - Old to New',
  "Date - New to Old",
];

const List<String> propertyType = [
  "Home",
  "Apartment",
  "Condo",
  'Office',
  'Shop',
  "Studio",
];

const String PLEASE_SELECT = "Please Select";
String MIN_PRICE = "0";
String MAX_PRICE = "5000000";
String MIN_AREA = "0";
String MAX_AREA = "1000000";
String DEFAULT_RADIUS = "50";
const String CLOSE = "close";
const String DONE = "Done";
const String RESET = "Reset";
const String UPDATE_DATA = "Update_Data";

const String PROPERTY_TYPE = "property_type";
const String PROPERTY_TYPE_SLUG = "property_type_slug";
const String PROPERTY_STATUS = "property_status";
const String PROPERTY_STATUS_SLUG = "property_status_slug";
const String PROPERTY_LABEL = "property_label";
const String PROPERTY_LABEL_SLUG = "property_label_slug";
const String PROPERTY_AREA = "property_area";
const String PROPERTY_AREA_SLUG = "property_area_slug";
const String PROPERTY_STATE = "property_state";
const String PROPERTY_STATE_SLUG = "property_state_slug";
const String PROPERTY_COUNTRY = "property_country";
const String PROPERTY_COUNTRY_SLUG = "property_country_slug";
const String PROPERTY_FEATURES = "property_features";
const String PROPERTY_FEATURES_SLUG = "property_features_slug";
const String PROPERTY_KEYWORD = "keyword";
const String PROPERTY_CUSTOM_FIELDS = "custom_fields";
const String PROPERTY_UNIQUE_ID = "property_id";

const String PROPERTY_COUNTRY_QUERY_TYPE = "country_query_type";
const String PROPERTY_STATE_QUERY_TYPE = "state_query_type";
const String PROPERTY_AREA_QUERY_TYPE = "area_query_type";
const String PROPERTY_STATUS_QUERY_TYPE = "status_query_type";
const String PROPERTY_TYPE_QUERY_TYPE = "type_query_type";
const String PROPERTY_LABEL_QUERY_TYPE = "label_query_type";
const String PROPERTY_FEATURES_QUERY_TYPE = "features_query_type";

const String CITY = "search_city";
const String CITY_ID = "search_city_id";
const String CITY_SLUG = "city_slug";

const String PROPERTY_TITLE = "property_title";

const String PRICE_MIN = "price_min";
const String PRICE_MAX = "price_max";
const String CURRENCY_SYMBOL = "currency_symbol";
const String AREA_MIN = "area_min";
const String AREA_MAX = "area_max";
const String AREA_TYPE = "area_type";
const String BEDROOMS = "bedrooms";
const String BATHROOMS = "bathrooms";
const String SELECTED_LOCATION = "selected_location_";
const String LATITUDE = 'search_lat';
const String LONGITUDE = 'search_long';
const String RADIUS = 'search_radius';
const String USE_RADIUS = 'use_radius';
const String SEARCH_LOCATION = 'search_location';
const String SELECTED_INDEX_FOR_TAB = 'selected';
const String SEARCH_COUNT = 'total_count';

const String AGENT_ID = "agent_id";
const String AGENT_DATA = "agent_data";
const String AGENT_INFO = "agent_info";
const String AGENCY_ID = "agency_id";
const String AGENCY_DATA = "agency_data";
const String AGENCY_INFO = "agency_info";
const String AUTHOR_ID = "author_id";
const String AUTHOR_DATA = "author_data";
const String AUTHOR_INFO = "author_info";

/// Home Screen Drawer Related
const String ADD_PROPERTY = 'Add Property';
const String USER_SIGNUP_PAGE = 'User Signup';
const String HOME = 'Home';
const String ACTIVITY = 'Activities';
const String INQUIRIES = 'Inquiries';
const String DEALS = 'Deals';
const String LEADS = 'Leads';
const String PROPERTIES = 'Properties';
const String MY_PROPERTIES = 'My Properties';
const String LOGIN = 'Login';
const String LOGOUT = 'Logout';
const String QUICK_ADD_PROPERTY = 'Quick Add Property';
const String DASHBOARD = 'Dash Board';
const String INQUIRY_FORM = 'Inquiry Form';
const String REQUEST_DEMO = 'Request Demo';

const USER_PROFILE_NAME = "username";
// const USER_PROFILE_NAME = "UserName";
const USER_PROFILE_IMAGE = "UserImage";
const USER_ROLE = "UserRole";
const USER_LOGGED_IN = "UserLoggedIn";

/// User Login Related
const String USER_NAME = 'username';
const String PASSWORD = 'password';
const String API_NONCE = 'api_nonce';

/// Social Login Related
const USER_SOCIAL_EMAIL = "email";
const USER_SOCIAL_ID = "user_id";
const USER_SOCIAL_PLATFORM = "source";
const USER_SOCIAL_DISPLAY_NAME = "display_name";
const USER_SOCIAL_PROFILE_URL = "profile_url";

/// Social Platform Related
const SOCIAL_PLATFORM_GOOGLE = "google";
const SOCIAL_PLATFORM_FACEBOOK = "facebook";
const SOCIAL_PLATFORM_APPLE = "apple";
const PLATFORM_PHONE = "phone";

/// STORAGE Keys:
const String PROPERTY_META_DATA = 'PropertyMetaData';
const String SCHEDULE_TIME_SLOTS = 'ScheduleTimeSlots';
const String PROPERTY_TYPES_METADATA = 'PropertyTypeMetaData';
const String PROPERTY_LABELS_METADATA = 'PropertyLabelMetaData';
const String PROPERTY_COUNTRIES_METADATA = 'PropertyCountriesMetaData';
const String PROPERTY_STATES_METADATA = 'PropertyStatesMetaData';
const String PROPERTY_AREA_METADATA = 'PropertyAreaMetaData';
const String PROPERTY_STATUS_METADATA = 'PropertyStatusMetaData';
const String PROPERTY_STATUS_MAP_DATA = 'PropertyStatusMapData';
const String PROPERTY_FEATURES_METADATA = 'PropertyFeaturesMetaData';
const String PROPERTY_TYPES_DATA_MAP = 'PropertyTypeMap';
const String CITIES_METADATA = 'CityMetaDataList';
const String AGENT_CITIES_METADATA = 'AgentCityMetaDataList';
const String AGENT_CATEGORIES_METADATA = 'AgentCategoriesMetaDataList';
const String SELECTED_CITY_INFORMATION = 'SelectedCityInfo';
const String FILTER_DATA_INFORMATION = 'FilterDataInfo';
const String DEFAULT_CURRENCY = 'DefaultCurrency';
const String INQUIRY_TYPE = 'InquiryType';
const String USER_LOGIN_INFO_DATA = 'userLoginInfoData';
const String USER_CREDENTIALS = 'UserCredentials';
const String PROPERTY_TYPES_MAP_DATA = 'PropertyTypeMapData';
const String RECENT_SEARCHES = 'RecentSearches';
const String COMMUNICATION_PROTOCOL = 'CommunicationProtocol';
const String APP_AUTHORITY = 'AppAuthority';
const String APP_URL = 'AppUrl';
const String INTERNET_CONNECTION_STATUS = 'InternetConnectionStatus';
const String SELECTED_LANGUAGE = 'SelectedLanguage';
const String SELECTED_LANGUAGE_CODE = 'SelectedLanguageCode';
const String SELECTED_LANGUAGE_SCRIPT = 'SelectedLanguageScript';
const String SELECTED_LANGUAGE_COUNTRY = 'SelectedLanguageCountry';
const String AGENT_CITY_METADATA = 'AgentCityMetaData';
const String AGENT_CATEGORY_METADATA = 'AgentCategoryMetaData';
const String TASKS_IDS_LIST = 'tasks_ids_list';
const String USER_ROLE_LIST = 'userRoleList';
const String ADMIN_USER_ROLE_LIST = 'adminUserRoleList';
const String PROPERTY_EMAIL_CONTACT_DATA = 'propertyEmailContact';
const String CUSTOM_FIELDS = 'customFields';
const String APP_CONFIGURATIONS_STORE_KEY = 'appConfigurationsStoreKey';
const String HOME_CONFIG_DATA_LIST = 'home_config_list';
const String FILTER_CONFIG_DATA_LIST = 'filter_config_list';
const String DRAWER_CONFIG_DATA_LIST = 'drawer_config_list';
const String PROPERTY_DETAIL_CONFIG_DATA_LIST = 'property_detail_config_list';
const String NAVBAR_CONFIG_DATA_LIST = 'navbar_config_list';
const String SORT_FIRST_BY_CONFIG_DATA_LIST = 'sort_first_by_config_list';
const String BLOG_DETAIL_CONFIG_DATA_LIST = 'blog_detail_config_list';
const String HOUZEZ_VERSION_STORE_KEY = 'houzezVersionStoreKey';
const String SELECTED_HOME_OPTION_KEY = 'selectedHomeOption';
const String HOUZI_VERSION_STORE_KEY = 'houziVersionStoreKey';
const String LEAD_PREFIX_STORE_KEY = 'leadPrefixKey';
const String LEAD_SOURCE_STORE_KEY = 'leadSourceKey';
const String DEAL_STATUS_STORE_KEY = 'dealStatusKey';
const String DEAL_NEXT_ACTION_STORE_KEY = 'dealNextActionKey';
const String ADD_PROPERTY_CONFIGURATIONS_STORE_KEY = 'aaddPropertyConfigurationsStoreKey';
const String QUICK_ADD_PROPERTY_CONFIGURATIONS_STORE_KEY = 'quickAddPropertyConfigurationsStoreKey';
const String USER_PAYMENT_STATUS_KEY = 'userPaymentStatus';
const String sequential_location_key = 'storeSequentialLocation';

const String HEADER_SECURITY_KEY = 'security_key';

const String SELECTED_COUNTRY_INFO_KEY = 'SelectedCountryInfo';
const String SELECTED_STATE_INFO_KEY = 'SelectedStateInfo';
const String SELECTED_AREA_INFO_KEY = 'SelectedAreaInfo';

/// Design Related Storage Keys
const String HOME_SCREEN_ITEM_DESIGN = 'homeScreen_design';
const String EXPLORE_BY_TYPE_ITEM_DESIGN = 'exploreByType_design';
const String THEME_MODE_INFO = 'themeMode';
const String LIGHT_THEME_MODE = 'light';
const String DARK_THEME_MODE = 'dark';
const String SYSTEM_THEME_MODE = 'system';

const String AGENCIES_DATA = 'AgenciesData';
const String AGENTS_DATA = 'AgentsData';

const String SETTINGS = 'Settings';
const String DARK_MODE = 'Dark Mode';
const String SYSTEM_THEME = 'System Theme';
const String LANGUAGE = 'Language';
const String TERMS_AND_CONDITIONS = 'Terms and Conditions';
const String PRIVACY_POLICY = 'Privacy Policy';
const String ABOUT = 'About';

/// Update related
const String UPDATE_PROPERTY_ID = 'prop_id';
const String UPDATE_PROPERTY_IMAGES = 'prop_images';
const String UPDATE_PROPERTY_IMAGES_ID = 'propperty_image_ids[]';

/// Add property data Map keys
const String ADD_PROPERTY_ACTION = 'action';
const String ADD_PROPERTY_ACTION_ADD = 'add_property';
const String ADD_PROPERTY_ACTION_UPDATE = 'update_property';
const String ADD_PROPERTY_USER_ID = 'user_id';
const String ADD_PROPERTY_TITLE = 'prop_title';
const String ADD_PROPERTY_DESCRIPTION = 'prop_des';
const String ADD_PROPERTY_TYPE = 'prop_type[]';
const String ADD_PROPERTY_STATUS = 'prop_status[]';
const String ADD_PROPERTY_LABELS = 'prop_labels[]';
const String ADD_PROPERTY_PRICE = 'prop_price';
const String ADD_PROPERTY_PRICE_POSTFIX = 'prop_label';
const String ADD_PROPERTY_PRICE_PREFIX = 'prop_price_prefix';
const String ADD_PROPERTY_SECOND_PRICE = 'prop_sec_price';
const String ADD_PROPERTY_CURRENCY = 'currency';
const String ADD_PROPERTY_VIDEO_URL = 'prop_video_url';
const String ADD_PROPERTY_BEDROOMS = 'prop_beds';
const String ADD_PROPERTY_BATHROOMS = 'prop_baths';
const String ADD_PROPERTY_SIZE = 'prop_size';
const String ADD_PROPERTY_SIZE_PREFIX = 'prop_size_prefix';
const String ADD_PROPERTY_LAND_AREA = 'prop_land_area';
const String ADD_PROPERTY_LAND_AREA_PREFIX = 'prop_land_area_prefix';
const String ADD_PROPERTY_GARAGE = 'prop_garage';
const String ADD_PROPERTY_GARAGE_SIZE = 'prop_garage_size';
const String ADD_PROPERTY_YEAR_BUILT = 'prop_year_built';
const String ADD_PROPERTY_FEATURES_LIST = 'prop_features[]';
const String ADD_PROPERTY_MAP_ADDRESS = 'property_map_address';
const String ADD_PROPERTY_COUNTRY = 'country';
const String ADD_PROPERTY_STATE_OR_COUNTY = 'administrative_area_level_1';
const String ADD_PROPERTY_CITY = 'locality';
const String ADD_PROPERTY_AREA = 'neighborhood';
const String ADD_PROPERTY_POSTAL_CODE = 'postal_code';
const String ADD_PROPERTY_LATITUDE = 'lat';
const String ADD_PROPERTY_LONGITUDE = 'lng';
const String ADD_PROPERTY_VIRTUAL_TOUR = 'virtual_tour';
const String ADD_PROPERTY_FLOOR_PLANS_ENABLE = 'floorPlans_enable';
const String ADD_PROPERTY_FLOOR_PLANS = 'floor_plans';
const String ADD_PROPERTY_MULTI_UNITS = 'multiUnits';
const String ADD_PROPERTY_FAVE_MULTI_UNITS = 'fave_multi_units';
const String ADD_PROPERTY_FAVE_PROPERTY_MAP = 'fave_property_map';
const String ADD_PROPERTY_PROPERTY_ID = 'property_id';
const String ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP =
    'user_submit_has_no_membership';
const String ADD_PROPERTY_IMAGE_IDS = 'propperty_image_ids[]';
const String ADD_PROPERTY_FEATURED_IMAGE_ID = 'featured_image_id';
const String ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX = 'featured_image_index';
const String ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION =
    'fave_agent_display_option';
const String ADD_PROPERTY_FAVE_AGENT = 'fave_agents[]';
const String ADD_PROPERTY_FAVE_AGENCY = 'fave_property_agency[]';
const String ADD_PROPERTY_UPLOAD_STATUS = 'add_property_upload_status';
const String ADD_PROPERTY_UPLOAD_STATUS_IN_PROGRESS = 'in_progress';
const String ADD_PROPERTY_UPLOAD_STATUS_PENDING = 'pending';
const String ADD_PROPERTY_DRAFT_INDEX = 'draft_index';
const String ADD_PROPERTY_DRAFT_TEMP_TITLE = "Temp Title";
const String ADD_PROPERTY_DRAFT_PROGRESS_KEY = "draft_progress_key";
const String ADD_PROPERTY_DRAFT_IN_PROGRESS = "draft_in_progress";
const String ADD_PROPERTY_DRAFT_SAVED = "draft_saved";
const String ADD_PROPERTY_ADDITIONAL_FEATURES = 'additional_features';
const String ADD_PROPERTY_FAVE_MULTI_UNITS_IDS = 'fave_multi_units_ids';
const String ADD_PROPERTY_PROPERTY_FEATURED = 'prop_featured';
const String ADD_PROPERTY_LOGGED_IN_REQUIRED = 'login-required';
const String ADD_PROPERTY_PRICE_PLACEHOLDER = 'prop_price_placeholder';
const String ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER = 'show_price_placeholder';

/// Custom (Non-Api) Map Key for Add Property Private Note
const String ADD_PROPERTY_PRIVATE_NOTE = 'fave_private_note';
const String ADD_PROPERTY_MAKE_PROPERTY_FEATURED = 'fave_featured';
const String ADD_PROPERTY_USER_LOGGED_IN_TO_VIEW = 'fave_loggedintoview';
const String ADD_PROPERTY_DISCLAIMER = 'fave_property_disclaimer';

const String ADD_PROPERTY_PENDING_IMAGES_LIST = 'pending_images_list';
const String ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID = 'featured_image_local_id';
const String ADD_PROPERTY_LOCAL_ID = 'property_local_id';
const String ADD_PROPERTY_LOGGED_IN = 'property_logged_in';
const String ADD_PROPERTY_NONCE = 'addPropertyNonce';
const String ADD_PROPERTY_IMAGE_NONCE = 'addPropertyImageNonce';

const String ADD_PROPERTIES_DATA_MAPS_LIST_KEY = 'AddPropertiesDataMapsListKey';
const String DRAFT_PROPERTIES_DATA_MAPS_LIST_KEY =
    'DraftPropertiesDataMapsListKey';

const String ROLE_ADMINISTRATOR = 'administrator';
const String ROLE_ADMINISTRATOR_CAPITAL = 'Administrator';
const String STATUS_PUBLISH = 'publish';
const String STATUS_ON_HOLD = 'on_hold';
const String STATUS_ON_PENDING = 'pending';
const String STATUS_APPROVE = 'approve';
const String STATUS_DISAPPROVE = 'disapproved';
const String MARK_FEATURED = 'houzez_mark_featured';
const String REMOVE_FEATURED = 'houzez_remove_featured';
const String MARK_AS_SOLD = 'houzez_mark_as_sold';
const String EXPIRED_LISTING = 'houzez_expire_listing';

const String USER_ROLE_HOUZEZ_AGENT_VALUE = 'houzez_agent';
const String USER_ROLE_HOUZEZ_AGENCY_VALUE = 'houzez_agency';
const String USER_ROLE_HOUZEZ_OWNER_VALUE = 'houzez_owner';
const String USER_ROLE_HOUZEZ_BUYER_VALUE = 'houzez_buyer';
const String USER_ROLE_HOUZEZ_SELLER_VALUE = 'houzez_seller';
const String USER_ROLE_HOUZEZ_MANAGER_VALUE = 'houzez_manager';

const String USER_ROLE_HOUZEZ_AUTHOR_VALUE = 'houzez_author';

const String USER_ROLE_HOUZEZ_AGENT_OPTION = 'Agent';
const String USER_ROLE_HOUZEZ_AGENCY_OPTION = 'Agency';
const String USER_ROLE_HOUZEZ_OWNER_OPTION = 'Owner';
const String USER_ROLE_HOUZEZ_BUYER_OPTION = 'Buyer';
const String USER_ROLE_HOUZEZ_SELLER_OPTION = 'Seller';
const String USER_ROLE_HOUZEZ_MANAGER_OPTION = 'Manager';

const String ACTIVE_OPTION = 'active';
const String WON_OPTION = 'won';
const String LOST_OPTION = 'lost';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/// To show/hide the Demo Configuration Widgets/Features

const bool SHOW_DEMO_CONFIGURATIONS = false;

bool SHOW_REQUEST_DEMO = false;

bool SHOW_THEME_RELATED_SETTINGS = false;

bool SHOW_ADD_PROPERTY = false;

bool ENABLE_HTML_IN_DESCRIPTION = true;
bool ENABLE_HTML_IN_BLOG_DESCRIPTION = true;

const String DEMO_URL = 'https://demodomain.com/';

///When we send a demo version to a client, we need to set this as true,
///setting this to true will make the app request to a webservices,
///that'll check if this app is allowed to execute or not, so
///we can control the lifetime of a demo version.
const bool APP_IS_IN_CLIENT_DEMO_MODE = false;

///demo version id to match with our online list.
const int APP_DEMO_ID = 0; //Houzi

/// Need to fix agent profile 1=> yes, 0=> no
const int NEED_TO_FIX_PROFILE_PIC = 0;

/// Show city on filter page
bool SHOW_SEARCH_BY_CITY = true;

/// Show location on filter page
bool SHOW_SEARCH_BY_LOCATION = true;

/// Social SignOn Related
const bool SHOW_SOCIAL_LOGIN = true;
bool SHOW_LOGIN_WITH_FACEBOOK = true;
bool SHOW_LOGIN_WITH_GOOGLE = true;
bool SHOW_LOGIN_WITH_APPLE = true;
bool SHOW_LOGIN_WITH_PHONE = true;

bool SHOW_SIGNUP_ENTER_PHONE_FIELD = false;
bool SHOW_SIGNUP_ENTER_FIRST_NAME_FIELD = false;
bool SHOW_SIGNUP_ENTER_LAST_NAME_FIELD = false;
bool SHOW_SIGNUP_PASSWORD_FIELD = false;

/// Drafts Related
const bool SHOW_DRAFTS = true;

/// Ads related
bool SHOW_ADS = false;
bool SHOW_ADS_ON_HOME = SHOW_ADS;
bool SHOW_ADS_ON_LISTINGS = SHOW_ADS;
bool SHOW_ADS_PROPERTY_PAGE = SHOW_ADS;

/// Slider related
/// Show slider on home screen
const bool SHOW_SLIDER_ON_HOME_SCREEN = false;

/// if [SHOW_SLIDER], then which list to put on slider
/// if [SHOW_FEATURED_PROPERTIES_ON_SLIDER], then featured properties will show otherwise latest properties
const bool SHOW_FEATURED_PROPERTIES_ON_SLIDER = true;

/// Show Reviews
bool SHOW_REVIEWS = true;

/// Places Api Related
bool LOCK_PLACES_API = false;
String PLACES_API_COUNTRIES = '';

/// Keys from touch-base
String MEASUREMENT_UNIT_TEXT = "sqft";
String MEASUREMENT_UNIT_GLOBAL = "sqft";
String ADD_PROP_GDPR_ENABLED = "1";
String DECIMAL_POINT_SEPARATOR = ".";
String THOUSAND_SEPARATOR = ",";
String CURRENCY_POSITION = "before";

/// Add Property / Update Property, Address Fields Related
bool SHOW_COUNTRY_NAME_FIELD = true;
bool SHOW_STATE_COUNTY_FIELD = true;
bool SHOW_LOCALITY_FIELD = true;
bool SHOW_NEIGHBOURHOOD_FIELD = true;

/// Add Property / Update Property, Sub-Listing Fields Related
bool SHOW_MULTI_UNITS_ID_FIELD = false;

/// Per Page items Related
const int FETCH_LATEST_PROPERTIES_PER_PAGE = 16;

/// Home Screen design Related
String HOME_SCREEN_DESIGN = DESIGN_01;

/// Api Configurations Related
const bool ENABLE_API_CONFIG = true;

/// Dev Api Configurations Related
const bool FETCH_DEV_API_CONFIG = false;

/// Show Add Property In Profile
bool SHOW_ADD_PROPERTY_IN_PROFILE = false;

/// Show Map first instead of filter page
bool SHOW_MAP_INSTEAD_FILTER = false;

/// Show/hide Property details options
bool SHOW_EMAIL_BUTTON = false;
bool SHOW_CALL_BUTTON = false;
bool SHOW_WHATSAPP_BUTTON = false;
bool SHOW_LINE_APP_BUTTON = false;
bool SHOW_TELEGRAM_BUTTON = false;
bool SHOW_PRINT_PROPERTY_BUTTON = false;
bool SHOW_DOWNLOAD_IMAGE_BUTTON = false;
bool SHOW_MESSAGES = false;
bool SHOW_MESSAGES_BUTTON = false;

/// Enable/disable the Sequential Location Picker
bool ENABLE_SEQUENTIAL_LOCATION_PICKER = true;

/// Show/hide Search Results Options
bool SHOW_GRID_VIEW_BUTTON = false;

/// Bottom Navigation Bar design Related
String BOTTOM_NAVIGATION_BAR_DESIGN = DESIGN_01;
bool SHOW_BOTTOM_NAV_BAR_ADD_BTN = false;

/// Radius Unit related
String RADIUS_UNIT = "km";

/// Use cupertino segment control
bool USE_CUPERTINO_SEGMENT_CONTROL = false;

/// Show/hide Notifications Bell widget
bool SHOW_NOTIFICATIONS = false;

/// Set Maximum property images uploads widget
String MAX_PROP_IMAGES_UPLOAD = "50";

/// Show/hide OneSignal Logs
const bool enableOneSignalLogs = false;

/// Show/hide Upload Property Logs
const bool enableUploadPropertyLogs = false;

/// Search Results Property Item Design Related
const newestKey = 'newest';
const oldestKey = 'oldest';
const priceMinKey = 'price_min';
const priceMaxKey = 'price_max';
const areaMinKey = 'area_min';
const areaMaxKey = 'area_max';

const List<String> sortByOptionsList = [
  newestKey,
  oldestKey,
  priceMinKey,
  priceMaxKey,
  areaMinKey,
  areaMaxKey,
];

List<String> homeLocationPickerHierarchyList = [
  propertyCountryDataType,
  propertyStateDataType,
  propertyCityDataType,
  propertyAreaDataType
];

List<String> filterLocationPickerHierarchyList = [
  propertyCountryDataType,
  propertyStateDataType,
  propertyCityDataType,
  propertyAreaDataType
];

String DEFAULT_SORT_BY_OPTION = sortByOptionsList[0];

String BLOGS_DESIGN = DESIGN_01;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const String ARTICLE_STATUS = 'Property Status';

/// Keys related to floor plans
const String FLOOR_PLAN_ROOMS = 'rooms';
const String FLOOR_PLAN_BATHROOMS = 'bathrooms';
const String FLOOR_PLAN_PRICE = 'price';
const String FLOOR_PLAN_SIZE = 'size';
const String FLOOR_PLAN_ICON = 'icon';
const String FLOOR_PLAN_VALUE = 'value';

/// Activities from board page keys
const String DAY = 'day';
const String WEEK = 'week';
const String MONTH = 'month';
const String SUCCESS = 'text-success';
const String DANGER = 'text-danger';
const String kReview = "review";
const String kLead = "lead";
const String kLeadContact = "lead_contact";
const String kScheduleTour = "schedule_tour";

/// Keys related to Property Details Map of Parser
const String PROPERTY_DETAILS_PROPERTY_ID = 'Property ID';
const String FIRST_PRICE = 'First Price';
const String SECOND_PRICE = 'Second Price';
const String PRICE = 'Price';
const String PROPERTY_DETAILS_PROPERTY_TYPE = 'Property Type';
const String PROPERTY_DETAILS_PROPERTY_STATUS = 'Property Status';
const String PROPERTY_DETAILS_PROPERTY_UNIQUE_ID = 'Property Unique ID';
const String PROPERTY_DETAILS_PROPERTY_SIZE = 'Property Size';
const String PROPERTY_DETAILS_PROPERTY_BEDROOMS = 'Bedrooms';
const String PROPERTY_DETAILS_PROPERTY_BATHROOMS = 'Bathrooms';
const String PROPERTY_DETAILS_PROPERTY_GARAGE = 'Garage';
const String PROPERTY_DETAILS_PROPERTY_GARAGE_SIZE = 'Garage Size';
const String PROPERTY_DETAILS_PROPERTY_YEAR_BUILT = 'Year Built';
const String PROPERTY_DETAILS_PROPERTY_LAST_UPDATED = 'Last Updated';
const String PROPERTY_DETAILS_PROPERTY_CREATED_DATE = 'Created Date';
const String PROPERTY_DETAILS_LAND_AREA = 'Land Area';

/// Keys related to Send Email to Realtor
const String SEND_EMAIL_SITE_NAME = 'siteName';
const String SEND_EMAIL_THUMBNAIL = 'thumbnail';
const String SEND_EMAIL_LISTING_ID = 'listingId';
const String SEND_EMAIL_LISTING_LINK = 'listingLink';
const String SEND_EMAIL_LISTING_NAME = 'listingName';
const String SEND_EMAIL_APP_BAR_TITLE = 'appBarTitle';
const String SEND_EMAIL_REALTOR_ID = 'agentAgencyId';
const String SEND_EMAIL_MESSAGE = 'messageContent';
const String SEND_EMAIL_REALTOR_NAME = 'agentAgencyName';
const String SEND_EMAIL_REALTOR_TYPE = 'agentAgencyType';
const String SEND_EMAIL_REALTOR_EMAIL = 'agentAgencyEmail';
const String SEND_EMAIL_UNIQUE_ID = 'uniqueId';
const String SEND_EMAIL_SOURCE = 'source';

/// Related Properties Related
const String RELATED = '-related';

/// Favourites Properties Related
const String FAVOURITES = '-favourites';

/// Single Properties Related
const String SINGLE = '-single';

/// Carousel Properties Related
const String CAROUSEL = '-carousel';

/// Filtered Properties Related
const String FILTERED = '-filtered';
const String FILTERED_GRID = '-filteredGrid';

/// Hero Related
const String HERO = 'hero';

/// App Info Related
const String APP_INFO_APP_NAME = 'appName';
const String APP_INFO_APP_PACKAGE_NAME = 'appPackageName';
const String APP_INFO_APP_VERSION = 'appVersion';
const String APP_INFO_APP_BUILD_NUMBER = 'appBuildNumber';

/// Property Status Related
const String PROPERTY_STATUS_BUY = 'Buy';
const String PROPERTY_STATUS_SALE = 'SALE';
const String PROPERTY_STATUS_RENT = 'Rent';

/// Review Related
const String REVIEW_TITLE = 'review_title';
const String REVIEW_STARS = 'review_stars';
const String REVIEW = 'review';
const String REVIEW_POST_TYPE = 'review_post_type';
const String REVIEW_LISTING_ID = 'listing_id';
const String REVIEW_LISTING_TITLE = 'listing_title';
const String REVIEW_PERMA_LINK = 'permalink';
const String REVIEW_CONTENT = 'content';
const String REVIEW_DATE = 'date';

/// Property Media Related
const String UPLOADED = 'Uploaded';
const String PENDING = 'Pending';
const String PROPERTY_MEDIA_IMAGE_ID = 'ImageId';
const String PROPERTY_MEDIA_IMAGE_NAME = 'ImageName';
const String PROPERTY_MEDIA_IMAGE_PATH = 'ImagePath';
const String PROPERTY_MEDIA_IMAGE_STATUS = 'ImageStatus';
const String PROPERTY_MEDIA_EXAMPLE_URL =
    'https://www.youtube.com/watch?v=40KtYliO_Dg';

const String ATTACHMENT_ID = 'attachment_id';
const String IMAGE_TASK_ID = 'ImageTaskId';
const String FULL_IMAGE = 'full_image';

/// User info
const String USER_EMAIL = "useremail";
const String USER_WHATSAPP = "whatsapp";
const String USER_TITLE = "title";
const String FIRST_NAME = "firstname";
const String LAST_NAME = "lastname";
const String USER_MOBILE = "usermobile";
const String USER_PHONE = "userphone";
const String DESCRIPTION = "bio";
const String USER_LANGS = "userlangs";
const String USER_COMPANY = "user_company";
const String TAX_NUMBER = "tax_number";
const String FAX_NUMBER = "fax_number";
const String USER_ADDRESS = "user_address";
const String SERVICE_AREA = "service_areas";
const String SPECIALITIES = "specialties";
const String LICENSE = "license";
const String DISPLAY_NAME = "display_name";
const String FACEBOOK = "facebook";
const String TWITTER = "twitter";
const String LINKEDIN = "linkedin";
const String INSTAGRAM = "instagram";
const String YOUTUBE = "youtube";
const String PINTEREST = "pinterest";
const String VIMEO = "vimeo";
const String SKYPE = "skype";
const String WEBSITE = "website";
const String LINE_ID = "line_id";
const String TELEGRAM = "telegram";
const String PICTURE_ID = "author_picture_id";

/// Saved search query
const String QUERY_STATUS = "Status";
const String QUERY_CITY = "City";
const String QUERY_TYPE = "Type";
const String QUERY_PRICE = "Price";
const String QUERY_AREA = "AREA";
const String QUERY_MIN_PRICE = "Min_price";
const String QUERY_MAX_PRICE = "Max_Price";
const String QUERY_BATHROOM = "Bathroom";
const String QUERY_BEDROOMS = "Bedroom";
const String TEMP_TITLE = "Temporary_Title";

/// Add new deal
const String DEAL_GROUP = "deal_group";
const String DEAL_TITLE = "deal_title";
const String DEAL_CONTACT = "deal_contact";
const String DEAL_VALUE = "deal_value";
const String DEAL_AGENT = "deal_agent";

/// Add new inquiry
const String INQUIRY_LEAD_ID = "lead_id";
const String INQUIRY_ENQUIRY_TYPE = "enquiry_type";
const String INQUIRY_PROPERTY_TYPE = "e_meta[property_type]";
const String INQUIRY_MIN_PRICE = "e_meta[min-price]";
const String INQUIRY_PRICE = "e_meta[price]";
const String INQUIRY_MIN_BEDS = "e_meta[min-beds]";
const String INQUIRY_BEDS = "e_meta[beds]";
const String INQUIRY_MIN_BATHS = "e_meta[min-baths]";
const String INQUIRY_BATHS = "e_meta[baths]";
const String INQUIRY_MIN_AREA = "e_meta[min-area]";
const String INQUIRY_AREA_SIZE = "e_meta[area-size]";
const String INQUIRY_COUNTRY = "e_meta[country]";
const String INQUIRY_STATE = "e_meta[state]";
const String INQUIRY_CITY = "e_meta[city]";
const String INQUIRY_AREA = "e_meta[area]";
const String INQUIRY_ZIP_CODE = "e_meta[zipcode]";
const String PRIVATE_NOTE = "private_note";
const String INQUIRY_MSG = "message";
const String INQUIRY_FIRST_NAME = "first_name";
const String INQUIRY_LAST_NAME = "last_name";
const String INQUIRY_EMAIL = "email";
const String INQUIRY_GDPR = "gdpr_agreement";
const String INQUIRY_MOBILE = "mobile";
const String UPDATE_INQUIRY_ID = "enquiry_id";
const String INQUIRY_ACTION = "action";
const String INQUIRY_ACTION_ADD_NEW = "crm_add_new_enquiry";

/// Deal detail
const String DEAL_DETAIL_TITLE = "title";
const String DEAL_DETAIL_ID = "dealId";
const String DEAL_DETAIL_DISPLAY_NAME = "displayName";
const String DEAL_DETAIL_AGENT_NAME = "agentName";
const String DEAL_DETAIL_ACTION_DUE_DATE = "actionDueDate";
const String DEAL_DETAIL_VALUE = "dealValue";
const String DEAL_DETAIL_EMAIL = "email";
const String DEAL_DETAIL_LAST_CONTACT_DATE = "lastContactDate";
const String DEAL_DETAIL_NEXT_ACTION = "nextAction";
const String DEAL_DETAIL_PHONE = "phone";
const String DEAL_DETAIL_STATUS = "status";
const String DEAL_AGENT_ID = "agentId";
const String DEAL_CONTACT_NAME_ID = "contactDisplayName";

/// Inquiry detail
const String INQUIRY_DETAIL_LOCATION = "location";
const String INQUIRY_DETAIL_PROPERTY_TYPE_NAME = "propertyTypeName";
const String INQUIRY_DETAIL_MIN_BATHROOMS = "minBathrooms";
const String INQUIRY_DETAIL_MAX_BATHROOMS = "maxBathrooms";
const String INQUIRY_DETAIL_MIN_BEDROOMS = "minBedrooms";
const String INQUIRY_DETAIL_MAX_BEDROOMS = "maxBedrooms";
const String INQUIRY_DETAIL_AREA_SIZE = "areaSize";
const String INQUIRY_DETAIL_DISPLAY_NAME = "displayName";
const String INQUIRY_DETAIL_MIN_PRICE = "minPrice";
const String INQUIRY_DETAIL_MAX_PRICE = "maxPrice";
const String INQUIRY_DETAIL_INQUIRY_ID = "inquiryId";
const String INQUIRY_DETAIL_MESSAGE = "message";
const String INQUIRY_DETAIL_MATCHED_ID = "matchedId";

///Agent agency search
const String SEARCH_KEYWORD = "search";
const String AGENT_SEARCH_CITY = "agent_city";
const String AGENT_SEARCH_CATEGORY = "agent_category";

/// Item Theme Design Related
const String DESIGN_01 = "design_01";
const String DESIGN_02 = "design_02";
const String DESIGN_03 = "design_03";
const String DESIGN_04 = "design_04";
const String DESIGN_05 = "design_05";
const String DESIGN_06 = "design_06";
const String DESIGN_07 = "design_07";
const String DESIGN_08 = "design_08";
const String DESIGN_09 = "design_09";
const String DESIGN_10 = "design_10";
const String DESIGN_11 = "design_11";
const String ITEM_DESIGN_FROM_HOOK = "item_design_from_hook";

const List<String> HOME_SCREEN_ITEM_DESIGN_LIST = [
  DESIGN_01,
  DESIGN_02,
  DESIGN_03,
  DESIGN_04,
  DESIGN_05,
  DESIGN_06,
  DESIGN_07,
  DESIGN_08,
];

const List<String> EXPLORE_BY_TYPE_ITEM_DESIGN_LIST = [
  DESIGN_01,
  DESIGN_02,
];

/// Explore Properties By Cities Design Related
const String EXPLORE_PROPERTIES_BY_CITIES_DESIGN = DESIGN_02;

/// Related Properties Design Related
const String RELATED_PROPERTIES_DESIGN = DESIGN_01;

/// Search Result Properties Design Related
String SEARCH_RESULTS_PROPERTIES_DESIGN = DESIGN_01;

/// Explore Properties Tag Related
const String EXPLORE_PROP_BY_CITY_TAG = "Explore Prop By City";
const String EXPLORE_PROP_BY_PROP_TYPE_TAG = "Explore Prop By Prop Type";

/// Realtors Tag Related
const String AGENTS_TAG = "Agents Tag";
const String AGENCIES_TAG = "Agencies Tag";

/// Home screen listing related
const String PROPERTY = "property";
const String REALTOR = "realtor";
const String PROPERTY_CITY = "property_city";
const String FEATURED_PROPERTY = "fave_featured";

/// Houzi Plug-in Url Related
const String HOUZI_URL_PLUG_IN = "https://github.com/AdilSoomro/houzi-rest-api";

/// Article Box Designs Related
/// AB : Article Box0
const String AB_HERO_ID = "Hero_id";
const String AB_PROPERTY_PRICE = "Property_Price";
const String AB_PROPERTY_FIRST_PRICE = "First_Price";
const String AB_PROPERTY_SECOND_PRICE = "Second_Price";
const String AB_IS_FEATURED = "isFeatured";
const String AB_TITLE = "Title";
const String AB_IMAGE_URL = "ImageUrl";
const String AB_IMAGE_PATH = "ImagePath";
const String AB_ADDRESS = "Address";
const String AB_AREA = "Area";
const String AB_AREA_POST_FIX = "Area_PostFix";
const String AB_BED_ROOMS = "BedRooms";
const String AB_BATH_ROOMS = "BathRooms";
const String AB_PROPERTY_STATUS = "Property_Status";
const String AB_PROPERTY_LABEL = "Property_Label";
const String AB_PROPERTY_TYPE = "Property_Type";

/// Dynamic Home Related
const String LATEST_PROPERTIES_TAG = "Latest_Properties_Tag";
const String FEATURED_PROPERTIES_TAG = "Featured_Properties_Tag";

/// Search Results Related
const String CHIP_GRID = "Grid";
const String CHIP_LIST = "List";
const String CHIP_MAP = "Map";
const String CHIP_FILTER = "Filter";
const String CHIP_SORT = "Sort";
const String OPTION_SAVE = "Save Search";
const String OPTION_DELETE = "Delete";
const String OPTION_EDIT = "Edit";
const String OPTION_REPORT = "Report";

/// Configurations Related
const String appNameConfiguration = "app_name";
const String wordpressUrlSchemeConfiguration = "wordpress_url_scheme";
const String wordpressUrlDomainConfiguration = "wordpress_url_domain";
const String wordpressUrlPathConfiguration = "wordpress_url_path";
const String appTermsUrlConfiguration = "app_terms_url";
const String appPrivacyUrlConfiguration = "app_privacy_url";
const String appTermsOfUseUrlConfiguration = "app_terms_of_use_url";
const String wordpressUrlGDPRAgreementConfiguration =
    "wordpress_url_gdpr_agreement";
const String companyUrlConfiguration = "company_url";
const String localeInUrl = "locale_in_url";
const String restAPIPropertiesRouteConfiguration = "rest_api_properties_route";
const String restAPIAgentRouteConfiguration = "rest_api_agent_route";
const String restAPIAgencyRouteConfiguration = "rest_api_agency_route";
const String googleMapAPIKeyConfiguration = "google_map_api_key";
const String androidNativeAdIdConfiguration = "android_native_ad_id";
const String iosNativeAdIdConfiguration = "ios_native_ad_id";
const String oneSignalAppIdConfiguration = "one_signal_app_id";
const String showNotificationConfiguration = "notification";
const String showMessagesConfiguration = "messages";
const String maxPropertyImagesConfiguration = "max_prop_images";

const String primaryColorConfiguration = "primary_color";
const String secondaryColorConfiguration = "secondary_color";
const String iconTintColorConfiguration = "icon_tint_color";
const String iconTintColorDarkModeConfiguration = "icon_tint_color_dark_mode";
const String bottomTabBarTintColorConfiguration = "bottom_tab_bar_tint_color";
const String unSelectedBottomTabBarTintColorConfiguration =
    "un_selected_bottom_tab_bar_tint_color";
const String bottomTabBarBackgroundColorLightModeConfiguration =
    "bottom_tab_bar_background_color_light";
const String bottomTabBarBackgroundColorDarkModeConfiguration =
    "bottom_tab_bar_background_color_dark";
const String sliderTintColorConfiguration = "slider_tint_color";
const String selectedItemBackgroundColorConfiguration =
    "selected_item_background_color";
const String selectedItemTextColorConfiguration = "selected_item_text_color";
const String unSelectedItemTextColorConfiguration =
    "un_selected_item_text_color";
const String unSelectedItemBackgroundColorConfiguration =
    "un_selected_item_background_color";
const String actionButtonBackgroundColorConfiguration =
    "action_button_background_color";
const String dividerColorLightConfiguration = "divider_color_light";
const String dividerColorDarkConfiguration = "divider_color_dark";
const String cupertinoSegmentThumbColorLightConfiguration = "segment_thumb_color_light";
const String cupertinoSegmentThumbColorDarkConfiguration = "segment_thumb_color_dark";

const String appBackgroundColorLightModeConfiguration =
    "app_background_color_light_mode";
const String appBackgroundColorDarkModeConfiguration =
    "app_background_color_dark_mode";
const String headingsColorLightModeConfiguration = "headings_color_light_mode";
const String headingsColorDarkModeConfiguration = "headings_color_dark_mode";
const String favouriteIconTintColorConfiguration = "favourite_icon_tint_color";
const String propertyDetailsEmailButtonBgColorConfiguration =
    "property_details_email_button_bg_color";
const String propertyDetailsCallButtonBgColorConfiguration =
    "property_details_call_button_bg_color";
const String propertyDetailsWhatsAppButtonBgColorConfiguration =
    "property_details_whatsapp_button_bg_color";
const String propertyItemDesignContainerBgColorLightModeConfiguration =
    "property_item_design_container_bg_color_light_mode";
const String propertyItemDesignContainerBgColorDarkModeConfiguration =
    "property_item_design_container_bg_color_dark_mode";

const String lineAppButtonBgColorConfiguration = "line_app_button_bg_color";
const String telegramAppButtonBgColorConfiguration = "telegram_button_bg_color";
const String messageButtonBgColorConfiguration = "message_button_bg_color";

const String filterPageHeadingsColorLightModeConfiguration = "filter_page_headings_color_light_mode";
const String filterPageHeadingsColorDarkModeConfiguration = "filter_page_headings_color_dark_mode";
const String filterPagePlaceHolderTextColorLightModeConfiguration = "filter_page_place_holder_text_color_light_mode";
const String filterPagePlaceHolderTextColorDarkModeConfiguration = "filter_page_place_holder_text_color_dark_mode";
const String filterPageIconTintColorLightModeConfiguration = "filter_page_icon_tint_color_light_mode";
const String filterPageIconTintColorDarkModeConfiguration = "filter_page_icon_tint_color_dark_mode";

const String featuredTagBackgroundColorLightModeConfiguration =
    "featured_label_background_color";
const String featuredTagBackgroundColorDarkModeConfiguration =
    "featured_tag_background_color_dark_mode";
const String featuredTagBorderColorLightModeConfiguration =
    "featured_tag_border_color_light_mode";
const String featuredTagBorderColorDarkModeConfiguration =
    "featured_tag_border_color_dark_mode";
const String featuredTagFontColorLightModeConfiguration =
    "featured_tag_font_color_light_mode";
const String featuredTagFontColorDarkModeConfiguration =
    "featured_tag_font_color_dark_mode";

const String tagBackgroundColorLightModeConfiguration = "tag_background_color";
const String tagBackgroundColorDarkModeConfiguration =
    "tag_background_color_dark_mode";
const String tagBorderColorLightModeConfiguration =
    "tag_border_color_light_mode";
const String tagBorderColorDarkModeConfiguration = "tag_border_color_dark_mode";
const String tagFontColorLightModeConfiguration = "tag_font_color_light_mode";
const String tagFontColorDarkModeConfiguration = "tag_font_color_dark_mode";

const String showSearchByCityConfiguration = "show_search_by_city";
const String showSearchByLocationConfiguration = "show_search_by_location";
const String showLoginWithFacebookConfiguration = "show_login_with_facebook";
const String showLoginWithGoogleConfiguration = "show_login_with_google";
const String showLoginWithAppleConfiguration = "show_login_with_apple";
const String showLoginWithPhoneConfiguration = "show_login_with_phone";
const String showAdsConfiguration = "show_ads";
const String showAndroidAdsConfiguration = "show_android_ads";
const String showIOSAdsConfiguration = "show_ios_ads";
const String showAddPropertyInProfileConfiguration =
    "show_add_property_in_profile";
const String showMapInsteadFilterConfiguration = "show_map_instead_filter";
const String showEmailButtonDetailPageConfiguration = "show_email_button";
const String showCallButtonDetailPageConfiguration = "show_call_button";
const String showWhatsappButtonDetailPageConfiguration = "show_whatsapp_button";
const String showPrintPropertyButtonConfig = "show_print_property_button";
const String showGridViewButtonConfig = "show_grid_view_button";
const String showDownloadImageButtonConfig = "show_download_image_button";
const String useCupertinoSegmentControlConfig = "use_cupertino_segment_control";

const String showLineAppButtonConfiguration = "show_line_app_button";
const String showTelegramButtonConfiguration = "show_telegram_button";

const String enableHtmlInDescriptionConfig = "enable_html_in_description";

const String enableHtmlInBlogDescriptionConfig = "enable_html_in_blog_description";

const String showMessageButtonConfiguration = "show_message_button";

const String selectedItemBackgroundColorDarkModeConfiguration = "selected_item_background_color_dark_mode";
const String selectedItemTextColorDarkModeConfiguration = "selected_item_text_color_dark_mode";
const String unSelectedItemTextColorDarkModeConfiguration = "un_selected_item_text_color_dark_mode";
const String unSelectedItemBackgroundColorDarkModeConfiguration = "un_selected_item_background_color_dark_mode";

const String homePageLayoutConfiguration = "home_layout";
const String bottomNavBarLayoutConfiguration = "bottom_navigation_bar_layout";
const String searchPageLayoutConfiguration = "filter_page_layout";
const String propertyDetailsPageLayoutConfiguration =
    "property_detail_page_layout";
const String drawerMenuLayoutConfiguration = "drawer_layout";
const String lockPlacesApiConfiguration = "lock_places_api";
const String lockPlacesCountriesApiConfiguration = "lock_places_api_countries";
const String addPropertyLayoutApiConfiguration = "add_property_layout";
const String quickAddPropertyLayoutApiConfiguration = "quick_add_property_layout";
const String blogDetailsPageLayoutConfiguration = "blog_detail_page_layout";

const String versionApiConfiguration = "api_config_version";
const String totalSearchTypeOptionsApiConfiguration =
    "show_total_search_type_options";
const String defaultHomeApiConfiguration = "default_home";
const String quoteApiConfiguration = "quote";
const String termsWithIconConfiguration = "terms_with_icon_layout";

const String MOBILE_APP_CONFIG_KEY = "mobile_app_config";
const String DEV_MOBILE_APP_CONFIG_KEY = "mobile_app_config_dev";

const String HOUZEZ_VERSION_KEY = "houzez_ver";

const String SIGNUP_REGISTER_MOBILE_KEY = "register_mobile";
const String SIGNUP_REGISTER_FIRST_NAME_KEY = "register_first_name";
const String SIGNUP_REGISTER_LAST_NAME_KEY = "register_last_name";
const String SIGNUP_ENABLE_PASSWORD_KEY = "enable_password";

const String SHOW_REQUEST_DEMO_KEY = "show_request_demo";
const String SHOW_THEME_RELTAED_SETTINGS_KEY = "show_theme_related_settings";
const String SHOW_ADD_PROPERTY_KEY = "show_add_property";

const String DEFAULT_BOTTOM_NAVBAR_DESIGN = "default_bottom_navbar_design";
const String SHOW_BOTTOM_NAVBAR_ADD_BUTTON_CONFIG = "show_bottom_navbar_add_button";

const String DEFAULT_RESULTS_ITEM_DESIGN_CONFIG = "default_results_item_design";
const String DEFAULT_SORT_BY_CONFIG = "default_sort_by";
const String SORT_FIRST_BY_CONFIG = "sort_first_by";


const String HOME_LOCATION_HIERARCHY_CONFIG = "home_location_hierarchy_list";

/// Floor Plans Related
const String favePlanTitle = 'fave_plan_title';
const String favePlanRooms = 'fave_plan_rooms';
const String favePlanBathrooms = 'fave_plan_bathrooms';
const String favePlanPrice = 'fave_plan_price';
const String favePlanPricePostFix = 'fave_plan_price_postfix';
const String favePlanSize = 'fave_plan_size';
const String favePlanImage = 'fave_plan_image';
const String favePlanPendingImage = 'fave_plan_pending_image';
const String favePlanDescription = 'fave_plan_description';

/// Additional Details Related
const String faveAdditionalFeatureTitle = 'fave_additional_feature_title';
const String faveAdditionalFeatureValue = 'fave_additional_feature_value';

/// Attachments Related
const String attachmentsUrl = 'url';
const String attachmentsName = 'name';
const String attachmentsSize = 'size';

/// Multi-Units Related
const String faveMUTitle = 'fave_mu_title';
const String faveMUPrice = 'fave_mu_price';
const String faveMUPricePostfix = 'fave_mu_price_postfix';
const String faveMUBeds = 'fave_mu_beds';
const String faveMUBaths = 'fave_mu_baths';
const String faveMUSize = 'fave_mu_size';
const String faveMUSizePostfix = 'fave_mu_size_postfix';
const String faveMUType = 'fave_mu_type';
const String faveMUAvailabilityDate = 'fave_mu_availability_date';

/// HomeElement Form Keys related
const String sectionTypeKey = "section_type";
const String titleKey = "title";
const String titleKeyOrig = "title_orig";
const String designKey = "layout_design";
const String subTypeKey = "sub_type";
const String subTypeValueKey = "sub_type_value";
const String subTypeValueCityKey = "sub_type_city_value";
const String sectionListingViewKey = "section_listing_view";
const String showFeaturedKey = "show_featured";
const String showNearbyKey = "show_nearby";
const String subTypeListKey = "sub_type_list";
const String subTypeValueListKey = "sub_type_value_list";
const String searchApiMapKey = "search_api_map";
const String searchRouteMapKey = "search_route_map";

const String checkLoginKey = "check_login";
const String enableKey = "enable";
const String dataMapKey = "data_map";

const String allString = "all";
const String allCapString = "All";
const String userSelectedString = "user_selected";

/// Section Type Keys related
const String allPropertyKey = "all_properties";
const String featuredPropertyKey = "featured_property";
const String propertyKey = "property";
const String termKey = "term";
const String recentSearchKey = "recent_search";
const String adKey = "ad";
const String agentsKey = "agents";
const String agenciesKey = "agencies";
const String termWithIconsTermKey = "term_with_icons";
const String partnersKey = "partners";
const String blogsKey = "blogs";
const String featuredSortItemKey = "featured";
const String messagesKey = "messages";

/// Search Section Type Keys related
const String termPickerKey = "term_picker";
const String termPickerTypeKey = "term_picker_type";
const String locationPickerKey = "location_picker";
const String rangePickerKey = "range_picker";
const String stringPickerKey = "string_picker";
const String keywordPickerKey = "keyword_picker";
const String metaKeyPickerKey = "meta_key_picker";
const String textFieldKey = "text_field";
const String customKeywordPickerKey = "custom_keyword_picker";
const String keywordCustomQueryPickerKey = "keyword_custom_query_picker";
const String switchKey = "switch";
const String checkboxKey = "checkbox";
const String sequentialLocationPickerTypeKey = "sequential_location_picker";

/// FilterConfigElement Form Keys related
const String dataTypeKey = "data_type";
const String apiValueKey = "api_value";
const String pickerTypeKey = "picker_type";
const String iconDataKey = "icon_data";
const String minRangeKey = "min_range_value";
const String maxRangeKey = "max_range_value";

/// FilterConfigElement Data Type Keys related
const String rangePickerPriceKey = "price";
const String rangePickerAreaKey = "area";
const String stringPickerBedroomsKey = "bedrooms";
const String stringPickerBathroomsKey = "bathrooms";
const String keywordPickerKeywordKey = "keyword";

/// TouchBase List Type related
const String propertyCountryDataType = "property_country";
const String propertyStateDataType = "property_state";
const String propertyCityDataType = "property_city";
const String propertyTypeDataType = "property_type";
const String propertyLabelDataType = "property_label";
const String propertyStatusDataType = "property_status";
const String propertyAreaDataType = "property_area";
const String propertyFeatureDataType = "property_feature";

/// TouchBase related keys
const String scheduleTimeSlotsKey = "schedule_time_slots";
const String defaultCurrencyKey = "default_currency";
const String userRolesKey = "user_roles";
const String allUserRolesKey = "all_user_roles";
const String propertyReviewsKey = "property_reviews";
const String customFieldsKey = "custom_fields";
const String currencyPositionKey = "currency_position";
const String thousandsSeparatorKey = "thousands_separator";
const String decimalPointSeparatorKey = "decimal_point_separator";
const String addPropGDPREnabledKey = "add-prop-gdpr-enabled";
const String measurementUnitGlobalKey = "measurement_unit_global";
const String measurementUnitTextKey = "measurement_unit_text";
const String radiusUnitKey = "radius_unit";
const String paymentEnabledStatusKey = "payment_enabled";
const String googlePlayStoreFeaturedProductIdKey = "android_featured_product_id";
const String appleAppStoreFeaturedProductIdKey = "ios_featured_product_id";
const String googlePlayStorePerListingProductIdKey = "android_per_listing_product_id";
const String appleAppStorePerListingProductIdKey = "ios_per_listing_product_id";
const String enquiryTypeKey = "enquiry_type";
const String leadPrefixKey = "lead_prefix";
const String leadSourceKey = "lead_source";
const String dealStatusKey = "deal_status";
const String dealNextActionKey = "deal_next_action";

/// Term Picker Types
const String dropDownPicker = "dropdown";
const String tabsAndChipsTermPicker = "tabs and chips";
const String fullScreenTermPicker = "full_screen";
const String boxTermPicker = "box";

/// String Picker Types
const String tabsStringPicker = "tabs";
const String chipsStringPicker = "chips";

/// Similar Properties View Types
const String similarPropertiesCarouselView = "carousel";
const String similarPropertiesListView = "list";

/// Sub-Listing Properties View Types
const String subListingPropertiesCarouselView = "carousel";
const String subListingPropertiesListView = "list";

/// Add lead keys
const String addLeadEmail = "email";
const String addLeadPrefix = "prefix";
const String addLeadFirstName = "first_name";
const String addLeadLastName = "last_name";
const String addLeadName = "name";
const String addLeadMobile = "mobile";
const String addLeadHomePhone = "home_phone";
const String addLeadWorkPhone = "work_phone";
const String addLeadUserType = "user_type";
const String addLeadAddress = "address";
const String addLeadCountry = "country";
const String addLeadCity = "city";
const String addLeadState = "state";
const String addLeadZip = "zip";
const String addLeadSource = "source";
const String addLeadFacebook = "facebook";
const String addLeadTwitter = "twitter";
const String addLeadLinkedIn = "linkedin";
const String addLeadPrivateNote = "private_note";
const String addLeadId = "lead_id";

/// AppBar Title Tags
const String filterPageTitleTag = 'filters';

/// Deep Link
String DEEP_LINK = "";

/// Search Results Related Params
const String SEARCH_RESULTS_BEDROOMS = "bedrooms";
const String SEARCH_RESULTS_BATHROOMS = "bathrooms";
const String SEARCH_RESULTS_STATUS = "status[]";
const String SEARCH_RESULTS_TYPE = "type[]";
const String SEARCH_RESULTS_LABEL = "label";
const String SEARCH_RESULTS_LOCATION = "location[]";
const String SEARCH_RESULTS_AREA = "area[]";
const String SEARCH_RESULTS_KEYWORD = "keyword";
const String SEARCH_RESULTS_COUNTRY = "country";
const String SEARCH_RESULTS_STATE = "state";
const String SEARCH_RESULTS_FEATURES = "features[]";
const String SEARCH_RESULTS_MAX_AREA = "max_area";
const String SEARCH_RESULTS_MIN_AREA = "min_area";
const String SEARCH_RESULTS_MIN_PRICE = "min_price";
const String SEARCH_RESULTS_MAX_PRICE = "max_price";
const String SEARCH_RESULTS_CURRENT_PAGE = "page";
const String SEARCH_RESULTS_PER_PAGE = "per_page";
const String SEARCH_RESULTS_BEDS_BATHS_CRITERIA = "beds_baths_criteria";
const String SEARCH_RESULTS_CUSTOM_FIELDS = "custom_fields_values";
const String SEARCH_RESULTS_FEATURED = "featured";
// const String SEARCH_RESULTS_CUSTOM_FIELDS = "custom_fields_values[]";

/// Add Property Keys related
const String ADD_PROPERTY_TYPE_NAMES_LIST = "add_property_types_names_list";
const String ADD_PROPERTY_LABEL_NAMES_LIST = "add_property_labels_names_list";
const String ADD_PROPERTY_STATUS_NAMES_LIST = "add_property_status_names_list";

const String FAVE_AUTHOR_AGENCY_ID = "fave_author_agency_id";

/// Custom Fields Related
const String CUSTOM_FIELDS_TYPE = "type";
const String CUSTOM_FIELDS_ID = "field_id";
const String CUSTOM_FIELDS_VALUES = "fvalues";
const String CUSTOM_FIELDS_LABEL = "label";
const String CUSTOM_FIELDS_PLACEHOLDER = "placeholder";

const String CUSTOM_FIELDS_TYPE_TEXT = "text";
const String CUSTOM_FIELDS_TYPE_SELECT = "select";
const String CUSTOM_FIELDS_TYPE_MULTI_SELECT = "multiselect";
const String CUSTOM_FIELDS_TYPE_NUMBER = "number";
const String CUSTOM_FIELDS_TYPE_RADIO = "radio";
const String CUSTOM_FIELDS_TYPE_CHECKBOX_LIST = "checkbox_list";
const String CUSTOM_FIELDS_TYPE_TEXT_AREA = "textarea";

const String CUSTOM_FIELDS_KEY = "custom_fields";
const String CUSTOM_FIELDS_SECTION_TYPE_TEMPLATE_KEY = "Custom Field: ";

/// Home Screen, Sliver App Bar, Search Type Related
int defaultSearchTypeSwitchOptions = 2;

/// Add agent related keys
const String agentUserName = "aa_username";
const String agentEmail = "aa_email";
const String agentFirstName = "aa_firstname";
const String agentLastName = "aa_lastname";
const String agentCategory = "agent_category";
const String agentCity = "agent_city";
const String agentPassword = "aa_password";
const String agentSendEmail = "aa_notification";
const String agencyUserId = "agency_user_id";

/// Realtor Info related keys
const String tempRealtorIdKey = "tempRealtorId";
const String tempRealtorEmailKey = "tempRealtorEmail";
const String tempRealtorThumbnailKey = "tempRealtorThumbnail";
const String tempRealtorNameKey = "tempRealtorName";
const String tempRealtorLinkKey = "tempRealtorLink";
const String tempRealtorMobileKey = "tempRealtorMobile";
const String tempRealtorWhatsAppKey = "tempRealtorWhatsApp";
const String tempRealtorPhoneKey = "tempRealtorPhone";
const String tempRealtorDisplayOption = "tempRealtorDisplayOption";
const String tempRealtorLineAppKey = "tempRealtorLineApp";
const String tempRealtorTelegramKey = "tempRealtorTelegram";

/// Modular Drawer Section Types related keys
const String homeSectionType = "home";
const String home0SectionType = "home_0";
const String home01SectionType = "home_1";
const String home02SectionType = "home_2";
const String home03SectionType = "home_3";
const String addPropertySectionType = "add_property";
const String quickAddPropertySectionType = "quick_add_property";
const String propertiesSectionType = "properties";
const String agentsSectionType = "agents";
const String agenciesSectionType = "agencies";
const String myAgentsSectionType = "my_agents";
const String requestPropertySectionType = "request_property";
const String favoritesSectionType = "favorites";
const String savedSearchesSectionType = "saved_searches";
const String activitiesSectionType = "activities";
const String inquiriesSectionType = "inquiries";
const String dealsSectionType = "deals";
const String leadsSectionType = "leads";
const String settingsSectionType = "settings";
const String requestDemoSectionType = "request_demo";
const String loginSectionType = "login";
const String logoutSectionType = "logout";
const String expansionTileSectionType = "expansionTile";
const String expansionTileChildrenSectionType = "expansion_tile_children";
const String crmDashboardSectionType = "crm_dashboard";

const String menuHomeSectionType = "home";
const String searchSectionType = "search";
const String savedSearchesAndFavouritesType = "savedSearches_favourites";
const String profileSectionType = "profile";
const String savedSectionType = "saved_searches";
const String favouritesSectionType = "favourites";

const String menuTermSectionType = "Term";
const String aboutScreenSectionType = "About_App_Screen";
const String themeSettingScreenSectionType = "App_Theme_Setting_Screen";
const String languageSettingScreenSectionType = "App_Language_Setting_Screen";
const String privacyPolicyScreenSectionType = "App_Privacy_Policy_Screen";
const String termsAndConditionsScreenSectionType =
    "App_Terms_and_Conditions_Screen";
const String webUrlSectionType = "web_url";

// const String FILTER_SCREEN_ROUTE_TAG = "Filter_Screen";
// const String SEARCH_SCREEN_ROUTE_TAG = "Search_Screen";
// const String ABOUT_SCREEN_ROUTE_TAG = "About_Screen";
// const String THEME_SETTING_SCREEN_ROUTE_TAG = "Theme_Setting_Screen";
// const String LANGUAGE_SETTING_SCREEN_ROUTE_TAG = "Language_Setting_Screen";
// const String PRIVACY_POLICY_SCREEN_ROUTE_TAG = "Privacy_Policy_Screen";
// const String TERMS_AND_CONDITIONS_SCREEN_ROUTE_TAG = "Terms_and_Conditions_Screen";
// const String FILTER_PAGE_SCREEN_DATA_MAP_KEY = "FilterPageDataMap";
// const String SEARCH_PAGE_SCREEN_DATA_INIT_MAP_KEY = "SearchPageDataInitMap";
// const String SEARCH_PAGE_SCREEN_RELATED_DATA_MAP_KEY = "SearchPageRelatedDataMap";

/// Modular Property Profile related
const String IMAGES_PROPERTY_PROFILE = "article_images";
const String TITLE_PROPERTY_PROFILE = "article_title";
const String ADDRESS_PROPERTY_PROFILE = "article_address";
const String STATUS_AND_PRICE_PROPERTY_PROFILE = "article_status_price";
const String ADS_PROPERTY_PROFILE = "ad";
const String VALUED_FEATURES_PROPERTY_PROFILE = "valued_features";
const String FEATURES_DETAILS_PROPERTY_PROFILE = "article_features_details";
const String FEATURES_PROPERTY_PROFILE = "article_features";
const String DESCRIPTION_PROPERTY_PROFILE = "article_description";
const String ATTACHMENT_PROPERTY_PROFILE = "article_attachments";
const String ADDRESS_INFO_PROPERTY_PROFILE = "article_address_info";
const String MAP_PROPERTY_PROFILE = "article_map";
const String FLOOR_PLANS_PROPERTY_PROFILE = "article_floor_plans";
const String MULTI_UNITS_PROPERTY_PROFILE = "article_multi_units";
const String CONTACT_INFORMATION_PROPERTY_PROFILE =
    "article_contact_information";
const String BUTTON_GRID_PROPERTY_PROFILE = "button_grid";
const String ENQUIRE_INFO_PROPERTY_PROFILE = "enquire_info";
const String SETUP_TOUR_PROPERTY_PROFILE = "setup_tour";
const String WATCH_VIDEO_PROPERTY_PROFILE = "watch_video";
const String VIRTUAL_TOUR_PROPERTY_PROFILE = "virtual_tour";
const String REVIEWS_PROPERTY_PROFILE = "article_reviews";
const String RELATED_POSTS_PROPERTY_PROFILE = "article_related_posts";

const WIDGET_TYPE_PROPERTY_PROFILE = "widget_type";
const WIDGET_TITLE_PROPERTY_PROFILE = "widget_title";
const WIDGET_ENABLED_PROPERTY_PROFILE = "widget_enable";
const WIDGET_VIEW_TYPE_PROPERTY_PROFILE = "widget_view_type";

const PLACE_HOLDER_SECTION_TYPE = "place_holder";

/// Listing views related
const String CAROUSEL_VIEW = "carousel";
const String LIST_VIEW = "list";
const String SLIDER_VIEW = "slider";

/// Home Screen Properties View Types
const String homeScreenWidgetsListingCarouselView = CAROUSEL_VIEW;
const String homeScreenWidgetsListingListView = LIST_VIEW;
const String homeScreenWidgetsListingSliderView = SLIDER_VIEW;

/// Search Page Chips related
const FEATURED_CHIP_KEY = "featured_chip_key";
const FEATURED_CHIP_VALUE = "Featured";

/// Realtor Information Page / Search Page Related Keys
const REALTOR_SEARCH_TYPE = "realtor_type";
const REALTOR_SEARCH_ID = "realtor_id";
const REALTOR_SEARCH_NAME = "realtor_name";

const REALTOR_SEARCH_TYPE_AGENT = "agent";
const REALTOR_SEARCH_TYPE_AGENCY = "agency";
const REALTOR_SEARCH_TYPE_AUTHOR = "author";

const REALTOR_SEARCH_PAGE = "page";
const REALTOR_SEARCH_PER_PAGE = "per_page";
const REALTOR_SEARCH_AGENT = "fave_agents";
const REALTOR_SEARCH_AGENCY = "fave_property_agency";

const REALTOR_CHIP_KEY = "realtor_chip_key";

/// Locale in url related
const changeUrlQueryParameter = "Language name as parameter";
const changeUrlPath = "Language name as directory";
const doNotChangeUrl = "Do not change url";
const defaultLangOnUrlAndSecondaryLangAsDirectory = "default_lang_on_default_url_and_secondary_lang_as_directory";
String currentSelectedLocaleUrlPosition = doNotChangeUrl;

/// All Terms related
const List<String> allTermsList = [
  propertyTypeDataType,
  propertyCityDataType,
  propertyStatusDataType,
  propertyLabelDataType,
  propertyAreaDataType,
  propertyFeatureDataType,
  propertyStateDataType,
  propertyCountryDataType,
];

const List<String> chipsRelatedList = [
  propertyTypeDataType,
  propertyCityDataType,
  propertyStatusDataType,
  propertyLabelDataType,
  propertyFeatureDataType
];

const List<String> locationRelatedList = [
  CITY,
  propertyCityDataType,
  propertyAreaDataType,
  propertyStateDataType,
  propertyCountryDataType,
];

/// Generic Page Router Related
const String FILTER_SCREEN_ROUTE_TAG = "Filter_Screen";
const String SEARCH_SCREEN_ROUTE_TAG = "Search_Screen";
const String ABOUT_SCREEN_ROUTE_TAG = "About_Screen";
const String THEME_SETTING_SCREEN_ROUTE_TAG = "Theme_Setting_Screen";
const String LANGUAGE_SETTING_SCREEN_ROUTE_TAG = "Language_Setting_Screen";
const String PRIVACY_POLICY_SCREEN_ROUTE_TAG = "Privacy_Policy_Screen";
const String TERMS_AND_CONDITIONS_SCREEN_ROUTE_TAG =
    "Terms_and_Conditions_Screen";
const String FILTER_PAGE_SCREEN_DATA_MAP_KEY = "FilterPageDataMap";

/// Dynamic Drawer Related
const String SEARCH_LIST_TYPE_KEY = "searchPageScreenListTypeDataList";
const String SEARCH_SUB_LIST_TYPE_KEY = "searchPageScreenListTypeValueDataList";
const String webUrlDataMapKey = "web_url_key";

/// CRM notes related
const String NOTE = "note";
const String BELONG_TO = "belong_to";
const String NOTE_TYPE = "note_type";
const String ENQUIRY = "enquiry";
const String LEAD = "lead";
const String NOTE_ID = "note_id";
const String FETCH_INQUIRY = "inquiry";
const String FETCH_LEAD = "leads";

/// CRM email related
const String IDS = "ids";
const String EMAIL_TO = "email_to";

/// Item / Explore Terms Theme related
const String ITEM_THEME_DESIGN = "itemThemeDesign";
const String EXPLORE_BY_TYPE_ITEM_THEME_DESIGN = "exploreByTypeItemThemeDesign";

/// CRM details fetch related
const String FETCH_INQUIRY_MATCHING = "inquiryMatching";
const String FETCH_LEAD_INQUIRY = "leadInquiry";
const String FETCH_LEAD_VIEWED = "leadViewed";
const String FETCH_LEAD_DETAIL = "leadDetail";
const String FETCH_REVIEWS = "reviews";

/// Update deal data related
const String DEAL_SET_NEXT_ACTION = "crm_set_deal_next_action";
const String DEAL_SET_STATUS = "crm_set_deal_status";
const String DEAL_SET_ACTION_DUE_DATE = "crm_set_action_due";
const String DEAL_SET_LAST_CONTACT_DATE = "crm_set_last_contact_date";
const String DEAL_UPDATE_ID = "deal_id";
const String DEAL_UPDATE_PURPOSE = "purpose";
const String DEAL_UPDATE_DATA = "deal_data";
const String ACTION_DUE_TYPE = "actionDue";
const String LAST_CONTACT_TYPE = "lastContact";

/// Nonce related
///
const String kCreateNonceKey = "nonce_name";

///
///
const String kContactRealtorNonceName = "contact_realtor_nonce";
const String kContactRealtorNonceVariable = "contact_realtor_ajax";

const String kAddAgentNonceName = "houzez_agency_agent_ajax_nonce";
const String kAddAgentNonceVariable = "houzez-security-agency-agent";

const String kEditAgentNonceName = "houzez_agency_agent_ajax_nonce";
const String kEditAgentNonceVariable = "houzez-security-agency-agent";

const String kDeleteAgentNonceName = "agent_delete_nonce";
const String kDeleteAgentNonceVariable = "agent_delete_security";

const String kScheduleTourNonceName = "schedule-contact-form-nonce";
const String kScheduleTourNonceVariable = "schedule_contact_form_ajax";

const String kContactPropertyAgentNonceName = "property_agent_contact_nonce";
const String kContactPropertyAgentNonceVariable =
    "property_agent_contact_security";

const String kDealDeleteNonceName = "delete_deal_nonce"; // need
const String kDealDeleteNonceVariable = "security";

const String kLeadDeleteNonceName = "delete_lead_nonce"; // need
const String kLeadDeleteNonceVariable = "security";

const String kAddNoteNonceName = "note_add_nonce"; // need
const String kAddNoteNonceVariable = "security";

const String kAddPropertyNonceName = "add_property_nonce";
const String kAddPropertyNonceVariable = "verify_add_prop_nonce";

const String kUpdatePropertyNonceName = "add_property_nonce";
const String kUpdatePropertyNonceVariable = "verify_add_prop_nonce";

const String kAddImageNonceName = "verify_gallery_nonce";
const String kAddImageNonceVariable = "verify_nonce";

const String kDeleteImageNonceName = "verify_gallery_nonce";
const String kDeleteImageNonceVariable = "removeNonce";

const String kAddReviewNonceName = "review-nonce";
const String kAddReviewNonceVariable = "review-security";

const String kReportContentNonceName = "report-nonce";
const String kReportContentNonceVariable = "report-security";

const String kSaveSearchNonceName = "houzez-save-search-nounce";
const String kSaveSearchNonceVariable = "houzez_save_search_ajax";

const String kSignUpNonceName = "houzez_register_nonce";
const String kSignUpNonceVariable = "houzez_register_security";

const String kResetPasswordNonceName = "fave_resetpassword_nonce";
const String kResetPasswordNonceVariable = "security";

const String kUpdatePasswordNonceName = "houzez_pass_ajax_nonce";
const String kUpdatePasswordNonceVariable = "houzez-security-pass";

const String kUpdateProfileNonceName = "houzez_profile_ajax_nonce";
const String kUpdateProfileNonceVariable = "houzez-security-profile";

const String kUpdateProfileImageNonceName = "houzez_upload_nonce";
const String kUpdateProfileImageNonceVariable = "verify_nonce";

const String kSignInNonceName = "login_nonce";
const String kSignInNonceVariable = "login_security";

const String kAddCommentNonceName = "comment_nonce";
const String kAddCommentNonceVariable = "comment-security";

/// Messages related
const String kStartMessageThreadNonceName = "property_agent_contact_nonce";
const String kStartMessageThreadVariable = "start_thread_form_ajax";

const String kSendMessageNonceName = "start-thread-message-form-nonce";
const String kSendMessageVariable = "start_thread_message_form_ajax";

/// Filter Page related
const double kFilterPageBottomActionBarHeight = 60.0;

/// API listing related
const String PAGE_KEY = "page";
const String PER_PAGE_KEY = "per_page";
const int PER_PAGE_VALUE = 16;

/// Houzi Form ELement Types Related
const String formTextField = "formTextField";
const String formStepperField = "formStepperField";
const String formMultiSelectField = "formMultiSelectField";
const String formDropDownField = "formDropDownField";
const String formGDPRAgreementField = "formGDPRAgreementField";
const String formMediaField = "formMediaField";
const String formAdditionalDetailsField = "formAdditionalDetailsField";
const String formCustomField = "formCustomField";
const String formMapField = "formMapField";
const String formCheckBoxListField = "formCheckBoxListField";
const String formRadioButtonField = "formRadioButtonField";
const String floorPlansField = "floorPlansField";
const String multiUnitsField = "multiUnitsField";
const String multiUnitsIdsField = "multiUnitsIdsField";
const String realtorContactInformationField = "realtorContactInformationField";
const String formPricePlaceHolderField = "formPricePlaceHolderField";

/// Form Validation Types Related
const String stringValidation = "stringValidation";
const String emailValidation = "emailValidation";
const String passwordValidation = "passwordValidation";
const String phoneNumberValidation = "phoneNumberValidation";
const String userNameValidation = "userNameValidation";

/// Form Keyboard Types Related
const String textKeyboardType = "text";
const String numberKeyboardType = "number";
const String urlKeyboardType = "url";
const String emailKeyboardType = "email";
const String multilineKeyboardType = "multiline";

/// Term Checkbox List Related
/// (Comparison on the basis of)
const String TERM_ID = "term_id";
const String TERM_NAME = "term_Name";
const String TERM_SLUG = "term_slug";

/// Search Section Meta Key Picker Data-Type Keys related
const String favPropertyPriceKey = "fave_property_price";
const String favPropertySizeKey = "fave_property_size";
const String favPropertyBedroomsKey = "fave_property_bedrooms";
const String favPropertyBathroomsKey = "fave_property_bathrooms";
const String favPropertyGarageKey = "fave_property_garage";
const String favPropertyYearKey = "fave_property_year";

const metaKeyFiltersKey = "meta_key_filters";
const metaApiKey = "apiKey";
const metaValueKey = "value";
const metaPickerTypeKey = "pickerType";
const metaMinValueKey = "min_range_value";
const metaMaxValueKey = "max_range_value";
const metaOptionsKey = "options";

const keywordFiltersKey = "keyword_filters";
const keywordFiltersValueKey = "value";
const keywordFiltersQueryTypeKey = "query_type";
const keywordFiltersUniqueIdKey = "unique_id";
const keywordFiltersCustomQueryTitleKey = "query_title";

/// Range Slider related
const String rangeSliderMinValue = "0";
const String rangeSliderMaxValue = "1000000";
const String rangeSliderDivisions = "1000";

/// Save Search related Keys
const String SAVE_SEARCH_BEDROOMS = "bedrooms";
const String SAVE_SEARCH_BATHROOMS = "bathrooms";
const String SAVE_SEARCH_MIN_AREA = "min-area";
const String SAVE_SEARCH_MAX_AREA = "max-area";
const String SAVE_SEARCH_MIN_PRICE = "min-price";
const String SAVE_SEARCH_MAX_PRICE = "max-price";
const String SAVE_SEARCH_GARAGE = "garage";
const String SAVE_SEARCH_YAER_BUILT = "year-built";

/// Dynamic Keyword Related
const String KEYWORD_PREFIX = "keyword-";
const String KEYWORD_DEFAULT_KEY = "keyword-text-field";
const String KEYWORD_DEFAULT_QUERY_TYPE = "OR";

/// Text Copy Related
const String TEXT_COPIED_STRING = "Text Copied!";

/// Download Manager Related
const String DOWNLOAD_STATUS_RUNNING = "Running";
const String DOWNLOAD_STATUS_FAILED = "Failed";
const String DOWNLOAD_STATUS_PAUSED = "Paused";
const String DOWNLOAD_STATUS_SUCCESSFUL = "Successful";
const String DOWNLOAD_STATUS_PENDING = "Pending";

/// Platforms Related
const String PLATFORM_GOOGLE_MAPS = "Google_MAPS";
const String PLATFORM_APPLE_MAPS = "APPLE_MAPS";

/// User payment status related
const String enablePaidSubmissionKey = "enable_paid_submission";
const String remainingListingKey = "remaining_listings";
const String featuredRemainingListingKey = "featured_remaining_listings";
const String paymentPageKey = "payment_page";
const String userHasMembershipKey = "user_has_membership";

const String freePaidListing = "free_paid_listing";
const String perListing = "per_listing";
const String membership = "membership";
const String freeListing = "no";
String TOUCH_BASE_PAYMENT_ENABLED_STATUS = "no";
String MAKE_FEATURED_ANDROID_PRODUCT_ID = "make_featured";
String MAKE_FEATURED_IOS_PRODUCT_ID = "make_property_featured";
String PER_LISTING_ANDROID_PRODUCT_ID = "per_listing";
String PER_LISTING_IOS_PRODUCT_ID = "per_listing";

/// API Types
const int GET = 0;
const int POST = 1;
const int PUT = 2;
const int DELETE = 3;
const String DUMMY_ICON_JSON = "{\"name\":\"blur_on\",\"fontFamily\":\"MaterialIcons\",\"codePoint\":57581}";

/// Comments Related
const String COMMENT_CONTENT = 'comment_content';
const String COMMENT_POST_ID = 'comment_post_ID';
const String COMMENT_IS_UPDATE = 'is_update';
const String COMMENT_ID = 'comment_ID';
const String COMMENT_PARENT_ID = 'comment_parent';
const String COMMENT_AUTHOR_EMAIL = 'comment_author_email';
const String COMMENT_AUTHOR_NAME = 'comment_author';

/// Blog Details Page Layout related
const String BLOG_IMAGE = "blog_images";
const String BLOG_TITLE = "blog_title";
const String BLOG_CATEGORY = "blog_category";
const String BLOG_AUTHOR_AND_TIME = "blog_author_and_time";
const String BLOG_CONTENT = "blog_content";
const String BLOG_COMMENTS = "blog_comments";

/// Notification Related
const String NOTIFICATION_ID_KEY = "notificationId";
const String NOTIFICATION_USER_EMAIL_KEY = "notificationUserEmail";