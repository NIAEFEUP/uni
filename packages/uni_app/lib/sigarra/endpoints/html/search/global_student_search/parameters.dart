import 'package:json_annotation/json_annotation.dart';
import 'package:uni/sigarra/instances.dart';

enum GlobalStudentSearchCourseType {
  /// Atualização
  a,

  /// Bacharelato
  b,

  /// Curso de complemento de formação
  cf,

  /// Curso de Formação Contínua
  cfc,

  ///Curso de Verão/Inverno
  vi,

  /// Curso ou Formação livre
  fl,

  /// Doutoramento
  d,

  /// Especialização
  e,

  /// Estudos Avançados
  ea,

  /// EUGLOH - Atividades de Formação
  eg,

  /// European Innovation Academy (EIA)
  eia,

  /// Formação Contínua
  fc,

  /// Licenciatura
  l,

  /// Livres
  lv,

  /// Mestrado
  m,

  /// Mestrado Integrado
  mi,

  /// Programa de Pós-Doutoramento
  pd,

  /// Unidade de Formação Contínua
  ufc,

  /// Unidade/Módulo/Ação
  um;

  String toJson() => name.toUpperCase();
}

enum GlobalStudentSearchEnrollmentStatus {
  /// Inscrito
  registered(1),

  /// Inscrito > Concluído
  completed(2),

  /// Inscrito > A Frequentar
  attending(3),

  /// Desistente
  withdrawn(4),

  /// Desistente > Desistencia Temporária
  withdrawnTemporarily(5),

  /// Desistente > Desistencia Temporária > Anulação de Inscrição
  registrationCancelled(6),

  /// Desistente > Desistencia Temporária > Suspenso
  suspended(7),

  /// Desistente > Desistencia Temporária > Prescrição
  expired(8),

  /// Desistente > Desistência Definitiva
  withdrawnPermanently(9),

  /// Desistente > Desistência Definitiva > Interrompido
  interrupted(10),

  /// Desistente > Desistência Definitiva > Anulação da Matrícula
  enrollmentCancelled(11),

  /// Desistente > Desistência Definitiva > Mudança de Curso
  changeOfCourse(12),

  /// Desistente > Desistência Definitiva > Permutado
  interchanged(13),

  /// Desistente > Desistência Definitiva > Recolocação
  placementChanged(14),

  /// Desistente > Desistência Definitiva > Reprovação
  failed(15),

  /// Desistente > Desistência Definitiva > Transferência
  transfer(16),

  /// Não Inscrito
  notRegistered(17),

  /// Não Inscrito > Prescrição 2ª vez
  expiredSecondTime(18),

  /// Não Inscrito > Suspensão prazo
  suspensionOfDeadline(19),

  /// Não Inscrito > Fim mobilidade
  endOfMobility(25),

  /// Não Inscrito > Fim de inscrição
  endOfEnrollment(26),

  /// Não Inscrito > Não concluído
  notCompleted(45),

  /// Não Inscrito > Transitou de Ciclo de Estudos
  changedStudyPlans(65),

  /// Não Inscrito > Estudante de Transição - Não Inscrito
  transitionStudentNotEnrolled(85);

  const GlobalStudentSearchEnrollmentStatus(this.value);

  final int value;

  int toJson() => value;
}

enum GlobalStudentSearchStudentType {
  /// Extraordinário
  x,

  /// Mobilidade
  m,

  /// Normal
  n;

  String toJson() => name.toUpperCase();
}

class GlobalStudentSearchParameters {
  GlobalStudentSearchParameters({
    this.instances,
    this.username,
    this.name,
    this.email,
    this.courseType,
    this.courseId,
    this.courseBranchId,
    this.enrollmentStatus,
    this.enrollmentFromYear,
    this.enrollmentUntilYear,
    this.firstEnrollmentFromYear,
    this.firstEnrollmentUntilYear,
    this.studentType,
    this.page = 1,
  }) {
    if (page < 1) {
      throw ArgumentError('page must be greater than or equal to 1');
    }
  }

  @JsonKey(name: 'pa_inst')
  final List<Instance>? instances;

  @JsonKey(name: 'pv_numero_de_estudante')
  final String? username;

  @JsonKey(name: 'pv_nome')
  final String? name;

  @JsonKey(name: 'pv_email')
  final String? email;

  @JsonKey(name: 'pv_tipo_de_curso')
  final GlobalStudentSearchCourseType? courseType;

  @JsonKey(name: 'pv_curso_id')
  final int? courseId;

  @JsonKey(name: 'pv_ramo_id')
  final int? courseBranchId;

  @JsonKey(name: 'pv_estado')
  final GlobalStudentSearchEnrollmentStatus? enrollmentStatus;

  @JsonKey(name: 'pv_em')
  final int? enrollmentFromYear;

  @JsonKey(name: 'pv_ate')
  final int? enrollmentUntilYear;

  @JsonKey(name: 'pv_1_inscricao_em')
  final int? firstEnrollmentFromYear;

  @JsonKey(name: 'pv_ate_2')
  final int? firstEnrollmentUntilYear;

  @JsonKey(name: 'pv_tipo')
  final GlobalStudentSearchStudentType? studentType;

  /// Each page has, at most, 20 results. Starts at 1.
  @JsonKey(includeToJson: false, includeFromJson: false)
  final int page;

  @JsonKey(name: 'pi_inicio')
  int get pageStart => (page - 1) * 20 + 1;

  Map<String, dynamic> serialize() {
    final instances = this.instances ?? Instance.allFaculties;

    return {
      'pa_inst': instances.map((instance) => instance).toList(),
    };
  }

  GlobalStudentSearchParameters copyWith({
    List<Instance>? instances,
    String? username,
    String? name,
    String? email,
    GlobalStudentSearchCourseType? courseType,
    int? courseId,
    int? courseBranchId,
    GlobalStudentSearchEnrollmentStatus? enrollmentStatus,
    int? enrollmentFromYear,
    int? enrollmentUntilYear,
    int? firstEnrollmentFromYear,
    int? firstEnrollmentUntilYear,
    GlobalStudentSearchStudentType? studentType,
    int? page,
  }) => GlobalStudentSearchParameters(
        instances: instances ?? this.instances,
        username: username ?? this.username,
        name: name ?? this.name,
        email: email ?? this.email,
        courseType: courseType ?? this.courseType,
        courseId: courseId ?? this.courseId,
        courseBranchId: courseBranchId ?? this.courseBranchId,
        enrollmentStatus: enrollmentStatus ?? this.enrollmentStatus,
        enrollmentFromYear: enrollmentFromYear ?? this.enrollmentFromYear,
        enrollmentUntilYear: enrollmentUntilYear ?? this.enrollmentUntilYear,
        firstEnrollmentFromYear: firstEnrollmentFromYear ?? this.firstEnrollmentFromYear,
        firstEnrollmentUntilYear: firstEnrollmentUntilYear ?? this.firstEnrollmentUntilYear,
        studentType: studentType ?? this.studentType,
        page: page ?? this.page,
      );
}
