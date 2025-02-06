
use Magaz_DB_Poln_Test
go
set nocount,xact_abort on
go

drop table if exists #t;

SELECT 
LEFT (o.name, len(o.name)-2)  as Name_TB, 
c.name as Name_Colm,
0 as flag
into #t
FROM sys.objects o
Inner JOIN  sys.columns c ON o.object_id = c.object_id
where 1 = 1 
and o.type = 'U' 
and o.name like '%_2%' 
and c.column_id = 2


declare @i int = 0, @s int = 0 , @n varchar(40), @mess varchar(8000), @err varchar(1000)

declare @Name_TB   nvarchar(100);
declare @Name_Colm nvarchar(100);  
declare @flag int;
declare @Data int;
declare @sql nvarchar(max);

declare mycur_Audit cursor local fast_forward read_only for

select * from #t


open mycur_Audit
fetch next from mycur_Audit into   @Name_TB,@Name_Colm,@flag

while @@FETCH_STATUS  = 0
               -- (0,-1,-2,-9) столбец fetch_status функции динамического управления sys.dm_exec_cursors
			   -- 0 Инструкция FETCH была выполнена успешно.
			   ---1	Выполнение инструкции FETCH завершилось неудачно или строка оказалась вне пределов результирующего набора.
			   ---2	Выбранная строка отсутствует.
			   --–9	Курсор не выполняет операцию выборки.
    begin
	  begin try
             set @sql = N'
		     with nums as 
             (
             select 0 n union all select 1 union all select 2union all select 3 union all select 4 union all select 5 
			 union all select 6 union all select 7 union all select 8 union all select 9 
             )
             insert into ' + QUOTENAME(@Name_TB) + '  
             (
             ' + QUOTENAME(@Name_Colm) + '
             ,ModifiedBy,ModifiedDate,Operation,ChangeDescription)
             select rn 
             ' + QUOTENAME(@Name_Colm) + '      
             ,cast(rn as nvarchar(128))
             ' + QUOTENAME(@Name_Colm) + '      
             , dateadd(hh, rn-1, ''20250101'') ModifiedBy, ''I'', ''dummy char column #'' + cast(rn as varchar)
             from
             (
             select row_number() over(order by (select (null))) rn
             from nums n1, nums n2, nums n3, nums n4, nums n5,nums n6, nums n7, nums n8
             ) t
             where rn < 40000
			 '
              exec sp_executesql @sql;

			  set @i =  @i + 1
			  if exists (select 
                         t2.TableName, 
                         sum(t2.RowCounts) as SumRows
                         from 
                         (SELECT 
                             t.name AS TableName,
                             p.rows AS RowCounts
                         FROM  sys.tables t
                         JOIN sys.schemas s ON t.schema_id = s.schema_id
                         JOIN sys.partitions p ON p.object_id = t.object_id
                         --WHERE  p.index_id IN (0, 1) -- 0 для хипов (heap), 1 для кластерных индексов
                         and t.name = @Name_TB and p.rows != 0 AND p.index_id = 1) as t2
                         GROUP BY  t2.TableName ) 
						 
                     begin 
					     update a set flag = 1 from #t  as a where Name_TB = @Name_TB and  @Name_Colm = Name_Colm and flag = 0
					 end;	
			   
		   set @Data = (select t3.SumRows from
			            (select
			            t2.TableName, sum(t2.RowCounts) as SumRows
			            from 
			            (SELECT 
			                t.name AS TableName,
			                p.rows AS RowCounts
			            FROM  sys.tables t
			            JOIN sys.schemas s ON t.schema_id = s.schema_id
			            JOIN sys.partitions p ON p.object_id = t.object_id
			            and t.name = @Name_TB and p.rows != 0 AND p.index_id = 1) as t2
			            GROUP BY  t2.TableName)  t3) 
			  select @s = count(0) from #t where flag = 0
			  set @n = (select  
			            case  t.flag  when 1 then ' 1  Значения изменены' when 0  then ' 0  Значения не изменялись' end  
			            from #t t  where Name_TB = @Name_TB and  @Name_Colm = Name_Colm)
			  set @mess = @n + ' - > ' +  ' В таблице ' + @Name_TB  + ' на текущий момент столько строк ' + ' --> ' +  cast(@Data as nvarchar(20)) + ' - ' + Cast(@i as varchar) + ' / ' + Cast(@s as varchar)
			  RAISERROR(@mess,0,0) WITH NOWAIT

       end try

	   begin catch
                if @@trancount > 0
                begin
                   rollback;
                end;
                 SELECT 
                     ERROR_NUMBER() AS ErrorNumber,
                     ERROR_SEVERITY() AS ErrorSeverity,
                     ERROR_STATE() as ErrorState,
                     ERROR_PROCEDURE() as ErrorProcedure,
                     ERROR_LINE() as ErrorLine,
                     ERROR_MESSAGE() as ErrorMessage;
                set @err = formatmessage(N'ID=%I64d, error - %s', @Name_TB, error_message());
                print @err;
       end catch;
            	   

	fetch next from mycur_Audit into @Name_TB,@Name_Colm,@flag
	
	end
		
close mycur_Audit
deallocate mycur_Audit
			
go				




--ALTER DATABASE Magaz_DB_2_Test
--MODIFY FILE (NAME = 'Log_Data_2', SIZE = 5000MB);
