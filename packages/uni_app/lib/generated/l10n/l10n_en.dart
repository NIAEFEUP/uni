// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get exit_confirm => 'Do you really want to exit?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get about => 'About us';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get academic_services => 'Academic services';

  @override
  String get accept => 'Accept';

  @override
  String get account_card_title => 'Checking account';

  @override
  String get add => 'Add';

  @override
  String get add_quota => 'Add quota';

  @override
  String get add_widget => 'Add widget';

  @override
  String get add_restaurants => 'Add restaurants';

  @override
  String get agree_terms => 'By entering you agree with these';

  @override
  String get all_widgets_added =>
      'All available widgets have already been added to your personal area!';

  @override
  String get at_least_one_college => 'Select at least one college';

  @override
  String get available_amount => 'Available amount';

  @override
  String get average => 'Average';

  @override
  String get banner_info =>
      'We collect anonymous usage data to help improve your experience. You can opt out anytime in the settings.';

  @override
  String get balance => 'Balance';

  @override
  String get bibliography => 'Bibliography';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get bs_description =>
      'Did you find any bugs in the application?\nDo you have any suggestions for the app?\nTell us so we can improve!';

  @override
  String get bug_description => 'Bug found, how to reproduce it, etc.';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get change => 'Change';

  @override
  String get change_password => 'Change password';

  @override
  String get change_prompt => 'Do you want to change the password?';

  @override
  String get check_internet => 'Check your internet connection';

  @override
  String get course_class => 'Classes';

  @override
  String get class_registration => 'Class Registration';

  @override
  String get college => 'College: ';

  @override
  String get college_select => 'select your college(s)';

  @override
  String get conclude => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get consent =>
      'I consent to this information being reviewed by NIAEFEUP and may be deleted at my request.';

  @override
  String get contact => 'Contact (optional)';

  @override
  String get contacts => 'Contacts';

  @override
  String get copy_center => 'Copy center';

  @override
  String get copy_center_building => 'Floor -1 of building B | AEFEUP building';

  @override
  String get course_info => 'Info';

  @override
  String get current_state => 'Current state: ';

  @override
  String get current_year => 'Current academic year: ';

  @override
  String get decrement => 'Decrement 1,00€';

  @override
  String get description => 'Description';

  @override
  String get desired_email => 'Email where you want to be contacted';

  @override
  String get dinner => 'Dinner';

  @override
  String get dona_bia => 'D. Beatriz\'s stationery store';

  @override
  String get dona_bia_building => 'Floor -1 of building B (B-142)';

  @override
  String get dont_show_again => 'Don\'t show again';

  @override
  String get ects => 'ECTS performed: ';

  @override
  String get edit_off => 'Edit';

  @override
  String get edit_on => 'Finish editing';

  @override
  String get empty_text => 'Please fill in this field';

  @override
  String get evaluation => 'Evaluation';

  @override
  String get frequency => 'Eligibility for exams';

  @override
  String get exams_filter => 'Exams Filter Settings';

  @override
  String get expired_password => 'Your password has expired';

  @override
  String get failed_login => 'Login failed';

  @override
  String get fee_date => 'Deadline';

  @override
  String get fee_notification => 'Fee deadline';

  @override
  String get feedback_description =>
      'Report an issue or suggest an improvement';

  @override
  String get first_year_registration => 'Year of first registration: ';

  @override
  String get floor => 'Floor';

  @override
  String get floors => 'Floors';

  @override
  String get forgot_password => 'Forgot password?';

  @override
  String get generate_reference => 'Generate reference';

  @override
  String get geral_registration => 'General Registration';

  @override
  String get improvement_registration => 'Enrollment for Improvement';

  @override
  String get increment => 'Increment 1,00€';

  @override
  String get invalid_credentials => 'Invalid credentials';

  @override
  String get keep_login => 'Remember me';

  @override
  String last_refresh_time(Object time) {
    return 'last refresh at $time';
  }

  @override
  String last_timestamp(num time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'Refreshed $time minutes ago',
      one: 'Refreshed $time minute ago',
      zero: 'Refreshed $time minutes ago',
    );
    return '$_temp0';
  }

  @override
  String get leave_feedback => 'Leave feedback';

  @override
  String get library_occupation => 'Library Occupation';

  @override
  String get lunch => 'Lunch';

  @override
  String get download_error => 'Error downloading the file';

  @override
  String get loading_terms => 'Loading Terms and Conditions...';

  @override
  String get login => 'Login';

  @override
  String get settings => 'Settings';

  @override
  String get snackbar => 'Snackbar';

  @override
  String get logout => 'Log out';

  @override
  String get menus => 'Menus';

  @override
  String get min_value_reference => 'Minimum value: 1,00 €';

  @override
  String get multimedia_center => 'Multimedia center';

  @override
  String nav_title(String title) {
    String _temp0 = intl.Intl.selectLogic(title, {
      'horario': 'Schedule',
      'exames': 'Exams',
      'area': 'Personal Area',
      'cadeiras': 'Course Units',
      'locais': 'Places',
      'restaurantes': 'Restaurants',
      'calendario': 'Calendar',
      'biblioteca': 'Library',
      'percurso_academico': 'Academic Path',
      'mapa': 'Map',
      'faculdade': 'Faculty',
      'bug_report': 'Leave Feedback',
      'conta_corrente': 'Current Account',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get news => 'News';

  @override
  String get no_class => 'There are no classes to display';

  @override
  String get no_classes_this_week => 'You have no classes this week';

  @override
  String get no_classes => 'No classes to present';

  @override
  String get no_news => 'No news to display';

  @override
  String get no_classes_on => 'You don\'t have classes on';

  @override
  String get no_classes_on_weekend => 'You don\'t have classes on';

  @override
  String get no_classes_today => 'You don\'t have any more classes today.';

  @override
  String get no_college => 'no college';

  @override
  String get no_course_units => 'No course units in the selected period';

  @override
  String get no_data => 'There is no data to show at this time';

  @override
  String get no_date => 'No date';

  @override
  String get date => 'Date';

  @override
  String get no_events => 'No events found';

  @override
  String get no_exams => 'You have no exams scheduled\n';

  @override
  String get no_exams_label => 'Looks like you are on vacation!';

  @override
  String get no_files => 'There are no files attached';

  @override
  String get no_files_label => 'You have nothing to see!';

  @override
  String get no_favorite_restaurants => 'No favorite restaurants open';

  @override
  String get no_info => 'There is no information to display';

  @override
  String get no_menu_info => 'There is no information available about meals';

  @override
  String get no_places_info => 'There is no information available about places';

  @override
  String get no_menus => 'There are no meals available';

  @override
  String get no_name_course => 'Unnamed course';

  @override
  String get no_references => 'There are no references to pay';

  @override
  String get no_results => 'No match';

  @override
  String get no_selected_courses => 'There are no course units to display';

  @override
  String get no_selected_exams => 'There are no exams to present';

  @override
  String get no_print_info => 'No print balance information';

  @override
  String get no_library_info => 'No library occupation information available';

  @override
  String get occurrence_type => 'Type of occurrence';

  @override
  String get of_month => 'of';

  @override
  String get no_link => 'We couldn\'t open the link';

  @override
  String get no_internet => 'It looks like you\'re offline';

  @override
  String get no_files_found => 'No files found';

  @override
  String get no_trips => 'No trips found at the moment';

  @override
  String get other_links => 'Other links';

  @override
  String get pass_change_request =>
      'For security reasons, passwords must be changed periodically.';

  @override
  String get password => 'Password';

  @override
  String get pendent_references => 'Pending references';

  @override
  String get personal_assistance => 'Face-to-face assistance';

  @override
  String get press_again => 'Press again to exit';

  @override
  String get print => 'Print';

  @override
  String get print_balance => 'Print balance';

  @override
  String get successful_open => 'File opened successfully';

  @override
  String get permission_denied => 'Permission denied';

  @override
  String get program => 'Program';

  @override
  String get open_error => 'Error opening the file';

  @override
  String get no_app => 'No app found to open the file';

  @override
  String get load_error => 'Error loading the information';

  @override
  String get prints => 'Prints';

  @override
  String get problem_id => 'Brief identification of the problem';

  @override
  String get reference_sigarra_help =>
      'The generated reference data will appear in Sigarra, checking account.\nProfile > Checking Account';

  @override
  String get reference_success => 'Reference created successfully!';

  @override
  String get reject => 'Reject';

  @override
  String get remove => 'Delete';

  @override
  String get report_error => 'Report error';

  @override
  String get restaurant_main_page =>
      'Do you want to see your favorite restaurants in the main page?';

  @override
  String get room => 'Room';

  @override
  String get files => 'Files';

  @override
  String get school_calendar => 'School Calendar';

  @override
  String get semester => 'Semester';

  @override
  String get send => 'Send';

  @override
  String get sent_error => 'An error occurred in sending';

  @override
  String get some_error => 'Some error!';

  @override
  String get student_number => 'Student Number';

  @override
  String get success => 'Sent with success';

  @override
  String get tele_assistance => 'Telephone assistance';

  @override
  String get tele_personal_assistance =>
      'Face-to-face and telephone assistance';

  @override
  String get telephone => 'Telephone';

  @override
  String get terms => 'Terms and Conditions';

  @override
  String get terms_change => 'Changes on uni\'s Terms and Conditions';

  @override
  String get title => 'Title';

  @override
  String get uc_info => 'Open UC page';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get user_informations => 'Personal Information';

  @override
  String get valid_email => 'Please enter a valid email';

  @override
  String get widget_prompt => 'Choose a widget to add to your personal area:';

  @override
  String get year => 'Year';

  @override
  String get see_more => 'See more';

  @override
  String get search_here => 'Search here';

  @override
  String get confirm_logout =>
      'Do you really want to log out? Your local data will be deleted and you will have to log in again.';

  @override
  String get collect_usage_stats => 'Collect usage statistics';

  @override
  String get try_again => 'Try again';

  @override
  String get try_different_login => 'Having trouble signing in?';

  @override
  String get login_with_credentials => 'Login with credentials';

  @override
  String get spotted_an_error => 'Something not right?';

  @override
  String get report_bug => 'Report a bug';

  @override
  String get fail_to_authenticate => 'Failed to authenticate';

  @override
  String get wrong_credentials_exception => 'Invalid credentials';

  @override
  String get internet_status_exception => 'Check your internet connection';

  @override
  String get bug_description_visual_detail => 'Visual Detail';

  @override
  String get bug_description_error => 'Error';

  @override
  String get bug_description_Suggestion => 'Suggestion';

  @override
  String get bug_description_unexpected_behaviour => 'Unexpected Behaviour';

  @override
  String get bug_description_other => 'Other';

  @override
  String get add_photo => 'Add photo';

  @override
  String get failed_upload => 'Failed to upload';

  @override
  String get schedule => 'Schedule';

  @override
  String get instructors => 'Instructors';

  @override
  String get remaining_instructors => 'Remaining Instructors';

  @override
  String get assessments => 'Assessments';

  @override
  String get noExamsScheduled => 'No exams scheduled';

  @override
  String get noInstructors => 'No instructors assigned';

  @override
  String get courseRegent => 'Course Regent';

  @override
  String get instructor => 'Instructor';

  @override
  String get classProfessor => 'Class Professor';

  @override
  String get lectures => 'Lectures';

  @override
  String get exams => 'Exams';

  @override
  String get courses => 'Courses';

  @override
  String get all_feminine => 'All';

  @override
  String dish_type(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'all_dishes': 'All dishes',
      'meat_dishes': 'Meat dishes',
      'fish_dishes': 'Fish dishes',
      'vegetarian_dishes': 'Vegetarian dishes',
      'soups': 'Soups',
      'salads': 'Salads',
      'diet_dishes': 'Diet dishes',
      'dishes_of_the_day': 'Dishes of the Day',
      'closed': 'Closed',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get dish_types => 'Dish Types';

  @override
  String get select_all => 'Select All';

  @override
  String get favorite_filter => 'Favorites';

  @override
  String restaurant_period(String period) {
    String _temp0 = intl.Intl.selectLogic(period, {
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get no_courses => 'No courses we\'re found';

  @override
  String get no_courses_description => 'Try to refresh the page';

  @override
  String get now => 'Now';

  @override
  String get all => 'All';

  @override
  String get drag_and_drop => 'Drag and drop elements';

  @override
  String get available_elements => 'Available elements';

  @override
  String get library => 'Library';

  @override
  String get library_building => 'Building C (Library)';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get tomorrows_meals => 'Tomorrow\'s Menu';

  @override
  String get no_menu_tomorrow => 'Tomorrow\'s Menu Unavailable';

  @override
  String get calendar => 'Calendar';

  @override
  String get ucs => 'UCS';

  @override
  String get save => 'Save';

  @override
  String get location => 'Location';

  @override
  String get email => 'Email';

  @override
  String get add_to_calendar => 'Add to calendar';

  @override
  String get view_course_details => 'View course details';

  @override
  String get until => 'Until';

  @override
  String get services => 'Services';

  @override
  String get goi => 'Psychology and Guidance Service';

  @override
  String get map => 'Map';

  @override
  String get exams_intro_message => 'Stay always updated with your exams';

  @override
  String get schedule_intro_message =>
      'Keep track of your daily classes and activities';

  @override
  String get restaurants_intro_message =>
      'Discover campus dining options and menus';

  @override
  String get services_intro_message =>
      'Access various campus services at your fingertips';

  @override
  String get map_intro_message => 'Explore the campus with our interactive map';

  @override
  String get notifications_intro_message =>
      'Would you like to receive notifications regarding important updates and alerts, including fee deadlines?';

  @override
  String get nationalities => 'Nationalities';

  @override
  String get nationality => 'Nationality';

  @override
  String get identification_documents => 'Identification Documents';

  @override
  String get addresses => 'Addresses';

  @override
  String get no_info_description => 'Try to refresh the page';

  @override
  String get tomorrow => 'tomorrow:';

  @override
  String get today => 'today:';

  @override
  String get nextclasses => 'Here are your classes for ';

  @override
  String get no_course_unit_classes =>
      'No classes have been assigned to this course unit yet';

  @override
  String get no_course_unit_info =>
      'This course unit has no information available yet';

  @override
  String get unable_to_load_data => 'Unable to load data';

  @override
  String get pedagogical_surveys => 'Pedagogical Surveys';

  @override
  String get pedagogical_surveys_description =>
      'Have you already filled out the pedagogical surveys? If not, please take a moment to fill them out. Your feedback is valuable and helps us improve the quality of education at your course.';

  @override
  String get answer => 'Answer';

  @override
  String get close => 'Close';

  @override
  String get no_restaurants_available => 'There are no restaurants to display';

  @override
  String get no_restaurants_available_sublabel =>
      'Bring your lunchbox from home.';

  @override
  String get vending_machine => 'Vending Machine';

  @override
  String get coffee_machine => 'Coffee Machine';

  @override
  String get atm => 'ATM';

  @override
  String get printer => 'Printer';

  @override
  String get wc => 'WC';

  @override
  String get parking => 'Parking';

  @override
  String get shop => 'Shop';

  @override
  String get current_account => 'Current Account';

  @override
  String get current_account_description =>
      'Track your fees, due dates and payment history.';

  @override
  String get account_faculty => 'Faculty';

  @override
  String get overview => 'Overview';

  @override
  String get upcoming_due => 'Upcoming Due';

  @override
  String get transactions => 'Transactions';

  @override
  String get pending => 'Pending';

  @override
  String get tuition_fees => 'Tuition Fees';

  @override
  String get general_history => 'General History';

  @override
  String get balance_description => 'Your total outstanding balance';

  @override
  String get fee_date_description => 'Due date for your next payment';

  @override
  String get print_balance_description =>
      'Funds for university printing services';

  @override
  String get interest_on_late_payments => 'Interest on late payments';

  @override
  String get due_in => 'Due in';

  @override
  String get no_records => 'No records';

  @override
  String get no_current_account_info =>
      'Try refreshing the page or check back later.';

  @override
  String get no_pending_label => 'All caught up!';

  @override
  String get no_pending_sublabel => 'You have no pending payments.';

  @override
  String get no_history_label => 'Nothing here yet';

  @override
  String get no_history_sublabel => 'Your payment history will appear here.';

  @override
  String get no_tuition_fees_label => 'No tuition fees found';

  @override
  String get no_tuition_fees_sublabel =>
      'Your tuition fee records will appear here.';

  @override
  String get feedback_type_title_section => 'Select the type of feedback';

  @override
  String get feedback_type_description_section =>
      'Please choose the category that best describes your feedback to help us address it effectively.';

  @override
  String get feedback_description_section =>
      'Provide a clear and concise title along with a detailed description of the issue or suggestion. The more information you provide, the better we can understand and address your feedback.';

  @override
  String get feedback_privacy_section => 'Privacy and Consent';

  @override
  String get feedback_privacy_description_section =>
      'Your privacy is important to us. You consent to the collection and use of your feedback and any attached images for the purpose of improving our app. You can choose to provide your email for follow-up, but it is not required.';

  @override
  String get feedback_images_title_section => 'Attach images';

  @override
  String get feedback_images_empty_section =>
      'Attached images will appear here.';

  @override
  String get feedback_consent_title => 'Consent to data collection';

  @override
  String get edit_homepage => 'Edit';

  @override
  String get pay => 'Pay';

  @override
  String get no_records_for_filter => 'No records for this filter.';

  @override
  String get session_expired => 'Session expired';

  @override
  String get skip => 'Skip';

  @override
  String get allow => 'Allow';

  @override
  String get snacks => 'Snacks';

  @override
  String get stores => 'Stores';

  @override
  String get statistics => 'Statistics';

  @override
  String statistics_year(Object year) {
    return 'Statistics $year';
  }

  @override
  String get statistics_distribution_description =>
      'Distribution of passed, failed, and not evaluated students';

  @override
  String get statistics_not_found =>
      'No statistics were found for this year or the previous year.';

  @override
  String get approved => 'Approved';

  @override
  String get failed => 'Failed';

  @override
  String get not_evaluated => 'Not evaluated';

  @override
  String get enrolled => 'Total Enrolled';

  @override
  String get feedback_github_title_section =>
      'Want to see how the app is built? Check out our GitHub';

  @override
  String get welcome_title => 'Welcome to university!';

  @override
  String get welcome_message =>
      'The UNI team welcomes you and wishes you the best of luck on your course!';

  @override
  String settings_app_version(String version) {
    return 'You are using uni $version';
  }
}
