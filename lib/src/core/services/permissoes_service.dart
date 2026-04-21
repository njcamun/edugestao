import '../../domain/entities/utilizador.dart';

class PermissoesService {
  static bool podeGerirUtilizadores(Utilizador? user) => 
      user?.perfil == Perfil.admin;

  static bool podeApagarDadosCriticos(Utilizador? user) => 
      user?.perfil == Perfil.admin;

  static bool podeConfirmarPagamentos(Utilizador? user) => 
      user?.perfil != Perfil.user;

  static bool podeAlterarConfiguracoes(Utilizador? user) => 
      user?.perfil == Perfil.admin || user?.perfil == Perfil.superUser;
}
