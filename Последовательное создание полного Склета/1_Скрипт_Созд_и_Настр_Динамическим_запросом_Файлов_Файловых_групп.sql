
--Сначала требуется ввести данные о пути к папкам, и после чего запускать.
declare                                          --------------------------------------------
 @Magaz_DB_Poln_Root      nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Magaz_DB_Poln_Root\'   +  'Magaz_DB_Poln_Root.mdf'
,@Customers_Data_Poln_1   nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Costomers_Group\'      +  'Customers_Data_Poln_1.ndf'
,@Customers_Data_Poln_2   nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Costomers_Group\'      +  'Customers_Data_Poln_2.ndf'
,@Product_Data_Poln_1	  nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Products_Group\'       +  'Product_Data_Poln_1.ndf'
,@Product_Data_Poln_2	  nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Products_Group\'       +  'Product_Data_Poln_2.ndf'
,@Orders_Data_Poln_1	  nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Orders_Group\'         +  'Orders_Data_Poln_1.ndf'
,@Orders_Data_Poln_2	  nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Orders_Group\'         +  'Orders_Data_Poln_2.ndf'
,@Employee_Data_Poln_1	  nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Employee_Group\'       +  'Employee_Data_Poln_1.ndf'
,@Employee_Data_Poln_2	  nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Employee_Group\'       +  'Employee_Data_Poln_2.ndf'
,@Log_Data_Poln           nvarchar(400) =  'D:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\Log_Data\'             +  'Log_Data_Poln.ldf'
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


