
--Полнотекстовые индексы создаются не на все таблицы, а на те которые я выбрал лично---------------------------------
-----Так как в список не попали те, в которых нет много информации, и не должно быть---------------------------------

--ВАЖНО !!!!!!!!!!!!!! ПРИ ПЕРЕНОСЕ СЕКЦИЙ ТАБЛИЦЫ С СОЗДАННЫМ ПОЛНОТЕКСТОВЫМ КЛЮЧЁМ - Не удалось выполнить инструкцию ALTER TABLE SWITCH, так как таблица "Magaz_DB_Poln_Test.dbo.Branch_Audit" имеет полнотекстовый индекс.
--ТОГДА СНАЧАЛА УДАЛЯЕМ ИХ, ПОТОМ ПЕРЕНОИМ, И ПОТОМ СНОВА ВОСТОНАВЛИВАЕМ. ТОЛЬКО ТАК.



--SELECT FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') AS IsFullTextInstalled;  -- Проверка на уствновленный компонент Полн_тект_индекса
use Magaz_DB_Poln

go
--создание полнотекстового индекса
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
