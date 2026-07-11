// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_PT locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_PT';

  static m0(type) =>
      "${Intl.select(type, {'all_dishes': 'Todos os pratos', 'meat_dishes': 'Pratos de Carne', 'fish_dishes': 'Pratos de Peixe', 'vegetarian_dishes': 'Pratos Vegetarianos', 'soups': 'Sopas', 'salads': 'Saladas', 'diet_dishes': 'Pratos de Dieta', 'dishes_of_the_day': 'Pratos do Dia', 'closed': 'Encerrado', 'other': 'Outros'})}";

  static m1(time) => "última atualização às ${time}";

  static m2(time) =>
      "${Intl.plural(time, zero: 'Atualizado há ${time} minutos', one: 'Atualizado há ${time} minuto', other: 'Atualizado há ${time} minutos')}";

  static m3(title) =>
      "${Intl.select(title, {'horario': 'Horário', 'exames': 'Exames', 'area': 'Área Pessoal', 'cadeiras': 'Cadeiras', 'autocarros': 'Autocarros', 'locais': 'Locais', 'restaurantes': 'Restaurantes', 'calendario': 'Calendário', 'biblioteca': 'Biblioteca', 'percurso_academico': 'Percurso Académico', 'mapa': 'Mapa', 'faculdade': 'Faculdade', 'bug_report': 'Feedback', 'conta_corrente': 'Conta Corrente', 'other': 'Outros'})}";

  static m4(period) =>
      "${Intl.select(period, {'lunch': 'Almoço', 'dinner': 'Jantar', 'other': 'Other'})}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Sobre nós"),
    "academic_services": MessageLookupByLibrary.simpleMessage(
      "Serviços académicos",
    ),
    "accept": MessageLookupByLibrary.simpleMessage("Aceito"),
    "account_card_title": MessageLookupByLibrary.simpleMessage(
      "Conta Corrente",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Adicionar"),
    "add_photo": MessageLookupByLibrary.simpleMessage("Adicionar foto"),
    "add_quota": MessageLookupByLibrary.simpleMessage("Adicionar quota"),
    "add_restaurants": MessageLookupByLibrary.simpleMessage(
      "Adicione restaurantes",
    ),
    "add_to_calendar": MessageLookupByLibrary.simpleMessage(
      "Adicionar ao calendário",
    ),
    "add_widget": MessageLookupByLibrary.simpleMessage("Adicionar widget"),
    "addresses": MessageLookupByLibrary.simpleMessage("Moradas"),
    "agree_terms": MessageLookupByLibrary.simpleMessage(
      "Ao entrares confirmas que concordas com estes",
    ),
    "all": MessageLookupByLibrary.simpleMessage("Todos"),
    "all_feminine": MessageLookupByLibrary.simpleMessage("Todas"),
    "all_widgets_added": MessageLookupByLibrary.simpleMessage(
      "Todos os widgets disponíveis já foram adicionados à tua área pessoal!",
    ),
    "allow": MessageLookupByLibrary.simpleMessage("Permitir"),
    "answer": MessageLookupByLibrary.simpleMessage("Responder"),
    "apply": MessageLookupByLibrary.simpleMessage("Aplicar"),
    "assessments": MessageLookupByLibrary.simpleMessage("Avaliações"),
    "at_least_one_college": MessageLookupByLibrary.simpleMessage(
      "Seleciona pelo menos uma faculdade",
    ),
    "atm": MessageLookupByLibrary.simpleMessage("Caixa Multibanco"),
    "available_amount": MessageLookupByLibrary.simpleMessage(
      "Valor disponível",
    ),
    "available_elements": MessageLookupByLibrary.simpleMessage(
      "Elementos disponíveis",
    ),
    "average": MessageLookupByLibrary.simpleMessage("Média"),
    "balance": MessageLookupByLibrary.simpleMessage("Saldo"),
    "balance_description": MessageLookupByLibrary.simpleMessage(
      "O teu saldo total em dívida",
    ),
    "banner_info": MessageLookupByLibrary.simpleMessage(
      "Recolhemos dados anónimos de utilização para ajudar a melhorar a sua experiência. Pode desativar esta opção a qualquer momento nas definições",
    ),
    "bibliography": MessageLookupByLibrary.simpleMessage("Bibliografia"),
    "breakfast": MessageLookupByLibrary.simpleMessage("Pequeno Almoço"),
    "bs_description": MessageLookupByLibrary.simpleMessage(
      "Encontraste algum bug na aplicação?\nTens alguma sugestão para a app?\nConta-nos para que possamos melhorar!",
    ),
    "bug_description": MessageLookupByLibrary.simpleMessage(
      "Bug encontrado, como o reproduzir, etc",
    ),
    "bug_description_Suggestion": MessageLookupByLibrary.simpleMessage(
      "Sugestão",
    ),
    "bug_description_error": MessageLookupByLibrary.simpleMessage("Erro"),
    "bug_description_other": MessageLookupByLibrary.simpleMessage("Outro"),
    "bug_description_unexpected_behaviour":
        MessageLookupByLibrary.simpleMessage("Comportamento Inesperado"),
    "bug_description_visual_detail": MessageLookupByLibrary.simpleMessage(
      "Detalhe Visual",
    ),
    "bus_error": MessageLookupByLibrary.simpleMessage(
      "Não foi possível obter informação",
    ),
    "bus_information": MessageLookupByLibrary.simpleMessage(
      "Seleciona os autocarros dos quais queres informação:",
    ),
    "buses_personalize": MessageLookupByLibrary.simpleMessage(
      "Configura aqui os teus autocarros",
    ),
    "buses_text": MessageLookupByLibrary.simpleMessage(
      "Os autocarros favoritos serão apresentados no widget \'Autocarros\' dos favoritos. Os restantes serão apresentados apenas na página.",
    ),
    "calendar": MessageLookupByLibrary.simpleMessage("Calendário"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "change": MessageLookupByLibrary.simpleMessage("Alterar"),
    "change_password": MessageLookupByLibrary.simpleMessage(
      "Alterar palavra-passe",
    ),
    "change_prompt": MessageLookupByLibrary.simpleMessage(
      "Deseja alterar a palavra-passe?",
    ),
    "check_internet": MessageLookupByLibrary.simpleMessage(
      "Verifica a tua ligação à internet",
    ),
    "classProfessor": MessageLookupByLibrary.simpleMessage(
      "Professor da Turma",
    ),
    "class_registration": MessageLookupByLibrary.simpleMessage(
      "Inscrição de Turmas",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Fechar"),
    "coffee_machine": MessageLookupByLibrary.simpleMessage("Máquina de café"),
    "collect_usage_stats": MessageLookupByLibrary.simpleMessage(
      "Partilhar estatísticas de uso",
    ),
    "college": MessageLookupByLibrary.simpleMessage("Faculdade: "),
    "college_select": MessageLookupByLibrary.simpleMessage(
      "seleciona a(s) tua(s) faculdade(s)",
    ),
    "conclude": MessageLookupByLibrary.simpleMessage("Concluído"),
    "configured_buses": MessageLookupByLibrary.simpleMessage(
      "Autocarros Configurados",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirm_logout": MessageLookupByLibrary.simpleMessage(
      "Tens a certeza de que queres terminar sessão? Os teus dados locais serão apagados e terás de iniciar sessão novamente.",
    ),
    "consent": MessageLookupByLibrary.simpleMessage(
      "Consinto que esta informação seja revista pelo NIAEFEUP, podendo ser eliminada a meu pedido.",
    ),
    "contact": MessageLookupByLibrary.simpleMessage("Contacto (opcional)"),
    "contacts": MessageLookupByLibrary.simpleMessage("Contactos Gerais"),
    "copy_center": MessageLookupByLibrary.simpleMessage("Centro de cópias"),
    "copy_center_building": MessageLookupByLibrary.simpleMessage(
      "Piso -1 do edifício B | Edifício da AEFEUP",
    ),
    "courseRegent": MessageLookupByLibrary.simpleMessage("Regente da Cadeira"),
    "course_class": MessageLookupByLibrary.simpleMessage("Turmas"),
    "course_info": MessageLookupByLibrary.simpleMessage("Ficha"),
    "courses": MessageLookupByLibrary.simpleMessage("Cursos"),
    "current_account": MessageLookupByLibrary.simpleMessage("Conta Corrente"),
    "current_account_description": MessageLookupByLibrary.simpleMessage(
      "Acompanha as tuas propinas, prazos e histórico de pagamentos.",
    ),
    "current_state": MessageLookupByLibrary.simpleMessage("Estado atual: "),
    "current_year": MessageLookupByLibrary.simpleMessage(
      "Ano curricular atual: ",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Data"),
    "decrement": MessageLookupByLibrary.simpleMessage("Decrementar 1,00€"),
    "description": MessageLookupByLibrary.simpleMessage("Descrição"),
    "desired_email": MessageLookupByLibrary.simpleMessage(
      "Email em que desejas ser contactado",
    ),
    "dinner": MessageLookupByLibrary.simpleMessage("Jantar"),
    "dish_type": m0,
    "dish_types": MessageLookupByLibrary.simpleMessage("Tipos de Prato"),
    "dona_bia": MessageLookupByLibrary.simpleMessage("Papelaria D. Beatriz"),
    "dona_bia_building": MessageLookupByLibrary.simpleMessage(
      "Piso -1 do edifício B (B-142)",
    ),
    "dont_show_again": MessageLookupByLibrary.simpleMessage(
      "Não mostrar novamente",
    ),
    "download_error": MessageLookupByLibrary.simpleMessage(
      "Erro ao descarregar o ficheiro",
    ),
    "drag_and_drop": MessageLookupByLibrary.simpleMessage(
      "Arrasta e solta os elementos",
    ),
    "due_in": MessageLookupByLibrary.simpleMessage("Vence em"),
    "ects": MessageLookupByLibrary.simpleMessage("ECTS realizados: "),
    "edit_homepage": MessageLookupByLibrary.simpleMessage("Editar"),
    "edit_off": MessageLookupByLibrary.simpleMessage("Editar"),
    "edit_on": MessageLookupByLibrary.simpleMessage("Concluir edição"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "empty_text": MessageLookupByLibrary.simpleMessage(
      "Por favor preenche este campo",
    ),
    "evaluation": MessageLookupByLibrary.simpleMessage("Avaliação"),
    "exams": MessageLookupByLibrary.simpleMessage("Exames"),
    "exams_filter": MessageLookupByLibrary.simpleMessage(
      "Definições Filtro de Exames",
    ),
    "exams_intro_message": MessageLookupByLibrary.simpleMessage(
      "Mantém-te sempre atualizado com os teus exames",
    ),
    "exit_confirm": MessageLookupByLibrary.simpleMessage(
      "Tem a certeza de que pretende sair?",
    ),
    "expired_password": MessageLookupByLibrary.simpleMessage(
      "A tua palavra-passe expirou",
    ),
    "fail_to_authenticate": MessageLookupByLibrary.simpleMessage(
      "Falha ao autenticar",
    ),
    "failed_login": MessageLookupByLibrary.simpleMessage("O login falhou"),
    "failed_upload": MessageLookupByLibrary.simpleMessage(
      "Falha de carregamento",
    ),
    "favorite_filter": MessageLookupByLibrary.simpleMessage("Favoritos"),
    "fee_date": MessageLookupByLibrary.simpleMessage("Data limite"),
    "fee_date_description": MessageLookupByLibrary.simpleMessage(
      "Data limite para o próximo pagamento",
    ),
    "fee_notification": MessageLookupByLibrary.simpleMessage(
      "Data limite de propina",
    ),
    "feedback_consent_title": MessageLookupByLibrary.simpleMessage(
      "Consentimento para recolha de dados",
    ),
    "feedback_description": MessageLookupByLibrary.simpleMessage(
      "Reporta um problema ou sugere uma melhoria",
    ),
    "feedback_description_section": MessageLookupByLibrary.simpleMessage(
      "Fornece uma descrição detalhada do problema ou sugestão, incluindo passos para reproduzir o problema, se aplicável. Quanto mais detalhes forneceres, melhor poderemos entender e resolver a questão.",
    ),
    "feedback_images_empty_section": MessageLookupByLibrary.simpleMessage(
      "As imagens anexadas aparecerão aqui.",
    ),
    "feedback_images_title_section": MessageLookupByLibrary.simpleMessage(
      "Anexar imagens",
    ),
    "feedback_privacy_description_section": MessageLookupByLibrary.simpleMessage(
      "A tua privacidade é importante para nós. Concordas com a recolha e utilização do teu feedback e de quaisquer imagens anexadas para o propósito de melhorar a nossa app. Podes optar por fornecer o teu email para acompanhamento, mas não é obrigatório.",
    ),
    "feedback_privacy_section": MessageLookupByLibrary.simpleMessage(
      "Privacidade e Consentimento",
    ),
    "feedback_type_description_section": MessageLookupByLibrary.simpleMessage(
      "Escolhe a categoria que melhor descreve o teu feedback para nos ajudar a processá-lo de forma eficiente.",
    ),
    "feedback_type_title_section": MessageLookupByLibrary.simpleMessage(
      "Seleciona o tipo de feedback",
    ),
    "files": MessageLookupByLibrary.simpleMessage("Ficheiros"),
    "first_year_registration": MessageLookupByLibrary.simpleMessage(
      "Ano da primeira inscrição: ",
    ),
    "floor": MessageLookupByLibrary.simpleMessage("Piso"),
    "floors": MessageLookupByLibrary.simpleMessage("Pisos"),
    "forgot_password": MessageLookupByLibrary.simpleMessage(
      "Esqueceu a palavra-passe?",
    ),
    "frequency": MessageLookupByLibrary.simpleMessage("Obtenção de Frequência"),
    "general_history": MessageLookupByLibrary.simpleMessage("Histórico Geral"),
    "generate_reference": MessageLookupByLibrary.simpleMessage(
      "Gerar referência",
    ),
    "geral_registration": MessageLookupByLibrary.simpleMessage(
      "Inscrição Geral",
    ),
    "goi": MessageLookupByLibrary.simpleMessage(
      "Gabinete de Orientação e Integração",
    ),
    "identification_documents": MessageLookupByLibrary.simpleMessage(
      "Documentos de Identificação",
    ),
    "improvement_registration": MessageLookupByLibrary.simpleMessage(
      "Inscrição para Melhoria",
    ),
    "increment": MessageLookupByLibrary.simpleMessage("Incrementar 1,00€"),
    "instructor": MessageLookupByLibrary.simpleMessage("Docente"),
    "instructors": MessageLookupByLibrary.simpleMessage("Docentes"),
    "interest_on_late_payments": MessageLookupByLibrary.simpleMessage(
      "juros de mora",
    ),
    "internet_status_exception": MessageLookupByLibrary.simpleMessage(
      "Verifique sua conexão com a internet",
    ),
    "invalid_credentials": MessageLookupByLibrary.simpleMessage(
      "Credenciais inválidas",
    ),
    "keep_login": MessageLookupByLibrary.simpleMessage("Lembre-se de mim"),
    "language": MessageLookupByLibrary.simpleMessage("Idioma"),
    "last_refresh_time": m1,
    "last_timestamp": m2,
    "leave_feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
    "lectures": MessageLookupByLibrary.simpleMessage("Aulas"),
    "library": MessageLookupByLibrary.simpleMessage("Biblioteca"),
    "library_building": MessageLookupByLibrary.simpleMessage(
      "Edifício C (Biblioteca)",
    ),
    "library_occupation": MessageLookupByLibrary.simpleMessage(
      "Ocupação da Biblioteca",
    ),
    "load_error": MessageLookupByLibrary.simpleMessage(
      "Erro ao carregar a informação",
    ),
    "loading_terms": MessageLookupByLibrary.simpleMessage(
      "Carregando os Termos e Condições...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Localização"),
    "login": MessageLookupByLibrary.simpleMessage("Entrar"),
    "login_with_credentials": MessageLookupByLibrary.simpleMessage(
      "Entrar com credenciais",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Terminar sessão"),
    "lunch": MessageLookupByLibrary.simpleMessage("Almoço"),
    "map": MessageLookupByLibrary.simpleMessage("Mapa"),
    "map_intro_message": MessageLookupByLibrary.simpleMessage(
      "Navega pelo campus com o nosso mapa interativo",
    ),
    "menus": MessageLookupByLibrary.simpleMessage("Ementas"),
    "min_value_reference": MessageLookupByLibrary.simpleMessage(
      "Valor mínimo: 1,00 €",
    ),
    "multimedia_center": MessageLookupByLibrary.simpleMessage(
      "Centro de multimédia",
    ),
    "nationalities": MessageLookupByLibrary.simpleMessage("Nacionalidades"),
    "nationality": MessageLookupByLibrary.simpleMessage("Nacionalidade"),
    "nav_title": m3,
    "news": MessageLookupByLibrary.simpleMessage("Notícias"),
    "nextclasses": MessageLookupByLibrary.simpleMessage(
      "Aqui estão as tuas aulas para ",
    ),
    "no": MessageLookupByLibrary.simpleMessage("Não"),
    "noExamsScheduled": MessageLookupByLibrary.simpleMessage(
      "Não há exames agendados",
    ),
    "noInstructors": MessageLookupByLibrary.simpleMessage(
      "Não há docentes atribuídos",
    ),
    "no_app": MessageLookupByLibrary.simpleMessage(
      "Nenhuma aplicação encontrada para abrir o ficheiro",
    ),
    "no_bus": MessageLookupByLibrary.simpleMessage(
      "Não percas nenhum autocarro!",
    ),
    "no_bus_stops": MessageLookupByLibrary.simpleMessage(
      "Não existe nenhuma paragem configurada",
    ),
    "no_class": MessageLookupByLibrary.simpleMessage(
      "Não existem turmas para apresentar",
    ),
    "no_classes": MessageLookupByLibrary.simpleMessage(
      "Não existem aulas para apresentar",
    ),
    "no_classes_on": MessageLookupByLibrary.simpleMessage("Não possui aulas à"),
    "no_classes_on_weekend": MessageLookupByLibrary.simpleMessage(
      "Não possui aulas ao",
    ),
    "no_classes_this_week": MessageLookupByLibrary.simpleMessage(
      "Não tens aulas esta semana",
    ),
    "no_classes_today": MessageLookupByLibrary.simpleMessage(
      "Não tens mais aulas hoje.",
    ),
    "no_college": MessageLookupByLibrary.simpleMessage("sem faculdade"),
    "no_course_unit_classes": MessageLookupByLibrary.simpleMessage(
      "Não foram atribuídas turmas a esta unidade curricular",
    ),
    "no_course_unit_info": MessageLookupByLibrary.simpleMessage(
      "Esta unidade curricular ainda não tem informação disponível",
    ),
    "no_course_units": MessageLookupByLibrary.simpleMessage(
      "Sem cadeiras no período selecionado",
    ),
    "no_courses": MessageLookupByLibrary.simpleMessage(
      "Não foram encontrados cursos",
    ),
    "no_courses_description": MessageLookupByLibrary.simpleMessage(
      "Tenta refrescar a página",
    ),
    "no_current_account_info": MessageLookupByLibrary.simpleMessage(
      "Tenta atualizar a página ou volta mais tarde.",
    ),
    "no_data": MessageLookupByLibrary.simpleMessage(
      "Não há dados a mostrar neste momento",
    ),
    "no_date": MessageLookupByLibrary.simpleMessage("Sem data"),
    "no_events": MessageLookupByLibrary.simpleMessage(
      "Nenhum evento encontrado",
    ),
    "no_exams": MessageLookupByLibrary.simpleMessage(
      "Não possui exames marcados",
    ),
    "no_exams_label": MessageLookupByLibrary.simpleMessage(
      "Parece que estás de férias!",
    ),
    "no_favorite_restaurants": MessageLookupByLibrary.simpleMessage(
      "Sem restaurantes favoritos abertos",
    ),
    "no_files": MessageLookupByLibrary.simpleMessage(
      "Não possui ficheiros anexados",
    ),
    "no_files_found": MessageLookupByLibrary.simpleMessage(
      "Nenhum ficheiro encontrado",
    ),
    "no_files_label": MessageLookupByLibrary.simpleMessage(
      "Não tens nada para ver!",
    ),
    "no_history_label": MessageLookupByLibrary.simpleMessage("Sem movimentos"),
    "no_history_sublabel": MessageLookupByLibrary.simpleMessage(
      "O teu histórico de pagamentos aparecerá aqui.",
    ),
    "no_info": MessageLookupByLibrary.simpleMessage(
      "Não existem informações para apresentar",
    ),
    "no_info_description": MessageLookupByLibrary.simpleMessage(
      "Tenta refrescar a página",
    ),
    "no_internet": MessageLookupByLibrary.simpleMessage(
      "Parece que estás offline",
    ),
    "no_library_info": MessageLookupByLibrary.simpleMessage(
      "Sem informação de ocupação",
    ),
    "no_link": MessageLookupByLibrary.simpleMessage(
      "Não conseguimos abrir o link",
    ),
    "no_menu_info": MessageLookupByLibrary.simpleMessage(
      "Não há informação disponível sobre refeições",
    ),
    "no_menu_tomorrow": MessageLookupByLibrary.simpleMessage(
      "Menu de Amanhã Indisponível",
    ),
    "no_menus": MessageLookupByLibrary.simpleMessage(
      "Não há refeições disponíveis",
    ),
    "no_name_course": MessageLookupByLibrary.simpleMessage("Curso sem nome"),
    "no_news": MessageLookupByLibrary.simpleMessage(
      "Não há notícias para apresentar",
    ),
    "no_pending_label": MessageLookupByLibrary.simpleMessage("Tudo em dia!"),
    "no_pending_sublabel": MessageLookupByLibrary.simpleMessage(
      "Não tens pagamentos pendentes.",
    ),
    "no_places_info": MessageLookupByLibrary.simpleMessage(
      "Não há informação disponível sobre locais",
    ),
    "no_print_info": MessageLookupByLibrary.simpleMessage(
      "Sem informação de saldo",
    ),
    "no_records": MessageLookupByLibrary.simpleMessage("Sem registos"),
    "no_records_for_filter": MessageLookupByLibrary.simpleMessage(
      "Sem registos para este filtro.",
    ),
    "no_references": MessageLookupByLibrary.simpleMessage(
      "Não existem referências a pagar",
    ),
    "no_restaurants_available": MessageLookupByLibrary.simpleMessage(
      "Não existem restaurantes para apresentar",
    ),
    "no_restaurants_available_sublabel": MessageLookupByLibrary.simpleMessage(
      "Traz a tua marmita de casa.",
    ),
    "no_results": MessageLookupByLibrary.simpleMessage("Sem resultados"),
    "no_selected_courses": MessageLookupByLibrary.simpleMessage(
      "Não existem cadeiras para apresentar",
    ),
    "no_selected_exams": MessageLookupByLibrary.simpleMessage(
      "Não existem exames para apresentar",
    ),
    "no_trips": MessageLookupByLibrary.simpleMessage(
      "Não há viagens planeadas de momento",
    ),
    "no_tuition_fees_label": MessageLookupByLibrary.simpleMessage(
      "Sem propinas encontradas",
    ),
    "no_tuition_fees_sublabel": MessageLookupByLibrary.simpleMessage(
      "Os teus registos de propinas aparecerão aqui.",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notificações"),
    "notifications_intro_message": MessageLookupByLibrary.simpleMessage(
      "Queres receber alertas de eventos e informações importantes, incluindo o prazo limite de propinas?",
    ),
    "now": MessageLookupByLibrary.simpleMessage("Agora"),
    "occurrence_type": MessageLookupByLibrary.simpleMessage(
      "Tipo de ocorrência",
    ),
    "of_month": MessageLookupByLibrary.simpleMessage("de"),
    "open_error": MessageLookupByLibrary.simpleMessage(
      "Erro ao abrir o ficheiro",
    ),
    "other_links": MessageLookupByLibrary.simpleMessage("Outros links"),
    "overview": MessageLookupByLibrary.simpleMessage("Visão Geral"),
    "parking": MessageLookupByLibrary.simpleMessage("Parque automóvel"),
    "pass_change_request": MessageLookupByLibrary.simpleMessage(
      "Por razões de segurança, as palavras-passe têm de ser alteradas periodicamente.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Palavra-passe"),
    "pay": MessageLookupByLibrary.simpleMessage("Pagar"),
    "pedagogical_surveys": MessageLookupByLibrary.simpleMessage(
      "Inquéritos Pedagógicos",
    ),
    "pedagogical_surveys_description": MessageLookupByLibrary.simpleMessage(
      "Já preencheste os inquéritos pedagógicos? Se ainda não, por favor tira um momento para os preencher. O teu feedback é valioso e ajuda a melhorar a qualidade do ensino do teu curso.",
    ),
    "pendent_references": MessageLookupByLibrary.simpleMessage(
      "Referências pendentes",
    ),
    "pending": MessageLookupByLibrary.simpleMessage("Pendentes"),
    "permission_denied": MessageLookupByLibrary.simpleMessage("Sem permissão"),
    "personal_assistance": MessageLookupByLibrary.simpleMessage(
      "Atendimento presencial",
    ),
    "press_again": MessageLookupByLibrary.simpleMessage(
      "Pressione novamente para sair",
    ),
    "print": MessageLookupByLibrary.simpleMessage("Impressão"),
    "print_balance": MessageLookupByLibrary.simpleMessage("Saldo impressões"),
    "print_balance_description": MessageLookupByLibrary.simpleMessage(
      "Saldo para serviços de impressão da UP",
    ),
    "printer": MessageLookupByLibrary.simpleMessage("Impressora"),
    "prints": MessageLookupByLibrary.simpleMessage("Impressões"),
    "problem_id": MessageLookupByLibrary.simpleMessage(
      "Breve identificação do problema",
    ),
    "program": MessageLookupByLibrary.simpleMessage("Programa"),
    "reference_sigarra_help": MessageLookupByLibrary.simpleMessage(
      "Os dados da referência gerada aparecerão no Sigarra, conta corrente. Perfil > Conta Corrente",
    ),
    "reference_success": MessageLookupByLibrary.simpleMessage(
      "Referência criada com sucesso!",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Rejeito"),
    "remaining_instructors": MessageLookupByLibrary.simpleMessage(
      "Docentes Restantes",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remover"),
    "report_bug": MessageLookupByLibrary.simpleMessage("Comunicar um erro"),
    "report_error": MessageLookupByLibrary.simpleMessage("Reportar erro"),
    "restaurant_main_page": MessageLookupByLibrary.simpleMessage(
      "Queres ver os teus restaurantes favoritos na página principal?",
    ),
    "restaurant_period": m4,
    "restaurants": MessageLookupByLibrary.simpleMessage("Restaurantes"),
    "restaurants_intro_message": MessageLookupByLibrary.simpleMessage(
      "Descobre as opções de restauração do campus e os menus",
    ),
    "room": MessageLookupByLibrary.simpleMessage("Sala"),
    "save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "schedule": MessageLookupByLibrary.simpleMessage("Aulas"),
    "schedule_intro_message": MessageLookupByLibrary.simpleMessage(
      "Mantém o controlo das tuas aulas e atividades diárias",
    ),
    "school_calendar": MessageLookupByLibrary.simpleMessage(
      "Calendário Escolar",
    ),
    "search_here": MessageLookupByLibrary.simpleMessage("Pesquisar aqui"),
    "see_more": MessageLookupByLibrary.simpleMessage("Ver mais"),
    "select_all": MessageLookupByLibrary.simpleMessage("Selecionar Todos"),
    "semester": MessageLookupByLibrary.simpleMessage("Semestre"),
    "send": MessageLookupByLibrary.simpleMessage("Enviar"),
    "sent_error": MessageLookupByLibrary.simpleMessage(
      "Ocorreu um erro no envio",
    ),
    "services": MessageLookupByLibrary.simpleMessage("Serviços"),
    "services_intro_message": MessageLookupByLibrary.simpleMessage(
      "Explora os serviços académicos disponíveis para ti",
    ),
    "session_expired": MessageLookupByLibrary.simpleMessage("Sessão expirada"),
    "settings": MessageLookupByLibrary.simpleMessage("Definições"),
    "shop": MessageLookupByLibrary.simpleMessage("loja"),
    "skip": MessageLookupByLibrary.simpleMessage("Ignorar"),
    "snackbar": MessageLookupByLibrary.simpleMessage("Snackbar"),
    "snacks": MessageLookupByLibrary.simpleMessage("Snacks"),
    "some_error": MessageLookupByLibrary.simpleMessage("Algum erro!"),
    "spotted_an_error": MessageLookupByLibrary.simpleMessage(
      "Algo não está bem?",
    ),
    "stcp_stops": MessageLookupByLibrary.simpleMessage(
      "STCP - Próximas Viagens",
    ),
    "stores": MessageLookupByLibrary.simpleMessage("Lojas"),
    "student_number": MessageLookupByLibrary.simpleMessage(
      "Número de Estudante",
    ),
    "success": MessageLookupByLibrary.simpleMessage("Enviado com sucesso"),
    "successful_open": MessageLookupByLibrary.simpleMessage(
      "Ficheiro aberto com sucesso",
    ),
    "tele_assistance": MessageLookupByLibrary.simpleMessage(
      "Atendimento telefónico",
    ),
    "tele_personal_assistance": MessageLookupByLibrary.simpleMessage(
      "Atendimento presencial e telefónico",
    ),
    "telephone": MessageLookupByLibrary.simpleMessage("Telefone"),
    "terms": MessageLookupByLibrary.simpleMessage("Termos e Condições"),
    "terms_change": MessageLookupByLibrary.simpleMessage(
      "Mudança nos Termos e Condições da uni",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Tema"),
    "title": MessageLookupByLibrary.simpleMessage("Título"),
    "today": MessageLookupByLibrary.simpleMessage("hoje:"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("amanhã:"),
    "tomorrows_meals": MessageLookupByLibrary.simpleMessage("Menu de Amanhã"),
    "transactions": MessageLookupByLibrary.simpleMessage("Transações"),
    "try_again": MessageLookupByLibrary.simpleMessage("Tentar de novo"),
    "try_different_login": MessageLookupByLibrary.simpleMessage(
      "Problemas ao iniciar sessão?",
    ),
    "tuition_fees": MessageLookupByLibrary.simpleMessage("Propinas"),
    "uc_info": MessageLookupByLibrary.simpleMessage("Abrir página da UC"),
    "ucs": MessageLookupByLibrary.simpleMessage("UCS"),
    "unable_to_load_data": MessageLookupByLibrary.simpleMessage(
      "Não foi possível carregar dados",
    ),
    "unavailable": MessageLookupByLibrary.simpleMessage("Indisponível"),
    "until": MessageLookupByLibrary.simpleMessage("Até"),
    "upcoming_due": MessageLookupByLibrary.simpleMessage("Próximo Vencimento"),
    "user_informations": MessageLookupByLibrary.simpleMessage(
      "Informações Pessoais",
    ),
    "valid_email": MessageLookupByLibrary.simpleMessage(
      "Por favor insere um email válido",
    ),
    "vending_machine": MessageLookupByLibrary.simpleMessage("Máquina de venda"),
    "view_course_details": MessageLookupByLibrary.simpleMessage(
      "Ver detalhes da Unidade Curricular",
    ),
    "wc": MessageLookupByLibrary.simpleMessage("Casa de banho"),
    "widget_prompt": MessageLookupByLibrary.simpleMessage(
      "Escolhe um widget para adicionares à tua área pessoal:",
    ),
    "wrong_credentials_exception": MessageLookupByLibrary.simpleMessage(
      "Credenciais inválidas",
    ),
    "year": MessageLookupByLibrary.simpleMessage("Ano"),
    "yes": MessageLookupByLibrary.simpleMessage("Sim"),
  };
}
