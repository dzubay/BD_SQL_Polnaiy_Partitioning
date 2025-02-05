

begin tran 

CREATE TABLE Buyer_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_buyer               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group_2;


go

CREATE TRIGGER trg_Buyer_Audit ON Buyer
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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

							DECLARE @OldId_buyer                    bigint       ;
							DECLARE @OldID_Connection_Buyer         bigint       ;
							DECLARE @OldId_Status                   bigint       ;
							DECLARE @OldName                        nvarchar(100);
							DECLARE @OldSurName                     nvarchar(100);
							DECLARE @OldLastName                    nvarchar(100);
							DECLARE @OldMail                        nvarchar(250);
							DECLARE @OldPol                         char(1)      ;
							DECLARE @OldPhone                       nvarchar(30) ;
							DECLARE @OldDate_Of_Birth               datetime     ;
							DECLARE @OldDescription                 nvarchar(4000);
							
							DECLARE @NewId_buyer                    bigint       ;
							DECLARE @NewID_Connection_Buyer         bigint       ;
							DECLARE @NewId_Status                   bigint       ;
							DECLARE @NewName                        nvarchar(100);
							DECLARE @NewSurName                     nvarchar(100);
							DECLARE @NewLastName                    nvarchar(100);
							DECLARE @NewMail                        nvarchar(250);
							DECLARE @NewPol                         char(1)      ;
							DECLARE @NewPhone                       nvarchar(30) ;
							DECLARE @NewDate_Of_Birth               datetime     ;
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

                                        SELECT 
							                @OldId_buyer             = D.Id_buyer           , 
							            	@OldID_Connection_Buyer  = D.ID_Connection_Buyer,
							            	@OldId_Status            = D.Id_Status          ,
							            	@OldName                 = D.Name               ,
							            	@OldSurName              = D.SurName            ,
							            	@OldLastName             = D.LastName           ,
							            	@OldMail                 = D.Mail               ,
							            	@OldPol                  = D.Pol                ,
							            	@OldPhone                = D.Phone              ,
							            	@OldDate_Of_Birth        = D.Date_Of_Birth      ,
							            	@OldDescription          = D.[Description]        							
							            FROM Deleted D
										where @ID_entity_D = D.Id_buyer;

							            SELECT 
							                @NewId_buyer             = I.Id_buyer           , 
							            	@NewID_Connection_Buyer  = I.ID_Connection_Buyer,
							            	@NewId_Status            = I.Id_Status          ,
							            	@NewName                 = I.Name               ,
							            	@NewSurName              = I.SurName            ,
							            	@NewLastName             = I.LastName           ,
							            	@NewMail                 = I.Mail               ,
							            	@NewPol                  = I.Pol                ,
							            	@NewPhone                = I.Phone              ,
							            	@NewDate_Of_Birth        = I.Date_Of_Birth      ,
							            	@NewDescription          = I.[Description]        	
							            FROM inserted I									 
							            where @ID_entity_D = I.Id_buyer;


                                       IF @NewID_Connection_Buyer <> @OldID_Connection_Buyer 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Connection_Buyer = Old ->"' +  ISNULL(CAST(@OldID_Connection_Buyer AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Connection_Buyer AS NVARCHAR(50)),'') + '", ';
							              end
                                       
							           IF @NewId_Status <> @OldId_Status
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Status = Old ->"' +  ISNULL(CAST(@OldId_Status AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewId_Status AS NVARCHAR(50)),'') + '", ';
							              end
							           IF @NewName <> @OldName 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							              end
                                                                                               
							           IF @NewSurName <> @OldSurName 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SurName = Old ->"' +  ISNULL(@OldSurName,'') + ' " NEW -> " ' + isnull(@NewSurName,'') + '", ';
							              end
							           IF @NewLastName <> @OldLastName 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  LastName = Old ->"' +  ISNULL(@OldLastName,'') + ' " NEW -> " ' + isnull(@NewLastName,'') + '", ';
							              end
							           IF @NewMail <> @OldMail 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							              end
							           
							           IF @NewPol <> @OldPol 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Pol = Old ->"' +  ISNULL(CAST(@OldPol AS NVARCHAR(1)),'') + ' " NEW -> " ' + isnull(CAST(@NewPol AS NVARCHAR(1)),'') + '", ';
							              end
							           IF @NewPhone <> @OldPhone 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> " ' + isnull(@NewPhone,'') + '", ';
							              end
                           	           			
							           IF @NewDate_Of_Birth <> @OldDate_Of_Birth
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Birth = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end
							           
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' Id_buyer = "' +  isnull(cast(@OldId_buyer as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Buyer_Audit
                                        ( 
                                         Id_buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
							DECLARE @OldName_2                        nvarchar(100)	 ;
							DECLARE @OldSurName_2                     nvarchar(100)	 ;
							DECLARE @OldLastName_2                    nvarchar(100)	 ;
							DECLARE @OldMail_2                        nvarchar(250)	 ;
							DECLARE @OldPol_2                         char(1)      	 ;
							DECLARE @OldPhone_2                       nvarchar(30) 	 ;
							DECLARE @OldDate_Of_Birth_2               datetime     	 ;
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
                                            SELECT 
							                    @OldId_buyer_2             = D.Id_buyer           , 
							                	@OldID_Connection_Buyer_2  = D.ID_Connection_Buyer,
							                	@OldId_Status_2            = D.Id_Status          ,
							                	@OldName_2                 = D.Name               ,
							                	@OldSurName_2              = D.SurName            ,
							                	@OldLastName_2             = D.LastName           ,
							                	@OldMail_2                 = D.Mail               ,
							                	@OldPol_2                  = D.Pol                ,
							                	@OldPhone_2                = D.Phone              ,
							                	@OldDate_Of_Birth_2        = D.Date_Of_Birth      ,
							                	@OldDescription_2          = D.[Description]        
							                FROM deleted D									 
											where @ID_entity_D_2 = D.Id_buyer;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'Id_buyer'            +' = "'+  ISNULL(CAST(@OldId_buyer_2     AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Connection_Buyer' +' = "'+  ISNULL(CAST(@OldID_Connection_Buyer_2  AS NVARCHAR(50)),'') + '", '
							                + 'Id_Status'           +' = "'+  ISNULL(CAST(@OldId_Status_2 AS NVARCHAR(50)),'') + '", '
							                + 'Name'                +' = "'+  ISNULL(@OldName_2,'')+ '", '				
							                + 'SurName'             +' = "'+  ISNULL(@OldSurName_2,'')+ '", '
							                + 'LastName'            +' = "'+  ISNULL(@OldLastName_2,'') + '", '
							                + 'Mail'                +' = "'+  ISNULL(@OldMail_2,'')+ '", '
							                + 'Pol'                 +' = "'+  ISNULL(CAST(@OldPol_2 AS NVARCHAR(1)),'') 	   + '", '
							                + 'Phone'               +' = "'+  ISNULL(@OldPhone_2,'')+ '", '
							                + 'Date_Of_Birth'       +' = "'+  ISNULL(CAST(Format(@OldDate_Of_Birth_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Buyer_Audit
                                           ( 
                                            Id_buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'Id_buyer = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Buyer_Audit
                                       ( 
                                        Id_buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Costomers_Group_2;


go

CREATE TRIGGER trg_Buyer_status_Audit ON Buyer_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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


                                            IF @NewName <> @OldName 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							                   end
                                            
							                IF @NewSysTypeBuyerStatusName <> @OldSysTypeBuyerStatusName 
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeBuyerStatusName = Old ->"' +  ISNULL(@OldSysTypeBuyerStatusName,'') + ' " NEW -> " ' + isnull(@NewSysTypeBuyerStatusName,'') + '", ';
							                   end
                                                                                                    
                                            IF @NewDescription <> @OldDescription
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Status = "' +  isnull(cast(@OldId_Status as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
                                            INSERT  INTO dbo.Buyer_status_Audit
                                            ( 
                                             Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = null 

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
                                     
									       set @ChangeDescription = null

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
                                     SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Status = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                    
                                      INSERT  INTO dbo.Buyer_status_Audit
                                      ( 
                                       Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                      )
                                       SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = null              

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
) on Products_Group_2;


go

CREATE TRIGGER trg_Condition_of_the_item_Audit ON Condition_of_the_item
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
								  
                                           SELECT 
							                    @OldID_Condition_of_the_item       = D.ID_Condition_of_the_item     ,
							                	@OldName_Condition_of_the_item     = D.Name_Condition_of_the_item   ,
							                	@OldSysNameConditionTypeOfTheItem  = D.SysNameConditionTypeOfTheItem,
							                	@OldDescription                    = D.[Description]  					
							                FROM Deleted D
											where @ID_entity_D = D.ID_Condition_of_the_item;

							                SELECT 
							                    @NewID_Condition_of_the_item       = I.ID_Condition_of_the_item     ,
							                	@NewName_Condition_of_the_item     = I.Name_Condition_of_the_item   ,
							                	@NewSysNameConditionTypeOfTheItem  = I.SysNameConditionTypeOfTheItem,
							                	@NewDescription                    = I.[Description]        	  
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_Condition_of_the_item;																			 

                                           IF @NewID_Condition_of_the_item  <> @OldID_Condition_of_the_item  
							                  begin
                                               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Condition_of_the_item  = Old ->"' +  ISNULL(CAST(@OldID_Condition_of_the_item  AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Condition_of_the_item  AS NVARCHAR(20)),'') + '", ';
							                  end
                                           
							               IF @NewName_Condition_of_the_item <> @OldName_Condition_of_the_item
							                  begin
							                   SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Condition_of_the_item = Old ->"' +  ISNULL(@OldName_Condition_of_the_item,'') + ' " NEW -> "' + isnull(@NewName_Condition_of_the_item,'') + '", ';
							                  end
							               
							               IF @NewSysNameConditionTypeOfTheItem <> @OldSysNameConditionTypeOfTheItem
							                  begin
							                   SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysNameConditionTypeOfTheItem = Old ->"' +  ISNULL(@OldSysNameConditionTypeOfTheItem,'') + ' " NEW -> "' + isnull(@NewSysNameConditionTypeOfTheItem,'') + '", ';
							                  end                  
							               
                                           IF @NewDescription <> @OldDescription
							                  begin
                                               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                              end
                                           SET @ChangeDescription = 'Updated: ' + ' ID_Condition_of_the_item = "' +  isnull(cast(@OldID_Condition_of_the_item as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                            --Удаляем запятую на конце
                                           IF LEN(@ChangeDescription) > 0
                                               SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                           INSERT  INTO dbo.Condition_of_the_item_Audit
                                           ( 
                                            ID_Condition_of_the_item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                             SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									       set @ChangeDescription = null 
                                            
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

                                        SELECT 
							                @OldID_Condition_of_the_item_2      = D.ID_Condition_of_the_item     ,
							            	@OldName_Condition_of_the_item_2    = D.Name_Condition_of_the_item   ,
							            	@OldSysNameConditionTypeOfTheItem_2 = D.SysNameConditionTypeOfTheItem,
							            	@OldDescription_2                   = D.[Description]        
							            FROM deleted D									 
							            where @ID_entity_D_2 = D.ID_Condition_of_the_item

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_Condition_of_the_item'      +' = "'+  ISNULL(CAST(@OldID_Condition_of_the_item_2 AS NVARCHAR(20)),'')+ '", '
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
                                     
									    set @ChangeDescription = null
                                     
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
                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Condition_of_the_item = "' + CAST(@ID_entity_D_2 AS NVARCHAR(20)) + '" ';
                                     
									 INSERT  INTO dbo.Condition_of_the_item_Audit
                                     ( 
                                      ID_Condition_of_the_item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null
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
) on Costomers_Group_2;


go

CREATE TRIGGER trg_Connection_Buyer_Audit ON Connection_Buyer
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
						   DECLARE @OldDate_Сreated       	datetime      	;
						   DECLARE @OldDescription      	nvarchar(1000)	;


						   DECLARE @NewID_Connection_Buyer  bigint          ;
						   DECLARE @NewPassword           	nvarchar(50)  	;
						   DECLARE @NewLogin              	nvarchar(100) 	;
						   DECLARE @NewDate_Сreated       	datetime      	;
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
								        SELECT 
                                              @OldID_Connection_Buyer = D.ID_Connection_Buyer,
							            	  @OldPassword            = D.Password           ,
							            	  @OldLogin               = D.Login              ,
							            	  @OldDate_Сreated        = D.Date_Сreated       ,
							            	  @OldDescription      	  = D.[Description]      	
							            FROM Deleted D
										where @ID_entity_D = D.ID_Connection_Buyer 

							            SELECT 
                                              @NewID_Connection_Buyer = I.ID_Connection_Buyer,
							            	  @NewPassword            = I.Password           ,
							            	  @NewLogin               = I.Login              ,
							            	  @NewDate_Сreated        = I.Date_Сreated       ,
							            	  @NewDescription      	  = I.[Description]      	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Connection_Buyer
																	 

                                        IF @NewPassword <> @OldPassword 
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Password = Old ->"' +  ISNULL(@OldPassword,'') + ' " NEW -> " ' + isnull(@NewPassword,'') + '", ';
							               end
                                        
							            IF @NewLogin <> @OldLogin 
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Login = Old ->"' +  ISNULL(@OldLogin,'') + ' " NEW -> " ' + isnull(@NewLogin,'') + '", ';
							               end
							            IF @NewDate_Сreated <> @OldDate_Сreated
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Сreated = Old ->"' +  ISNULL(CAST(Format(@OldDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
                                                                                                
                                        IF @NewDescription <> @OldDescription
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                           end
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Connection_Buyer = "' +  isnull(cast(@OldID_Connection_Buyer as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                             			INSERT  INTO dbo.Connection_Buyer_Audit
                                        ( 
                                         ID_Connection_Buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                        SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = null
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
							 DECLARE @OldDate_Сreated_2       	datetime      	;
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

							            SELECT 
                                              @OldID_Connection_Buyer_2	   = D.ID_Connection_Buyer  ,
							            	  @OldPassword_2           	   = D.Password             ,
							            	  @OldLogin_2              	   = D.Login                ,
							            	  @OldDate_Сreated_2       	   = D.Date_Сreated         ,
							            	  @OldDescription_2            = D.[Description]      	  
							            FROM deleted D
										where @ID_entity_D_2 = D.ID_Connection_Buyer

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_Connection_Buyer'  +' = "'+  ISNULL(CAST(@OldID_Connection_Buyer_2  AS NVARCHAR(50)),'')+ '", '
							            + 'Password'             +' = "'+  ISNULL(@OldPassword_2,'')+ '", '
							            + 'Login'                +' = "'+  ISNULL(@OldLogin_2,'')+ '", '
							            + 'Date_Сreated'         +' = "'+  ISNULL(CAST(Format(@OldDate_Сreated_2,'yyyy-MM-dd HH:mm:ss.fff')AS NVARCHAR(50)),'')+ '", '
							            + '[Description]'        +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                          
						               IF LEN(@ChangeDescription) > 0
                                             SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                       INSERT  INTO dbo.Connection_Buyer_Audit
                                       ( 
                                        ID_Connection_Buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
                                   SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Connection_Buyer = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                   
								   INSERT  INTO dbo.Connection_Buyer_Audit
                                   ( 
                                    ID_Connection_Buyer,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                   )
                                    SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null

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
)on Orders_Group_2 ;

go

CREATE TRIGGER trg_Currency_Audit ON Currency
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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

								 SELECT 
								     @OldID_Currency       =   ID_Currency     ,
									 @OldFull_name_rus     =   Full_name_rus   ,
									 @OldFull_name_eng     =   Full_name_eng   ,
									 @OldAbbreviation_rus  =   Abbreviation_rus,
									 @OldAbbreviation_eng  =   Abbreviation_eng,
									 @OldDescription       =   [Description]     
								 FROM   Deleted D 
								 where @ID_entity_D = D.ID_Currency 

								 SELECT 
								     @NewID_Currency       =   ID_Currency     ,
								 	 @NewFull_name_rus     =   Full_name_rus   ,
								 	 @NewFull_name_eng     =   Full_name_eng   ,
								 	 @NewAbbreviation_rus  =   Abbreviation_rus,
								 	 @NewAbbreviation_eng  =   Abbreviation_eng,
								 	 @NewDescription       =   [Description]    
								 FROM   Deleted D 
								 where @ID_entity_D = D.ID_Currency 


                         
                            IF @NewFull_name_rus <> @OldFull_name_rus 
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Full_name_rus = Old ->"' +  ISNULL(@OldFull_name_rus,'') + ' " NEW -> " ' + isnull(@NewFull_name_rus,'') + '", ';
							   end
                            IF @NewFull_name_eng <> @OldFull_name_eng
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Full_name_eng = Old ->"' + ISNULL(@OldFull_name_eng,'') + ' " NEW -> "' + ISNULL(@NewFull_name_eng,'') + '", ';
							   end

                            IF @NewAbbreviation_rus <> @OldAbbreviation_rus 
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Abbreviation_rus = Old ->"' +  ISNULL(@OldAbbreviation_rus,'') + ' " NEW -> " ' + isnull(@NewAbbreviation_rus,'') + '", ';
							   end
                            IF @NewAbbreviation_eng <> @OldAbbreviation_eng
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Abbreviation_eng = Old ->"' + ISNULL(@OldAbbreviation_eng,'') + ' " NEW -> "' + ISNULL(@NewAbbreviation_eng,'') + '", ';
							   end

                            IF @NewDescription <> @OldDescription
							   begin
                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                               end
                            SET @ChangeDescription = 'Updated: ' + ' ID_Currency = "' +  isnull(cast(@OldID_Currency as nvarchar(20)),'')+ '" ' + @ChangeDescription
                             --Удаляем запятую на конце
                            IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                            INSERT  INTO dbo.Currency_Audit
                                     ( 
                                      ID_Currency,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
							set @ChangeDescription = null 
                            
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
                                                + 'ID_Currency'      +' = "'+ ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(20)), '') + '", '
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
									    
									   set @ChangeDescription = null
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

		            
                                   SET @ChangeDescription = 'Inserted: '
                                              + 'ID_Currency = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                   
								   INSERT  INTO dbo.Currency_Audit
                                     ( 
                                      ID_Currency,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null

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
) on Products_Group_2;


go

CREATE TRIGGER trg_Currency_Rate_Audit ON Currency_Rate
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldAmount_Rate             float        	;
							DECLARE @OldValid_from              datetime     	;
							DECLARE @OldValid_to                datetime     	;
							DECLARE @OldJSON_Currency_Rate_Data nvarchar(max)	;
							DECLARE @OldDescription             nvarchar(4000)	;

							DECLARE @NewID_Currency_Rate        bigint          ;
							DECLARE @NewID_Currency             bigint       	;
							DECLARE @NewAmount_Rate             float        	;
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


                                            IF @NewID_Currency <> @OldID_Currency 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(cast(@OldID_Currency as nvarchar(20)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Currency as nvarchar(20)),'') + '", ';
							                   end
                                            
							                IF @NewAmount_Rate <> @OldAmount_Rate
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Amount_Rate = Old ->"' +  ISNULL(cast(@OldAmount_Rate as nvarchar(20)),'') + ' " NEW -> " ' + isnull(cast(@NewAmount_Rate as nvarchar(20)),'') + '", ';
							                   end
							                
							                   				
							                IF @NewValid_from <> @OldValid_from
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Valid_from = Old ->"' +  ISNULL(CAST(Format(@OldValid_from,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewValid_from,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
							                						   				
							                IF @NewValid_to <> @OldValid_to
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Valid_to = Old ->"' +  ISNULL(CAST(Format(@OldValid_to,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewValid_to,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
							                IF @NewJSON_Currency_Rate_Data <> @OldJSON_Currency_Rate_Data
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  JSON_Currency_Rate_Data = Old ->"' +  ISNULL(CAST(@OldAmount_Rate AS NVARCHAR(max)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmount_Rate AS NVARCHAR(max)),'') + '", ';
							                   end
							                
                                            IF @NewDescription <> @OldDescription
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_Currency_Rate = "' +  isnull(cast(@OldID_Currency_Rate as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                             INSERT  INTO dbo.Currency_Rate_Audit
                                             ( 
                                              ID_Currency_Rate,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                             )
                                               SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									         set @ChangeDescription = null
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
							DECLARE @OldAmount_Rate_2             float        	  ;
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
                                     
									       set @ChangeDescription = null

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
                                       SET @ChangeDescription = 'Inserted: '
                                              + 'ID_Currency_Rate = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';

									   INSERT  INTO dbo.Currency_Rate_Audit
                                        ( 
                                         ID_Currency_Rate,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									    set @ChangeDescription = null
                                        
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
) on Orders_Group_2;


go

CREATE TRIGGER trg_Data_Orders_Audit ON Data_Orders
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
																	 
                                         IF @NewID_Employee <> @OldID_Employee
							                begin
                                             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Employee = Old ->"' +  ISNULL(CAST(@OldID_Employee AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Employee AS NVARCHAR(20)),'') + '", ';
							                end
                                         
							             IF @NewID_Orders <> @OldID_Orders
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Orders = Old ->"' +  ISNULL(CAST(@OldID_Orders AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Orders AS NVARCHAR(20)),'') + '", ';
							                end
							             IF @NewId_buyer <> @OldId_buyer 
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_buyer = Old ->"' +  ISNULL(cast(@OldId_buyer AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(cast(@NewId_buyer AS NVARCHAR(20)),'') + '", ';
							                end
                                                                                                 
							             IF @NewID_Exemplar <> @OldID_Exemplar 
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Exemplar = Old ->"' +  ISNULL(cast(@OldID_Exemplar AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Exemplar AS NVARCHAR(20)),'') + '", ';
							                end
							             IF @NewID_Transaction <> @OldID_Transaction 
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Transaction = Old ->"' +  ISNULL(CAST(@OldID_Transaction AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Transaction AS NVARCHAR(20)),'') + '", ';
							                end
							             
							             IF @NewDate_Data_Orders <> @OldDate_Data_Orders
							                begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Data_Orders = Old ->"' +  ISNULL(CAST(Format(@OldDate_Data_Orders,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Data_Orders,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                end
							             
                                         IF @NewDescription <> @OldDescription
							                begin
                                             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                            end
                                         SET @ChangeDescription = 'Updated: ' + ' Id_Data_Orders = "' +  isnull(cast(@OldId_Data_Orders as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                          --Удаляем запятую на конце
                                         IF LEN(@ChangeDescription) > 0
                                             SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                         INSERT  INTO dbo.Data_Orders_Audit
                                         ( 
                                          Id_Data_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                           SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									     set @ChangeDescription = null  
										 

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
							                + 'Id_Data_Orders'     +' = "'+  ISNULL(CAST(@OldId_Data_Orders_2 AS NVARCHAR(20)),'')     + '", '
							                + 'ID_Employee'        +' = "'+  ISNULL(CAST(@OldID_Employee_2 AS NVARCHAR(20)),'')     + '", '
							                + 'ID_Orders'          +' = "'+  ISNULL(CAST(@OldID_Orders_2 AS NVARCHAR(20)),'')     + '", '
							                + 'Id_buyer'           +' = "'+  ISNULL(CAST(@OldId_buyer_2 AS NVARCHAR(20)),'')     + '", '
							                + 'ID_Exemplar'        +' = "'+  ISNULL(CAST(@OldID_Exemplar_2 AS NVARCHAR(20)),'')     + '", '
							                + 'ID_Transaction'     +' = "'+  ISNULL(CAST(@OldID_Transaction_2 AS NVARCHAR(20)),'')     + '", '
							                + 'Date_Data_Orders'   +' = "'+  ISNULL(CAST(Format(@OldDate_Data_Orders_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Description'        +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

						                    IF LEN(@ChangeDescription) > 0
                                                    SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                            INSERT  INTO dbo.Data_Orders_Audit
                                            ( 
                                             Id_Data_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                             SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									        set @ChangeDescription = null 
											
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

                                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Data_Orders = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                    
                                    INSERT  INTO dbo.Data_Orders_Audit
                                     ( 
                                      Id_Data_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null              
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
) on Products_Group_2;


go

CREATE TRIGGER trg_Exemplar_Audit ON Exemplar
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
						   DECLARE @OldOld_Price_no_NDS           float          ;
						   DECLARE @OldRefund                     bit            ;
						   DECLARE @OldDate_Refund                datetime       ;
						   DECLARE @OldReturn_Note                nvarchar(4000) ;
						   DECLARE @OldOld_Price_NDS              float          ;
						   DECLARE @OldJSON_Size_Volume           nvarchar(max)  ;
						   DECLARE @OldNew_Price_NDS              float          ;
						   DECLARE @OldNew_Price_no_NDS           float          ;
						   DECLARE @OldDate_Сreated               datetime       ;
						   DECLARE @OldDescription                nvarchar(4000) ;

						   DECLARE @NewID_Exemplar                bigint         ;
						   DECLARE @NewId_Item                    bigint         ;
						   DECLARE @NewID_Currency                bigint         ;
						   DECLARE @NewID_Storage_location        bigint         ;
						   DECLARE @NewKeySource                  bigint         ;
						   DECLARE @NewSerial_number              nvarchar(500)  ;
						   DECLARE @NewID_Condition_of_the_item   bigint         ;
						   DECLARE @NewOld_Price_no_NDS           float          ;
						   DECLARE @NewRefund                     bit            ;
						   DECLARE @NewDate_Refund                datetime       ;
						   DECLARE @NewReturn_Note                nvarchar(4000) ;
						   DECLARE @NewOld_Price_NDS              float          ;
						   DECLARE @NewJSON_Size_Volume           nvarchar(max)  ;
						   DECLARE @NewNew_Price_NDS              float          ;
						   DECLARE @NewNew_Price_no_NDS           float          ;
						   DECLARE @NewDate_Сreated               datetime       ;
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
							            	@OldDate_Сreated                = D.Date_Сreated            , 
							            	@OldDescription                 = D.[Description]        	  					
							            FROM Deleted D																		 
										where @ID_entity_D = D.ID_Exemplar;
								       
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
							            	@NewDate_Сreated                = I.Date_Сreated            ,
							            	@NewDescription                 = I.[Description]        	  
							            FROM inserted I
										where @ID_entity_D = I.ID_Exemplar;	


                                          IF @NewId_Item  <> @OldId_Item  
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Item  = Old ->"' +  ISNULL(CAST(@OldId_Item  AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewId_Item  AS NVARCHAR(20)),'') + '", ';
							                 end
                                          
							              IF @NewID_Currency <> @OldID_Currency
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(CAST(@OldID_Currency AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Currency AS NVARCHAR(20)),'') + '", ';
							                 end
							              
							              IF @NewID_Storage_location <> @OldID_Storage_location
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Storage_location = Old ->"' +  ISNULL(CAST(@OldID_Storage_location AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Storage_location AS NVARCHAR(20)),'') + '", ';
							                 end                  
							              
							              IF @NewKeySource <> @OldKeySource
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  KeySource = Old ->"' +  ISNULL(CAST(@OldKeySource AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewKeySource AS NVARCHAR(20)),'') + '", ';
							                 end
							              
							              IF @NewSerial_number <> @OldSerial_number
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Serial_number = Old ->"' +  ISNULL(@OldSerial_number,'') + ' " NEW -> "' + isnull(@NewSerial_number,'') + '", ';
							                 end
							              
							              IF @NewID_Condition_of_the_item <> @OldID_Condition_of_the_item
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Condition_of_the_item = Old ->"' +  ISNULL(CAST(@OldID_Condition_of_the_item AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Condition_of_the_item AS NVARCHAR(20)),'') + '", ';
							                 end
							              
							              IF @NewOld_Price_no_NDS <> @OldOld_Price_no_NDS
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Old_Price_no_NDS = Old ->"' +  ISNULL(CAST(@OldOld_Price_no_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewOld_Price_no_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
							              
                                          IF @NewRefund <> @OldRefund
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Refund = Old ->"' +  ISNULL(CAST(@OldRefund AS NVARCHAR(1)),'') + ' " NEW -> "' + isnull(CAST(@NewRefund AS NVARCHAR(1)),'') + '", ';
							                 end
							              
                                          IF @NewDate_Refund <> @OldDate_Refund
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Refund = Old ->"' +  ISNULL(CAST(Format(@OldDate_Refund,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Refund,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                 end
                                          -----
							              IF @NewReturn_Note <> @OldReturn_Note
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Return_Note = Old ->"' +  ISNULL(@OldReturn_Note,'') + ' " NEW -> "' + isnull(@NewReturn_Note,'') + '", ';
							                 end
                                          
							              IF @NewOld_Price_NDS <> @OldOld_Price_NDS
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Old_Price_NDS = Old ->"' +  ISNULL(CAST(@OldOld_Price_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewOld_Price_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF @NewJSON_Size_Volume <> @OldJSON_Size_Volume
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  JSON_Size_Volume = Old ->"' +  ISNULL(CAST(@OldJSON_Size_Volume AS NVARCHAR(max)),'') + ' " NEW -> "' + isnull(CAST(@NewJSON_Size_Volume AS NVARCHAR(max)),'') + '", ';
							                 end
                                          
							              IF @NewNew_Price_NDS <> @OldNew_Price_NDS
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  New_Price_NDS = Old ->"' +  ISNULL(CAST(@OldNew_Price_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewNew_Price_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
							              
							              IF @NewNew_Price_no_NDS <> @OldNew_Price_no_NDS
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  New_Price_no_NDS = Old ->"' +  ISNULL(CAST(@OldNew_Price_no_NDS AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewNew_Price_no_NDS AS NVARCHAR(50)),'') + '", ';
							                 end
                                          
							              IF @NewDate_Сreated <> @OldDate_Сreated
							                 begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Сreated = Old ->"' +  ISNULL(CAST(Format(@OldDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                 end
							              
                                          IF @NewDescription <> @OldDescription
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                             end
                                          SET @ChangeDescription = 'Updated: ' + ' ID_Exemplar = "' +  isnull(cast(@OldID_Exemplar as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                           --Удаляем запятую на конце
                                          IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                          INSERT  INTO dbo.Exemplar_Audit
                                          ( 
                                           ID_Exemplar,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									      set @ChangeDescription = null 
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
						   DECLARE @OldOld_Price_no_NDS_2           float          ;
						   DECLARE @OldRefund_2                     bit            ;
						   DECLARE @OldDate_Refund_2                datetime       ;
						   DECLARE @OldReturn_Note_2                nvarchar(4000) ;
						   DECLARE @OldOld_Price_NDS_2              float          ;
						   DECLARE @OldJSON_Size_Volume_2           nvarchar(max)  ;
						   DECLARE @OldNew_Price_NDS_2              float          ;
						   DECLARE @OldNew_Price_no_NDS_2           float          ;
						   DECLARE @OldDate_Сreated_2               datetime       ;
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
							                	@OldDate_Сreated_2                = D.Date_Сreated             ,
							                	@OldDescription_2                 = D.[Description]        
							                FROM deleted D	
											where @ID_entity_D_2 = D.ID_Exemplar

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Exemplar'             +' = "'+  ISNULL(CAST(@OldID_Exemplar_2     AS NVARCHAR(20)),'')+ '", '
							                + 'Id_Item'                 +' = "'+  ISNULL(CAST(@OldId_Item_2  AS NVARCHAR(20)),'')+ '", '
							                + 'ID_Currency'             +' = "'+  ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(20)),'') + '", '
							                + 'ID_Storage_location'     +' = "'+  ISNULL(CAST(@OldID_Storage_location_2 AS NVARCHAR(20)),'') + '", '
							                + 'KeySource'               +' = "'+  ISNULL(CAST(@OldKeySource_2 AS NVARCHAR(50)),'')+ '", '				
							                + 'Serial_number'           +' = "'+  ISNULL(@OldSerial_number_2,'')+ '", '
							                + 'ID_Condition_of_the_item'+' = "'+  ISNULL(CAST(@OldID_Condition_of_the_item_2 AS NVARCHAR(20)),'') + '", '
							                + 'Old_Price_no_NDS'        +' = "'+  ISNULL(CAST(@OldOld_Price_no_NDS_2 AS NVARCHAR(50)),'')+ '", '
							                + 'Refund'                  +' = "'+  ISNULL(CAST(@OldRefund_2 AS NVARCHAR(1)),'') + '", '
							                + 'Date_Refund'             +' = "'+  ISNULL(CAST(Format(@OldDate_Refund_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Return_Note'             +' = "'+  ISNULL(@OldReturn_Note_2,'')+ '", '
							                + 'Old_Price_NDS'           +' = "'+  ISNULL(CAST(@OldOld_Price_NDS_2 AS NVARCHAR(50)),'') + '", '
							                + 'JSON_Size_Volume'        +' = "'+  ISNULL(CAST(@OldJSON_Size_Volume_2 AS NVARCHAR(MAX)),'') + '", '
							                + 'New_Price_NDS'           +' = "'+  ISNULL(CAST(@OldNew_Price_NDS_2 AS NVARCHAR(50)),'') + '", '
							                + 'New_Price_no_NDS'        +' = "'+  ISNULL(CAST(@OldNew_Price_no_NDS_2 AS NVARCHAR(50)),'') + '", '
							                + 'Date_Сreated'            +' = "'+  ISNULL(CAST(Format(@OldDate_Сreated_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
            				                + 'Description'             +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

							               IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Exemplar_Audit
                                           ( 
                                            ID_Exemplar,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = null     
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
                                        SET @ChangeDescription = 'Inserted: '
                                               + 'ID_Exemplar = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                        
										 INSERT  INTO dbo.Exemplar_Audit
                                         ( 
                                          ID_Exemplar,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                          SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									     set @ChangeDescription = null
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
) on Products_Group_2;


go

CREATE TRIGGER trg_Item_Audit ON Item
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
						   DECLARE @OldDate_Сreated                datetime       	;
						   DECLARE @OldQuantity                    int              ;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

                           DECLARE @NewId_Item                     bigint         	;
						   DECLARE @NewID_product_measurement      bigint         	;
						   DECLARE @NewID_TypeItem                 bigint         	;
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
						   DECLARE @NewDate_Сreated                datetime       	;
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
						   
                         
							                SELECT  
							                        @NewId_Item                    =  I.Id_Item                ,
							                		@NewID_product_measurement	   =  I.ID_product_measurement ,
							                		@NewID_TypeItem           	   =  I.ID_TypeItem            ,
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
							                		@NewDate_Сreated          	   =  I.Date_Сreated           ,
							                		@NewQuantity                   =  I.Quantity               ,
							                		@NewDescription                =  I.[Description]         	
							                FROM inserted I									 
											where @ID_entity_D = I.Id_Item;
							
							                SELECT 
							                        @oldId_Item                    =  D.Id_Item                ,
							                		@oldID_product_measurement	   =  D.ID_product_measurement ,
							                		@oldID_TypeItem           	   =  D.ID_TypeItem            ,
							                		@oldArticle_number        	   =  D.Article_number         ,
							                		@oldName_Item             	   =  D.Name_Item              ,
							                		@oldImage_Item            	   =  D.Image_Item             ,
							                		@oldManufacturer          	   =  D.Manufacturer           ,
							                		@oldCountry               	   =  D.Country                ,
							                		@oldCity                  	   =  D.City                   ,
							                		@oldAdress                	   =  D.Adress                 ,
							                		@oldMail                  	   =  D.Mail                   ,
							                		@oldPhone                 	   =  D.Phone                  ,
							                		@oldLogo                  	   =  D.Logo                   ,
							                		@oldDate_Сreated          	   =  D.Date_Сreated           ,
							                		@oldQuantity                   =  D.Quantity               ,
							                		@OldDescription                =  D.[Description]         								
							                FROM Deleted D
											where @ID_entity_D = D.Id_Item;

                                            IF @NewID_product_measurement <> @OldID_product_measurement
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_product_measurement = Old ->"' +  ISNULL(CAST(@OldID_product_measurement AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_product_measurement AS NVARCHAR(20)),'') + '", ';
							                   end
                                            
							                IF @NewID_TypeItem <> @OldID_TypeItem
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_TypeItem = Old ->"' +  ISNULL(CAST(@OldID_TypeItem AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_TypeItem AS NVARCHAR(20)),'') + '", ';
							                   end
					                        
							                IF @NewArticle_number <> @OldArticle_number
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Article_number = Old ->"' +  ISNULL(@OldArticle_number,'') + ' " NEW -> " ' + isnull(@NewArticle_number,'') + '", ';
							                   end
					                        
							                IF @NewName_Item <> @OldName_Item
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Item = Old ->"' +  ISNULL(@OldName_Item,'') + ' " NEW -> " ' + isnull(@NewName_Item,'') + '", ';
							                   end
					                        
							                IF @NewImage_Item <> @OldImage_Item
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Image_Item = '  +  '"Изображение было изменено или удалено", ';
							                   end
					                        
							                IF @NewManufacturer <> @OldManufacturer
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Manufacturer = Old ->"' +  ISNULL(@OldManufacturer,'') + ' " NEW -> " ' + isnull(@NewManufacturer,'') + '", ';
							                   end
					                        
							                IF @NewCountry <> @OldCountry
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Country = Old ->"' +  ISNULL(@OldCountry,'') + ' " NEW -> " ' + isnull(@NewCountry,'') + '", ';
							                   end
					                        
							                IF @NewCity <> @OldCity
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  City = Old ->"' +  ISNULL(@OldCity,'') + ' " NEW -> " ' + isnull(@NewCity,'') + '", ';
							                   end
					                        
							                IF @NewAdress <> @OldAdress
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Adress = Old ->"' +  ISNULL(@OldAdress,'') + ' " NEW -> " ' + isnull(@NewAdress,'') + '", ';
							                   end
					                        
							                IF @NewMail <> @OldMail
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							                   end
					                        
							                IF @NewPhone <> @OldPhone
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> " ' + isnull(@NewPhone,'') + '", ';
							                   end
					                        
							                IF @NewLogo <> @OldLogo
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Logo = ' +  '"Изображение было изменено или удалено", ';
							                   end
							                
							                IF @NewDate_Сreated <> @OldDate_Сreated
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Сreated = Old ->"' +  ISNULL(CAST(Format(@OldDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
					                        IF @NewQuantity <> @OldQuantity
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Quantity = Old ->"' +  ISNULL(CAST(@OldQuantity AS NVARCHAR(20)),'') + ' " NEW -> " ' + isnull(CAST(@NewQuantity AS NVARCHAR(20)),'') + '", ';
							                   end
                                            
							                
                                            IF @NewDescription <> @OldDescription
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' Id_Item = "' +  isnull(cast(@OldId_Item as nvarchar(20)),'')+ '" ' + @ChangeDescription + '"'
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                             INSERT  INTO dbo.Item_Audit
                                             ( 
                                              Id_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                             )
                                               SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                             
									         set @ChangeDescription = null 
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
						   DECLARE @OldDate_Сreated_2                  datetime       ;
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
                                                SELECT 
                                                    @OldId_Item_2                   = D.Id_Item               ,
							                    	@OldID_product_measurement_2    = D.ID_product_measurement,
							                    	@OldID_TypeItem_2               = D.ID_TypeItem           ,
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
							                    	@OldDate_Сreated_2              = D.Date_Сreated          ,
							                    	@OldQuantity_2                  = D.Quantity              ,        
							                    	@OldDescription_2               = D.[Description]        
							                    FROM deleted D
												where @ID_entity_D_2 = D.Id_Item;

                                                SET @ChangeDescription = 'Deleted: '
							                    + 'Id_Item'                +' = "'+  ISNULL(CAST(@OldId_Item_2 AS NVARCHAR(20)),'')+ '", '
							                    + 'ID_product_measurement' +' = "'+  ISNULL(CAST(@OldID_product_measurement_2 AS NVARCHAR(20)),'')+ '", '
							                    + 'ID_TypeItem'            +' = "'+  ISNULL(CAST(@OldID_TypeItem_2 AS NVARCHAR(20)),'')+ '", '
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
							                    + 'Date_Сreated'           +' = "'+  ISNULL(CAST(Format(@OldDate_Сreated_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'')+ '", '
							                    + 'Quantity'               +' = "'+  ISNULL(CAST(@OldQuantity_2 AS NVARCHAR(20)),'')+ '", '
							                    + 'Description'            +' = "'+  ISNULL(@OldDescription_2  ,'')+ '"'

                                                IF LEN(@ChangeDescription) > 0
                                                      SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                                
												INSERT  INTO dbo.Item_Audit
                                                ( 
                                                 Id_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                                )
                                                 SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									             set @ChangeDescription = null
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
		            
                                         SET @ChangeDescription = 'Inserted: '
                                                    + 'Id_Item = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                    
                                         INSERT  INTO dbo.Item_Audit
                                         ( 
                                          Id_Item,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                          SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									     set @ChangeDescription = null    
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
) on Orders_Group_2;


go

CREATE TRIGGER trg_Orders_Audit ON Orders
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
	                       
						   DECLARE @OldID_Orders        bigint              ;
						   DECLARE @OldID_status        bigint        		;
						   DECLARE @OldID_TypeOrders    bigint        		;
						   DECLARE @OldID_Currency      bigint        		;
						   DECLARE @OldDate             datetime      		;
						   DECLARE @OldPayment_Date     datetime      		;
						   DECLARE @OldAmount           float         		;
						   DECLARE @OldAmountCurr       float         		;
						   DECLARE @OldAmountNDS        float         		;
						   DECLARE @OldAmountCurrNDS    float         		;
						   DECLARE @OldNum              nvarchar(50)  		;
						   DECLARE @OldDescription      nvarchar(4000)		;


						   DECLARE @NewID_Orders        bigint              ;
						   DECLARE @NewID_status        bigint        		;
						   DECLARE @NewID_TypeOrders    bigint        		;
						   DECLARE @NewID_Currency      bigint        		;
						   DECLARE @NewDate             datetime      		;
						   DECLARE @NewPayment_Date     datetime      		;
						   DECLARE @NewAmount           float         		;
						   DECLARE @NewAmountCurr       float         		;
						   DECLARE @NewAmountNDS        float         		;
						   DECLARE @NewAmountCurrNDS    float         		;
						   DECLARE @NewNum              nvarchar(50)  		;
						   DECLARE @NewDescription      nvarchar(4000)		;
						
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

							            SELECT 
							                   @OldID_Orders      =  D.ID_Orders        ,
							            	   @OldID_status      =  D.ID_status    	,
							            	   @OldID_TypeOrders  =  D.ID_TypeOrders	,
							            	   @OldID_Currency    =  D.ID_Currency  	,
							            	   @OldDate           =  D.Date             ,       --convert(datetime,Date,109),
							            	   @OldPayment_Date   =  D.Payment_Date     ,       --convert(datetime,Payment_Date,109),
							            	   @OldAmount         =  D.Amount       	,
							            	   @OldAmountCurr     =  D.AmountCurr   	,
							            	   @OldAmountNDS      =  D.AmountNDS    	,
							            	   @OldAmountCurrNDS  =  D.AmountCurrNDS	,
							            	   @OldNum            =  D.Num          	,
							            	   @OldDescription    =  D.[Description]  
							            FROM Deleted D																		 
										where @ID_entity_D = D.ID_Orders

										SELECT 
                                               @NewID_Orders      =  I.ID_Orders        ,
							            	   @NewID_status      =  I.ID_status    	,
							            	   @NewID_TypeOrders  =  I.ID_TypeOrders	,
							            	   @NewID_Currency    =  I.ID_Currency  	,
							            	   @NewDate           =  I.Date             ,         --convert(datetime,Date,109),     
							            	   @NewPayment_Date   =  I.Payment_Date     ,         --convert(datetime,Payment_Date,109),
							            	   @NewAmount         =  I.Amount       	,
							            	   @NewAmountCurr     =  I.AmountCurr   	,
							            	   @NewAmountNDS      =  I.AmountNDS    	,
							            	   @NewAmountCurrNDS  =  I.AmountCurrNDS	,
							            	   @NewNum            =  I.Num          	,
							            	   @NewDescription    =  I.[Description]  
							            FROM inserted I									 
										where @ID_entity_D = I.ID_Orders


                                        IF @NewID_status <> @OldID_status 
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_status = Old ->"' +  ISNULL(CAST(@OldID_status AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_status AS NVARCHAR(50)),'') + '", ';
							               end
                                        
							            IF @NewID_TypeOrders <> @OldID_TypeOrders 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_TypeOrders = Old ->"' +  ISNULL(CAST(@OldID_TypeOrders AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_TypeOrders AS NVARCHAR(50)),'') + '", ';
							               end
							            IF @NewID_Currency <> @OldID_Currency 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(CAST(@OldID_Currency AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Currency AS NVARCHAR(50)),'') + '", ';
							               end
                                                                                                
							            IF @NewDate <> @OldDate 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date = Old ->"' +  ISNULL(CAST(Format(@OldDate,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
							            IF @NewPayment_Date <> @OldPayment_Date 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Payment_Date = Old ->"' +  ISNULL(CAST(Format(@OldPayment_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewPayment_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
							            IF @NewAmount <> @OldAmount 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Amount = Old ->"' +  ISNULL(CAST(@OldAmount AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmount AS NVARCHAR(50)),'') + '", ';
							               end
							            
							            IF @NewAmountCurr <> @OldAmountCurr 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  AmountCurr = Old ->"' +  ISNULL(CAST(@OldAmountCurr AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmountCurr AS NVARCHAR(50)),'') + '", ';
							               end
							            IF @NewAmountNDS <> @OldAmountNDS 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  AmountNDS = Old ->"' +  ISNULL(CAST(@OldAmountNDS AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmountNDS AS NVARCHAR(50)),'') + '", ';
							               end
                                        
							            IF @NewAmountCurrNDS <> @OldAmountCurrNDS 
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  AmountCurrNDS = Old ->"' +  ISNULL(CAST(@OldAmountCurrNDS AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewAmountCurrNDS AS NVARCHAR(50)),'') + '", ';
							               end
							            IF @NewNum <> @OldNum
							               begin
							                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Num = Old ->"' +  ISNULL(@OldNum,'') + ' " NEW -> " ' + isnull(@NewNum,'') + '", ';
							               end
							            
                                        IF @NewDescription <> @OldDescription
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                           end
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Orders = "' +  isnull(cast(@OldID_Orders as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                        
										INSERT  INTO dbo.Orders_Audit
                                        ( 
                                         ID_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = null 
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

                            DECLARE @OldID_Orders_2        bigint        ;
							DECLARE @OldID_status_2        bigint        ;
							DECLARE @OldID_TypeOrders_2    bigint        ;
							DECLARE @OldID_Currency_2      bigint        ;
							DECLARE @OldDate_2             datetime      ;
							DECLARE @OldPayment_Date_2     datetime      ;
							DECLARE @OldAmount_2           float         ;
							DECLARE @OldAmountCurr_2       float         ;
							DECLARE @OldAmountNDS_2        float         ;
							DECLARE @OldAmountCurrNDS_2    float         ;
							DECLARE @OldNum_2              nvarchar(50)  ;
							DECLARE @OldDescription_2      nvarchar(4000);

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
							            SELECT 
							               @OldID_Orders_2       =  D.ID_Orders        ,
							               @OldID_status_2     	 =  D.ID_status    	   ,
							               @OldID_TypeOrders_2 	 =  D.ID_TypeOrders	   ,
							               @OldID_Currency_2   	 =  D.ID_Currency  	   ,
							               @OldDate_2          	 =  D.Date             ,    --convert(datetime,Date,109),         	 
							               @OldPayment_Date_2  	 =  D.Payment_Date     ,    --convert(datetime,Payment_Date,109), 	 
							               @OldAmount_2        	 =  D.Amount       	   ,
							               @OldAmountCurr_2    	 =  D.AmountCurr   	   ,
							               @OldAmountNDS_2     	 =  D.AmountNDS    	   ,
							               @OldAmountCurrNDS_2 	 =  D.AmountCurrNDS	   ,
							               @OldNum_2           	 =  D.Num          	   ,
							               @OldDescription_2   	 =  D.[Description]  	 
							            FROM deleted D									 
										where @ID_entity_D_2 = D.ID_Orders

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_Orders'      +' = "'+  ISNULL(CAST(@OldID_Orders_2     AS NVARCHAR(50)),'')     + '", '
							            + 'ID_status'      +' = "'+  ISNULL(CAST(@OldID_status_2     AS NVARCHAR(50)),'') 	   + '", '
							            + 'ID_TypeOrders'  +' = "'+  ISNULL(CAST(@OldID_TypeOrders_2 AS NVARCHAR(50)),'') 	   + '", '
							            + 'ID_Currency'    +' = "'+  ISNULL(CAST(@OldID_Currency_2   AS NVARCHAR(50)),'') 	   + '", '
							            + 'Date'           +' = "'+  ISNULL(CAST(Format(@OldDate_2,'yyyy-MM-dd HH:mm:ss.fff')          AS NVARCHAR(50)),'') 	   + '", '
							            + 'Payment_Date'   +' = "'+  ISNULL(CAST(Format(@OldPayment_Date_2,'yyyy-MM-dd HH:mm:ss.fff')  AS NVARCHAR(50)),'') 	   + '", '
							            + 'Amount'         +' = "'+  ISNULL(CAST(@OldAmount_2        AS NVARCHAR(50)),'') 	   + '", '
							            + 'AmountCurr'     +' = "'+  ISNULL(CAST(@OldAmountCurr_2    AS NVARCHAR(50)),'') 	   + '", '
							            + 'AmountNDS'      +' = "'+  ISNULL(CAST(@OldAmountNDS_2     AS NVARCHAR(50)),'') 	   + '", '
							            + 'AmountCurrNDS'  +' = "'+  ISNULL(CAST(@OldAmountCurrNDS_2 AS NVARCHAR(50)),'') 	   + '", '
							            + 'Num'            +' = "'+  ISNULL(@OldNum_2          ,'') 	   + '", '
							            + '[Description]'  +' = "'+  ISNULL(@OldDescription_2  ,'') 	   + '", '

                                        IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                         INSERT  INTO dbo.Orders_Audit
                                         ( 
                                          ID_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                          SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									     set @ChangeDescription = null   
								    
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
                                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Orders = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                     
                                     INSERT  INTO dbo.Orders_Audit
                                     ( 
                                      ID_Orders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									 set @ChangeDescription = null
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
) on Orders_Group_2;


go

CREATE TRIGGER trg_Orders_status_Audit ON Orders_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
                         
                                        IF @NewName <> @OldName 
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							               end
                                        IF @NewSysTypeOrderStatusName <> @OldSysTypeOrderStatusName
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeOrderStatusName = Old ->"' + ISNULL(@OldSysTypeOrderStatusName,'') + ' " NEW -> "' + ISNULL(@NewSysTypeOrderStatusName,'') + '", ';
							               end
                                        IF @NewDescription <> @OldDescription
							               begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                           end
                                        SET @ChangeDescription = 'Updated: ' + ' Id_Status = "' +  isnull(cast(@OldId_Status as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                             SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                        INSERT  INTO dbo.Orders_status_Audit
                                        ( 
                                         Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = null 

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

                                           SELECT 
							                      @OldId_Status_2               = D.Id_Status              ,
                                                  @OldName_2                    = D.Name                   ,
                                                  @OldSysTypeOrderStatusName_2  = D.SysTypeOrderStatusName ,
                                                  @OldDescription_2             = D.[Description]           
                                           FROM deleted D
										   where @ID_entity_D_2 = D.Id_Status


                                           SET @ChangeDescription = 'Deleted: '
                                           + 'Id_Status'              +' = "'+ isnull(CAST(@OldId_Status_2 AS NVARCHAR(20)),'') + '", '
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
                                     
									      set @ChangeDescription = null

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

							  SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Country = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
  
		                      INSERT  INTO dbo.Orders_status_Audit
                              ( 
                               Id_Status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                              )
                               SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
							  set @ChangeDescription = null
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
) on Products_Group_2;


go

CREATE TRIGGER trg_Storage_location_Audit ON Storage_location
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
						   DECLARE @OldKeySource                  bigint         ;
						   DECLARE @OldName                       nvarchar(400)  ;
						   DECLARE @OldCountry                    nvarchar(200)  ;
						   DECLARE @OldCity                       nvarchar(200)  ;
						   DECLARE @OldAdress                     nvarchar(800)  ;
						   DECLARE @OldMail                       nvarchar(250)  ;
						   DECLARE @OldPhone                      nvarchar(30)   ;
						   DECLARE @OldDate_Сreated               datetime       ;
						   DECLARE @OldDescription                nvarchar(4000) ;

                           DECLARE @NewID_Storage_location        bigint         ;
						   DECLARE @NewID_Type_Storage_location   bigint         ;
						   DECLARE @NewKeySource                  bigint         ;
						   DECLARE @NewName                       nvarchar(400)  ;
						   DECLARE @NewCountry                    nvarchar(200)  ;
						   DECLARE @NewCity                       nvarchar(200)  ;
						   DECLARE @NewAdress                     nvarchar(800)  ;
						   DECLARE @NewMail                       nvarchar(250)  ;
						   DECLARE @NewPhone                      nvarchar(30)   ;
						   DECLARE @NewDate_Сreated               datetime       ;
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
						                SELECT 
							                @OldID_Storage_location     	= D.ID_Storage_location     ,
							            	@OldID_Type_Storage_location	= D.ID_Type_Storage_location,
							            	@OldKeySource               	= D.KeySource               ,
							            	@OldName                    	= D.Name                    ,
							            	@OldCountry                 	= D.Country                 ,
							            	@OldCity                    	= D.City                    ,
							            	@OldAdress                  	= D.Adress                  ,
							            	@OldMail                    	= D.Mail                    ,
							            	@OldPhone                   	= D.Phone                   ,
							            	@OldDate_Сreated                = D.Date_Сreated            ,
							            	@OldDescription                 = D.[Description]        	  					
							            FROM Deleted D	
										 where @ID_entity_D = D.ID_Storage_location

							            SELECT 
							                @NewID_Storage_location     	= I.ID_Storage_location     ,
							            	@NewID_Type_Storage_location	= I.ID_Type_Storage_location,
							            	@NewKeySource               	= I.KeySource               ,
							            	@NewName                    	= I.Name                    ,
							            	@NewCountry                 	= I.Country                 ,
							            	@NewCity                    	= I.City                    ,
							            	@NewAdress                  	= I.Adress                  ,
							            	@NewMail                    	= I.Mail                    ,
							            	@NewPhone                   	= I.Phone                   ,
							            	@NewDate_Сreated                = I.Date_Сreated            ,
							            	@NewDescription                 = I.[Description]        	  
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Storage_location;
																	 

                                        IF @NewID_Type_Storage_location  <> @OldID_Type_Storage_location  
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Type_Storage_location  = Old ->"' +  ISNULL(CAST(@OldID_Type_Storage_location  AS NVARCHAR(20)),'') + ' " NEW -> "' + isnull(CAST(@NewID_Type_Storage_location  AS NVARCHAR(20)),'') + '", ';
							               end
                                        
							            IF @NewKeySource <> @OldKeySource
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  KeySource = Old ->"' +  ISNULL(CAST(@OldKeySource AS NVARCHAR(50)),'') + ' " NEW -> "' + isnull(CAST(@NewKeySource AS NVARCHAR(50)),'') + '", ';
							               end
							            
							            IF @NewName <> @OldName
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> "' + isnull(@NewName,'') + '", ';
							               end                  
							            
							            IF @NewCountry <> @OldCountry
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Country = Old ->"' +  ISNULL(@OldCountry,'') + ' " NEW -> "' + isnull(@NewCountry,'') + '", ';
							               end
							            
							            IF @NewCity <> @OldCity
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  City = Old ->"' +  ISNULL(@OldCity,'') + ' " NEW -> "' + isnull(@NewCity,'') + '", ';
							               end
							            
							            IF @NewAdress <> @OldAdress
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Adress = Old ->"' +  ISNULL(@OldAdress,'') + ' " NEW -> "' + isnull(@NewAdress,'') + '", ';
							               end
							            
							            IF @NewMail <> @OldMail
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> "' + isnull(@NewMail,'') + '", ';
							               end
							            
                                        IF @NewPhone <> @OldPhone
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> "' + isnull(@NewPhone,'') + '", ';
							               end
							            
                                        IF @NewDate_Сreated <> @OldDate_Сreated
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Сreated = Old ->"' +  ISNULL(CAST(Format(@OldDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							               end
							            
                                        IF @NewDescription <> @OldDescription
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                           end
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Storage_location = "' +  isnull(cast(@OldID_Storage_location as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                         INSERT  INTO dbo.Storage_location_Audit
                                         ( 
                                          ID_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                         )
                                           SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									    set @ChangeDescription = null 
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
							DECLARE @OldKeySource_2                  bigint         ;
							DECLARE @OldName_2                       nvarchar(400)  ;
							DECLARE @OldCountry_2                    nvarchar(200)  ;
							DECLARE @OldCity_2                       nvarchar(200)  ;
							DECLARE @OldAdress_2                     nvarchar(800)  ;
							DECLARE @OldMail_2                       nvarchar(250)  ;
							DECLARE @OldPhone_2                      nvarchar(30)   ;
							DECLARE @OldDate_Сreated_2               datetime       ;
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
                                                SELECT 
							                        @OldID_Storage_location_2         = D.ID_Storage_location     ,
							                    	@OldID_Type_Storage_location_2	  = D.ID_Type_Storage_location,
							                    	@OldKeySource_2               	  = D.KeySource               ,
							                    	@OldName_2                    	  = D.Name                    ,
							                    	@OldCountry_2                 	  = D.Country                 ,
							                    	@OldCity_2                    	  = D.City                    ,
							                    	@OldAdress_2                  	  = D.Adress                  ,
							                    	@OldMail_2                    	  = D.Mail                    ,
							                    	@OldPhone_2                   	  = D.Phone                   ,
							                    	@OldDate_Сreated_2                = D.Date_Сreated            ,
							                    	@OldDescription_2                 = D.[Description]        
							                    FROM deleted D	
												where @ID_entity_D_2 = D.ID_Storage_location

                                                SET @ChangeDescription = 'Deleted: '
							                    + 'ID_Storage_location'      +' = "'+  ISNULL(CAST(@OldID_Storage_location_2     AS NVARCHAR(20)),'')+ '", '
							                    + 'ID_Type_Storage_location' +' = "'+  ISNULL(CAST(@OldID_Type_Storage_location_2  AS NVARCHAR(20)),'')+ '", '
							                    + 'KeySource'                +' = "'+  ISNULL(CAST(@OldKeySource_2 AS NVARCHAR(50)),'') + '", '
							                    + 'Name'                     +' = "'+  ISNULL(@OldName_2,'')+ '", '				
							                    + 'Country'                  +' = "'+  ISNULL(@OldCountry_2,'')+ '", '
							                    + 'City'                     +' = "'+  ISNULL(@OldCity_2,'') + '", '
							                    + 'Adress'                   +' = "'+  ISNULL(@OldAdress_2,'')+ '", '
							                    + 'Mail'                     +' = "'+  ISNULL(@OldMail_2,'') + '", '
							                    + 'Phone'                    +' = "'+  ISNULL(@OldPhone_2,'')+ '", '
							                    + 'Date_Сreated'             +' = "'+  ISNULL(CAST(Format(@OldDate_Сreated_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
            				                    + 'Description'              +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

							                    IF LEN(@ChangeDescription) > 0
                                                        SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                                INSERT  INTO dbo.Storage_location_Audit
                                                ( 
                                                 ID_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                                )
                                                 SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									            set @ChangeDescription = null

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

                                     SET @ChangeDescription = 'Inserted: '
                                            + 'ID_Storage_location = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                      
                                     INSERT  INTO dbo.Storage_location_Audit
                                     ( 
                                      ID_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null
                                
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
) on Products_Group_2;


go

CREATE TRIGGER trg_Transaction_Audit ON [dbo].[Transaction]
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldTransaction_Amount              float        	;
							DECLARE @OldDescription                     nvarchar(4000)	;

							DECLARE @NewID_Transaction                  bigint          ;
							DECLARE @NewID_Currency                     bigint       	;
							DECLARE @NewID_Transaction_status           bigint       	;
							DECLARE @NewID_Currency_Rate                bigint       	;
							DECLARE @NewTransaction_Date                datetime     	;
							DECLARE @NewKeySource                       bigint       	;
							DECLARE @NewTransaction_name_sender         nvarchar(500)	;
							DECLARE @NewJSON_Transaction_sender         nvarchar(max)	;
							DECLARE @NewTransaction_Amount              float        	;
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


                                            IF @NewID_Currency <> @OldID_Currency 
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency = Old ->"' +  ISNULL(cast(@OldID_Currency as nvarchar(20)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Currency as nvarchar(20)),'') + '", ';
							                   end
                                            
							                IF @NewID_Transaction_status <> @OldID_Transaction_status 
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Transaction_status = Old ->"' +  ISNULL(cast(@OldID_Transaction_status as nvarchar(20)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Transaction_status as nvarchar(20)),'') + '", ';
							                   end
                                            
							                IF @NewID_Currency_Rate <> @OldID_Currency_Rate 
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Currency_Rate = Old ->"' +  ISNULL(cast(@OldID_Currency_Rate as nvarchar(20)),'') + ' " NEW -> " ' + isnull(cast(@NewID_Currency_Rate as nvarchar(20)),'') + '", ';
							                   end
                                            
							                IF @NewTransaction_Date <> @OldTransaction_Date
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Transaction_Date = Old ->"' +  ISNULL(CAST(Format(@OldTransaction_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewTransaction_Date,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							                   end
							                
							                
							                IF @NewKeySource <> @OldKeySource
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  KeySource = Old ->"' +  ISNULL(cast(@OldKeySource as nvarchar(100)),'') + ' " NEW -> " ' + isnull(cast(@NewKeySource as nvarchar(100)),'') + '", ';
							                   end
							                
							                IF @NewTransaction_name_sender <> @OldTransaction_name_sender
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Transaction_name_sender = Old ->"' +  ISNULL(@OldTransaction_name_sender,'') + ' " NEW -> " ' + isnull(@NewTransaction_name_sender,'') + '", ';
							                   end  																	   			
							                
							                IF @NewJSON_Transaction_sender <> @OldJSON_Transaction_sender
							                   begin
							                      SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  JSON_Transaction_sender = Old ->"' +  ISNULL(cast(@OldJSON_Transaction_sender as nvarchar(max)),'') + ' " NEW -> " ' + isnull(cast(@NewJSON_Transaction_sender as nvarchar(max)),'') + '", ';
							                   end
							                
                                            IF @NewDescription <> @OldDescription
							                   begin
                                                  SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_Transaction = "' +  isnull(cast(@OldID_Transaction as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                            INSERT  INTO dbo.TRANSACTION_Audit
                                            ( 
                                             ID_Transaction,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                              SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = null 

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
							DECLARE @OldTransaction_Amount_2              float        	  ;
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
							                + 'Transaction_Amount      ' +' = "'+  ISNULL(cast(@OldTransaction_Amount_2 as nvarchar(20)),'')+ '", '		
							                + 'Description'              +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
                                                   SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
										   INSERT  INTO dbo.TRANSACTION_Audit
                                           ( 
                                            ID_Transaction,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									        set @ChangeDescription = null

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
                                       SET @ChangeDescription = 'Inserted: '
                                            + 'ID_Transaction = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                        
									   INSERT  INTO dbo.TRANSACTION_Audit
                                       ( 
                                        ID_Transaction,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									    set @ChangeDescription = null
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
) on Products_Group_2;


go

CREATE TRIGGER trg_Transaction_status_Audit ON Transaction_status
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
                                            SELECT  
							                     @OldID_Transaction_status    = D.ID_Transaction_status ,
							                	 @OldTypeTransactionName      = D.TypeTransactionName   ,
							                	 @OldSysTypeTransactionName   = D.SysTypeTransactionName,
							                	 @OldDescription              = D.[Description]          
							                FROM Deleted D
											where @ID_entity_D = D.ID_Transaction_status;


							                SELECT  
							                     @NewID_Transaction_status    = I.ID_Transaction_status , 
							                	 @NewTypeTransactionName      = I.TypeTransactionName   ,
							                	 @NewSysTypeTransactionName   = I.SysTypeTransactionName,
							                	 @NewDescription              = I.[Description]           
							                FROM inserted I									 
							                where @ID_entity_D = I.ID_Transaction_status;

                                            IF @NewTypeTransactionName <> @OldTypeTransactionName 
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeTransactionName = Old ->"' +  ISNULL(@OldTypeTransactionName,'') + ' " NEW -> " ' + isnull(@NewTypeTransactionName,'') + '", ';
							                   end
                                            
							                IF @NewSysTypeTransactionName <> @OldSysTypeTransactionName
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeTransactionName = Old ->"' +  ISNULL(@OldTypeTransactionName,'') + ' " NEW -> " ' + isnull(@NewTypeTransactionName,'') + '", ';
							                   end
							                
                                            IF @NewDescription <> @OldDescription
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_Transaction_status = "' +  isnull(cast(@OldID_Transaction_status as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                            
											INSERT  INTO dbo.Transaction_status_Audit
                                            ( 
                                             ID_Transaction_status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                              SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = null 
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
                                     
									       set @ChangeDescription = null
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
                                            SET @ChangeDescription = 'Inserted: '
                                                    + 'ID_Transaction_status = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                    
                                            INSERT  INTO dbo.Transaction_status_Audit
                                            ( 
                                             ID_Transaction_status,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                             SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									        set @ChangeDescription = null

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
) on Products_Group_2;


go

CREATE TRIGGER trg_Type_of_product_measurement_Audit ON Type_of_product_measurement
AFTER INSERT, UPDATE, DELETE

AS  
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
                                            SELECT 
                                                    @OldID_product_measurement     =  D.ID_product_measurement   ,
							                		@OldProduct_measurement_Name   =  D.Product_measurement_Name ,
							                		@OldSysProductMeasurementName  =  D.SysProductMeasurementName,
							                		@OldDescription                =  D.[Description]         								
							                FROM Deleted D
											where @ID_entity_D = D.ID_product_measurement;

							                SELECT 
							                        @NewID_product_measurement     =  I.ID_product_measurement   ,
							                		@NewProduct_measurement_Name   =  I.Product_measurement_Name ,
							                		@NewSysProductMeasurementName  =  I.SysProductMeasurementName,
							                		@NewDescription                =  I.[Description]         	
							                FROM inserted I
											where @ID_entity_D = I.ID_product_measurement;
							                																		 
                                            IF @NewProduct_measurement_Name <> @OldProduct_measurement_Name
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Product_measurement_Name = Old ->"' +  ISNULL(CAST(@OldProduct_measurement_Name AS NVARCHAR(300)),'') + ' " NEW -> " ' + isnull(CAST(@NewProduct_measurement_Name AS NVARCHAR(300)),'') + '", ';
							                   end
                                            
							                IF @NewSysProductMeasurementName <> @OldSysProductMeasurementName
							                   begin
							                    SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysProductMeasurementName = Old ->"' +  ISNULL(CAST(@OldSysProductMeasurementName AS NVARCHAR(300)),'') + ' " NEW -> " ' + isnull(CAST(@NewSysProductMeasurementName AS NVARCHAR(300)),'') + '", ';
							                   end
							                
                                            IF @NewDescription <> @OldDescription
							                   begin
                                                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                               end
                                            SET @ChangeDescription = 'Updated: ' + ' ID_product_measurement = "' +  isnull(cast(@OldID_product_measurement as nvarchar(20)),'')+ '" ' + @ChangeDescription + '"'
                                             --Удаляем запятую на конце
                                            IF LEN(@ChangeDescription) > 0
                                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                            INSERT  INTO dbo.Type_of_product_measurement_Audit
                                            ( 
                                             ID_product_measurement,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                            )
                                              SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									        set @ChangeDescription = null 
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
                                        SELECT 
							                @OldID_product_measurement_2   	= D.ID_product_measurement    ,
							            	@OldProduct_measurement_Name_2 	= D.Product_measurement_Name  ,
							            	@OldSysProductMeasurementName_2 = D.SysProductMeasurementName ,            
							            	@OldDescription_2               = D.[Description]        
							            FROM deleted D
										where @ID_entity_D_2 = D.ID_product_measurement;

                                        SET @ChangeDescription = 'Deleted: '
							            + 'ID_product_measurement'     +' = "'+  ISNULL(CAST(@OldID_product_measurement_2 AS NVARCHAR(20)),'')+ '", '
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
                                     
									    set @ChangeDescription = null 
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
                                          SET @ChangeDescription = 'Inserted: '
                                                  + 'ID_product_measurement = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                    
                                          INSERT  INTO dbo.Type_of_product_measurement_Audit
                                          ( 
                                           ID_product_measurement,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                           SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									      set @ChangeDescription = null     
								  
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
) on Products_Group_2;


go

CREATE TRIGGER trg_Type_Storage_location_Audit ON Type_Storage_location
AFTER INSERT, UPDATE, DELETE

AS 
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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

                            
							            IF @NewName_Type_Storage_location <> @OldName_Type_Storage_location
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Type_Storage_location = Old ->"' +  ISNULL(@OldName_Type_Storage_location,'') + ' " NEW -> "' + isnull(@NewName_Type_Storage_location,'') + '", ';
							               end
							            
							            IF @NewSysNameTypeStoragelocation <> @OldSysNameTypeStoragelocation 
							               begin
							                SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysNameTypeStoragelocation = Old ->"' +  ISNULL(@OldSysNameTypeStoragelocation,'') + ' " NEW -> "' + isnull(@NewSysNameTypeStoragelocation,'') + '", ';
							               end                  
							            
                                        IF @NewDescription <> @OldDescription
							               begin
                                            SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> "' + ISNULL(@NewDescription,'') + '",';
                                           end
							            
                                        SET @ChangeDescription = 'Updated: ' + ' ID_Type_Storage_location = "' +  isnull(cast(@OldID_Type_Storage_location as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                         --Удаляем запятую на конце
                                        IF LEN(@ChangeDescription) > 0
                                            SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                            
                                        INSERT  INTO dbo.Type_Storage_location_Audit
                                        ( 
                                         ID_Type_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                          SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                        
									    set @ChangeDescription = null 
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
                                     
									        set @ChangeDescription = null  
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

                                       SET @ChangeDescription = 'Inserted: '
                                               + 'ID_Type_Storage_location = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Type_Storage_location_Audit
                                       ( 
                                        ID_Type_Storage_location,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
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
) on Products_Group_2;


go

CREATE TRIGGER trg_TypeItem_Audit ON TypeItem
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
									       SELECT @OldId_TypeItem     = D.Id_TypeItem    , 
                                                  @OldTypeItemName    = D.TypeItemName   , 
                                                  @OldSysTypeItemName = D.SysTypeItemName,
                                                  @OldDescription     = D.[Description]
                                           FROM deleted D
										   where @ID_entity_D = D.Id_TypeItem;

							               SELECT @NewId_TypeItem     = I.Id_TypeItem    ,
							                      @NewTypeItemName    = I.TypeItemName   , 
							                      @NewSysTypeItemName = I.SysTypeItemName,
							                      @NewDescription     = I.[Description]
							               FROM inserted I
										   where @ID_entity_D = I.Id_TypeItem;
							               
                                          IF @NewTypeItemName <> @OldTypeItemName 
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeItemName = Old ->"' +  ISNULL(@OldTypeItemName,'') + ' " NEW -> " ' + isnull(@NewTypeItemName,'') + '", ';
							                 end
                                          IF @NewSysTypeItemName <> @OldSysTypeItemName
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SysTypeItemName = Old ->"' + ISNULL(@OldSysTypeItemName,'') + ' " NEW -> "' + ISNULL(@NewSysTypeItemName,'') + '", ';
							                 end
                                          IF @NewDescription <> @OldDescription
							                 begin
                                              SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                             end
                                          SET @ChangeDescription = 'Updated: ' + ' Id_TypeItem = "' +  isnull(cast(@OldId_TypeItem as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                           --Удаляем запятую на конце
                                          IF LEN(@ChangeDescription) > 0
                                              SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                              			  INSERT  INTO dbo.TypeItem_Audit
                                          ( 
                                           Id_TypeItem,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                          )
                                            SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									      set @ChangeDescription = null 
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
									       SELECT
										          @OldId_TypeItem_2     = D.Id_TypeItem    , 
                                                  @OldTypeItemName_2    = D.TypeItemName   , 
                                                  @OldSysTypeItemName_2 = D.SysTypeItemName,
                                                  @OldDescription_2     = D.[Description]
                                           FROM deleted D
										   where @ID_entity_D_2 = D.Id_TypeItem;
										   
                                           SET @ChangeDescription = 'Deleted: '
                                              + 'Id_TypeItem'    + ' = "' + isnull(CAST(@OldId_TypeItem_2 AS NVARCHAR(20)),'') + '", '
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
                                          
									      set @ChangeDescription = null 

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
                                       SET @ChangeDescription = 'Inserted: '
                                            + 'Id_TypeItem = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.TypeItem_Audit
                                        ( 
                                         Id_TypeItem,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                         SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
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
) on Orders_Group_2;


go

CREATE TRIGGER trg_TypeOrders_Audit ON TypeOrders
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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


							          SELECT 
							                 @NewID_TypeOrders     = D.ID_TypeOrders     ,
							                 @NewTypeOrdersName    = D.TypeOrdersName    ,
							                 @NewTypeOrdersSysName = D.TypeOrdersSysName ,
							                 @NewDescription       = D.[Description]      
							          FROM inserted D									 
							          where @ID_entity_D = D.ID_TypeOrders 

							          SELECT 
                                             @OldID_TypeOrders     = D.ID_TypeOrders     ,
                                             @OldTypeOrdersName    = D.TypeOrdersName    ,
                                             @OldTypeOrdersSysName = D.TypeOrdersSysName ,
                                             @OldDescription       = D.[Description]      
							          FROM Deleted D								 
                                      where @ID_entity_D = D.ID_TypeOrders



                                      IF @NewTypeOrdersName <> @OldTypeOrdersName 
							             begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeOrdersName = Old ->"' +  ISNULL(@OldTypeOrdersName,'') + ' " NEW -> " ' + isnull(@NewTypeOrdersName,'') + '", ';
							             end
                                      IF @NewTypeOrdersSysName <> @OldTypeOrdersSysName
							             begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  TypeOrdersSysName = Old ->"' + ISNULL(@OldTypeOrdersSysName,'') + ' " NEW -> "' + ISNULL(@NewTypeOrdersSysName,'') + '", ';
							             end
                                      IF @NewDescription <> @OldDescription
							             begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                         end
                                      SET @ChangeDescription = 'Updated: ' + ' ID_TypeOrders = "' +  isnull(cast(@OldID_TypeOrders as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                       --Удаляем запятую на конце
                                      IF LEN(@ChangeDescription) > 0
                                          SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                                      INSERT  INTO dbo.TypeOrders_Audit
                                     ( 
                                      ID_TypeOrders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									set @ChangeDescription = null 

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

							          SELECT 
							                 @OldID_TypeOrders_2     = D.ID_TypeOrders     ,
							                 @OldTypeOrdersName_2    = D.TypeOrdersName    ,
							                 @OldTypeOrdersSysName_2 = D.TypeOrdersSysName ,
							                 @OldDescription_2       = D.[Description]      
							          FROM deleted D									 
							          where @ID_entity_D_2 = D.ID_TypeOrders

                                      SET @ChangeDescription = 'Deleted: '
                                          + 'ID_TypeOrders'     +' = "'+ isnull(CAST(@OldID_TypeOrders_2 AS NVARCHAR(20)),'') + '", '
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
                                     
									set @ChangeDescription = null

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
                                     SET @ChangeDescription = 'Inserted: '
                                         + 'ID_TypeOrders = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                     
									 INSERT  INTO dbo.TypeOrders_Audit
                                     ( 
                                      ID_TypeOrders,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null

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


CREATE TABLE Branch_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Branch               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(max)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Employee_Group_2;


go

CREATE TRIGGER trg_Branch_Audit ON Branch
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldDescription   nvarchar(1000);

						   DECLARE @NewID_Branch     bigint        ;
						   DECLARE @NewId_Country    bigint        ;
						   DECLARE @NewCity          nvarchar(100) ;
						   DECLARE @NewAddress       nvarchar(300) ;
						   DECLARE @NewName_Branch   nvarchar(300) ;
						   DECLARE @NewMail          nvarchar(300) ;
						   DECLARE @NewPhone         nvarchar(15)  ;
						   DECLARE @NewPostal_Code   int           ;
						   DECLARE @NewINN           int           ;
						   DECLARE @NewDescription   nvarchar(1000);


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


                                       IF @NewId_Country <> @OldId_Country 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Id_Country = Old ->"' +  ISNULL(CAST(@OldId_Country AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewId_Country AS NVARCHAR(50)),'') + '", ';
							              end
                                       
							           IF @NewCity <> @OldCity 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  City = Old ->"' +  ISNULL(@OldCity,'') + ' " NEW -> " ' + isnull(@NewCity,'') + '", ';
							              end
                                                                                               
							           IF @NewAddress <> @OldAddress 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Address = Old ->"' +  ISNULL(@OldAddress,'') + ' " NEW -> " ' + isnull(@NewAddress,'') + '", ';
							              end
							           IF @NewName_Branch <> @OldName_Branch 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Branch = Old ->"' +  ISNULL(@OldName_Branch,'') + ' " NEW -> " ' + isnull(@NewName_Branch,'') + '", ';
							              end
							           IF @NewMail <> @OldMail 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							              end
							           
							           IF @NewPhone <> @OldPhone 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Phone = Old ->"' +  ISNULL(@OldPhone,'') + ' " NEW -> " ' + isnull(@NewPhone,'') + '", ';
							              end
                           	          IF @NewPostal_Code <> @OldPostal_Code
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Postal_Code = Old ->"' +  ISNULL(CAST(@OldPostal_Code AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewPostal_Code AS NVARCHAR(50)),'') + '", ';
							              end
										  
									  IF @NewINN <> @OldINN 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  INN = Old ->"' +  ISNULL(CAST(@OldINN AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewINN AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Branch = "' +  isnull(cast(@OldID_Branch as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Branch_Audit
                                        ( 
                                         ID_Branch,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Branch = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Branch_Audit
                                       ( 
                                        ID_Branch,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2;


go

CREATE TRIGGER trg_Connection_String_Audit ON Connection_String
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldDate_Сreated           datetime      ;
							DECLARE @OldDescription            nvarchar(1000);

							DECLARE @NewID_Connection_String   bigint        ;
							DECLARE @NewPassword               nvarchar(50)  ;
							DECLARE @NewLogin                  nvarchar(100) ;
							DECLARE @NewDate_Сreated           datetime      ;
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

                                        SELECT 
                                               @OldID_Connection_String = D.ID_Connection_String,
											   @OldPassword             = D.[Password]          ,  
											   @OldLogin                = D.[Login]             ,  
											   @OldDate_Сreated         = D.Date_Сreated        ,
											   @OldDescription          = D.[Description]          							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Connection_String;

							            SELECT 
                                               @NewID_Connection_String = I.ID_Connection_String,
											   @NewPassword             = I.[Password]          ,  
											   @NewLogin                = I.[Login]             ,  
											   @NewDate_Сreated         = I.Date_Сreated        ,
											   @NewDescription          = I.[Description]          	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Connection_String;

							           IF @NewPassword <> @OldPassword 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Password = Old ->"' +  ISNULL(@OldPassword,'') + ' " NEW -> " ' + isnull(@NewPassword,'') + '", ';
							              end

							           IF @NewLogin <> @OldLogin 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Login = Old ->"' +  ISNULL(@OldLogin,'') + ' " NEW -> " ' + isnull(@NewLogin,'') + '", ';
							              end

							           IF @NewDate_Сreated <> @OldDate_Сreated
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Сreated = Old ->"' +  ISNULL(CAST(Format(@OldDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Сreated,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end
							           
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Connection_String = "' +  isnull(cast(@OldID_Connection_String as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Connection_String_Audit
                                        ( 
                                         ID_Connection_String,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
							DECLARE @OldDate_Сreated_2           datetime      ;
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
                                            SELECT 
                                                   @OldID_Connection_String_2 = D.ID_Connection_String,
												   @OldPassword_2             = D.[Password]          , 
												   @OldLogin_2                = D.[Login]             , 
												   @OldDate_Сreated_2         = D.Date_Сreated        ,
												   @OldDescription_2          = D.[Description]               
							                FROM deleted D									 
											where @ID_entity_D_2 = D.ID_Connection_String;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Connection_String'            +' = "'+  ISNULL(CAST(@OldID_Connection_String_2     AS NVARCHAR(50)),'')     + '", '
						                    + 'Password'                +' = "'+  ISNULL(@OldPassword_2,'')+ '", '				
							                + 'Login'             +' = "'+  ISNULL(@OldLogin_2,'')+ '", ' 
							                + 'Date_Сreated'       +' = "'+  ISNULL(CAST(Format(@OldDate_Сreated_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Connection_String_Audit
                                           ( 
                                            ID_Connection_String,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Connection_String = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Connection_String_Audit
                                       ( 
                                        ID_Connection_String,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2


go

CREATE TRIGGER trg_Country_Audit ON Country
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;
	
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
								     
									 SELECT  
									     @OldId_Country        =   D.Id_Country       ,
										 @OldName_Country      =   D.Name_Country     ,
										 @OldName_English      =   D.Name_English     ,
										 @OldCod_Country_Phone =   D.Cod_Country_Phone
									 FROM   Deleted D 
									 where @ID_entity_D = D.Id_Country 

									 SELECT 
										@NewId_Country       	 = I.Id_Country       ,
										@NewName_Country     	 = I.Name_Country     ,
										@NewName_English     	 = I.Name_English     ,
										@NewCod_Country_Phone    = I.Cod_Country_Phone 
									 FROM inserted I  
									 where @ID_entity_D = I.Id_Country;					
														
                                     
									 IF @NewName_Country <> @OldName_Country 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Country = Old ->"' +  ISNULL(@OldName_Country,'') + ' " NEW -> " ' + isnull(@NewName_Country,'') + '", ';
							            end
                            
							        IF @NewName_English <> @OldName_English
							           begin
							             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_English = Old ->"' +  ISNULL(@OldName_English,'') + ' " NEW -> " ' + isnull(@NewName_English,'') + '", ';
							           end

							        IF @NewCod_Country_Phone <> @OldCod_Country_Phone 
							           begin
							             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Cod_Country_Phone = Old ->"' +  ISNULL(@OldCod_Country_Phone,'') + ' " NEW -> " ' + isnull(@NewCod_Country_Phone,'') + '", ';
							           end
                                    
									SET @ChangeDescription = 'Updated: ' + ' Id_Country = "' +  isnull(cast(@OldId_Country as nvarchar(20)),'')+ '" ' + @ChangeDescription

									IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);


                                    INSERT  INTO dbo.Country_Audit
                                     ( 
                                      Id_Country,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									set @ChangeDescription = null 

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
                                     
									set @ChangeDescription = null

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
								     				 
					
					                 SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Country = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
  
                                    INSERT  INTO dbo.Country_Audit
                                     ( 
                                      Id_Country,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null

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
) on Employee_Group_2;


go

CREATE TRIGGER trg_Department_Audit ON Department
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldDepartment_Сode         int           ;
							DECLARE @OldDescription             nvarchar(4000);
							
							DECLARE @NewID_Department           bigint        ;
							DECLARE @NewID_Head_Department      bigint        ;
							DECLARE @NewID_Vice_Head_Department bigint        ;
							DECLARE @NewName_Department         nvarchar(300) ;
							DECLARE @NewID_Branch               bigint        ;
							DECLARE @NewDepartment_Сode         int           ;
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
								       
                                        SELECT 
										    @OldID_Department            = D.ID_Department          ,
											@OldID_Head_Department     	 = D.ID_Head_Department     ,
											@OldID_Vice_Head_Department	 = D.ID_Vice_Head_Department,
											@OldName_Department        	 = D.Name_Department        ,
											@OldID_Branch              	 = D.ID_Branch              ,
											@OldDepartment_Сode        	 = D.Department_Сode        ,
											@OldDescription            	 = D.[Description]            						
							            FROM Deleted D
										where @ID_entity_D = D.ID_Department;

							            SELECT
										    @OldID_Department            = I.ID_Department          ,
											@OldID_Head_Department     	 = I.ID_Head_Department     ,
											@OldID_Vice_Head_Department	 = I.ID_Vice_Head_Department,
											@OldName_Department        	 = I.Name_Department        ,
											@OldID_Branch              	 = I.ID_Branch              ,
											@OldDepartment_Сode        	 = I.Department_Сode        ,
											@OldDescription            	 = I.[Description]            		
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Department;


                                       IF @NewID_Head_Department <> @OldID_Head_Department 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Head_Department = Old ->"' +  ISNULL(CAST(@OldID_Head_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Head_Department AS NVARCHAR(50)),'') + '", ';
							              end
                                       
									   IF @NewID_Vice_Head_Department <> @OldID_Vice_Head_Department 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Vice_Head_Department = Old ->"' +  ISNULL(CAST(@OldID_Vice_Head_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Vice_Head_Department AS NVARCHAR(50)),'') + '", ';
							              end

							           IF @NewName_Department <> @OldName_Department
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Department = Old ->"' +  ISNULL(@OldName_Department,'') + ' " NEW -> " ' + isnull(@NewName_Department,'') + '", ';
							              end

									   IF @NewID_Branch <> @OldID_Branch 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

									   IF @NewDepartment_Сode <> @OldDepartment_Сode 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Сode = Old ->"' +  ISNULL(CAST(@OldDepartment_Сode AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewDepartment_Сode AS NVARCHAR(50)),'') + '", ';
							              end
							           
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Department = "' +  isnull(cast(@OldID_Department as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Department_Audit
                                        ( 
                                         ID_Department,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
							DECLARE @OldDepartment_Сode_2         int           ;
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
                                            SELECT 
										        @OldID_Department_2              = D.ID_Department          ,
										    	@OldID_Head_Department_2     	 = D.ID_Head_Department     ,
										    	@OldID_Vice_Head_Department_2	 = D.ID_Vice_Head_Department,
										    	@OldName_Department_2        	 = D.Name_Department        ,
										    	@OldID_Branch_2              	 = D.ID_Branch              ,
										    	@OldDepartment_Сode_2        	 = D.Department_Сode        ,
										    	@OldDescription_2            	 = D.[Description]            						
							                FROM Deleted D
										    where @ID_entity_D_2 = D.ID_Department;

                                            SET @ChangeDescription = 'Deleted: '
							                + 'ID_Department'           +' = "'+  ISNULL(CAST(@OldID_Department_2     AS NVARCHAR(50)),'')     + '", '
							                + 'ID_Head_Department'      +' = "'+  ISNULL(CAST(@OldID_Head_Department_2  AS NVARCHAR(50)),'') + '", '
							                + 'ID_Vice_Head_Department' +' = "'+  ISNULL(CAST(@OldID_Vice_Head_Department_2 AS NVARCHAR(50)),'') + '", '
							                + 'Name_Department'         +' = "'+  ISNULL(@OldName_Department_2,'')+ '", '
											+ 'ID_Branch'               +' = "'+  ISNULL(CAST(@OldID_Branch_2  AS NVARCHAR(50)),'') + '", '
							                + 'Department_Сode'         +' = "'+  ISNULL(CAST(@OldDepartment_Сode_2 AS NVARCHAR(50)),'') + '", '
							                + 'Description'             +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Department_Audit
                                           ( 
                                            ID_Department,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Department = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Department_Audit
                                       ( 
                                        ID_Department,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2


go

CREATE TRIGGER trg_Employees_Audit ON Employees
AFTER INSERT, UPDATE, DELETE

AS   
    set nocount,xact_abort on;
	
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
						   DECLARE @OldDate_Сard_Сreated_Employee datetime      ;
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
						   DECLARE @NewDate_Сard_Сreated_Employee datetime      ;
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
										 @OldDate_Сard_Сreated_Employee	  = D.Date_Сard_Сreated_Employee,
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
										 @NewDate_Сard_Сreated_Employee	  = I.Date_Сard_Сreated_Employee,
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
														
                                     IF @NewID_Department <> @OldID_Department 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Department = Old ->"' +  ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Department AS NVARCHAR(50)),'') + '", ';
							              end

								     IF @NewID_Group <> @OldID_Group 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Group = Old ->"' +  ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF @NewID_The_Subgroup <> @OldID_The_Subgroup 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end
                                     
									 IF @NewID_Passport <> @OldID_Passport 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Passport = Old ->"' +  ISNULL(CAST(@OldID_Passport AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Passport AS NVARCHAR(50)),'') + '", ';
							              end

								     IF @NewID_Branch <> @OldID_Branch 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF @NewID_Post <> @OldID_Post
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Post = Old ->"' +  ISNULL(CAST(@OldID_Post AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Post AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF @NewID_Status_Employee <> @OldID_Status_Employee
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Status_Employee = Old ->"' +  ISNULL(CAST(@OldID_Status_Employee AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Status_Employee AS NVARCHAR(50)),'') + '", ';
							              end

								     IF @NewID_Connection_String <> @OldID_Connection_String 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Connection_String = Old ->"' +  ISNULL(CAST(@OldID_Connection_String AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Connection_String AS NVARCHAR(50)),'') + '", ';
							              end

                                     IF @NewID_Chief <> @OldID_Chief 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Chief = Old ->"' +  ISNULL(CAST(@OldID_Chief AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Chief AS NVARCHAR(50)),'') + '", ';
							              end

									 IF @NewName <> @OldName 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name = Old ->"' +  ISNULL(@OldName,'') + ' " NEW -> " ' + isnull(@NewName,'') + '", ';
							            end

									 IF @NewSurName <> @OldSurName 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  SurName = Old ->"' +  ISNULL(@OldSurName,'') + ' " NEW -> " ' + isnull(@NewSurName,'') + '", ';
							            end

									 IF @NewLastName <> @OldLastName 
							            begin
                                         SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  LastName = Old ->"' +  ISNULL(@OldLastName,'') + ' " NEW -> " ' + isnull(@NewLastName,'') + '", ';
							            end

                                     IF @NewDate_Of_Hiring <> @OldDate_Of_Hiring
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Hiring = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Hiring,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Hiring,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

									IF @NewDate_Сard_Сreated_Employee <> @OldDate_Сard_Сreated_Employee
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Сard_Сreated_Employee = Old ->"' +  ISNULL(CAST(Format(@OldDate_Сard_Сreated_Employee,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Сard_Сreated_Employee,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end
                                   
									IF @NewResidential_Address <> @OldResidential_Address 
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Residential_Address = Old ->"' +  ISNULL(@OldResidential_Address,'') + ' " NEW -> " ' + isnull(@NewResidential_Address,'') + '", ';
							            end

									IF @NewHome_Phone <> @OldHome_Phone
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Home_Phone = Old ->"' +  ISNULL(@OldHome_Phone,'') + ' " NEW -> " ' + isnull(@NewHome_Phone,'') + '", ';
							            end

									IF @NewCell_Phone <> @OldCell_Phone
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Cell_Phone = Old ->"' +  ISNULL(@OldCell_Phone,'') + ' " NEW -> " ' + isnull(@NewCell_Phone,'') + '", ';
							            end

								    IF @NewImage_Employees <> @OldImage_Employees
							                   begin
							                     SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Image_Employees = '  +  '"Изображение было изменено или удалено", ';
							                   end

									IF @NewWork_Phone <> @OldWork_Phone
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Work_Phone = Old ->"' +  ISNULL(@OldWork_Phone,'') + ' " NEW -> " ' + isnull(@NewWork_Phone,'') + '", ';
							            end 

									IF @NewMail <> @OldMail
							            begin
                                          SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Mail = Old ->"' +  ISNULL(@OldMail,'') + ' " NEW -> " ' + isnull(@NewMail,'') + '", ';
							            end 

							        IF @NewPol <> @OldPol 
							              begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Pol = Old ->"' +  ISNULL(CAST(@OldPol AS NVARCHAR(1)),'') + ' " NEW -> " ' + isnull(CAST(@NewPol AS NVARCHAR(1)),'') + '", ';
							              end

                                   IF @NewDate_Of_Dismissal <> @OldDate_Of_Dismissal
							              begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Dismissal = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Dismissal,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Dismissal,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

								   IF @NewDate_Of_Birth <> @OldDate_Of_Birth
							              begin
							                 SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Birth = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Birth,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

                                   IF @NewDescription <> @OldDescription
							              begin
                                             SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                    
									SET @ChangeDescription = 'Updated: ' + ' ID_Employee = "' +  isnull(cast(@OldID_Employee as nvarchar(20)),'')+ '" ' + @ChangeDescription

									IF LEN(@ChangeDescription) > 0
                                                 SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);


                                    INSERT  INTO dbo.Employees_Audit
                                     ( 
                                      ID_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									set @ChangeDescription = null 

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
						    DECLARE @OldDate_Сard_Сreated_Employee_2 datetime      ;
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
										 @OldDate_Сard_Сreated_Employee_2	  = D.Date_Сard_Сreated_Employee,
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
									 +  'Date_Сard_Сreated_Employee'  +' = "'+ ISNULL(CAST(Format(@OldDate_Сard_Сreated_Employee_2,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", '
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
                                     
									set @ChangeDescription = null

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
								     				 
					
					                 SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Employee = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
  
                                    INSERT  INTO dbo.Employees_Audit
                                     ( 
                                      ID_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                     )
                                      SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									set @ChangeDescription = null

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
) on Employee_Group_2;


go

CREATE TRIGGER trg_Group_Audit ON dbo.[Group]
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldDepartment_Сode         int           ;
							DECLARE @OldDescription             nvarchar(1000);

							DECLARE @NewID_Group                bigint        ;
							DECLARE @NewID_Head_Group           bigint        ;
							DECLARE @NewID_Vice_Head_Group      bigint        ;
							DECLARE @NewID_Department           bigint        ;
							DECLARE @NewName_Group              nvarchar(300) ;
							DECLARE @NewID_Branch               bigint        ;
							DECLARE @NewDepartment_Сode         int           ;
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

                                        SELECT 
                                            @OldID_Group           = D.ID_Group          ,
											@OldID_Head_Group      = D.ID_Head_Group     ,
											@OldID_Vice_Head_Group = D.ID_Vice_Head_Group,
											@OldID_Department      = D.ID_Department     ,
											@OldName_Group         = D.Name_Group        ,
											@OldID_Branch          = D.ID_Branch         ,
											@OldDepartment_Сode    = D.Department_Сode   ,
											@OldDescription        = D.[Description]       							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Group;

							            SELECT 
	                                        @NewID_Group           = I.ID_Group          ,
											@NewID_Head_Group      = I.ID_Head_Group     ,
											@NewID_Vice_Head_Group = I.ID_Vice_Head_Group,
											@NewID_Department      = I.ID_Department     ,
											@NewName_Group         = I.Name_Group        ,
											@NewID_Branch          = I.ID_Branch         ,
											@NewDepartment_Сode    = I.Department_Сode   ,
											@NewDescription        = I.[Description]       	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Group;


                                       IF @NewID_Head_Group <> @OldID_Head_Group
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Head_Group = Old ->"' +  ISNULL(CAST(@OldID_Head_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Head_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewID_Vice_Head_Group <> @OldID_Vice_Head_Group 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Vice_Head_Group = Old ->"' +  ISNULL(CAST(@OldID_Vice_Head_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Vice_Head_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewID_Department <> @OldID_Department 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Department = Old ->"' +  ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Department AS NVARCHAR(50)),'') + '", ';
							              end

							           IF @NewName_Group <> @OldName_Group 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Group = Old ->"' +  ISNULL(@OldName_Group,'') + ' " NEW -> " ' + isnull(@NewName_Group,'') + '", ';
							              end

                                       IF @NewID_Branch <> @OldID_Branch 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewDepartment_Сode <> @OldDepartment_Сode 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Сode = Old ->"' +  ISNULL(CAST(@OldDepartment_Сode AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewDepartment_Сode AS NVARCHAR(50)),'') + '", ';
							              end
          
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Group = "' +  isnull(cast(@OldID_Group as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Group_Audit
                                        ( 
                                         ID_Group,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
							DECLARE @OldDepartment_Сode_2         int           ;
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
                                            SELECT 
                                                @OldID_Group_2           = D.ID_Group          ,
										    	@OldID_Head_Group_2      = D.ID_Head_Group     ,
										    	@OldID_Vice_Head_Group_2 = D.ID_Vice_Head_Group,
										    	@OldID_Department_2      = D.ID_Department     ,
										    	@OldName_Group_2         = D.Name_Group        ,
										    	@OldID_Branch_2          = D.ID_Branch         ,
										    	@OldDepartment_Сode_2    = D.Department_Сode   ,
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
											+ 'Department_Сode'     +' = "'+  ISNULL(CAST(@OldDepartment_Сode_2 AS NVARCHAR(50)),'') + '", '
							                + 'Description'         +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.Group_Audit
                                           ( 
                                            ID_Group,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Group = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Group_Audit
                                       ( 
                                        ID_Group,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2;


go

CREATE TRIGGER trg_Passport_Audit ON Passport
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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

                                       
							           IF @NewNumber_Series <> @OldNumber_Series 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Number_Series = Old ->"' +  ISNULL(@OldNumber_Series,'') + ' " NEW -> " ' + isnull(@NewNumber_Series,'') + '", ';
							              end

							           IF @NewDate_Of_Issue <> @OldDate_Of_Issue
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Date_Of_Issue = Old ->"' +  ISNULL(CAST(Format(@OldDate_Of_Issue,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(Format(@NewDate_Of_Issue,'yyyy-MM-dd HH:mm:ss.fff') AS NVARCHAR(50)),'') + '", ';
							              end

							           IF @NewDepartment_Code <> @OldDepartment_Code 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Code = Old ->"' +  ISNULL(@OldDepartment_Code,'') + ' " NEW -> " ' + isnull(@NewDepartment_Code,'') + '", ';
							              end

							           IF @NewIssued_By_Whom <> @OldIssued_By_Whom 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Issued_By_Whom = Old ->"' +  ISNULL(@OldIssued_By_Whom,'') + ' " NEW -> " ' + isnull(@NewIssued_By_Whom,'') + '", ';
							              end

							           IF @NewRegistration <> @OldRegistration 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Registration = Old ->"' +  ISNULL(@OldRegistration,'') + ' " NEW -> " ' + isnull(@NewRegistration,'') + '", ';
							              end

							           IF @NewMilitary_Duty <> @OldMilitary_Duty
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Military_Duty = Old ->"' +  ISNULL(@OldMilitary_Duty,'') + ' " NEW -> " ' + isnull(@NewMilitary_Duty,'') + '", ';
							              end
     
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Passport = "' +  isnull(cast(@OldID_Passport as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Passport_Audit
                                        ( 
                                         ID_Passport,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Passport = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Passport_Audit
                                       ( 
                                        ID_Passport,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2;


go

CREATE TRIGGER trg_Post_Audit ON Post
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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

                                        SELECT 
                                              @OldID_Post         = D.ID_Post        , 
											  @OldName_Post       = D.Name_Post      , 
											  @OldID_Department   = D.ID_Department  , 
											  @OldID_Group        = D.ID_Group       , 
											  @OldID_The_Subgroup = D.ID_The_Subgroup, 
											  @OldDescription     = D.[Description]         							
							            FROM Deleted D
										where @ID_entity_D = D.ID_Post;

							            SELECT 
                                              @NewID_Post         = I.ID_Post        , 
											  @NewName_Post       = I.Name_Post      , 
											  @NewID_Department   = I.ID_Department  , 
											  @NewID_Group        = I.ID_Group       , 
											  @NewID_The_Subgroup = I.ID_The_Subgroup, 
											  @NewDescription     = I.[Description]    
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Post;


                                       
									   IF @NewName_Post <> @OldName_Post 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Post = Old ->"' +  ISNULL(@OldName_Post,'') + ' " NEW -> " ' + isnull(@NewName_Post,'') + '", ';
							              end

                                       IF @NewID_Department <> @OldID_Department 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Department = Old ->"' +  ISNULL(CAST(@OldID_Department AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Department AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewID_Group <> @OldID_Group 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Group = Old ->"' +  ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Group AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewID_The_Subgroup <> @OldID_The_Subgroup 
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end
			           
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Post = "' +  isnull(cast(@OldID_Post as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Post_Audit
                                        ( 
                                         ID_Post,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Post = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Post_Audit
                                       ( 
                                        ID_Post,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2;


go

CREATE TRIGGER trg_Status_Employee_Audit ON Status_Employee
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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

                                        SELECT 
 							                 @OldID_Status_Employee   = D.ID_Status_Employee  ,
											 @OldName_Status_Employee = D.Name_Status_Employee,
											 @OldDescription          = D.[Description]                  
							            FROM Deleted D
										where @ID_entity_D = D.ID_Status_Employee;

							            SELECT 
                                             @OldID_Status_Employee   = I.ID_Status_Employee  ,
											 @OldName_Status_Employee = I.Name_Status_Employee,
											 @OldDescription          = I.[Description]         	
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_Status_Employee;


							           IF @NewName_Status_Employee <> @OldName_Status_Employee 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_Status_Employee = Old ->"' +  ISNULL(@OldName_Status_Employee,'') + ' " NEW -> " ' + isnull(@NewName_Status_Employee,'') + '", ';
							              end
                                                                                               
                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end
                                       SET @ChangeDescription = 'Updated: ' + ' ID_Status_Employee = "' +  isnull(cast(@OldID_Status_Employee as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.Status_Employee_Audit
                                        ( 
                                         ID_Status_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
                                            SELECT 
                                                    @OldID_Status_Employee_2   = ID_Status_Employee  ,
													@OldName_Status_Employee_2 = Name_Status_Employee,
													@OldDescription_2          = Description        
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
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Status_Employee = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.Status_Employee_Audit
                                       ( 
                                        ID_Status_Employee,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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
) on Employee_Group_2;


go

CREATE TRIGGER trg_The_Subgroup_Audit ON The_Subgroup
AFTER INSERT, UPDATE, DELETE

AS
    set nocount,xact_abort on;

    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


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
							DECLARE @OldDepartment_Сode            int           ;
							DECLARE @OldDescription                nvarchar(1000);
							DECLARE @OldID_Parent_The_Subgroup     bigint        ;


							DECLARE @NewID_The_Subgroup            bigint        ;
							DECLARE @NewID_Head_The_Subgroup       bigint        ;
							DECLARE @NewID_Vice_Head_The_Subgroup  bigint        ;
							DECLARE @NewID_Group                   bigint        ;
							DECLARE @NewName_The_Subgroup          nvarchar(300) ;
							DECLARE @NewID_Branch                  bigint        ;
							DECLARE @NewDepartment_Сode            int           ;
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

                                        SELECT 
										     @OldID_The_Subgroup           = D.ID_The_Subgroup          ,
											 @OldID_Head_The_Subgroup      = D.ID_Head_The_Subgroup     ,
											 @OldID_Vice_Head_The_Subgroup = D.ID_Vice_Head_The_Subgroup,
											 @OldID_Group                  = D.ID_Group                 ,
											 @OldName_The_Subgroup         = D.Name_The_Subgroup        ,
											 @OldID_Branch                 = D.ID_Branch                ,
											 @OldDepartment_Сode           = D.Department_Сode          ,
											 @OldDescription               = D.[Description]            ,
											 @OldID_Parent_The_Subgroup    = D.ID_Parent_The_Subgroup   
							            FROM Deleted D
										where @ID_entity_D = D.ID_The_Subgroup;

							            SELECT 
										     @NewID_The_Subgroup           = I.ID_The_Subgroup          ,
											 @NewID_Head_The_Subgroup      = I.ID_Head_The_Subgroup     ,
											 @NewID_Vice_Head_The_Subgroup = I.ID_Vice_Head_The_Subgroup,
											 @NewID_Group                  = I.ID_Group                 ,
											 @NewName_The_Subgroup         = I.Name_The_Subgroup        ,
											 @NewID_Branch                 = I.ID_Branch                ,
											 @NewDepartment_Сode           = I.Department_Сode          ,
											 @NewDescription               = I.[Description]            ,
											 @NewID_Parent_The_Subgroup    = I.ID_Parent_The_Subgroup   
							            FROM inserted I									 
							            where @ID_entity_D = I.ID_The_Subgroup;

                                       
							           IF @NewID_Head_The_Subgroup <> @OldID_Head_The_Subgroup
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Head_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_Head_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Head_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end

							           IF @NewID_Vice_Head_The_Subgroup <> @OldID_Vice_Head_The_Subgroup
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Vice_Head_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_Vice_Head_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Vice_Head_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end

							           IF @NewID_Group <> @OldID_Group
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Group = Old ->"' +  ISNULL(CAST(@OldID_Group AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Group AS NVARCHAR(50)),'') + '", ';
							              end

							           IF @NewName_The_Subgroup <> @OldName_The_Subgroup 
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Name_The_Subgroup = Old ->"' +  ISNULL(@OldName_The_Subgroup,'') + ' " NEW -> " ' + isnull(@NewName_The_Subgroup,'') + '", ';
							              end
                                        
									   IF @NewID_Branch <> @OldID_Branch
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Branch = Old ->"' +  ISNULL(CAST(@OldID_Branch AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Branch AS NVARCHAR(50)),'') + '", ';
							              end

									   IF @NewDepartment_Сode <> @OldDepartment_Сode
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Department_Сode = Old ->"' +  ISNULL(CAST(@OldDepartment_Сode AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewDepartment_Сode AS NVARCHAR(50)),'') + '", ';
							              end

                                       IF @NewDescription <> @OldDescription
							              begin
                                           SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  Description = Old ->"' + ISNULL(@OldDescription,'') + ' " NEW -> " ' + ISNULL(@NewDescription,'') + '", ';
                                          end

									   IF @NewID_Parent_The_Subgroup <> @OldID_Parent_The_Subgroup
							              begin
							               SET @ChangeDescription = '' + isnull(@ChangeDescription,'') + '  ID_Parent_The_Subgroup = Old ->"' +  ISNULL(CAST(@OldID_Parent_The_Subgroup AS NVARCHAR(50)),'') + ' " NEW -> " ' + isnull(CAST(@NewID_Parent_The_Subgroup AS NVARCHAR(50)),'') + '", ';
							              end


                                       SET @ChangeDescription = 'Updated: ' + ' ID_The_Subgroup = "' +  isnull(cast(@OldID_The_Subgroup as nvarchar(20)),'')+ '" ' + @ChangeDescription
                                        --Удаляем запятую на конце
                                       IF LEN(@ChangeDescription) > 0
                                           SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                                       
									   INSERT  INTO dbo.The_Subgroup_Audit
                                        ( 
                                         ID_The_Subgroup,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                        )
                                       SELECT  @ID_entity_D,@login_name_2_D,@ModifiedDate_D,@Name_action_D,@ChangeDescription;              
                                     
									   set @ChangeDescription = null 
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
							DECLARE @OldDepartment_Сode_2            int           ;
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
                                            SELECT 
										              @OldID_The_Subgroup_2           = D.ID_The_Subgroup          ,
											          @OldID_Head_The_Subgroup_2      = D.ID_Head_The_Subgroup     ,
											          @OldID_Vice_Head_The_Subgroup_2 = D.ID_Vice_Head_The_Subgroup,
											          @OldID_Group_2                  = D.ID_Group                 ,
											          @OldName_The_Subgroup_2         = D.Name_The_Subgroup        ,
											          @OldID_Branch_2                 = D.ID_Branch                ,
											          @OldDepartment_Сode_2           = D.Department_Сode          ,
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
											+ 'Department_Сode'            +' = "'+  ISNULL(CAST(@OldDepartment_Сode_2 AS NVARCHAR(50)),'') + '", '											
											+ 'Description'                +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '
											+ 'ID_Parent_The_Subgroup'     +' = "'+  ISNULL(CAST(@OldID_Parent_The_Subgroup_2 AS NVARCHAR(50)),'') + '", '

                                           IF LEN(@ChangeDescription) > 0
						                       SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                                           INSERT  INTO dbo.The_Subgroup_Audit
                                           ( 
                                            ID_The_Subgroup,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                           )
                                            SELECT  @ID_entity_D_2,@login_name_2_D_2,@ModifiedDate_D_2,@Name_action_D_2,@ChangeDescription;              
                                     
									       set @ChangeDescription = null
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
                                       SET @ChangeDescription = 'Inserted: '
                                         + 'ID_The_Subgroup = "' + CAST(@ID_entity_I_2 AS NVARCHAR(20)) + '" ';
                                       
									   INSERT  INTO dbo.The_Subgroup_Audit
                                       ( 
                                        ID_The_Subgroup,ModifiedBy,ModifiedDate,Operation,ChangeDescription                
                                       )
                                        SELECT  @ID_entity_I_2,@login_name_2_I_2,@ModifiedDate_I_2,@Name_action_I_2,@ChangeDescription;              
                                     
									   set @ChangeDescription = null
           
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

--rollback
commit
