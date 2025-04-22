-- Membros: Ana Clara Maiberg, [*CADA UM ADICIONAR SEU NOME COMPLETO*]
-- Proposta 1 - Banco de Dados de Gestão de Biblioteca


--Criação de tabelas

CREATE TABLE Livros (
    livroID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    titulo VARCHAR2(100) NOT NULL,
    editora VARCHAR2(50),
    anoPublicação DATE,
    categoria VARCHAR2(50),
    status CHAR(15) DEFAULT 'Disponível' NOT NULL
    	CONSTRAINT ck_livros_status CHECK (status in ('Disponível', 'Emprestado', 'Descontinuado', 'Extraviado')),
    CONSTRAINT pk_livros PRIMARY KEY (livroID)
);

CREATE TABLE Autores (
    autorID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    dataNascimento DATE,
    nacionalidade VARCHAR2(50),
    CONSTRAINT pk_autores PRIMARY KEY (autorID)
);

CREATE TABLE LivrosAutores (
    livroID NUMBER NOT NULL,
    autorID NUMBER NOT NULL,
    CONSTRAINT pk_livros_autores PRIMARY KEY (livroID, autorID),
    CONSTRAINT fk_livro_id FOREIGN KEY (livroID) REFERENCES Livros(livroID),
    CONSTRAINT fk_autor_id FOREIGN KEY (autorID) REFERENCES Autores(autorID) 
);

CREATE TABLE Usuarios (
    usuarioID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(100),
    telefone CHAR(15) NOT NULL,
    email VARCHAR2(50),
    CONSTRAINT pk_usuarios PRIMARY KEY (usuarioID)
);

CREATE TABLE Emprestimos (
    emprestimoID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    usuarioID NUMBER NOT NULL,
    livroID NUMBER NOT NULL,
    dataEmprestimo DATE NOT NULL,
    dataDevolucao DATE NOT NULL,
    status CHAR(10) DEFAULT 'Pendente' NOT NULL
    	CONSTRAINT ck_emprestimos_status CHECK (status in ('Pendente', 'Finalizado')),
    CONSTRAINT pk_emprestimos PRIMARY KEY (emprestimoID)
);

CREATE TABLE Reservas (
    reservaID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL,
    usuarioID NUMBER NOT NULL,
    livroID NUMBER NOT NULL,
    dataReserva DATE NOT NULL,
    status CHAR(10) DEFAULT 'Pendente' NOT NULL
    	CONSTRAINT ck_reservas_status CHECK (status in ('Pendente', 'Finalizado', 'Cancelado')),
    CONSTRAINT pk_reservas PRIMARY KEY (reservaID)
);


--Inserções na tabela Livros

INSERT INTO Livros (titulo, editora, anoPublicação, categoria, status) 
VALUES ('O Pequeno Príncipe', 'Petit', TO_DATE('01/01/1943', 'DD/MM/YYYY'), 'Infantojuvenil', 'Disponível');

INSERT INTO Livros (titulo, editora, anoPublicação, categoria, status) 
VALUES ('A Menina Que Roubava Livros', 'WWII', TO_DATE('01/01/2001', 'DD/MM/YYYY'), 'Trauma', 'Extraviado');

INSERT INTO Livros (titulo, editora, anoPublicação, categoria, status) 
VALUES ('Percy Jackson', 'Uncle Rick', TO_DATE('29/03/2006', 'DD/MM/YYYY'), 'Infantojuvenil', 'Disponível');

INSERT INTO Livros (titulo, editora, anoPublicação, categoria, status) 
VALUES ('Os Heróis do Olimpo', 'Uncle Rick', TO_DATE('05/01/2015', 'DD/MM/YYYY'), 'Infantojuvenil', 'Emprestado');

INSERT INTO Livros (titulo, editora, anoPublicação, categoria, status) 
VALUES ('A Arte de Ligar o Foda-se', 'esadof', TO_DATE('01/12/2020', 'DD/MM/YYYY'), 'Auto-ajuda', 'Descontinuado');


--Inserções na tabela Autores

INSERT INTO Autores (nome, dataNascimento, nacionalidade) 
VALUES ('Antoine de Saint-Exupéry', TO_DATE('01/01/1900', 'DD/MM/YYYY'), 'Francesa');

INSERT INTO Autores (nome, dataNascimento, nacionalidade) 
VALUES ('Markus Zusak', TO_DATE('15/05/1975', 'DD/MM/YYYY'), 'Australiana');

INSERT INTO Autores (nome, dataNascimento, nacionalidade) 
VALUES ('Jane Austen', TO_DATE('01/10/1775', 'DD/MM/YYYY'), 'Inglesa');

INSERT INTO Autores (nome, dataNascimento, nacionalidade) 
VALUES ('Rick Riordan', TO_DATE('20/01/1964', 'DD/MM/YYYY'), 'Estadunidense');

INSERT INTO Autores (nome, dataNascimento, nacionalidade) 
VALUES ('Mark Manson', TO_DATE('22/02/1984', 'DD/MM/YYYY'), 'Norte-americano');


--Inserções na tabela LivrosAutores

INSERT INTO LivrosAutores (livroID, autorID) VALUES (1, 1); 

INSERT INTO LivrosAutores (livroID, autorID) VALUES (2, 2); 

INSERT INTO LivrosAutores (livroID, autorID) VALUES (3, 4); 

INSERT INTO LivrosAutores (livroID, autorID) VALUES (4, 4); 

INSERT INTO LivrosAutores (livroID, autorID) VALUES (5, 5); 


--Inserções na tabela Usuarios

INSERT INTO Usuarios (nome, endereco, telefone, email) 
VALUES ('Ana Clara', 'Rua das Rosas, 123', '11999990001', 'ana.clara@email.com');

INSERT INTO Usuarios (nome, endereco, telefone, email) 
VALUES ('Aline Souza', 'Av. Brasil, 456', '21988887777', 'aline.souza@email.com');

INSERT INTO Usuarios (nome, endereco, telefone, email) 
VALUES ('Jonathan Silva', 'Rua do Sol, 789', '31977776666', 'jonathan.silva@email.com');

INSERT INTO Usuarios (nome, endereco, telefone, email) 
VALUES ('Isis Carvalho', 'Travessa da Paz, 321', '41966665555', 'isis.carvalho@email.com');

INSERT INTO Usuarios (nome, endereco, telefone, email) 
VALUES ('Rafael Martins', 'Alameda Santos, 1001', '51955554444', 'rafael.martins@email.com');


--Inserções na tabela Emprestimos

INSERT INTO Emprestimos (usuarioID, livroID, dataEmprestimo, dataDevolucao, status) 
VALUES (1, 3, TO_DATE('01/04/2025', 'DD/MM/YYYY'), TO_DATE('10/04/2025', 'DD/MM/YYYY'), 'Finalizado');

INSERT INTO Emprestimos (usuarioID, livroID, dataEmprestimo, dataDevolucao, status) 
VALUES (2, 4, TO_DATE('02/04/2025', 'DD/MM/YYYY'), TO_DATE('12/04/2025', 'DD/MM/YYYY'), 'Pendente');

INSERT INTO Emprestimos (usuarioID, livroID, dataEmprestimo, dataDevolucao, status) 
VALUES (3, 1, TO_DATE('03/04/2025', 'DD/MM/YYYY'), TO_DATE('13/04/2025', 'DD/MM/YYYY'), 'Finalizado');

INSERT INTO Emprestimos (usuarioID, livroID, dataEmprestimo, dataDevolucao, status) 
VALUES (4, 5, TO_DATE('04/04/2025', 'DD/MM/YYYY'), TO_DATE('14/04/2025', 'DD/MM/YYYY'), 'Finalizado');

INSERT INTO Emprestimos (usuarioID, livroID, dataEmprestimo, dataDevolucao, status) 
VALUES (5, 2, TO_DATE('05/04/2025', 'DD/MM/YYYY'), TO_DATE('15/04/2025', 'DD/MM/YYYY'), 'Pendente');


--Inserções na tabela Reservas

INSERT INTO Reservas (usuarioID, livroID, dataReserva, status) 
VALUES (1, 2, TO_DATE('01/04/2025', 'DD/MM/YYYY'), 'Cancelado');

INSERT INTO Reservas (usuarioID, livroID, dataReserva, status) 
VALUES (2, 1, TO_DATE('02/04/2025', 'DD/MM/YYYY'), 'Finalizado');

INSERT INTO Reservas (usuarioID, livroID, dataReserva, status) 
VALUES (3, 5, TO_DATE('03/04/2025', 'DD/MM/YYYY'), 'Pendente');

INSERT INTO Reservas (usuarioID, livroID, dataReserva, status) 
VALUES (4, 3, TO_DATE('04/04/2025', 'DD/MM/YYYY'), 'Finalizado');

INSERT INTO Reservas (usuarioID, livroID, dataReserva, status) 
VALUES (5, 4, TO_DATE('05/04/2025', 'DD/MM/YYYY'), 'Pendente');
