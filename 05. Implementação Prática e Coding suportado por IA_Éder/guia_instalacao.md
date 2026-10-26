# Guia de instalação: VS Code, R, Git e Claude Code

Faça **antes da aula**. Leva de 30 a 60 minutos. Ao final, rode a verificação da seção 7
e traga o resultado. Comandos e telas conferidos em outubro de 2026 ⚙️: se algo estiver
diferente, consulte https://code.claude.com/docs/en/setup e
https://code.claude.com/docs/en/vs-code.

## 0. O que você precisa ter

- Computador com Windows 10 (versão 1809) ou mais recente, macOS 13 ou mais recente, ou
  Linux (Ubuntu 20.04+, Debian 10+); 4 GB de RAM ou mais; internet.
- **Conta com acesso ao Claude Code**: plano Pro, Max, Team ou Enterprise do Claude, ou
  conta do Claude Console (API). O plano gratuito do claude.ai **não** inclui o Claude
  Code. Confirme com o professor qual opção a turma vai usar (`docs/logistica.md`).
- Permissão para instalar programas na sua máquina (em computadores institucionais,
  fale com a TI antes).

## 1. Abrir um terminal

| Sistema | Como abrir | Como reconhecer |
|---|---|---|
| Windows | Menu Iniciar → "PowerShell" | O prompt começa com `PS C:\Users\...>` |
| macOS | Spotlight (`Cmd+Espaço`) → "Terminal" | Termina em `%` ou `$` |
| Linux | `Ctrl+Alt+T` ou o terminal da distribuição | Termina em `$` |

Para colar um comando: `Ctrl+V` no PowerShell; `Cmd+V` no macOS; `Ctrl+Shift+V` no
terminal do Linux. Depois, `Enter`.

## 2. VS Code

1. Baixe em https://code.visualstudio.com o instalador do seu sistema.
2. **Windows:** execute o instalador; marque "Adicionar ao PATH" e "Adicionar a ação
   'Abrir com Code' ao menu de contexto".
   **macOS:** arraste o aplicativo para Aplicativos. Depois, no VS Code, `Cmd+Shift+P` →
   "Shell Command: Install 'code' command in PATH".
   **Linux:** instale o `.deb` (Ubuntu/Debian) ou o `.rpm` (Fedora/RHEL).
3. Abra o VS Code. Confira em Help → About: versão **1.94 ou mais recente** (exigida
   pela extensão do Claude Code).

### Alternativas ao VS Code

| Editor | Quando escolher | Observação |
|---|---|---|
| **Positron** (https://positron.posit.co) | Você trabalha principalmente em R ou Python e quer console, visualizador de dados e gráficos integrados | Derivado do VS Code; instala extensões do Open VSX, onde a extensão do Claude Code pode estar defasada. O Claude Code no **terminal integrado** sempre funciona |
| **Cursor** (https://cursor.com) | Você já usa o Cursor | A extensão do Claude Code tem instalação oficial no Cursor. Evite usar o agente do Cursor e o Claude Code ao mesmo tempo na mesma pasta |
| **Antigravity** (Google) | Você já usa o Antigravity | Tem agentes próprios; use o Claude Code no terminal integrado |
| **RStudio** | Você não quer trocar de editor | Não há extensão; rode `claude` no Terminal do RStudio |

Na aula, o professor usa o **VS Code**. Os princípios valem para todos.

## 3. R e o suporte ao R no VS Code

1. Instale o R (versão 4.3 ou mais recente) em https://cran.r-project.org.
   **Windows:** durante a instalação, mantenha marcada a opção de salvar a versão no
   registro. Instale também o **Rtools** da mesma versão do R.
2. No R:
   ```r
   install.packages(c("languageserver", "httpgd", "lme4", "yaml", "testthat"))
   ```
3. No VS Code: `Ctrl+Shift+X` (`Cmd+Shift+X` no Mac) → procure **R** (identificador
   `REditorSupport.r`) → Install.
4. Teste: crie `teste.R` com `print(1 + 1)`, selecione a linha e pressione
   `Ctrl+Enter`: o resultado aparece no terminal do R.

## 4. Git

- **Windows:** instale o **Git for Windows** (https://git-scm.com/downloads/win). Ele
  traz o Git Bash, que o Claude Code usa para rodar comandos no Windows.
- **macOS:** no terminal, `git --version`; se não estiver instalado, o sistema oferece
  instalar as ferramentas de linha de comando.
- **Linux:** `sudo apt install git` (Ubuntu/Debian) ou `sudo dnf install git`.

Configure seu nome e e-mail uma única vez:
```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@ufv.br"
```

## 5. Claude Code (linha de comando) ⚙️

Instalador nativo recomendado (atualiza sozinho). **Não** precisa de administrador.

| Sistema | Comando |
|---|---|
| macOS, Linux, WSL | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Windows PowerShell | `irm https://claude.ai/install.ps1 \| iex` |
| Windows CMD | `curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd` |

Alternativas: `brew install --cask claude-code` (macOS, Homebrew) ou
`winget install Anthropic.ClaudeCode` (Windows); essas duas **não** atualizam sozinhas.

Depois da instalação, **feche e abra o terminal** e rode:
```bash
claude --version    # deve imprimir um número de versão
claude doctor       # diagnóstico; não deve haver erros
```

Problemas comuns:
- `claude: command not found` / "não é reconhecido": o terminal ainda não vê a pasta
  de instalação. Feche e abra o terminal; se persistir, veja "Fix your PATH" em
  https://code.claude.com/docs/en/troubleshoot-install.
- `'irm' não é reconhecido`: você está no CMD, não no PowerShell (use o comando do CMD).
- `The token '&&' is not a valid statement separator`: você está no PowerShell, não no CMD.

## 6. Primeiro login e a extensão do VS Code ⚙️

1. No terminal, em qualquer pasta, rode `claude`. O navegador abre para login com a
   conta da turma. Se não abrir, pressione `c` para copiar o endereço e cole no navegador.
   Ao final, o terminal mostra `Login successful`. Saia com `/exit`.
2. No VS Code: `Ctrl+Shift+X` → procure **Claude Code** (publicado pela **Anthropic**)
   → Install.
3. Abra uma pasta qualquer (File → Open Folder), abra um arquivo e clique no ícone ✻
   (Spark) no canto superior direito do editor. Clique em **Sign in** e conclua no
   navegador. Aparece uma lista "Learn Claude Code": pode percorrê-la ou fechá-la.
4. Na caixa de prompt, digite `/status`: aparecem a versão, a conta e o modelo.

> A extensão traz uma cópia própria do Claude Code para o painel, mas **não** coloca o
> comando `claude` no terminal. Por isso a instalação da seção 5 é necessária.

## 7. Verificação final

Clone o repositório do curso e rode:
```bash
Rscript setup/verificar_instalacao.R
```
Todas as linhas devem mostrar `[ ok ]`. Traga um print da saída e do `/status`.

## 8. Antes da aula

- Leia `docs/governanca_dados.md`.
- Não abra o Claude Code em pastas com dados confidenciais até a aula sobre permissões.
- Se algo falhar, anote a mensagem de erro exata e traga para a sessão de suporte.
