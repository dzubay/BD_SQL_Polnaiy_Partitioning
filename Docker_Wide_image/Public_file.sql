
--Сначала требуется ввести данные о пути к папкам, и после чего запускать.
declare                                          --------------------------------------------
 @Magaz_DB_Poln_Root      nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Magaz_DB_Poln_Root.mdf'
,@Customers_Data_Poln_1   nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Customers_Data_Poln_1.ndf'
,@Customers_Data_Poln_2   nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Customers_Data_Poln_2.ndf'
,@Product_Data_Poln_1	  nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Product_Data_Poln_1.ndf'
,@Product_Data_Poln_2	  nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Product_Data_Poln_2.ndf'
,@Orders_Data_Poln_1	  nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Orders_Data_Poln_1.ndf'
,@Orders_Data_Poln_2	  nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Orders_Data_Poln_2.ndf'
,@Employee_Data_Poln_1	  nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Employee_Data_Poln_1.ndf'
,@Employee_Data_Poln_2	  nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Employee_Data_Poln_2.ndf'
,@Log_Data_Poln           nvarchar(400) =  N'/var/opt/mssql/data/'   +  'Log_Data_Poln.ldf'
                                         --------------------------------------------   
										 

declare @SQL_Cod nvarchar(max) -- В коде не должно быть комментариев, а то будут ошибка, или просто не сработает
set @SQL_Cod = N'
create database Magaz_DB_Poln
on primary 																	
(																			
name =  Magaz_DB_Poln_Root,													
filename = '''+@Magaz_DB_Poln_Root+''',										
size = 50 mb ,																
maxsize = 10000 mb,															
filegrowth = 50 mb															
),																			
filegroup  Costomers_Group												
(																			
name =  Customers_Data_Poln_1,													
filename = '''+@Customers_Data_Poln_1+''',										
size = 25 mb,																
maxsize = 250 mb,															
filegrowth = 25 mb															
),																			
(																			
name =  Customers_Data_Poln_2,													
filename = '''+@Customers_Data_Poln_2+''',										
size = 25 mb,																
maxsize = 250 mb,															
filegrowth = 25 mb															
),																			
filegroup  Products_Group													
(																			
name =  Product_Data_Poln_1,													
filename = '''+@Product_Data_Poln_1+''',										
size = 50 mb,																
maxsize = 1000 mb,															
filegrowth = 50 mb															
),																			
(																			
name =  Product_Data_Poln_2,													
filename = '''+@Product_Data_Poln_2+''',										
size = 50 mb,																
maxsize = 1000 mb,															
filegrowth = 50 mb															
),																			
filegroup  Orders_Group													
(																			
name =  Orders_Data_Poln_1,													
filename = '''+@Orders_Data_Poln_1+''',										
size = 75 mb,																
maxsize = 750 mb,															
filegrowth = 75 mb															
),																			
(																			
name =  Orders_Data_Poln_2,													
filename = '''+@Orders_Data_Poln_2+''',										
size = 75 mb,																
maxsize = 750 mb,															
filegrowth = 75 mb															
),																			
filegroup  Employee_Group													
(																			
name =  Employee_Data_Poln_1,													
filename = '''+@Employee_Data_Poln_1+''',										
size = 25 mb,																
maxsize = 250 mb,															
filegrowth = 25 mb															
),																			
(																			
name =  Employee_Data_Poln_2,													
filename = '''+@Employee_Data_Poln_2+''',										
size = 25 mb,																
maxsize = 250 mb,															
filegrowth = 25 mb															
)																			
log on																		
(																			
name = Log_Data_Poln,															
filename = '''+@Log_Data_Poln+''',												
size = 20mb,																
maxsize =5200mb,															
filegrowth = 40mb															
)																			
collate Cyrillic_General_CI_AS;       


ALTER DATABASE Magaz_DB_Poln  
SET RECOVERY SIMPLE;        
'

EXEC sp_executesql @SQL_Cod
go


-------------------------------------------------------------------------------------------------------------------------
use Magaz_DB_Poln
go

create table dbo.[Employees]                                   -- Сотрудник
(
ID_Employee                bigint         not null identity (1,1) check(ID_Employee !=0), -- ID Сотрудника
ID_Department              bigint         null,											  -- ID Депортамента
ID_Group                   bigint         null,											  -- ID Отдела
ID_The_Subgroup            bigint         null,											  -- ID Группы(Подгруппы)
ID_Passport                bigint         not null,										  -- ID Паспорта
ID_Branch                  bigint         null,											  -- ID Филиала
ID_Post                    bigint         null,											  -- ID Должности
ID_Status_Employee         bigint         null,											  -- ID Стасу сотрудника
ID_Connection_String       bigint         null,											  -- ID Данных Учётной записи
ID_Chief                   bigint         null,											  -- ID Начальника
Name                       nvarchar(100)  null,											  -- Имя
SurName                    nvarchar(100)  null,											  -- Фамилия
LastName                   nvarchar(100)  null,											  -- Отчество
Date_Of_Hiring             datetime       not null, 									  -- Дата приёма на работу
Date_Card_Created_Employee datetime       not null default GetDate(),					  -- Дата создания карточки сотрудника
Residential_Address        nvarchar(400)  null,											  -- Адрес проживания
Home_Phone                 nvarchar(30)   null,											  -- Домашний телефон
Cell_Phone                 nvarchar(30)   null,											  -- Сотовый телефон
Image_Employees            varbinary(max) null,    										  -- Фотография Сотрудника
Work_Phone                 nvarchar(30)   null,											  -- Рабочий телефон
Mail                       nvarchar(150)  null,											  -- Электронная почта
Pol                        char(1)        not null CHECK (Pol IN ('М', 'Ж')),			  -- Пол
Date_Of_Dismissal          datetime       null,											  -- Дата увольнения
Date_Of_Birth              datetime       not null,										  -- Дата рождения
[Description]              nvarchar(4000) null, 										  -- Комментарии
constraint PK_ID_Employee Primary key  (ID_Employee),
constraint FK_Employees_ID_Chief Foreign key(ID_Chief) references dbo.Employees(ID_Employee)  on delete NO ACTION --on Update NO ACTION  --Ссылается на саму себя, указывая на одного из сотрудников, при удалении останится  null в данном поле, при обновлении изменения внесуться.
) on Employee_Group
go


--alter table dbo.[Employees] add Image_Employees varbinary(max) null;

create table dbo.[Department]                      -- Депортамент
(
ID_Department               bigint         not null identity (1,1) check(ID_Department != 0), -- ID Депортамента
ID_Head_Department          bigint         null,											  -- ID Начальника Группы(Подгруппы) 
ID_Vice_Head_Department     bigint         null,											  -- ID Заместителя Группы(Подгруппы)
ID_Branch                   bigint         null,											  -- ID Филиала где находится этот Депортамент
Name_Department             nvarchar(300)  not null,										  -- Наименование Депортамента
Department_Code             int            null,											  -- Код депортамента
[Description]               nvarchar(4000) null, 											  -- Комментарии 
constraint PK_ID_Department Primary key  (ID_Department),
) on Employee_Group
go

create table dbo.[Group]                         -- Отдел
(
ID_Group                bigint         not null identity (1,1) check(ID_Group  != 0), -- ID Отдела 
ID_Head_Group           bigint         null,										  -- ID Начальника Группы(Подгруппы) 
ID_Vice_Head_Group      bigint         null,										  -- ID Заместителя Группы(Подгруппы)
ID_Department           bigint         not null,									  -- ID Депортамента
ID_Branch               bigint         null,										  -- ID Филиала где находится этот Отдел
Name_Group              nvarchar(300)  not null,									  -- Наименование отдела
Department_Code         int            null,										  -- Код депортамента
[Description]           nvarchar(4000) null, 										  -- Комментарии
constraint PK_ID_Group  Primary key  (ID_Group)
) on Employee_Group
go

create table dbo.[The_Subgroup]               -- группа(Подгруппа) 
(
ID_The_Subgroup            bigint         not null identity (1,1) check(ID_The_Subgroup  != 0), -- ID Группы(Подгруппы)
ID_Head_The_Subgroup       bigint         null,													-- ID Начальника Группы(Подгруппы)
ID_Vice_Head_The_Subgroup  bigint         null,													-- ID Заместителя Группы(Подгруппы)
ID_Group                   bigint         not null,												-- ID Отдела
ID_Branch                  bigint         null,													-- ID Филиала где находится этот Группы(Подгруппы)
ID_Parent_The_Subgroup     bigint         null,													-- ID Родительской группы
Name_The_Subgroup          nvarchar(300)  not null,												-- Наименование Группы(Подгруппы)
Department_Code            int            null,													-- Код депортамента
[Description]              nvarchar(4000) null,													-- Комментарии
constraint PK_The_Subgroup Primary key  (ID_The_Subgroup),
constraint FK_ID_Parent_The_Subgroup Foreign key (ID_Parent_The_Subgroup) references The_Subgroup(ID_The_Subgroup)  on delete NO ACTION
) on Employee_Group
go

create table dbo.[Passport]                        -- Данные паспорта сотрудника
(
ID_Passport                bigint         not null identity (1,1) check(ID_Passport  != 0), -- ID Паспорта сотрудника
Number_Series              nvarchar(100)  not null,											-- Номер_Серия
Date_Of_Issue              Datetime       not null,											-- Дата выдачи
Department_Code            nvarchar(20)   not null,											-- Код Депортамента
Issued_By_Whom             nvarchar(400)  not null,											-- Кем выдан
Registration               nvarchar(200)  not null,											-- Где зарегестрирован
Military_Duty              nvarchar(200)  not null,											-- Данные о военной службе
[Description]              nvarchar(4000) null,												-- Комментарии
constraint PK_ID_Passport Primary key  (ID_Passport)
) on Employee_Group
go

create table Post                                 -- Должность
(
ID_Post               bigint         not null identity (1,1) check(ID_Post  != 0), -- ID Должности
ID_Department         bigint         not null,									   -- ID Депортамента
ID_Group              bigint         not null,									   -- ID Группы
ID_The_Subgroup       bigint         not null,									   -- ID Подгруппы
Name_Post             nvarchar(200)  not null,									   -- Наименование должности
[Description]         nvarchar(4000) null,										   -- Комментарии
constraint PK_ID_Post Primary key  (ID_Post)
) on Employee_Group
go

create table Status_Employee              -- Статусы сотрудника
(
ID_Status_Employee   bigint         not null identity (1,1) check(ID_Status_Employee  != 0),  -- ID Статуса сотрудника
Name_Status_Employee nvarchar(100)  not null,												  -- Наименование статуса сотрудника
[Description]        nvarchar(4000) null,													  -- Комментарий
constraint PK_ID_Status_Employee Primary key  (ID_Status_Employee)
) on Employee_Group
go

create table Connection_String                                 -- Данные учётной записи сотрудника в системе
(
ID_Connection_String   bigint    not null identity (1,1) check(ID_Connection_String  != 0),  -- ID Учётной записи сотрудника
Password      nvarchar(50)       null,                                                       -- Пароль
Login         nvarchar(100)      null,														 -- Логин
Date_Created  datetime           null default GetDate(),									 -- Дата созданияУчётной записи сотрудника
[Description] nvarchar(4000)     null,														 -- Комментарии 
constraint PK_ID_Connection_String  Primary key  (ID_Connection_String),
) on Employee_Group
go

create table Branch                    --Филиал
(
ID_Branch     bigint          not null identity (1,1) check(ID_Branch  != 0), -- ID Филиала
Id_Country    bigint          null,                                           -- ID Страны где находится филиал
City          nvarchar(100)   not null,										  -- Город филиала
[Address]     nvarchar(300)   not null,										  -- Адрес
Name_Branch   nvarchar(300)   not null,										  -- Наименование филиала
Mail          nvarchar(300)   null,											  -- Почтовый адрес
Phone         nvarchar(15)    null,											  -- Телефон
Postal_Code   int             null,											  -- Почтовый индекс
INN           int             not null,										  -- ИНН
[Description] nvarchar(4000)  null,											  -- Комментарии
constraint PK_ID_Branch  Primary key  (ID_Branch),
) on Employee_Group
go

create table Country                 --Страны
(
Id_Country         bigint           not null identity (1,1) check(ID_Country  != 0),  -- ID Страны
Name_Country       nvarchar(150)    not null,                                         -- Наименование страны
Name_English       nvarchar(150)    not null,										  -- Наименование на английском
Cod_Country_Phone  nvarchar(10)     null,											  -- Телефонный код страны
constraint PK_ID_Country  Primary key  (ID_Country),
) on Employee_Group
go

create table  Currency                               --Валюта
(
ID_Currency       bigint          not null identity (1,1) check(ID_Currency !=0),      -- ID валюты
Full_name_rus     nvarchar(300)   not null,                                            -- Полное наименование валюты на русском
Full_name_eng     nvarchar(300)   not null,                                            -- Полное наименование валюты на английском
Abbreviation_rus  nvarchar(15)    not null,                                            -- Короткое наименование на русском
Abbreviation_eng  nvarchar(15)    not null,                                            -- Короткое наименование на английском
[Description]     nvarchar(4000)  null,                                                -- Комментарии
constraint PK_ID_Currency         primary key (ID_Currency),
) on Orders_Group

go

create table Orders_status                                                  --Статус заказа
(
Id_Status                  bigint          not null identity (1,1)  check(Id_Status !=0),   -- ID статуса заказа
Name                       nvarchar(300)   not null,                                        -- Наименование статуса заказа
SysTypeOrderStatusName     nvarchar(300)   not null,                                        -- Системное имя статуса заказа
[Description]              nvarchar(4000)  null,                                            -- Комментарии
constraint  PK_Id_Status   primary key (Id_Status),
) on Orders_Group

go


create table TypeOrders                                                      --Тип заказа
(
ID_TypeOrders       bigint          not null  identity(1,1)  check(ID_TypeOrders != 0),   -- ID Типа заказа
TypeOrdersName      nvarchar(300)   not null,                                             -- Наименование типа заказа
TypeOrdersSysName   nvarchar(300)   not null,                                             -- Наименование системного типа заказа
[Description]       nvarchar(4000)  null                                                  -- Комментарии
constraint PK_ID_TypeOrders Primary key(ID_TypeOrders)
)  on Orders_Group

go


create table Order_category                                                      --Категория заказа
(
ID_OrderCategory       bigint          not null  identity(1,1)  check(ID_OrderCategory != 0),   -- ID Категории заказа
OrderCategoryName      nvarchar(300)   not null,                                                -- Наименование Категории заказа
Abbreviation           nvarchar(10)    not null,                                                -- Аббревиатура, сокращённое наименование Категории заказа
OrderCategorySysName   nvarchar(300)   not null,                                                -- Наименование системного типа Категории заказа
[Description]          nvarchar(4000)  null                                                     -- Комментарии
constraint PK_ID_OrderCategory Primary key(ID_OrderCategory)
)  on Orders_Group

go


create table Order_Assignment                                                      ---Принадлежность заказа к системе  
(
ID_OrderAssignment       bigint          not null  identity(1,1)  check(ID_OrderAssignment != 0),   -- ID_Принадлежности_заказа_к_системе 
OrderAssignmentName      nvarchar(300)   not null,                                                  -- Наименование Принадлежности заказа к системе
OrderAssignmentNameEng   nvarchar(300)   not null,                                                  -- Наименование Принадлежности заказа к системе на английском
OrderAssignmentSysName   nvarchar(300)   not null,                                                  -- Системное наименование Принадлежности заказа к системе
[Description]            nvarchar(4000)  null                                                       -- Комментарии
constraint PK_ID_OrderAssignment Primary key(ID_OrderAssignment)
)  on Orders_Group

go

create table Orders                                                                 --Заказ
(
ID_Orders          bigint          not null identity (1,1)  check(Id_Orders !=0),      -- ID заказа
ID_status          bigint          not null,                                           -- ID статуса заказа
ID_TypeOrders      bigint          not null,                                           -- ID Типа заказа
ID_Currency        bigint          not null,                                           -- Валюта заказа
ID_OrderAssignment BIGINT          NOT NULL,                                           -- ID_Принадлежности_заказа_к_системе
ID_OrderCategory   BIGINT          NOT NULL,                                           -- ID Категории заказа
Date               datetime        not null default  getDate(),                        -- Дата создания заказа
Payment_Date       datetime        null,                                               -- Дата Оплаты заказа
Amount             decimal(10,2)   null,                                               -- Сумма заказа
AmountCurr         decimal(10,2)   null,                                               -- Сумма заказа c начислением коммисии 
AmountNDS          decimal(10,2)   null,                                               -- Сумма заказа c начисленным НДС
AmountCurrNDS      decimal(10,2)   null,                                               -- Сумма заказа c начислением коммисии и НДС
Num                nvarchar(50)    not null,                                           -- Номер заказа
[Description]      nvarchar(4000)  null,                                               -- Комментарий
constraint  PK_ID_Orders               primary key (ID_Orders)
)  on Orders_Group

go


create table Connection_Buyer                                                     --Аккаунт покупателя
(
ID_Connection_Buyer   bigint             not null identity (1,1) check(ID_Connection_Buyer  != 0), -- ID данных о личном аккаунте на ресурсе покупателя 
Password              nvarchar(50)       null,                                                     -- Пароль аккаунта на ресурсе
Login                 nvarchar(100)      null,                                                     -- Логин аккаунта на ресурсе
Date_Created          datetime           not null default GetDate(),                               -- Дата создания аккаунта
[Description]         nvarchar(1000)     null,                                                     -- Комментарий
constraint PK_ID_Connection_Buyer  Primary key  (ID_Connection_Buyer)
) on Costomers_Group
go



create table Buyer_status                                              --Статуса покупателя
(
Id_Status              bigint          not null identity (1,1)  check(Id_Status !=0),  -- ID Статуса покупателя
Name                   nvarchar(300)   not null,                                       -- Наименования статуса покупателя
SysTypeBuyerStatusName nvarchar(300)   not null,                                       -- Системное имя статуса покупателя
[Description]          nvarchar(4000)  null,                                           -- Комментарий
constraint  PK_Id_Buyer_status   primary key (Id_Status)
) on Costomers_Group

go

create table Buyer_Type                                              --Тип покупателя
(
Id_Buyer_Type              bigint          not null identity (1,1)  check(Id_Buyer_Type !=0),  -- ID Тип покупателя
Name                       nvarchar(300)   not null,                                           -- Наименования типа покупателя
SysTypeBuyerTypeName       nvarchar(300)   not null,                                           -- Системное имя типа покупателя
[Description]              nvarchar(4000)  null,                                               -- Комментарий
constraint  PK_Id_Buyer_Type   primary key (Id_Buyer_Type)
) on Costomers_Group

go

create  table Buyer                                                     --Покупатель
(
Id_buyer                    bigint         not null identity (1,1)check(Id_buyer !=0),      -- ID Покупателя
ID_Connection_Buyer         bigint         not null,                                        -- ID данных о личном аккаунте на ресурсе покупателя 
Id_Status                   bigint         null,                                            -- ID Статуса покупателя
Id_Buyer_Type               bigint         not null,                                        -- ID Тип покупателя
Name                        nvarchar(100)  null,                                            -- Имя
SurName                     nvarchar(100)  null,                                            -- Фамилия
LastName                    nvarchar(100)  null,                                            -- Отчество
Mail                        nvarchar(250)  null,                                            -- Электронная почта покупателя
Pol                         char(1)        not null CHECK (Pol IN ('М', 'Ж')),              -- Пол
Phone                       nvarchar(30)   null,                                            -- Действующий телефон покупателя
Date_Of_Birth               datetime       null,                                            -- Дата роождения
Premium                     bit            not null,                                        -- Премиум аккаунт или нет 0\1
The_resident                bit            not null,                                        -- Резидент или не Резидент 0\1
[Description]               nvarchar(4000) null,                                            -- Комментарий
constraint PK_Id_buyer             primary key (Id_buyer)
) on Costomers_Group
go


CREATE TABLE [dbo].Transaction_status                                      --Статус Транзакции
(
ID_Transaction_status          bigint          not null  identity(1,1)  check(ID_Transaction_status != 0),   -- ID_Статуса транзакции
TypeTransactionName            nvarchar(300)   not null,                                                     -- Наименование типа транзакции
SysTypeTransactionName         nvarchar(300)   not null,                                                     -- Системное наименование типа транзакции
[Description]                  nvarchar(4000)  null                                                          -- Комментарий
constraint PK_ID_Transaction_status       primary key (ID_Transaction_status)
)  on Products_Group

go

CREATE TABLE Currency_Rate                                        -- Ставка за период
(
ID_Currency_Rate        bigint          not null identity(1,1)  check(ID_Currency_Rate != 0),   -- ID Ставки  за период
ID_Currency             bigint          not null,                                               -- ID Валюты                                                          
Amount_Rate             decimal(5,2)    not null,                                               -- Сумма ставки одной  ед в рублях, за текущий период
Valid_from              datetime        not null,                                               -- Сумма ставки с момента.
Valid_to                datetime        not null,                                               -- Сумма ставки до момента.
JSON_Currency_Rate_Data nvarchar(max)   null      check(isjson(JSON_Currency_Rate_Data)>0),		-- JSON Данные приходящие из стороннего ресурса
[Description]           nvarchar(4000)  null                                                    -- Комментарий
constraint      PK_ID_Currency_Rate     primary key (ID_Currency_Rate)
)  on Products_Group
go

CREATE TABLE [dbo].[TRANSACTION]                                       --Транзакция
(
ID_Transaction                  bigint          not null  identity(1,1)    check(ID_Transaction != 0),    -- ID_Тразанкции
ID_Currency                     bigint          not null,                                                 -- ID Валюты транзакции
ID_Transaction_status           bigint          not null,                                                 -- ID_Статуса транзакции
ID_Currency_Rate                bigint          not null,                                                 -- ID Ставки  за период
Transaction_Date                datetime        not null  default GetDate(),                              -- Дата создания транзакции 
KeySource                       bigint          null,                                                     -- Источник ключа с другими БД или сервисами
Transaction_name_sender         nvarchar(500)   not null,                                                 -- Наименование отправителя
JSON_Transaction_sender         nvarchar(max)   null      check(isjson(JSON_Transaction_sender)>0),		  -- JSON Данные от сервиса отправителя
Transaction_Amount              decimal(10,2)   not null,												  -- Сумма транзакции
[Description]                   nvarchar(4000)  null 													  -- Комментарий
constraint PK_ID_Transaction                     primary key (ID_Transaction)
)  on Products_Group
go


create table TypeItem                                                 --Тип товара
(
Id_TypeItem      bigint          not null identity (1,1) check(Id_TypeItem !=0),  -- ID Типа товара
TypeItemName     nvarchar(300)   not null,                                        -- Наименование типа тоара
SysTypeItemName  nvarchar(300)   not null,                                        -- Системное наименование типа товара
[Description]    nvarchar(4000)  null                                             -- Комментарий
constraint PK_Id_TypeItem  primary key (Id_TypeItem),
) on Products_Group

go



create table Type_of_product_measurement                                            --Тип измерения товара
(
ID_product_measurement          bigint          not null identity (1,1) check(ID_product_measurement !=0), --ID Типа измерения товара 
Product_measurement_Name        nvarchar(300)   not null,                                                  --Наименование Типа измерения товара 
SysProductMeasurementName       nvarchar(300)   not null,                                                  --Системное Наименование Типа измерения товара 
[Description]                   nvarchar(4000)  null                                                       --Комментарий
Constraint PK_ID_product_measurement  primary key (ID_product_measurement)
) on Products_Group

go

create table Species_Item                                            --Вид товара
(
ID_Species_Item                 bigint          not null identity (1,1) check(ID_Species_Item !=0),        --ID Вида товара 
SpeciesItemName                 nvarchar(300)   not null,                                                  --Наименование Вида товара 
SysSpeciesItemName              nvarchar(300)   not null,                                                  --Системное Наименование Вида товара 
[Description]                   nvarchar(4000)  null                                                       --Комментарий
Constraint PK_ID_Species_Item  primary key (ID_Species_Item)
) on Products_Group

go


create table Item_status                                              --Статус Товара
(
Id_Item_Status             bigint          not null identity (1,1)  check(Id_Item_Status !=0),  -- ID Статуса Товара 
ItemStatus                 nvarchar(300)   not null,                                            -- Наименования статуса Товара
SysItemStatusName          nvarchar(300)   not null,                                            -- Системное имя статуса Товара
[Description]              nvarchar(4000)  null,                                                -- Комментарий
constraint  PK_Id_Item_Status   primary key (Id_Item_Status)
) on Products_Group

go

create table Item                                                                       --Товар
(
Id_Item                    bigint          not null identity (1,1) check(Id_Item !=0),              --ID Карточки товра
ID_product_measurement     bigint          not null,                                                --ID Типа измерения товара  
ID_TypeItem                bigint          not null,                                                --ID Типа товара
ID_Species_Item            bigint          not null,                                                --ID Вида товара
Id_Item_Status             bigint          not null,                                                --ID Статуса Товара
Article_number             nvarchar(300)   null,                                                    --Артикул товара
Name_Item                  nvarchar(500)   null,                                                    --Наименование товара
Image_Item                 varbinary(max)  null,                                                    --Изображение товара
Manufacturer               nvarchar(500)   null,                                                    --Производитель товара
Country                    nvarchar(200)   null,                                                    --Страна  Производителя товара
City                       nvarchar(200)   null,                                                    --Город  Производителя товара
Adress                     nvarchar(800)   null,                                                    --Адрес Производителя товара
Mail                       nvarchar(250)   null,                                                    --Электронная почта производителя товара 
Phone                      nvarchar(30)    null,                                                    --Контактный телефон производителя товара
Logo                       varbinary(max)  null,                                                    --Логотип производителя товара
Date_Created               datetime        not null  default GetDate(),                             --Дата заведения карточки товара
Quantity                   int             null,                                                    --Количество данного товара
[Description]              nvarchar(4000)  null                                                     --Комментарий 
constraint PK_Id_Item  primary key (Id_Item)
) on Products_Group
go



create table Type_Storage_location                               --Тип места хранения
(
ID_Type_Storage_location                    bigint              not null identity(1,1) check(ID_Type_Storage_location != 0),  --ID Типа места хранение
Name_Type_Storage_location                  nvarchar(300)       not null,                                                     --Наименование типа места хранениея 
SysNameTypeStoragelocation                  nvarchar(300)       not null,                                                     --Системное наименование типа места хранения
[Description]                               nvarchar(4000)      null                                                          --Комментарий
constraint PK_ID_Type_Storage_location      primary key (ID_Type_Storage_location)
) on Products_Group

go  


create table Storage_location_status                                           --Статус Места Хранения
(
Id_Status                  bigint          not null identity (1,1)  check(Id_Status !=0),   -- ID Статуса Места Хранения
TypeStoragelocationName    nvarchar(300)   not null,                                        -- Наименование Статуса Места Хранения
SysTypeStoragelocationName nvarchar(300)   not null,                                        -- Системное имя Статуса Места Хранения
[Description]              nvarchar(4000)  null,                                            -- Комментарии
constraint  PK_Id_Storage_location_status   primary key (Id_Status),
) on Products_Group

go

create table Storage_location                                                    -- Место хранение
(
ID_Storage_location        bigint              not null identity(1,1) check(ID_Storage_location != 0),   --ID Место хранение экземпляра
ID_Type_Storage_location   bigint              not null,                                                 --ID Типа места хранение
Id_Status                  bigint              not null,                                                 --ID Статуса Места Хранения
Id_Country                 bigint              not null,                                                 --ID Страны
KeySource                  bigint              null,                                                     --Источник ключа с другими БД или сервисами
Name                       nvarchar(400)       not null,                                                 --Наименование места хранения
City                       nvarchar(200)       null,                                                     --Город  места хранения
Adress                     nvarchar(800)       not null,                                                 --Адрес места хранения
Mail                       nvarchar(250)       null,                                                     --Электронная почта хранение экземпляра
Phone                      nvarchar(30)        null,                                                     --Действующий телефон хранение экземпляра
Date_Created               datetime            not null  default GetDate(),                              --Дата заведения в систему места хранения
[Description]              nvarchar(4000)      null                                                      --Комментарий
constraint PK_ID_Storage_location          primary key (ID_Storage_location)
)  on Products_Group

go

create table Condition_of_the_item                                                    -- Cостояние экземпляра
(  
ID_Condition_of_the_item       bigint not null identity(1,1) check(ID_Condition_of_the_item != 0), -- ID Текущего состояния экземпляра
Name_Condition_of_the_item     nvarchar(300)       not null,                                       -- Наименование текущего состояния экземпляра
SysNameConditionTypeOfTheItem  nvarchar(300)       not null,                                       -- Системное наименование текущего состояния экземпляра
[Description]                  nvarchar(4000)      null                                            -- Комментарий
constraint PK_ID_Condition_of_the_item  primary key (ID_Condition_of_the_item)
)  on Products_Group

go


create table Exemplar                                                                   --Экземпляр
(
ID_Exemplar               bigint          not null   identity (1,1)  check(ID_Exemplar != 0),     -- ID Экземпляра
Id_Item                   bigint          not null,                                               -- ID Карточки товара
ID_Currency               bigint          not null,											      -- ID Валюта, цены на экземпляр
ID_Storage_location       bigint          not null,                                               -- ID Место хранение экземпляра
KeySource                 bigint          null,                                                   -- Источник ключа с другими БД или сервисами
Serial_number             nvarchar(500)   not null,                                               -- Серийный номер экземпляра товара
ID_Condition_of_the_item  bigint          not null,                                               -- ID Текущего состояния экземпляра
Old_Price_no_NDS          decimal(10,2)   not null,                                               -- Цена без НДС экземпляра
Refund                    bit             not null,                                               -- Был ли возврат данного экземпляра или нет. 0/1
Date_Refund               datetime        null,                                                   -- Дата возврата
Return_Note               nvarchar(4000)  null,                                                   -- Записка(Примечание) о возврате
Old_Price_NDS             decimal(10,2)   not null,                                               -- Цена экземпляра с НДС
JSON_Size_Volume          nvarchar(max)   null      check(isjson(JSON_Size_Volume)>0),            -- Данный JSON параметры самого экземпляра
New_Price_NDS             decimal(10,2)   not null,                                               -- Цена экземпляра с НДС после начисления коммисии  за  сервис
New_Price_no_NDS          decimal(10,2)   not null,                                               -- Цена экземпляра без НДС после начисления коммисии  за  сервис
Date_Created              datetime        not null  default GetDate(),                            -- Дата внесения экземпляра в систему
[Description]             nvarchar(4000)  null                                                    -- Комментарий
constraint PK_ID_Exemplar              primary key (ID_Exemplar)
)  on Products_Group

go 


create table  Data_Orders                                                    --Вспомогательная таблицца, данные о заказе
(
Id_Data_Orders         bigint          not null identity (1,1) check(ID_Data_Orders !=0),  -- ID данных о заказе
ID_Employee            bigint          null,                                               -- ID Сотрудника или бота
ID_Orders              bigint          not null,                                           -- ID Заказа
Id_buyer               bigint          not null,	                                       -- ID Покупателя
ID_Exemplar            bigint          not null,                                           -- ID Экземпляра
ID_Transaction         bigint          null,                                               -- ID Тразанкции
Date_Data_Orders       datetime        not null  default getdate(),                        -- Дата создания данныйх о заказе
[Description]          nvarchar(4000)  null
constraint PK_ID_Data_Orders                primary key (ID_Data_Orders) 
)  on Orders_Group
go



ALTER TABLE dbo.[Employees]
Add 
CONSTRAINT FK_Employees_ID_Department        Foreign key  (ID_Department)        references dbo.[Department](ID_Department)               on delete set null on Update cascade ,
CONSTRAINT FK_Employees_ID_Group             Foreign key  (ID_Group)             references dbo.[Group](ID_Group)                         on delete set null on Update cascade ,
CONSTRAINT FK_Employees_ID_The_Subgroup      Foreign key  (ID_The_Subgroup)      references dbo.[The_Subgroup](ID_The_Subgroup)           on delete set null on Update cascade ,
CONSTRAINT FK_Employees_ID_Passport          Foreign key  (ID_Passport)          references dbo.[Passport](ID_Passport)                   on delete cascade on Update cascade ,
CONSTRAINT FK_Employees_ID_Branch            Foreign key  (ID_Branch)            references dbo.[Branch](ID_Branch)                       on delete set null on Update cascade,
CONSTRAINT FK_Employees_ID_Post              Foreign key  (ID_Post)              references dbo.[Post](ID_Post)                           on delete set null on Update cascade,
CONSTRAINT FK_Employees_ID_Status_Employee   Foreign key  (ID_Status_Employee)   references dbo.[Status_Employee](ID_Status_Employee)     on delete set null on Update cascade,
CONSTRAINT FK_Employees_ID_Connection_String Foreign key  (ID_Connection_String) references dbo.[Connection_String](ID_Connection_String) on delete set null on Update cascade 
go
ALTER TABLE dbo.[Department]
Add 
CONSTRAINT FK_Department_ID_Head_Department      Foreign key  (ID_Head_Department)      references dbo.[Employees](ID_Employee),
CONSTRAINT FK_Department_ID_Vice_Head_Department Foreign key  (ID_Vice_Head_Department) references dbo.[Employees](ID_Employee),
CONSTRAINT FK_Department_ID_Branch               Foreign key  (ID_Vice_Head_Department) references dbo.[Branch](ID_Branch)  
go
ALTER TABLE dbo.[Group]
Add 
CONSTRAINT FK_Group_ID_Head_Group      Foreign key  (ID_Head_Group)      references dbo.[Employees](ID_Employee) ,
CONSTRAINT FK_Group_ID_Vice_Head_Group Foreign key  (ID_Vice_Head_Group) references dbo.[Employees](ID_Employee),
CONSTRAINT FK_Group_ID_Department      Foreign key  (ID_Department)      references dbo.[Department](ID_Department),
CONSTRAINT FK_Group_ID_Branch          Foreign key  (ID_Branch)          references dbo.[Branch](ID_Branch)
go
ALTER TABLE dbo.[The_Subgroup]
Add 
CONSTRAINT FK_The_Subgroup_ID_Head_The_Subgroup       Foreign key  (ID_Head_The_Subgroup)      references dbo.[Employees](ID_Employee),
CONSTRAINT FK_The_Subgroup_ID_Vice_Head_The_Subgroup  Foreign key  (ID_Vice_Head_The_Subgroup) references dbo.[Employees](ID_Employee),
CONSTRAINT FK_The_Subgroup_ID_Group                   Foreign key  (ID_Group)                  references dbo.[Group](ID_Group),
CONSTRAINT FK_The_Subgroup_ID_Branch                  Foreign key  (ID_Branch)                 references dbo.[Branch](ID_Branch)
go
ALTER TABLE dbo.[Post]
Add
CONSTRAINT FK_Post_ID_Department   Foreign key  (ID_Department)   references dbo.[Department](ID_Department),
CONSTRAINT FK_Post_ID_Group        Foreign key  (ID_Group)        references dbo.[Group](ID_Group),
CONSTRAINT FK_Post_ID_The_Subgroup Foreign key  (ID_The_Subgroup) references dbo.[The_Subgroup](ID_The_Subgroup)
go
ALTER TABLE dbo.[Branch]
Add
CONSTRAINT FK_Branch_Id_Country Foreign key  (Id_Country) references dbo.[Country](Id_Country)  on delete set null on Update cascade
go
ALTER TABLE dbo.[Orders]
ADD
constraint  FK_ID_Orders_status        foreign key (ID_status)            references [dbo].Orders_status      on delete NO ACTION,
constraint  FK_ID_TypeOrders           foreign key (ID_TypeOrders)        references [dbo].TypeOrders         on delete NO ACTION,
constraint  FK_ID_Currency_Orders      foreign key (ID_Currency  )        references [dbo].Currency           on delete NO ACTION,
constraint  FK_ID_OrderAssignment      foreign key (ID_OrderAssignment)   references [dbo].Order_Assignment   on delete NO ACTION,
constraint  FK_ID_OrderCategory        foreign key (ID_OrderCategory  )   references [dbo].Order_category     on delete NO ACTION
go
ALTER TABLE   dbo.[Buyer]
ADD 
constraint FK_ID_Connection_Buyer  foreign key (ID_Connection_Buyer)   references dbo.Connection_Buyer  on delete NO ACTION,
constraint FK_Id_Buyer_statuss     foreign key (Id_Status)             references dbo.Buyer_status      on delete NO ACTION,
constraint FK_Id_Buyer_Type        foreign key (Id_Buyer_Type)         references dbo.Buyer_Type        on delete NO ACTION
go
ALTER TABLE dbo.[Currency_Rate]
ADD
constraint      FK_ID_Currency_Rate     foreign key (ID_Currency)        references [dbo].Currency      on delete NO ACTION
go
ALTER TABLE [dbo].[TRANSACTION]
ADD
constraint FK_ID_Currency_Transaction            foreign key (ID_Currency)             references [dbo].Currency                on delete NO ACTION,
constraint FK_ID_Transaction_status              foreign key (ID_Transaction_status)   references [dbo].Transaction_status      on delete NO ACTION,
constraint FK_ID_Currency_Rate_ID_Transaction    foreign key (ID_Currency_Rate)        references [dbo].Currency_Rate           on delete NO ACTION
GO
ALTER TABLE  dbo.[Item]
ADD
constraint FK_ID_TypeItem                   foreign key (ID_TypeItem)              references [dbo].TypeItem                       on delete NO ACTION,
constraint FK_ID_product_measurement        foreign key (ID_product_measurement)   references [dbo].Type_of_product_measurement    on delete NO ACTION,
constraint FK_ID_Species_Item               foreign key (ID_Species_Item)          references [dbo].Species_Item                   on delete NO ACTION,
constraint FK_Id_Item_Status                foreign key (Id_Item_Status)           references [dbo].Item_status                    on delete NO ACTION
GO
ALTER TABLE dbo.[Storage_location]
ADD
constraint FK_ID_Type_Storage_location     foreign key (ID_Type_Storage_location)        references [dbo].Type_Storage_location    on delete NO ACTION,
constraint FK_ID_Status_Storage_location   Foreign key(Id_Status)                        references  [dbo].Storage_location_status on delete no action,
constraint FK_Id_Country_Storage_location  foreign key (Id_Country)                      references [dbo].Country                  on delete no action
GO
ALTER TABLE dbo.[Exemplar]
ADD
constraint FK_ID_Item                  foreign key (Id_Item)                  references [dbo].Item                    on delete NO ACTION,
constraint FK_ID_Currency_Exemplar     foreign key (ID_Currency)              references [dbo].Currency                on delete NO ACTION,
constraint FK_ID_Storage_location      foreign key (ID_Storage_location)      references [dbo].Storage_location        on delete NO ACTION,
constraint FK_ID_Condition_of_the_item foreign key (ID_Condition_of_the_item) references [dbo].Condition_of_the_item   on delete NO ACTION
GO
ALTER TABLE dbo.[Data_Orders]
ADD
constraint FK_ID_Employee                   foreign key (ID_Employee)       references [dbo].Employees       on delete NO ACTION, 
constraint FK_ID_Orders                     foreign key (ID_Orders)         references [dbo].Orders          on delete NO ACTION,
constraint FK_Id_buyer                      foreign key (Id_buyer)          references [dbo].buyer           on delete NO ACTION, 
constraint FK_ID_Transaction_Data_Orders    foreign key (ID_Transaction)    references [dbo].[Transaction]   on delete NO ACTION,
constraint FK_ID_Exemplar_Data_Orders       foreign key (ID_Exemplar)       references [dbo].Exemplar        on delete NO ACTION 
GO

use Magaz_DB_Poln
go


CREATE TABLE Branch_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Branch               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Branch_Audit ON Branch
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';

    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Branch,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Branch,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


							DECLARE @OldID_Branch     bigint        ;
							DECLARE @OldId_Country    bigint        ;
							DECLARE @OldCity          nvarchar(100) ;
							DECLARE @OldAddress       nvarchar(300) ;
							DECLARE @OldName_Branch   nvarchar(300) ;
							DECLARE @OldMail          nvarchar(300) ;
							DECLARE @OldPhone         nvarchar(15)  ;
							DECLARE @OldPostal_Code   int           ;
							DECLARE @OldINN           int           ;
							DECLARE @OldDescription   nvarchar(4000);

						   DECLARE @NewID_Branch     bigint        ;
						   DECLARE @NewId_Country    bigint        ;
						   DECLARE @NewCity          nvarchar(100) ;
						   DECLARE @NewAddress       nvarchar(300) ;
						   DECLARE @NewName_Branch   nvarchar(300) ;
						   DECLARE @NewMail          nvarchar(300) ;
						   DECLARE @NewPhone         nvarchar(15)  ;
						   DECLARE @NewPostal_Code   int           ;
						   DECLARE @NewINN           int           ;
						   DECLARE @NewDescription   nvarchar(4000);


						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

								        SELECT 
                                              @NewID_Branch   = I.ID_Branch     ,
											  @NewId_Country  = I.Id_Country  	,
											  @NewCity        = I.City        	,
											  @NewAddress     = I.[Address]     ,
											  @NewName_Branch = I.Name_Branch 	,
											  @NewMail        = I.Mail        	,
											  @NewPhone       = I.Phone       	,
											  @NewPostal_Code = I.Postal_Code 	,
											  @NewINN         = I.INN         	,
											  @NewDescription = I.[Description]    	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Branch;

                                        SELECT 
                                              @OldID_Branch   = D.ID_Branch     ,
											  @OldId_Country  = D.Id_Country  	,
											  @OldCity        = D.City        	,
											  @OldAddress     = D.[Address]     ,
											  @OldName_Branch = D.Name_Branch 	,
											  @OldMail        = D.Mail        	,
											  @OldPhone       = D.Phone       	,
											  @OldPostal_Code = D.Postal_Code 	,
											  @OldINN         = D.INN         	,
											  @OldDescription = D.[Description]   							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Branch;

                                       IF isnull(cast(@NewId_Country AS NVARCHAR(50)),'null')  <> isnull(cast(@OldId_Country AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Country = Old ->"' +  ISNULL(CAST(@OldId_Country AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewId_Country AS NVARCHAR(50)),'') + '", ';
							              end

							           IF isnull(@NewCity,'null') <> isnull(@OldCity,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  City = Old ->"' +  ISNULL(@OldCity,'') + ' " NEW -> " ' + isnull(@NewCity,'') + '", ';
							              end
                                                                                               
							           IF isnull(@NewAddress,'null') <> isnull(@OldAddress,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Address = Old ->"' +  ISNULL(@OldAddress,'') + ' " NEW -> " ' + isnull(@NewAddress,'') + '", ';
							              end

							           IF isnull(@NewName_Branch,'null') <> isnull(@OldName_Branch,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Branch = Old ->"' +  ISNULL(@OldName_Branch,'') + ' " NEW -> " ' + isnull(@NewName_Branch,'') + '", ';
							              end

							           IF isnull(@NewMail,'null') <> isnull(@OldMail,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							              end							          

							           IF isnull(@NewPhone,'null') <> isnull(@OldPhone,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> " ' + isnull(@NewPhone,'') + '", ';
							              end

                           	          IF isnull(cast(@NewPostal_Code AS NVARCHAR(50)),'null') <> isnull(cast(@OldPostal_Code AS NVARCHAR(50)),'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Postal_Code = Old ->"' +  ISNULL(CAST(@OldPostal_Code AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewPostal_Code AS NVARCHAR(50)),'') + '", ';
							              end
										  
									  IF isnull(cast(@NewINN AS NVARCHAR(50)),'null') <> isnull(cast(@OldINN AS NVARCHAR(50)),'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  INN = Old ->"' +  ISNULL(CAST(@OldINN AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewINN AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end

                                       SET @ChangeDescription = 'Updated: ' + ' ID_Branch = "' +  isnull(cast(@OldID_Branch as nvarchar(50)),'')+ '", ' + isnull(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Branch_Audit
                                        ( 
                                         ID_Branch,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Branch,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Branch_2     bigint        ;
							DECLARE @OldId_Country_2    bigint        ;
							DECLARE @OldCity_2          nvarchar(100) ;
							DECLARE @OldAddress_2       nvarchar(300) ;
							DECLARE @OldName_Branch_2   nvarchar(300) ;
							DECLARE @OldMail_2          nvarchar(300) ;
							DECLARE @OldPhone_2         nvarchar(15)  ;
							DECLARE @OldPostal_Code_2   int           ;
							DECLARE @OldINN_2           int           ;
							DECLARE @OldDescription_2   nvarchar(1000);



							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
											     @OldID_Branch_2   = D.ID_Branch     ,
												 @OldId_Country_2  = D.Id_Country  	,
												 @OldCity_2        = D.City        	,
												 @OldAddress_2     = D.[Address]     ,
												 @OldName_Branch_2 = D.Name_Branch 	,
												 @OldMail_2        = D.Mail        	,
												 @OldPhone_2       = D.Phone       	,
												 @OldPostal_Code_2 = D.Postal_Code 	,
												 @OldINN_2         = D.INN         	,
												 @OldDescription_2 = D.[Description]   
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_Branch;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Branch'           +' = "'+  ISNULL(CAST(@OldID_Branch_2     AS NVARCHAR(50)),'')     + '", '
							                + 'Id_Country'          +' = "'+  ISNULL(CAST(@OldId_Country_2  AS NVARCHAR(50)),'') + '", '
							                + 'City'                +' = "'+  ISNULL(@OldCity_2,'')+ '", '				
							                + 'Address'             +' = "'+  ISNULL(@OldAddress_2,'')+ '", '
							                + 'Name_Branch'         +' = "'+  ISNULL(@OldName_Branch_2,'') + '", '
							                + 'Mail'                +' = "'+  ISNULL(@OldMail_2,'')+ '", '	   + '", '
							                + 'Phone'               +' = "'+  ISNULL(@OldPhone_2,'')+ '", '
								            + 'Postal_Code'         +' = "'+  ISNULL(CAST(@OldPostal_Code_2  AS NVARCHAR(50)),'') + '", '
							                + 'INN'                 +' = "'+  ISNULL(CAST(@OldINN_2  AS NVARCHAR(50)),'') + '", '
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Branch_Audit
                                           ( 
                                            ID_Branch,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Branch,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Branch = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Branch_Audit
                                       ( 
                                        ID_Branch,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Buyer_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_buyer               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group;


go

CREATE TRIGGER trg_Buyer_Audit ON Buyer
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_buyer,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_buyer,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;

							DECLARE @OldId_buyer                    bigint        ;
							DECLARE @OldID_Connection_Buyer         bigint        ;
							DECLARE @OldId_Status                   bigint        ;
							DECLARE @OldId_Buyer_Type               bigint        ;
							DECLARE @OldName                        nvarchar(100) ;
							DECLARE @OldSurName                     nvarchar(100) ;
							DECLARE @OldLastName                    nvarchar(100) ;
							DECLARE @OldMail                        nvarchar(250) ;
							DECLARE @OldPol                         char(1)       ;
							DECLARE @OldPhone                       nvarchar(30)  ;
							DECLARE @OldDate_Of_Birth               datetime      ;
							DECLARE @OldPremium                     bit           ;
							DECLARE @OldThe_resident                bit			  ;
							DECLARE @OldDescription                 nvarchar(4000);
							
							DECLARE @NewId_buyer                    bigint        ;
							DECLARE @NewID_Connection_Buyer         bigint        ;
							DECLARE @NewId_Status                   bigint        ;
							DECLARE @NewId_Buyer_Type               bigint        ;
							DECLARE @NewName                        nvarchar(100) ;
							DECLARE @NewSurName                     nvarchar(100) ;
							DECLARE @NewLastName                    nvarchar(100) ;
							DECLARE @NewMail                        nvarchar(250) ;
							DECLARE @NewPol                         char(1)       ;
							DECLARE @NewPhone                       nvarchar(30)  ;
							DECLARE @NewDate_Of_Birth               datetime      ;
							DECLARE @NewPremium                     bit           ;
							DECLARE @NewThe_resident                bit			  ;
							DECLARE @NewDescription                 nvarchar(4000);


						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

								        SELECT 
							                @NewId_buyer             = I.Id_buyer           , 
							            	@NewID_Connection_Buyer  = I.ID_Connection_Buyer,
							            	@NewId_Status            = I.Id_Status          ,
											@NewId_Buyer_Type        = I.Id_Buyer_Type      ,
							            	@NewName                 = I.Name               ,
							            	@NewSurName              = I.SurName            ,
							            	@NewLastName             = I.LastName           ,
							            	@NewMail                 = I.Mail               ,
							            	@NewPol                  = I.Pol                ,
							            	@NewPhone                = I.Phone              ,
							            	@NewDate_Of_Birth        = I.Date_Of_Birth      ,
											@NewPremium     		 = I.Premium            ,
											@NewThe_resident         = I.The_resident		,
							            	@NewDescription          = I.[Description]        	
							            FROM inserted I									 
							            where @ID_entity_D = I.Id_buyer;

                                        SELECT 
							                @OldId_buyer             = D.Id_buyer           , 
							            	@OldID_Connection_Buyer  = D.ID_Connection_Buyer,
							            	@OldId_Status            = D.Id_Status          ,
											@OldId_Buyer_Type        = D.Id_Buyer_Type      ,
							            	@OldName                 = D.Name               ,
							            	@OldSurName              = D.SurName            ,
							            	@OldLastName             = D.LastName           ,
							            	@OldMail                 = D.Mail               ,
							            	@OldPol                  = D.Pol                ,
							            	@OldPhone                = D.Phone              ,
							            	@OldDate_Of_Birth        = D.Date_Of_Birth      ,
											@OldPremium     		 = D.Premium            ,
											@OldThe_resident         = D.The_resident		,
							            	@OldDescription          = D.[Description]        							
							            FROM Deleted D
										where @ID_entity_D = D.Id_buyer;


                                       IF ISNULL(CAST(@NewID_Connection_Buyer AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Connection_Buyer AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Connection_Buyer = Old ->"' +  ISNULL(CAST(@OldID_Connection_Buyer AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Connection_Buyer AS NVARCHAR(50)),'') + '", ';
							              end
                                       
							           IF ISNULL(CAST(@NewId_Status  AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldId_Status  AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Status = Old ->"' +  ISNULL(CAST(@OldId_Status AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewId_Status AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewId_Buyer_Type AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldId_Buyer_Type AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Buyer_Type = Old ->"' +  ISNULL(CAST(@OldId_Buyer_Type AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewId_Buyer_Type AS NVARCHAR(50)),'') + '", ';
							              end

							           IF isnull(@NewName,'null') <> isnull(@OldName,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							              end
                                                                                               
							           IF isnull(@NewSurName,'null') <> isnull(@OldSurName,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SurName = Old ->"' +  ISNULL(@OldSurName,'') + ' " NEW -> " ' + isnull(@NewSurName,'') + '", ';
							              end

							           IF isnull(@NewLastName,'null') <> isnull(@OldLastName,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  LastName = Old ->"' +  ISNULL(@OldLastName,'') + ' " NEW -> " ' + isnull(@NewLastName,'') + '", ';
							              end

							           IF isnull(@NewMail,'null') <> isnull(@OldMail,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							              end
							           
							           IF ISNULL(CAST(@NewPol AS NVARCHAR(1)),'null') <> ISNULL(CAST(@OldPol AS NVARCHAR(1)),'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Pol = Old ->"' +  ISNULL(CAST(@OldPol AS NVARCHAR(1)),'') + ' " NEW -> " ' + isnull(CAST(@NewPol AS NVARCHAR(1)),'') + '", ';
							              end

							           IF isnull(@NewPhone,'null') <> isnull(@OldPhone,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> " ' + isnull(@NewPhone,'') + '", ';
							              end
                           	           			
							           IF ISNULL(CAST(Format(@NewDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Birth = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

									   IF ISNULL(CAST(@NewPremium AS NVARCHAR(1)),'null') <> ISNULL(CAST(@OldPremium AS NVARCHAR(1)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Premium = Old ->"' +  ISNULL(CAST(@OldPremium AS NVARCHAR(1)),'') + ' " NEW -> "' + isnull(CAST(@NewPremium AS NVARCHAR(1)),'') + '", ';
							                 end

                                       IF ISNULL(CAST(@NewThe_resident AS NVARCHAR(1)),'null') <> ISNULL(CAST(@OldThe_resident AS NVARCHAR(1)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  The_resident = Old ->"' +  ISNULL(CAST(@OldThe_resident AS NVARCHAR(1)),'') + ' " NEW -> "' + isnull(CAST(@NewThe_resident AS NVARCHAR(1)),'') + '", ';
							                 end
							           
                                       IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end

                                       SET @ChangeDescription = 'Updated: ' + ' Id_buyer = "' +  isnull(cast(@OldId_buyer as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Buyer_Audit
                                        ( 
                                         Id_buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_buyer,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                            DECLARE @OldId_buyer_2                    bigint         ;
							DECLARE @OldID_Connection_Buyer_2         bigint       	 ;
							DECLARE @OldId_Status_2                   bigint       	 ;
							DECLARE @OldId_Buyer_Type_2               bigint         ;
							DECLARE @OldName_2                        nvarchar(100)	 ;
							DECLARE @OldSurName_2                     nvarchar(100)	 ;
							DECLARE @OldLastName_2                    nvarchar(100)	 ;
							DECLARE @OldMail_2                        nvarchar(250)	 ;
							DECLARE @OldPol_2                         char(1)      	 ;
							DECLARE @OldPhone_2                       nvarchar(30) 	 ;
							DECLARE @OldDate_Of_Birth_2               datetime     	 ;
							DECLARE @OldPremium_2                     bit            ;
							DECLARE @OldThe_resident_2                bit			 ;
							DECLARE @OldDescription_2                 nvarchar(4000) ;



							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
							                    @OldId_buyer_2             = D.Id_buyer           , 
							                	@OldID_Connection_Buyer_2  = D.ID_Connection_Buyer,
							                	@OldId_Status_2            = D.Id_Status          ,
												@OldId_Buyer_Type_2        = D.Id_Buyer_Type      ,
							                	@OldName_2                 = D.Name               ,
							                	@OldSurName_2              = D.SurName            ,
							                	@OldLastName_2             = D.LastName           ,
							                	@OldMail_2                 = D.Mail               ,
							                	@OldPol_2                  = D.Pol                ,
							                	@OldPhone_2                = D.Phone              ,
							                	@OldDate_Of_Birth_2        = D.Date_Of_Birth      ,
												@OldPremium_2              = D.Premium            ,
												@OldThe_resident_2		   = D.The_resident		  ,
							                	@OldDescription_2          = D.[Description]        
							                FROM deleted D									 
											where @ID_entity_D_2 = D.Id_buyer;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'Id_buyer'            +' = "'+  ISNULL(CAST(@OldId_buyer_2     AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Connection_Buyer' +' = "'+  ISNULL(CAST(@OldID_Connection_Buyer_2  AS NVARCHAR(50)),'') + '", '
							                + 'Id_Status'           +' = "'+  ISNULL(CAST(@OldId_Status_2 AS NVARCHAR(50)),'') + '", '
											+ 'Id_Buyer_Type'       +' = "'+  ISNULL(CAST(@OldId_Buyer_Type_2 AS NVARCHAR(50)),'') + '", '
							                + 'Name'                +' = "'+  ISNULL(@OldName_2,'')+ '", '				
							                + 'SurName'             +' = "'+  ISNULL(@OldSurName_2,'')+ '", '
							                + 'LastName'            +' = "'+  ISNULL(@OldLastName_2,'') + '", '
							                + 'Mail'                +' = "'+  ISNULL(@OldMail_2,'')+ '", '
							                + 'Pol'                 +' = "'+  ISNULL(CAST(@OldPol_2 AS NVARCHAR(1)),'')+ '", '
							                + 'Phone'               +' = "'+  ISNULL(@OldPhone_2,'')+ '", '
							                + 'Date_Of_Birth'       +' = "'+  ISNULL(CAST(Format(@OldDate_Of_Birth_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
											+ 'Premium'             +' = "'+  ISNULL(CAST(@OldPremium_2 AS NVARCHAR(1)),'')+ '", '
											+ 'The_resident'        +' = "'+  ISNULL(CAST(@OldThe_resident_2 AS NVARCHAR(1)),'')+ '", '
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Buyer_Audit
                                           ( 
                                            Id_buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.Id_buyer,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'Id_buyer = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Buyer_Audit
                                       ( 
                                        Id_buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Buyer_status_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Status              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group;


go

CREATE TRIGGER trg_Buyer_status_Audit ON Buyer_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      

						   DECLARE @OldId_Status                bigint          ;
						   DECLARE @OldName                  	nvarchar(300)  	;
						   DECLARE @OldSysTypeBuyerStatusName	nvarchar(300) 	;
						   DECLARE @OldDescription      	    nvarchar(4000)	;


						   DECLARE @NewId_Status                bigint          ;
						   DECLARE @NewName                  	nvarchar(300)  	;
						   DECLARE @NewSysTypeBuyerStatusName	nvarchar(300) 	;
						   DECLARE @NewDescription      	    nvarchar(4000)	;
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewId_Status                 = I.Id_Status                  ,
							                	  @NewName                  	= I.Name                  	 ,
							                	  @NewSysTypeBuyerStatusName	= I.SysTypeBuyerStatusName	 ,
							                	  @NewDescription      	        = I.[Description]      	
							                FROM inserted I									 
							                where @ID_entity_D = I.Id_Status;	

							                SELECT 
                                                  @OldId_Status                 = D.Id_Status                  ,
							                	  @OldName                  	= D.Name                  	 ,
							                	  @OldSysTypeBuyerStatusName	= D.SysTypeBuyerStatusName	 ,  	
							                	  @OldDescription      	        = D.[Description]      	
							                FROM Deleted D																		 
											 where @ID_entity_D = D.Id_Status; 


                                            IF isnull(@NewName,'null') <> isnull(@OldName,'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							                   end
                                            
							                IF isnull(@NewSysTypeBuyerStatusName,'null') <> isnull(@OldSysTypeBuyerStatusName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeBuyerStatusName = Old ->"' +  ISNULL(@OldSysTypeBuyerStatusName,'') + ' " NEW -> " ' + isnull(@NewSysTypeBuyerStatusName,'') + '", ';
							                   end
                                                                                                    
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Status = "' +  isnull(cast(@OldId_Status as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Buyer_status_Audit
                                            ( 
                                             Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                            DECLARE @OldId_Status_2                 bigint          ;
							DECLARE @OldName_2                  	nvarchar(300)  	;
							DECLARE @OldSysTypeBuyerStatusName_2	nvarchar(300) 	;
							DECLARE @OldDescription_2      	        nvarchar(4000)	;

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
                                              @OldId_Status_2               = D.Id_Status               ,
							               	  @OldName_2                    = D.Name                    ,
							               	  @OldSysTypeBuyerStatusName_2  = D.SysTypeBuyerStatusName  ,
							               	  @OldDescription_2             = D.[Description]      		  
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.Id_Status;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'Id_Status'               +' = "'+  ISNULL(CAST(@OldId_Status_2  AS NVARCHAR(50)),'')+ '", '
							               + 'Name'                    +' = "'+  ISNULL(@OldName_2,'')+ '", '
							               + 'SysTypeBuyerStatusName'  +' = "'+  ISNULL(@OldSysTypeBuyerStatusName_2,'')+ '", '
							               + '[Description]'           +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Buyer_status_Audit
                                           ( 
                                            Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.Id_Status,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Status = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Buyer_status_Audit
                                      ( 
                                       Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''              

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Buyer_Type_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Buyer_Type          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group;


go

CREATE TRIGGER trg_Buyer_Type_Audit ON Buyer_Type
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)= '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Buyer_Type,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Buyer_Type,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      

						   DECLARE @OldId_Buyer_Type            bigint          ;
						   DECLARE @OldName                  	nvarchar(300)  	;
						   DECLARE @OldSysTypeBuyerTypeName  	nvarchar(300) 	;
						   DECLARE @OldDescription      	    nvarchar(4000)	;


						   DECLARE @NewId_Buyer_Type            bigint          ;
						   DECLARE @NewName                  	nvarchar(300)  	;
						   DECLARE @NewSysTypeBuyerTypeName 	nvarchar(300) 	;
						   DECLARE @NewDescription      	    nvarchar(4000)	;
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewId_Buyer_Type         = I.Id_Buyer_Type       ,
							                	  @NewName                 	= I.Name                ,
							                	  @NewSysTypeBuyerTypeName 	= I.SysTypeBuyerTypeName,
							                	  @NewDescription      	    = I.[Description]      	
							                FROM inserted I									 
							                where @ID_entity_D = I.Id_Buyer_Type;	

							                SELECT 
                                                  @OldId_Buyer_Type         = D.Id_Buyer_Type       ,
							                	  @OldName                 	= D.Name                ,
							                	  @OldSysTypeBuyerTypeName 	= D.SysTypeBuyerTypeName,  	
							                	  @OldDescription      	    = D.[Description]      	
							                FROM Deleted D																		 
											 where @ID_entity_D = D.Id_Buyer_Type; 


                                            IF isnull(@NewName,'null') <> isnull(@OldName,'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							                   end
                                            
							                IF isnull(@NewSysTypeBuyerTypeName,'null') <> isnull(@OldSysTypeBuyerTypeName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeBuyerTypeName = Old ->"' +  ISNULL(@OldSysTypeBuyerTypeName,'') + ' " NEW -> " ' + isnull(@NewSysTypeBuyerTypeName,'') + '", ';
							                   end
                                                                                                    
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Buyer_Type = "' +  isnull(cast(@OldId_Buyer_Type as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Buyer_Type_Audit
                                            ( 
                                             Id_Buyer_Type,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Buyer_Type,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                            DECLARE @OldId_Buyer_Type_2         bigint        ;
							DECLARE @OldName_2                  nvarchar(300) ;
							DECLARE @OldSysTypeBuyerTypeName_2	nvarchar(300) ;
							DECLARE @OldDescription_2      	    nvarchar(4000);

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
                                              @OldId_Buyer_Type_2         = D.Id_Buyer_Type       ,
							               	  @OldName_2                  = D.Name                ,
							               	  @OldSysTypeBuyerTypeName_2  = D.SysTypeBuyerTypeName,
							               	  @OldDescription_2      	  = D.[Description]      		  
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.Id_Buyer_Type;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'Id_Buyer_Type'         +' = "'+  ISNULL(CAST(@OldId_Buyer_Type_2  AS NVARCHAR(50)),'')+ '", '
							               + 'Name'                  +' = "'+  ISNULL(@OldName_2,'')+ '", '
							               + 'SysTypeBuyerTypeName'  +' = "'+  ISNULL(@OldSysTypeBuyerTypeName_2,'')+ '", '
							               + '[Description]'         +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Buyer_Type_Audit
                                           ( 
                                            Id_Buyer_Type,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.Id_Buyer_Type,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Buyer_Type = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Buyer_Type_Audit
                                      ( 
                                       Id_Buyer_Type,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''              

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Condition_of_the_item_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Condition_of_the_item  bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Condition_of_the_item_Audit ON Condition_of_the_item
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Condition_of_the_item,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Condition_of_the_item,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
						   DECLARE @OldID_Condition_of_the_item       bigint         ;
						   DECLARE @OldName_Condition_of_the_item     nvarchar(300)	 ;
						   DECLARE @OldSysNameConditionTypeOfTheItem  nvarchar(300)	 ;
						   DECLARE @OldDescription                    nvarchar(4000) ;

                           DECLARE @NewID_Condition_of_the_item       bigint         ;
						   DECLARE @NewName_Condition_of_the_item     nvarchar(300)	 ;
						   DECLARE @NewSysNameConditionTypeOfTheItem  nvarchar(300)	 ;
						   DECLARE @NewDescription                    nvarchar(4000) ;

						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try 
								            set @ChangeDescription = ''

							                SELECT 
							                    @NewID_Condition_of_the_item       = I.ID_Condition_of_the_item     ,
							                	@NewName_Condition_of_the_item     = I.Name_Condition_of_the_item   ,
							                	@NewSysNameConditionTypeOfTheItem  = I.SysNameConditionTypeOfTheItem,
							                	@NewDescription                    = I.[Description]        	  
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_Condition_of_the_item;
											
                                           SELECT 
							                    @OldID_Condition_of_the_item       = D.ID_Condition_of_the_item     ,
							                	@OldName_Condition_of_the_item     = D.Name_Condition_of_the_item   ,
							                	@OldSysNameConditionTypeOfTheItem  = D.SysNameConditionTypeOfTheItem,
							                	@OldDescription                    = D.[Description]  					
							                FROM Deleted D
											where @ID_entity_D = D.ID_Condition_of_the_item;																			 
                                           
							               IF isnull(@NewName_Condition_of_the_item,'null') <> isnull(@OldName_Condition_of_the_item,'null')
							                  begin
							                   SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Condition_of_the_item = Old ->"' +  ISNULL(@OldName_Condition_of_the_item,'') + ' " NEW -> "' + isnull(@NewName_Condition_of_the_item,'') + '", ';
							                  end
							               
							               IF isnull(@NewSysNameConditionTypeOfTheItem,'null') <> isnull(@OldSysNameConditionTypeOfTheItem,'null')
							                  begin
							                   SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysNameConditionTypeOfTheItem = Old ->"' +  ISNULL(@OldSysNameConditionTypeOfTheItem,'') + ' " NEW -> "' + isnull(@NewSysNameConditionTypeOfTheItem,'') + '", ';
							                  end                  
							               
                                           IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                  begin
                                               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                              end

                                           SET @ChangeDescription = 'Updated: ' + ' ID_Condition_of_the_item = "' +  isnull(cast(@OldID_Condition_of_the_item as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                            --Удаляем запятую на конце
                                           IF LEN(@ChangeDescription) > 0
                                               SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                           INSERT  INTO dbo.Condition_of_the_item_Audit
                                           ( 
                                            ID_Condition_of_the_item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                             SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									       set @ChangeDescription = '' 
                                            
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Condition_of_the_item,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

 

                           DECLARE @OldID_Condition_of_the_item_2       bigint         ;
						   DECLARE @OldName_Condition_of_the_item_2     nvarchar(300)  ;
						   DECLARE @OldSysNameConditionTypeOfTheItem_2  nvarchar(300)  ;
						   DECLARE @OldDescription_2                    nvarchar(4000) ;    	  	


						    declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									    set @ChangeDescription = ''

                                        SELECT 
							                @OldID_Condition_of_the_item_2      = D.ID_Condition_of_the_item     ,
							            	@OldName_Condition_of_the_item_2    = D.Name_Condition_of_the_item   ,
							            	@OldSysNameConditionTypeOfTheItem_2 = D.SysNameConditionTypeOfTheItem,
							            	@OldDescription_2                   = D.[Description]        
							            FROM deleted D									 
							            where @ID_entity_D_2 = D.ID_Condition_of_the_item

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_Condition_of_the_item'      +' = "'+  ISNULL(CAST(@OldID_Condition_of_the_item_2 AS NVARCHAR(50)),'')+ '", '
							            + 'Name_Condition_of_the_item'    +' = "'+  ISNULL(@OldName_Condition_of_the_item_2,'')+ '", '
							            + 'SysNameConditionTypeOfTheItem' +' = "'+  ISNULL(@OldSysNameConditionTypeOfTheItem_2,'') + '", '
            				            + 'Description'                   +' = "'+  ISNULL(@OldDescription_2,'') + '", '

							            IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                        
										INSERT  INTO dbo.Condition_of_the_item_Audit
                                        ( 
                                         ID_Condition_of_the_item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									    set @ChangeDescription = ''
                                     
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Condition_of_the_item,@login_name,GETDATE(),'I'  
					FROM  inserted I  

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Condition_of_the_item = "' + CAST(@ID_entity_D_2 AS NVARCHAR(50)) + '" ';
                                     
									 INSERT  INTO dbo.Condition_of_the_item_Audit
                                     ( 
                                      ID_Condition_of_the_item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''
							  end try
							  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE Connection_Buyer_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Connection_Buyer    bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group;


go

CREATE TRIGGER trg_Connection_Buyer_Audit ON Connection_Buyer
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Connection_Buyer,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Connection_Buyer,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      

						   DECLARE @OldID_Connection_Buyer  bigint          ;
						   DECLARE @OldPassword           	nvarchar(50)  	;
						   DECLARE @OldLogin              	nvarchar(100) 	;
						   DECLARE @OldDate_Created       	datetime      	;
						   DECLARE @OldDescription      	nvarchar(1000)	;


						   DECLARE @NewID_Connection_Buyer  bigint          ;
						   DECLARE @NewPassword           	nvarchar(50)  	;
						   DECLARE @NewLogin              	nvarchar(100) 	;
						   DECLARE @NewDate_Created       	datetime      	;
						   DECLARE @NewDescription      	nvarchar(1000)	;
                           
						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
                                              @NewID_Connection_Buyer = I.ID_Connection_Buyer,
							            	  @NewPassword            = I.Password           ,
							            	  @NewLogin               = I.Login              ,
							            	  @NewDate_Created        = I.Date_Created       ,
							            	  @NewDescription      	  = I.[Description]      	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Connection_Buyer

								        SELECT 
                                              @OldID_Connection_Buyer = D.ID_Connection_Buyer,
							            	  @OldPassword            = D.Password           ,
							            	  @OldLogin               = D.Login              ,
							            	  @OldDate_Created        = D.Date_Created       ,
							            	  @OldDescription      	  = D.[Description]      	
							            FROM Deleted D
										where @ID_entity_D = D.ID_Connection_Buyer 
																	 

                                        IF isnull(@NewPassword,'null') <> isnull(@OldPassword,'null') 
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Password = Old ->"' +  ISNULL(@OldPassword,'') + ' " NEW -> " ' + isnull(@NewPassword,'') + '", ';
							               end
                                        
							            IF isnull(@NewLogin,'null') <> isnull(@OldLogin,'null') 
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Login = Old ->"' +  ISNULL(@OldLogin,'') + ' " NEW -> " ' + isnull(@NewLogin,'') + '", ';
							               end

							            IF ISNULL(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Created = Old ->"' +  ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
                                                                                                
                                        IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                           end

                                        SET @ChangeDescription = 'Updated: ' + ' ID_Connection_Buyer = "' +  isnull(cast(@OldID_Connection_Buyer as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                             			INSERT  INTO dbo.Connection_Buyer_Audit
                                        ( 
                                         ID_Connection_Buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                        SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = ''
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr


                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Connection_Buyer,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                             DECLARE @OldID_Connection_Buyer_2  bigint          ;
							 DECLARE @OldPassword_2           	nvarchar(50)  	;
							 DECLARE @OldLogin_2              	nvarchar(100) 	;
							 DECLARE @OldDate_Created_2       	datetime      	;
							 DECLARE @OldDescription_2         	nvarchar(4000)	;
                             
						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
                                              @OldID_Connection_Buyer_2	   = D.ID_Connection_Buyer  ,
							            	  @OldPassword_2           	   = D.Password             ,
							            	  @OldLogin_2              	   = D.Login                ,
							            	  @OldDate_Created_2       	   = D.Date_Created         ,
							            	  @OldDescription_2            = D.[Description]      	  
							            FROM deleted D
										where @ID_entity_D_2 = D.ID_Connection_Buyer

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_Connection_Buyer'  +' = "'+  ISNULL(CAST(@OldID_Connection_Buyer_2  AS NVARCHAR(50)),'')+ '", '
							            + 'Password'             +' = "'+  ISNULL(@OldPassword_2,'')+ '", '
							            + 'Login'                +' = "'+  ISNULL(@OldLogin_2,'')+ '", '
							            + 'Date_Created'         +' = "'+  ISNULL(CAST(Format(@OldDate_Created_2,'yyyy-MM-dd HH:mm:ss.fff')AS NVARCHAR(50)),'')+ '", '
							            + '[Description]'        +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                          
						               IF LEN(@ChangeDescription) > 0
                                             SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                       INSERT  INTO dbo.Connection_Buyer_Audit
                                       ( 
                                        ID_Connection_Buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = '' 
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					); 

                    insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Connection_Buyer,@login_name,GETDATE(),'I'  
					FROM  inserted I
		            

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							       set @ChangeDescription = ''

                                   SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Connection_Buyer = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                   
								   INSERT  INTO dbo.Connection_Buyer_Audit
                                   ( 
                                    ID_Connection_Buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                   )
                                    SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

                              end try
							  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3          

                    END

GO


CREATE TABLE Connection_String_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Connection_String   bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Connection_String_Audit ON Connection_String
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) ='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Connection_String,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Connection_String,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;

                            DECLARE @OldID_Connection_String   bigint        ;
							DECLARE @OldPassword               nvarchar(50)  ;
							DECLARE @OldLogin                  nvarchar(100) ;
							DECLARE @OldDate_Created           datetime      ;
							DECLARE @OldDescription            nvarchar(1000);

							DECLARE @NewID_Connection_String   bigint        ;
							DECLARE @NewPassword               nvarchar(50)  ;
							DECLARE @NewLogin                  nvarchar(100) ;
							DECLARE @NewDate_Created           datetime      ;
							DECLARE @NewDescription            nvarchar(1000);


						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
                                               @NewID_Connection_String = I.ID_Connection_String,
											   @NewPassword             = I.[Password]          ,  
											   @NewLogin                = I.[Login]             ,  
											   @NewDate_Created         = I.Date_Created        ,
											   @NewDescription          = I.[Description]          	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Connection_String;

                                        SELECT 
                                               @OldID_Connection_String = D.ID_Connection_String,
											   @OldPassword             = D.[Password]          ,  
											   @OldLogin                = D.[Login]             ,  
											   @OldDate_Created         = D.Date_Created        ,
											   @OldDescription          = D.[Description]          							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Connection_String;


							           IF isnull(@NewPassword,'null') <> isnull(@OldPassword,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Password = Old ->"' +  ISNULL(@OldPassword,'') + ' " NEW -> " ' + isnull(@NewPassword,'') + '", ';
							              end

							           IF isnull(@NewLogin,'null') <> isnull(@OldLogin,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Login = Old ->"' +  ISNULL(@OldLogin,'') + ' " NEW -> " ' + isnull(@NewLogin,'') + '", ';
							              end

							           IF ISNULL(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Created = Old ->"' +  ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end
							           
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end

                                       SET @ChangeDescription = 'Updated: ' + ' ID_Connection_String = "' +  isnull(cast(@OldID_Connection_String as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Connection_String_Audit
                                        ( 
                                         ID_Connection_String,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Connection_String,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							
                            DECLARE @OldID_Connection_String_2   bigint        ;
							DECLARE @OldPassword_2               nvarchar(50)  ;
							DECLARE @OldLogin_2                  nvarchar(100) ;
							DECLARE @OldDate_Created_2           datetime      ;
							DECLARE @OldDescription_2            nvarchar(1000);

							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
                                                   @OldID_Connection_String_2 = D.ID_Connection_String,
												   @OldPassword_2             = D.[Password]          , 
												   @OldLogin_2                = D.[Login]             , 
												   @OldDate_Created_2         = D.Date_Created        ,
												   @OldDescription_2          = D.[Description]               
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_Connection_String;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Connection_String' +' = "'+  ISNULL(CAST(@OldID_Connection_String_2 AS NVARCHAR(50)),'') + '", '
						                    + 'Password'             +' = "'+  ISNULL(@OldPassword_2,'')+ '", '				
							                + 'Login'                +' = "'+  ISNULL(@OldLogin_2,'')+ '", ' 
							                + 'Date_Created'         +' = "'+  ISNULL(CAST(Format(@OldDate_Created_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Description'          +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Connection_String_Audit
                                           ( 
                                            ID_Connection_String,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Connection_String,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Connection_String = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Connection_String_Audit
                                       ( 
                                        ID_Connection_String,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Country_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Country             bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
  --  PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Country_Audit ON Country
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;
	
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)= '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN


							declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Country,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Country,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


						   DECLARE @OldId_Country         bigint        ;
						   DECLARE @OldName_Country       nvarchar(150) ;
						   DECLARE @OldName_English       nvarchar(150) ;
						   DECLARE @OldCod_Country_Phone  nvarchar(10)  ;

						   DECLARE @NewId_Country         bigint        ;
						   DECLARE @NewName_Country       nvarchar(150) ;
						   DECLARE @NewName_English       nvarchar(150) ;
						   DECLARE @NewCod_Country_Phone  nvarchar(10)  ;
						   
						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								     set @ChangeDescription = ''

									 SELECT 
										@NewId_Country       	 = I.Id_Country       ,
										@NewName_Country     	 = I.Name_Country     ,
										@NewName_English     	 = I.Name_English     ,
										@NewCod_Country_Phone    = I.Cod_Country_Phone 
									 FROM inserted I  
									 where @ID_entity_D = I.Id_Country;	
									 
									 SELECT  
									     @OldId_Country        =   D.Id_Country       ,
										 @OldName_Country      =   D.Name_Country     ,
										 @OldName_English      =   D.Name_English     ,
										 @OldCod_Country_Phone =   D.Cod_Country_Phone
									 FROM   Deleted D 
									 where @ID_entity_D = D.Id_Country 
				
														
                                     
									 IF isnull(@NewName_Country,'null') <> isnull(@OldName_Country,'null') 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Country = Old ->"' +  ISNULL(@OldName_Country,'') + ' " NEW -> " ' + isnull(@NewName_Country,'') + '", ';
							            end
                            
							        IF isnull(@NewName_English,'null') <> isnull(@OldName_English,'null')
							           begin
							             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_English = Old ->"' +  ISNULL(@OldName_English,'') + ' " NEW -> " ' + isnull(@NewName_English,'') + '", ';
							           end

							        IF isnull(@NewCod_Country_Phone,'null') <> isnull(@OldCod_Country_Phone,'null') 
							           begin
							             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Cod_Country_Phone = Old ->"' +  ISNULL(@OldCod_Country_Phone,'') + ' " NEW -> " ' + isnull(@NewCod_Country_Phone,'') + '", ';
							           end
                                    
									SET @ChangeDescription = 'Updated: ' + ' Id_Country = "' +  isnull(cast(@OldId_Country as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')

									IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);


                                    INSERT  INTO dbo.Country_Audit
                                     ( 
                                      Id_Country,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									set @ChangeDescription = '' 

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
							  					
                END
            ELSE
                BEGIN						  
							declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Country,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

						   DECLARE @OldId_Country_2         bigint        ;
						   DECLARE @OldName_Country_2       nvarchar(150) ;
						   DECLARE @OldName_English_2       nvarchar(150) ;
						   DECLARE @OldCod_Country_Phone_2  nvarchar(10)  ;
						   
						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								     set @ChangeDescription = ''

									 SELECT  
									     @OldId_Country_2        =   D.Id_Country       ,
										 @OldName_Country_2      =   D.Name_Country     ,
										 @OldName_English_2      =   D.Name_English     ,
										 @OldCod_Country_Phone_2 =   D.Cod_Country_Phone
									 FROM   Deleted D 
									 where @ID_entity_D_2 = D.Id_Country 
					
					                 SET @ChangeDescription = 'Deleted: '
							         + 'Id_Country'                +' = "'+  ISNULL(CAST(@OldId_Country_2  AS NVARCHAR(50)),'')+ '", '
							         + 'Name_Country'              +' = "'+  ISNULL(@OldName_Country_2,'')+ '", '				
							         + 'Name_English'              +' = "'+  ISNULL(@OldName_English_2,'')+ '", '
							         + 'Cod_Country_Phone'         +' = "'+  ISNULL(@OldCod_Country_Phone_2,'') + '", '


                                     IF LEN(@ChangeDescription) > 0
						                     SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                    INSERT  INTO dbo.Country_Audit
                                     ( 
                                      Id_Country,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN

				           DECLARE @ID_entity_I_2    bigint       ;
				           DECLARE @login_name_2_I_2 nvarchar(128);
				           DECLARE @ModifiedDate_I_2 DATETIME     ;
				           DECLARE @Name_action_I_2  char(1)      ;

							declare @t_I_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT I.Id_Country,@login_name,GETDATE(),'I'  
							FROM  inserted I
						   
						   declare cr_3 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_I_I 
                           open cr_3       
						   
						   fetch next from cr_3 into 
						   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								     set @ChangeDescription = ''				 
					
					                 SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Country = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
  
                                    INSERT  INTO dbo.Country_Audit
                                     ( 
                                      Id_Country,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END


GO


CREATE TABLE Currency_Audit
(
    AuditID              bigint IDENTITY(1,1)  not null,
    ID_Currency          bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
)on Orders_Group;

go

CREATE TRIGGER trg_Currency_Audit ON Currency
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)= '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                          declare @t_U_D table 
						  (
						  Id_Num         bigint        identity(1,1) not null,
						  ID_entity      bigint        null,
						  login_name     nvarchar(128) null,
						  ModifiedDate   DATETIME      null,
						  Name_action    char(1)       null
						  );
						  
						  declare @t_U_I table 
						  (
						  Id_Num         bigint        identity(1,1) not null,
						  ID_entity      bigint        null,
						  login_name     nvarchar(128) null,
						  ModifiedDate   DATETIME      null,
						  Name_action    char(1)       null
						  );
                          
						  insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
						  SELECT d.ID_Currency,@login_name,GETDATE(),'U'  
						  FROM  Deleted D
						  
						  insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
						  SELECT d.ID_Currency,@login_name,GETDATE(),'U'  
						  FROM  inserted D

						  DECLARE @ID_entity_D    bigint       ;
						  DECLARE @login_name_2_D nvarchar(128);
						  DECLARE @ModifiedDate_D DATETIME     ;
						  DECLARE @Name_action_D  char(1)      ;
						  
						  DECLARE @ID_entity_I    bigint       ;
						  DECLARE @login_name_2_I nvarchar(128);
						  DECLARE @ModifiedDate_I DATETIME     ;
						  DECLARE @Name_action_I  char(1)      ;
	                       
						   DECLARE @OldID_Currency         BIGINT
						   DECLARE @OldFull_name_rus       NVARCHAR(300);
						   DECLARE @OldFull_name_eng       NVARCHAR(300);
						   DECLARE @OldAbbreviation_rus    NVARCHAR(15);
						   DECLARE @OldAbbreviation_eng    NVARCHAR(15);
						   DECLARE @OldDescription         NVARCHAR(4000);

						   DECLARE @NewID_Currency         BIGINT
						   DECLARE @NewFull_name_rus       NVARCHAR(300);
						   DECLARE @NewFull_name_eng       NVARCHAR(300);
						   DECLARE @NewAbbreviation_rus    NVARCHAR(15);
						   DECLARE @NewAbbreviation_eng    NVARCHAR(15);
						   DECLARE @NewDescription         NVARCHAR(4000);


						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
						   open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
						         begin try
								 set @ChangeDescription = ''

								 SELECT 
								     @NewID_Currency       =   ID_Currency     ,
								 	 @NewFull_name_rus     =   Full_name_rus   ,
								 	 @NewFull_name_eng     =   Full_name_eng   ,
								 	 @NewAbbreviation_rus  =   Abbreviation_rus,
								 	 @NewAbbreviation_eng  =   Abbreviation_eng,
								 	 @NewDescription       =   [Description]    
								 FROM   Deleted D 
								 where @ID_entity_D = D.ID_Currency 

								 SELECT 
								     @OldID_Currency       =   ID_Currency     ,
									 @OldFull_name_rus     =   Full_name_rus   ,
									 @OldFull_name_eng     =   Full_name_eng   ,
									 @OldAbbreviation_rus  =   Abbreviation_rus,
									 @OldAbbreviation_eng  =   Abbreviation_eng,
									 @OldDescription       =   [Description]     
								 FROM   Deleted D 
								 where @ID_entity_D = D.ID_Currency 



                         
                            IF isnull(@NewFull_name_rus,'null') <> isnull(@OldFull_name_rus,'null') 
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Full_name_rus = Old ->"' +  ISNULL(@OldFull_name_rus,'') + ' " NEW -> " ' + isnull(@NewFull_name_rus,'') + '", ';
							   end

                            IF isnull(@NewFull_name_eng,'null') <> isnull(@OldFull_name_eng,'null')
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Full_name_eng = Old ->"' + ISNULL(@OldFull_name_eng,'') + ' " NEW -> "' + ISNULL(@NewFull_name_eng,'') + '", ';
							   end

                            IF isnull(@NewAbbreviation_rus,'null') <> isnull(@OldAbbreviation_rus,'null') 
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Abbreviation_rus = Old ->"' +  ISNULL(@OldAbbreviation_rus,'') + ' " NEW -> " ' + isnull(@NewAbbreviation_rus,'') + '", ';
							   end

                            IF isnull(@NewAbbreviation_eng,'null') <> isnull(@OldAbbreviation_eng,'null')
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Abbreviation_eng = Old ->"' + ISNULL(@OldAbbreviation_eng,'') + ' " NEW -> "' + ISNULL(@NewAbbreviation_eng,'') + '", ';
							   end

                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                               end

                            SET @ChangeDescription = 'Updated: ' + ' ID_Currency = "' +  isnull(cast(@OldID_Currency as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                             --Удаляем запятую на конце
                            IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                            INSERT  INTO dbo.Currency_Audit
                                     ( 
                                      ID_Currency,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
							set @ChangeDescription = '' 
                            
							end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
   					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Currency,@login_name,GETDATE(),'D'  
							FROM  Deleted D



							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Currency_2         BIGINT        ;
							DECLARE @OldFull_name_rus_2       NVARCHAR(300) ;
							DECLARE @OldFull_name_eng_2       NVARCHAR(300) ;
							DECLARE @OldAbbreviation_rus_2    NVARCHAR(15)  ;
							DECLARE @OldAbbreviation_eng_2    NVARCHAR(15)  ;
							DECLARE @OldDescription_2         NVARCHAR(4000);
                            
                            declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2   
                
                           fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								         set @ChangeDescription = ''

                                         SELECT 
							                 @OldID_Currency_2        = D.ID_Currency,     
							                 @OldFull_name_rus_2      = D.Full_name_rus,   
                                             @OldFull_name_eng_2      = D.Full_name_eng,   
                                             @OldAbbreviation_rus_2   = D.Abbreviation_rus,
                                             @OldAbbreviation_eng_2   = D.Abbreviation_eng,
                                             @OldDescription_2        = D.[Description]   
							             FROM deleted D
										 where @ID_entity_D_2 = D.ID_Currency


                                        SET @ChangeDescription = 'Deleted: '
                                                + 'ID_Currency'      +' = "'+ ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(50)), '') + '", '
                                                + 'Full_name_rus'    +' = "'+ ISNULL(@OldFull_name_rus_2, '') + '", '
							            		+ 'Full_name_eng'    +' = "'+ ISNULL(@OldFull_name_eng_2, '') + '", '
                                                + 'Abbreviation_rus' +' = "'+ ISNULL(@OldAbbreviation_rus_2, '') + '", '
							            		+ 'Abbreviation_eng' +' = "'+ ISNULL(@OldAbbreviation_eng_2, '') + '", '
                                                + 'Description'      +' = "'+ ISNULL(@OldDescription_2, '') + '" ';

                                        IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                       INSERT  INTO dbo.Currency_Audit
									    ( 
									     ID_Currency,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
									    )
									     SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;      
									    
									   set @ChangeDescription = ''
									end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
									   
                END  
        END
    ELSE
        BEGIN
		            DECLARE @ID_entity_I_2    bigint       ;
					DECLARE @login_name_2_I_2 nvarchar(128);
					DECLARE @ModifiedDate_I_2 DATETIME     ;
					DECLARE @Name_action_I_2  char(1)      ;


					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Currency,@login_name,GETDATE(),'I'  
					FROM  inserted I

					declare cr_3 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_I_I 
                           open cr_3       
						   
						   fetch next from cr_3 into 
						   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								   set @ChangeDescription = ''
		            
                                   SET @ChangeDescription = 'Inserted: '
                                              + 'ID_Currency = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                   
								   INSERT  INTO dbo.Currency_Audit
                                     ( 
                                      ID_Currency,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

								 end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3             

                    END

GO


CREATE TABLE Currency_Rate_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Currency_Rate       bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Currency_Rate_Audit ON Currency_Rate
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Currency_Rate,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Currency_Rate,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                          
							DECLARE @OldID_Currency_Rate        bigint          ;
							DECLARE @OldID_Currency             bigint       	;
							DECLARE @OldAmount_Rate             decimal(5,2)    ;
							DECLARE @OldValid_from              datetime     	;
							DECLARE @OldValid_to                datetime     	;
							DECLARE @OldJSON_Currency_Rate_Data nvarchar(max)	;
							DECLARE @OldDescription             nvarchar(4000)	;

							DECLARE @NewID_Currency_Rate        bigint          ;
							DECLARE @NewID_Currency             bigint       	;
							DECLARE @NewAmount_Rate             decimal(5,2)    ;
							DECLARE @NewValid_from              datetime     	;
							DECLARE @NewValid_to                datetime     	;
							DECLARE @NewJSON_Currency_Rate_Data nvarchar(max)	;
							DECLARE @NewDescription             nvarchar(4000)	;
                            
                            declare cr cursor local fast_forward for
						   
						    select 
						    ID_entity    
						    ,login_name   
						    ,ModifiedDate 
						    ,Name_action  
						    from @t_U_D 
                            open cr       
						    
						    fetch next from cr into 
						    @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

							                SELECT  
                                                  @NewID_Currency_Rate         =  I.ID_Currency_Rate         ,
							                	  @NewID_Currency              =  I.ID_Currency              ,
							                	  @NewAmount_Rate              =  I.Amount_Rate              ,
							                	  @NewValid_from               =  I.Valid_from               ,
							                	  @NewValid_to                 =  I.Valid_to                 ,
							                	  @NewJSON_Currency_Rate_Data  =  I.JSON_Currency_Rate_Data  ,
							                	  @NewDescription              =  I.[Description]              
							                FROM inserted I	
											where @ID_entity_D = I.ID_Currency_Rate;	
							                
							                SELECT  
							                      @OldID_Currency_Rate         =  D.ID_Currency_Rate         ,
							                	  @OldID_Currency              =  D.ID_Currency              ,
							                	  @OldAmount_Rate              =  D.Amount_Rate              ,
							                	  @OldValid_from               =  D.Valid_from               ,
							                	  @OldValid_to                 =  D.Valid_to                 ,
							                	  @OldJSON_Currency_Rate_Data  =  D.JSON_Currency_Rate_Data  ,
							                	  @OldDescription              =  D.[Description]              
							                FROM Deleted D																		 
											where @ID_entity_D = D.ID_Currency_Rate;


                                            IF ISNULL(cast(@NewID_Currency as nvarchar(50)),'null') <> ISNULL(cast(@OldID_Currency as nvarchar(50)),'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(cast(@OldID_Currency as nvarchar(50)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Currency as nvarchar(50)),'') + '", ';
							                   end
                                            
							                IF ISNULL(cast(@NewAmount_Rate as nvarchar(50)),'null') <> ISNULL(cast(@OldAmount_Rate as nvarchar(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Amount_Rate = Old ->"' +  ISNULL(cast(@OldAmount_Rate as nvarchar(50)),'') + ' " NEW -> " ' + isnull(cast(@NewAmount_Rate as nvarchar(50)),'') + '", ';
							                   end
							                
							                   				
							                IF ISNULL(CAST(Format(@NewValid_from,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldValid_from,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Valid_from = Old ->"' +  ISNULL(CAST(Format(@OldValid_from,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewValid_from,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
							                						   				
							                IF ISNULL(CAST(Format(@NewValid_to,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldValid_to,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Valid_to = Old ->"' +  ISNULL(CAST(Format(@OldValid_to,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewValid_to,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
							                IF ISNULL(CAST(@NewJSON_Currency_Rate_Data AS NVARCHAR(max)),'null') <> ISNULL(CAST(@OldJSON_Currency_Rate_Data AS NVARCHAR(max)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  JSON_Currency_Rate_Data = Old ->"' +  ISNULL(CAST(@OldAmount_Rate AS NVARCHAR(max)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmount_Rate AS NVARCHAR(max)),'') + '", ';
							                   end
							                
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end

                                            SET @ChangeDescription = 'Updated: ' + ' ID_Currency_Rate = "' +  isnull(cast(@OldID_Currency_Rate as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                             INSERT  INTO dbo.Currency_Rate_Audit
                                             ( 
                                              ID_Currency_Rate,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                             )
                                               SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									         set @ChangeDescription = ''
					              end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Currency_Rate,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;


							DECLARE @OldID_Currency_Rate_2        bigint          ;
							DECLARE @OldID_Currency_2             bigint       	  ;
							DECLARE @OldAmount_Rate_2             decimal(5,2)    ;
							DECLARE @OldValid_from_2              datetime     	  ;
							DECLARE @OldValid_to_2                datetime     	  ;
							DECLARE @OldJSON_Currency_Rate_Data_2 nvarchar(max)	  ;
							DECLARE @OldDescription_2             nvarchar(4000)  ;

							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						          begin
							          begin try
									        set @ChangeDescription = ''

                                            SELECT
							                    @OldID_Currency_Rate_2        = D.ID_Currency_Rate       	 ,
							                	@OldID_Currency_2             = D.ID_Currency            	 ,
							                	@OldAmount_Rate_2             = D.Amount_Rate           	 ,
							                	@OldValid_from_2              = D.Valid_from             	 ,
							                	@OldValid_to_2                = D.Valid_to               	 ,
							                	@OldJSON_Currency_Rate_Data_2 = D.JSON_Currency_Rate_Data  ,
							                	@OldDescription_2             = D.[Description]            
							                FROM deleted D	
											where @ID_entity_D_2 = D.ID_Currency_Rate 

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Currency_Rate'         +'="'+  ISNULL(CAST(@OldID_Currency_Rate_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Currency'              +'="'+  ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(50)),'')     + '", '
							                + 'Amount_Rate'              +'="'+  ISNULL(cast(@OldAmount_Rate_2 as nvarchar(20)),'')+ '", '	
							                + 'Valid_from'               +'="'+  ISNULL(CAST(Format(@OldValid_from_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Valid_to'                 +'="'+  ISNULL(CAST(Format(@OldValid_to_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'JSON_Currency_Rate_Data'  +'="'+  ISNULL(cast(@OldJSON_Currency_Rate_Data_2 as nvarchar(max)),'')+ '", '
							                + 'Description'              +'="'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                           
										   INSERT  INTO dbo.Currency_Rate_Audit
                                           ( 
                                            ID_Currency_Rate,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);
                    
					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Currency_Rate,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							    begin try
								       set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                              + 'ID_Currency_Rate = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';

									   INSERT  INTO dbo.Currency_Rate_Audit
                                        ( 
                                         ID_Currency_Rate,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									    set @ChangeDescription = ''
                                        
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3             

                    END

GO


CREATE TABLE Data_Orders_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Data_Orders         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group;


go

CREATE TRIGGER trg_Data_Orders_Audit ON Data_Orders
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max) = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Data_Orders,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Data_Orders,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
                           DECLARE @OldId_Data_Orders              bigint           ;
						   DECLARE @OldID_Employee                 bigint    		;
						   DECLARE @OldID_Orders                   bigint    		;
						   DECLARE @OldId_buyer                    bigint    		;
						   DECLARE @OldID_Exemplar                 bigint    		;
						   DECLARE @OldID_Transaction              bigint    		;
						   DECLARE @OldDate_Data_Orders            datetime  		;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

                           DECLARE @NewId_Data_Orders              bigint           ;
						   DECLARE @NewID_Employee                 bigint    		;
						   DECLARE @NewID_Orders                   bigint    		;
						   DECLARE @NewId_buyer                    bigint    		;
						   DECLARE @NewID_Exemplar                 bigint    		;
						   DECLARE @NewID_Transaction              bigint    		;
						   DECLARE @NewDate_Data_Orders            datetime  		;
	                       DECLARE @NewDescription                 nvarchar(4000)	;
                           

						    declare cr cursor local fast_forward for
						   
						    select 
						    ID_entity    
						    ,login_name   
						    ,ModifiedDate 
						    ,Name_action  
						    from @t_U_D 
                            open cr       
						    
						    fetch next from cr into 
						    @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						    while @@FETCH_STATUS  = 0
						          begin
							           begin try
									      set @ChangeDescription = ''
										  SELECT 
                                                @NewId_Data_Orders    =  I.Id_Data_Orders  ,
							             		@NewID_Employee       =  I.ID_Employee     ,
							             		@NewID_Orders         =  I.ID_Orders       ,
							             		@NewId_buyer          =  I.Id_buyer        ,
							             		@NewID_Exemplar       =  I.ID_Exemplar     ,
							             		@NewID_Transaction    =  I.ID_Transaction  ,
							             		@NewDate_Data_Orders  =  I.Date_Data_Orders,
							             		@NewDescription       =  I.[Description]         	
							             FROM inserted I	
										 where @ID_entity_D = I.Id_Data_Orders;

                                           SELECT 
                                               @OldId_Data_Orders     =  D.Id_Data_Orders  ,
									           @OldID_Employee        =  D.ID_Employee     ,
									           @OldID_Orders          =  D.ID_Orders       ,
									           @OldId_buyer           =  D.Id_buyer        ,
									           @OldID_Exemplar        =  D.ID_Exemplar     ,
									           @OldID_Transaction     =  D.ID_Transaction  ,
									           @OldDate_Data_Orders   =  D.Date_Data_Orders,
									           @OldDescription        =  D.[Description]        							
							             FROM Deleted D	
										 where @ID_entity_D = D.Id_Data_Orders;

																	 
                                         IF ISNULL(CAST(@NewID_Employee AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Employee AS NVARCHAR(50)),'null')
							                begin
                                             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Employee = Old ->"' +  ISNULL(CAST(@OldID_Employee AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Employee AS NVARCHAR(20)),'') + '", ';
							                end
                                         
							             IF ISNULL(CAST(@NewID_Orders AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Orders AS NVARCHAR(50)),'null')
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Orders = Old ->"' +  ISNULL(CAST(@OldID_Orders AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Orders AS NVARCHAR(20)),'') + '", ';
							                end
							             IF ISNULL(CAST(@NewId_buyer AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldId_buyer AS NVARCHAR(50)),'null') 
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_buyer = Old ->"' +  ISNULL(cast(@OldId_buyer AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(cast(@NewId_buyer AS NVARCHAR(20)),'') + '", ';
							                end
                                                                                                 
							             IF ISNULL(CAST(@NewID_Exemplar AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Exemplar AS NVARCHAR(50)),'null') 
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Exemplar = Old ->"' +  ISNULL(cast(@OldID_Exemplar AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Exemplar AS NVARCHAR(20)),'') + '", ';
							                end
							             IF ISNULL(CAST(@NewID_Transaction AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Transaction AS NVARCHAR(50)),'null') 
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Transaction = Old ->"' +  ISNULL(CAST(@OldID_Transaction AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Transaction AS NVARCHAR(20)),'') + '", ';
							                end
							             
							             IF ISNULL(CAST(Format(@NewDate_Data_Orders,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Data_Orders,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Data_Orders = Old ->"' +  ISNULL(CAST(Format(@OldDate_Data_Orders,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Data_Orders,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                end
							             
                                         IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                begin
                                             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                            end
                                         SET @ChangeDescription = 'Updated: ' + ' Id_Data_Orders = "' +  isnull(cast(@OldId_Data_Orders as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                          --Удаляем запятую на конце
                                         IF LEN(@ChangeDescription) > 0
                                             SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                         INSERT  INTO dbo.Data_Orders_Audit
                                         ( 
                                          Id_Data_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                           SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									     set @ChangeDescription = '' 
										 

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
                           declare @t_D_D table 
						   (
						   Id_Num         bigint        identity(1,1) not null,
						   ID_entity      bigint        null,
						   login_name     nvarchar(128) null,
						   ModifiedDate   DATETIME      null,
						   Name_action    char(1)       null
						   );
						   
						   
						   insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
						   SELECT d.Id_Data_Orders,@login_name,GETDATE(),'D'  
						   FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                           DECLARE @OldId_Data_Orders_2              bigint           ;
						   DECLARE @OldID_Employee_2                 bigint    		  ;
						   DECLARE @OldID_Orders_2                   bigint    		  ;
						   DECLARE @OldId_buyer_2                    bigint    		  ;
						   DECLARE @OldID_Exemplar_2                 bigint    		  ;
						   DECLARE @OldID_Transaction_2              bigint    		  ;
						   DECLARE @OldDate_Data_Orders_2            datetime  		  ;
	                       DECLARE @OldDescription_2                 nvarchar(4000)	  ;

						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

                                            SELECT 
							                    @OldId_Data_Orders_2  	   = D.Id_Data_Orders    ,
							                	@OldID_Employee_2     	   = D.ID_Employee       ,
							                	@OldID_Orders_2       	   = D.ID_Orders         ,
							                	@OldId_buyer_2        	   = D.Id_buyer          ,
							                	@OldID_Exemplar_2     	   = D.ID_Exemplar       ,
							                	@OldID_Transaction_2  	   = D.ID_Transaction    ,
							                	@OldDate_Data_Orders_2     = D.Date_Data_Orders  ,
							                	@OldDescription_2          = D.[Description]        
							                FROM deleted D									 
							                where @ID_entity_D_2 = D.Id_Data_Orders

                                            SET @ChangeDescription = 'Deleted: '
							                + 'Id_Data_Orders'     +' = "'+  ISNULL(CAST(@OldId_Data_Orders_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Employee'        +' = "'+  ISNULL(CAST(@OldID_Employee_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Orders'          +' = "'+  ISNULL(CAST(@OldID_Orders_2 AS NVARCHAR(50)),'')     + '", '
							                + 'Id_buyer'           +' = "'+  ISNULL(CAST(@OldId_buyer_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Exemplar'        +' = "'+  ISNULL(CAST(@OldID_Exemplar_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Transaction'     +' = "'+  ISNULL(CAST(@OldID_Transaction_2 AS NVARCHAR(50)),'')     + '", '
							                + 'Date_Data_Orders'   +' = "'+  ISNULL(CAST(Format(@OldDate_Data_Orders_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Description'        +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

						                    IF LEN(@ChangeDescription) > 0
                                                    SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                            INSERT  INTO dbo.Data_Orders_Audit
                                            ( 
                                             Id_Data_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                             SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 
											
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.Id_Data_Orders,@login_name,GETDATE(),'I'  
					FROM  inserted I

					 declare cr_3 cursor local fast_forward for
						   
					 select 
					 ID_entity   
					 ,login_name  
					 ,ModifiedDate
					 ,Name_action 
					 from @t_I_I 
                     open cr_3       
					 
					 fetch next from cr_3 into 
					 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					 while @@FETCH_STATUS  = 0
						    begin
							  begin try
							        set @ChangeDescription = ''

                                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Data_Orders = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                    
                                    INSERT  INTO dbo.Data_Orders_Audit
                                     ( 
                                      Id_Data_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''              
                              end try
							  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Department_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Department          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Department_Audit ON Department
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)  = '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Department,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Department,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


							DECLARE @OldID_Department           bigint        ;
							DECLARE @OldID_Head_Department      bigint        ;
							DECLARE @OldID_Vice_Head_Department bigint        ;
							DECLARE @OldName_Department         nvarchar(300) ;
							DECLARE @OldID_Branch               bigint        ;
							DECLARE @OldDepartment_Code         int           ;
							DECLARE @OldDescription             nvarchar(4000);
							
							DECLARE @NewID_Department           bigint        ;
							DECLARE @NewID_Head_Department      bigint        ;
							DECLARE @NewID_Vice_Head_Department bigint        ;
							DECLARE @NewName_Department         nvarchar(300) ;
							DECLARE @NewID_Branch               bigint        ;
							DECLARE @NewDepartment_Code         int           ;
							DECLARE @NewDescription             nvarchar(4000);

						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT
										    @NewID_Department            = I.ID_Department          ,
											@NewID_Head_Department     	 = I.ID_Head_Department     ,
											@NewID_Vice_Head_Department	 = I.ID_Vice_Head_Department,
											@NewName_Department        	 = I.Name_Department        ,
											@NewID_Branch              	 = I.ID_Branch              ,
											@NewDepartment_Code        	 = I.Department_Code        ,
											@NewDescription            	 = I.[Description]            		
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Department;
										
                                        SELECT 
										    @OldID_Department            = D.ID_Department          ,
											@OldID_Head_Department     	 = D.ID_Head_Department     ,
											@OldID_Vice_Head_Department	 = D.ID_Vice_Head_Department,
											@OldName_Department        	 = D.Name_Department        ,
											@OldID_Branch              	 = D.ID_Branch              ,
											@OldDepartment_Code        	 = D.Department_Code        ,
											@OldDescription            	 = D.[Description]            						
							            FROM Deleted D
										where @ID_entity_D = D.ID_Department;



                                       IF ISNULL(CAST(@NewID_Head_Department AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Head_Department AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Head_Department = Old ->"' +  ISNULL(CAST(@OldID_Head_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Head_Department AS NVARCHAR(50)),'') + '", ';
							              end
                                       
									   IF ISNULL(CAST(@NewID_Vice_Head_Department AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Vice_Head_Department AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Vice_Head_Department = Old ->"' +  ISNULL(CAST(@OldID_Vice_Head_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Vice_Head_Department AS NVARCHAR(50)),'') + '", ';
							              end

							           IF ISNULL(@NewName_Department,'null') <> ISNULL(@OldName_Department,'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Department = Old ->"' +  ISNULL(@OldName_Department,'') + ' " NEW -> " ' + isnull(@NewName_Department,'') + '", ';
							              end

									   IF ISNULL(CAST(@NewID_Branch AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

									   IF ISNULL(CAST(@NewDepartment_Code AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldDepartment_Code AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Code = Old ->"' +  ISNULL(CAST(@OldDepartment_Code AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewDepartment_Code AS NVARCHAR(50)),'') + '", ';
							              end
							           
                                       IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Department = "' +  isnull(cast(@OldID_Department as nvarchar(20)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Department_Audit
                                        ( 
                                         ID_Department,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Department,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;
                            
							DECLARE @OldID_Department_2           bigint        ;
							DECLARE @OldID_Head_Department_2      bigint        ;
							DECLARE @OldID_Vice_Head_Department_2 bigint        ;
							DECLARE @OldName_Department_2         nvarchar(300) ;
							DECLARE @OldID_Branch_2               bigint        ;
							DECLARE @OldDepartment_Code_2         int           ;
							DECLARE @OldDescription_2             nvarchar(4000);



							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
										        @OldID_Department_2              = D.ID_Department          ,
										    	@OldID_Head_Department_2     	 = D.ID_Head_Department     ,
										    	@OldID_Vice_Head_Department_2	 = D.ID_Vice_Head_Department,
										    	@OldName_Department_2        	 = D.Name_Department        ,
										    	@OldID_Branch_2              	 = D.ID_Branch              ,
										    	@OldDepartment_Code_2        	 = D.Department_Code        ,
										    	@OldDescription_2            	 = D.[Description]            						
							                FROM Deleted D
										    where @ID_entity_D_2 = D.ID_Department;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Department'           +' = "'+  ISNULL(CAST(@OldID_Department_2     AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Head_Department'      +' = "'+  ISNULL(CAST(@OldID_Head_Department_2  AS NVARCHAR(50)),'') + '", '
							                + 'ID_Vice_Head_Department' +' = "'+  ISNULL(CAST(@OldID_Vice_Head_Department_2 AS NVARCHAR(50)),'') + '", '
							                + 'Name_Department'         +' = "'+  ISNULL(@OldName_Department_2,'')+ '", '
											+ 'ID_Branch'               +' = "'+  ISNULL(CAST(@OldID_Branch_2  AS NVARCHAR(50)),'') + '", '
							                + 'Department_Code'         +' = "'+  ISNULL(CAST(@OldDepartment_Code_2 AS NVARCHAR(50)),'') + '", '
							                + 'Description'             +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Department_Audit
                                           ( 
                                            ID_Department,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Department,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Department = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Department_Audit
                                       ( 
                                        ID_Department,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Employees_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Employee            bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
  --  PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Employees_Audit ON Employees
AFTER INSERT, UPDATE, DELETE

AS   
    set nocount,xact_abort on;
	
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN

							declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Employee,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Employee,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;



                           DECLARE @OldID_Employee                bigint        ;
						   DECLARE @OldID_Department              bigint        ;
						   DECLARE @OldID_Group                   bigint        ;
						   DECLARE @OldID_The_Subgroup            bigint        ;
						   DECLARE @OldID_Passport                bigint        ;
						   DECLARE @OldID_Branch                  bigint        ;
						   DECLARE @OldID_Post                    bigint        ;
						   DECLARE @OldID_Status_Employee         bigint        ;
						   DECLARE @OldID_Connection_String       bigint        ;
						   DECLARE @OldID_Chief                   bigint        ;
						   DECLARE @OldName                       nvarchar(100) ;
						   DECLARE @OldSurName                    nvarchar(100) ;
						   DECLARE @OldLastName                   nvarchar(100) ;
						   DECLARE @OldDate_Of_Hiring             datetime      ;
						   DECLARE @OldDate_Card_Created_Employee datetime      ;
						   DECLARE @OldResidential_Address        nvarchar(400) ;
						   DECLARE @OldHome_Phone                 nvarchar(30)  ;
						   DECLARE @OldCell_Phone                 nvarchar(30)  ;
						   DECLARE @OldImage_Employees            varbinary(max);
						   DECLARE @OldWork_Phone                 nvarchar(30)  ;
						   DECLARE @OldMail                       nvarchar(150) ;
						   DECLARE @OldPol                        char(1)       ;
						   DECLARE @OldDate_Of_Dismissal          datetime      ;
						   DECLARE @OldDate_Of_Birth              datetime      ;
						   DECLARE @OldDescription                nvarchar(1000);

						   DECLARE @NewID_Employee                bigint        ;
						   DECLARE @NewID_Department              bigint        ;
						   DECLARE @NewID_Group                   bigint        ;
						   DECLARE @NewID_The_Subgroup            bigint        ;
						   DECLARE @NewID_Passport                bigint        ;
						   DECLARE @NewID_Branch                  bigint        ;
						   DECLARE @NewID_Post                    bigint        ;
						   DECLARE @NewID_Status_Employee         bigint        ;
						   DECLARE @NewID_Connection_String       bigint        ;
						   DECLARE @NewID_Chief                   bigint        ;
						   DECLARE @NewName                       nvarchar(100) ;
						   DECLARE @NewSurName                    nvarchar(100) ;
						   DECLARE @NewLastName                   nvarchar(100) ;
						   DECLARE @NewDate_Of_Hiring             datetime      ;
						   DECLARE @NewDate_Card_Created_Employee datetime      ;
						   DECLARE @NewResidential_Address        nvarchar(400) ;
						   DECLARE @NewHome_Phone                 nvarchar(30)  ;
						   DECLARE @NewCell_Phone                 nvarchar(30)  ;
						   DECLARE @NewImage_Employees            varbinary(max);
						   DECLARE @NewWork_Phone                 nvarchar(30)  ;
						   DECLARE @NewMail                       nvarchar(150) ;
						   DECLARE @NewPol                        char(1)       ;
						   DECLARE @NewDate_Of_Dismissal          datetime      ;
						   DECLARE @NewDate_Of_Birth              datetime      ;
						   DECLARE @NewDescription                nvarchar(1000);


						   
						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								     set @ChangeDescription = ''

                                     SELECT  
									     @NewID_Employee               	  = I.ID_Employee               ,	
										 @NewID_Department             	  = I.ID_Department             ,
										 @NewID_Group                  	  = I.ID_Group                  ,
										 @NewID_The_Subgroup           	  = I.ID_The_Subgroup           ,
										 @NewID_Passport               	  = I.ID_Passport               ,
										 @NewID_Branch                 	  = I.ID_Branch                 ,
										 @NewID_Post                   	  = I.ID_Post                   ,
										 @NewID_Status_Employee        	  = I.ID_Status_Employee        ,
										 @NewID_Connection_String      	  = I.ID_Connection_String      ,
										 @NewID_Chief                  	  = I.ID_Chief                  ,
										 @NewName                      	  = I.Name                      ,
										 @NewSurName                   	  = I.SurName                   ,
										 @NewLastName                  	  = I.LastName                  ,
										 @NewDate_Of_Hiring            	  = I.Date_Of_Hiring            ,
										 @NewDate_Card_Created_Employee	  = I.Date_Card_Created_Employee,
										 @NewResidential_Address       	  = I.Residential_Address       ,
										 @NewHome_Phone                	  = I.Home_Phone                ,
										 @NewCell_Phone                	  = I.Cell_Phone                ,
										 @NewImage_Employees           	  = I.Image_Employees           ,
										 @NewWork_Phone                	  = I.Work_Phone                ,
										 @NewMail                      	  = I.Mail                      ,
										 @NewPol                       	  = I.Pol                       ,
										 @NewDate_Of_Dismissal         	  = I.Date_Of_Dismissal         ,
										 @NewDate_Of_Birth             	  = I.Date_Of_Birth             ,
										 @NewDescription                  = I.[Description]               
									 FROM inserted I  
									 where @ID_entity_D = I.ID_Employee;								     
								     
									 SELECT  
									     @OldID_Employee               	  = D.ID_Employee               ,	
										 @OldID_Department             	  = D.ID_Department             ,
										 @OldID_Group                  	  = D.ID_Group                  ,
										 @OldID_The_Subgroup           	  = D.ID_The_Subgroup           ,
										 @OldID_Passport               	  = D.ID_Passport               ,
										 @OldID_Branch                 	  = D.ID_Branch                 ,
										 @OldID_Post                   	  = D.ID_Post                   ,
										 @OldID_Status_Employee        	  = D.ID_Status_Employee        ,
										 @OldID_Connection_String      	  = D.ID_Connection_String      ,
										 @OldID_Chief                  	  = D.ID_Chief                  ,
										 @OldName                      	  = D.Name                      ,
										 @OldSurName                   	  = D.SurName                   ,
										 @OldLastName                  	  = D.LastName                  ,
										 @OldDate_Of_Hiring            	  = D.Date_Of_Hiring            ,
										 @OldDate_Card_Created_Employee	  = D.Date_Card_Created_Employee,
										 @OldResidential_Address       	  = D.Residential_Address       ,
										 @OldHome_Phone                	  = D.Home_Phone                ,
										 @OldCell_Phone                	  = D.Cell_Phone                ,
										 @OldImage_Employees           	  = D.Image_Employees           ,
										 @OldWork_Phone                	  = D.Work_Phone                ,
										 @OldMail                      	  = D.Mail                      ,
										 @OldPol                       	  = D.Pol                       ,
										 @OldDate_Of_Dismissal         	  = D.Date_Of_Dismissal         ,
										 @OldDate_Of_Birth             	  = D.Date_Of_Birth             ,
										 @OldDescription                  = D.[Description]               
									 FROM   Deleted D 
									 where @ID_entity_D = D.ID_Employee; 					
														
                                     IF ISNULL(CAST(@NewID_Department AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Department = Old ->"' +  ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Department AS NVARCHAR(50)),'') + '", ';
							              end

								     IF ISNULL(CAST(@NewID_Group AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Group = Old ->"' +  ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF ISNULL(CAST(@NewID_The_Subgroup AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_The_Subgroup AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end
                                     
									 IF ISNULL(CAST(@NewID_Passport AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Passport AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Passport = Old ->"' +  ISNULL(CAST(@OldID_Passport AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Passport AS NVARCHAR(50)),'') + '", ';
							              end

								     IF ISNULL(CAST(@NewID_Branch AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF ISNULL(CAST(@NewID_Post AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Post AS NVARCHAR(50)),'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Post = Old ->"' +  ISNULL(CAST(@OldID_Post AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Post AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF ISNULL(CAST(@NewID_Status_Employee AS NVARCHAR(50)),'null') <>  ISNULL(CAST(@OldID_Status_Employee AS NVARCHAR(50)),'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Status_Employee = Old ->"' +  ISNULL(CAST(@OldID_Status_Employee AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Status_Employee AS NVARCHAR(50)),'') + '", ';
							              end

								     IF ISNULL(CAST(@NewID_Connection_String AS NVARCHAR(50)),'null') <>  ISNULL(CAST(@OldID_Connection_String AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Connection_String = Old ->"' +  ISNULL(CAST(@OldID_Connection_String AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Connection_String AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF ISNULL(CAST(@NewID_Chief AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Chief AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Chief = Old ->"' +  ISNULL(CAST(@OldID_Chief AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Chief AS NVARCHAR(50)),'') + '", ';
							              end

									 IF ISNULL(@NewName,'null') <> ISNULL(@OldName,'null') 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							            end

									 IF ISNULL(@NewSurName,'null') <> ISNULL(@OldSurName,'null') 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SurName = Old ->"' +  ISNULL(@OldSurName,'') + ' " NEW -> " ' + isnull(@NewSurName,'') + '", ';
							            end

									 IF ISNULL(@NewLastName,'null') <> ISNULL(@OldLastName,'null') 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  LastName = Old ->"' +  ISNULL(@OldLastName,'') + ' " NEW -> " ' + isnull(@NewLastName,'') + '", ';
							            end

                                     IF ISNULL(CAST(Format(@NewDate_Of_Hiring,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Of_Hiring,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Hiring = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Hiring,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Hiring,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

									IF ISNULL(CAST(Format(@NewDate_Card_Created_Employee,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Card_Created_Employee,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Card_Created_Employee = Old ->"' +  ISNULL(CAST(Format(@OldDate_Card_Created_Employee,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Card_Created_Employee,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end
                                   
									IF ISNULL(@NewResidential_Address,'null') <> ISNULL(@OldResidential_Address,'null') 
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Residential_Address = Old ->"' +  ISNULL(@OldResidential_Address,'') + ' " NEW -> " ' + isnull(@NewResidential_Address,'') + '", ';
							            end

									IF isnull(@NewHome_Phone,'null') <> isnull(@OldHome_Phone,'null')
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Home_Phone = Old ->"' +  ISNULL(@OldHome_Phone,'') + ' " NEW -> " ' + isnull(@NewHome_Phone,'') + '", ';
							            end

									IF isnull(@NewCell_Phone,'null') <> isnull(@OldCell_Phone,'null')
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Cell_Phone = Old ->"' +  ISNULL(@OldCell_Phone,'') + ' " NEW -> " ' + isnull(@NewCell_Phone,'') + '", ';
							            end

								    IF isnull(cast(@NewImage_Employees as nvarchar(10)),'null') <> isnull(cast(@OldImage_Employees as nvarchar(10)),'null')
							                   begin
							                     SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Image_Employees = '  +  '"Изображение было изменено или удалено", ';
							                   end

									IF isnull(@NewWork_Phone,'null') <> isnull(@OldWork_Phone,'null')
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Work_Phone = Old ->"' +  ISNULL(@OldWork_Phone,'') + ' " NEW -> " ' + isnull(@NewWork_Phone,'') + '", ';
							            end 

									IF isnull(@NewMail,'null') <> isnull(@OldMail,'null')
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							            end 

							        IF ISNULL(CAST(@NewPol AS NVARCHAR(1)),'null') <> ISNULL(CAST(@OldPol AS NVARCHAR(1)),'null') 
							              begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Pol = Old ->"' +  ISNULL(CAST(@OldPol AS NVARCHAR(1)),'') + ' " NEW -> " ' + isnull(CAST(@NewPol AS NVARCHAR(1)),'') + '", ';
							              end

                                   IF ISNULL(CAST(Format(@NewDate_Of_Dismissal,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Of_Dismissal,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Dismissal = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Dismissal,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Dismissal,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

								   IF ISNULL(CAST(Format(@NewDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Birth = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

                                   IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							              begin
                                             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                    
									SET @ChangeDescription = 'Updated: ' + ' ID_Employee = "' +  isnull(cast(@OldID_Employee as nvarchar(20)),'')+ '" ' + ISNULL(@ChangeDescription,'')

									IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);


                                    INSERT  INTO dbo.Employees_Audit
                                     ( 
                                      ID_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									set @ChangeDescription = '' 

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
							  					
                END
            ELSE
                BEGIN						  
							declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Employee,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                            DECLARE @OldID_Employee_2                bigint        ;
						    DECLARE @OldID_Department_2              bigint        ;
						    DECLARE @OldID_Group_2                   bigint        ;
						    DECLARE @OldID_The_Subgroup_2            bigint        ;
						    DECLARE @OldID_Passport_2                bigint        ;
						    DECLARE @OldID_Branch_2                  bigint        ;
						    DECLARE @OldID_Post_2                    bigint        ;
						    DECLARE @OldID_Status_Employee_2         bigint        ;
						    DECLARE @OldID_Connection_String_2       bigint        ;
						    DECLARE @OldID_Chief_2                   bigint        ;
						    DECLARE @OldName_2                       nvarchar(100) ;
						    DECLARE @OldSurName_2                    nvarchar(100) ;
						    DECLARE @OldLastName_2                   nvarchar(100) ;
						    DECLARE @OldDate_Of_Hiring_2             datetime      ;
						    DECLARE @OldDate_Card_Created_Employee_2 datetime      ;
						    DECLARE @OldResidential_Address_2        nvarchar(400) ;
						    DECLARE @OldHome_Phone_2                 nvarchar(30)  ;
						    DECLARE @OldCell_Phone_2                 nvarchar(30)  ;
						    DECLARE @OldImage_Employees_2            varbinary(max);
						    DECLARE @OldWork_Phone_2                 nvarchar(30)  ;
						    DECLARE @OldMail_2                       nvarchar(150) ;
						    DECLARE @OldPol_2                        char(1)       ;
						    DECLARE @OldDate_Of_Dismissal_2          datetime      ;
						    DECLARE @OldDate_Of_Birth_2              datetime      ;
						    DECLARE @OldDescription_2                nvarchar(1000);
						   
						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								      set @ChangeDescription = ''
								     
                                      SELECT  
									     @OldID_Employee_2               	  = D.ID_Employee               ,	
										 @OldID_Department_2             	  = D.ID_Department             ,
										 @OldID_Group_2                  	  = D.ID_Group                  ,
										 @OldID_The_Subgroup_2           	  = D.ID_The_Subgroup           ,
										 @OldID_Passport_2               	  = D.ID_Passport               ,
										 @OldID_Branch_2                 	  = D.ID_Branch                 ,
										 @OldID_Post_2                   	  = D.ID_Post                   ,
										 @OldID_Status_Employee_2        	  = D.ID_Status_Employee        ,
										 @OldID_Connection_String_2      	  = D.ID_Connection_String      ,
										 @OldID_Chief_2                  	  = D.ID_Chief                  ,
										 @OldName_2                      	  = D.Name                      ,
										 @OldSurName_2                   	  = D.SurName                   ,
										 @OldLastName_2                  	  = D.LastName                  ,
										 @OldDate_Of_Hiring_2            	  = D.Date_Of_Hiring            ,
										 @OldDate_Card_Created_Employee_2	  = D.Date_Card_Created_Employee,
										 @OldResidential_Address_2       	  = D.Residential_Address       ,
										 @OldHome_Phone_2                	  = D.Home_Phone                ,
										 @OldCell_Phone_2                	  = D.Cell_Phone                ,
										 @OldImage_Employees_2           	  = D.Image_Employees           ,
										 @OldWork_Phone_2                	  = D.Work_Phone                ,
										 @OldMail_2                      	  = D.Mail                      ,
										 @OldPol_2                       	  = D.Pol                       ,
										 @OldDate_Of_Dismissal_2         	  = D.Date_Of_Dismissal         ,
										 @OldDate_Of_Birth_2             	  = D.Date_Of_Birth             ,
										 @OldDescription_2                    = D.[Description]               
									 FROM  Deleted D 
									 where @ID_entity_D_2 = D.ID_Employee; 
					
					                 SET @ChangeDescription = 'Deleted: '
									 +  'ID_Employee'                 +' = "'+ ISNULL(CAST(@OldID_Employee_2 AS NVARCHAR(50)),'')  + '", '
									 +	'ID_Department'               +' = "'+ ISNULL(CAST(@OldID_Department_2 AS NVARCHAR(50)),'') + '", '
									 +	'ID_Group'                    +' = "'+ ISNULL(CAST(@OldID_Group_2 AS NVARCHAR(50)),'') + '", '
									 +	'ID_The_Subgroup'             +' = "'+ ISNULL(CAST(@OldID_The_Subgroup_2 AS NVARCHAR(50)),'')+ '", '
									 +	'ID_Passport'                 +' = "'+ ISNULL(CAST(@OldID_Passport_2 AS NVARCHAR(50)),'')+ '", '
									 +	'ID_Branch'                   +' = "'+ ISNULL(CAST(@OldID_Branch_2 AS NVARCHAR(50)),'')+ '", '
									 +	'ID_Post'                     +' = "'+ ISNULL(CAST(@OldID_Post_2 AS NVARCHAR(50)),'')+ '", '
									 +	'ID_Status_Employee'          +' = "'+ ISNULL(CAST(@OldID_Status_Employee_2 AS NVARCHAR(50)),'')+ '", '
									 +	'ID_Connection_String'        +' = "'+ ISNULL(CAST(@OldID_Connection_String_2 AS NVARCHAR(50)),'')+ '", '
									 +	'ID_Chief'                    +' = "'+ ISNULL(CAST(@OldID_Chief_2 AS NVARCHAR(50)),'')+ '", '
							         +  'Name'                        +' = "'+ ISNULL(@OldName_2,'')+ '", '				
							         +  'SurName'                     +' = "'+ ISNULL(@OldSurName_2,'')+ '", '
							         +  'LastName'                    +' = "'+ ISNULL(@OldLastName_2,'') + '", '	
									 +  'Date_Of_Hiring'              +' = "'+ ISNULL(CAST(Format(@OldDate_Of_Hiring_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
									 +  'Date_Card_Created_Employee'  +' = "'+ ISNULL(CAST(Format(@OldDate_Card_Created_Employee_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							         +  'Residential_Address'         +' = "'+ ISNULL(@OldResidential_Address_2,'') + '", '
							         +  'Home_Phone'                  +' = "'+ ISNULL(@OldHome_Phone_2,'')+ '", '				
							         +  'Cell_Phone'                  +' = "'+ ISNULL(@OldCell_Phone_2,'')+ '", '
							         +  'Image_Employees'             +' = "'+ ISNULL(cast(@OldImage_Employees_2 as varchar(max)),'')+ '", '
							         +  'Work_Phone'                  +' = "'+ ISNULL(@OldWork_Phone_2,'')+ '", '				
							         +  'Mail'                        +' = "'+ ISNULL(@OldMail_2,'')+ '", ' 
                                     +  'Pol'                         +' = "'+ ISNULL(CAST(@OldPol_2 AS NVARCHAR(1)),'') 	   + '", '
									 +  'Date_Of_Dismissal'           +' = "'+ ISNULL(CAST(Format(@OldDate_Of_Dismissal_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
									 +  'Date_Of_Birth'               +' = "'+ ISNULL(CAST(Format(@OldDate_Of_Birth_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							         +  'Description'                 +' = "'+ ISNULL(@OldDescription_2  ,'') + '", '

                                     IF LEN(@ChangeDescription) > 0
						                     SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                    INSERT  INTO dbo.Employees_Audit
                                     ( 
                                      ID_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN

				           DECLARE @ID_entity_I_2    bigint       ;
				           DECLARE @login_name_2_I_2 nvarchar(128);
				           DECLARE @ModifiedDate_I_2 DATETIME     ;
				           DECLARE @Name_action_I_2  char(1)      ;

							declare @t_I_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT I.ID_Employee,@login_name,GETDATE(),'I'  
							FROM  inserted I
						   
						   declare cr_3 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_I_I 
                           open cr_3       
						   
						   fetch next from cr_3 into 
						   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								     set @ChangeDescription = ''				 
					
					                 SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Employee = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
  
                                    INSERT  INTO dbo.Employees_Audit
                                     ( 
                                      ID_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END


GO


CREATE TABLE Exemplar_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Exemplar               bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Exemplar_Audit ON Exemplar
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                         	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Exemplar,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Exemplar,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
                           DECLARE @OldID_Exemplar                bigint         ;
						   DECLARE @OldId_Item                    bigint         ;
						   DECLARE @OldID_Currency                bigint         ;
						   DECLARE @OldID_Storage_location        bigint         ;
						   DECLARE @OldKeySource                  bigint         ;
						   DECLARE @OldSerial_number              nvarchar(500)  ;
						   DECLARE @OldID_Condition_of_the_item   bigint         ;
						   DECLARE @OldOld_Price_no_NDS           decimal(10,2)  ;
						   DECLARE @OldRefund                     bit            ;
						   DECLARE @OldDate_Refund                datetime       ;
						   DECLARE @OldReturn_Note                nvarchar(4000) ;
						   DECLARE @OldOld_Price_NDS              decimal(10,2)  ;
						   DECLARE @OldJSON_Size_Volume           nvarchar(max)  ;
						   DECLARE @OldNew_Price_NDS              decimal(10,2)  ;
						   DECLARE @OldNew_Price_no_NDS           decimal(10,2)  ;
						   DECLARE @OldDate_Created               datetime       ;
						   DECLARE @OldDescription                nvarchar(4000) ;

						   DECLARE @NewID_Exemplar                bigint         ;
						   DECLARE @NewId_Item                    bigint         ;
						   DECLARE @NewID_Currency                bigint         ;
						   DECLARE @NewID_Storage_location        bigint         ;
						   DECLARE @NewKeySource                  bigint         ;
						   DECLARE @NewSerial_number              nvarchar(500)  ;
						   DECLARE @NewID_Condition_of_the_item   bigint         ;
						   DECLARE @NewOld_Price_no_NDS           decimal(10,2)  ;
						   DECLARE @NewRefund                     bit            ;
						   DECLARE @NewDate_Refund                datetime       ;
						   DECLARE @NewReturn_Note                nvarchar(4000) ;
						   DECLARE @NewOld_Price_NDS              decimal(10,2)  ;
						   DECLARE @NewJSON_Size_Volume           nvarchar(max)  ;
						   DECLARE @NewNew_Price_NDS              decimal(10,2)  ;
						   DECLARE @NewNew_Price_no_NDS           decimal(10,2)  ;
						   DECLARE @NewDate_Created               datetime       ;
						   DECLARE @NewDescription                nvarchar(4000) ;

						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
							                @NewID_Exemplar             	= I.ID_Exemplar             , 
							            	@NewId_Item                 	= I.Id_Item                 ,
							            	@NewID_Currency             	= I.ID_Currency             ,
							            	@NewID_Storage_location     	= I.ID_Storage_location     ,
							            	@NewKeySource               	= I.KeySource               ,
							            	@NewSerial_number           	= I.Serial_number           ,
							            	@NewID_Condition_of_the_item	= I.ID_Condition_of_the_item,
							            	@NewOld_Price_no_NDS        	= I.Old_Price_no_NDS        ,
							            	@NewRefund                  	= I.Refund                  ,
							            	@NewDate_Refund             	= I.Date_Refund             ,
							            	@NewReturn_Note             	= I.Return_Note             ,
							            	@NewOld_Price_NDS           	= I.Old_Price_NDS           ,
							            	@NewJSON_Size_Volume        	= I.JSON_Size_Volume        ,
							            	@NewNew_Price_NDS           	= I.New_Price_NDS           ,
							            	@NewNew_Price_no_NDS        	= I.New_Price_no_NDS        ,
							            	@NewDate_Created                = I.Date_Created            ,
							            	@NewDescription                 = I.[Description]        	  
							            FROM inserted I
										where @ID_entity_D = I.ID_Exemplar;	

								        SELECT 
							                @OldID_Exemplar             	= D.ID_Exemplar             ,
							            	@OldId_Item                 	= D.Id_Item                 ,
							            	@OldID_Currency             	= D.ID_Currency             ,
							            	@OldID_Storage_location     	= D.ID_Storage_location     ,
							            	@OldKeySource               	= D.KeySource               ,
							            	@OldSerial_number           	= D.Serial_number           ,
							            	@OldID_Condition_of_the_item	= D.ID_Condition_of_the_item,
							            	@OldOld_Price_no_NDS        	= D.Old_Price_no_NDS        ,
							            	@OldRefund                  	= D.Refund                  ,
							            	@OldDate_Refund             	= D.Date_Refund             ,
							            	@OldReturn_Note             	= D.Return_Note             ,
							            	@OldOld_Price_NDS           	= D.Old_Price_NDS           ,
							            	@OldJSON_Size_Volume        	= D.JSON_Size_Volume        ,
							            	@OldNew_Price_NDS           	= D.New_Price_NDS           ,
							            	@OldNew_Price_no_NDS        	= D.New_Price_no_NDS        ,
							            	@OldDate_Created                = D.Date_Created            , 
							            	@OldDescription                 = D.[Description]        	  					
							            FROM Deleted D																		 
										where @ID_entity_D = D.ID_Exemplar;								       


                                          IF ISNULL(CAST(@NewId_Item  AS NVARCHAR(50)),'null')  <> ISNULL(CAST(@OldId_Item  AS NVARCHAR(50)),'null')  
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Item  = Old ->"' +  ISNULL(CAST(@OldId_Item  AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewId_Item  AS NVARCHAR(50)),'') + '", ';
							                 end
                                          
							              IF ISNULL(CAST(@NewID_Currency  AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Currency  AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(CAST(@OldID_Currency AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Currency AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF ISNULL(CAST(@NewID_Storage_location  AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Storage_location  AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Storage_location = Old ->"' +  ISNULL(CAST(@OldID_Storage_location AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Storage_location AS NVARCHAR(50)),'') + '", ';
							                 end                  
							              
							              IF ISNULL(CAST(@NewKeySource AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldKeySource AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  KeySource = Old ->"' +  ISNULL(CAST(@OldKeySource AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewKeySource AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF ISNULL(@NewSerial_number,'null') <> ISNULL(@OldSerial_number,'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Serial_number = Old ->"' +  ISNULL(@OldSerial_number,'') + ' " NEW -> "' + isnull(@NewSerial_number,'') + '", ';
							                 end
							              
							              IF ISNULL(CAST(@NewID_Condition_of_the_item AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Condition_of_the_item AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Condition_of_the_item = Old ->"' +  ISNULL(CAST(@OldID_Condition_of_the_item AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Condition_of_the_item AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF ISNULL(CAST(@NewOld_Price_no_NDS AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldOld_Price_no_NDS AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Old_Price_no_NDS = Old ->"' +  ISNULL(CAST(@OldOld_Price_no_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewOld_Price_no_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
							              
                                          IF ISNULL(CAST(@NewRefund AS NVARCHAR(1)),'null') <> ISNULL(CAST(@OldRefund AS NVARCHAR(1)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Refund = Old ->"' +  ISNULL(CAST(@OldRefund AS NVARCHAR(1)),'') + ' " NEW -> "' + isnull(CAST(@NewRefund AS NVARCHAR(1)),'') + '", ';
							                 end
							              
                                          IF ISNULL(CAST(Format(@NewDate_Refund,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Refund,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Refund = Old ->"' +  ISNULL(CAST(Format(@OldDate_Refund,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Refund,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                 end
                                          
							              IF ISNULL(@NewReturn_Note,'null') <> ISNULL(@OldReturn_Note,'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Return_Note = Old ->"' +  ISNULL(@OldReturn_Note,'') + ' " NEW -> "' + isnull(@NewReturn_Note,'') + '", ';
							                 end
                                          
							              IF ISNULL(CAST(@NewOld_Price_NDS AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldOld_Price_NDS AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Old_Price_NDS = Old ->"' +  ISNULL(CAST(@OldOld_Price_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewOld_Price_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF ISNULL(CAST(@NewJSON_Size_Volume AS NVARCHAR(max)),'null') <> ISNULL(CAST(@OldJSON_Size_Volume AS NVARCHAR(max)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  JSON_Size_Volume = Old ->"' +  ISNULL(CAST(@OldJSON_Size_Volume AS NVARCHAR(max)),'') + ' " NEW -> "' + isnull(CAST(@NewJSON_Size_Volume AS NVARCHAR(max)),'') + '", ';
							                 end
                                          
							              IF ISNULL(CAST(@NewNew_Price_NDS AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldNew_Price_NDS AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  New_Price_NDS = Old ->"' +  ISNULL(CAST(@OldNew_Price_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewNew_Price_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF ISNULL(CAST(@NewNew_Price_no_NDS AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldNew_Price_no_NDS AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  New_Price_no_NDS = Old ->"' +  ISNULL(CAST(@OldNew_Price_no_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewNew_Price_no_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
                                          
							              IF ISNULL(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Created = Old ->"' +  ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                 end
							              
                                          IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                             end
                                          SET @ChangeDescription = 'Updated: ' + ' ID_Exemplar = "' +  isnull(cast(@OldID_Exemplar as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'null')
                                           --Удаляем запятую на конце
                                          IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                          INSERT  INTO dbo.Exemplar_Audit
                                          ( 
                                           ID_Exemplar,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									      set @ChangeDescription = '' 
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                                   					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Exemplar,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

		                   DECLARE @OldID_Exemplar_2                bigint         ;
						   DECLARE @OldId_Item_2                    bigint         ;
						   DECLARE @OldID_Currency_2                bigint         ;
						   DECLARE @OldID_Storage_location_2        bigint         ;
						   DECLARE @OldKeySource_2                  bigint         ;
						   DECLARE @OldSerial_number_2              nvarchar(500)  ;
						   DECLARE @OldID_Condition_of_the_item_2   bigint         ;
						   DECLARE @OldOld_Price_no_NDS_2           decimal(10,2)  ;
						   DECLARE @OldRefund_2                     bit            ;
						   DECLARE @OldDate_Refund_2                datetime       ;
						   DECLARE @OldReturn_Note_2                nvarchar(4000) ;
						   DECLARE @OldOld_Price_NDS_2              decimal(10,2)  ;
						   DECLARE @OldJSON_Size_Volume_2           nvarchar(max)  ;
						   DECLARE @OldNew_Price_NDS_2              decimal(10,2)  ;
						   DECLARE @OldNew_Price_no_NDS_2           decimal(10,2)  ;
						   DECLARE @OldDate_Created_2               datetime       ;
						   DECLARE @OldDescription_2                nvarchar(4000) ;    	  	

						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						        begin
							        begin try
									        set @ChangeDescription = ''

                                            SELECT 
							                    @OldID_Exemplar_2             	  = D.ID_Exemplar              ,
							                	@OldId_Item_2                 	  = D.Id_Item                  ,
							                	@OldID_Currency_2             	  = D.ID_Currency              ,
							                	@OldID_Storage_location_2     	  = D.ID_Storage_location      ,
							                	@OldKeySource_2               	  = D.KeySource                ,
							                	@OldSerial_number_2           	  = D.Serial_number            ,
							                	@OldID_Condition_of_the_item_2	  = D.ID_Condition_of_the_item ,
							                	@OldOld_Price_no_NDS_2        	  = D.Old_Price_no_NDS         ,
							                	@OldRefund_2                  	  = D.Refund                   ,
							                	@OldDate_Refund_2             	  = D.Date_Refund              ,
							                	@OldReturn_Note_2             	  = D.Return_Note              ,
							                	@OldOld_Price_NDS_2           	  = D.Old_Price_NDS            ,
							                	@OldJSON_Size_Volume_2        	  = D.JSON_Size_Volume         ,
							                	@OldNew_Price_NDS_2           	  = D.New_Price_NDS            ,
							                	@OldNew_Price_no_NDS_2        	  = D.New_Price_no_NDS         ,
							                	@OldDate_Created_2                = D.Date_Created             ,
							                	@OldDescription_2                 = D.[Description]        
							                FROM deleted D	
											where @ID_entity_D_2 = D.ID_Exemplar

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Exemplar'             +' = "'+  ISNULL(CAST(@OldID_Exemplar_2     AS NVARCHAR(50)),'')+ '", '
							                + 'Id_Item'                 +' = "'+  ISNULL(CAST(@OldId_Item_2  AS NVARCHAR(50)),'')+ '", '
							                + 'ID_Currency'             +' = "'+  ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(50)),'') + '", '
							                + 'ID_Storage_location'     +' = "'+  ISNULL(CAST(@OldID_Storage_location_2 AS NVARCHAR(50)),'') + '", '
							                + 'KeySource'               +' = "'+  ISNULL(CAST(@OldKeySource_2 AS NVARCHAR(50)),'')+ '", '				
							                + 'Serial_number'           +' = "'+  ISNULL(@OldSerial_number_2,'')+ '", '
							                + 'ID_Condition_of_the_item'+' = "'+  ISNULL(CAST(@OldID_Condition_of_the_item_2 AS NVARCHAR(50)),'') + '", '
							                + 'Old_Price_no_NDS'        +' = "'+  ISNULL(CAST(@OldOld_Price_no_NDS_2 AS NVARCHAR(50)),'')+ '", '
							                + 'Refund'                  +' = "'+  ISNULL(CAST(@OldRefund_2 AS NVARCHAR(1)),'') + '", '
							                + 'Date_Refund'             +' = "'+  ISNULL(CAST(Format(@OldDate_Refund_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Return_Note'             +' = "'+  ISNULL(@OldReturn_Note_2,'')+ '", '
							                + 'Old_Price_NDS'           +' = "'+  ISNULL(CAST(@OldOld_Price_NDS_2 AS NVARCHAR(50)),'') + '", '
							                + 'JSON_Size_Volume'        +' = "'+  ISNULL(CAST(@OldJSON_Size_Volume_2 AS NVARCHAR(MAX)),'') + '", '
							                + 'New_Price_NDS'           +' = "'+  ISNULL(CAST(@OldNew_Price_NDS_2 AS NVARCHAR(50)),'') + '", '
							                + 'New_Price_no_NDS'        +' = "'+  ISNULL(CAST(@OldNew_Price_no_NDS_2 AS NVARCHAR(50)),'') + '", '
							                + 'Date_Created'            +' = "'+  ISNULL(CAST(Format(@OldDate_Created_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
            				                + 'Description'             +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

							               IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Exemplar_Audit
                                           ( 
                                            ID_Exemplar,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''     
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                 END
        END
    ELSE
        BEGIN
                   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;

				   declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Exemplar,@login_name,GETDATE(),'I'  
					FROM  inserted I  

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						   begin
							      begin try
								        set @ChangeDescription = ''

                                        SET @ChangeDescription = 'Inserted: '
                                               + 'ID_Exemplar = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                        
										 INSERT  INTO dbo.Exemplar_Audit
                                         ( 
                                          ID_Exemplar,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                          SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									     set @ChangeDescription = ''
                                  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3               

                    END

GO


CREATE TABLE Group_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Group               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Group_Audit ON dbo.[Group]
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)= '';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Group,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Group,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;

							DECLARE @OldID_Group                bigint        ;
							DECLARE @OldID_Head_Group           bigint        ;
							DECLARE @OldID_Vice_Head_Group      bigint        ;
							DECLARE @OldID_Department           bigint        ;
							DECLARE @OldName_Group              nvarchar(300) ;
							DECLARE @OldID_Branch               bigint        ;
							DECLARE @OldDepartment_Code         int           ;
							DECLARE @OldDescription             nvarchar(1000);

							DECLARE @NewID_Group                bigint        ;
							DECLARE @NewID_Head_Group           bigint        ;
							DECLARE @NewID_Vice_Head_Group      bigint        ;
							DECLARE @NewID_Department           bigint        ;
							DECLARE @NewName_Group              nvarchar(300) ;
							DECLARE @NewID_Branch               bigint        ;
							DECLARE @NewDepartment_Code         int           ;
							DECLARE @NewDescription             nvarchar(1000);
							
						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

								        SELECT 
	                                        @NewID_Group           = I.ID_Group          ,
											@NewID_Head_Group      = I.ID_Head_Group     ,
											@NewID_Vice_Head_Group = I.ID_Vice_Head_Group,
											@NewID_Department      = I.ID_Department     ,
											@NewName_Group         = I.Name_Group        ,
											@NewID_Branch          = I.ID_Branch         ,
											@NewDepartment_Code    = I.Department_Code   ,
											@NewDescription        = I.[Description]       	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Group;

                                        SELECT 
                                            @OldID_Group           = D.ID_Group          ,
											@OldID_Head_Group      = D.ID_Head_Group     ,
											@OldID_Vice_Head_Group = D.ID_Vice_Head_Group,
											@OldID_Department      = D.ID_Department     ,
											@OldName_Group         = D.Name_Group        ,
											@OldID_Branch          = D.ID_Branch         ,
											@OldDepartment_Code    = D.Department_Code   ,
											@OldDescription        = D.[Description]       							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Group;


                                       IF ISNULL(CAST(@NewID_Head_Group AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Head_Group AS NVARCHAR(50)),'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Head_Group = Old ->"' +  ISNULL(CAST(@OldID_Head_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Head_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewID_Vice_Head_Group AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Vice_Head_Group AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Vice_Head_Group = Old ->"' +  ISNULL(CAST(@OldID_Vice_Head_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Vice_Head_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewID_Department AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Department = Old ->"' +  ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Department AS NVARCHAR(50)),'') + '", ';
							              end

							           IF ISNULL(@NewName_Group,'null') <> ISNULL(@OldName_Group,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Group = Old ->"' +  ISNULL(@OldName_Group,'') + ' " NEW -> " ' + isnull(@NewName_Group,'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewID_Branch AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewDepartment_Code AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldDepartment_Code AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Code = Old ->"' +  ISNULL(CAST(@OldDepartment_Code AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewDepartment_Code AS NVARCHAR(50)),'') + '", ';
							              end
          
                                       IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Group = "' +  isnull(cast(@OldID_Group as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Group_Audit
                                        ( 
                                         ID_Group,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Group,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Group_2                bigint        ;
							DECLARE @OldID_Head_Group_2           bigint        ;
							DECLARE @OldID_Vice_Head_Group_2      bigint        ;
							DECLARE @OldID_Department_2           bigint        ;
							DECLARE @OldName_Group_2              nvarchar(300) ;
							DECLARE @OldID_Branch_2               bigint        ;
							DECLARE @OldDepartment_Code_2         int           ;
							DECLARE @OldDescription_2             nvarchar(1000);


							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
                                                @OldID_Group_2           = D.ID_Group          ,
										    	@OldID_Head_Group_2      = D.ID_Head_Group     ,
										    	@OldID_Vice_Head_Group_2 = D.ID_Vice_Head_Group,
										    	@OldID_Department_2      = D.ID_Department     ,
										    	@OldName_Group_2         = D.Name_Group        ,
										    	@OldID_Branch_2          = D.ID_Branch         ,
										    	@OldDepartment_Code_2    = D.Department_Code   ,
										    	@OldDescription_2        = D.[Description]       							
							                FROM Deleted D
										    where @ID_entity_D_2 = D.ID_Group;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Group'            +' = "'+  ISNULL(CAST(@OldID_Group_2     AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Head_Group'       +' = "'+  ISNULL(CAST(@OldID_Head_Group_2  AS NVARCHAR(50)),'') + '", '
							                + 'ID_Vice_Head_Group'  +' = "'+  ISNULL(CAST(@OldID_Vice_Head_Group_2 AS NVARCHAR(50)),'') + '", '
											+ 'ID_Department'       +' = "'+  ISNULL(CAST(@OldID_Department_2 AS NVARCHAR(50)),'') + '", '
											+ 'Name_Group'          +' = "'+  ISNULL(@OldName_Group_2,'')+ '", '
											+ 'ID_Branch'           +' = "'+  ISNULL(CAST(@OldID_Branch_2 AS NVARCHAR(50)),'') + '", '
											+ 'Department_Code'     +' = "'+  ISNULL(CAST(@OldDepartment_Code_2 AS NVARCHAR(50)),'') + '", '
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Group_Audit
                                           ( 
                                            ID_Group,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Group,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Group = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Group_Audit
                                       ( 
                                        ID_Group,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Item_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Item                bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(Max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Item_Audit ON Item
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Item,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Item,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
                           DECLARE @OldId_Item                     bigint         	;
						   DECLARE @OldID_product_measurement      bigint         	;
						   DECLARE @OldID_TypeItem                 bigint         	;
						   DECLARE @OldID_Species_Item             bigint           ;
						   DECLARE @OldId_Item_Status              bigint           ;
						   DECLARE @OldArticle_number              nvarchar(300)  	;
						   DECLARE @OldName_Item                   nvarchar(500)  	;
						   DECLARE @OldImage_Item                  varbinary(max) 	;
						   DECLARE @OldManufacturer                nvarchar(500)  	;
						   DECLARE @OldCountry                     nvarchar(200)  	;
						   DECLARE @OldCity                        nvarchar(200)  	;
						   DECLARE @OldAdress                      nvarchar(800)  	;
						   DECLARE @OldMail                        nvarchar(250)  	;
						   DECLARE @OldPhone                       nvarchar(30)   	;
						   DECLARE @OldLogo                        varbinary(max) 	;
						   DECLARE @OldDate_Created                datetime       	;
						   DECLARE @OldQuantity                    int              ;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

                           DECLARE @NewId_Item                     bigint         	;
						   DECLARE @NewID_product_measurement      bigint         	;
						   DECLARE @NewID_TypeItem                 bigint         	;
						   DECLARE @NewID_Species_Item             bigint           ;
						   DECLARE @NewId_Item_Status              bigint           ;
						   DECLARE @NewArticle_number              nvarchar(300)  	;
						   DECLARE @NewName_Item                   nvarchar(500)  	;
						   DECLARE @NewImage_Item                  varbinary(max) 	;
						   DECLARE @NewManufacturer                nvarchar(500)  	;
						   DECLARE @NewCountry                     nvarchar(200)  	;
						   DECLARE @NewCity                        nvarchar(200)  	;
						   DECLARE @NewAdress                      nvarchar(800)  	;
						   DECLARE @NewMail                        nvarchar(250)  	;
						   DECLARE @NewPhone                       nvarchar(30)   	;
						   DECLARE @NewLogo                        varbinary(max) 	;
						   DECLARE @NewDate_Created                datetime       	;
						   DECLARE @NewQuantity                    int              ;
						   DECLARE @NewDescription                 nvarchar(4000)	;
						   
						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						         begin
							          begin try
						                    set @ChangeDescription = ''
                         
							                SELECT  
							                        @NewId_Item                    =  I.Id_Item                ,
							                		@NewID_product_measurement	   =  I.ID_product_measurement ,
							                		@NewID_TypeItem           	   =  I.ID_TypeItem            ,
													@NewID_Species_Item			   =  I.ID_Species_Item        ,
													@NewId_Item_Status             =  I.Id_Item_Status 		   ,
							                		@NewArticle_number        	   =  I.Article_number         ,
							                		@NewName_Item             	   =  I.Name_Item              ,
							                		@NewImage_Item            	   =  I.Image_Item             ,
							                		@NewManufacturer          	   =  I.Manufacturer           ,
							                		@NewCountry               	   =  I.Country                ,
							                		@NewCity                  	   =  I.City                   ,
							                		@NewAdress                	   =  I.Adress                 ,
							                		@NewMail                  	   =  I.Mail                   ,
							                		@NewPhone                 	   =  I.Phone                  ,
							                		@NewLogo                  	   =  I.Logo                   ,
							                		@NewDate_Created          	   =  I.Date_Created           ,
							                		@NewQuantity                   =  I.Quantity               ,
							                		@NewDescription                =  I.[Description]         	
							                FROM inserted I									 
											where @ID_entity_D = I.Id_Item;
							
							                SELECT 
							                        @OldId_Item                    =  D.Id_Item                ,
							                		@OldID_product_measurement	   =  D.ID_product_measurement ,
							                		@OldID_TypeItem           	   =  D.ID_TypeItem            ,
													@OldID_Species_Item			   =  D.ID_Species_Item        ,
													@OldId_Item_Status             =  D.Id_Item_Status 		   ,
							                		@OldArticle_number        	   =  D.Article_number         ,
							                		@OldName_Item             	   =  D.Name_Item              ,
							                		@OldImage_Item            	   =  D.Image_Item             ,
							                		@OldManufacturer          	   =  D.Manufacturer           ,
							                		@OldCountry               	   =  D.Country                ,
							                		@OldCity                  	   =  D.City                   ,
							                		@OldAdress                	   =  D.Adress                 ,
							                		@OldMail                  	   =  D.Mail                   ,
							                		@OldPhone                 	   =  D.Phone                  ,
							                		@OldLogo                  	   =  D.Logo                   ,
							                		@OldDate_Created          	   =  D.Date_Created           ,
							                		@OldQuantity                   =  D.Quantity               ,
							                		@OldDescription                =  D.[Description]         								
							                FROM Deleted D
											where @ID_entity_D = D.Id_Item;

                                            IF ISNULL(CAST(@NewID_product_measurement AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_product_measurement AS NVARCHAR(50)),'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_product_measurement = Old ->"' +  ISNULL(CAST(@OldID_product_measurement AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_product_measurement AS NVARCHAR(50)),'') + '", ';
							                   end
                                            
							                IF ISNULL(CAST(@NewID_TypeItem AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_TypeItem AS NVARCHAR(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_TypeItem = Old ->"' +  ISNULL(CAST(@OldID_TypeItem AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_TypeItem AS NVARCHAR(50)),'') + '", ';
							                   end

                                            IF ISNULL(CAST(@NewID_Species_Item AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Species_Item AS NVARCHAR(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Species_Item = Old ->"' +  ISNULL(CAST(@OldID_Species_Item AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Species_Item AS NVARCHAR(50)),'') + '", ';
							                   end

											IF ISNULL(CAST(@NewId_Item_Status AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldId_Item_Status AS NVARCHAR(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Item_Status = Old ->"' +  ISNULL(CAST(@OldId_Item_Status AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewId_Item_Status AS NVARCHAR(50)),'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewArticle_number,'null') <> ISNULL(@OldArticle_number,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Article_number = Old ->"' +  ISNULL(@OldArticle_number,'') + ' " NEW -> " ' + isnull(@NewArticle_number,'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewName_Item,'null') <> ISNULL(@OldName_Item,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Item = Old ->"' +  ISNULL(@OldName_Item,'') + ' " NEW -> " ' + isnull(@NewName_Item,'') + '", ';
							                   end
					                        
							                IF ISNULL(cast(@NewImage_Item as nvarchar(10)),'null') <> ISNULL(cast(@OldImage_Item as nvarchar(10)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Image_Item = '  +  '"Изображение было изменено или удалено", ';
							                   end
					                        
							                IF ISNULL(@NewManufacturer,'null') <> ISNULL(@OldManufacturer,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Manufacturer = Old ->"' +  ISNULL(@OldManufacturer,'') + ' " NEW -> " ' + isnull(@NewManufacturer,'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewCountry,'null') <> ISNULL(@OldCountry,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Country = Old ->"' +  ISNULL(@OldCountry,'') + ' " NEW -> " ' + isnull(@NewCountry,'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewCity,'null') <> ISNULL(@OldCity,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  City = Old ->"' +  ISNULL(@OldCity,'') + ' " NEW -> " ' + isnull(@NewCity,'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewAdress,'null') <> ISNULL(@OldAdress,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Adress = Old ->"' +  ISNULL(@OldAdress,'') + ' " NEW -> " ' + isnull(@NewAdress,'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewMail,'null') <> ISNULL(@OldMail,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							                   end
					                        
							                IF ISNULL(@NewPhone,'null') <> ISNULL(@OldPhone,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> " ' + isnull(@NewPhone,'') + '", ';
							                   end
					                        
							                IF ISNULL(cast(@NewLogo as nvarchar(10)),'null') <> ISNULL(cast(@OldLogo as nvarchar(10)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Logo = ' +  '"Изображение было изменено или удалено", ';
							                   end
							                
							                IF ISNULL(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Created = Old ->"' +  ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
					                        IF ISNULL(CAST(@NewQuantity AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldQuantity AS NVARCHAR(50)),'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Quantity = Old ->"' +  ISNULL(CAST(@OldQuantity AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewQuantity AS NVARCHAR(50)),'') + '", ';
							                   end
                                            
							                
                                            IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Item = "' +  isnull(cast(@OldId_Item as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'') + '"'
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                             INSERT  INTO dbo.Item_Audit
                                             ( 
                                              Id_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                             )
                                               SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                             
									         set @ChangeDescription = '' 
 					              end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Item,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ; 

						   DECLARE @OldId_Item_2                       bigint         ;
						   DECLARE @OldID_product_measurement_2        bigint         ;
						   DECLARE @OldID_TypeItem_2                   bigint         ;
						   DECLARE @OldID_Species_Item_2               bigint         ;
						   DECLARE @OldId_Item_Status_2                bigint         ;
						   DECLARE @OldArticle_number_2                nvarchar(300)  ;
						   DECLARE @OldName_Item_2                     nvarchar(500)  ;
						   DECLARE @OldImage_Item_2                    varbinary(max) ;
						   DECLARE @OldManufacturer_2                  nvarchar(500)  ;
						   DECLARE @OldCountry_2                       nvarchar(200)  ;
						   DECLARE @OldCity_2                          nvarchar(200)  ;
						   DECLARE @OldAdress_2                        nvarchar(800)  ;
						   DECLARE @OldMail_2                          nvarchar(250)  ;
						   DECLARE @OldPhone_2                         nvarchar(30)   ;
						   DECLARE @OldLogo_2                          varbinary(max) ;
						   DECLARE @OldDate_Created_2                  datetime       ;
						   DECLARE @OldQuantity_2                      int            ;
	                       DECLARE @OldDescription_2                   nvarchar(4000) ;


						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						        begin
							         begin try
									            set @ChangeDescription = ''

                                                SELECT 
                                                    @OldId_Item_2                   = D.Id_Item               ,
							                    	@OldID_product_measurement_2    = D.ID_product_measurement,
							                    	@OldID_TypeItem_2               = D.ID_TypeItem           ,
													@OldID_Species_Item_2			= D.ID_Species_Item       ,
													@OldId_Item_Status_2            = D.Id_Item_Status 		  ,
							                    	@OldArticle_number_2            = D.Article_number        ,
							                    	@OldName_Item_2                 = D.Name_Item             ,
							                    	@OldImage_Item_2                = D.Image_Item            ,
							                    	@OldManufacturer_2              = D.Manufacturer          ,
							                    	@OldCountry_2                   = D.Country               ,
							                    	@OldCity_2                      = D.City                  ,
							                    	@OldAdress_2                    = D.Adress                ,
							                    	@OldMail_2                      = D.Mail                  ,
							                    	@OldPhone_2                     = D.Phone                 ,
							                    	@OldLogo_2                      = D.Logo                  ,
							                    	@OldDate_Created_2              = D.Date_Created          ,
							                    	@OldQuantity_2                  = D.Quantity              ,        
							                    	@OldDescription_2               = D.[Description]        
							                    FROM deleted D
												where @ID_entity_D_2 = D.Id_Item;

                                                SET @ChangeDescription = 'Deleted: '
							                    + 'Id_Item'                +' = "'+  ISNULL(CAST(@OldId_Item_2 AS NVARCHAR(50)),'')+ '", '
							                    + 'ID_product_measurement' +' = "'+  ISNULL(CAST(@OldID_product_measurement_2 AS NVARCHAR(50)),'')+ '", '
							                    + 'ID_TypeItem'            +' = "'+  ISNULL(CAST(@OldID_TypeItem_2 AS NVARCHAR(50)),'')+ '", '
                                                + 'ID_Species_Item'        +' = "'+  ISNULL(CAST(@OldID_Species_Item_2 AS NVARCHAR(50)),'')+ '", '
												+ 'Id_Item_Status'         +' = "'+  ISNULL(CAST(@OldId_Item_Status_2 AS NVARCHAR(50)),'')+ '", '
							                    + 'Article_number'         +' = "'+  ISNULL(@OldArticle_number_2,'')+ '", '
							                    + 'Name_Item'              +' = "'+  ISNULL(@OldName_Item_2,'')+ '", '
							                    + 'Image_Item'             +' = "'+  ISNULL(cast(@OldImage_Item_2 as varchar(max)),'')+ '", '
							                    + 'Manufacturer'           +' = "'+  ISNULL(@OldManufacturer_2,'')+ '", '
							                    + 'Country'                +' = "'+  ISNULL(@OldCountry_2,'')+ '", '
							                    + 'City'                   +' = "'+  ISNULL(@OldCity_2,'')+ '", '
							                    + 'Adress'                 +' = "'+  ISNULL(@OldAdress_2,'')+ '", '
							                    + 'Mail'                   +' = "'+  ISNULL(@OldMail_2,'')+ '", '
							                    + 'Phone'                  +' = "'+  ISNULL(@OldPhone_2,'')+ '", '
							                    + 'Logo'                   +' = "'+  ISNULL(cast(@OldLogo_2 as varchar(max)),'')+ '", '
							                    + 'Date_Created'           +' = "'+  ISNULL(CAST(Format(@OldDate_Created_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'')+ '", '
							                    + 'Quantity'               +' = "'+  ISNULL(CAST(@OldQuantity_2 AS NVARCHAR(50)),'')+ '", '
							                    + 'Description'            +' = "'+  ISNULL(@OldDescription_2  ,'')+ '"'

                                                IF LEN(@ChangeDescription) > 0
                                                      SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                                
												INSERT  INTO dbo.Item_Audit
                                                ( 
                                                 Id_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                                )
                                                 SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									             set @ChangeDescription = ''
                                 end try
								 begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2                        
                END  
        END
    ELSE
        BEGIN
		            declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.Id_Item,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						   begin
							      begin try
		                                 set @ChangeDescription = ''

                                         SET @ChangeDescription = 'Inserted: '
                                                    + 'Id_Item = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                         INSERT  INTO dbo.Item_Audit
                                         ( 
                                          Id_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                          SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									     set @ChangeDescription = ''    
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE Item_status_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Item_Status         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Item_status_Audit ON Item_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Item_Status,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Item_Status,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      

						   DECLARE @OldId_Item_Status          bigint        ;
						   DECLARE @OldItemStatus              nvarchar(300) ;
						   DECLARE @OldSysItemStatusName       nvarchar(300) ;
						   DECLARE @OldDescription      	   nvarchar(4000);


						   DECLARE @NewId_Item_Status           bigint        ;
						   DECLARE @NewItemStatus               nvarchar(300) ;
						   DECLARE @NewSysItemStatusName        nvarchar(300) ;
						   DECLARE @NewDescription      	    nvarchar(4000);
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewId_Item_Status        = I.Id_Item_Status   ,
							                	  @NewItemStatus       	    = I.ItemStatus       ,
							                	  @NewSysItemStatusName  	= I.SysItemStatusName,
							                	  @NewDescription      	    = I.[Description]      	
							                FROM inserted I									 
							                where @ID_entity_D = I.Id_Item_Status;	

							                SELECT 
                                                  @OldId_Item_Status        = D.Id_Item_Status   ,
							                	  @OldItemStatus        	= D.ItemStatus       ,
							                	  @OldSysItemStatusName 	= D.SysItemStatusName,
							                	  @OldDescription      	    = D.[Description]      	
							                FROM Deleted D																		 
											 where @ID_entity_D = D.Id_Item_Status; 


                                            IF isnull(@NewItemStatus,'null') <> isnull(@OldItemStatus,'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ItemStatus = Old ->"' +  ISNULL(@OldItemStatus,'') + ' " NEW -> " ' + isnull(@NewItemStatus,'') + '", ';
							                   end
                                            
							                IF isnull(@NewSysItemStatusName,'null') <> isnull(@OldSysItemStatusName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysItemStatusName = Old ->"' +  ISNULL(@OldSysItemStatusName,'') + ' " NEW -> " ' + isnull(@NewSysItemStatusName,'') + '", ';
							                   end
                                                                                                    
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Item_Status = "' +  isnull(cast(@OldId_Item_Status as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Item_status_Audit
                                            ( 
                                             Id_Item_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Item_Status,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                           DECLARE @OldId_Item_Status_2          bigint        ;
						   DECLARE @OldItemStatus_2              nvarchar(300) ;
						   DECLARE @OldSysItemStatusName_2       nvarchar(300) ;
						   DECLARE @OldDescription_2      	     nvarchar(4000);

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
										      @OldId_Item_Status_2        = D.Id_Item_Status   ,
											  @OldItemStatus_2        	  = D.ItemStatus       ,
											  @OldSysItemStatusName_2 	  = D.SysItemStatusName,
							               	  @OldDescription_2      	  = D.[Description]      		  
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.Id_Item_Status;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'Id_Item_Status'       +' = "'+  ISNULL(CAST(@OldId_Item_Status_2  AS NVARCHAR(50)),'')+ '", '
							               + 'ItemStatus'           +' = "'+  ISNULL(@OldItemStatus_2,'')+ '", '
							               + 'SysItemStatusName'    +' = "'+  ISNULL(@OldSysItemStatusName_2,'')+ '", '
							               + '[Description]'        +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Item_status_Audit
                                           ( 
                                            Id_Item_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.Id_Item_Status,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Item_Status = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Item_status_Audit
                                      ( 
                                       Id_Item_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''              

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Order_Assignment_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_OrderAssignment     bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group;


go

CREATE TRIGGER trg_Order_Assignment_Audit ON Order_Assignment
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_OrderAssignment,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_OrderAssignment,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      
                           DECLARE @OldID_OrderAssignment       bigint        ;
						   DECLARE @OldOrderAssignmentName      nvarchar(300) ;
						   DECLARE @OldOrderAssignmentNameEng   nvarchar(300) ;
						   DECLARE @OldOrderAssignmentSysName   nvarchar(300) ;
						   DECLARE @OldDescription              nvarchar(4000);

                           DECLARE @NewID_OrderAssignment       bigint        ;
						   DECLARE @NewOrderAssignmentName      nvarchar(300) ;
						   DECLARE @NewOrderAssignmentNameEng   nvarchar(300) ;
						   DECLARE @NewOrderAssignmentSysName   nvarchar(300) ;
						   DECLARE @NewDescription              nvarchar(4000);
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewID_OrderAssignment      	= I.ID_OrderAssignment    ,
												  @NewOrderAssignmentName    	= I.OrderAssignmentName   ,
												  @NewOrderAssignmentNameEng 	= I.OrderAssignmentNameEng,
												  @NewOrderAssignmentSysName 	= I.OrderAssignmentSysName,
												  @NewDescription               = I.[Description]      	  
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_OrderAssignment;	

							                SELECT   
                                                  @OldID_OrderAssignment      	= D.ID_OrderAssignment    ,
												  @OldOrderAssignmentName    	= D.OrderAssignmentName   ,
												  @OldOrderAssignmentNameEng 	= D.OrderAssignmentNameEng,
												  @OldOrderAssignmentSysName 	= D.OrderAssignmentSysName,
												  @OldDescription               = D.[Description]        	  
							                FROM Deleted D																		 
											 where @ID_entity_D = D.ID_OrderAssignment; 


                                            IF ISNULL(@NewOrderAssignmentName,'null') <> ISNULL(@OldOrderAssignmentName,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  OrderAssignmentName = Old ->"' +  ISNULL(@OldOrderAssignmentName,'') + ' " NEW -> " ' + isnull(@NewOrderAssignmentName,'') + '", ';
							                   end
                                            
							                IF ISNULL(@NewOrderAssignmentNameEng,'null') <> ISNULL(@OldOrderAssignmentNameEng,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  OrderAssignmentNameEng = Old ->"' +  ISNULL(@OldOrderAssignmentNameEng,'') + ' " NEW -> " ' + isnull(@NewOrderAssignmentNameEng,'') + '", ';
							                   end

											IF ISNULL(@NewOrderAssignmentSysName,'null') <> ISNULL(@OldOrderAssignmentSysName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  OrderAssignmentSysName = Old ->"' +  ISNULL(@OldOrderAssignmentSysName,'') + ' " NEW -> " ' + isnull(@NewOrderAssignmentSysName,'') + '", ';
							                   end
                                                                                                    
                                            IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' ID_OrderAssignment = "' +  isnull(cast(@OldID_OrderAssignment as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Order_Assignment_Audit
                                            ( 
                                             ID_OrderAssignment,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_OrderAssignment,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                           DECLARE @OldID_OrderAssignment_2       bigint        ;
						   DECLARE @OldOrderAssignmentName_2      nvarchar(300) ;
						   DECLARE @OldOrderAssignmentNameEng_2   nvarchar(300) ;
						   DECLARE @OldOrderAssignmentSysName_2   nvarchar(300) ;
						   DECLARE @OldDescription_2              nvarchar(4000);

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
                                                @OldID_OrderAssignment_2     = D.ID_OrderAssignment    ,
												@OldOrderAssignmentName_2    = D.OrderAssignmentName   ,
												@OldOrderAssignmentNameEng_2 = D.OrderAssignmentNameEng,
												@OldOrderAssignmentSysName_2 = D.OrderAssignmentSysName,
												@OldDescription_2            = D.[Description]        	
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.ID_OrderAssignment;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'ID_OrderAssignment'      +' = "'+  ISNULL(CAST(@OldID_OrderAssignment_2  AS NVARCHAR(50)),'')+ '", '
										   + 'OrderAssignmentName'     +' = "'+  ISNULL(@OldOrderAssignmentName_2,'')+ '", '
							               + 'OrderAssignmentNameEng'  +' = "'+  ISNULL(@OldOrderAssignmentNameEng_2,'')+ '", '
							               + 'OrderAssignmentSysName'  +' = "'+  ISNULL(@OldOrderAssignmentSysName_2,'')+ '", '
							               + '[Description]'           +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Order_Assignment_Audit
                                           ( 
                                            ID_OrderAssignment,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.ID_OrderAssignment,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_OrderAssignment = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Order_Assignment_Audit
                                      ( 
                                       ID_OrderAssignment,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''              

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Order_category_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_OrderCategory       bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group;


go

CREATE TRIGGER trg_Order_category_Audit ON Order_category
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_OrderCategory,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_OrderCategory,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      
                           DECLARE @OldID_OrderCategory         bigint         ;
						   DECLARE @OldOrderCategoryName   	    nvarchar(300)  ;
						   DECLARE @OldAbbreviation        	    nvarchar(10)   ;
						   DECLARE @OldOrderCategorySysName	    nvarchar(300)  ;
						   DECLARE @OldDescription      		nvarchar(4000) ;

                           DECLARE @NewID_OrderCategory         bigint         ;
						   DECLARE @NewOrderCategoryName   	    nvarchar(300)  ;
						   DECLARE @NewAbbreviation        	    nvarchar(10)   ;
						   DECLARE @NewOrderCategorySysName	    nvarchar(300)  ;
						   DECLARE @NewDescription      		nvarchar(4000) ;
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewID_OrderCategory     	= I.ID_OrderCategory    ,
												  @NewOrderCategoryName   	= I.OrderCategoryName   ,
												  @NewAbbreviation        	= I.Abbreviation        ,
												  @NewOrderCategorySysName	= I.OrderCategorySysName,
												  @NewDescription      	    = I.[Description]      	  
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_OrderCategory;

							                SELECT   
											      @OldID_OrderCategory     	= D.ID_OrderCategory    ,
												  @OldOrderCategoryName   	= D.OrderCategoryName   ,
												  @OldAbbreviation        	= D.Abbreviation        ,
												  @OldOrderCategorySysName	= D.OrderCategorySysName,
												  @OldDescription      	    = D.[Description]      	  
							                FROM Deleted D																		 
											 where @ID_entity_D = D.ID_OrderCategory; 

                                            IF ISNULL(@NewOrderCategoryName,'null') <> ISNULL(@OldOrderCategoryName,'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  OrderCategoryName = Old ->"' +  ISNULL(@OldOrderCategoryName,'') + ' " NEW -> " ' + isnull(@NewOrderCategoryName,'') + '", ';
							                   end
                                            
							                IF ISNULL(@NewAbbreviation,'null') <> ISNULL(@OldAbbreviation,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Abbreviation = Old ->"' +  ISNULL(@OldAbbreviation,'') + ' " NEW -> " ' + isnull(@NewAbbreviation,'') + '", ';
							                   end

											IF ISNULL(@NewOrderCategorySysName,'null') <> ISNULL(@OldOrderCategorySysName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  OrderCategorySysName = Old ->"' +  ISNULL(@OldOrderCategorySysName,'') + ' " NEW -> " ' + isnull(@NewOrderCategorySysName,'') + '", ';
							                   end
                                                                                                    
                                            IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' ID_OrderCategory = "' +  isnull(cast(@OldID_OrderCategory as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Order_category_Audit
                                            ( 
                                             ID_OrderCategory,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = ''

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_OrderCategory,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                           DECLARE @OldID_OrderCategory_2           bigint         ;
						   DECLARE @OldOrderCategoryName_2   	    nvarchar(300)  ;
						   DECLARE @OldAbbreviation_2        	    nvarchar(10)   ;
						   DECLARE @OldOrderCategorySysName_2	    nvarchar(300)  ;
						   DECLARE @OldDescription_2      		    nvarchar(4000) ;

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
                                                 @OldID_OrderCategory_2     	= D.ID_OrderCategory    ,
												 @OldOrderCategoryName_2   	    = D.OrderCategoryName   ,
												 @OldAbbreviation_2        	    = D.Abbreviation        ,
												 @OldOrderCategorySysName_2	    = D.OrderCategorySysName,
												 @OldDescription_2      	    = D.[Description]      	  
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.ID_OrderCategory;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'ID_OrderCategory'      +' = "'+  ISNULL(CAST(@OldID_OrderCategory_2  AS NVARCHAR(50)),'')+ '", '
										   + 'OrderCategoryName'     +' = "'+  ISNULL(@OldOrderCategoryName_2,'')+ '", '
							               + 'Abbreviation'          +' = "'+  ISNULL(@OldAbbreviation_2,'')+ '", '
							               + 'OrderCategorySysName'  +' = "'+  ISNULL(@OldOrderCategorySysName_2,'')+ '", '
							               + '[Description]'         +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Order_category_Audit
                                           ( 
                                            ID_OrderCategory,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.ID_OrderCategory,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_OrderCategory = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Order_category_Audit
                                      ( 
                                       ID_OrderCategory,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''             

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Orders_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Orders              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group;


go

CREATE TRIGGER trg_Orders_Audit ON Orders
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);
                   
                            insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Orders,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Orders,@login_name,GETDATE(),'U'  
							FROM  inserted D
                            
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
	                       
						   DECLARE @OldID_Orders          bigint        ;
						   DECLARE @OldID_status          bigint        ;
						   DECLARE @OldID_TypeOrders      bigint        ;
						   DECLARE @OldID_Currency        bigint        ;
						   DECLARE @OldID_OrderAssignment bigint        ;
						   DECLARE @OldID_OrderCategory	  bigint        ;
						   DECLARE @OldDate               datetime      ;
						   DECLARE @OldPayment_Date       datetime      ;
						   DECLARE @OldAmount             decimal(10,2) ;
						   DECLARE @OldAmountCurr         decimal(10,2) ;
						   DECLARE @OldAmountNDS          decimal(10,2) ;
						   DECLARE @OldAmountCurrNDS      decimal(10,2) ;
						   DECLARE @OldNum                nvarchar(50)  ;
						   DECLARE @OldDescription        nvarchar(4000);


						   DECLARE @NewID_Orders           bigint        ;
						   DECLARE @NewID_status           bigint        ;
						   DECLARE @NewID_TypeOrders       bigint        ;
						   DECLARE @NewID_Currency         bigint        ;
						   DECLARE @NewID_OrderAssignment  bigint        ;
						   DECLARE @NewID_OrderCategory	   bigint        ;
						   DECLARE @NewDate                datetime      ;
						   DECLARE @NewPayment_Date        datetime      ;
						   DECLARE @NewAmount              decimal(10,2) ;
						   DECLARE @NewAmountCurr          decimal(10,2) ;
						   DECLARE @NewAmountNDS           decimal(10,2) ;
						   DECLARE @NewAmountCurrNDS       decimal(10,2) ;
						   DECLARE @NewNum                 nvarchar(50)  ;
						   DECLARE @NewDescription         nvarchar(4000);
						
                           declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

										SELECT 
                                               @NewID_Orders           =  I.ID_Orders         ,
							            	   @NewID_status           =  I.ID_status    	  ,
							            	   @NewID_TypeOrders       =  I.ID_TypeOrders	  ,
							            	   @NewID_Currency         =  I.ID_Currency  	  ,
											   @NewID_OrderAssignment  =  I.ID_OrderAssignment,
											   @NewID_OrderCategory	   =  I.ID_OrderCategory  ,
							            	   @NewDate                =  I.Date              ,         --convert(datetime,Date,109),     
							            	   @NewPayment_Date        =  I.Payment_Date      ,         --convert(datetime,Payment_Date,109),
							            	   @NewAmount              =  I.Amount       	  ,
							            	   @NewAmountCurr          =  I.AmountCurr   	  ,
							            	   @NewAmountNDS           =  I.AmountNDS    	  ,
							            	   @NewAmountCurrNDS       =  I.AmountCurrNDS	  ,
							            	   @NewNum                 =  I.Num          	  ,
							            	   @NewDescription         =  I.[Description]  
							            FROM inserted I									 
										where @ID_entity_D = I.ID_Orders

							            SELECT 
							                   @OldID_Orders           =  D.ID_Orders         ,
							            	   @OldID_status           =  D.ID_status    	  ,
							            	   @OldID_TypeOrders       =  D.ID_TypeOrders	  ,
							            	   @OldID_Currency         =  D.ID_Currency  	  ,
											   @OldID_OrderAssignment  =  D.ID_OrderAssignment,
											   @OldID_OrderCategory	   =  D.ID_OrderCategory  ,
							            	   @OldDate                =  D.Date              ,       --convert(datetime,Date,109),
							            	   @OldPayment_Date        =  D.Payment_Date      ,       --convert(datetime,Payment_Date,109),
							            	   @OldAmount              =  D.Amount            ,
							            	   @OldAmountCurr          =  D.AmountCurr        ,
							            	   @OldAmountNDS           =  D.AmountNDS         ,
							            	   @OldAmountCurrNDS       =  D.AmountCurrNDS     ,
							            	   @OldNum                 =  D.Num               ,
							            	   @OldDescription         =  D.[Description]  
							            FROM Deleted D																		 
										where @ID_entity_D = D.ID_Orders



                                        IF ISNULL(CAST(@NewID_status AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_status AS NVARCHAR(50)),'null') 
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_status = Old ->"' +  ISNULL(CAST(@OldID_status AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_status AS NVARCHAR(50)),'') + '", ';
							               end
                                        
							            IF ISNULL(CAST(@NewID_TypeOrders AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_TypeOrders AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_TypeOrders = Old ->"' +  ISNULL(CAST(@OldID_TypeOrders AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_TypeOrders AS NVARCHAR(50)),'') + '", ';
							               end
							            IF ISNULL(CAST(@NewID_Currency AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Currency AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(CAST(@OldID_Currency AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Currency AS NVARCHAR(50)),'') + '", ';
							               end
                                        IF ISNULL(CAST(@NewID_OrderAssignment AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_OrderAssignment AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_OrderAssignment = Old ->"' +  ISNULL(CAST(@OldID_OrderAssignment AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_OrderAssignment AS NVARCHAR(50)),'') + '", ';
							               end        
										IF ISNULL(CAST(@NewID_OrderCategory AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_OrderCategory AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_OrderCategory = Old ->"' +  ISNULL(CAST(@OldID_OrderCategory AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_OrderCategory AS NVARCHAR(50)),'') + '", ';
							               end		


							            IF ISNULL(CAST(Format(@NewDate,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date = Old ->"' +  ISNULL(CAST(Format(@OldDate,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
							            IF ISNULL(CAST(Format(@NewPayment_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldPayment_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Payment_Date = Old ->"' +  ISNULL(CAST(Format(@OldPayment_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewPayment_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
							            IF ISNULL(CAST(@NewAmount AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldAmount AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Amount = Old ->"' +  ISNULL(CAST(@OldAmount AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmount AS NVARCHAR(50)),'') + '", ';
							               end
							            
							            IF ISNULL(CAST(@NewAmountCurr AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldAmountCurr AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  AmountCurr = Old ->"' +  ISNULL(CAST(@OldAmountCurr AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmountCurr AS NVARCHAR(50)),'') + '", ';
							               end

							            IF ISNULL(CAST(@NewAmountNDS AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldAmountNDS AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  AmountNDS = Old ->"' +  ISNULL(CAST(@OldAmountNDS AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmountNDS AS NVARCHAR(50)),'') + '", ';
							               end
                                        
							            IF ISNULL(CAST(@NewAmountCurrNDS AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldAmountCurrNDS AS NVARCHAR(50)),'null') 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  AmountCurrNDS = Old ->"' +  ISNULL(CAST(@OldAmountCurrNDS AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmountCurrNDS AS NVARCHAR(50)),'') + '", ';
							               end

							            IF ISNULL(@NewNum,'null') <> ISNULL(@OldNum,'null')
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Num = Old ->"' +  ISNULL(@OldNum,'') + ' " NEW -> " ' + isnull(@NewNum,'') + '", ';
							               end
							            
                                        IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                           end
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Orders = "' +  isnull(cast(@OldID_Orders as nvarchar(20)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                        
										INSERT  INTO dbo.Orders_Audit
                                        ( 
                                         ID_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = '' 
                                  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
   					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Orders,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                            DECLARE @OldID_Orders_2           bigint        ;
							DECLARE @OldID_status_2           bigint        ;
							DECLARE @OldID_TypeOrders_2       bigint        ;
							DECLARE @OldID_Currency_2         bigint        ;
							DECLARE @OldID_OrderAssignment_2  bigint        ;
						    DECLARE @OldID_OrderCategory_2	  bigint        ;
							DECLARE @OldDate_2                datetime      ;
							DECLARE @OldPayment_Date_2        datetime      ;
							DECLARE @OldAmount_2              decimal(10,2) ;
							DECLARE @OldAmountCurr_2          decimal(10,2) ;
							DECLARE @OldAmountNDS_2           decimal(10,2) ;
							DECLARE @OldAmountCurrNDS_2       decimal(10,2) ;
							DECLARE @OldNum_2                 nvarchar(50)  ;
							DECLARE @OldDescription_2         nvarchar(4000);

							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						   
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								        set @ChangeDescription = ''

							            SELECT 
							               @OldID_Orders_2          =  D.ID_Orders         ,
							               @OldID_status_2     	    =  D.ID_status    	   ,
							               @OldID_TypeOrders_2 	    =  D.ID_TypeOrders	   ,
							               @OldID_Currency_2   	    =  D.ID_Currency  	   ,
										   @OldID_OrderAssignment_2 =  D.ID_OrderAssignment,
										   @OldID_OrderCategory_2	=  D.ID_OrderCategory  ,
							               @OldDate_2          	    =  D.Date              ,    --convert(datetime,Date,109),         	 
							               @OldPayment_Date_2  	    =  D.Payment_Date      ,    --convert(datetime,Payment_Date,109), 	 
							               @OldAmount_2        	    =  D.Amount       	   ,
							               @OldAmountCurr_2    	    =  D.AmountCurr   	   ,
							               @OldAmountNDS_2     	    =  D.AmountNDS    	   ,
							               @OldAmountCurrNDS_2 	    =  D.AmountCurrNDS	   ,
							               @OldNum_2           	    =  D.Num          	   ,
							               @OldDescription_2   	    =  D.[Description]  	 
							            FROM deleted D									 
										where @ID_entity_D_2 = D.ID_Orders

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_Orders'           +' = "'+  ISNULL(CAST(@OldID_Orders_2          AS NVARCHAR(50)),'')        + '", '
							            + 'ID_status'           +' = "'+  ISNULL(CAST(@OldID_status_2          AS NVARCHAR(50)),'') 	   + '", '
							            + 'ID_TypeOrders'       +' = "'+  ISNULL(CAST(@OldID_TypeOrders_2      AS NVARCHAR(50)),'') 	   + '", '
							            + 'ID_Currency'         +' = "'+  ISNULL(CAST(@OldID_Currency_2        AS NVARCHAR(50)),'') 	   + '", '
										+ 'ID_OrderAssignment'  +' = "'+  ISNULL(CAST(@OldID_OrderAssignment_2 AS NVARCHAR(50)),'') 	   + '", '
							            + 'ID_OrderCategory'    +' = "'+  ISNULL(CAST(@OldID_OrderCategory_2   AS NVARCHAR(50)),'') 	   + '", '
							            + 'Date'                +' = "'+  ISNULL(CAST(Format(@OldDate_2,'yyyy-MM-dd HH:mm:ss.fff')          AS NVARCHAR(50)),'') 	   + '", '
							            + 'Payment_Date'        +' = "'+  ISNULL(CAST(Format(@OldPayment_Date_2,'yyyy-MM-dd HH:mm:ss.fff')  AS NVARCHAR(50)),'') 	   + '", '
							            + 'Amount'              +' = "'+  ISNULL(CAST(@OldAmount_2             AS NVARCHAR(50)),'') 	   + '", '
							            + 'AmountCurr'          +' = "'+  ISNULL(CAST(@OldAmountCurr_2         AS NVARCHAR(50)),'') 	   + '", '
							            + 'AmountNDS'           +' = "'+  ISNULL(CAST(@OldAmountNDS_2          AS NVARCHAR(50)),'') 	   + '", '
							            + 'AmountCurrNDS'       +' = "'+  ISNULL(CAST(@OldAmountCurrNDS_2      AS NVARCHAR(50)),'') 	   + '", '
							            + 'Num'                 +' = "'+  ISNULL(@OldNum_2          ,'') 	   + '", '
							            + '[Description]'       +' = "'+  ISNULL(@OldDescription_2  ,'') 	   + '", '

                                        IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                         INSERT  INTO dbo.Orders_Audit
                                         ( 
                                          ID_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                          SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									     set @ChangeDescription = ''   
								    
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2

                END  
        END
    ELSE
        BEGIN
		             DECLARE @ID_entity_I_2    bigint       ;
				     DECLARE @login_name_2_I_2 nvarchar(128);
				     DECLARE @ModifiedDate_I_2 DATETIME     ;
				     DECLARE @Name_action_I_2  char(1)      ;

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Orders,@login_name,GETDATE(),'I'  
					FROM  inserted I    

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
						   
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						 begin
							  begin try
							        set @ChangeDescription = ''

                                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Orders = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                     
                                     INSERT  INTO dbo.Orders_Audit
                                     ( 
                                      ID_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''
                               end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE Orders_status_Audit
(
    AuditID              bigint IDENTITY(1,1)  not null,
    Id_Status            bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group;


go

CREATE TRIGGER trg_Orders_status_Audit ON Orders_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'U'  
							FROM  inserted D
                            
							
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
							
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


	                       DECLARE @OldId_Status                  bigint        ;  
						   DECLARE @OldName                       nvarchar(300) ;
						   DECLARE @OldSysTypeOrderStatusName     nvarchar(300) ;
						   DECLARE @OldDescription                nvarchar(4000);

						   DECLARE @NewId_Status                  bigint        ;
						   DECLARE @NewName                       nvarchar(300) ;
						   DECLARE @NewSysTypeOrderStatusName     nvarchar(300) ;
						   DECLARE @NewDescription                nvarchar(4000);

                           declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
							                   @NewId_Status              = D.Id_Status              ,    
							                   @NewName                   = D.Name                   ,
							                   @NewSysTypeOrderStatusName = D.SysTypeOrderStatusName ,
							                   @NewDescription            = D.[Description]            
							            FROM inserted  D
							            where @ID_entity_D = D.Id_Status

							            SELECT 
							                   @OldId_Status              = D.Id_Status              ,
                                               @OldName                   = D.Name                   ,
                                               @OldSysTypeOrderStatusName = D.SysTypeOrderStatusName ,
                                               @OldDescription            = D.[Description]           
                                        FROM deleted D
										where @ID_entity_D = D.Id_Status
                         
                                        IF isnull(@NewName,'null') <> isnull(@OldName,'null') 
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							               end

                                        IF isnull(@NewSysTypeOrderStatusName,'null') <> isnull(@OldSysTypeOrderStatusName,'null')
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeOrderStatusName = Old ->"' + ISNULL(@OldSysTypeOrderStatusName,'') + ' " NEW -> "' + ISNULL(@NewSysTypeOrderStatusName,'') + '", ';
							               end

                                        IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                           end

                                        SET @ChangeDescription = 'Updated: ' + ' Id_Status = "' +  isnull(cast(@OldId_Status as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                             SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                        INSERT  INTO dbo.Orders_status_Audit
                                        ( 
                                         Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = ''

									end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
   					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;


							DECLARE @OldId_Status_2                  bigint        ;  
                            DECLARE @OldName_2                       nvarchar(300) ;
                            DECLARE @OldSysTypeOrderStatusName_2     nvarchar(300) ;
                            DECLARE @OldDescription_2                nvarchar(4000);
                            
                            declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								           set @ChangeDescription = ''

                                           SELECT 
							                      @OldId_Status_2               = D.Id_Status              ,
                                                  @OldName_2                    = D.Name                   ,
                                                  @OldSysTypeOrderStatusName_2  = D.SysTypeOrderStatusName ,
                                                  @OldDescription_2             = D.[Description]           
                                           FROM deleted D
										   where @ID_entity_D_2 = D.Id_Status


                                           SET @ChangeDescription = 'Deleted: '
                                           + 'Id_Status'              +' = "'+ isnull(CAST(@OldId_Status_2 AS NVARCHAR(50)),'') + '", '
                                           + 'Name'                   +' = "'+ ISNULL(@OldName_2, '') + '", '
                                           + 'SysTypeOrderStatusName' +' = "'+ ISNULL(@OldSysTypeOrderStatusName_2, '') + '", '
                                           + 'Description'            +' = "'+ ISNULL(@OldDescription_2, '') + '" ';

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                           
									      INSERT  INTO dbo.Orders_status_Audit
                                          ( 
                                           Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                          SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									      set @ChangeDescription = ''

								 end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2

                         
                END  
        END
    ELSE
        BEGIN
                    DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					
					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.Id_Status,@login_name,GETDATE(),'I'  
					FROM  inserted I

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
						   
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						begin
							begin try
							  set @ChangeDescription = ''

							  SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Country = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
  
		                      INSERT  INTO dbo.Orders_status_Audit
                              ( 
                               Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                              )
                               SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
							  set @ChangeDescription = ''
						   end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
                           close cr_3
                           deallocate cr_3         

                    END

GO


CREATE TABLE Passport_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Passport            bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Passport_Audit ON Passport
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Passport,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Passport,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


							DECLARE @OldID_Passport                bigint        ;
							DECLARE @OldNumber_Series              nvarchar(100) ;
							DECLARE @OldDate_Of_Issue              Datetime      ;
							DECLARE @OldDepartment_Code            nvarchar(20)  ;
							DECLARE @OldIssued_By_Whom             nvarchar(400) ;
							DECLARE @OldRegistration               nvarchar(200) ;
							DECLARE @OldMilitary_Duty              nvarchar(200) ;
							DECLARE @OldDescription                nvarchar(1000);

							DECLARE @NewID_Passport                bigint        ;
							DECLARE @NewNumber_Series              nvarchar(100) ;
							DECLARE @NewDate_Of_Issue              Datetime      ;
							DECLARE @NewDepartment_Code            nvarchar(20)  ;
							DECLARE @NewIssued_By_Whom             nvarchar(400) ;
							DECLARE @NewRegistration               nvarchar(200) ;
							DECLARE @NewMilitary_Duty              nvarchar(200) ;
							DECLARE @NewDescription                nvarchar(1000);



						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
                                              @NewID_Passport    = I.ID_Passport    ,
											  @NewNumber_Series  = I.Number_Series  ,
											  @NewDate_Of_Issue  = I.Date_Of_Issue  ,
											  @NewDepartment_Code= I.Department_Code,
											  @NewIssued_By_Whom = I.Issued_By_Whom ,
											  @NewRegistration   = I.Registration   ,
											  @NewMilitary_Duty  = I.Military_Duty  ,
											  @NewDescription    = I.[Description]      	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Passport;

                                        SELECT 
                                              @OldID_Passport    = D.ID_Passport    ,
											  @OldNumber_Series  = D.Number_Series  ,
											  @OldDate_Of_Issue  = D.Date_Of_Issue  ,
											  @OldDepartment_Code= D.Department_Code,
											  @OldIssued_By_Whom = D.Issued_By_Whom ,
											  @OldRegistration   = D.Registration   ,
											  @OldMilitary_Duty  = D.Military_Duty  ,
											  @OldDescription    = D.[Description]     							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Passport;

                                       
							           IF isnull(@NewNumber_Series,'null') <> isnull(@OldNumber_Series,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Number_Series = Old ->"' +  ISNULL(@OldNumber_Series,'') + ' " NEW -> " ' + isnull(@NewNumber_Series,'') + '", ';
							              end

							           IF ISNULL(CAST(Format(@NewDate_Of_Issue,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Of_Issue,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Issue = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Issue,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Issue,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

							           IF ISNULL(@NewDepartment_Code,'null') <> ISNULL(@OldDepartment_Code,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Code = Old ->"' +  ISNULL(@OldDepartment_Code,'') + ' " NEW -> " ' + isnull(@NewDepartment_Code,'') + '", ';
							              end

							           IF isnull(@NewIssued_By_Whom,'null') <> isnull(@OldIssued_By_Whom,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Issued_By_Whom = Old ->"' +  ISNULL(@OldIssued_By_Whom,'') + ' " NEW -> " ' + isnull(@NewIssued_By_Whom,'') + '", ';
							              end

							           IF isnull(@NewRegistration,'null') <> isnull(@OldRegistration,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Registration = Old ->"' +  ISNULL(@OldRegistration,'') + ' " NEW -> " ' + isnull(@NewRegistration,'') + '", ';
							              end

							           IF isnull(@NewMilitary_Duty,'null') <> isnull(@OldMilitary_Duty,'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Military_Duty = Old ->"' +  ISNULL(@OldMilitary_Duty,'') + ' " NEW -> " ' + isnull(@NewMilitary_Duty,'') + '", ';
							              end
     
                                       IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Passport = "' +  isnull(cast(@OldID_Passport as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Passport_Audit
                                        ( 
                                         ID_Passport,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Passport,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                            DECLARE @OldID_Passport_2                bigint        ;
							DECLARE @OldNumber_Series_2              nvarchar(100) ;
							DECLARE @OldDate_Of_Issue_2              Datetime      ;
							DECLARE @OldDepartment_Code_2            nvarchar(20)  ;
							DECLARE @OldIssued_By_Whom_2             nvarchar(400) ;
							DECLARE @OldRegistration_2               nvarchar(200) ;
							DECLARE @OldMilitary_Duty_2              nvarchar(200) ;
							DECLARE @OldDescription_2                nvarchar(1000);



							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
                                              @OldID_Passport_2     = D.ID_Passport    ,
											  @OldNumber_Series_2   = D.Number_Series  ,
											  @OldDate_Of_Issue_2   = D.Date_Of_Issue  ,
											  @OldDepartment_Code_2 = D.Department_Code,
											  @OldIssued_By_Whom_2  = D.Issued_By_Whom ,
											  @OldRegistration_2    = D.Registration   ,
											  @OldMilitary_Duty_2   = D.Military_Duty  ,
											  @OldDescription_2     = D.[Description]            
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_Passport;

                                            SET @ChangeDescription = 'Deleted: '
                                            + 'ID_Passport'     +' = "'+  ISNULL(CAST(@OldID_Passport_2     AS NVARCHAR(50)),'')     + '", '
							                + 'Number_Series'   +' = "'+  ISNULL(@OldNumber_Series_2,'')+ '", '				
							                + 'Date_Of_Issue'   +' = "'+  ISNULL(CAST(Format(@OldDate_Of_Issue_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Department_Code' +' = "'+  ISNULL(@OldDepartment_Code_2,'')+ '", '
							                + 'Issued_By_Whom'  +' = "'+  ISNULL(@OldIssued_By_Whom_2,'')+ '", '
							                + 'Registration'    +' = "'+  ISNULL(@OldRegistration_2,'')+ '", '
							                + 'Military_Duty'   +' = "'+  ISNULL(@OldMilitary_Duty_2,'')+ '", '
							                + 'Description'     +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Passport_Audit
                                           ( 
                                            ID_Passport,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Passport,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Passport = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Passport_Audit
                                       ( 
                                        ID_Passport,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO

CREATE TABLE Post_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Post                bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Post_Audit ON Post
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Post,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Post,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


							DECLARE @OldID_Post               bigint        ;
							DECLARE @OldName_Post             nvarchar(200) ;
							DECLARE @OldID_Department         bigint        ;
							DECLARE @OldID_Group              bigint        ;
							DECLARE @OldID_The_Subgroup       bigint        ;
							DECLARE @OldDescription           nvarchar(1000);

                            DECLARE @NewID_Post               bigint        ;
							DECLARE @NewName_Post             nvarchar(200) ;
							DECLARE @NewID_Department         bigint        ;
							DECLARE @NewID_Group              bigint        ;
							DECLARE @NewID_The_Subgroup       bigint        ;
							DECLARE @NewDescription           nvarchar(1000);


						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
                                              @NewID_Post         = I.ID_Post        , 
											  @NewName_Post       = I.Name_Post      , 
											  @NewID_Department   = I.ID_Department  , 
											  @NewID_Group        = I.ID_Group       , 
											  @NewID_The_Subgroup = I.ID_The_Subgroup, 
											  @NewDescription     = I.[Description]    
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Post;

                                        SELECT 
                                              @OldID_Post         = D.ID_Post        , 
											  @OldName_Post       = D.Name_Post      , 
											  @OldID_Department   = D.ID_Department  , 
											  @OldID_Group        = D.ID_Group       , 
											  @OldID_The_Subgroup = D.ID_The_Subgroup, 
											  @OldDescription     = D.[Description]         							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Post;


									   IF isnull(@NewName_Post,'null') <> isnull(@OldName_Post,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Post = Old ->"' +  ISNULL(@OldName_Post,'') + ' " NEW -> " ' + isnull(@NewName_Post,'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewID_Department AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Department = Old ->"' +  ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Department AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewID_Group AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Group = Old ->"' +  ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF ISNULL(CAST(@NewID_The_Subgroup AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_The_Subgroup AS NVARCHAR(50)),'null') 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end
			           
                                       IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Post = "' +  isnull(cast(@OldID_Post as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Post_Audit
                                        ( 
                                         ID_Post,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Post,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Post_2               bigint        ;
							DECLARE @OldName_Post_2             nvarchar(200) ;
							DECLARE @OldID_Department_2         bigint        ;
							DECLARE @OldID_Group_2              bigint        ;
							DECLARE @OldID_The_Subgroup_2       bigint        ;
							DECLARE @OldDescription_2           nvarchar(1000);



							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
                                                 @OldID_Post_2         = D.ID_Post        ,
												 @OldName_Post_2       = D.Name_Post      ,
												 @OldID_Department_2   = D.ID_Department  ,
												 @OldID_Group_2        = D.ID_Group       ,
												 @OldID_The_Subgroup_2 = D.ID_The_Subgroup,
												 @OldDescription_2     = D.[Description]   
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_Post;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Post'         +' = "'+  ISNULL(CAST(@OldID_Post_2     AS NVARCHAR(50)),'')     + '", '
							                + 'Name_Post'       +' = "'+  ISNULL(@OldName_Post_2,'')+ '", '	
							                + 'ID_Department'   +' = "'+  ISNULL(CAST(@OldID_Department_2  AS NVARCHAR(50)),'') + '", '
							                + 'ID_Group'        +' = "'+  ISNULL(CAST(@OldID_Group_2 AS NVARCHAR(50)),'') + '", '
                                            + 'ID_The_Subgroup' +' = "'+  ISNULL(CAST(@OldID_The_Subgroup_2 AS NVARCHAR(50)),'') + '", '
							                + 'Description'     +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Post_Audit
                                           ( 
                                            ID_Post,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Post,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Post = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Post_Audit
                                       ( 
                                        ID_Post,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Species_Item_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Species_Item          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Species_Item_Audit ON Species_Item
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Species_Item,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Species_Item,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      

						   DECLARE @OldID_Species_Item         bigint           ;
						   DECLARE @OldSpeciesItemName    	   nvarchar(300)  	;
						   DECLARE @OldSysSpeciesItemName 	   nvarchar(300) 	;
						   DECLARE @OldDescription      	   nvarchar(4000)	;


						   DECLARE @NewID_Species_Item          bigint          ;
						   DECLARE @NewSpeciesItemName    	 	nvarchar(300)  	;
						   DECLARE @NewSysSpeciesItemName 		nvarchar(300) 	;
						   DECLARE @NewDescription      	    nvarchar(4000)	;
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewID_Species_Item       = I.ID_Species_Item   ,
							                	  @NewSpeciesItemName    	= I.SpeciesItemName   ,
							                	  @NewSysSpeciesItemName 	= I.SysSpeciesItemName,
							                	  @NewDescription      	    = I.[Description]      	
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_Species_Item;	

							                SELECT 
                                                  @OldID_Species_Item       = D.ID_Species_Item   ,
							                	  @OldSpeciesItemName    	= D.SpeciesItemName   ,
							                	  @OldSysSpeciesItemName 	= D.SysSpeciesItemName,
							                	  @OldDescription      	    = D.[Description]      	
							                FROM Deleted D																		 
											 where @ID_entity_D = D.ID_Species_Item; 


                                            IF isnull(@NewSpeciesItemName,'null') <> isnull(@OldSpeciesItemName,'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SpeciesItemName = Old ->"' +  ISNULL(@OldSpeciesItemName,'') + ' " NEW -> " ' + isnull(@NewSpeciesItemName,'') + '", ';
							                   end
                                            
							                IF isnull(@NewSysSpeciesItemName,'null') <> isnull(@OldSysSpeciesItemName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysSpeciesItemName = Old ->"' +  ISNULL(@OldSysSpeciesItemName,'') + ' " NEW -> " ' + isnull(@NewSysSpeciesItemName,'') + '", ';
							                   end
                                                                                                    
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' ID_Species_Item = "' +  isnull(cast(@OldID_Species_Item as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Species_Item_Audit
                                            ( 
                                             ID_Species_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = ''

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Species_Item,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

						   DECLARE @OldID_Species_Item_2           bigint           ;
						   DECLARE @OldSpeciesItemName_2    	   nvarchar(300)  	;
						   DECLARE @OldSysSpeciesItemName_2 	   nvarchar(300) 	;
						   DECLARE @OldDescription_2      	       nvarchar(4000)	;

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
										      @OldID_Species_Item_2       = D.ID_Species_Item   ,
											  @OldSpeciesItemName_2    	  = D.SpeciesItemName   ,
											  @OldSysSpeciesItemName_2 	  = D.SysSpeciesItemName,
							               	  @OldDescription_2      	  = D.[Description]      		  
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.ID_Species_Item;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'ID_Species_Item'       +' = "'+  ISNULL(CAST(@OldID_Species_Item_2  AS NVARCHAR(50)),'')+ '", '
							               + 'SpeciesItemName'       +' = "'+  ISNULL(@OldSpeciesItemName_2,'')+ '", '
							               + 'SysSpeciesItemName'    +' = "'+  ISNULL(@OldSysSpeciesItemName_2,'')+ '", '
							               + '[Description]'         +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Species_Item_Audit
                                           ( 
                                            ID_Species_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.ID_Species_Item,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Species_Item = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Species_Item_Audit
                                      ( 
                                       ID_Species_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''             

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Status_Employee_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Status_Employee     bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_Status_Employee_Audit ON Status_Employee
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Status_Employee,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Status_Employee,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                            
							DECLARE @OldID_Status_Employee   bigint        ;
							DECLARE @OldName_Status_Employee nvarchar(100) ;
							DECLARE @OldDescription          nvarchar(1000);

							DECLARE @NewID_Status_Employee   bigint        ;
							DECLARE @NewName_Status_Employee nvarchar(100) ;
							DECLARE @NewDescription          nvarchar(1000);							

						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
                                             @NewID_Status_Employee   = I.ID_Status_Employee  ,
											 @NewName_Status_Employee = I.Name_Status_Employee,
											 @NewDescription          = I.[Description]         	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Status_Employee;

                                        SELECT 
 							                 @OldID_Status_Employee   = D.ID_Status_Employee  ,
											 @OldName_Status_Employee = D.Name_Status_Employee,
											 @OldDescription          = D.[Description]                  
							            FROM Deleted D
										where @ID_entity_D = D.ID_Status_Employee;




							           IF ISNULL(@NewName_Status_Employee,'null') <> ISNULL(@OldName_Status_Employee,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Status_Employee = Old ->"' +  ISNULL(@OldName_Status_Employee,'') + ' " NEW -> " ' + isnull(@NewName_Status_Employee,'') + '", ';
							              end
                                                                                               
                                       IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end

                                       SET @ChangeDescription = 'Updated: ' + ' ID_Status_Employee = "' +  isnull(cast(@OldID_Status_Employee as nvarchar(20)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Status_Employee_Audit
                                        ( 
                                         ID_Status_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Status_Employee,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Status_Employee_2   bigint        ;
							DECLARE @OldName_Status_Employee_2 nvarchar(100) ;
							DECLARE @OldDescription_2          nvarchar(1000);


							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
                                                    @OldID_Status_Employee_2   = D.ID_Status_Employee  ,
													@OldName_Status_Employee_2 = D.Name_Status_Employee,
													@OldDescription_2          = D.[Description]        
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_Status_Employee;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Status_Employee'  +' = "'+  ISNULL(CAST(@OldID_Status_Employee_2     AS NVARCHAR(50)),'')     + '", '
							                + 'Name_Status_Employee'+' = "'+  ISNULL(@OldName_Status_Employee_2,'')+ '", '				
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Status_Employee_Audit
                                           ( 
                                            ID_Status_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Status_Employee,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Status_Employee = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Status_Employee_Audit
                                       ( 
                                        ID_Status_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE Storage_location_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Storage_location       bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;

go

CREATE TRIGGER trg_Storage_location_Audit ON Storage_location
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                          declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Storage_location,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Storage_location,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
                           DECLARE @OldID_Storage_location        bigint         ;
						   DECLARE @OldID_Type_Storage_location   bigint         ;
						   DECLARE @OldId_Status                  bigint         ;
						   DECLARE @OldId_Country                 bigint         ;
						   DECLARE @OldKeySource                  bigint         ;
						   DECLARE @OldName                       nvarchar(400)  ;
						   DECLARE @OldCity                       nvarchar(200)  ;
						   DECLARE @OldAdress                     nvarchar(800)  ;
						   DECLARE @OldMail                       nvarchar(250)  ;
						   DECLARE @OldPhone                      nvarchar(30)   ;
						   DECLARE @OldDate_Created               datetime       ;
						   DECLARE @OldDescription                nvarchar(4000) ;

                           DECLARE @NewID_Storage_location        bigint         ;
						   DECLARE @NewID_Type_Storage_location   bigint         ;
						   DECLARE @NewId_Status                  bigint         ;
						   DECLARE @NewId_Country                 bigint         ;
						   DECLARE @NewKeySource                  bigint         ;
						   DECLARE @NewName                       nvarchar(400)  ;
						   DECLARE @NewCity                       nvarchar(200)  ;
						   DECLARE @NewAdress                     nvarchar(800)  ;
						   DECLARE @NewMail                       nvarchar(250)  ;
						   DECLARE @NewPhone                      nvarchar(30)   ;
						   DECLARE @NewDate_Created               datetime       ;
						   DECLARE @NewDescription                nvarchar(4000) ; 

						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

								        SELECT 
							                @NewID_Storage_location     	= I.ID_Storage_location     ,
							            	@NewID_Type_Storage_location	= I.ID_Type_Storage_location,
											@NewId_Status                   = I.Id_Status               ,
											@NewId_Country                  = I.Id_Country              ,
							            	@NewKeySource               	= I.KeySource               ,
							            	@NewName                    	= I.Name                    ,
							            	@NewCity                    	= I.City                    ,
							            	@NewAdress                  	= I.Adress                  ,
							            	@NewMail                    	= I.Mail                    ,
							            	@NewPhone                   	= I.Phone                   ,
							            	@NewDate_Created                = I.Date_Created            ,
							            	@NewDescription                 = I.[Description]        	  
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Storage_location;

						                SELECT 
							                @OldID_Storage_location     	= D.ID_Storage_location     ,
							            	@OldID_Type_Storage_location	= D.ID_Type_Storage_location,
											@OldId_Status                   = D.Id_Status               ,
											@OldId_Country                  = D.Id_Country              ,
							            	@OldKeySource               	= D.KeySource               ,
							            	@OldName                    	= D.Name                    ,
							            	@OldCity                    	= D.City                    ,
							            	@OldAdress                  	= D.Adress                  ,
							            	@OldMail                    	= D.Mail                    ,
							            	@OldPhone                   	= D.Phone                   ,
							            	@OldDate_Created                = D.Date_Created            ,
							            	@OldDescription                 = D.[Description]        	  					
							            FROM Deleted D	
										 where @ID_entity_D = D.ID_Storage_location
																	 

                                        IF ISNULL(CAST(@NewID_Type_Storage_location  AS NVARCHAR(50)),'null')  <> ISNULL(CAST(@OldID_Type_Storage_location  AS NVARCHAR(50)),'null')  
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Type_Storage_location  = Old ->"' +  ISNULL(CAST(@OldID_Type_Storage_location  AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Type_Storage_location  AS NVARCHAR(50)),'') + '", ';
							               end
                                        
										IF ISNULL(CAST(@NewId_Status  AS NVARCHAR(50)),'null')  <> ISNULL(CAST(@OldId_Status  AS NVARCHAR(50)),'null') 
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Status  = Old ->"' +  ISNULL(CAST(@OldId_Status  AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewId_Status  AS NVARCHAR(50)),'') + '", ';
							               end

										IF ISNULL(CAST(@NewId_Country  AS NVARCHAR(50)),'null')  <> ISNULL(CAST(@OldId_Country  AS NVARCHAR(50)),'null') 
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Country  = Old ->"' +  ISNULL(CAST(@OldId_Country  AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewId_Country  AS NVARCHAR(50)),'') + '", ';
							               end

							            IF ISNULL(CAST(@NewKeySource AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldKeySource AS NVARCHAR(50)),'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  KeySource = Old ->"' +  ISNULL(CAST(@OldKeySource AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewKeySource AS NVARCHAR(50)),'') + '", ';
							               end
							            
							            IF isnull(@NewName,'null') <> isnull(@OldName,'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> "' + isnull(@NewName,'') + '", ';
							               end                  							            
							            
							            IF isnull(@NewCity,'null') <> isnull(@OldCity,'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  City = Old ->"' +  ISNULL(@OldCity,'') + ' " NEW -> "' + isnull(@NewCity,'') + '", ';
							               end
							            
							            IF isnull(@NewAdress,'null') <> isnull(@OldAdress,'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Adress = Old ->"' +  ISNULL(@OldAdress,'') + ' " NEW -> "' + isnull(@NewAdress,'') + '", ';
							               end
							            
							            IF isnull(@NewMail,'null') <> isnull(@OldMail,'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> "' + isnull(@NewMail,'') + '", ';
							               end
							            
                                        IF isnull(@NewPhone,'null') <> isnull(@OldPhone,'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> "' + isnull(@NewPhone,'') + '", ';
							               end
							            
                                        IF ISNULL(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Created = Old ->"' +  ISNULL(CAST(Format(@OldDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Created,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
							            
                                        IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                           end
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Storage_location = "' +  isnull(cast(@OldID_Storage_location as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                         INSERT  INTO dbo.Storage_location_Audit
                                         ( 
                                          ID_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                           SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									     set @ChangeDescription = '' 
							 end try
							 begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                                        				
                END
            ELSE
                BEGIN
                           declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Storage_location,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Storage_location_2        bigint         ;
							DECLARE @OldID_Type_Storage_location_2   bigint         ;
							DECLARE @OldId_Status_2                  bigint         ;
							DECLARE @OldId_Country_2                 bigint         ;
							DECLARE @OldKeySource_2                  bigint         ;
							DECLARE @OldName_2                       nvarchar(400)  ;
							DECLARE @OldCity_2                       nvarchar(200)  ;
							DECLARE @OldAdress_2                     nvarchar(800)  ;
							DECLARE @OldMail_2                       nvarchar(250)  ;
							DECLARE @OldPhone_2                      nvarchar(30)   ;
							DECLARE @OldDate_Created_2               datetime       ;
							DECLARE @OldDescription_2                nvarchar(4000) ;

							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						   
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try  
									            set @ChangeDescription = ''

                                                SELECT 
							                        @OldID_Storage_location_2         = D.ID_Storage_location     ,
							                    	@OldID_Type_Storage_location_2	  = D.ID_Type_Storage_location,
													@OldId_Status_2                   = D.Id_Status               ,
													@OldId_Country_2                  = D.Id_Country              ,
							                    	@OldKeySource_2               	  = D.KeySource               ,
							                    	@OldName_2                    	  = D.Name                    ,
							                    	@OldCity_2                    	  = D.City                    ,
							                    	@OldAdress_2                  	  = D.Adress                  ,
							                    	@OldMail_2                    	  = D.Mail                    ,
							                    	@OldPhone_2                   	  = D.Phone                   ,
							                    	@OldDate_Created_2                = D.Date_Created            ,
							                    	@OldDescription_2                 = D.[Description]        
							                    FROM deleted D	
												where @ID_entity_D_2 = D.ID_Storage_location

                                                SET @ChangeDescription = 'Deleted: '
							                    + 'ID_Storage_location'      +' = "'+  ISNULL(CAST(@OldID_Storage_location_2     AS NVARCHAR(50)),'')+ '", '
							                    + 'ID_Type_Storage_location' +' = "'+  ISNULL(CAST(@OldID_Type_Storage_location_2  AS NVARCHAR(50)),'')+ '", '
												+ 'Id_Status'                +' = "'+  ISNULL(CAST(@OldId_Status_2  AS NVARCHAR(50)),'')+ '", '
												+ 'Id_Country'               +' = "'+  ISNULL(CAST(@OldId_Country_2  AS NVARCHAR(50)),'')+ '", '
							                    + 'KeySource'                +' = "'+  ISNULL(CAST(@OldKeySource_2 AS NVARCHAR(50)),'') + '", '
							                    + 'Name'                     +' = "'+  ISNULL(@OldName_2,'')+ '", '				
							                    + 'City'                     +' = "'+  ISNULL(@OldCity_2,'') + '", '
							                    + 'Adress'                   +' = "'+  ISNULL(@OldAdress_2,'')+ '", '
							                    + 'Mail'                     +' = "'+  ISNULL(@OldMail_2,'') + '", '
							                    + 'Phone'                    +' = "'+  ISNULL(@OldPhone_2,'')+ '", '
							                    + 'Date_Created'             +' = "'+  ISNULL(CAST(Format(@OldDate_Created_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
            				                    + 'Description'              +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

							                    IF LEN(@ChangeDescription) > 0
                                                        SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                                INSERT  INTO dbo.Storage_location_Audit
                                                ( 
                                                 ID_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                                )
                                                 SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									            set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Storage_location,@login_name,GETDATE(),'I'  
					FROM  inserted I


					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							     begin try
								     set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                            + 'ID_Storage_location = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                      
                                     INSERT  INTO dbo.Storage_location_Audit
                                     ( 
                                      ID_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''
                                
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE Storage_location_status_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Status              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Storage_location_status_Audit ON Storage_location_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                                          	                      
                           DECLARE @OldId_Status                  bigint        ;
						   DECLARE @OldTypeStoragelocationName    nvarchar(300)	;
						   DECLARE @OldSysTypeStoragelocationName nvarchar(300)	;
						   DECLARE @OldDescription                nvarchar(4000);

                           DECLARE @NewId_Status                  bigint        ;
						   DECLARE @NewTypeStoragelocationName    nvarchar(300)	;
						   DECLARE @NewSysTypeStoragelocationName nvarchar(300)	;
						   DECLARE @NewDescription                nvarchar(4000);
                       
					       declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								            set @ChangeDescription = ''

							                SELECT 
                                                  @NewId_Status                  = I.Id_Status                 ,
												  @NewTypeStoragelocationName    = I.TypeStoragelocationName   ,
												  @NewSysTypeStoragelocationName = I.SysTypeStoragelocationName,            
												  @NewDescription                = I.[Description]      	  
							                FROM inserted I									 
							                where @ID_entity_D = I.Id_Status;	

							                SELECT   
                                                  @OldId_Status                  = D.Id_Status                 ,
												  @OldTypeStoragelocationName    = D.TypeStoragelocationName   ,
												  @OldSysTypeStoragelocationName = D.SysTypeStoragelocationName,            
												  @OldDescription                = D.[Description]      		  
							                FROM Deleted D																		 
											 where @ID_entity_D = D.Id_Status; 


                                            IF ISNULL(@NewTypeStoragelocationName,'null') <> ISNULL(@OldTypeStoragelocationName,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeStoragelocationName = Old ->"' +  ISNULL(@OldTypeStoragelocationName,'') + ' " NEW -> " ' + isnull(@NewTypeStoragelocationName,'') + '", ';
							                   end
                                            
							                IF ISNULL(@NewSysTypeStoragelocationName,'null') <> ISNULL(@OldSysTypeStoragelocationName,'null') 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeStoragelocationName = Old ->"' +  ISNULL(@OldSysTypeStoragelocationName,'') + ' " NEW -> " ' + isnull(@NewSysTypeStoragelocationName,'') + '", ';
							                   end
                                                                                                    
                                            IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Status = "' +  isnull(cast(@OldId_Status as nvarchar(20)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Storage_location_status_Audit
                                            ( 
                                             Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 

								   end try
								   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr                               					
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

					        insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_Status,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                           DECLARE @OldId_Status_2                  bigint        ;
						   DECLARE @OldTypeStoragelocationName_2    nvarchar(300)	;
						   DECLARE @OldSysTypeStoragelocationName_2 nvarchar(300)	;
						   DECLARE @OldDescription_2                nvarchar(4000);

                            declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						        begin
							       begin try
								           set @ChangeDescription = ''

							               SELECT 
                                                  @OldId_Status_2                  = D.Id_Status                 ,
												  @OldTypeStoragelocationName_2    = D.TypeStoragelocationName   ,
												  @OldSysTypeStoragelocationName_2 = D.SysTypeStoragelocationName,            
												  @OldDescription_2                = D.[Description]        	
							               FROM deleted D									 
										   where @ID_entity_D_2 = D.Id_Status;

                                           SET @ChangeDescription = 'Deleted: '
							               + 'Id_Status'                  +' = "'+  ISNULL(CAST(@OldId_Status_2  AS NVARCHAR(50)),'')+ '", '
							               + 'TypeStoragelocationName'    +' = "'+  ISNULL(@OldTypeStoragelocationName_2,'')+ '", '
							               + 'SysTypeStoragelocationName' +' = "'+  ISNULL(@OldSysTypeStoragelocationName_2,'')+ '", '
							               + '[Description]'              +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                                           IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Storage_location_status_Audit
                                           ( 
                                            Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2


                END  
        END
    ELSE
        BEGIN
		           declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );


				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.Id_Status,@login_name,GETDATE(),'I'  
				   FROM  inserted I

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;
		 
		           declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						  begin
							   begin try
							         set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Status = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                      INSERT  INTO dbo.Storage_location_status_Audit
                                      ( 
                                       Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = ''             

								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE The_Subgroup_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_The_Subgroup        bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group;


go

CREATE TRIGGER trg_The_Subgroup_Audit ON The_Subgroup
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           	declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_The_Subgroup,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_The_Subgroup,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


							DECLARE @OldID_The_Subgroup            bigint        ;
							DECLARE @OldID_Head_The_Subgroup       bigint        ;
							DECLARE @OldID_Vice_Head_The_Subgroup  bigint        ;
							DECLARE @OldID_Group                   bigint        ;
							DECLARE @OldName_The_Subgroup          nvarchar(300) ;
							DECLARE @OldID_Branch                  bigint        ;
							DECLARE @OldDepartment_Code            int           ;
							DECLARE @OldDescription                nvarchar(1000);
							DECLARE @OldID_Parent_The_Subgroup     bigint        ;


							DECLARE @NewID_The_Subgroup            bigint        ;
							DECLARE @NewID_Head_The_Subgroup       bigint        ;
							DECLARE @NewID_Vice_Head_The_Subgroup  bigint        ;
							DECLARE @NewID_Group                   bigint        ;
							DECLARE @NewName_The_Subgroup          nvarchar(300) ;
							DECLARE @NewID_Branch                  bigint        ;
							DECLARE @NewDepartment_Code            int           ;
							DECLARE @NewDescription                nvarchar(1000);
							DECLARE @NewID_Parent_The_Subgroup     bigint        ;
							


						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

							            SELECT 
										     @NewID_The_Subgroup           = I.ID_The_Subgroup          ,
											 @NewID_Head_The_Subgroup      = I.ID_Head_The_Subgroup     ,
											 @NewID_Vice_Head_The_Subgroup = I.ID_Vice_Head_The_Subgroup,
											 @NewID_Group                  = I.ID_Group                 ,
											 @NewName_The_Subgroup         = I.Name_The_Subgroup        ,
											 @NewID_Branch                 = I.ID_Branch                ,
											 @NewDepartment_Code           = I.Department_Code          ,
											 @NewDescription               = I.[Description]            ,
											 @NewID_Parent_The_Subgroup    = I.ID_Parent_The_Subgroup   
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_The_Subgroup;								        

                                        SELECT 
										     @OldID_The_Subgroup           = D.ID_The_Subgroup          ,
											 @OldID_Head_The_Subgroup      = D.ID_Head_The_Subgroup     ,
											 @OldID_Vice_Head_The_Subgroup = D.ID_Vice_Head_The_Subgroup,
											 @OldID_Group                  = D.ID_Group                 ,
											 @OldName_The_Subgroup         = D.Name_The_Subgroup        ,
											 @OldID_Branch                 = D.ID_Branch                ,
											 @OldDepartment_Code           = D.Department_Code          ,
											 @OldDescription               = D.[Description]            ,
											 @OldID_Parent_The_Subgroup    = D.ID_Parent_The_Subgroup   
							            FROM Deleted D
										where @ID_entity_D = D.ID_The_Subgroup;

                                       
							           IF ISNULL(CAST(@NewID_Head_The_Subgroup AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Head_The_Subgroup AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Head_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_Head_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Head_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end

							           IF ISNULL(CAST(@NewID_Vice_Head_The_Subgroup AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Vice_Head_The_Subgroup AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Vice_Head_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_Vice_Head_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Vice_Head_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end

							           IF ISNULL(CAST(@NewID_Group AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Group = Old ->"' +  ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Group AS NVARCHAR(50)),'') + '", ';
							              end

							           IF ISNULL(@NewName_The_Subgroup,'null') <> ISNULL(@OldName_The_Subgroup,'null') 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_The_Subgroup = Old ->"' +  ISNULL(@OldName_The_Subgroup,'') + ' " NEW -> " ' + isnull(@NewName_The_Subgroup,'') + '", ';
							              end
                                        
									   IF ISNULL(CAST(@NewID_Branch AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

									   IF ISNULL(CAST(@NewDepartment_Code AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldDepartment_Code AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Code = Old ->"' +  ISNULL(CAST(@OldDepartment_Code AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewDepartment_Code AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end

									   IF ISNULL(CAST(@NewID_Parent_The_Subgroup AS NVARCHAR(50)),'null') <> ISNULL(CAST(@OldID_Parent_The_Subgroup AS NVARCHAR(50)),'null')
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Parent_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_Parent_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Parent_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end


                                       SET @ChangeDescription = 'Updated: ' + ' ID_The_Subgroup = "' +  isnull(cast(@OldID_The_Subgroup as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.The_Subgroup_Audit
                                        ( 
                                         ID_The_Subgroup,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr

  					
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

                            insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_The_Subgroup,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_The_Subgroup_2            bigint        ;
							DECLARE @OldID_Head_The_Subgroup_2       bigint        ;
							DECLARE @OldID_Vice_Head_The_Subgroup_2  bigint        ;
							DECLARE @OldID_Group_2                   bigint        ;
							DECLARE @OldName_The_Subgroup_2          nvarchar(300) ;
							DECLARE @OldID_Branch_2                  bigint        ;
							DECLARE @OldDepartment_Code_2            int           ;
							DECLARE @OldDescription_2                nvarchar(1000);
							DECLARE @OldID_Parent_The_Subgroup_2     bigint        ;



							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
										              @OldID_The_Subgroup_2           = D.ID_The_Subgroup          ,
											          @OldID_Head_The_Subgroup_2      = D.ID_Head_The_Subgroup     ,
											          @OldID_Vice_Head_The_Subgroup_2 = D.ID_Vice_Head_The_Subgroup,
											          @OldID_Group_2                  = D.ID_Group                 ,
											          @OldName_The_Subgroup_2         = D.Name_The_Subgroup        ,
											          @OldID_Branch_2                 = D.ID_Branch                ,
											          @OldDepartment_Code_2           = D.Department_Code          ,
											          @OldDescription_2               = D.[Description]            ,
											          @OldID_Parent_The_Subgroup_2    = D.ID_Parent_The_Subgroup           
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_The_Subgroup;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_The_Subgroup'            +' = "'+  ISNULL(CAST(@OldID_The_Subgroup_2     AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Head_The_Subgroup'       +' = "'+  ISNULL(CAST(@OldID_Head_The_Subgroup_2  AS NVARCHAR(50)),'') + '", '
							                + 'ID_Vice_Head_The_Subgroup'  +' = "'+  ISNULL(CAST(@OldID_Vice_Head_The_Subgroup_2 AS NVARCHAR(50)),'') + '", '
											+ 'ID_Group'                   +' = "'+  ISNULL(CAST(@OldID_Group_2 AS NVARCHAR(50)),'') + '", '
							                + 'Name_The_Subgroup'          +' = "'+  ISNULL(@OldName_The_Subgroup_2,'')+ '", '
											+ 'ID_Branch'                  +' = "'+  ISNULL(CAST(@OldID_Branch_2 AS NVARCHAR(50)),'') + '", '
											+ 'Department_Code'            +' = "'+  ISNULL(CAST(@OldDepartment_Code_2 AS NVARCHAR(50)),'') + '", '											
											+ 'Description'                +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '
											+ 'ID_Parent_The_Subgroup'     +' = "'+  ISNULL(CAST(@OldID_Parent_The_Subgroup_2 AS NVARCHAR(50)),'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.The_Subgroup_Audit
                                           ( 
                                            ID_The_Subgroup,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);


					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_The_Subgroup,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

                    declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							   begin try
							           set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_The_Subgroup = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.The_Subgroup_Audit
                                       ( 
                                        ID_The_Subgroup,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
           
		                       end try
							   begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
                    END

GO


CREATE TABLE TRANSACTION_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Transaction         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)         null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Transaction_Audit ON [dbo].[Transaction]
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Transaction,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Transaction,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;


                           
                            DECLARE @OldID_Transaction                  bigint          ;
							DECLARE @OldID_Currency                     bigint       	;
							DECLARE @OldID_Transaction_status           bigint       	;
							DECLARE @OldID_Currency_Rate                bigint       	;
							DECLARE @OldTransaction_Date                datetime     	;
							DECLARE @OldKeySource                       bigint       	;
							DECLARE @OldTransaction_name_sender         nvarchar(500)	;
							DECLARE @OldJSON_Transaction_sender         nvarchar(max)	;
							DECLARE @OldTransaction_Amount              decimal(10,2)   ;
							DECLARE @OldDescription                     nvarchar(4000)	;

							DECLARE @NewID_Transaction                  bigint          ;
							DECLARE @NewID_Currency                     bigint       	;
							DECLARE @NewID_Transaction_status           bigint       	;
							DECLARE @NewID_Currency_Rate                bigint       	;
							DECLARE @NewTransaction_Date                datetime     	;
							DECLARE @NewKeySource                       bigint       	;
							DECLARE @NewTransaction_name_sender         nvarchar(500)	;
							DECLARE @NewJSON_Transaction_sender         nvarchar(max)	;
							DECLARE @NewTransaction_Amount              decimal(10,2)   ;
							DECLARE @NewDescription                     nvarchar(4000)	;
                            

							declare cr cursor local fast_forward for
						   
						    select 
						    ID_entity    
						    ,login_name   
						    ,ModifiedDate 
						    ,Name_action  
						    from @t_U_D 
                            open cr       
						    
						    fetch next from cr into 
						    @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						    while @@FETCH_STATUS  = 0
						          begin
							          begin try	
									        set @ChangeDescription = ''

											SELECT  
                                                  @NewID_Transaction          = I.ID_Transaction          ,
							                	  @NewID_Currency             = I.ID_Currency            	,
							                	  @NewID_Transaction_status   = I.ID_Transaction_status  	,
							                	  @NewID_Currency_Rate        = I.ID_Currency_Rate       	,
							                	  @NewTransaction_Date        = I.Transaction_Date       	,
							                	  @NewKeySource               = I.KeySource              	,
							                	  @NewTransaction_name_sender = I.Transaction_name_sender	,
							                	  @NewJSON_Transaction_sender = I.JSON_Transaction_sender	,
							                	  @NewTransaction_Amount      = I.Transaction_Amount     	,
							                	  @NewDescription             = I.[Description]                      
							                FROM inserted I
											where @ID_entity_D = I.ID_Transaction;									  
							                
							                SELECT  
                                                  @OldID_Transaction          = D.ID_Transaction          ,
							                	  @OldID_Currency             = D.ID_Currency            	,
							                	  @OldID_Transaction_status   = D.ID_Transaction_status  	,
							                	  @OldID_Currency_Rate        = D.ID_Currency_Rate       	,
							                	  @OldTransaction_Date        = D.Transaction_Date       	,
							                	  @OldKeySource               = D.KeySource              	,
							                	  @OldTransaction_name_sender = D.Transaction_name_sender	,
							                	  @OldJSON_Transaction_sender = D.JSON_Transaction_sender	,
							                	  @OldTransaction_Amount      = D.Transaction_Amount     	,
							                	  @OldDescription             = D.[Description]                           
							                FROM Deleted D
											where @ID_entity_D = D.ID_Transaction; 	


                                            IF ISNULL(cast(@NewID_Currency as nvarchar(50)),'null') <> ISNULL(cast(@OldID_Currency as nvarchar(50)),'null') 
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(cast(@OldID_Currency as nvarchar(50)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Currency as nvarchar(50)),'') + '", ';
							                   end
                                            
							                IF ISNULL(cast(@NewID_Transaction_status as nvarchar(50)),'null') <> ISNULL(cast(@OldID_Transaction_status as nvarchar(50)),'null') 
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Transaction_status = Old ->"' +  ISNULL(cast(@OldID_Transaction_status as nvarchar(50)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Transaction_status as nvarchar(50)),'') + '", ';
							                   end
                                            
							                IF ISNULL(cast(@NewID_Currency_Rate as nvarchar(50)),'null') <> ISNULL(cast(@OldID_Currency_Rate as nvarchar(50)),'null') 
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency_Rate = Old ->"' +  ISNULL(cast(@OldID_Currency_Rate as nvarchar(50)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Currency_Rate as nvarchar(50)),'') + '", ';
							                   end
                                            
							                IF ISNULL(CAST(Format(@NewTransaction_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null') <> ISNULL(CAST(Format(@OldTransaction_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'null')
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Transaction_Date = Old ->"' +  ISNULL(CAST(Format(@OldTransaction_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewTransaction_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
							                
							                IF ISNULL(cast(@NewKeySource as nvarchar(100)),'null') <> ISNULL(cast(@OldKeySource as nvarchar(100)),'null')
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  KeySource = Old ->"' +  ISNULL(cast(@OldKeySource as nvarchar(100)),'') + ' " NEW -> " ' + isnull(cast(@NewKeySource as nvarchar(100)),'') + '", ';
							                   end
							                
							                IF ISNULL(@NewTransaction_name_sender,'null') <> ISNULL(@OldTransaction_name_sender,'null')
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Transaction_name_sender = Old ->"' +  ISNULL(@OldTransaction_name_sender,'') + ' " NEW -> " ' + isnull(@NewTransaction_name_sender,'') + '", ';
							                   end  																	   			
							                
							                IF ISNULL(cast(@NewJSON_Transaction_sender as nvarchar(max)),'null') <> ISNULL(cast(@OldJSON_Transaction_sender as nvarchar(max)),'null')
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  JSON_Transaction_sender = Old ->"' +  ISNULL(cast(@OldJSON_Transaction_sender as nvarchar(max)),'') + ' " NEW -> " ' + isnull(cast(@NewJSON_Transaction_sender as nvarchar(max)),'') + '", ';
							                   end
							                
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_Transaction = "' +  isnull(cast(@OldID_Transaction as nvarchar(20)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                            INSERT  INTO dbo.TRANSACTION_Audit
                                            ( 
                                             ID_Transaction,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                              SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
  					
                END
            ELSE
                BEGIN
				           declare @t_D_D table 
						   (
						   Id_Num         bigint        identity(1,1) not null,
						   ID_entity      bigint        null,
						   login_name     nvarchar(128) null,
						   ModifiedDate   DATETIME      null,
						   Name_action    char(1)       null
						   );


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Transaction,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;


                            DECLARE @OldID_Transaction_2                  bigint          ;
							DECLARE @OldID_Currency_2                     bigint       	  ;
							DECLARE @OldID_Transaction_status_2           bigint       	  ;
							DECLARE @OldID_Currency_Rate_2                bigint       	  ;
							DECLARE @OldTransaction_Date_2                datetime     	  ;
							DECLARE @OldKeySource_2                       bigint       	  ;
							DECLARE @OldTransaction_name_sender_2         nvarchar(500)	  ;
							DECLARE @OldJSON_Transaction_sender_2         nvarchar(max)	  ;
							DECLARE @OldTransaction_Amount_2              decimal(10,2)   ;
							DECLARE @OldDescription_2                     nvarchar(4000)  ;
                            
							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT
                                                  @OldID_Transaction_2          = D.ID_Transaction          ,
							                	  @OldID_Currency_2             = D.ID_Currency             ,
							                	  @OldID_Transaction_status_2   = D.ID_Transaction_status   ,
							                	  @OldID_Currency_Rate_2        = D.ID_Currency_Rate        ,
							                	  @OldTransaction_Date_2        = D.Transaction_Date        ,
							                	  @OldKeySource_2               = D.KeySource               ,
							                	  @OldTransaction_name_sender_2 = D.Transaction_name_sender ,
							                	  @OldJSON_Transaction_sender_2 = D.JSON_Transaction_sender ,
							                	  @OldTransaction_Amount_2      = D.Transaction_Amount      ,
							                	  @OldDescription_2             = D.[Description]           
							                FROM deleted D	
											where @ID_entity_D_2 = D.ID_Transaction;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Transaction'           +' = "'+  ISNULL(CAST(@OldID_Transaction_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Currency'              +' = "'+  ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Transaction_status'    +' = "'+  ISNULL(CAST(@OldID_Transaction_status_2 AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Currency_Rate'         +' = "'+  ISNULL(CAST(@OldID_Currency_Rate_2 AS NVARCHAR(50)),'')     + '", '
							                + 'Transaction_Date'         +' = "'+  ISNULL(CAST(Format(@OldTransaction_Date_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'KeySource'                +' = "'+  ISNULL(cast(@OldKeySource_2 as nvarchar(100)),'') + '", ' 
							                + 'Transaction_name_sender'  +' = "'+  ISNULL(@OldTransaction_name_sender_2,'')+ '", ' 
							                + 'JSON_Currency_Rate_Data'  +' = "'+  ISNULL(@OldJSON_Transaction_sender_2,'')+ '", '
							                + 'Transaction_Amount      ' +' = "'+  ISNULL(cast(@OldTransaction_Amount_2 as nvarchar(50)),'')+ '", '		
							                + 'Description'              +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
                                                   SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
										   INSERT  INTO dbo.TRANSACTION_Audit
                                           ( 
                                            ID_Transaction,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END   
        END
    ELSE
        BEGIN
		            declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

                    insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Transaction,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
					DECLARE @login_name_2_I_2 nvarchar(128);
					DECLARE @ModifiedDate_I_2 DATETIME     ;
					DECLARE @Name_action_I_2  char(1)      ;

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						    begin
							      begin try
								       set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                            + 'ID_Transaction = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                        
									   INSERT  INTO dbo.TRANSACTION_Audit
                                       ( 
                                        ID_Transaction,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									    set @ChangeDescription = ''
                                 end try
								 begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3          

                    END

GO


CREATE TABLE Transaction_status_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Transaction_status  bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Transaction_status_Audit ON Transaction_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
				            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Transaction_status,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Transaction_status,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;

                           
	                        DECLARE @OldID_Transaction_status      bigint           ;
						    DECLARE @OldTypeTransactionName        nvarchar(300)	;
						    DECLARE @OldSysTypeTransactionName     nvarchar(300)	;
	                        DECLARE @OldDescription                nvarchar(4000)	;

		                    DECLARE @NewID_Transaction_status      bigint           ;
							DECLARE @NewTypeTransactionName        nvarchar(300)	;
							DECLARE @NewSysTypeTransactionName     nvarchar(300)	;
							DECLARE @NewDescription                nvarchar(4000)	;

							declare cr cursor local fast_forward for
						   
						    select 
						    ID_entity    
						    ,login_name   
						    ,ModifiedDate 
						    ,Name_action  
						    from @t_U_D 
                            open cr       
						    
						    fetch next from cr into 
						    @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

							                SELECT  
							                     @NewID_Transaction_status    = I.ID_Transaction_status , 
							                	 @NewTypeTransactionName      = I.TypeTransactionName   ,
							                	 @NewSysTypeTransactionName   = I.SysTypeTransactionName,
							                	 @NewDescription              = I.[Description]           
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_Transaction_status;

                                            SELECT  
							                     @OldID_Transaction_status    = D.ID_Transaction_status ,
							                	 @OldTypeTransactionName      = D.TypeTransactionName   ,
							                	 @OldSysTypeTransactionName   = D.SysTypeTransactionName,
							                	 @OldDescription              = D.[Description]          
							                FROM Deleted D
											where @ID_entity_D = D.ID_Transaction_status;


                                            IF ISNULL(@NewTypeTransactionName,'null') <> ISNULL(@OldTypeTransactionName,'null') 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeTransactionName = Old ->"' +  ISNULL(@OldTypeTransactionName,'') + ' " NEW -> " ' + isnull(@NewTypeTransactionName,'') + '", ';
							                   end
                                            
							                IF ISNULL(@NewSysTypeTransactionName,'null') <> ISNULL(@OldSysTypeTransactionName,'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeTransactionName = Old ->"' +  ISNULL(@OldTypeTransactionName,'') + ' " NEW -> " ' + isnull(@NewTypeTransactionName,'') + '", ';
							                   end
							                
                                            IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_Transaction_status = "' +  isnull(cast(@OldID_Transaction_status as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
											INSERT  INTO dbo.Transaction_status_Audit
                                            ( 
                                             ID_Transaction_status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                              SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 
                            		end try
								    begin catch
								       if xact_state() in (1, -1)
									        begin
									           ROLLBACK TRAN
									        end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Transaction_status,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_Transaction_status_2      bigint         ;
							DECLARE @OldTypeTransactionName_2        nvarchar(300)	;
							DECLARE @OldSysTypeTransactionName_2     nvarchar(300)	;
							DECLARE @OldDescription_2                nvarchar(4000)	;


							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						    
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									        set @ChangeDescription = ''

                                            SELECT 
							                    @OldID_Transaction_status_2   = D.ID_Transaction_status  ,
							                	@OldTypeTransactionName_2     = D.TypeTransactionName    ,
							                	@OldSysTypeTransactionName_2  = D.SysTypeTransactionName ,
							                	@OldDescription_2             = D.[Description]        
							                FROM deleted D	
											where @ID_entity_D_2 = D.ID_Transaction_status 

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Transaction_status'    +' = "'+  ISNULL(CAST(@OldID_Transaction_status_2 AS NVARCHAR(50)),'')     + '", '
							                + 'TypeTransactionName'      +' = "'+  ISNULL(@OldTypeTransactionName_2,'')+ '", '				
							                + 'SysTypeTransactionName'   +' = "'+  ISNULL(@OldSysTypeTransactionName_2,'')+ '", '
							                + 'Description'              +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '
						  
						                   IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                           
										   INSERT  INTO dbo.Transaction_status_Audit
                                           ( 
                                            ID_Transaction_status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = ''
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN

                   	declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_Transaction_status,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
					DECLARE @login_name_2_I_2 nvarchar(128);
					DECLARE @ModifiedDate_I_2 DATETIME     ;
					DECLARE @Name_action_I_2  char(1)      ;

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						   begin
							      begin try
								            set @ChangeDescription = ''

                                            SET @ChangeDescription = 'Inserted: '
                                                    + 'ID_Transaction_status = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                            INSERT  INTO dbo.Transaction_status_Audit
                                            ( 
                                             ID_Transaction_status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                             SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									        set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE Type_of_product_measurement_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_product_measurement bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Type_of_product_measurement_Audit ON Type_of_product_measurement
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                           declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_product_measurement,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_product_measurement,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
						   DECLARE @OldID_product_measurement      bigint        ; 
						   DECLARE @OldProduct_measurement_Name    nvarchar(300) ;
						   DECLARE @OldSysProductMeasurementName   nvarchar(300) ;
	                       DECLARE @OldDescription                 nvarchar(4000);

                           DECLARE @NewID_product_measurement      bigint        ;
						   DECLARE @NewProduct_measurement_Name    nvarchar(300) ;
						   DECLARE @NewSysProductMeasurementName   nvarchar(300) ;
						   DECLARE @NewDescription                 nvarchar(4000);

						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							        begin try
									        set @ChangeDescription = ''

							                SELECT 
							                        @NewID_product_measurement     =  I.ID_product_measurement   ,
							                		@NewProduct_measurement_Name   =  I.Product_measurement_Name ,
							                		@NewSysProductMeasurementName  =  I.SysProductMeasurementName,
							                		@NewDescription                =  I.[Description]         	
							                FROM inserted I
											where @ID_entity_D = I.ID_product_measurement

                                            SELECT 
                                                    @OldID_product_measurement     =  D.ID_product_measurement   ,
							                		@OldProduct_measurement_Name   =  D.Product_measurement_Name ,
							                		@OldSysProductMeasurementName  =  D.SysProductMeasurementName,
							                		@OldDescription                =  D.[Description]         								
							                FROM Deleted D
											where @ID_entity_D = D.ID_product_measurement;

;
							                																		 
                                            IF ISNULL(CAST(@NewProduct_measurement_Name AS NVARCHAR(300)),'null') <> ISNULL(CAST(@OldProduct_measurement_Name AS NVARCHAR(300)),'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Product_measurement_Name = Old ->"' +  ISNULL(CAST(@OldProduct_measurement_Name AS NVARCHAR(300)),'') + ' " NEW -> " ' + isnull(CAST(@NewProduct_measurement_Name AS NVARCHAR(300)),'') + '", ';
							                   end
                                            
							                IF ISNULL(CAST(@NewSysProductMeasurementName AS NVARCHAR(300)),'null') <> ISNULL(CAST(@OldSysProductMeasurementName AS NVARCHAR(300)),'null')
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysProductMeasurementName = Old ->"' +  ISNULL(CAST(@OldSysProductMeasurementName AS NVARCHAR(300)),'') + ' " NEW -> " ' + isnull(CAST(@NewSysProductMeasurementName AS NVARCHAR(300)),'') + '", ';
							                   end
							                
                                            IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_product_measurement = "' +  isnull(cast(@OldID_product_measurement as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'') + '"'
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                            INSERT  INTO dbo.Type_of_product_measurement_Audit
                                            ( 
                                             ID_product_measurement,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                              SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = ''
								 end try
								 begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
				           declare @t_D_D table 
						   (
						   Id_Num         bigint        identity(1,1) not null,
						   ID_entity      bigint        null,
						   login_name     nvarchar(128) null,
						   ModifiedDate   DATETIME      null,
						   Name_action    char(1)       null
						   );


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_product_measurement,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

						   DECLARE @OldID_product_measurement_2      bigint         ; 
						   DECLARE @OldProduct_measurement_Name_2    nvarchar(300)	;
						   DECLARE @OldSysProductMeasurementName_2   nvarchar(300)	;
	                       DECLARE @OldDescription_2                 nvarchar(4000)	;
                           
						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								        set @ChangeDescription = ''

                                        SELECT 
							                @OldID_product_measurement_2   	= D.ID_product_measurement    ,
							            	@OldProduct_measurement_Name_2 	= D.Product_measurement_Name  ,
							            	@OldSysProductMeasurementName_2 = D.SysProductMeasurementName ,            
							            	@OldDescription_2               = D.[Description]        
							            FROM deleted D
										where @ID_entity_D_2 = D.ID_product_measurement;

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_product_measurement'     +' = "'+  ISNULL(CAST(@OldID_product_measurement_2 AS NVARCHAR(50)),'')+ '", '
							            + 'Product_measurement_Name'   +' = "'+  ISNULL(@OldProduct_measurement_Name_2,'')+ '", '
							            + 'SysProductMeasurementName'  +' = "'+  ISNULL(@OldSysProductMeasurementName_2,'')+ '", '
							            + 'Description'                +' = "'+  ISNULL(@OldDescription_2  ,'')+ '"'

                                        IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                        INSERT  INTO dbo.Type_of_product_measurement_Audit
                                        ( 
                                         ID_product_measurement,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									    set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_product_measurement,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						   begin
							      begin try
								          set @ChangeDescription = ''

                                          SET @ChangeDescription = 'Inserted: '
                                                  + 'ID_product_measurement = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                    
                                          INSERT  INTO dbo.Type_of_product_measurement_Audit
                                          ( 
                                           ID_product_measurement,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                           SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									      set @ChangeDescription = ''     
								  
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE Type_Storage_location_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Type_Storage_location  bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(max)         null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_Type_Storage_location_Audit ON Type_Storage_location
AFTER INSERT, UPDATE, DELETE

AS 
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Type_Storage_location,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Type_Storage_location,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                           
						   DECLARE @OldID_Type_Storage_location    bigint           ;
						   DECLARE @OldName_Type_Storage_location  nvarchar(300)	;
						   DECLARE @OldSysNameTypeStoragelocation  nvarchar(300)	;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

                           DECLARE @NewID_Type_Storage_location    bigint           ;
						   DECLARE @NewName_Type_Storage_location  nvarchar(300)	;
						   DECLARE @NewSysNameTypeStoragelocation  nvarchar(300)	;
						   DECLARE @NewDescription                 nvarchar(4000)	;
                           
						   declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						        begin
							         begin try
                                        set @ChangeDescription = ''

							            SELECT 
							                @NewID_Type_Storage_location    = I.ID_Type_Storage_location  ,
							            	@NewName_Type_Storage_location	= I.Name_Type_Storage_location,
							            	@NewSysNameTypeStoragelocation  = I.SysNameTypeStoragelocation,            
							            	@NewDescription                 = I.[Description]        	
							            FROM inserted I
										where @ID_entity_D = I.ID_Type_Storage_location;	
							            
							            SELECT 
							                @OldID_Type_Storage_location    = D.ID_Type_Storage_location  ,
							            	@OldName_Type_Storage_location  = D.Name_Type_Storage_location,
							            	@OldSysNameTypeStoragelocation	= D.SysNameTypeStoragelocation,
							            	@OldDescription                 = D.[Description]        							
							            FROM Deleted D	
										where @ID_entity_D = D.ID_Type_Storage_location; 

                            
							            IF ISNULL(@NewName_Type_Storage_location,'null') <> ISNULL(@OldName_Type_Storage_location,'null')
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Type_Storage_location = Old ->"' +  ISNULL(@OldName_Type_Storage_location,'') + ' " NEW -> "' + isnull(@NewName_Type_Storage_location,'') + '", ';
							               end
							            
							            IF ISNULL(@NewSysNameTypeStoragelocation,'null') <> ISNULL(@OldSysNameTypeStoragelocation,'null') 
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysNameTypeStoragelocation = Old ->"' +  ISNULL(@OldSysNameTypeStoragelocation,'') + ' " NEW -> "' + isnull(@NewSysNameTypeStoragelocation,'') + '", ';
							               end                  
							            
                                        IF ISNULL(@NewDescription,'null') <> ISNULL(@OldDescription,'null')
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                           end
							            
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Type_Storage_location = "' +  isnull(cast(@OldID_Type_Storage_location as nvarchar(50)),'')+ '" ' + ISNULL(@ChangeDescription,'')
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                            
                                        INSERT  INTO dbo.Type_Storage_location_Audit
                                        ( 
                                         ID_Type_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                          SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                        
									    set @ChangeDescription = '' 
								end try
								begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN
                            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_Type_Storage_location,@login_name,GETDATE(),'D'  
							FROM  Deleted D


							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

                           DECLARE @OldID_Type_Storage_location_2    bigint         ;
						   DECLARE @OldName_Type_Storage_location_2  nvarchar(300)	;
						   DECLARE @OldSysNameTypeStoragelocation_2  nvarchar(300)	;
	                       DECLARE @OldDescription_2                 nvarchar(4000)	;

						   declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						         begin
							          begin try
									        set @ChangeDescription = ''

                                            SELECT 
							                    @OldID_Type_Storage_location_2    = D.ID_Type_Storage_location   ,
							                	@OldName_Type_Storage_location_2  = D.Name_Type_Storage_location ,
							                	@OldSysNameTypeStoragelocation_2  = D.SysNameTypeStoragelocation ,
							                	@OldDescription_2                 = D.[Description]        
							                FROM deleted D
											where @ID_entity_D_2 = D.ID_Type_Storage_location

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Type_Storage_location'   +' = "'+  ISNULL(CAST(@OldID_Type_Storage_location_2  AS NVARCHAR(50)),'')+ '", '
							                + 'Name_Type_Storage_location' +' = "'+  ISNULL(@OldName_Type_Storage_location_2,'')+ '", '
							                + 'SysNameTypeStoragelocation' +' = "'+  ISNULL(@OldSysNameTypeStoragelocation_2,'')+ '", '
							                + 'Description'                +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '
                          
						                    IF LEN(@ChangeDescription) > 0
                                                  SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                            INSERT  INTO dbo.Type_Storage_location_Audit
                                            ( 
                                             ID_Type_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                             SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									        set @ChangeDescription = '' 
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                   declare @t_I_I table 
				   (
				   Id_Num         bigint        identity(1,1) not null,
				   ID_entity      bigint        null,
				   login_name     nvarchar(128) null,
				   ModifiedDate   DATETIME      null,
				   Name_action    char(1)       null
				   );
				   
				   
				   insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
				   SELECT I.ID_Type_Storage_location,@login_name,GETDATE(),'I'  
				   FROM  inserted I 

				   DECLARE @ID_entity_I_2    bigint       ;
				   DECLARE @login_name_2_I_2 nvarchar(128);
				   DECLARE @ModifiedDate_I_2 DATETIME     ;
				   DECLARE @Name_action_I_2  char(1)      ;

                   declare cr_3 cursor local fast_forward for
						   
				   select 
				   ID_entity   
				   ,login_name  
				   ,ModifiedDate
				   ,Name_action 
				   from @t_I_I 
                      open cr_3       
				   
				   fetch next from cr_3 into 
				   @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
				   while @@FETCH_STATUS  = 0
						   begin
							     begin try
								       set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                               + 'ID_Type_Storage_location = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.Type_Storage_location_Audit
                                       ( 
                                        ID_Type_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
								 end try
								 begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3           
                    END

GO


CREATE TABLE TypeItem_Audit
(
    AuditID              bigint IDENTITY(1,1)  not null,
    Id_TypeItem          bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group;


go

CREATE TRIGGER trg_TypeItem_Audit ON TypeItem
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN       
				            declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_TypeItem,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_TypeItem,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ; 

                            
                            DECLARE @OldId_TypeItem BIGINT;
                            DECLARE @OldTypeItemName NVARCHAR(300);
                            DECLARE @OldSysTypeItemName NVARCHAR(300);
                            DECLARE @OldDescription NVARCHAR(4000);	                    
	                       
							DECLARE @NewId_TypeItem BIGINT;
                            DECLARE @NewTypeItemName NVARCHAR(300);
                            DECLARE @NewSysTypeItemName NVARCHAR(300);
                            DECLARE @NewDescription NVARCHAR(4000);

							declare cr cursor local fast_forward for
						   
						    select 
						    ID_entity    
						    ,login_name   
						    ,ModifiedDate 
						    ,Name_action  
						    from @t_U_D 
                            open cr       
						    
						    fetch next from cr into 
						    @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									       set @ChangeDescription = ''

									       SELECT @NewId_TypeItem     = I.Id_TypeItem    ,
							                      @NewTypeItemName    = I.TypeItemName   , 
							                      @NewSysTypeItemName = I.SysTypeItemName,
							                      @NewDescription     = I.[Description]
							               FROM inserted I
										   where @ID_entity_D = I.Id_TypeItem;

									       SELECT @OldId_TypeItem     = D.Id_TypeItem    , 
                                                  @OldTypeItemName    = D.TypeItemName   , 
                                                  @OldSysTypeItemName = D.SysTypeItemName,
                                                  @OldDescription     = D.[Description]
                                           FROM deleted D
										   where @ID_entity_D = D.Id_TypeItem;

							               
                                          IF isnull(@NewTypeItemName,'null') <> isnull(@OldTypeItemName,'null') 
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeItemName = Old ->"' +  ISNULL(@OldTypeItemName,'') + ' " NEW -> " ' + isnull(@NewTypeItemName,'') + '", ';
							                 end

                                          IF isnull(@NewSysTypeItemName,'null') <> isnull(@OldSysTypeItemName,'null')
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeItemName = Old ->"' + ISNULL(@OldSysTypeItemName,'') + ' " NEW -> "' + ISNULL(@NewSysTypeItemName,'') + '", ';
							                 end

                                          IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                             end

                                          SET @ChangeDescription = 'Updated: ' + ' Id_TypeItem = "' +  isnull(cast(@OldId_TypeItem as nvarchar(20)),'')+ '" ' + isnull(@ChangeDescription,'')
                                           --Удаляем запятую на конце
                                          IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                              			  INSERT  INTO dbo.TypeItem_Audit
                                          ( 
                                           Id_TypeItem,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									      set @ChangeDescription = '' 
								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
                END
            ELSE
                BEGIN        
				            declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);


							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.Id_TypeItem,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldId_TypeItem_2 BIGINT;
                            DECLARE @OldTypeItemName_2 NVARCHAR(300);
                            DECLARE @OldSysTypeItemName_2 NVARCHAR(300);
                            DECLARE @OldDescription_2 NVARCHAR(4000);
                            
							declare cr_2 cursor local fast_forward for
						   
						    select 
						    ID_entity   
						    ,login_name  
						    ,ModifiedDate
						    ,Name_action 
						    from @t_D_D 
                            open cr_2       
						   
						    fetch next from cr_2 into 
						    @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						    while @@FETCH_STATUS  = 0
						         begin
							         begin try
									       set @ChangeDescription = ''

									       SELECT
										          @OldId_TypeItem_2     = D.Id_TypeItem    , 
                                                  @OldTypeItemName_2    = D.TypeItemName   , 
                                                  @OldSysTypeItemName_2 = D.SysTypeItemName,
                                                  @OldDescription_2     = D.[Description]
                                           FROM deleted D
										   where @ID_entity_D_2 = D.Id_TypeItem;
										   
                                           SET @ChangeDescription = 'Deleted: '
                                              + 'Id_TypeItem'    + ' = "' + isnull(CAST(@OldId_TypeItem_2 AS NVARCHAR(50)),'') + '", '
                                              + 'TypeItemName'   + ' = "' + ISNULL(@OldTypeItemName_2, '') + '", '
                                              + 'SysTypeItemName'+ ' = "' + ISNULL(@OldSysTypeItemName_2, '') + '", '
                                              + 'Description'    + ' = "' + ISNULL(@OldDescription_2, '') + '" ';
                            
                                           IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                           
										  INSERT  INTO dbo.TypeItem_Audit
                                          ( 
                                           Id_TypeItem,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                           SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                          
									      set @ChangeDescription = '' 

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2

                END  
        END
    ELSE
        BEGIN       
		            declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.Id_TypeItem,@login_name,GETDATE(),'I'  
					FROM  inserted I

					DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ;

		            declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						  begin
							    begin try 
								       set @ChangeDescription = ''

                                       SET @ChangeDescription = 'Inserted: '
                                            + 'Id_TypeItem = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                       
									   INSERT  INTO dbo.TypeItem_Audit
                                        ( 
                                         Id_TypeItem,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = ''
                                 end try
								 begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3

                    END

GO


CREATE TABLE TypeOrders_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_TypeOrders          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group;


go

CREATE TRIGGER trg_TypeOrders_Audit ON TypeOrders
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max)='';


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                      		declare @t_U_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							declare @t_U_I table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_U_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_TypeOrders,@login_name,GETDATE(),'U'  
							FROM  Deleted D

							insert into @t_U_I (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_TypeOrders,@login_name,GETDATE(),'U'  
							FROM  inserted D
 
							DECLARE @ID_entity_D    bigint       ;
							DECLARE @login_name_2_D nvarchar(128);
							DECLARE @ModifiedDate_D DATETIME     ;
							DECLARE @Name_action_D  char(1)      ;
 
							DECLARE @ID_entity_I    bigint       ;
							DECLARE @login_name_2_I nvarchar(128);
							DECLARE @ModifiedDate_I DATETIME     ;
							DECLARE @Name_action_I  char(1)      ;
                            
                            DECLARE @OldID_TypeOrders       bigint        ;
                            DECLARE @OldTypeOrdersName      nvarchar(300) ;
                            DECLARE @OldTypeOrdersSysName   nvarchar(300) ;
                            DECLARE @OldDescription         nvarchar(4000);                  
	                       
							DECLARE @NewID_TypeOrders       bigint        ;
                            DECLARE @NewTypeOrdersName      nvarchar(300) ;
                            DECLARE @NewTypeOrdersSysName   nvarchar(300) ;
                            DECLARE @NewDescription         nvarchar(4000); 

							declare cr cursor local fast_forward for
						   
						   select 
						   ID_entity    
						   ,login_name   
						   ,ModifiedDate 
						   ,Name_action  
						   from @t_U_D 
                           open cr       
						   
						   fetch next from cr into 
						   @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try

								      set @ChangeDescription = ''
							          SELECT 
							                 @NewID_TypeOrders     = I.ID_TypeOrders     ,
							                 @NewTypeOrdersName    = I.TypeOrdersName    ,
							                 @NewTypeOrdersSysName = I.TypeOrdersSysName ,
							                 @NewDescription       = I.[Description]      
							          FROM inserted I									 
							          where @ID_entity_D = I.ID_TypeOrders 

							          SELECT 
                                             @OldID_TypeOrders     = D.ID_TypeOrders     ,
                                             @OldTypeOrdersName    = D.TypeOrdersName    ,
                                             @OldTypeOrdersSysName = D.TypeOrdersSysName ,
                                             @OldDescription       = D.[Description]      
							          FROM Deleted D								 
                                      where @ID_entity_D = D.ID_TypeOrders



                                      IF isnull(@NewTypeOrdersName,'null') <> isnull(@OldTypeOrdersName,'null') 
							             begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeOrdersName = Old ->"' +  ISNULL(@OldTypeOrdersName,'') + ' " NEW -> " ' + isnull(@NewTypeOrdersName,'') + '", ';
							             end

                                      IF isnull(@NewTypeOrdersSysName,'null') <> isnull(@OldTypeOrdersSysName,'null')
							             begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeOrdersSysName = Old ->"' + ISNULL(@OldTypeOrdersSysName,'') + ' " NEW -> "' + ISNULL(@NewTypeOrdersSysName,'') + '", ';
							             end

                                      IF isnull(@NewDescription,'null') <> isnull(@OldDescription,'null')
							             begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                         end

                                      SET @ChangeDescription = 'Updated: ' + ' ID_TypeOrders = "' +  isnull(cast(@OldID_TypeOrders as nvarchar(50)),'')+ '" ' + isnull(@ChangeDescription,'')
                                       --Удаляем запятую на конце
                                      IF LEN(@ChangeDescription) > 0
                                          SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                      INSERT  INTO dbo.TypeOrders_Audit
                                     ( 
                                      ID_TypeOrders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									set @ChangeDescription = '' 

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_U_D,
									   ERROR_SEVERITY() AS ErrorSeverity_U_D,
									   ERROR_STATE() as ErrorState_U_D,
									   ERROR_PROCEDURE() as ErrorProcedure_U_D,
									   ERROR_LINE() as ErrorLine_U_D,
									   ERROR_MESSAGE() as ErrorMessage_U_D;
								  end catch;
							     fetch next from cr into 
								 @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D
						         end
						   close cr
                           deallocate cr
   					
                END
            ELSE
                BEGIN
                           declare @t_D_D table 
							(
							Id_Num         bigint        identity(1,1) not null,
							ID_entity      bigint        null,
							login_name     nvarchar(128) null,
							ModifiedDate   DATETIME      null,
							Name_action    char(1)       null
							);

							insert into @t_D_D (ID_entity,login_name,ModifiedDate,Name_action)
							SELECT d.ID_TypeOrders,@login_name,GETDATE(),'D'  
							FROM  Deleted D

							DECLARE @ID_entity_D_2    bigint       ;
							DECLARE @login_name_2_D_2 nvarchar(128);
							DECLARE @ModifiedDate_D_2 DATETIME     ;
							DECLARE @Name_action_D_2  char(1)      ;

							DECLARE @OldID_TypeOrders_2       bigint        ;
                            DECLARE @OldTypeOrdersName_2      nvarchar(300) ;
                            DECLARE @OldTypeOrdersSysName_2   nvarchar(300) ;
                            DECLARE @OldDescription_2         nvarchar(4000);     
                            
							declare cr_2 cursor local fast_forward for
						   
						   select 
						   ID_entity   
						   ,login_name  
						   ,ModifiedDate
						   ,Name_action 
						   from @t_D_D 
                           open cr_2       
						   
						   fetch next from cr_2 into 
						   @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2 
						   while @@FETCH_STATUS  = 0
						       begin
							      begin try
								      set @ChangeDescription = ''

							          SELECT 
							                 @OldID_TypeOrders_2     = D.ID_TypeOrders     ,
							                 @OldTypeOrdersName_2    = D.TypeOrdersName    ,
							                 @OldTypeOrdersSysName_2 = D.TypeOrdersSysName ,
							                 @OldDescription_2       = D.[Description]      
							          FROM deleted D									 
							          where @ID_entity_D_2 = D.ID_TypeOrders

                                      SET @ChangeDescription = 'Deleted: '
                                          + 'ID_TypeOrders'     +' = "'+ isnull(CAST(@OldID_TypeOrders_2 AS NVARCHAR(50)),'') + '", '
                                          + 'TypeOrdersName'    +' = "'+ ISNULL(@OldTypeOrdersName_2, '') + '", '
                                          + 'TypeOrdersSysName' +' = "'+ ISNULL(@OldTypeOrdersSysName_2, '') + '", '
                                          + 'Description'       +' = "'+ ISNULL(@OldDescription_2, '') + '" ';

                                      IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
						  
                                      INSERT  INTO dbo.TypeOrders_Audit
                                     ( 
                                      ID_TypeOrders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

								  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_D_D,
									   ERROR_SEVERITY() AS ErrorSeverity_D_D,
									   ERROR_STATE() as ErrorState_D_D,
									   ERROR_PROCEDURE() as ErrorProcedure_D_D,
									   ERROR_LINE() as ErrorLine_D_D,
									   ERROR_MESSAGE() as ErrorMessage_D_D;
								  end catch;
							     fetch next from cr_2 into 
								 @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2
						         end
						   close cr_2
                           deallocate cr_2
                END  
        END
    ELSE
        BEGIN
                    DECLARE @ID_entity_I_2    bigint       ;
				    DECLARE @login_name_2_I_2 nvarchar(128);
				    DECLARE @ModifiedDate_I_2 DATETIME     ;
				    DECLARE @Name_action_I_2  char(1)      ; 

					declare @t_I_I table 
					(
					Id_Num         bigint        identity(1,1) not null,
					ID_entity      bigint        null,
					login_name     nvarchar(128) null,
					ModifiedDate   DATETIME      null,
					Name_action    char(1)       null
					);

					insert into @t_I_I (ID_entity,login_name,ModifiedDate,Name_action)
					SELECT I.ID_TypeOrders,@login_name,GETDATE(),'I'  
					FROM  inserted I
		            
					declare cr_3 cursor local fast_forward for
						   
					select 
					ID_entity   
					,login_name  
					,ModifiedDate
					,Name_action 
					from @t_I_I 
                    open cr_3       
					
					fetch next from cr_3 into 
					@ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2 
					while @@FETCH_STATUS  = 0
						       begin
							      begin try
								     set @ChangeDescription = ''

                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_TypeOrders = "' + CAST(@ID_entity_I_2 AS NVARCHAR(50)) + '" ';
                                     
									 INSERT  INTO dbo.TypeOrders_Audit
                                     ( 
                                      ID_TypeOrders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = ''

                                  end try
								  begin catch
								     if xact_state() in (1, -1)
									    begin
									       ROLLBACK TRAN
									    end
								     SELECT 
									   ERROR_NUMBER() AS ErrorNumber_I_I,
									   ERROR_SEVERITY() AS ErrorSeverity_I_I,
									   ERROR_STATE() as ErrorState_I_I,
									   ERROR_PROCEDURE() as ErrorProcedure_I_I,
									   ERROR_LINE() as ErrorLine_I_I,
									   ERROR_MESSAGE() as ErrorMessage_I_I;
								  end catch;
							     fetch next from cr_3 into 
								 @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2
						         end
						   close cr_3
                           deallocate cr_3
               

                    END

GO


set nocount,xact_abort on;
go


declare @PARTITION_Audit nvarchar(500); 
declare @SQl_script nvarchar(max); 

declare 
     @Num_partition_1 DateTime = '31.12.2025 23:59:59.997',
	 @Num_partition_2 DateTime = '31.12.2026 23:59:59.997',
	 @Num_partition_3 DateTime = '31.12.2027 23:59:59.997',
	 @Num_partition_4 DateTime = '31.12.2028 23:59:59.997',
	 @Num_partition_5 DateTime = '31.12.2029 23:59:59.997'

set  @PARTITION_Audit = N'/var/opt/mssql/data/' +  'PARTITION_Audit.ndf'

set  @SQl_script = '
Alter database [Magaz_DB_Poln] add filegroup [PARTITION_Audit];

Alter database [Magaz_DB_Poln] add file
(
 name = PARTITION_Audit                   
,FileName =  ''' +@PARTITION_Audit+''' 
,size	 = 100 mb
,maxsize = 15000 mb,															
filegrowth = 100 mb	
)  TO FILEGROUP PARTITION_Audit;


CREATE PARTITION FUNCTION PF_PartFuncDate_left (Datetime)  
AS RANGE left FOR VALUES 
(
''' + CAST(Format(@Num_partition_1,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + ''',
''' + CAST(Format(@Num_partition_2,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + ''',
''' + CAST(Format(@Num_partition_3,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + ''',
''' + CAST(Format(@Num_partition_4,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + ''',
''' + CAST(Format(@Num_partition_5,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + '''
);


CREATE PARTITION SCHEME SH_PartFuncDate_left
AS PARTITION PF_PartFuncDate_left
all TO (PARTITION_Audit)
'
if @SQl_script is not null
      begin
	       exec sp_executesql  @SQl_script
	  end;

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
CREATE TABLE Storage_location_status_Audit_2
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
CREATE TABLE Buyer_Type_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Buyer_Type          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit;
go

CREATE TABLE Species_Item_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Species_Item        bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit;
go

CREATE TABLE Item_status_Audit_2
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Item_Status         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on PARTITION_Audit;
go

create UNIQUE nonclustered index index_UNIQUE_Species_Item_Audit_2                  on Species_Item_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Item_status_Audit_2                   on Item_status_Audit_2(AuditID) 
create UNIQUE nonclustered index index_UNIQUE_Buyer_Type_Audit_2                    on Buyer_Type_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Storage_location_status_Audit_2       on Storage_location_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Order_Assignment_Audit_2              on Order_Assignment_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Order_category_Audit_2                on Order_category_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Employees_Audit_2                     on Employees_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Department_Audit_2                    on Department_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Group_Audit_2                         on Group_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_The_Subgroup_Audit_2                  on The_Subgroup_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Passport_Audit_2                      on Passport_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Post_Audit_2                          on Post_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Status_Employee_Audit_2               on Status_Employee_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_String_Audit_2             on Connection_String_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Branch_Audit_2                        on Branch_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Country_Audit_2                       on Country_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_Audit_2                         on Buyer_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_status_Audit_2                  on Buyer_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Condition_of_the_item_Audit_2         on Condition_of_the_item_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_Buyer_Audit_2              on Connection_Buyer_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Audit_2                      on Currency_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Rate_Audit_2                 on Currency_Rate_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Data_Orders_Audit_2                   on Data_Orders_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Exemplar_Audit_2                      on Exemplar_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Item_Audit_2                          on Item_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_Audit_2                        on Orders_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_status_Audit_2                 on Orders_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Storage_location_Audit_2              on Storage_location_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TRANSACTION_Audit_2                   on TRANSACTION_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Transaction_status_Audit_2            on Transaction_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_of_product_measurement_Audit_2   on Type_of_product_measurement_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_Storage_location_Audit_2         on Type_Storage_location_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeItem_Audit_2                      on TypeItem_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeOrders_Audit_2                    on TypeOrders_Audit_2(AuditID)

create UNIQUE nonclustered index index_UNIQUE_Species_Item_Audit                    on Species_Item_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Item_status_Audit                     on Item_status_Audit(AuditID) 
create UNIQUE nonclustered index index_UNIQUE_Buyer_Type_Audit                      on Buyer_Type_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Storage_location_status_Audit         on Storage_location_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Order_Assignment_Audit                on Order_Assignment_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Order_category_Audit                  on Order_category_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Employees_Audit                       on Employees_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Department_Audit                      on Department_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Group_Audit                           on Group_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_The_Subgroup_Audit                    on The_Subgroup_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Passport_Audit                        on Passport_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Post_Audit                            on Post_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Status_Employee_Audit                 on Status_Employee_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_String_Audit               on Connection_String_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Branch_Audit                          on Branch_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Country_Audit                         on Country_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_Audit                           on Buyer_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_status_Audit                    on Buyer_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Condition_of_the_item_Audit           on Condition_of_the_item_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_Buyer_Audit                on Connection_Buyer_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Audit                        on Currency_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Rate_Audit                   on Currency_Rate_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Data_Orders_Audit                     on Data_Orders_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Exemplar_Audit                        on Exemplar_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Item_Audit                            on Item_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_Audit                          on Orders_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_status_Audit                   on Orders_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Storage_location_Audit                on Storage_location_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TRANSACTION_Audit                     on TRANSACTION_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Transaction_status_Audit              on Transaction_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_of_product_measurement_Audit     on Type_of_product_measurement_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_Storage_location_Audit           on Type_Storage_location_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeItem_Audit                        on TypeItem_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeOrders_Audit                      on TypeOrders_Audit(AuditID)


create clustered index index_Species_Item_Audit_2                  on Species_Item_Audit_2(ID_Species_Item,ModifiedDate)                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_status_Audit_2                   on Item_status_Audit_2(Id_Item_Status,ModifiedDate)                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Type_Audit_2                    on Buyer_Type_Audit_2(Id_Buyer_Type,ModifiedDate)                           on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_status_Audit_2       on Storage_location_status_Audit_2(Id_Status,ModifiedDate)                  on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Order_Assignment_Audit_2              on Order_Assignment_Audit_2(ID_OrderAssignment,ModifiedDate)                on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Order_category_Audit_2                on Order_category_Audit_2(ID_OrderCategory,ModifiedDate)                    on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Employees_Audit_2                     on Employees_Audit_2(ID_Employee,ModifiedDate)                              on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Department_Audit_2                    on Department_Audit_2(ID_Department,ModifiedDate)                           on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Group_Audit_2                         on Group_Audit_2(ID_Group,ModifiedDate)                                     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_The_Subgroup_Audit_2                  on The_Subgroup_Audit_2(ID_The_Subgroup,ModifiedDate)                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Passport_Audit_2                      on Passport_Audit_2(ID_Passport,ModifiedDate)                               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Post_Audit_2                          on Post_Audit_2(ID_Post,ModifiedDate)                                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Status_Employee_Audit_2               on Status_Employee_Audit_2(ID_Status_Employee,ModifiedDate)                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_String_Audit_2             on Connection_String_Audit_2(ID_Connection_String,ModifiedDate)             on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Branch_Audit_2                        on Branch_Audit_2(ID_Branch,ModifiedDate)                                   on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Country_Audit_2                       on Country_Audit_2(Id_Country,ModifiedDate)                                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Audit_2                         on Buyer_Audit_2(Id_buyer,ModifiedDate)                                     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_status_Audit_2                  on Buyer_status_Audit_2(Id_Status,ModifiedDate)                             on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Condition_of_the_item_Audit_2         on Condition_of_the_item_Audit_2(ID_Condition_of_the_item,ModifiedDate)     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_Buyer_Audit_2              on Connection_Buyer_Audit_2(ID_Connection_Buyer,ModifiedDate)               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Audit_2                      on Currency_Audit_2(ID_Currency,ModifiedDate)                               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Rate_Audit_2                 on Currency_Rate_Audit_2(ID_Currency_Rate,ModifiedDate)                     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Data_Orders_Audit_2                   on Data_Orders_Audit_2(Id_Data_Orders,ModifiedDate)                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Exemplar_Audit_2                      on Exemplar_Audit_2(ID_Exemplar,ModifiedDate)                               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_Audit_2                          on Item_Audit_2(Id_Item,ModifiedDate)                                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_Audit_2                        on Orders_Audit_2(ID_Orders,ModifiedDate)                                   on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_status_Audit_2                 on Orders_status_Audit_2(Id_Status,ModifiedDate)                            on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_Audit_2              on Storage_location_Audit_2(ID_Storage_location,ModifiedDate)               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TRANSACTION_Audit_2                   on TRANSACTION_Audit_2(ID_Transaction,ModifiedDate)                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Transaction_status_Audit_2            on Transaction_status_Audit_2(ID_Transaction_status,ModifiedDate)           on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_of_product_measurement_Audit_2   on Type_of_product_measurement_Audit_2(ID_product_measurement,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_Storage_location_Audit_2         on Type_Storage_location_Audit_2(ID_Type_Storage_location,ModifiedDate)     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeItem_Audit_2                      on TypeItem_Audit_2(Id_TypeItem,ModifiedDate)                               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeOrders_Audit_2                    on TypeOrders_Audit_2(ID_TypeOrders,ModifiedDate)                           on SH_PartFuncDate_left(ModifiedDate)


create clustered index index_Species_Item_Audit                    on Species_Item_Audit(ID_Species_Item,ModifiedDate)                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_status_Audit                     on Item_status_Audit(Id_Item_Status,ModifiedDate)                           on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Type_Audit                      on Buyer_Type_Audit(Id_Buyer_Type,ModifiedDate)                             on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_status_Audit         on Storage_location_status_Audit(Id_Status,ModifiedDate)                    on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Order_Assignment_Audit                on Order_Assignment_Audit(ID_OrderAssignment,ModifiedDate)                  on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Order_category_Audit                  on Order_category_Audit(ID_OrderCategory,ModifiedDate)                      on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Employees_Audit                       on Employees_Audit(ID_Employee,ModifiedDate)                                on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Department_Audit                      on Department_Audit(ID_Department,ModifiedDate)                             on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Group_Audit                           on Group_Audit(ID_Group,ModifiedDate)                                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_The_Subgroup_Audit                    on The_Subgroup_Audit(ID_The_Subgroup,ModifiedDate)                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Passport_Audit                        on Passport_Audit(ID_Passport,ModifiedDate)                                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Post_Audit                            on Post_Audit(ID_Post,ModifiedDate)                                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Status_Employee_Audit                 on Status_Employee_Audit(ID_Status_Employee,ModifiedDate)                   on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_String_Audit               on Connection_String_Audit(ID_Connection_String,ModifiedDate)               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Branch_Audit                          on Branch_Audit(ID_Branch,ModifiedDate)                                     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Country_Audit                         on Country_Audit(Id_Country,ModifiedDate)                                   on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Audit                           on Buyer_Audit(Id_buyer,ModifiedDate)                                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_status_Audit                    on Buyer_status_Audit(Id_Status,ModifiedDate)                               on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Condition_of_the_item_Audit           on Condition_of_the_item_Audit(ID_Condition_of_the_item,ModifiedDate)       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_Buyer_Audit                on Connection_Buyer_Audit(ID_Connection_Buyer,ModifiedDate)                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Audit                        on Currency_Audit(ID_Currency,ModifiedDate)                                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Rate_Audit                   on Currency_Rate_Audit(ID_Currency_Rate,ModifiedDate)                       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Data_Orders_Audit                     on Data_Orders_Audit(Id_Data_Orders,ModifiedDate)                           on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Exemplar_Audit                        on Exemplar_Audit(ID_Exemplar,ModifiedDate)                                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_Audit                            on Item_Audit(Id_Item,ModifiedDate)                                         on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_Audit                          on Orders_Audit(ID_Orders,ModifiedDate)                                     on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_status_Audit                   on Orders_status_Audit(Id_Status,ModifiedDate)                              on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_Audit                on Storage_location_Audit(ID_Storage_location,ModifiedDate)                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TRANSACTION_Audit                     on TRANSACTION_Audit(ID_Transaction,ModifiedDate)                           on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Transaction_status_Audit              on Transaction_status_Audit(ID_Transaction_status,ModifiedDate)             on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_of_product_measurement_Audit     on Type_of_product_measurement_Audit(ID_product_measurement,ModifiedDate)   on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_Storage_location_Audit           on Type_Storage_location_Audit(ID_Type_Storage_location,ModifiedDate)       on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeItem_Audit                        on TypeItem_Audit(Id_TypeItem,ModifiedDate)                                 on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeOrders_Audit                      on TypeOrders_Audit(ID_TypeOrders,ModifiedDate)                             on SH_PartFuncDate_left(ModifiedDate)

go

CREATE FULLTEXT CATALOG CATALOG_FULLTEXT AS DEFAULT; 

--Employees_Audit  
--Employees_Audit_2
CREATE FULLTEXT INDEX ON Employees_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Employees_Audit
CREATE FULLTEXT INDEX ON Employees_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Employees_Audit_2
--Passport_Audit  
--Passport_Audit_2
CREATE FULLTEXT INDEX ON Passport_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Passport_Audit
CREATE FULLTEXT INDEX ON Passport_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Passport_Audit_2
--Connection_String_Audit
--Connection_String_Audit_2
CREATE FULLTEXT INDEX ON Connection_String_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Connection_String_Audit
CREATE FULLTEXT INDEX ON Connection_String_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Connection_String_Audit_2
--Branch_Audit
--Branch_Audit_2
CREATE FULLTEXT INDEX ON Branch_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Branch_Audit
CREATE FULLTEXT INDEX ON Branch_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Branch_Audit_2
--Buyer_Audit
--Buyer_Audit_2
CREATE FULLTEXT INDEX ON Buyer_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Buyer_Audit
CREATE FULLTEXT INDEX ON Buyer_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Buyer_Audit_2
--Connection_Buyer_Audit
--Connection_Buyer_Audit_2
CREATE FULLTEXT INDEX ON Connection_Buyer_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Connection_Buyer_Audit
CREATE FULLTEXT INDEX ON Connection_Buyer_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Connection_Buyer_Audit_2
--Currency_Rate_Audit
--Currency_Rate_Audit_2
CREATE FULLTEXT INDEX ON Currency_Rate_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Currency_Rate_Audit
CREATE FULLTEXT INDEX ON Currency_Rate_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Currency_Rate_Audit_2
--Data_Orders_Audit
--Data_Orders_Audit_2
CREATE FULLTEXT INDEX ON Data_Orders_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Data_Orders_Audit
CREATE FULLTEXT INDEX ON Data_Orders_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Data_Orders_Audit_2
--Exemplar_Audit
--Exemplar_Audit_2
CREATE FULLTEXT INDEX ON Exemplar_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Exemplar_Audit
CREATE FULLTEXT INDEX ON Exemplar_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Exemplar_Audit_2
--Item_Audit
--Item_Audit_2
CREATE FULLTEXT INDEX ON Item_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Item_Audit
CREATE FULLTEXT INDEX ON Item_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Item_Audit_2
--Orders_Audit
--Orders_Audit_2
CREATE FULLTEXT INDEX ON Orders_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_Orders_Audit
CREATE FULLTEXT INDEX ON Orders_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_Orders_Audit_2
--TRANSACTION_Audit
--TRANSACTION_Audit_2
CREATE FULLTEXT INDEX ON TRANSACTION_Audit   (ChangeDescription) KEY INDEX index_UNIQUE_TRANSACTION_Audit
CREATE FULLTEXT INDEX ON TRANSACTION_Audit_2 (ChangeDescription) KEY INDEX index_UNIQUE_TRANSACTION_Audit_2

go

create view All_Branch
as
select 
b.ID_Branch	           as 'ID_Филиала'
,b.Id_Country		   as 'ID_Страны'
,c.Name_Country		   as 'Наименование_страны'
,c.Name_English		   as 'Наименование_на_английском'
,c.Cod_Country_Phone   as 'Телефонный_код_страны'
,b.City				   as 'Наименование_города_где_находится_филиал'
,b.Address			   as 'Адрес_где_находится_филиал'
,b.Name_Branch		   as 'Наименование_филиала'
,b.Mail				   as 'Электроная_почта_филиала'
,b.Phone			   as 'Телефон_филиала'
,b.Postal_Code		   as 'Почтовый_индекс'
,b.INN				   as 'ИНН'
,b.Description         as 'Комментарии_к_филиалу'
from Branch as b
inner join Country as c on c.ID_Country = b.ID_Country

go

create view All_Endpoints_Grops
as
with s as(
select distinct 
ID_Parent_The_Subgroup
from The_Subgroup 
where  ID_Parent_The_Subgroup is not null
), 
s_2 as
(
select
d.ID_The_Subgroup,
f.ID_Parent_The_Subgroup
from s as f 
full outer join The_Subgroup as d on d.ID_The_Subgroup  = f.ID_Parent_The_Subgroup
where  f.ID_Parent_The_Subgroup is null
)
select 
d.ID_The_Subgroup
,d.ID_Parent_The_Subgroup
,d.Name_The_Subgroup
from The_Subgroup as d inner join  s_2 as s on  s.ID_The_Subgroup =  d.ID_The_Subgroup  

go

create view All_Otdel
as
select 
d.ID_Department		   as 'ID_Департамента'
,d.Name_Department	   as 'Наименование_Департамента'
,g.ID_Group			   as 'ID_Группы_или_отдела'
,g.Name_Group		   as 'Наименование отдела'
,t.ID_The_Subgroup	   as 'ID_Группы'
,t.Name_The_Subgroup   as 'Наименование_группы'
,t2.ID_The_Subgroup	   as 'ID_подгруппы'
,t2.Name_The_Subgroup  as 'Наименование_подгруппы'
from Department d 
left join  [Group]      as g  on g.ID_Department             = d.ID_Department
left join  The_Subgroup as t  on t.[ID_Group]                = g.[ID_Group]         and t.[ID_Parent_The_Subgroup] is null
left join  The_Subgroup as t2 on t2.[ID_Parent_The_Subgroup] = t.[ID_The_Subgroup] 

go

create view All_Post_Department
as
select 
 p.ID_Post                                as 'ID_Должности'
,p.Name_Post                              as 'Наименование_должности'
,p.ID_Department                          as 'ID_депортамента'
,d.Name_Department 						  as 'Наименование_депортамента'
,p.ID_Group                               as 'ID_Группы'
,g.Name_Group							  as 'Наименование_группы'
,p.ID_The_Subgroup                        as 'ID_ПодГруппы'   
,eg.Name_The_Subgroup					  as 'Наименование_подгруппы'
from Post p 
inner join All_Endpoints_Grops as eg on  eg.ID_The_Subgroup       = p.ID_The_Subgroup
inner join Department as d           on  d.ID_Department          = p.ID_Department
inner join [Group] as g              on  g.ID_Group               = p.ID_Group

go

create view AllEmployees
as
select
e.ID_Employee                             as 'ID_Сотрудника'
,d.Name_Department 						  as 'Наименование_депортамента'
,g.Name_Group							  as 'Наименование_группы'
,tg.Name_The_Subgroup					  as 'Наименование_подгруппы'
,p.Number_Series						  as 'Номер_серия_паспорта'
,p.Date_Of_Issue						  as 'Дата_выдачи'
,p.Department_Code						  as 'Код_депортамента'
,p.Issued_By_Whom						  as 'Кем_выдан'
,p.Registration							  as 'Регистрация'
,p.Military_Duty						  as 'Прохождение_военной_службы'
,b.City									  as 'Город_филиала'
,b.Address								  as 'Адрес_филиала'
,b.Name_Branch							  as 'Наименование_филиала'
,ps.Name_Post							  as 'Наименование_должности'
,c.Password								  as 'Пароль_УЗ'
,c.Login								  as 'Логин_УЗ'
,c.Date_Created							  as 'Дата_заведения_УЗ'
,e.ID_Chief								  as 'Руководитель'
,e.Name									  as 'Имя'
,e.SurName								  as 'Фамилия'
,e.LastName								  as 'Отчество'
,e.Date_Of_Hiring						  as 'Дата_создания_карты_работника'
,e.Date_Card_Created_Employee			  as 'Дата_приема_на_работу'
,e.Residential_Address					  as 'Адрес_проживания'
,e.Home_Phone							  as 'Домашний_телефон'
,e.Cell_Phone							  as 'Сотовый_телефон'
,e.Image_Employees						  as 'Фотография_сотрудника'
,e.Work_Phone							  as 'Рабочий_телефон'
,e.Mail									  as 'Электронная_почта_сотрудника'
,e.Pol									  as 'Пол'
,e.Date_Of_Dismissal					  as 'Дата_увольнения'
,e.Date_Of_Birth 						  as 'Дата_Рождения'
,s.Name_Status_Employee                   as 'Статус_карточки_сотрудника'
from Employees as e
inner join Department as d              on d.ID_Department          = e.ID_Department
inner join [Group] as g                 on g.ID_Group               = e.ID_Group
inner join All_Endpoints_Grops as tg    on tg.ID_The_Subgroup       = e.ID_The_Subgroup
inner join Passport as p                on p.ID_Passport            = e.ID_Passport
inner join Branch as b                  on b.ID_Branch              = e.ID_Branch
inner join Post as ps                   on ps.ID_Post               = e.ID_Post
inner join Connection_String as c       on c.ID_Connection_String   = e.ID_Connection_String
inner join Status_Employee   as s       on s.ID_Status_Employee     = e.ID_Status_Employee

go

create view All_Data_Exemplar
as
select
e.ID_Exemplar
,e.Old_Price_no_NDS                 as 'Цена_без_НДС_экземпляра'
,e.Old_Price_NDS					as 'Цена_экземпляра_с_НДС'
,e.New_Price_NDS					as 'Цена_экземпляра_с_НДС_после_начисления_коммисии_за_сервис'
,e.New_Price_no_NDS					as 'Цена_экземпляра_без_НДС_после_начисления_коммисии_за_сервис'
,e.Date_Refund                      as 'Дата_возврата'
,e.Date_Created                     as 'Дата_заведения_экземпляра_в_систему'
,e.ID_Condition_of_the_item
,e_2.Name_Condition_of_the_item     as 'Наименование_статуса_экземпляра'
,e.Id_Item             
,e_3.Name_Item                      as 'Наименование_карточки_товара'
,e_3.Manufacturer                   as 'Наименование_производителя'
,e_3.Country                        as 'Страна_производителя'
,e_3.City							as 'Город_производителя'
,e_3.Adress							as 'Адрес_производителя'
,e.ID_Currency
,c.Full_name_rus                    as 'Наименование_валюты_на_русском'
,e_3.Quantity                       as 'Количество_товара'
,e_3.Date_Created                   as 'Дата_создания_карточки_товара'
,e_3.ID_product_measurement    
,t.Product_measurement_Name         as 'Тип_измерения_товара'
,e_3.ID_TypeItem
,t_2.TypeItemName                   as 'Тип_товара'
,e_3.ID_Species_Item
,t_3.SpeciesItemName                as 'Вид_товара'
,e_3.Id_Item_Status
,i.ItemStatus                       as 'Наименование_статуса_товара'
,e.ID_Storage_location          
,s.Name                             as 'Наименование_места_хранения'
,s.ID_Type_Storage_location
,s_2.Name_Type_Storage_location     as 'Наименование_типа_места_хранения'
,s.Id_Status
,s_3.TypeStoragelocationName        as 'Статус_места_хранения'
,s.Id_Country
,co.Name_Country                    as 'Наименование_страны_места_хранения'
,s.City                             as 'Город_места_хранения'
,s.Adress                           as 'Адрес_места_хранения'
from Exemplar  e
left join Condition_of_the_item as e_2          on e_2.ID_Condition_of_the_item = e.ID_Condition_of_the_item 
left join item as e_3                           on e_3.ID_item                  = e.ID_item 
left join Currency as c                         on c.ID_Currency                = e.ID_Currency
left join Type_of_product_measurement as t      on t.ID_product_measurement     = e_3.ID_product_measurement
left join TypeItem as t_2                       on t_2.Id_TypeItem              = e_3.ID_TypeItem
left join Species_Item as t_3                   on t_3.ID_Species_Item          = e_3.ID_Species_Item 
left join Item_status as i                      on i.Id_Item_Status             = e_3.Id_Item_Status
left join Storage_location as s                 on s.ID_Storage_location        = e.ID_Storage_location
left join Type_Storage_location as s_2          on s_2.ID_Type_Storage_location = s.ID_Type_Storage_location
left join Storage_location_status as s_3        on s_3.Id_Status                = s.Id_Status
left join Country as co                         on co.Id_Country                = s.Id_Country
go


--SELECT FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') AS IsFullTextInstalled;  -- Проверка на уствновленный компонент Полн_тект_индекса