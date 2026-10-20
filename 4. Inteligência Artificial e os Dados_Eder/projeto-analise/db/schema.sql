-- Camada BRUTA do ensaio didático. Sem chave estrangeira de propósito:
-- o arquivo que chega do campo pode ter ID estranho, duplicata e valor inválido.
-- A prática não carrega uma camada curada neste banco. A curadoria grava CSV.

CREATE TABLE ambiente (
  ambiente_id TEXT PRIMARY KEY,
  local       TEXT NOT NULL,
  ano         INTEGER NOT NULL,
  safra       TEXT,
  latitude    DOUBLE,
  longitude   DOUBLE
);

CREATE TABLE ensaio (
  ensaio_id    TEXT PRIMARY KEY,
  ambiente_id  TEXT NOT NULL,
  delineamento TEXT,
  n_rep        INTEGER
);

CREATE TABLE bruto_germoplasma (
  germoplasma_id TEXT PRIMARY KEY,
  grupo          TEXT,
  origem         TEXT
);

CREATE TABLE variavel (
  variavel_id INTEGER PRIMARY KEY,
  codigo      TEXT NOT NULL,
  descricao   TEXT,
  unidade     TEXT,
  minimo      DOUBLE,
  maximo      DOUBLE
);

CREATE TABLE bruto_parcelas (
  parcela_id        TEXT,
  ensaio_id         TEXT,
  ambiente_id       TEXT,
  germoplasma_nome  TEXT,
  bloco             INTEGER,
  linha             INTEGER,
  coluna            INTEGER,
  PROD              VARCHAR,
  data_coleta       TEXT
);
