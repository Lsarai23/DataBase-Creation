-- Observação: Os códigos foram feitos no MySQL Workbench, com o uso do app XAMPP para conexão com os servidores Apache e MySQL

-- Criando banco de dados
create database condominio 
default character set utf8
default collate utf8_general_ci;

-- Selecionando o banco
use condominio;

-- 1) Item 1 -> Feito em PDF

-- 2) Criação e adição de valores às tabelas

-- Criando as entidades
create table apartamento
( id_apto smallint unsigned,
  numero_andar tinyint unsigned not null check(numero_andar > 0),
  telefone_fixo varchar(11) unique not null check (telefone_fixo != ""),
  primary key(id_apto)
);

-- Após criar a tabela, adicionar uma checagem que garante que o apartamento está no andar correto
-- Essa validação não foi adicionada no momento da criação, pois pela ordem de criação das colunas, 
-- ela não foi aceita naquele momento.
alter table apartamento change column id_apto id_apto smallint unsigned check(floor(id_apto / 10) = numero_andar);

create table morador
( cpf varchar(20) check (cpf != ""),
  nome varchar(30) not null check (nome != ""),
  idade tinyint unsigned not null check(idade > 0),
  id_apto smallint unsigned not null,
  ehSindico enum('S','N') default 'N' not null,
  primary key(cpf),
  foreign key(id_apto) references apartamento(id_apto)
);

create table area_de_Lazer
( id_espaco tinyint unsigned auto_increment,
  nome_espaco varchar(30) not null check (nome_espaco != ""),
  primary key(id_espaco)
);

create table veiculo
( placa varchar(10) check (placa != ""),
  id_apto smallint unsigned not null,
  primary key(placa),
  foreign key(id_apto) references apartamento(id_apto)
);

create table deposito
( id_deposito smallint unsigned auto_increment,
  id_apto smallint unsigned not null,
  primary key(id_deposito),
  foreign key(id_apto) references apartamento(id_apto) 
);

create table vaga
( id_vaga smallint unsigned check(id_vaga > 0),
  id_apto smallint unsigned not null,
  primary key(id_vaga),
  foreign key(id_apto) references apartamento(id_apto) 
);

create table morAlazer
( cpf varchar(20),
  id_espaco tinyint unsigned,
  primary key(cpf,id_espaco),
  foreign key(cpf) references morador(cpf)
);


-- Adicionando valores
insert into apartamento 
values(31, 3, '2833-1221'),
       (54, 5, '3614-3171'),
       (41, 4, '3232-5114'),
       (82, 8, '2164-5584'),
       (122, 12, '2541-3181');

insert into morador values
	   ('078.672.160-06', 'João', 40, 31, 'N'),
       ('274.140.630-89', 'Maria', 35, 31,'N'),
       ('615.116.120-37', 'José', 42, 41,'N'),
       ('509.338.780-01', 'Paulo', 53, 82,'N'),
       ('068.730.490-34', 'Roberto', 44, 122, 'S'),
       ('201.419.360-61', 'Leonardo', 30, 54,'N');
       
insert into area_de_lazer (nome_espaco)
values ('quadra'),
	   ('quadra'),
       ('salão de festa'),
       ('sala de jogos'),
       ('parquinho'),
       ('parquinho');
       
insert into deposito(id_apto) 
values (31),
       (54),
       (41),
       (82),
       (122);

insert into veiculo
values ('GXX-6679', 31),
	   ('LTV-3213', 54),
       ('SDF-3435', 54),
       ('HLF-35456', 41),
       ('MTM-7580', 82),
       ('DFG-1234', 82),
       ('MZW-8347', 122);
       
insert into vaga 
values (5, 31),
       (20, 54),
       (21,54),
       (3, 41),
       (36,82),
       (37, 82),
       (33, 122),
       (34, 122);

       
insert into morAlazer
values ('078.672.160-06', 1),
       ('274.140.630-89', 1),
       ('615.116.120-37', 3),
       ('509.338.780-01', 3),
       ('068.730.490-34', 4),
       ('201.419.360-61', 5);

-- 3) Tabelas no PDF
select * from apartamento;
select * from area_de_lazer;
select * from deposito;
select * from morador;
select * from moralazer;
select * from veiculo;

-- 4) Fazendo seleções

-- 4.1) INNER JOIN de 2 tabelas: Selecione o nome e o número do depósito do morador de cpf '201.419.360-61'
select M.nome, D.id_deposito
from morador M 
inner join deposito D on (M.id_apto = D.id_apto)
where M.cpf = '201.419.360-61';

-- 4.2) INNER JOIN + GROUP BY (2 tabelas): Selecione a média de idade para cada andar, de forma crescente
select A.numero_andar, avg(M.idade) as media_idade
from apartamento A inner join morador M on(A.id_apto = M.id_apto)
group by A.numero_andar
order by media_idade asc;

-- 4.3) LEFT JOIN em 2 tabelas: Selecione os números dos apartamentos e, se houver, a placa do veículo registrado em cada.
select A.id_apto as numero_apto, Ve.placa from
 apartamento A left join veiculo Ve on(A.id_apto = Ve.id_apto);

-- 4.4) LEFT JOIN de 3 tabelas: Selecione o nome do sindico e, se houver, o nome do local que ele está usufruindo dentre as áreas de lazer
select M.nome,Al.nome_espaco from
morador M left join morAlazer MAl on (M.cpf = MAl.cpf) left join
area_de_lazer Al on (MAl.id_espaco = Al.id_espaco) where M.ehSindico = 'S'; 






  