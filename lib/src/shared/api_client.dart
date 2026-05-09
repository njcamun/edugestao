import 'package:dio/dio.dart';

class LoginUserDto {
  final String id;
  final String email;
  final String name;
  final String role;

  LoginUserDto({required this.id, required this.email, required this.name, required this.role});

  factory LoginUserDto.fromJson(Map<String, dynamic> json) => LoginUserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
  );
}

class LoginResponseDto {
  final String accessToken;
  final String refreshToken;
  final LoginUserDto user;

  LoginResponseDto({required this.accessToken, required this.refreshToken, required this.user});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => LoginResponseDto(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    user: LoginUserDto.fromJson(json['user'] as Map<String, dynamic>),
  );
}

class StudentDto {
  final String id;
  final String fullName;
  final String? phone;
  final String? gender;
  final bool isActive;

  StudentDto({required this.id, required this.fullName, this.phone, this.gender, required this.isActive});

  factory StudentDto.fromJson(Map<String, dynamic> json) => StudentDto(
    id: json['id'] as String,
    fullName: json['fullName'] as String,
    phone: json['phone'] as String?,
    gender: json['gender'] as String?,
    isActive: json['isActive'] as bool? ?? true,
  );
}

class PaginatedStudentsDto {
  final List<StudentDto> items;
  final int total;
  final int page;
  final int pageSize;

  PaginatedStudentsDto({required this.items, required this.total, required this.page, required this.pageSize});

  factory PaginatedStudentsDto.fromJson(Map<String, dynamic> json) => PaginatedStudentsDto(
    items: (json['items'] as List).map((e) => StudentDto.fromJson(e as Map<String, dynamic>)).toList(),
    total: json['total'] as int,
    page: json['page'] as int,
    pageSize: json['pageSize'] as int,
  );
}

class AcademicYearDto {
  final String id;
  final String year;
  final bool isActive;

  AcademicYearDto({required this.id, required this.year, required this.isActive});

  factory AcademicYearDto.fromJson(Map<String, dynamic> json) => AcademicYearDto(
    id: json['id'] as String,
    year: json['year'] as String,
    isActive: json['isActive'] as bool,
  );
}

class SchoolClassDto {
  final String id;
  final String name;
  final String academicYearId;
  final Map<String, dynamic>? gradeLevel;

  SchoolClassDto({required this.id, required this.name, required this.academicYearId, this.gradeLevel});

  factory SchoolClassDto.fromJson(Map<String, dynamic> json) => SchoolClassDto(
    id: json['id'] as String,
    name: json['name'] as String,
    academicYearId: json['academicYearId'] as String,
    gradeLevel: json['gradeLevel'] as Map<String, dynamic>?,
  );
}

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000'),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        handler.next(e);
      },
    ));
  }

  void setAccessToken(String? token) {
    if (token == null) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Auth
  Future<LoginResponseDto> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return LoginResponseDto.fromJson(res.data as Map<String, dynamic>);
  }

  // Students
  Future<PaginatedStudentsDto> listStudents({String? q, int page = 1, int pageSize = 20}) async {
    try {
      final res = await _dio.get('/students', queryParameters: {'q': q, 'page': page, 'pageSize': pageSize});
      return PaginatedStudentsDto.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      return PaginatedStudentsDto(items: [], total: 0, page: 1, pageSize: 20);
    }
  }

  Future<StudentDto> createStudent(Map<String, dynamic> data) async {
    final res = await _dio.post('/students', data: data);
    return StudentDto.fromJson(res.data as Map<String, dynamic>);
  }

  // Academic Years
  Future<List<AcademicYearDto>> listAcademicYears() async {
    try {
      final res = await _dio.get('/academic-years');
      return (res.data as List).map((e) => AcademicYearDto.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [AcademicYearDto(id: "1", year: "2025 (Local)", isActive: true)];
    }
  }

  // School Classes
  Future<List<SchoolClassDto>> listClasses({String? academicYearId}) async {
    try {
      final res = await _dio.get('/school-classes', queryParameters: {'academicYearId': academicYearId});
      return (res.data as List).map((e) => SchoolClassDto.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  // Enrollments
  Future<List<dynamic>> listEnrollments({String? academicYearId}) async {
    try {
      final res = await _dio.get('/enrollments', queryParameters: {'academicYearId': academicYearId});
      return res.data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> enrollStudent(String studentId, String schoolClassId, String academicYearId) async {
    final res = await _dio.post('/enrollments', data: {
      'studentId': studentId,
      'schoolClassId': schoolClassId,
      'academicYearId': academicYearId,
    });
    return res.data;
  }

  // Finance
  Future<Map<String, dynamic>> getFinanceStats() async {
    try {
      final res = await _dio.get('/finance/dashboard');
      return res.data as Map<String, dynamic>;
    } catch (e) {
      return {'totalRevenue': 0.0, 'pendingAmount': 0.0, 'paidInvoices': 0};
    }
  }

  Future<List<dynamic>> listInvoices({String? enrollmentId}) async {
    try {
      final res = await _dio.get('/finance/invoices', queryParameters: {'enrollmentId': enrollmentId});
      return res.data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<void> createPayment(Map<String, dynamic> data) async {
    await _dio.post('/finance/payments', data: data);
  }

  // Reports (Boletim)
  Future<List<int>> getReportCardPdf(String enrollmentId) async {
    final res = await _dio.get(
      '/reports/report-card/$enrollmentId',
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data as List<int>;
  }
}
