
/*****ОЧЕНЬ ВАЖНО!!!!!!!! Таблица должна быть в той же файловой группе, что и секция, которую мы хотим туда «переключить». ******/

Alter database [Magaz_DB_2_Test] add filegroup [PARTITION_Audit_2] 
go
Alter database [Magaz_DB_2_Test] add file
(
 name = N'PARTITION_Audit_2'                    --Наименование name должно будет тоже самое что и  FileName а то будет ошибка
,FileName = N'd:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Издатель\PARTITION_Audit_2\PARTITION_Audit_2.ndf'
,size	 = 100 mb
,maxsize = 15000 mb,															
filegrowth = 100 mb	
)  TO FILEGROUP PARTITION_Audit_2
go --  Создаём файловую группу PARTITION_Audit_2

begin tran

CREATE PARTITION FUNCTION PF_PartFuncDate_left (Datetime)  
AS RANGE left FOR VALUES 
(
N'31.12.2023 23:59:59.997',
N'31.12.2024 23:59:59.997',
N'31.12.2025 23:59:59.997',
N'31.12.2026 23:59:59.997',
N'31.12.2027 23:59:59.997'
);
go

CREATE PARTITION SCHEME SH_PartFuncDate_left
AS PARTITION PF_PartFuncDate_left
all TO (PARTITION_Audit_2) -- всё в одну файловую группу
go


CREATE TABLE Employees_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Employee            bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Employees_Audit on Employees_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Employees_Audit_2 on Employees_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)

go
CREATE TABLE Department_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Department          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Department_Audit on Department_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Department_Audit_2 on Department_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Group_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Group               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Group_Audit on Group_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Group_Audit_2 on Group_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE The_Subgroup_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_The_Subgroup        bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_The_Subgroup_Audit on The_Subgroup_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_The_Subgroup_Audit_2 on The_Subgroup_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Passport_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Passport            bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Passport_Audit on Passport_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Passport_Audit_2 on Passport_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go

CREATE TABLE Post_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Post                bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Post_Audit on Post_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Post_Audit_2 on Post_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Status_Employee_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Status_Employee     bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Status_Employee_Audit on Status_Employee_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Status_Employee_Audit_2 on Status_Employee_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go

CREATE TABLE Connection_String_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Connection_String   bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Connection_String_Audit on Connection_String_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_String_Audit_2 on Connection_String_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)

go

CREATE TABLE Branch_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Branch              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Branch_Audit on Branch_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Branch_Audit_2 on Branch_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Country_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Country             bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go

create clustered index index_Country_Audit on Country_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Country_Audit_2 on Country_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go

CREATE TABLE Buyer_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_buyer               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Buyer_Audit on Buyer_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Audit_2 on Buyer_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Buyer_status_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Status              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Buyer_status_Audit on Buyer_status_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_status_Audit_2 on Buyer_status_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Condition_of_the_item_Audit_2
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Condition_of_the_item  bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Condition_of_the_item_Audit on Condition_of_the_item_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Condition_of_the_item_Audit_2 on Condition_of_the_item_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Connection_Buyer_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Connection_Buyer    bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Connection_Buyer_Audit on Connection_Buyer_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_Buyer_Audit_2 on Connection_Buyer_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Currency_Audit_2
(
    AuditID              bigint IDENTITY(1,1)  not null,
    ID_Currency          bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
)on PARTITION_Audit_2 ;
go
create clustered index index_Currency_Audit on Currency_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Audit_2 on Currency_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Currency_Rate_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Currency_Rate       bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Currency_Rate_Audit on Currency_Rate_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Rate_Audit_2 on Currency_Rate_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Data_Orders_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Data_Orders         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Data_Orders_Audit on Data_Orders_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Data_Orders_Audit_2 on Data_Orders_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Exemplar_Audit_2
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Exemplar               bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Exemplar_Audit on Exemplar_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Exemplar_Audit_2 on Exemplar_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Item_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Item                bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Item_Audit on Item_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_Audit_2 on Item_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Orders_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Orders              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Orders_Audit on Orders_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_Audit_2 on Orders_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Orders_status_Audit_2
(
    AuditID              bigint IDENTITY(1,1)  not null,
    Id_Status            bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Orders_status_Audit on Orders_status_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_status_Audit_2 on Orders_status_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Storage_location_Audit_2
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Storage_location       bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Storage_location_Audit on Storage_location_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_Audit_2 on Storage_location_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE TRANSACTION_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Transaction         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_TRANSACTION_Audit on TRANSACTION_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TRANSACTION_Audit_2 on TRANSACTION_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Transaction_status_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Transaction_status  bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Transaction_status_Audit on Transaction_status_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Transaction_status_Audit_2 on Transaction_status_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Type_of_product_measurement_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_product_measurement bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Type_of_product_measurement_Audit on Type_of_product_measurement_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_of_product_measurement_Audit_2 on Type_of_product_measurement_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE Type_Storage_location_Audit_2
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Type_Storage_location  bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_Type_Storage_location_Audit on Type_Storage_location_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_Storage_location_Audit_2 on Type_Storage_location_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE TypeItem_Audit_2
(
    AuditID              bigint IDENTITY(1,1)  not null,
    Id_TypeItem          bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_TypeItem_Audit on TypeItem_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeItem_Audit_2 on TypeItem_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go
CREATE TABLE TypeOrders_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_TypeOrders          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit_2;
go
create clustered index index_TypeOrders_Audit on TypeOrders_Audit(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeOrders_Audit_2 on TypeOrders_Audit_2(ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
go

--rollback
commit