-------------------------------------------------------------------------------------------------------------------------
use Magaz_DB_Poln
go

begin tran
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
Id_Status                   bigint         not null,                                        -- ID Статуса покупателя
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
ID_Employee            bigint          not null,                                           -- ID Сотрудника или бота
ID_Orders              bigint          not null,                                           -- ID Заказа
Id_buyer               bigint          not null,	                                       -- ID Покупателя
ID_Exemplar            bigint          not null,                                           -- ID Экземпляра
ID_Transaction         bigint          not null,                                           -- ID Тразанкции
Date_Data_Orders       datetime        not null  default getdate(),                        -- Дата создания данныйх о заказе
[Description]          nvarchar(4000)  null
constraint PK_ID_Data_Orders                primary key (ID_Data_Orders) 
)  on Orders_Group
go

--rollback
commit