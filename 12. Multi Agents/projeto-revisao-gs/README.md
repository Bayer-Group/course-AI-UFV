# Projeto — Mini-revisão multi-agente (seleção genômica)

Prática da sessão 12. Em ~60 minutos, o **aluno é o escritor**: produz um esboço curto sobre a evolução da seleção genômica, recebe parecer do **orientador**, decide se envia ao painel de **três revisores**, e (se preciso) itera até 3 rodadas.

Não é uma revisão formal para publicação.

## Como abrir

Abra **esta pasta** (`projeto-revisao-gs`) como projeto no Cursor ou no Claude Code. Não abra a pasta `12. Multi Agents` inteira.

## Arquivos-guia

| Arquivo | Uso |
| --- | --- |
| [MISSAO.md](MISSAO.md) | Tema, estrutura e limites do texto |
| [PLANO.md](PLANO.md) | Rodadas 1–3 e critérios |
| [CLAUDE.md](CLAUDE.md) | Regras para todos os agentes |
| [roteiro_aula.md](roteiro_aula.md) | Cronograma e **um** prompt que orquestra o fluxo |
| [referencias/README.md](referencias/README.md) | Lista fechada de citações |

## Agentes

Em `.claude/agents/`:

- `escritor` — redige/revisa o rascunho
- `orientador` — parecer (não edita o texto)
- `revisor-gq` — genética quantitativa
- `revisor-melhoramento` — métodos de melhoramento
- `revisor-molecular` — genética molecular / germoplasma

## Fluxo resumido

Cole o prompt único de [roteiro_aula.md](roteiro_aula.md): escritor → orientador → **gate do aluno** (`ENVIAR` / `REESCREVER`) → três revisores → consolidação (≥ 2 de 3). Máx. 3 rodadas.

## Limpeza

Para recomeçar a demo:

```powershell
.\limpeza.ps1
```
