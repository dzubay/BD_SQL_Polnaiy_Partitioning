use Magaz_DB_Poln
go
---------------------------------Данный запрос формирует уникальные кластеризованные индексы----------------------------------------------------------------------------------------------------
---------------------------так как для создания ПОЛНОТЕКСТОВОГО ИНДЕКСА требуется, проиндексированное уникальное поле, иначе будет ошибка-------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------НУЖНЫЕ ПОЛЯ УЖЕ СФОРМИРОВАНЫ НИЖЕ, МОЖНО ЗАПУСКАТЬ ИХ. ОНИ ПРОВЕРЕНЫ!!!!!!!!!!!!!---------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Именно сначала, в таком порядке, а не иначе, а то будет ошибка.


/*
select 'create UNIQUE nonclustered index index_UNIQUE_' + d.Name_TB + ' on ' + d.Name_TB + '(AuditID)' 
from 
(
SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,o.name as Name_TB, 0 flag 
--into #t2
FROM sys.objects o 
where 1 = 1 and o.type = 'U' and o.name like '%_2%'
union all
SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,LEFT (o.name, len(o.name)-2)  as Name_TB,0 flag
--into #t3
FROM sys.objects o
where 1 = 1  and o.type = 'U'  and o.name like '%_2%'
) as d
*/

begin tran
create UNIQUE nonclustered index index_UNIQUE_Order_Assignment_Audit_2 on Order_Assignment_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Order_category_Audit_2 on Order_category_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Employees_Audit_2 on Employees_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Department_Audit_2 on Department_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Group_Audit_2 on Group_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_The_Subgroup_Audit_2 on The_Subgroup_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Passport_Audit_2 on Passport_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Post_Audit_2 on Post_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Status_Employee_Audit_2 on Status_Employee_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_String_Audit_2 on Connection_String_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Branch_Audit_2 on Branch_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Country_Audit_2 on Country_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_Audit_2 on Buyer_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_status_Audit_2 on Buyer_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Condition_of_the_item_Audit_2 on Condition_of_the_item_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_Buyer_Audit_2 on Connection_Buyer_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Audit_2 on Currency_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Rate_Audit_2 on Currency_Rate_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Data_Orders_Audit_2 on Data_Orders_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Exemplar_Audit_2 on Exemplar_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Item_Audit_2 on Item_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_Audit_2 on Orders_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_status_Audit_2 on Orders_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Storage_location_Audit_2 on Storage_location_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TRANSACTION_Audit_2 on TRANSACTION_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Transaction_status_Audit_2 on Transaction_status_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_of_product_measurement_Audit_2 on Type_of_product_measurement_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_Storage_location_Audit_2 on Type_Storage_location_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeItem_Audit_2 on TypeItem_Audit_2(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeOrders_Audit_2 on TypeOrders_Audit_2(AuditID)

create UNIQUE nonclustered index index_UNIQUE_Order_Assignment_Audit on Order_Assignment_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Order_category_Audit on Order_category_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Employees_Audit on Employees_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Department_Audit on Department_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Group_Audit on Group_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_The_Subgroup_Audit on The_Subgroup_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Passport_Audit on Passport_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Post_Audit on Post_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Status_Employee_Audit on Status_Employee_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_String_Audit on Connection_String_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Branch_Audit on Branch_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Country_Audit on Country_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_Audit on Buyer_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Buyer_status_Audit on Buyer_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Condition_of_the_item_Audit on Condition_of_the_item_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Connection_Buyer_Audit on Connection_Buyer_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Audit on Currency_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Currency_Rate_Audit on Currency_Rate_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Data_Orders_Audit on Data_Orders_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Exemplar_Audit on Exemplar_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Item_Audit on Item_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_Audit on Orders_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Orders_status_Audit on Orders_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Storage_location_Audit on Storage_location_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TRANSACTION_Audit on TRANSACTION_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Transaction_status_Audit on Transaction_status_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_of_product_measurement_Audit on Type_of_product_measurement_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_Type_Storage_location_Audit on Type_Storage_location_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeItem_Audit on TypeItem_Audit(AuditID)
create UNIQUE nonclustered index index_UNIQUE_TypeOrders_Audit on TypeOrders_Audit(AuditID)
--rollback
commit





--Формируем индексы, с помощью запроса ниже. Даннын индексы требуются для формирования секции в схеме секционирования.
--На данный момент индекс был сформирован по двум полям, это поле "ModifiedDate" которое указано в смехе и функции секционирования, и второй столбец с ID объекта над которым были произведены изменения
--Это некластеризованный композитный индекс. 
--!!!Можно попробовать только с полем "ModifiedDate", но думаю лучше с двумя полями.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------НУЖНЫЕ ПОЛЯ УЖЕ СФОРМИРОВАНЫ НИЖЕ, МОЖНО ЗАПУСКАТЬ ИХ. ОНИ ПРОВЕРЕНЫ!!!!!!!!!!!!!---------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
select 'create clustered index index_' + d.TABLE_NAME + ' on ' + d.TABLE_NAME + '('+ d.COLUMN_NAME +',ModifiedDate)' + ' on SH_PartFuncDate_left(ModifiedDate)'  
from 
(
SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,o.name as Name_TB, 0 flag, o_2.TABLE_NAME,o_2.COLUMN_NAME
--into #t2
FROM sys.objects o 
outer apply (
              SELECT TABLE_NAME,COLUMN_NAME
              FROM INFORMATION_SCHEMA.COLUMNS 
              WHERE TABLE_NAME  in (
              select r.Name_TB from (
              SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,o.name as Name_TB, 0 flag 
              --into #t2
              FROM sys.objects o 
              where 1 = 1 and o.type = 'U' and o.name like '%_2%'
              union all
              SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,LEFT (o.name, len(o.name)-2)  as Name_TB,0 flag
              --into #t3
              FROM sys.objects o
              where 1 = 1  and o.type = 'U'  and o.name like '%_2%'
              ) r )
              AND ORDINAL_POSITION = 2 and  TABLE_NAME = o.name            
		     ) o_2
where 1 = 1 and o.type = 'U' and o.name like '%_2%'
union all
SELECT ROW_NUMBER() OVER (ORDER BY t.name) as Num,LEFT (t.name, len(t.name)-2)  as Name_TB,0 flag, LEFT (o_2.TABLE_NAME, len(o_2.TABLE_NAME)-2),o_2.COLUMN_NAME
--into #t3
FROM sys.objects t
outer apply (
              SELECT TABLE_NAME,COLUMN_NAME
              FROM INFORMATION_SCHEMA.COLUMNS 
              WHERE TABLE_NAME  in (
              select r.Name_TB from (
              SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,o.name as Name_TB, 0 flag 
              --into #t2
              FROM sys.objects o 
              where 1 = 1 and o.type = 'U' and o.name like '%_2%'
              union all
              SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,LEFT (o.name, len(o.name)-2)  as Name_TB,0 flag
              --into #t3
              FROM sys.objects o
              where 1 = 1  and o.type = 'U'  and o.name like '%_2%'
              ) r )
              AND ORDINAL_POSITION = 2 and  TABLE_NAME = t.name            
		     ) o_2
where 1 = 1  and t.type = 'U'  and t.name like '%_2%'
) as d

*/


begin tran
create clustered index index_Order_Assignment_Audit_2 on Order_Assignment_Audit_2(ID_OrderAssignment,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Order_category_Audit_2 on Order_category_Audit_2(ID_OrderCategory,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Employees_Audit_2 on Employees_Audit_2(ID_Employee,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Department_Audit_2 on Department_Audit_2(ID_Department,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Group_Audit_2 on Group_Audit_2(ID_Group,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_The_Subgroup_Audit_2 on The_Subgroup_Audit_2(ID_The_Subgroup,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Passport_Audit_2 on Passport_Audit_2(ID_Passport,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Post_Audit_2 on Post_Audit_2(ID_Post,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Status_Employee_Audit_2 on Status_Employee_Audit_2(ID_Status_Employee,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_String_Audit_2 on Connection_String_Audit_2(ID_Connection_String,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Branch_Audit_2 on Branch_Audit_2(ID_Branch,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Country_Audit_2 on Country_Audit_2(Id_Country,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Audit_2 on Buyer_Audit_2(Id_buyer,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_status_Audit_2 on Buyer_status_Audit_2(Id_Status,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Condition_of_the_item_Audit_2 on Condition_of_the_item_Audit_2(ID_Condition_of_the_item,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_Buyer_Audit_2 on Connection_Buyer_Audit_2(ID_Connection_Buyer,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Audit_2 on Currency_Audit_2(ID_Currency,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Rate_Audit_2 on Currency_Rate_Audit_2(ID_Currency_Rate,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Data_Orders_Audit_2 on Data_Orders_Audit_2(Id_Data_Orders,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Exemplar_Audit_2 on Exemplar_Audit_2(ID_Exemplar,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_Audit_2 on Item_Audit_2(Id_Item,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_Audit_2 on Orders_Audit_2(ID_Orders,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_status_Audit_2 on Orders_status_Audit_2(Id_Status,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_Audit_2 on Storage_location_Audit_2(ID_Storage_location,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TRANSACTION_Audit_2 on TRANSACTION_Audit_2(ID_Transaction,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Transaction_status_Audit_2 on Transaction_status_Audit_2(ID_Transaction_status,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_of_product_measurement_Audit_2 on Type_of_product_measurement_Audit_2(ID_product_measurement,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_Storage_location_Audit_2 on Type_Storage_location_Audit_2(ID_Type_Storage_location,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeItem_Audit_2 on TypeItem_Audit_2(Id_TypeItem,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeOrders_Audit_2 on TypeOrders_Audit_2(ID_TypeOrders,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)


create clustered index index_Order_Assignment_Audit on Order_Assignment_Audit(ID_OrderAssignment,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Order_category_Audit on Order_category_Audit(ID_OrderCategory,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Employees_Audit on Employees_Audit(ID_Employee,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Department_Audit on Department_Audit(ID_Department,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Group_Audit on Group_Audit(ID_Group,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_The_Subgroup_Audit on The_Subgroup_Audit(ID_The_Subgroup,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Passport_Audit on Passport_Audit(ID_Passport,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Post_Audit on Post_Audit(ID_Post,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Status_Employee_Audit on Status_Employee_Audit(ID_Status_Employee,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_String_Audit on Connection_String_Audit(ID_Connection_String,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Branch_Audit on Branch_Audit(ID_Branch,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Country_Audit on Country_Audit(Id_Country,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_Audit on Buyer_Audit(Id_buyer,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Buyer_status_Audit on Buyer_status_Audit(Id_Status,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Condition_of_the_item_Audit on Condition_of_the_item_Audit(ID_Condition_of_the_item,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Connection_Buyer_Audit on Connection_Buyer_Audit(ID_Connection_Buyer,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Audit on Currency_Audit(ID_Currency,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Currency_Rate_Audit on Currency_Rate_Audit(ID_Currency_Rate,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Data_Orders_Audit on Data_Orders_Audit(Id_Data_Orders,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Exemplar_Audit on Exemplar_Audit(ID_Exemplar,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Item_Audit on Item_Audit(Id_Item,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_Audit on Orders_Audit(ID_Orders,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Orders_status_Audit on Orders_status_Audit(Id_Status,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Storage_location_Audit on Storage_location_Audit(ID_Storage_location,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TRANSACTION_Audit on TRANSACTION_Audit(ID_Transaction,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Transaction_status_Audit on Transaction_status_Audit(ID_Transaction_status,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_of_product_measurement_Audit on Type_of_product_measurement_Audit(ID_product_measurement,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_Type_Storage_location_Audit on Type_Storage_location_Audit(ID_Type_Storage_location,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeItem_Audit on TypeItem_Audit(Id_TypeItem,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
create clustered index index_TypeOrders_Audit on TypeOrders_Audit(ID_TypeOrders,ModifiedDate) on SH_PartFuncDate_left(ModifiedDate)
--rollback
commit







