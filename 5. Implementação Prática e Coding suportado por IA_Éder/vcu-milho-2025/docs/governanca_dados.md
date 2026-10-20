# Governança dos dados com agentes de IA

Tudo o que o agente lê (arquivos, saídas de comandos) é enviado ao serviço do modelo.

## Antes de abrir o agente em uma pasta com dados reais
- [ ] Conferi a política da instituição, os contratos e os termos de transferência de
      material (germoplasma, pedigree, marcadores de parceiros).
- [ ] Conferi os termos de uso do meu plano (individual, institucional ou API).
- [ ] Minimizei os dados: subconjuntos, IDs codificados, sem dados pessoais.
- [ ] Bloqueei pastas sensíveis com `Read(...)` em `deny` no `.claude/settings.json`.
- [ ] Não há senhas nem chaves em arquivos do projeto ou em prompts.
- [ ] Li os arquivos versionados de terceiros (`.claude/settings.json`, plugins,
      `.mcp.json`) antes de confiar neles: podem rodar comandos.

## Neste projeto
Os dados são simulados e podem ser usados com o agente. `data/bruto/` é protegido em
três camadas: somente leitura no sistema operacional, `deny` para `Edit` e Git.
