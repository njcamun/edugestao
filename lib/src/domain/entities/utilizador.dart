enum Perfil { admin, superUser, geral, user }

class Utilizador {
  final String id;
  final String nome;
  final String email;
  final String? fotoUrl;
  final Perfil perfil;
  final bool ativo;

  Utilizador({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
    required this.perfil,
    this.ativo = true,
  });

  factory Utilizador.fromFirestore(Map<String, dynamic> data, String id) {
    return Utilizador(
      id: id,
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      fotoUrl: data['fotoUrl'],
      perfil: Perfil.values.firstWhere(
        (e) => e.name == (data['perfil'] ?? 'user'),
        orElse: () => Perfil.user,
      ),
      ativo: data['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'fotoUrl': fotoUrl,
      'perfil': perfil.name,
      'ativo': ativo,
      'updatedAt': DateTime.now(),
    };
  }

  // Métodos auxiliares de permissão
  bool get canManageUsers => perfil == Perfil.admin;
  bool get canViewReports => perfil == Perfil.admin || perfil == Perfil.superUser;
  bool get canViewFinance => perfil != Perfil.user;
  bool get canEditData => perfil != Perfil.user;
  bool get canDeletePermanently => perfil == Perfil.admin;
}
