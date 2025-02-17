// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_PT locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_PT';

  static String m0(type) => "${Intl.select(type, {
            'all_dishes': 'Todos os pratos',
            'meat_dishes': 'Pratos de Carne',
            'fish_dishes': 'Pratos de Peixe',
            'vegetarian_dishes': 'Pratos Vegetarianos',
            'soups': 'Sopas',
            'salads': 'Saladas',
            'diet_dishes': 'Pratos de Dieta',
            'dishes_of_the_day': 'Pratos do Dia',
            'other': 'Outros',
          })}";

  static String m1(time) => "última atualização às ${time}";

  static String m2(time) =>
      "${Intl.plural(time, zero: 'Atualizado há ${time} minutos', one: 'Atualizado há ${time} minuto', other: 'Atualizado há ${time} minutos')}";

  static String m3(title) => "${Intl.select(title, {
            'horario': 'Horário',
            'exames': 'Exames',
            'area': 'Área Pessoal',
            'cadeiras': 'Cadeiras',
            'autocarros': 'Autocarros',
            'locais': 'Locais',
            'restaurantes': 'Restaurantes',
            'calendario': 'Calendário',
            'biblioteca': 'Biblioteca',
            'percurso_academico': 'Percurso Académico',
            'mapa': 'Mapa',
            'faculdade': 'Faculdade',
            'other': 'Outros',
          })}";

  static String m4(period) => "${Intl.select(period, {
            'lunch': 'Almoço',
            'dinner': 'Jantar',
            'other': 'Other',
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Sobre nós"),
        "academic_services":
            MessageLookupByLibrary.simpleMessage("Serviços académicos"),
        "account_card_title":
            MessageLookupByLibrary.simpleMessage("Conta Corrente"),
        "add": MessageLookupByLibrary.simpleMessage("Adicionar"),
        "add_quota": MessageLookupByLibrary.simpleMessage("Adicionar quota"),
        "add_widget": MessageLookupByLibrary.simpleMessage("Adicionar widget"),
        "agree_terms": MessageLookupByLibrary.simpleMessage(
            "Ao entrares confirmas que concordas com estes"),
        "all_feminine": MessageLookupByLibrary.simpleMessage("Todas"),
        "all_widgets_added": MessageLookupByLibrary.simpleMessage(
            "Todos os widgets disponíveis já foram adicionados à tua área pessoal!"),
        "assessments": MessageLookupByLibrary.simpleMessage("Avaliações"),
        "at_least_one_college": MessageLookupByLibrary.simpleMessage(
            "Seleciona pelo menos uma faculdade"),
        "available_amount":
            MessageLookupByLibrary.simpleMessage("Valor disponível"),
        "average": MessageLookupByLibrary.simpleMessage("Média"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo"),
        "banner_info": MessageLookupByLibrary.simpleMessage(
            "Agora recolhemos estatísticas de uso anónimas para melhorar a tua experiência. Podes alterá-lo nas definições."),
        "bibliography": MessageLookupByLibrary.simpleMessage("Bibliografia"),
        "breakfast": MessageLookupByLibrary.simpleMessage("Pequeno Almoço"),
        "bs_description": MessageLookupByLibrary.simpleMessage(
            "Encontraste algum bug na aplicação?\nTens alguma sugestão para a app?\nConta-nos para que possamos melhorar!"),
        "bug_description": MessageLookupByLibrary.simpleMessage(
            "Bug encontrado, como o reproduzir, etc"),
        "bus_error": MessageLookupByLibrary.simpleMessage(
            "Não foi possível obter informação"),
        "bus_information": MessageLookupByLibrary.simpleMessage(
            "Seleciona os autocarros dos quais queres informação:"),
        "buses_personalize": MessageLookupByLibrary.simpleMessage(
            "Configura aqui os teus autocarros"),
        "buses_text": MessageLookupByLibrary.simpleMessage(
            "Os autocarros favoritos serão apresentados no widget \'Autocarros\' dos favoritos. Os restantes serão apresentados apenas na página."),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "change": MessageLookupByLibrary.simpleMessage("Alterar"),
        "change_prompt": MessageLookupByLibrary.simpleMessage(
            "Deseja alterar a palavra-passe?"),
        "check_internet": MessageLookupByLibrary.simpleMessage(
            "Verifica a tua ligação à internet"),
        "class_registration":
            MessageLookupByLibrary.simpleMessage("Inscrição de Turmas"),
        "collect_usage_stats": MessageLookupByLibrary.simpleMessage(
            "Partilhar estatísticas de uso"),
        "college": MessageLookupByLibrary.simpleMessage("Faculdade: "),
        "college_select": MessageLookupByLibrary.simpleMessage(
            "seleciona a(s) tua(s) faculdade(s)"),
        "conclude": MessageLookupByLibrary.simpleMessage("Concluído"),
        "configured_buses":
            MessageLookupByLibrary.simpleMessage("Autocarros Configurados"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "confirm_logout": MessageLookupByLibrary.simpleMessage(
            "Tens a certeza de que queres terminar sessão? Os teus dados locais serão apagados e terás de iniciar sessão novamente."),
        "consent": MessageLookupByLibrary.simpleMessage(
            "Consinto que esta informação seja revista pelo NIAEFEUP, podendo ser eliminada a meu pedido."),
        "contact": MessageLookupByLibrary.simpleMessage("Contacto (opcional)"),
        "copy_center": MessageLookupByLibrary.simpleMessage("Centro de cópias"),
        "copy_center_building": MessageLookupByLibrary.simpleMessage(
            "Piso -1 do edifício B | Edifício da AEFEUP"),
        "courseRegent":
            MessageLookupByLibrary.simpleMessage("Regente da Cadeira"),
        "course_class": MessageLookupByLibrary.simpleMessage("Turmas"),
        "course_info": MessageLookupByLibrary.simpleMessage("Ficha"),
        "courses": MessageLookupByLibrary.simpleMessage("Cursos"),
        "current_state": MessageLookupByLibrary.simpleMessage("Estado atual: "),
        "current_year":
            MessageLookupByLibrary.simpleMessage("Ano curricular atual: "),
        "decrement": MessageLookupByLibrary.simpleMessage("Decrementar 1,00€"),
        "description": MessageLookupByLibrary.simpleMessage("Descrição"),
        "desired_email": MessageLookupByLibrary.simpleMessage(
            "Email em que desejas ser contactado"),
        "dinner": MessageLookupByLibrary.simpleMessage("Jantar"),
        "dish_type": m0,
        "dona_bia":
            MessageLookupByLibrary.simpleMessage("Papelaria D. Beatriz"),
        "dona_bia_building": MessageLookupByLibrary.simpleMessage(
            "Piso -1 do edifício B (B-142)"),
        "download_error": MessageLookupByLibrary.simpleMessage(
            "Erro ao descarregar o ficheiro"),
        "ects": MessageLookupByLibrary.simpleMessage("ECTS realizados: "),
        "edit_off": MessageLookupByLibrary.simpleMessage("Editar"),
        "edit_on": MessageLookupByLibrary.simpleMessage("Concluir edição"),
        "empty_text": MessageLookupByLibrary.simpleMessage(
            "Por favor preenche este campo"),
        "evaluation": MessageLookupByLibrary.simpleMessage("Avaliação"),
        "exams": MessageLookupByLibrary.simpleMessage("Exames"),
        "exams_filter":
            MessageLookupByLibrary.simpleMessage("Definições Filtro de Exames"),
        "exit_confirm": MessageLookupByLibrary.simpleMessage(
            "Tem a certeza de que pretende sair?"),
        "expired_password":
            MessageLookupByLibrary.simpleMessage("A tua palavra-passe expirou"),
        "fail_to_authenticate":
            MessageLookupByLibrary.simpleMessage("Falha ao autenticar"),
        "failed_login": MessageLookupByLibrary.simpleMessage("O login falhou"),
        "favorite_filter": MessageLookupByLibrary.simpleMessage("Favoritos"),
        "fee_date": MessageLookupByLibrary.simpleMessage("Data limite"),
        "fee_notification":
            MessageLookupByLibrary.simpleMessage("Data limite de propina"),
        "feedback_description": MessageLookupByLibrary.simpleMessage(
            "Reporta um problema ou sugere uma melhoria"),
        "files": MessageLookupByLibrary.simpleMessage("Ficheiros"),
        "first_year_registration":
            MessageLookupByLibrary.simpleMessage("Ano da primeira inscrição: "),
        "floor": MessageLookupByLibrary.simpleMessage("Piso"),
        "floors": MessageLookupByLibrary.simpleMessage("Pisos"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Esqueceu a palavra-passe?"),
        "frequency":
            MessageLookupByLibrary.simpleMessage("Obtenção de Frequência"),
        "generate_reference":
            MessageLookupByLibrary.simpleMessage("Gerar referência"),
        "geral_registration":
            MessageLookupByLibrary.simpleMessage("Inscrição Geral"),
        "improvement_registration":
            MessageLookupByLibrary.simpleMessage("Inscrição para Melhoria"),
        "increment": MessageLookupByLibrary.simpleMessage("Incrementar 1,00€"),
        "instructor": MessageLookupByLibrary.simpleMessage("Docente"),
        "instructors": MessageLookupByLibrary.simpleMessage("Docentes"),
        "internet_status_exception": MessageLookupByLibrary.simpleMessage(
            "Verifique sua conexão com a internet"),
        "invalid_credentials":
            MessageLookupByLibrary.simpleMessage("Credenciais inválidas"),
        "keep_login": MessageLookupByLibrary.simpleMessage("Lembre-se de mim"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "last_refresh_time": m1,
        "last_timestamp": m2,
        "leave_feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "lectures": MessageLookupByLibrary.simpleMessage("Aulas"),
        "library_occupation":
            MessageLookupByLibrary.simpleMessage("Ocupação da Biblioteca"),
        "load_error": MessageLookupByLibrary.simpleMessage(
            "Erro ao carregar a informação"),
        "loading_terms": MessageLookupByLibrary.simpleMessage(
            "Carregando os Termos e Condições..."),
        "login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "login_with_credentials":
            MessageLookupByLibrary.simpleMessage("Entrar com credenciais"),
        "logout": MessageLookupByLibrary.simpleMessage("Terminar sessão"),
        "lunch": MessageLookupByLibrary.simpleMessage("Almoço"),
        "menus": MessageLookupByLibrary.simpleMessage("Ementas"),
        "min_value_reference":
            MessageLookupByLibrary.simpleMessage("Valor mínimo: 1,00 €"),
        "multimedia_center":
            MessageLookupByLibrary.simpleMessage("Centro de multimédia"),
        "nav_title": m3,
        "news": MessageLookupByLibrary.simpleMessage("Notícias"),
        "no": MessageLookupByLibrary.simpleMessage("Não"),
        "noExamsScheduled":
            MessageLookupByLibrary.simpleMessage("Não há exames agendados"),
        "noInstructors":
            MessageLookupByLibrary.simpleMessage("Não há docentes atribuídos"),
        "no_app": MessageLookupByLibrary.simpleMessage(
            "Nenhuma aplicação encontrada para abrir o ficheiro"),
        "no_bus": MessageLookupByLibrary.simpleMessage(
            "Não percas nenhum autocarro!"),
        "no_bus_stops": MessageLookupByLibrary.simpleMessage(
            "Não existe nenhuma paragem configurada"),
        "no_class": MessageLookupByLibrary.simpleMessage(
            "Não existem turmas para apresentar"),
        "no_classes": MessageLookupByLibrary.simpleMessage(
            "Não existem aulas para apresentar"),
        "no_classes_on":
            MessageLookupByLibrary.simpleMessage("Não possui aulas à"),
        "no_classes_on_weekend":
            MessageLookupByLibrary.simpleMessage("Não possui aulas ao"),
        "no_college": MessageLookupByLibrary.simpleMessage("sem faculdade"),
        "no_course_units": MessageLookupByLibrary.simpleMessage(
            "Sem cadeiras no período selecionado"),
        "no_courses": MessageLookupByLibrary.simpleMessage(
            "Não foram encontrados cursos"),
        "no_courses_description":
            MessageLookupByLibrary.simpleMessage("Tenta refrescar a página"),
        "no_data": MessageLookupByLibrary.simpleMessage(
            "Não há dados a mostrar neste momento"),
        "no_date": MessageLookupByLibrary.simpleMessage("Sem data"),
        "no_events":
            MessageLookupByLibrary.simpleMessage("Nenhum evento encontrado"),
        "no_exams":
            MessageLookupByLibrary.simpleMessage("Não possui exames marcados"),
        "no_exams_label":
            MessageLookupByLibrary.simpleMessage("Parece que estás de férias!"),
        "no_favorite_restaurants":
            MessageLookupByLibrary.simpleMessage("Sem restaurantes favoritos"),
        "no_files_found":
            MessageLookupByLibrary.simpleMessage("Nenhum ficheiro encontrado"),
        "no_info": MessageLookupByLibrary.simpleMessage(
            "Não existem informações para apresentar"),
        "no_internet":
            MessageLookupByLibrary.simpleMessage("Parece que estás offline"),
        "no_library_info":
            MessageLookupByLibrary.simpleMessage("Sem informação de ocupação"),
        "no_link": MessageLookupByLibrary.simpleMessage(
            "Não conseguimos abrir o link"),
        "no_menu_info": MessageLookupByLibrary.simpleMessage(
            "Não há informação disponível sobre refeições"),
        "no_menus": MessageLookupByLibrary.simpleMessage(
            "Não há refeições disponíveis"),
        "no_name_course":
            MessageLookupByLibrary.simpleMessage("Curso sem nome"),
        "no_places_info": MessageLookupByLibrary.simpleMessage(
            "Não há informação disponível sobre locais"),
        "no_print_info":
            MessageLookupByLibrary.simpleMessage("Sem informação de saldo"),
        "no_references": MessageLookupByLibrary.simpleMessage(
            "Não existem referências a pagar"),
        "no_results": MessageLookupByLibrary.simpleMessage("Sem resultados"),
        "no_selected_courses": MessageLookupByLibrary.simpleMessage(
            "Não existem cadeiras para apresentar"),
        "no_selected_exams": MessageLookupByLibrary.simpleMessage(
            "Não existem exames para apresentar"),
        "no_trips": MessageLookupByLibrary.simpleMessage(
            "Não há viagens planeadas de momento"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notificações"),
        "occurrence_type":
            MessageLookupByLibrary.simpleMessage("Tipo de ocorrência"),
        "of_month": MessageLookupByLibrary.simpleMessage("de"),
        "open_error":
            MessageLookupByLibrary.simpleMessage("Erro ao abrir o ficheiro"),
        "other_links": MessageLookupByLibrary.simpleMessage("Outros links"),
        "pass_change_request": MessageLookupByLibrary.simpleMessage(
            "Por razões de segurança, as palavras-passe têm de ser alteradas periodicamente."),
        "password": MessageLookupByLibrary.simpleMessage("Palavra-passe"),
        "pendent_references":
            MessageLookupByLibrary.simpleMessage("Referências pendentes"),
        "permission_denied":
            MessageLookupByLibrary.simpleMessage("Sem permissão"),
        "personal_assistance":
            MessageLookupByLibrary.simpleMessage("Atendimento presencial"),
        "press_again": MessageLookupByLibrary.simpleMessage(
            "Pressione novamente para sair"),
        "print": MessageLookupByLibrary.simpleMessage("Impressão"),
        "print_balance":
            MessageLookupByLibrary.simpleMessage("Saldo impressões"),
        "prints": MessageLookupByLibrary.simpleMessage("Impressões"),
        "problem_id": MessageLookupByLibrary.simpleMessage(
            "Breve identificação do problema"),
        "program": MessageLookupByLibrary.simpleMessage("Programa"),
        "reference_sigarra_help": MessageLookupByLibrary.simpleMessage(
            "Os dados da referência gerada aparecerão no Sigarra, conta corrente. Perfil > Conta Corrente"),
        "reference_success": MessageLookupByLibrary.simpleMessage(
            "Referência criada com sucesso!"),
        "remove": MessageLookupByLibrary.simpleMessage("Remover"),
        "report_error": MessageLookupByLibrary.simpleMessage("Reportar erro"),
        "restaurant_main_page": MessageLookupByLibrary.simpleMessage(
            "Queres ver os teus restaurantes favoritos na página principal?"),
        "restaurant_period": m4,
        "room": MessageLookupByLibrary.simpleMessage("Sala"),
        "schedule": MessageLookupByLibrary.simpleMessage("Aulas"),
        "school_calendar":
            MessageLookupByLibrary.simpleMessage("Calendário Escolar"),
        "search": MessageLookupByLibrary.simpleMessage("Pesquisar"),
        "semester": MessageLookupByLibrary.simpleMessage("Semestre"),
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sent_error":
            MessageLookupByLibrary.simpleMessage("Ocorreu um erro no envio"),
        "settings": MessageLookupByLibrary.simpleMessage("Definições"),
        "snackbar": MessageLookupByLibrary.simpleMessage("Snackbar"),
        "some_error": MessageLookupByLibrary.simpleMessage("Algum erro!"),
        "stcp_stops":
            MessageLookupByLibrary.simpleMessage("STCP - Próximas Viagens"),
        "student_number":
            MessageLookupByLibrary.simpleMessage("Número de Estudante"),
        "success": MessageLookupByLibrary.simpleMessage("Enviado com sucesso"),
        "successful_open":
            MessageLookupByLibrary.simpleMessage("Ficheiro aberto com sucesso"),
        "tele_assistance":
            MessageLookupByLibrary.simpleMessage("Atendimento telefónico"),
        "tele_personal_assistance": MessageLookupByLibrary.simpleMessage(
            "Atendimento presencial e telefónico"),
        "telephone": MessageLookupByLibrary.simpleMessage("Telefone"),
        "terms": MessageLookupByLibrary.simpleMessage("Termos e Condições"),
        "theme": MessageLookupByLibrary.simpleMessage("Tema"),
        "title": MessageLookupByLibrary.simpleMessage("Título"),
        "try_again": MessageLookupByLibrary.simpleMessage("Tentar de novo"),
        "try_different_login": MessageLookupByLibrary.simpleMessage(
            "Problemas ao iniciar sessão?"),
        "uc_info": MessageLookupByLibrary.simpleMessage("Abrir página da UC"),
        "unavailable": MessageLookupByLibrary.simpleMessage("Indisponível"),
        "valid_email": MessageLookupByLibrary.simpleMessage(
            "Por favor insere um email válido"),
        "widget_prompt": MessageLookupByLibrary.simpleMessage(
            "Escolhe um widget para adicionares à tua área pessoal:"),
        "wrong_credentials_exception":
            MessageLookupByLibrary.simpleMessage("Credenciais inválidas"),
        "year": MessageLookupByLibrary.simpleMessage("Ano"),
        "yes": MessageLookupByLibrary.simpleMessage("Sim")
      };
}
