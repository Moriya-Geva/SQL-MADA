CREATE DATABASE MADA
go
--����� ���� ����
USE MADA
CREATE TABLE darga
(idDarga INT IDENTITY(1,1)PRIMARY KEY,
nameDara VARCHAR(20) not null )
GO
--����� ���� ���� ���
CREATE TABLE typeCars
(idCar INT IDENTITY(1,1)PRIMARY KEY,
type VARCHAR(20) not null)
GO
--����� ���� ������
CREATE TABLE branchs
(idB INT IDENTITY(1,1)PRIMARY KEY,
nameB VARCHAR(20) not null,
addressb VARCHAR(20)  not null,
city VARCHAR(20)  not null)
GO
--����� ���� �������
CREATE TABLE eventss 
(idEvent INT IDENTITY(1,1)PRIMARY KEY,
nameE VARCHAR(20) , 
idCar INT references typeCars,
idDmin INT REFERENCES darga,
sumConan INT,
sumGeneralConan INT)
GO
--����� ���� ������
CREATE TABLE conanim
(idConan INT PRIMARY KEY,
name VARCHAR(20) not null,
idA INT REFERENCES branchs,
idD INT REFERENCES darga  not null,
idCar INT REFERENCES typeCars,
phone VARCHAR(10)  not null,
tokef DATE  not null
)
GO
--����� ���� ������
CREATE TABLE calls 
(idCall INT IDENTITY(1,1)PRIMARY KEY,
time_call date not null,
idA INT REFERENCES branchs,
idEvent INT REFERENCES eventss ,
discribe VARCHAR(40),
exactAddress VARCHAR(50) ,
story VARCHAR(50)
)
--����� ���� ������ �� ������
GO
CREATE TABLE no_active
(idConan INT PRIMARY KEY,
name VARCHAR(20),
idA INT REFERENCES branchs,
idD INT REFERENCES darga  not null,
idCar INT REFERENCES typeCars,
phone VARCHAR(10)  not null,
tokef DATE  not null
)
--����� ���� ������
use MADA
CREATE TABLE replay_Of_Conan
(idReplay INT IDENTITY(1,1)PRIMARY KEY,
idCall INT REFERENCES calls  not null,
idConan INT references conanim not null,
time_arrive date  not null,
ps VARCHAR (40)
)
GO
--����� ���� ������ �� ������
CREATE TABLE old_replay
(idReplay INT PRIMARY KEY,
idCall INT REFERENCES calls  not null,
idConan INT references no_active not null,
time_arrive date  not null,
ps VARCHAR (40)
)
go