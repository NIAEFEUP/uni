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
      "${Intl.plural(time, one: '${time} minuto', other: '${time} minutos')}";

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
        "add_widget": MessageLookupByLibrary.simpleMessage("Adicionar widget"),
        "all_widgets_added": MessageLookupByLibrary.simpleMessage(
            "Todos os widgets disponíveis já foram adicionados à tua área pessoal!"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo:"),
        "bus_card_title": MessageLookupByLibrary.simpleMessage("Autocarros"),
        "bus_error": MessageLookupByLibrary.simpleMessage(
            "Não foi possível obter informação"),
        "buses_personalize": MessageLookupByLibrary.simpleMessage(
            "Configura aqui os teus autocarros"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar\n"),
        "edit_off": MessageLookupByLibrary.simpleMessage("Editar\n"),
        "edit_on": MessageLookupByLibrary.simpleMessage("Concluir edição"),
        "exam_card_title": MessageLookupByLibrary.simpleMessage("Exames"),
        "fee_date": MessageLookupByLibrary.simpleMessage(
            "Data limite próxima prestação:"),
        "fee_notification": MessageLookupByLibrary.simpleMessage(
            "Notificar próxima data limite:"),
        "last_refresh_time": m0,
        "last_timestamp": m1,
        "logout": MessageLookupByLibrary.simpleMessage("Terminar sessão"),
        "nav_title": m2,
        "no_data": MessageLookupByLibrary.simpleMessage(
            "Não há dados a mostrar neste momento"),
        "no_exams":
            MessageLookupByLibrary.simpleMessage("Não possui exames marcados"),
        "no_selected_exams": MessageLookupByLibrary.simpleMessage(
            "Não existem exames para apresentar"),
        "restaurant_card_title":
            MessageLookupByLibrary.simpleMessage("Restaurantes"),
        "schedule_card_title": MessageLookupByLibrary.simpleMessage("Horário"),
        "stcp_stops":
            MessageLookupByLibrary.simpleMessage("STCP - Próximas Viagens"),
        "widget_prompt": MessageLookupByLibrary.simpleMessage(
            "Escolhe um widget para adicionares à tua área pessoal:")
      };
}
