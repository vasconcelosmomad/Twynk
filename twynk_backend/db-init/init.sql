-- ============================================================
-- BANCO DE DADOS: app_namoro_mz
-- ============================================================
CREATE DATABASE IF NOT EXISTS app_namoro_mz CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE app_namoro_mz;

-- ============================================================
-- 💳 Tabela: planos
-- ============================================================
CREATE TABLE planos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  descricao TEXT,
  duracao ENUM('gratuito','semanal','quinzenal','mensal') NOT NULL,
  preco DECIMAL(10,2) DEFAULT 0,
  ativo BOOLEAN DEFAULT TRUE
);

-- Inserindo planos padrão (valores em Meticais 🇲🇿)
INSERT INTO planos (nome, descricao, duracao, preco) VALUES
('Gratuito', 'Plano básico com acesso limitado', 'gratuito', 0),
('Semanal', 'Acesso completo por 7 dias', 'semanal', 35.00),
('Quinzenal', 'Acesso completo por 15 dias', 'quinzenal', 85.00),
('Mensal', 'Acesso completo por 30 dias', 'mensal', 110.00);

-- ============================================================
-- 💎 Tabela: beneficios_plano
-- ============================================================
CREATE TABLE beneficios_plano (
  id INT AUTO_INCREMENT PRIMARY KEY,
  plano_id INT NOT NULL,
  curtidas_dia INT DEFAULT 0,
  mensagens_dia INT DEFAULT 0,
  video_tempo_min INT DEFAULT 0,
  boost_semana INT DEFAULT 0,
  pode_chat BOOLEAN DEFAULT FALSE,
  pode_video BOOLEAN DEFAULT FALSE,
  ver_quem_curtiu BOOLEAN DEFAULT FALSE,
  enviar_fotos BOOLEAN DEFAULT FALSE,
  creditos_iniciais DECIMAL(10,2) DEFAULT 0,
  suporte_prioritario BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (plano_id) REFERENCES planos(id) ON DELETE CASCADE
);

-- ============================================================
-- 🧍 Tabela: usuarios
-- ============================================================
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  genero ENUM('masculino','feminino','outro') NOT NULL,
  interesse ENUM('masculino','feminino','ambos') DEFAULT 'ambos',
  data_nascimento DATE,
  email VARCHAR(100) UNIQUE NOT NULL,
  senha VARCHAR(255) NOT NULL,
  foto_perfil VARCHAR(255),
  bio TEXT,
  localizacao VARCHAR(100),
  status ENUM('online','offline') DEFAULT 'offline',
  plano_id INT DEFAULT NULL,
  data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (plano_id) REFERENCES planos(id)
);

-- ============================================================
-- 🧾 Tabela: assinaturas
-- ============================================================
CREATE TABLE assinaturas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  plano_id INT NOT NULL,
  data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_fim TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (plano_id) REFERENCES planos(id) ON DELETE CASCADE
);

-- ============================================================
-- 🪙 Tabela: creditos
-- ============================================================
CREATE TABLE creditos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  saldo DECIMAL(10,2) DEFAULT 0,
  ultimo_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- 💳 Tabela: transacoes
-- ============================================================
CREATE TABLE transacoes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  plano_id INT,
  valor_pago DECIMAL(10,2) NOT NULL,
  metodo_pagamento ENUM('mpesa','emola','paypal','stripe','outro') DEFAULT 'mpesa',
  data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pago','pendente','falhou') DEFAULT 'pago',
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (plano_id) REFERENCES planos(id)
);

-- ============================================================
-- 💖 Tabela: likes
-- ============================================================
CREATE TABLE likes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario_origem INT NOT NULL,
  id_usuario_destino INT NOT NULL,
  data_like TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_usuario_origem) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (id_usuario_destino) REFERENCES usuarios(id) ON DELETE CASCADE,
  UNIQUE(id_usuario_origem, id_usuario_destino)
);

-- ============================================================
-- 💬 Tabela: mensagens (não em tempo real)
-- ============================================================
CREATE TABLE mensagens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  remetente_id INT NOT NULL,
  destinatario_id INT NOT NULL,
  conteudo TEXT NOT NULL,
  lida BOOLEAN DEFAULT FALSE,
  data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (remetente_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (destinatario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- ⚡ Tabela: chat_mensagem (tempo real)
-- ============================================================
CREATE TABLE chat_mensagem (
  id INT AUTO_INCREMENT PRIMARY KEY,
  chat_id VARCHAR(100) NOT NULL,
  remetente_id INT NOT NULL,
  destinatario_id INT NOT NULL,
  tipo ENUM('texto','imagem','audio','video') DEFAULT 'texto',
  conteudo TEXT,
  data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (remetente_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (destinatario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- 🎥 Tabela: solicitacoes_chat
-- ============================================================
CREATE TABLE solicitacoes_chat (
  id INT AUTO_INCREMENT PRIMARY KEY,
  solicitante_id INT NOT NULL,
  solicitado_id INT NOT NULL,
  tipo ENUM('chat','video') NOT NULL,
  status ENUM('pendente','aceito','recusado') DEFAULT 'pendente',
  data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (solicitante_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (solicitado_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- 📷 Tabela: fotos
-- ============================================================
CREATE TABLE fotos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  url_foto VARCHAR(255) NOT NULL,
  descricao VARCHAR(255),
  data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- 📝 Tabela: status_publicacoes
-- ============================================================
CREATE TABLE status_publicacoes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  texto TEXT,
  imagem_url VARCHAR(255),
  data_publicacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- 👁️ Tabela: visualizacoes
-- (quem viu o perfil de quem)
-- ============================================================
CREATE TABLE visualizacoes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_visualizador INT NOT NULL,
  id_visualizado INT NOT NULL,
  data_visualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_visualizador) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (id_visualizado) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ============================================================
-- EXEMPLO DE USUÁRIO INICIAL (Admin)
-- ============================================================
INSERT INTO usuarios (nome, genero, interesse, data_nascimento, email, senha, localizacao, status)
VALUES ('Admin', 'masculino', 'feminino', '1990-01-01', 'admin@appnamoro.mz', '123456', 'Maputo', 'offline');
