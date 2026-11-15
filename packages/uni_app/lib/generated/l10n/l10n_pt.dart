// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get exit_confirm => 'Tem a certeza de que pretende sair?';

  @override
  String get no => 'Não';

  @override
  String get yes => 'Sim';

  @override
  String get about => 'Sobre nós';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get notifications => 'Notificações';

  @override
  String get academic_services => 'Serviços académicos';

  @override
  String get accept => 'Aceito';

  @override
  String get account_card_title => 'Conta Corrente';

  @override
  String get add => 'Adicionar';

  @override
  String get add_quota => 'Adicionar quota';

  @override
  String get add_widget => 'Adicionar widget';

  @override
  String get add_restaurants => 'Adicione restaurantes';

  @override
  String get agree_terms => 'Ao entrares confirmas que concordas com estes';

  @override
  String get all_widgets_added =>
      'Todos os widgets disponíveis já foram adicionados à tua área pessoal!';

  @override
  String get at_least_one_college => 'Seleciona pelo menos uma faculdade';

  @override
  String get available_amount => 'Valor disponível';

  @override
  String get average => 'Média';

  @override
  String get banner_info =>
      'Recolhemos dados anónimos de utilização para ajudar a melhorar a sua experiência. Pode desativar esta opção a qualquer momento nas definições';

  @override
  String get balance => 'Saldo';

  @override
  String get bibliography => 'Bibliografia';

  @override
  String get breakfast => 'Pequeno Almoço';

  @override
  String get bs_description =>
      'Encontraste algum bug na aplicação?\nTens alguma sugestão para a app?\nConta-nos para que possamos melhorar!';

  @override
  String get bug_description => 'Bug encontrado, como o reproduzir, etc';

  @override
  String get cancel => 'Cancelar';

  @override
  String get apply => 'Aplicar';

  @override
  String get change => 'Alterar';

  @override
  String get change_password => 'Alterar palavra-passe';

  @override
  String get change_prompt => 'Deseja alterar a palavra-passe?';

  @override
  String get check_internet => 'Verifica a tua ligação à internet';

  @override
  String get course_class => 'Turmas';

  @override
  String get class_registration => 'Inscrição de Turmas';

  @override
  String get college => 'Faculdade: ';

  @override
  String get college_select => 'seleciona a(s) tua(s) faculdade(s)';

  @override
  String get conclude => 'Concluído';

  @override
  String get confirm => 'Confirmar';

  @override
  String get consent =>
      'Consinto que esta informação seja revista pelo NIAEFEUP, podendo ser eliminada a meu pedido.';

  @override
  String get contact => 'Contacto (opcional)';

  @override
  String get contacts => 'Contactos Gerais';

  @override
  String get copy_center => 'Centro de cópias';

  @override
  String get copy_center_building =>
      'Piso -1 do edifício B | Edifício da AEFEUP';

  @override
  String get course_info => 'Ficha';

  @override
  String get current_state => 'Estado atual: ';

  @override
  String get current_year => 'Ano curricular atual: ';

  @override
  String get decrement => 'Decrementar 1,00€';

  @override
  String get description => 'Descrição';

  @override
  String get desired_email => 'Email em que desejas ser contactado';

  @override
  String get dinner => 'Jantar';

  @override
  String get dona_bia => 'Papelaria D. Beatriz';

  @override
  String get dona_bia_building => 'Piso -1 do edifício B (B-142)';

  @override
  String get dont_show_again => 'Não mostrar novamente';

  @override
  String get ects => 'ECTS realizados: ';

  @override
  String get edit_off => 'Editar';

  @override
  String get edit_on => 'Concluir edição';

  @override
  String get empty_text => 'Por favor preenche este campo';

  @override
  String get evaluation => 'Avaliação';

  @override
  String get frequency => 'Obtenção de Frequência';

  @override
  String get exams_filter => 'Definições Filtro de Exames';

  @override
  String get expired_password => 'A tua palavra-passe expirou';

  @override
  String get failed_login => 'O login falhou';

  @override
  String get fee_date => 'Data limite';

  @override
  String get fee_notification => 'Data limite de propina';

  @override
  String get feedback_description =>
      'Reporta um problema ou sugere uma melhoria';

  @override
  String get first_year_registration => 'Ano da primeira inscrição: ';

  @override
  String get floor => 'Piso';

  @override
  String get floors => 'Pisos';

  @override
  String get forgot_password => 'Esqueceu a palavra-passe?';

  @override
  String get generate_reference => 'Gerar referência';

  @override
  String get geral_registration => 'Inscrição Geral';

  @override
  String get improvement_registration => 'Inscrição para Melhoria';

  @override
  String get increment => 'Incrementar 1,00€';

  @override
  String get invalid_credentials => 'Credenciais inválidas';

  @override
  String get keep_login => 'Lembre-se de mim';

  @override
  String last_refresh_time(Object time) {
    return 'última atualização às $time';
  }

  @override
  String last_timestamp(num time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'Atualizado há $time minutos',
      one: 'Atualizado há $time minuto',
      zero: 'Atualizado há $time minutos',
    );
    return '$_temp0';
  }

  @override
  String get leave_feedback => 'Feedback';

  @override
  String get library_occupation => 'Ocupação da Biblioteca';

  @override
  String get lunch => 'Almoço';

  @override
  String get download_error => 'Erro ao descarregar o ficheiro';

  @override
  String get loading_terms => 'Carregando os Termos e Condições...';

  @override
  String get login => 'Entrar';

  @override
  String get settings => 'Definições';

  @override
  String get snackbar => 'Snackbar';

  @override
  String get logout => 'Terminar sessão';

  @override
  String get menus => 'Ementas';

  @override
  String get min_value_reference => 'Valor mínimo: 1,00 €';

  @override
  String get multimedia_center => 'Centro de multimédia';

  @override
  String nav_title(String title) {
    String _temp0 = intl.Intl.selectLogic(title, {
      'horario': 'Horário',
      'exames': 'Exames',
      'area': 'Área Pessoal',
      'cadeiras': 'Cadeiras',
      'locais': 'Locais',
      'restaurantes': 'Restaurantes',
      'calendario': 'Calendário',
      'biblioteca': 'Biblioteca',
      'percurso_academico': 'Percurso Académico',
      'mapa': 'Mapa',
      'faculdade': 'Faculdade',
      'bug_report': 'Feedback',
      'conta_corrente': 'Conta Corrente',
      'other': 'Outros',
    });
    return '$_temp0';
  }

  @override
  String get news => 'Notícias';

  @override
  String get no_class => 'Não existem turmas para apresentar';

  @override
  String get no_classes_this_week => 'Não tens aulas esta semana';

  @override
  String get no_classes => 'Não existem aulas para apresentar';

  @override
  String get no_news => 'Não há notícias para apresentar';

  @override
  String get no_classes_on => 'Não possui aulas à';

  @override
  String get no_classes_on_weekend => 'Não possui aulas ao';

  @override
  String get no_classes_today => 'Não tens mais aulas hoje.';

  @override
  String get no_college => 'sem faculdade';

  @override
  String get no_course_units => 'Sem cadeiras no período selecionado';

  @override
  String get no_data => 'Não há dados a mostrar neste momento';

  @override
  String get no_date => 'Sem data';

  @override
  String get date => 'Data';

  @override
  String get no_events => 'Nenhum evento encontrado';

  @override
  String get no_exams => 'Não possui exames marcados';

  @override
  String get no_exams_label => 'Parece que estás de férias!';

  @override
  String get no_files => 'Não possui ficheiros anexados';

  @override
  String get no_files_label => 'Não tens nada para ver!';

  @override
  String get no_favorite_restaurants => 'Sem restaurantes favoritos abertos';

  @override
  String get no_info => 'Não existem informações para apresentar';

  @override
  String get no_menu_info => 'Não há informação disponível sobre refeições';

  @override
  String get no_places_info => 'Não há informação disponível sobre locais';

  @override
  String get no_menus => 'Não há refeições disponíveis';

  @override
  String get no_name_course => 'Curso sem nome';

  @override
  String get no_references => 'Não existem referências a pagar';

  @override
  String get no_results => 'Sem resultados';

  @override
  String get no_selected_courses => 'Não existem cadeiras para apresentar';

  @override
  String get no_selected_exams => 'Não existem exames para apresentar';

  @override
  String get no_print_info => 'Sem informação de saldo';

  @override
  String get no_library_info => 'Sem informação de ocupação';

  @override
  String get occurrence_type => 'Tipo de ocorrência';

  @override
  String get of_month => 'de';

  @override
  String get no_link => 'Não conseguimos abrir o link';

  @override
  String get no_internet => 'Parece que estás offline';

  @override
  String get no_files_found => 'Nenhum ficheiro encontrado';

  @override
  String get no_trips => 'Não há viagens planeadas de momento';

  @override
  String get other_links => 'Outros links';

  @override
  String get pass_change_request =>
      'Por razões de segurança, as palavras-passe têm de ser alteradas periodicamente.';

  @override
  String get password => 'Palavra-passe';

  @override
  String get pendent_references => 'Referências pendentes';

  @override
  String get personal_assistance => 'Atendimento presencial';

  @override
  String get press_again => 'Pressione novamente para sair';

  @override
  String get print => 'Impressão';

  @override
  String get print_balance => 'Saldo impressões';

  @override
  String get successful_open => 'Ficheiro aberto com sucesso';

  @override
  String get permission_denied => 'Sem permissão';

  @override
  String get program => 'Programa';

  @override
  String get open_error => 'Erro ao abrir o ficheiro';

  @override
  String get no_app => 'Nenhuma aplicação encontrada para abrir o ficheiro';

  @override
  String get load_error => 'Erro ao carregar a informação';

  @override
  String get prints => 'Impressões';

  @override
  String get problem_id => 'Breve identificação do problema';

  @override
  String get reference_sigarra_help =>
      'Os dados da referência gerada aparecerão no Sigarra, conta corrente. Perfil > Conta Corrente';

  @override
  String get reference_success => 'Referência criada com sucesso!';

  @override
  String get reject => 'Rejeito';

  @override
  String get remove => 'Remover';

  @override
  String get report_error => 'Reportar erro';

  @override
  String get restaurant_main_page =>
      'Queres ver os teus restaurantes favoritos na página principal?';

  @override
  String get room => 'Sala';

  @override
  String get files => 'Ficheiros';

  @override
  String get school_calendar => 'Calendário Escolar';

  @override
  String get semester => 'Semestre';

  @override
  String get send => 'Enviar';

  @override
  String get sent_error => 'Ocorreu um erro no envio';

  @override
  String get some_error => 'Algum erro!';

  @override
  String get student_number => 'Número de Estudante';

  @override
  String get success => 'Enviado com sucesso';

  @override
  String get tele_assistance => 'Atendimento telefónico';

  @override
  String get tele_personal_assistance => 'Atendimento presencial e telefónico';

  @override
  String get telephone => 'Telefone';

  @override
  String get terms => 'Termos e Condições';

  @override
  String get terms_change => 'Mudança nos Termos e Condições da uni';

  @override
  String get title => 'Título';

  @override
  String get uc_info => 'Abrir página da UC';

  @override
  String get unavailable => 'Indisponível';

  @override
  String get user_informations => 'Informações Pessoais';

  @override
  String get valid_email => 'Por favor insere um email válido';

  @override
  String get widget_prompt =>
      'Escolhe um widget para adicionares à tua área pessoal:';

  @override
  String get year => 'Ano';

  @override
  String get see_more => 'Ver mais';

  @override
  String get search_here => 'Pesquisar aqui';

  @override
  String get confirm_logout =>
      'Tens a certeza de que queres terminar sessão? Os teus dados locais serão apagados e terás de iniciar sessão novamente.';

  @override
  String get collect_usage_stats => 'Partilhar estatísticas de uso';

  @override
  String get try_again => 'Tentar de novo';

  @override
  String get try_different_login => 'Problemas ao iniciar sessão?';

  @override
  String get login_with_credentials => 'Entrar com credenciais';

  @override
  String get spotted_an_error => 'Algo não está bem?';

  @override
  String get report_bug => 'Comunicar um erro';

  @override
  String get fail_to_authenticate => 'Falha ao autenticar';

  @override
  String get wrong_credentials_exception => 'Credenciais inválidas';

  @override
  String get internet_status_exception =>
      'Verifique sua conexão com a internet';

  @override
  String get bug_description_visual_detail => 'Detalhe Visual';

  @override
  String get bug_description_error => 'Erro';

  @override
  String get bug_description_Suggestion => 'Sugestão';

  @override
  String get bug_description_unexpected_behaviour => 'Comportamento Inesperado';

  @override
  String get bug_description_other => 'Outro';

  @override
  String get add_photo => 'Adicionar foto';

  @override
  String get failed_upload => 'Falha de carregamento';

  @override
  String get schedule => 'Aulas';

  @override
  String get instructors => 'Docentes';

  @override
  String get remaining_instructors => 'Docentes Restantes';

  @override
  String get assessments => 'Avaliações';

  @override
  String get noExamsScheduled => 'Não há exames agendados';

  @override
  String get noInstructors => 'Não há docentes atribuídos';

  @override
  String get courseRegent => 'Regente da Cadeira';

  @override
  String get instructor => 'Docente';

  @override
  String get classProfessor => 'Professor da Turma';

  @override
  String get lectures => 'Aulas';

  @override
  String get exams => 'Exames';

  @override
  String get courses => 'Cursos';

  @override
  String get all_feminine => 'Todas';

  @override
  String dish_type(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'all_dishes': 'Todos os pratos',
      'meat_dishes': 'Pratos de Carne',
      'fish_dishes': 'Pratos de Peixe',
      'vegetarian_dishes': 'Pratos Vegetarianos',
      'soups': 'Sopas',
      'salads': 'Saladas',
      'diet_dishes': 'Pratos de Dieta',
      'dishes_of_the_day': 'Pratos do Dia',
      'closed': 'Encerrado',
      'other': 'Outros',
    });
    return '$_temp0';
  }

  @override
  String get dish_types => 'Tipos de Prato';

  @override
  String get select_all => 'Selecionar Todos';

  @override
  String get favorite_filter => 'Favoritos';

  @override
  String restaurant_period(String period) {
    String _temp0 = intl.Intl.selectLogic(period, {
      'lunch': 'Almoço',
      'dinner': 'Jantar',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get no_courses => 'Não foram encontrados cursos';

  @override
  String get no_courses_description => 'Tenta refrescar a página';

  @override
  String get now => 'Agora';

  @override
  String get all => 'Todos';

  @override
  String get drag_and_drop => 'Arrasta e solta os elementos';

  @override
  String get available_elements => 'Elementos disponíveis';

  @override
  String get library => 'Biblioteca';

  @override
  String get library_building => 'Edifício C (Biblioteca)';

  @override
  String get restaurants => 'Restaurantes';

  @override
  String get tomorrows_meals => 'Menu de Amanhã';

  @override
  String get no_menu_tomorrow => 'Menu de Amanhã Indisponível';

  @override
  String get calendar => 'Calendário';

  @override
  String get ucs => 'UCS';

  @override
  String get save => 'Guardar';

  @override
  String get location => 'Localização';

  @override
  String get email => 'Email';

  @override
  String get add_to_calendar => 'Adicionar ao calendário';

  @override
  String get view_course_details => 'Ver detalhes da Unidade Curricular';

  @override
  String get until => 'Até';

  @override
  String get services => 'Serviços';

  @override
  String get goi => 'Serviço de Psicologia e Orientação';

  @override
  String get map => 'Mapa';

  @override
  String get exams_intro_message =>
      'Mantém-te sempre atualizado com os teus exames';

  @override
  String get schedule_intro_message =>
      'Mantém o controlo das tuas aulas e atividades diárias';

  @override
  String get restaurants_intro_message =>
      'Descobre as opções de restauração do campus e os menus';

  @override
  String get services_intro_message =>
      'Explora os serviços académicos disponíveis para ti';

  @override
  String get map_intro_message =>
      'Navega pelo campus com o nosso mapa interativo';

  @override
  String get notifications_intro_message =>
      'Queres receber alertas de eventos e informações importantes, incluindo o prazo limite de propinas?';

  @override
  String get nationalities => 'Nacionalidades';

  @override
  String get nationality => 'Nacionalidade';

  @override
  String get identification_documents => 'Documentos de Identificação';

  @override
  String get addresses => 'Moradas';

  @override
  String get no_info_description => 'Tenta refrescar a página';

  @override
  String get tomorrow => 'amanhã:';

  @override
  String get today => 'hoje:';

  @override
  String get nextclasses => 'Aqui estão as tuas aulas para ';

  @override
  String get no_course_unit_classes =>
      'Não foram atribuídas turmas a esta unidade curricular';

  @override
  String get no_course_unit_info =>
      'Esta unidade curricular ainda não tem informação disponível';

  @override
  String get unable_to_load_data => 'Não foi possível carregar dados';

  @override
  String get pedagogical_surveys => 'Inquéritos Pedagógicos';

  @override
  String get pedagogical_surveys_description =>
      'Já preencheste os inquéritos pedagógicos? Se ainda não, por favor tira um momento para os preencher. O teu feedback é valioso e ajuda a melhorar a qualidade do ensino do teu curso.';

  @override
  String get answer => 'Responder';

  @override
  String get close => 'Fechar';

  @override
  String get no_restaurants_available =>
      'Não existem restaurantes para apresentar';

  @override
  String get no_restaurants_available_sublabel => 'Traz a tua marmita de casa.';

  @override
  String get vending_machine => 'Máquina de venda';

  @override
  String get coffee_machine => 'Máquina de café';

  @override
  String get atm => 'Caixa Multibanco';

  @override
  String get printer => 'Impressora';

  @override
  String get wc => 'Casa de banho';

  @override
  String get parking => 'Parque automóvel';

  @override
  String get shop => 'loja';

  @override
  String get current_account => 'Conta Corrente';

  @override
  String get current_account_description =>
      'Acompanha as tuas propinas, prazos e histórico de pagamentos.';

  @override
  String get account_faculty => 'Faculdade';

  @override
  String get overview => 'Visão Geral';

  @override
  String get upcoming_due => 'Próximo Vencimento';

  @override
  String get transactions => 'Transações';

  @override
  String get pending => 'Pendentes';

  @override
  String get tuition_fees => 'Propinas';

  @override
  String get general_history => 'Histórico Geral';

  @override
  String get balance_description => 'O teu saldo total em dívida';

  @override
  String get fee_date_description => 'Data limite para o próximo pagamento';

  @override
  String get print_balance_description =>
      'Saldo para serviços de impressão da UP';

  @override
  String get interest_on_late_payments => 'juros de mora';

  @override
  String get due_in => 'Vence em';

  @override
  String get no_records => 'Sem registos';

  @override
  String get no_current_account_info =>
      'Tenta atualizar a página ou volta mais tarde.';

  @override
  String get no_pending_label => 'Tudo em dia!';

  @override
  String get no_pending_sublabel => 'Não tens pagamentos pendentes.';

  @override
  String get no_history_label => 'Sem movimentos';

  @override
  String get no_history_sublabel =>
      'O teu histórico de pagamentos aparecerá aqui.';

  @override
  String get no_tuition_fees_label => 'Sem propinas encontradas';

  @override
  String get no_tuition_fees_sublabel =>
      'Os teus registos de propinas aparecerão aqui.';

  @override
  String get feedback_type_title_section => 'Seleciona o tipo de feedback';

  @override
  String get feedback_type_description_section =>
      'Escolhe a categoria que melhor descreve o teu feedback para nos ajudar a processá-lo de forma eficiente.';

  @override
  String get feedback_description_section =>
      'Fornece uma descrição detalhada do problema ou sugestão, incluindo passos para reproduzir o problema, se aplicável. Quanto mais detalhes forneceres, melhor poderemos entender e resolver a questão.';

  @override
  String get feedback_privacy_section => 'Privacidade e Consentimento';

  @override
  String get feedback_privacy_description_section =>
      'A tua privacidade é importante para nós. Concordas com a recolha e utilização do teu feedback e de quaisquer imagens anexadas para o propósito de melhorar a nossa app. Podes optar por fornecer o teu email para acompanhamento, mas não é obrigatório.';

  @override
  String get feedback_images_title_section => 'Anexar imagens';

  @override
  String get feedback_images_empty_section =>
      'As imagens anexadas aparecerão aqui.';

  @override
  String get feedback_consent_title => 'Consentimento para recolha de dados';

  @override
  String get edit_homepage => 'Editar';

  @override
  String get pay => 'Pagar';

  @override
  String get no_records_for_filter => 'Sem registos para este filtro.';

  @override
  String get session_expired => 'Sessão expirada';

  @override
  String get skip => 'Ignorar';

  @override
  String get allow => 'Permitir';

  @override
  String get snacks => 'Snacks';

  @override
  String get stores => 'Lojas';

  @override
  String get statistics => 'Estatísticas';

  @override
  String statistics_year(Object year) {
    return 'Estatísticas $year';
  }

  @override
  String get statistics_distribution_description =>
      'Distribuição de aprovados, reprovados e não avaliados';

  @override
  String get statistics_not_found =>
      'Não foram encontradas estatísticas para este ano letivo nem para o anterior.';

  @override
  String get approved => 'Aprovados';

  @override
  String get failed => 'Reprovados';

  @override
  String get not_evaluated => 'Não avaliados';

  @override
  String get enrolled => 'Total Inscritos';

  @override
  String get feedback_github_title_section =>
      'Queres ver como a app é feita? Explora o nosso GitHub';

  @override
  String get welcome_title => 'Bem-vindo à universidade!';

  @override
  String get welcome_message =>
      'A equipa da UNI dá-te as boas-vindas e deseja-te muita sorte no curso!';

  @override
  String settings_app_version(String version) {
    return 'Estás a usar a uni $version';
  }
}
