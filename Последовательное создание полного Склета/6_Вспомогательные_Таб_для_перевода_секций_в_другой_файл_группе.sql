use Magaz_DB_Poln
go
 begin tran
CREATE TABLE Employees_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Employee            bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;


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
) on PARTITION_Audit;

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
) on PARTITION_Audit;

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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
)on PARTITION_Audit ;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
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
) on PARTITION_Audit;
go
CREATE TABLE Order_category_Audit_2
(
    AuditID              bigint IDENTITY(1,1)  not null,
    ID_OrderCategory     bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit;
go
CREATE TABLE Order_Assignment_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_OrderAssignment     bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit;
go
--rollback
commit