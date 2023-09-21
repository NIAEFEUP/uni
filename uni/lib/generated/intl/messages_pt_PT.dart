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

  static String m0(time) => "última atualização às ${time}";

  static String m1(time) =>
      "${Intl.plural(time, zero: 'Atualizado há ${time} minutos', one: 'Atualizado há ${time} minuto', other: 'Atualizado há ${time} minutos')}";

  static String m2(title) => "${Intl.select(title, {
            'horario': 'Horário',
            'exames': 'Exames',
            'area': 'Área Pessoal',
            'cadeiras': 'Cadeiras',
            'autocarros': 'Autocarros',
            'locais': 'Locais',
            'restaurantes': 'Restaurantes',
            'calendario': 'Calendário',
            'biblioteca': 'Biblioteca',
            'uteis': 'Úteis',
            'sobre': 'Sobre',
            'bugs': 'Bugs e Sugestões',
            'other': 'Outros',
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "academic_services":
            MessageLookupByLibrary.simpleMessage("Serviços académicos"),
        "account_card_title":
            MessageLookupByLibrary.simpleMessage("Conta Corrente"),
        "add": MessageLookupByLibrary.simpleMessage("Adicionar"),
        "add_quota": MessageLookupByLibrary.simpleMessage("Adicionar quota"),
        "add_widget": MessageLookupByLibrary.simpleMessage("Adicionar widget"),
        "agree_terms": MessageLookupByLibrary.simpleMessage(
            "Ao entrares confirmas que concordas com estes Termos e Condições"),
        "all_widgets_added": MessageLookupByLibrary.simpleMessage(
            "Todos os widgets disponíveis já foram adicionados à tua área pessoal!"),
        "at_least_one_college": MessageLookupByLibrary.simpleMessage(
            "Seleciona pelo menos uma faculdade"),
        "available_amount":
            MessageLookupByLibrary.simpleMessage("Valor disponível"),
        "average": MessageLookupByLibrary.simpleMessage("Média: "),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo:"),
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
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar\n"),
        "change": MessageLookupByLibrary.simpleMessage("Alterar"),
        "change_prompt": MessageLookupByLibrary.simpleMessage(
            "Deseja alterar a palavra-passe?"),
        "check_internet": MessageLookupByLibrary.simpleMessage(
            "Verifica a tua ligação à internet"),
        "class_registration":
            MessageLookupByLibrary.simpleMessage("Inscrição de Turmas"),
        "college": MessageLookupByLibrary.simpleMessage("Faculdade: "),
        "college_select": MessageLookupByLibrary.simpleMessage(
            "seleciona a(s) tua(s) faculdade(s)"),
        "conclude": MessageLookupByLibrary.simpleMessage("Concluído"),
        "configured_buses":
            MessageLookupByLibrary.simpleMessage("Autocarros Configurados"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "consent": MessageLookupByLibrary.simpleMessage(
            "Consinto que esta informação seja revista pelo NIAEFEUP, podendo ser eliminada a meu pedido."),
        "contact": MessageLookupByLibrary.simpleMessage("Contacto (opcional)"),
        "copy_center": MessageLookupByLibrary.simpleMessage("Centro de cópias"),
        "copy_center_building": MessageLookupByLibrary.simpleMessage(
            "Piso -1 do edifício B | Edifício da AEFEUP"),
        "course_class": MessageLookupByLibrary.simpleMessage("Turmas"),
        "course_info": MessageLookupByLibrary.simpleMessage("Ficha"),
        "current_state": MessageLookupByLibrary.simpleMessage("Estado atual: "),
        "current_year":
            MessageLookupByLibrary.simpleMessage("Ano curricular atual: "),
        "decrement": MessageLookupByLibrary.simpleMessage("Decrementar 1,00€"),
        "description": MessageLookupByLibrary.simpleMessage("Descrição"),
        "desired_email": MessageLookupByLibrary.simpleMessage(
            "Email em que desejas ser contactado"),
        "dona_bia":
            MessageLookupByLibrary.simpleMessage("Papelaria D. Beatriz"),
        "dona_bia_building": MessageLookupByLibrary.simpleMessage(
            "Piso -1 do edifício B (B-142)"),
        "ects": MessageLookupByLibrary.simpleMessage("ECTs realizados: "),
        "edit_off": MessageLookupByLibrary.simpleMessage("Editar\n"),
        "edit_on": MessageLookupByLibrary.simpleMessage("Concluir edição"),
        "empty_text": MessageLookupByLibrary.simpleMessage(
            "Por favor preenche este campo"),
        "exams_filter":
            MessageLookupByLibrary.simpleMessage("Definições Filtro de Exames"),
        "exit_confirm": MessageLookupByLibrary.simpleMessage(
            "Tem a certeza de que pretende sair?"),
        "expired_password":
            MessageLookupByLibrary.simpleMessage("A tua palavra-passe expirou"),
        "failed_login": MessageLookupByLibrary.simpleMessage("O login falhou"),
        "fee_date": MessageLookupByLibrary.simpleMessage(
            "Data limite próxima prestação:"),
        "fee_notification": MessageLookupByLibrary.simpleMessage(
            "Notificar próxima data limite:"),
        "first_year_registration":
            MessageLookupByLibrary.simpleMessage("Ano da primeira inscrição: "),
        "floor": MessageLookupByLibrary.simpleMessage("Piso"),
        "floors": MessageLookupByLibrary.simpleMessage("Pisos"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Esqueceu a palavra-passe?"),
        "generate_reference":
            MessageLookupByLibrary.simpleMessage("Gerar referência"),
        "geral_registration":
            MessageLookupByLibrary.simpleMessage("Inscrição Geral"),
        "improvement_registration":
            MessageLookupByLibrary.simpleMessage("Inscrição para Melhoria"),
        "increment": MessageLookupByLibrary.simpleMessage("Incrementar 1,00€"),
        "invalid_credentials":
            MessageLookupByLibrary.simpleMessage("Credenciais inválidas"),
        "keep_login":
            MessageLookupByLibrary.simpleMessage("Manter sessão iniciada"),
        "last_refresh_time": m0,
        "last_timestamp": m1,
        "library_occupation":
            MessageLookupByLibrary.simpleMessage("Ocupação da Biblioteca"),
        "load_error": MessageLookupByLibrary.simpleMessage(
            "Aconteceu um erro ao carregar os dados"),
        "loading_terms": MessageLookupByLibrary.simpleMessage(
            "Carregando os Termos e Condições..."),
        "login": MessageLookupByLibrary.simpleMessage("Entrar"),
        "logout": MessageLookupByLibrary.simpleMessage("Terminar sessão"),
        "menus": MessageLookupByLibrary.simpleMessage("Ementas"),
        "min_value_reference":
            MessageLookupByLibrary.simpleMessage("Valor mínimo: 1,00 €"),
        "multimedia_center":
            MessageLookupByLibrary.simpleMessage("Centro de multimédia"),
        "nav_title": m2,
        "news": MessageLookupByLibrary.simpleMessage("Notícias"),
        "no": MessageLookupByLibrary.simpleMessage("Não"),
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
        "no_college": MessageLookupByLibrary.simpleMessage("sem faculdade"),
        "no_course_units": MessageLookupByLibrary.simpleMessage(
            "Sem cadeiras no período selecionado"),
        "no_data": MessageLookupByLibrary.simpleMessage(
            "Não há dados a mostrar neste momento"),
        "no_date": MessageLookupByLibrary.simpleMessage("Sem data"),
        "no_exams":
            MessageLookupByLibrary.simpleMessage("Não possui exames marcados"),
        "no_exams_label":
            MessageLookupByLibrary.simpleMessage("Parece que estás de férias!"),
        "no_favorite_restaurants":
            MessageLookupByLibrary.simpleMessage("Sem restaurantes favoritos"),
        "no_info": MessageLookupByLibrary.simpleMessage(
            "Não existem informações para apresentar"),
        "no_menu_info": MessageLookupByLibrary.simpleMessage(
            "Não há informação disponível sobre refeições"),
        "no_menus": MessageLookupByLibrary.simpleMessage(
            "Não há refeições disponíveis"),
        "no_name_course":
            MessageLookupByLibrary.simpleMessage("Curso sem nome"),
        "no_places_info": MessageLookupByLibrary.simpleMessage(
            "Não há informação disponível sobre locais"),
        "no_references": MessageLookupByLibrary.simpleMessage(
            "Não existem referências a pagar"),
        "no_results": MessageLookupByLibrary.simpleMessage("Sem resultados"),
        "no_selected_courses": MessageLookupByLibrary.simpleMessage(
            "Não existem cadeiras para apresentar"),
        "no_selected_exams": MessageLookupByLibrary.simpleMessage(
            "Não existem exames para apresentar"),
        "occurrence_type":
            MessageLookupByLibrary.simpleMessage("Tipo de ocorrência"),
        "other_links": MessageLookupByLibrary.simpleMessage("Outros links"),
        "pass_change_request": MessageLookupByLibrary.simpleMessage(
            "Por razões de segurança, as palavras-passe têm de ser alteradas periodicamente."),
        "password": MessageLookupByLibrary.simpleMessage("palavra-passe"),
        "pendent_references":
            MessageLookupByLibrary.simpleMessage("Referências pendentes"),
        "personal_assistance":
            MessageLookupByLibrary.simpleMessage("Atendimento presencial"),
        "press_again": MessageLookupByLibrary.simpleMessage(
            "Pressione novamente para sair"),
        "print": MessageLookupByLibrary.simpleMessage("Impressão"),
        "prints": MessageLookupByLibrary.simpleMessage("Impressões"),
        "problem_id": MessageLookupByLibrary.simpleMessage(
            "Breve identificação do problema"),
        "reference_sigarra_help": MessageLookupByLibrary.simpleMessage(
            "Os dados da referência gerada aparecerão no Sigarra, conta corrente.\\nPerfil > Conta Corrente"),
        "reference_success": MessageLookupByLibrary.simpleMessage(
            "Referência criada com sucesso!"),
        "remove": MessageLookupByLibrary.simpleMessage("Remover"),
        "report_error": MessageLookupByLibrary.simpleMessage("Reportar erro"),
        "room": MessageLookupByLibrary.simpleMessage("Sala"),
        "school_calendar":
            MessageLookupByLibrary.simpleMessage("Calendário Escolar"),
        "semester": MessageLookupByLibrary.simpleMessage("Semestre"),
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sent_error":
            MessageLookupByLibrary.simpleMessage("Ocorreu um erro no envio"),
        "some_error": MessageLookupByLibrary.simpleMessage("Algum erro!"),
        "stcp_stops":
            MessageLookupByLibrary.simpleMessage("STCP - Próximas Viagens"),
        "student_number":
            MessageLookupByLibrary.simpleMessage("número de estudante"),
        "success": MessageLookupByLibrary.simpleMessage("Enviado com sucesso"),
        "tele_assistance":
            MessageLookupByLibrary.simpleMessage("Atendimento telefónico"),
        "tele_personal_assistance": MessageLookupByLibrary.simpleMessage(
            "Atendimento presencial e telefónico"),
        "telephone": MessageLookupByLibrary.simpleMessage("Telefone"),
        "terms": MessageLookupByLibrary.simpleMessage("Termos e Condições"),
        "title": MessageLookupByLibrary.simpleMessage("Título"),
        "unavailable": MessageLookupByLibrary.simpleMessage("Indisponível"),
        "valid_email": MessageLookupByLibrary.simpleMessage(
            "Por favor insere um email válido"),
        "widget_prompt": MessageLookupByLibrary.simpleMessage(
            "Escolhe um widget para adicionares à tua área pessoal:"),
        "year": MessageLookupByLibrary.simpleMessage("Ano"),
        "yes": MessageLookupByLibrary.simpleMessage("Sim")
      };
}
