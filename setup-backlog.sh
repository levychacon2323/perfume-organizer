#!/usr/bin/env bash
#
# setup-backlog.sh
# Cria labels, milestones e issues do MVP do Perfume Organizer no GitHub.
#
# Pré-requisitos:
#   - GitHub CLI instalado e autenticado (gh auth login)
#   - Executar a partir da raiz do repositório (ou ajustar REPO abaixo)
#
# Uso:
#   chmod +x setup-backlog.sh
#   ./setup-backlog.sh
#
# Idempotência: criar labels/milestones que já existem gera aviso mas não quebra.
# As issues SÃO recriadas a cada execução — rode apenas uma vez, ou comente os
# blocos de issue que já existirem.

set -euo pipefail

# ─────────────────────────────────────────────────────────────
# 0. Verificações
# ─────────────────────────────────────────────────────────────

if ! command -v gh &> /dev/null; then
  echo "Erro: GitHub CLI (gh) não encontrado. Instale com: brew install gh"
  exit 1
fi

if ! gh auth status &> /dev/null; then
  echo "Erro: não autenticado no gh. Rode: gh auth login"
  exit 1
fi

echo "==> Criando labels..."

# ─────────────────────────────────────────────────────────────
# 1. Labels
# ─────────────────────────────────────────────────────────────
# Função helper: cria label ignorando erro se já existe
create_label() {
  gh label create "$1" --color "$2" --description "$3" 2>/dev/null \
    && echo "  + label: $1" \
    || echo "  · label já existe: $1"
}

create_label "setup"          "0E8A16" "Configuração de ambiente e tooling"
create_label "design-system"  "D4C5F9" "Tokens, tipografia e componentes base"
create_label "feature"        "1D76DB" "Funcionalidade de produto"
create_label "database"       "5319E7" "Schema, migrations e repositories"
create_label "bug"            "D73A4A" "Algo não está funcionando"
create_label "chore"          "FEF2C0" "Manutenção, refactor, docs"
create_label "test"           "0E8A16" "Testes automatizados"

echo "==> Criando milestones..."

# ─────────────────────────────────────────────────────────────
# 2. Milestones
# ─────────────────────────────────────────────────────────────
# gh não tem comando nativo simples para milestones; usamos a API REST.
create_milestone() {
  gh api "repos/{owner}/{repo}/milestones" \
    -f title="$1" \
    -f description="$2" \
    --silent 2>/dev/null \
    && echo "  + milestone: $1" \
    || echo "  · milestone já existe (ou erro ignorado): $1"
}

create_milestone "Design System" "Tokens, tipografia Geist e componentes primitivos do Editorial Moderno"
create_milestone "Perfume CRUD"  "Cadastro manual, listagem, edição e detalhe de perfumes"
create_milestone "Catalog Search" "Catálogo bundled + busca fuzzy com Fuse.js"
create_milestone "Impressions"   "Diário de impressões datadas por perfume"
create_milestone "Wear Sessions" "Registro estruturado de uso (longevidade, projeção, sillage)"
create_milestone "Wishlist & Samples" "Lista de desejos e amostras/decants"
create_milestone "Tags & Polish" "Sistema de tags e refinamentos finais do MVP"

# Helper para pegar o número do milestone pelo título
milestone_number() {
  gh api "repos/{owner}/{repo}/milestones?state=all" \
    --jq ".[] | select(.title==\"$1\") | .number"
}

echo "==> Criando issues..."

# ─────────────────────────────────────────────────────────────
# 3. Issues
# ─────────────────────────────────────────────────────────────
# Helper: cria issue com título, corpo, labels e milestone
create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"
  local milestone="$4"

  gh issue create \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$milestone" \
    && echo "  + issue: $title"
}

# ===== MILESTONE: Design System =====

create_issue \
"Setup: instalar e carregar fonte Geist" \
"Instalar e configurar a fonte Geist (três pesos: 300, 400, 500) com carregamento via expo-font, segurando a splash até carregar.

## Definition of Done
- [ ] \`@expo-google-fonts/geist\`, \`expo-font\` e \`expo-splash-screen\` instalados
- [ ] Fonte carregada no \`_layout.tsx\` com useFonts
- [ ] App segura render até fonte + migrations estarem prontas
- [ ] Tela de loading enquanto carrega
- [ ] Tratamento de erro de carregamento

## Notas técnicas
- Pesos: Geist_300Light, Geist_400Regular, Geist_500Medium
- Integrar no mesmo gate que já roda as migrations do banco
- Sem peso 700 (Editorial Moderno usa 500 como hierarquia máxima)" \
"setup,design-system" \
"Design System"

create_issue \
"Tokens: configurar paleta Editorial Moderno no tailwind.config" \
"Formalizar os tokens de cor, tipografia e letter-spacing do Editorial Moderno no tailwind.config.js.

## Definition of Done
- [ ] Cores nomeadas: paper, bone, ash, stone, ink, vermilion
- [ ] Tokens semânticos: background, foreground, primary, muted, border, destructive
- [ ] fontFamily mapeando Geist (light/sans/medium)
- [ ] letterSpacing custom (tightest, tighter, tight, label)
- [ ] App ainda compila após mudança

## Notas técnicas
- vermilion (#8B3A2F) é acento ÚNICO — usar com parcimônia
- letter-spacing negativo em títulos, positivo em labels caps" \
"design-system" \
"Design System"

create_issue \
"Componente: Text" \
"Componente tipográfico base com variantes que encapsulam a hierarquia do Editorial Moderno.

## Definition of Done
- [ ] Variantes: display, heading, subheading, body, label, caption
- [ ] Usa cva para gerenciar variantes
- [ ] Aplica fonte, peso, tamanho, tracking e cor por variante
- [ ] Prop de cor opcional (default foreground)
- [ ] Tipado corretamente (sem any)
- [ ] Exportado de src/shared/ui/

## Notas técnicas
- display: Geist light, grande, tracking tightest
- label: caps, tracking label (0.2em), stone
- É a fundação de todos os outros componentes — capricha" \
"design-system" \
"Design System"

create_issue \
"Componente: Button" \
"Botão com três variantes do Editorial Moderno.

## Definition of Done
- [ ] Variantes: primary (ink), secondary (outline), ghost
- [ ] Tamanhos: sm, md, lg
- [ ] Estado disabled e loading
- [ ] Usa cva + Pressable
- [ ] Texto em caps com tracking (estilo editorial)
- [ ] Exportado de src/shared/ui/

## Notas técnicas
- primary: bg ink, texto paper
- secondary: transparente, borda ink
- ghost: sem borda, sem bg
- Cantos retos (border-radius 0 ou mínimo) combina com editorial" \
"design-system" \
"Design System"

create_issue \
"Componente: Input" \
"Campo de texto com label em caps e borda inferior, estilo editorial.

## Definition of Done
- [ ] Label em caps acima do campo
- [ ] Borda inferior (não box completo)
- [ ] Estado focused (borda ink)
- [ ] Estado de erro (borda vermilion + mensagem)
- [ ] Suporta placeholder, value, onChangeText
- [ ] forwardRef para uso com react-hook-form
- [ ] Exportado de src/shared/ui/

## Notas técnicas
- Vai ser usado com Controller do react-hook-form depois
- Borda inferior só: border-b, não border completo" \
"design-system" \
"Design System"

create_issue \
"Componente: Card" \
"Superfície contida com borda fina para agrupar conteúdo.

## Definition of Done
- [ ] Variantes: default (borda), flat (sem borda, bg bone)
- [ ] Padding configurável
- [ ] Aceita children
- [ ] Exportado de src/shared/ui/

## Notas técnicas
- Editorial usa bordas finas (1px ash) ou separação por linha
- Evitar sombras (não combina com o estilo)" \
"design-system" \
"Design System"

create_issue \
"Componente: Tag" \
"Chip para exibir notas olfativas e categorias.

## Definition of Done
- [ ] Variantes: filled (bg ink, texto paper), outline (borda ink)
- [ ] Tamanho compacto
- [ ] Texto em caps com tracking
- [ ] Opcional: onPress para tags interativas
- [ ] Exportado de src/shared/ui/

## Notas técnicas
- Usado na pirâmide olfativa (saída/coração/fundo)
- Cantos retos" \
"design-system" \
"Design System"

create_issue \
"Componente: Rating" \
"Indicador de avaliação em barras para longevidade, projeção e sillage.

## Definition of Done
- [ ] Exibe N barras preenchidas de um total (ex: 4/5)
- [ ] Variante read-only e interativa (seleção)
- [ ] Label opcional ao lado
- [ ] Exportado de src/shared/ui/

## Notas técnicas
- Barras horizontais finas (não estrelas) combinam com editorial
- Preenchida: ink. Vazia: ash" \
"design-system" \
"Design System"

create_issue \
"Tela de showcase dos componentes" \
"Tela temporária (rota de dev) que renderiza todos os componentes do design system para inspeção visual.

## Definition of Done
- [ ] Rota acessível em dev (ex: app/showcase.tsx)
- [ ] Mostra Text em todas as variantes
- [ ] Mostra Button em todas as variantes e tamanhos
- [ ] Mostra Input (normal, focused, erro)
- [ ] Mostra Card, Tag, Rating
- [ ] Serve como referência visual viva

## Notas técnicas
- Não precisa estar bonita, precisa ser completa
- Útil pra pegar inconsistências entre componentes" \
"design-system,chore" \
"Design System"

# ===== MILESTONE: Perfume CRUD =====

create_issue \
"DB: criar repository de perfumes" \
"Camada de abstração entre features e o Drizzle para a tabela perfumes.

## Definition of Done
- [ ] src/db/repositories/perfume-repository.ts criado
- [ ] Métodos: create, findAll, findById, update, softDelete
- [ ] findAll filtra deleted_at null
- [ ] Gera UUID no create
- [ ] Atualiza updated_at no update
- [ ] Tipado com os tipos inferidos do schema

## Notas técnicas
- Features NUNCA acessam db direto, sempre via repository
- softDelete seta deleted_at, não apaga a linha" \
"database,feature" \
"Perfume CRUD"

create_issue \
"Schema do formulário de perfume (zod)" \
"Schema de validação zod para o formulário de cadastro/edição de perfume.

## Definition of Done
- [ ] src/features/perfume/schemas/perfume-schema.ts
- [ ] Valida campos obrigatórios (name, brand, concentration, gender)
- [ ] Valida campos opcionais (year, bottleSizeMl, price, etc.)
- [ ] Mensagens de erro em português
- [ ] Exporta schema + tipo inferido (PerfumeFormData)

## Notas técnicas
- Usar com zodResolver no react-hook-form
- year: int, min 1900, max ano atual" \
"feature" \
"Perfume CRUD"

create_issue \
"Feature: formulário de cadastro de perfume" \
"Tela e formulário para cadastrar um perfume manualmente (sem catálogo ainda).

## Definition of Done
- [ ] Screen em src/features/perfume/screens/
- [ ] Usa react-hook-form + zodResolver
- [ ] Usa componentes do design system (Input, Button, etc.)
- [ ] Controller para inputs não-nativos
- [ ] Salva via perfume-repository
- [ ] Feedback de sucesso e erro
- [ ] index.ts exporta a screen

## Notas técnicas
- Primeira feature end-to-end: prova a stack inteira
- Cadastro manual; integração com catálogo vem depois" \
"feature" \
"Perfume CRUD"

create_issue \
"Feature: listagem do acervo" \
"Tela que lista os perfumes cadastrados, no estilo editorial (linhas, não cards).

## Definition of Done
- [ ] Screen de listagem em src/features/collection/
- [ ] Usa useLiveQuery para reatividade
- [ ] Itens separados por linha fina (estilo editorial)
- [ ] Mostra marca, nome, concentração, tamanho
- [ ] Ícone de favorito (vermilion quando ativo)
- [ ] Empty state quando não há perfumes
- [ ] Toca no item navega para detalhe

## Notas técnicas
- useLiveQuery atualiza a lista quando dados mudam
- Performance: usar FlashList se a lista crescer" \
"feature" \
"Perfume CRUD"

create_issue \
"Feature: tela de detalhe do perfume" \
"Tela que exibe todos os detalhes de um perfume do acervo.

## Definition of Done
- [ ] Screen de detalhe com rota dinâmica (app/perfume/[id])
- [ ] Header com nome, marca, concentração
- [ ] Seção de dados do frasco (tamanho, nível, compra)
- [ ] Botão de editar e de favoritar
- [ ] Botão de excluir (soft delete, com confirmação)
- [ ] Placeholder para impressões e sessões (features futuras)

## Notas técnicas
- Layout inspirado no moodboard Editorial Moderno
- Excluir = softDelete via repository" \
"feature" \
"Perfume CRUD"

create_issue \
"Feature: editar perfume" \
"Reutilizar o formulário de cadastro para edição de um perfume existente.

## Definition of Done
- [ ] Formulário pré-preenche com dados do perfume
- [ ] Salva via update do repository
- [ ] updated_at é atualizado
- [ ] Volta para o detalhe após salvar

## Notas técnicas
- Reaproveitar o componente de formulário do cadastro
- Detectar modo create vs edit por prop ou param de rota" \
"feature" \
"Perfume CRUD"

# ===== MILESTONE: Catalog Search =====

create_issue \
"Montar catálogo curado de perfumes (JSON)" \
"Criar o arquivo perfumes.json com catálogo curado de perfumes populares.

## Definition of Done
- [ ] src/catalog/data/perfumes.json com 100+ perfumes inicialmente
- [ ] Cada item segue o schema definido (id, name, brand, notas, etc.)
- [ ] Cobre masculinos, femininos, unissex, nicho e clássicos
- [ ] Dados curados manualmente (sem scraping)

## Notas técnicas
- Trabalho braçal: usar planilha e exportar pra JSON
- Pode começar com 100 e crescer
- Você é o domain expert aqui" \
"feature" \
"Catalog Search"

create_issue \
"Catálogo: tipos e validação zod" \
"Tipos TypeScript e validação zod para as entradas do catálogo.

## Definition of Done
- [ ] src/catalog/types.ts com tipo CatalogPerfume
- [ ] src/catalog/schema.ts com validação zod
- [ ] Valida o JSON no carregamento (catch erros de digitação)

## Notas técnicas
- Validar no boot evita dados malformados em runtime" \
"feature" \
"Catalog Search"

create_issue \
"Catálogo: store Zustand + carregamento" \
"Store que carrega o catálogo JSON em memória na inicialização.

## Definition of Done
- [ ] src/catalog/store.ts com Zustand
- [ ] Carrega perfumes.json na init
- [ ] Valida com zod ao carregar
- [ ] Expõe lista e estado de loading

## Notas técnicas
- Catálogo fica em memória, não no SQLite
- ~500 perfumes = ~200-400KB, carregamento instantâneo" \
"feature" \
"Catalog Search"

create_issue \
"Catálogo: busca fuzzy com Fuse.js" \
"Configurar Fuse.js para busca fuzzy no catálogo por nome e marca.

## Definition of Done
- [ ] src/catalog/search.ts configura Fuse.js
- [ ] Busca por name e brand
- [ ] Tolerância a erros de digitação ajustada
- [ ] Hook useCatalogSearch em catalog-search/hooks

## Notas técnicas
- Configurar threshold do Fuse pra equilibrar precisão/tolerância" \
"feature" \
"Catalog Search"

create_issue \
"Feature: tela de busca no catálogo" \
"Tela de busca que aparece ao adicionar perfume, com fallback para cadastro manual.

## Definition of Done
- [ ] Screen em src/features/catalog-search/screens/
- [ ] Search bar com resultados em tempo real
- [ ] Toca em resultado pré-preenche o formulário de cadastro
- [ ] Opção 'Não encontrei meu perfume' leva ao cadastro manual
- [ ] catalogId preenchido quando vem do catálogo, null quando manual

## Notas técnicas
- Integra com o formulário de cadastro já existente
- Fluxo: buscar → selecionar → pré-preencher → completar dados pessoais" \
"feature" \
"Catalog Search"

# ===== MILESTONE: Impressions =====

create_issue \
"DB: tabela e repository de impressions" \
"Adicionar a tabela impressions ao schema e criar seu repository.

## Definition of Done
- [ ] Tabela impressions no schema.ts (perfume_id, recorded_at, title, body, mood)
- [ ] Colunas de auditoria (created_at, updated_at, deleted_at)
- [ ] Migration gerada (pnpm db:generate)
- [ ] impression-repository.ts com CRUD
- [ ] findByPerfume retorna impressões de um perfume

## Notas técnicas
- recorded_at != created_at (evento vs inserção no banco)
- mood: enum love/like/neutral/dislike" \
"database,feature" \
"Impressions"

create_issue \
"Schema do formulário de impressão (zod)" \
"Schema zod para o formulário de nova impressão.

## Definition of Done
- [ ] src/features/impressions/schemas/
- [ ] Valida body (obrigatório), title e mood (opcionais)
- [ ] recorded_at default agora, editável
- [ ] Mensagens em português

## Notas técnicas
- body é o campo principal (texto livre)" \
"feature" \
"Impressions"

create_issue \
"Feature: adicionar e listar impressões" \
"Permitir adicionar impressões a um perfume e listá-las cronologicamente no detalhe.

## Definition of Done
- [ ] Formulário de nova impressão (react-hook-form + zod)
- [ ] Lista cronológica de impressões no detalhe do perfume
- [ ] Ordenadas por recorded_at desc
- [ ] Mostra data, título, corpo e mood
- [ ] Editar e excluir impressão (soft delete)

## Notas técnicas
- Integra na tela de detalhe do perfume
- Estilo timeline editorial (borda lateral)" \
"feature" \
"Impressions"

# ===== MILESTONE: Wear Sessions =====

create_issue \
"DB: tabela e repository de wear_sessions" \
"Adicionar a tabela wear_sessions ao schema e criar seu repository.

## Definition of Done
- [ ] Tabela wear_sessions (perfume_id, worn_at, occasion, weather, longevity, projection, sillage, etc.)
- [ ] Colunas de auditoria
- [ ] application_areas como JSON
- [ ] Migration gerada
- [ ] wear-session-repository.ts com CRUD
- [ ] findByPerfume

## Notas técnicas
- Muitos campos opcionais (usuário preenche o que quiser)
- Ratings: projection/sillage 1-5, overall 1-10" \
"database,feature" \
"Wear Sessions"

create_issue \
"Schema do formulário de sessão de uso (zod)" \
"Schema zod para registrar uma sessão de uso.

## Definition of Done
- [ ] src/features/wear-sessions/schemas/
- [ ] worn_at obrigatório, resto opcional
- [ ] Enums validados (occasion, season, weather)
- [ ] Ratings dentro dos ranges corretos
- [ ] Mensagens em português

## Notas técnicas
- Formulário longo mas quase tudo opcional" \
"feature" \
"Wear Sessions"

create_issue \
"Feature: registrar e listar sessões de uso" \
"Permitir registrar sessões de uso e exibir estatísticas no detalhe do perfume.

## Definition of Done
- [ ] Formulário de nova sessão (campos estruturados)
- [ ] Lista de sessões recentes no detalhe
- [ ] Resumo de stats (longevidade média, projeção média)
- [ ] Editar e excluir sessão

## Notas técnicas
- Stats: calcular médias via TanStack Query ou no repository
- UI inspirada no bloco de stats do moodboard" \
"feature" \
"Wear Sessions"

# ===== MILESTONE: Wishlist & Samples =====

create_issue \
"DB: tabela e repository de wishlist_items" \
"Adicionar a tabela wishlist_items e seu repository.

## Definition of Done
- [ ] Tabela wishlist_items (catalog_id, name, brand, priority, target_price, acquired_at)
- [ ] Colunas de auditoria
- [ ] Migration gerada
- [ ] wishlist-repository.ts com CRUD

## Notas técnicas
- acquired_at null = ainda desejado" \
"database,feature" \
"Wishlist & Samples"

create_issue \
"Feature: wishlist completa" \
"CRUD de lista de desejos com prioridade e preço-alvo.

## Definition of Done
- [ ] Tela de listagem da wishlist
- [ ] Adicionar item (com ou sem catálogo)
- [ ] Marcar como adquirido
- [ ] Prioridade visual (low/medium/high)
- [ ] Editar e remover

## Notas técnicas
- Pode reusar busca de catálogo pra adicionar item" \
"feature" \
"Wishlist & Samples"

create_issue \
"DB: tabela e repository de samples" \
"Adicionar a tabela samples e seu repository.

## Definition of Done
- [ ] Tabela samples (catalog_id, name, brand, size_ml, type, verdict, is_finished, etc.)
- [ ] Colunas de auditoria
- [ ] Migration gerada
- [ ] sample-repository.ts com CRUD

## Notas técnicas
- type: official_sample/decant/split
- verdict: full_bottle_worthy/like/pass" \
"database,feature" \
"Wishlist & Samples"

create_issue \
"Feature: samples e decants" \
"CRUD de amostras e decants, separado do acervo principal.

## Definition of Done
- [ ] Tela de listagem de amostras
- [ ] Adicionar amostra/decant
- [ ] Marcar como finalizada
- [ ] Registrar veredito (full bottle worthy, like, pass)
- [ ] Editar e remover

## Notas técnicas
- Lifecycle diferente do perfume (consumível)
- UX própria, não misturar com acervo" \
"feature" \
"Wishlist & Samples"

# ===== MILESTONE: Tags & Polish =====

create_issue \
"DB: tabelas e repository de tags" \
"Adicionar tabelas tags e perfume_tags (junction) e seu repository.

## Definition of Done
- [ ] Tabela tags (name, color)
- [ ] Tabela perfume_tags (perfume_id, tag_id)
- [ ] Colunas de auditoria em ambas
- [ ] Migration gerada
- [ ] tag-repository.ts com CRUD e associações

## Notas técnicas
- Relação N:N entre perfumes e tags via junction" \
"database,feature" \
"Tags & Polish"

create_issue \
"Feature: sistema de tags" \
"Permitir criar tags e associá-las a perfumes, com filtro por tag.

## Definition of Done
- [ ] Criar e gerenciar tags
- [ ] Associar/desassociar tags a um perfume
- [ ] Filtrar acervo por tag
- [ ] Tags exibidas no detalhe do perfume

## Notas técnicas
- Usar componente Tag do design system" \
"feature" \
"Tags & Polish"

create_issue \
"Testes: cobrir repositories e schemas zod" \
"Adicionar testes automatizados para a camada de dados e validação.

## Definition of Done
- [ ] Jest + React Native Testing Library configurados
- [ ] Testes dos repositories (CRUD, soft delete)
- [ ] Testes dos schemas zod (casos válidos e inválidos)
- [ ] Testes co-localizados com os arquivos fonte

## Notas técnicas
- Priorizar repositories e validação (maior risco)
- E2E com Maestro fica pra depois" \
"test,chore" \
"Tags & Polish"

create_issue \
"Polish: empty states, loading e tratamento de erro" \
"Revisar todas as telas garantindo empty states, loading e erros bem tratados.

## Definition of Done
- [ ] Toda lista tem empty state
- [ ] Toda ação async tem feedback de loading
- [ ] Erros são exibidos de forma amigável
- [ ] Confirmações em ações destrutivas

## Notas técnicas
- Consistência visual com o Editorial Moderno
- Passar a skill vercel-react-native-skills pra revisar UX" \
"chore" \
"Tags & Polish"

create_issue \
"Polish: README com screenshots e vídeo" \
"Finalizar o README do projeto com material visual para portfólio.

## Definition of Done
- [ ] Screenshots das telas principais
- [ ] GIF ou vídeo curto de demonstração
- [ ] Seção de decisões arquiteturais revisada
- [ ] Instruções de setup testadas do zero

## Notas técnicas
- Recrutador abre o README primeiro
- Atualizar CHANGELOG para a versão de release do MVP" \
"chore" \
"Tags & Polish"

echo ""
echo "==> Concluído! Issues, labels e milestones criados."
echo "    Veja em: gh issue list  ou  no GitHub Projects."
echo ""
echo "Próximo passo: criar um Project (board) e adicionar as issues."
echo "  gh project create --title 'Perfume Organizer MVP'"