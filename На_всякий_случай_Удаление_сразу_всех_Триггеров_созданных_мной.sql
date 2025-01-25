--Удаление всех триггеров созданных мной
DECLARE @triggerName NVARCHAR(256);
DECLARE triggerCursor CURSOR FOR
SELECT name
FROM sys.triggers
WHERE is_ms_shipped = 0
AND object_id IN (
   SELECT object_id
   FROM sys.objects
   WHERE principal_id = USER_ID('LAPTOP-QJ5M2P5A\dzubay') or principal_id  is null and Name like '%trg_%'
);

OPEN triggerCursor;
FETCH NEXT FROM triggerCursor INTO @triggerName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(500);
    SET @sql = 'DROP TRIGGER [' + @triggerName + '];';
    EXEC sp_executesql @sql;

    FETCH NEXT FROM triggerCursor INTO @triggerName;
END

CLOSE triggerCursor;
DEALLOCATE triggerCursor;



--Удаление всех таблиц, которые были созданны триггером
drop table Buyer_Audit
drop table Buyer_status_Audit
drop table Condition_of_the_item_Audit
drop table Connection_Buyer_Audit
drop table Currency_Audit
drop table Currency_Rate_Audit
drop table Data_Orders_Audit
drop table Exemplar_Audit
drop table Item_Audit
drop table Orders_Audit
drop table Orders_status_Audit
drop table Storage_location_Audit
drop table TRANSACTION_Audit
drop table Transaction_status_Audit
drop table Type_of_product_measurement_Audit
drop table Type_Storage_location_Audit
drop table TypeItem_Audit
drop table TypeOrders_Audit

--Удаление всех таблиц, которые были созданны триггером
--drop table Buyer_Audit_2
--drop table Buyer_status_Audit_2
--drop table Condition_of_the_item_Audit_2
--drop table Connection_Buyer_Audit_2
--drop table Currency_Audit_2
--drop table Currency_Rate_Audit_2
--drop table Data_Orders_Audit_2
--drop table Exemplar_Audit_2
--drop table Item_Audit_2
--drop table Orders_Audit_2
--drop table Orders_status_Audit_2
--drop table Storage_location_Audit_2
--drop table TRANSACTION_Audit_2
--drop table Transaction_status_Audit_2
--drop table Type_of_product_measurement_Audit_2
--drop table Type_Storage_location_Audit_2
--drop table TypeItem_Audit_2
--drop table TypeOrders_Audit_2



truncate table Buyer_Audit_2
truncate table Buyer_status_Audit_2
truncate table Condition_of_the_item_Audit_2
truncate table Connection_Buyer_Audit_2
truncate table Currency_Audit_2
truncate table Currency_Rate_Audit_2
truncate table Data_Orders_Audit_2
truncate table Exemplar_Audit_2
truncate table Item_Audit_2
truncate table Orders_Audit_2
truncate table Orders_status_Audit_2
truncate table Storage_location_Audit_2
truncate table TRANSACTION_Audit_2
truncate table Transaction_status_Audit_2
truncate table Type_of_product_measurement_Audit_2
truncate table Type_Storage_location_Audit_2
truncate table TypeItem_Audit_2
truncate table TypeOrders_Audit_2


--truncate table Buyer_Audit
--truncate table Buyer_status_Audit
--truncate table Condition_of_the_item_Audit
--truncate table Connection_Buyer_Audit
--truncate table Currency_Audit
--truncate table Currency_Rate_Audit
--truncate table Data_Orders_Audit
--truncate table Exemplar_Audit
--truncate table Item_Audit
--truncate table Orders_Audit
--truncate table Orders_status_Audit
--truncate table Storage_location_Audit
--truncate table TRANSACTION_Audit
--truncate table Transaction_status_Audit
--truncate table Type_of_product_measurement_Audit
--truncate table Type_Storage_location_Audit
--truncate table TypeItem_Audit
--truncate table TypeOrders_Audit


















