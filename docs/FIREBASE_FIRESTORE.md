# Firestore — coleções EDUCLASS

A sincronização automática (Android/Web) usa coleções de topo no Firestore. Cada documento deve ter o campo `id` igual ao ID do documento.

## Coleções principais

| Coleção | Descrição |
|---------|-----------|
| `alunos` | Cadastro de alunos |
| `turmas` | Turmas e salas |
| `anosLectivos` | Anos lectivos |
| `matriculas` | Matrículas |
| `mensalidades` | Propinas |
| `custos` | Custos e despesas |
| `configuracoes` | Dados da instituição |
| `funcionarios` | Funcionários |
| `salarios` | Folha salarial |
| `ativosInventario` | Inventário |
| `presencasFuncionarios` | Presenças (subcoleção lógica) |
| `manutencoesAtivo` | Manutenções de activos |
| `notasAvaliacao` | Notas por aluno/disciplina/trimestre |
| `horariosAula` | Aulas na grade horária |
| `notificacoesInternas` | Avisos internos (sincronizados entre dispositivos) |

## Campos — `notasAvaliacao`

- `alunoId`, `disciplina`, `trimestre` (1–3), `anoLectivo`, `valor` (0–20)
- `observacao` (opcional)
- `isDeleted`, `createdAt`, `updatedAt`, `createdBy`

## Campos — `notificacoesInternas`

- `titulo`, `mensagem`, `tipo`
- `entidadeRelacionada`, `entidadeId` (opcional)
- `lida` (boolean), `createdAt`

## Campos — `horariosAula`

- `turmaId`, `diaSemana` (1=Seg … 7=Dom), `horaInicio`, `horaFim` (texto `HH:mm`)
- `disciplina`, `professor` (opcional)
- `isDeleted`, `createdAt`, `updatedAt`, `createdBy`

## Regras de segurança (exemplo)

Ajuste ao seu modelo de autenticação. Exemplo mínimo para utilizadores autenticados:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{collection}/{docId} {
      allow read, write: if request.auth != null
        && collection in [
          'alunos', 'turmas', 'anosLectivos', 'matriculas', 'mensalidades',
          'custos', 'configuracoes', 'funcionarios', 'salarios',
          'ativosInventario', 'presencasFuncionarios', 'manutencoesAtivo',
          'notasAvaliacao', 'horariosAula', 'notificacoesInternas'
        ];
    }
  }
}
```

## Windows / offline

No desktop Windows, a app faz **upload** (`syncLocalToCloud`) mas não faz pull inicial automático. Use Android/Web para sincronização bidireccional completa.

Ver também: [FIREBASE_ANDROID.md](./FIREBASE_ANDROID.md) para SHA-1 e `google-services.json`.
