use Magaz_DB_2_Test
go
set nocount,xact_abort on
go


declare @SQL nvarchar(max);
declare @Name_TB nvarchar(150);
declare @Name_TB_2 nvarchar(150);
declare @num int;
declare @flag int;
declare @err nvarchar(max);
declare @mess nvarchar(max);

declare @i int = 0, @s int, @n nvarchar(100);

declare @Name_TB_rows int;    
declare @partition_number int;
declare @partition_id bigint; 


declare @Num_partition DateTime = '31.12.2023 23:59:59.997' -- Указываем Секцию

drop table if exists #t
drop table if exists #t2
drop table if exists #t3


Create table #t
(
num        int   identity(1,1) not null,
Name_TB    nvarchar(150) null,
Name_TB_2  nvarchar(150) null,
Flag       int           null
)


SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,o.name as Name_TB, 0 flag 
into #t2
FROM sys.objects o 
where 1 = 1 and o.type = 'U' and o.name like '%_2%'

SELECT ROW_NUMBER() OVER (ORDER BY o.name) as Num,LEFT (o.name, len(o.name)-2)  as Name_TB,0 flag
into #t3
FROM sys.objects o
where 1 = 1  and o.type = 'U'  and o.name like '%_2%'



insert into #t 
select  t3.Name_TB,t2.Name_TB,t2.flag from #t2 as t2 join #t3 t3 on t3.Num = t2.Num


declare curs cursor local fast_forward read_only for

select num,Name_TB,Name_TB_2,Flag from #t

open curs
   fetch next from curs into @num,@Name_TB,@Name_TB_2,@flag 
      while @@FETCH_STATUS = 0
	     begin
		    begin try
			     SELECT 
				 @partition_id = partition_id,
                 @partition_number = p.partition_number,
                 @Name_TB_rows = p.rows
                 FROM  sys.partitions p  
                 JOIN  sys.tables t                          ON p.object_id = t.object_id
                 JOIN  sys.indexes i                         ON p.object_id = i.object_id            AND p.index_id = i.index_id
                 JOIN  sys.partition_schemes ps              ON ps.data_space_id = i.data_space_id 
                 join  sys.partition_functions pf            ON pf.function_id = ps.function_id
                 left JOIN sys.partition_range_values  prv   on prv.function_id=pf.function_id       
                 and p.partition_number =  CASE pf.boundary_value_on_right 
                                                WHEN 1 THEN prv.boundary_id + 1 
                                           ELSE prv.boundary_id END       
                 WHERE  t.name = @Name_TB and prv.value = @Num_partition

				 print  ' ID Секции, из таблицы '+ isnull(@Name_TB,'')  +' которая будет переносится --> ' + isnull(cast(@partition_id as nvarchar(30)),'') + ';' +
				       + ' Нумерация секции ' + isnull(cast(@partition_number as nvarchar(2)),'')  + ' Число строк --> ' + isnull(cast(@Name_TB_rows as nvarchar(100)),'') 
					   

			     set @SQL = N'
			     alter table 
				 ' + QUOTENAME(@Name_TB) + '  switch partition   
                 $partition.PF_PartFuncDate_left(''' + CAST(Format(@Num_partition,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + ''')  
                 to ' + QUOTENAME(@Name_TB_2) + '   partition  
                 $partition.PF_PartFuncDate_left(''' + CAST(Format(@Num_partition,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)) + ''')
				 '
				 exec sp_executesql @sql;
				 set @i = @i + 1
				 if exists (SELECT 
                            p.rows,
                            prv.value       as  partition_value,
                            t.name          AS table_name
                            FROM  sys.partitions p  
                            JOIN  sys.tables t                          ON p.object_id = t.object_id
                            JOIN  sys.indexes i                         ON p.object_id = i.object_id            AND p.index_id = i.index_id
                            JOIN  sys.partition_schemes ps              ON ps.data_space_id = i.data_space_id 
                            join  sys.partition_functions pf            ON pf.function_id = ps.function_id
                            left JOIN sys.partition_range_values  prv   on prv.function_id=pf.function_id       
                            and p.partition_number =  CASE pf.boundary_value_on_right 
                                                           WHEN 1 THEN prv.boundary_id + 1 
                                                      ELSE prv.boundary_id END       
                            WHERE 1 = 1
							and t.name not like '%_2%'  
							and prv.value = @Num_partition
							and p.rows = 0
							and t.name = @Name_TB
							)
							begin 
							    update r set flag = 1 from #t r where Name_TB =  @Name_TB and  @Name_TB_2 = Name_TB_2 and flag = 0
							end;
				 

				 select @s = count(0) from #t where flag = 0
			     set @n = (select  
			               case  t.Flag  when 1 then ' "1"  Секция была перенесена' when 0  then ' "0"  Секция не перенесена' end  
			               from #t t  where Name_TB = @Name_TB and  @Name_TB_2 = @Name_TB_2)
			     set @mess =  @n + ' - > ' +  ' Из таблицы ' + @Name_TB  + ' была перенесена секция  ' + isnull(CAST(Format(@Num_partition,'dd-MM-yyyy HH:mm:ss.fff') AS NVARCHAR(50)),'')
				     + ';  в таблицу ' + @Name_TB_2 + ' --> '+ ' - ' + Cast(@i as nvarchar(10)) + ' / ' + Cast(@s as nvarchar(10)) + CHAR(13) + CHAR(10) + ' '
			     RAISERROR(@mess,0,0) WITH NOWAIT



			end try
			begin catch
			      if xact_state() in (1, -1) -- Функция XACT_STATE сообщает о состоянии пользовательской транзакции текущего выполняемого запроса.
		              /*
		              1 : запрос внутри блока транзакции активен и действителен (не выдал ошибку).
                      0 : запрос не выдаст ошибку (например, запрос select внутри транзакции без запросов update / insert).
                      -1: Запрос внутри транзакции выдал ошибку (при вводе блока catch) и выполнит полный откат
					  (если у нас есть 4 успешных запроса и 1 выдает ошибку ,все 5 запросов будут откатаны ).
		              */
		                begin
                           ROLLBACK TRAN
		                end
                   SELECT 
                     ERROR_NUMBER() AS ErrorNumber,
                     ERROR_SEVERITY() AS ErrorSeverity,
                     ERROR_STATE() as ErrorState,
                     ERROR_PROCEDURE() as ErrorProcedure,
                     ERROR_LINE() as ErrorLine,
                     ERROR_MESSAGE() as ErrorMessage;
				   set @err = formatmessage(N'ID=%I64d, error - %s', @Name_TB, error_message());
                   print @err;
			end catch
		 fetch next from curs into @num,@Name_TB,@Name_TB_2,@flag 
	   end
close curs
deallocate curs


/*

SELECT 
 p.partition_id,
 p.partition_number,
 p.rows,
 prv.boundary_id as boundary_id,
 prv.value       as  partition_value,
 t.name          AS table_name,
 i.name          AS index_name,
 ps.name         as PARTITION_SCHEME,
 pf.name         as PARTITION_FUNCTION
FROM  sys.partitions p  
JOIN  sys.tables t                          ON p.object_id = t.object_id
JOIN  sys.indexes i                         ON p.object_id = i.object_id            AND p.index_id = i.index_id
JOIN  sys.partition_schemes ps              ON ps.data_space_id = i.data_space_id 
join  sys.partition_functions pf            ON pf.function_id = ps.function_id
left JOIN sys.partition_range_values  prv   on prv.function_id=pf.function_id       
and p.partition_number =  CASE pf.boundary_value_on_right 
                               WHEN 1 THEN prv.boundary_id + 1 
                          ELSE prv.boundary_id END       
WHERE  t.name not like '%_2%'  



SELECT 
 p.partition_id,
 p.partition_number,
 p.rows,
 prv.boundary_id as boundary_id,
 prv.value       as  partition_value,
 t.name          AS table_name,
 i.name          AS index_name,
 ps.name         as PARTITION_SCHEME,
 pf.name         as PARTITION_FUNCTION
FROM  sys.partitions p  
JOIN  sys.tables t                          ON p.object_id = t.object_id
JOIN  sys.indexes i                         ON p.object_id = i.object_id            AND p.index_id = i.index_id
JOIN  sys.partition_schemes ps              ON ps.data_space_id = i.data_space_id 
join  sys.partition_functions pf            ON pf.function_id = ps.function_id
left JOIN sys.partition_range_values  prv   on prv.function_id=pf.function_id       
and p.partition_number =  CASE pf.boundary_value_on_right 
                               WHEN 1 THEN prv.boundary_id + 1 
                          ELSE prv.boundary_id END       
WHERE  t.name  like '%_2%'  

--72057594048479232
*/

