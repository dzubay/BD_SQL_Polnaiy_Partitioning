use Magaz_DB_Poln
go
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

set  @PARTITION_Audit = N'd:\Программы\БД\Моя база данных\2024\Более новая БД\Файлы_БД_полной\Для_полной_БД_2025\PARTITION_Audit\' +  'PARTITION_Audit.ndf'

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


	  --select * from sys.partitions
	  --select * from sys.partition_functions  
	  --select * from sys.partition_schemes    