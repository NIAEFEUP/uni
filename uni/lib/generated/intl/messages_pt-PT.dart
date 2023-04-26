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
        "account_card_title":
            MessageLookupByLibrary.simpleMessage("Conta Corrente"),
        "add": MessageLookupByLibrary.simpleMessage("Adicionar"),
        "add_widget": MessageLookupByLibrary.simpleMessage("Adicionar widget"),
        "all_widgets_added": MessageLookupByLibrary.simpleMessage(
            "Todos os widgets disponíveis já foram adicionados à tua área pessoal!"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo:"),
        "bus_error": MessageLookupByLibrary.simpleMessage(
            "Não foi possível obter informação"),
        "bus_information": MessageLookupByLibrary.simpleMessage(
            "Seleciona os autocarros dos quais queres informação:"),
        "buses_personalize": MessageLookupByLibrary.simpleMessage(
            "Configura aqui os teus autocarros"),
        "buses_text": MessageLookupByLibrary.simpleMessage(
            "Os autocarros favoritos serão apresentados no widget \'Autocarros\' dos favoritos. Os restantes serão apresentados apenas na página."),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar\n"),
        "conclude": MessageLookupByLibrary.simpleMessage("Concluído"),
        "configured_buses":
            MessageLookupByLibrary.simpleMessage("Autocarros Configurados"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "edit_off": MessageLookupByLibrary.simpleMessage("Editar\n"),
        "edit_on": MessageLookupByLibrary.simpleMessage("Concluir edição"),
        "exams_filter":
            MessageLookupByLibrary.simpleMessage("Definições Filtro de Exames"),
        "fee_date": MessageLookupByLibrary.simpleMessage(
            "Data limite próxima prestação:"),
        "fee_notification": MessageLookupByLibrary.simpleMessage(
            "Notificar próxima data limite:"),
        "floor": MessageLookupByLibrary.simpleMessage("Piso"),
        "floors": MessageLookupByLibrary.simpleMessage("Pisos"),
        "last_refresh_time": m0,
        "last_timestamp": m1,
        "library": MessageLookupByLibrary.simpleMessage("Biblioteca"),
        "library_occupation":
            MessageLookupByLibrary.simpleMessage("Ocupação da Biblioteca"),
        "logout": MessageLookupByLibrary.simpleMessage("Terminar sessão"),
        "menus": MessageLookupByLibrary.simpleMessage("Ementas"),
        "nav_title": m2,
        "no_course_units": MessageLookupByLibrary.simpleMessage(
            "Sem cadeiras no período selecionado"),
        "no_data": MessageLookupByLibrary.simpleMessage(
            "Não há dados a mostrar neste momento"),
        "no_exams":
            MessageLookupByLibrary.simpleMessage("Não possui exames marcados"),
        "no_menu_info": MessageLookupByLibrary.simpleMessage(
            "Não há informação disponível sobre refeições"),
        "no_menus": MessageLookupByLibrary.simpleMessage(
            "Não há refeições disponíveis"),
        "no_results": MessageLookupByLibrary.simpleMessage("Sem resultados"),
        "no_selected_courses": MessageLookupByLibrary.simpleMessage(
            "Não existem cadeiras para apresentar"),
        "no_selected_exams": MessageLookupByLibrary.simpleMessage(
            "Não existem exames para apresentar"),
        "semester": MessageLookupByLibrary.simpleMessage("Semestre"),
        "stcp_stops":
            MessageLookupByLibrary.simpleMessage("STCP - Próximas Viagens"),
        "widget_prompt": MessageLookupByLibrary.simpleMessage(
            "Escolhe um widget para adicionares à tua área pessoal:"),
        "year": MessageLookupByLibrary.simpleMessage("Ano")
      };
}
