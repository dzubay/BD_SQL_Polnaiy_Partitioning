set nocount,xact_abort on 
go
begin tran


CREATE TABLE Buyer_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_buyer               bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group_2;


go

CREATE TRIGGER trg_Buyer_Audit ON Buyer
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Buyer_Audit
                            ( 
                               ID_Buyer            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Buyer
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
						   DECLARE @OldId_buyer                    bigint           ;
						   DECLARE @OldID_Connection_Buyer         bigint       	;
						   DECLARE @OldId_Status                   bigint       	;
						   DECLARE @OldName                        nvarchar(100)	;
						   DECLARE @OldSurName                     nvarchar(100)	;
						   DECLARE @OldLastName                    nvarchar(100)	;
						   DECLARE @OldMail                        nvarchar(250)	;
						   DECLARE @OldPol                         char(1)      	;
						   DECLARE @OldPhone                       nvarchar(30) 	;
						   DECLARE @OldDate_Of_Birth               datetime     	;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

						   DECLARE @NewId_buyer                    bigint           ;
						   DECLARE @NewID_Connection_Buyer         bigint       	;
						   DECLARE @NewId_Status                   bigint       	;
						   DECLARE @NewName                        nvarchar(100)	;
						   DECLARE @NewSurName                     nvarchar(100)	;
						   DECLARE @NewLastName                    nvarchar(100)	;
						   DECLARE @NewMail                        nvarchar(250)	;
						   DECLARE @NewPol                         char(1)      	;
						   DECLARE @NewPhone                       nvarchar(30) 	;
						   DECLARE @NewDate_Of_Birth               datetime     	;
						   DECLARE @NewDescription                 nvarchar(4000)	;
                     
                         
							SELECT 
							    @NewId_buyer             = Id_buyer           , 
								@NewID_Connection_Buyer  = ID_Connection_Buyer,
								@NewId_Status            = Id_Status          ,
								@NewName                 = Name               ,
								@NewSurName              = SurName            ,
								@NewLastName             = LastName           ,
								@NewMail                 = Mail               ,
								@NewPol                  = Pol                ,
								@NewPhone                = Phone              ,
								@NewDate_Of_Birth        = Date_Of_Birth      ,
								@NewDescription          = [Description]        	
							FROM inserted;									 

							SELECT 
							    @OldId_buyer             = Id_buyer           , 
								@OldID_Connection_Buyer  = ID_Connection_Buyer,
								@OldId_Status            = Id_Status          ,
								@OldName                 = Name               ,
								@OldSurName              = SurName            ,
								@OldLastName             = LastName           ,
								@OldMail                 = Mail               ,
								@OldPol                  = Pol                ,
								@OldPhone                = Phone              ,
								@OldDate_Of_Birth        = Date_Of_Birth      ,
								@OldDescription          = [Description]        							
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Buyer_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Buyer_Audit
                            ( 
                               Id_buyer       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.Id_buyer
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

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

                            SELECT 
							    @OldId_buyer_2             = Id_buyer           , 
								@OldID_Connection_Buyer_2  = ID_Connection_Buyer,
								@OldId_Status_2            = Id_Status          ,
								@OldName_2                 = Name               ,
								@OldSurName_2              = SurName            ,
								@OldLastName_2             = LastName           ,
								@OldMail_2                 = Mail               ,
								@OldPol_2                  = Pol                ,
								@OldPhone_2                = Phone              ,
								@OldDate_Of_Birth_2        = Date_Of_Birth      ,
								@OldDescription_2          = [Description]        
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Buyer_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Buyer_Audit
                    ( 
                          Id_buyer  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.Id_buyer
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @Id_buyer_3 BIGINT;
                    SELECT @Id_buyer_3 = Id_buyer FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_buyer = "' + CAST(@Id_buyer_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Buyer_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Buyer_status_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Status              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group_2;


go

CREATE TRIGGER trg_Buyer_status_Audit ON Buyer_status
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Buyer_status_Audit
                            ( 
                               Id_Status            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.Id_Status
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                                          	                      

						   DECLARE @OldId_Status                bigint          ;
						   DECLARE @OldName                  	nvarchar(300)  	;
						   DECLARE @OldSysTypeBuyerStatusName	nvarchar(300) 	;
						   DECLARE @OldDescription      	    nvarchar(4000)	;


						   DECLARE @NewId_Status                bigint          ;
						   DECLARE @NewName                  	nvarchar(300)  	;
						   DECLARE @NewSysTypeBuyerStatusName	nvarchar(300) 	;
						   DECLARE @NewDescription      	    nvarchar(4000)	;
                       

							SELECT 
                                  @NewId_Status                 = Id_Status                  ,
								  @NewName                  	= Name                  	 ,
								  @NewSysTypeBuyerStatusName	= SysTypeBuyerStatusName	 ,
								  @NewDescription      	        = [Description]      	
							FROM inserted;									 

							SELECT 
                                  @OldId_Status                 = Id_Status                  ,
								  @OldName                  	= Name                  	 ,
								  @OldSysTypeBuyerStatusName	= SysTypeBuyerStatusName	 ,  	
								  @OldDescription      	        = [Description]      	
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Buyer_status_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Buyer_status_Audit
                            ( 
                               Id_Status       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.Id_Status
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

                            DECLARE @OldId_Status_2                 bigint          ;
							DECLARE @OldName_2                  	nvarchar(300)  	;
							DECLARE @OldSysTypeBuyerStatusName_2	nvarchar(300) 	;
							DECLARE @OldDescription_2      	        nvarchar(4000)	;

							SELECT 
                                  @OldId_Status_2               = Id_Status               ,
								  @OldName_2                    = Name                    ,
								  @OldSysTypeBuyerStatusName_2  = SysTypeBuyerStatusName  ,
								  @OldDescription_2             = [Description]      		  
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
							+ 'Id_Status'               +' = "'+  ISNULL(CAST(@OldId_Status_2  AS NVARCHAR(50)),'')+ '", '
							+ 'Name'                    +' = "'+  ISNULL(@OldName_2,'')+ '", '
							+ 'SysTypeBuyerStatusName'  +' = "'+  ISNULL(@OldSysTypeBuyerStatusName_2,'')+ '", '
							+ '[Description]'           +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                          IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Buyer_status_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Buyer_status_Audit
                    ( 
                          Id_Status  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.Id_Status
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @Id_Status_3 BIGINT;
                    SELECT @Id_Status_3 = Id_Status FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Status = "' + CAST(@Id_Status_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Buyer_status_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Condition_of_the_item_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Condition_of_the_item  bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Condition_of_the_item_Audit ON Condition_of_the_item
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Condition_of_the_item_Audit
                            ( 
                               ID_Condition_of_the_item            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Condition_of_the_item
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
						   DECLARE @OldID_Condition_of_the_item       bigint         ;
						   DECLARE @OldName_Condition_of_the_item     nvarchar(300)	 ;
						   DECLARE @OldSysNameConditionTypeOfTheItem  nvarchar(300)	 ;
						   DECLARE @OldDescription                    nvarchar(4000) ;

                           DECLARE @NewID_Condition_of_the_item       bigint         ;
						   DECLARE @NewName_Condition_of_the_item     nvarchar(300)	 ;
						   DECLARE @NewSysNameConditionTypeOfTheItem  nvarchar(300)	 ;
						   DECLARE @NewDescription                    nvarchar(4000) ;

							SELECT 
							    @NewID_Condition_of_the_item       = ID_Condition_of_the_item     ,
								@NewName_Condition_of_the_item     = Name_Condition_of_the_item   ,
								@NewSysNameConditionTypeOfTheItem  = SysNameConditionTypeOfTheItem,
								@NewDescription                    = [Description]        	  
							FROM inserted;									 

                            SELECT 
							    @OldID_Condition_of_the_item       = ID_Condition_of_the_item     ,
								@OldName_Condition_of_the_item     = Name_Condition_of_the_item   ,
								@OldSysNameConditionTypeOfTheItem  = SysNameConditionTypeOfTheItem,
								@OldDescription                    = [Description]  					
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Condition_of_the_item_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Condition_of_the_item_Audit
                            ( 
                               ID_Condition_of_the_item       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Condition_of_the_item
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

                           DECLARE @OldID_Condition_of_the_item_2       bigint         ;
						   DECLARE @OldName_Condition_of_the_item_2     nvarchar(300)  ;
						   DECLARE @OldSysNameConditionTypeOfTheItem_2  nvarchar(300)  ;
						   DECLARE @OldDescription_2                    nvarchar(4000) ;    	  	

                            SELECT 
							    @OldID_Condition_of_the_item_2      = ID_Condition_of_the_item     ,
								@OldName_Condition_of_the_item_2    = Name_Condition_of_the_item   ,
								@OldSysNameConditionTypeOfTheItem_2 = SysNameConditionTypeOfTheItem,
								@OldDescription_2                   = [Description]        
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
							+ 'ID_Condition_of_the_item'      +' = "'+  ISNULL(CAST(@OldID_Condition_of_the_item_2 AS NVARCHAR(20)),'')+ '", '
							+ 'Name_Condition_of_the_item'    +' = "'+  ISNULL(@OldName_Condition_of_the_item_2,'')+ '", '
							+ 'SysNameConditionTypeOfTheItem' +' = "'+  ISNULL(@OldSysNameConditionTypeOfTheItem_2,'') + '", '
            				+ 'Description'                   +' = "'+  ISNULL(@OldDescription_2,'') + '", '

							IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Condition_of_the_item_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Condition_of_the_item_Audit
                    ( 
                          ID_Condition_of_the_item  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Condition_of_the_item
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Condition_of_the_item_3 BIGINT;
                    SELECT @ID_Condition_of_the_item_3 = ID_Condition_of_the_item FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Condition_of_the_item = "' + CAST(@ID_Condition_of_the_item_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Condition_of_the_item_Audit i
					where @AuditID_3  = AuditID                

                    END

GO

CREATE TABLE Connection_Buyer_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Connection_Buyer    bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Costomers_Group_2;


go

CREATE TRIGGER trg_Connection_Buyer_Audit ON Connection_Buyer
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Connection_Buyer_Audit
                            ( 
                               ID_Connection_Buyer            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Connection_Buyer
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                                          	                      

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
                       

							SELECT 
                                  @NewID_Connection_Buyer = ID_Connection_Buyer  ,
								  @NewPassword            = Password           	 ,
								  @NewLogin               = Login              	 ,
								  @NewDate_Сreated        = Date_Сreated       	 ,
								  @NewDescription      	  = [Description]      	
							FROM inserted;									 

							SELECT 
                                  @OldID_Connection_Buyer = ID_Connection_Buyer  ,
								  @OldPassword            = Password           	 ,
								  @OldLogin               = Login              	 ,
								  @OldDate_Сreated        = Date_Сreated       	 ,
								  @OldDescription      	  = [Description]      	
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Connection_Buyer_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Connection_Buyer_Audit
                            ( 
                               ID_Connection_Buyer       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Connection_Buyer
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

                             DECLARE @OldID_Connection_Buyer_2  bigint          ;
							 DECLARE @OldPassword_2           	nvarchar(50)  	;
							 DECLARE @OldLogin_2              	nvarchar(100) 	;
							 DECLARE @OldDate_Сreated_2       	datetime      	;
							 DECLARE @OldDescription_2         	nvarchar(4000)	;


							SELECT 
                                  @OldID_Connection_Buyer_2	   = ID_Connection_Buyer  ,
								  @OldPassword_2           	   = Password             ,
								  @OldLogin_2              	   = Login                ,
								  @OldDate_Сreated_2       	   = Date_Сreated         ,
								  @OldDescription_2            = [Description]      	  
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
							+ 'ID_Connection_Buyer'  +' = "'+  ISNULL(CAST(@OldID_Connection_Buyer_2  AS NVARCHAR(50)),'')+ '", '
							+ 'Password'             +' = "'+  ISNULL(@OldPassword_2,'')+ '", '
							+ 'Login'                +' = "'+  ISNULL(@OldLogin_2,'')+ '", '
							+ 'Date_Сreated'         +' = "'+  ISNULL(CAST(Format(@OldDate_Сreated_2,'yyyy-MM-dd HH:mm:ss.fff')AS NVARCHAR(50)),'')+ '", '
							+ '[Description]'        +' = "'+  ISNULL(@OldDescription_2,'')+ '", '

                          
						  IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Connection_Buyer_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Connection_Buyer_Audit
                    ( 
                          ID_Connection_Buyer  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Connection_Buyer
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Connection_Buyer_3 BIGINT;
                    SELECT @ID_Connection_Buyer_3 = ID_Connection_Buyer FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Connection_Buyer = "' + CAST(@ID_Connection_Buyer_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Connection_Buyer_Audit i
					where @AuditID_3  = AuditID                

                    END

GO

CREATE TABLE Currency_Audit
(
    AuditID              bigint IDENTITY(1,1)  not null,
    ID_Currency          bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
)on Orders_Group_2 ;

go

CREATE TRIGGER trg_Currency_Audit ON Currency
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Currency_Audit
                            ( 
                               ID_Currency            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Currency
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                                              
	                       
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


							SELECT 
							@NewID_Currency        = ID_Currency,     
							@NewFull_name_rus      = Full_name_rus,   
							@NewFull_name_eng      = Full_name_eng,   
							@NewAbbreviation_rus   = Abbreviation_rus,
							@NewAbbreviation_eng   = Abbreviation_eng,
							@NewDescription        = [Description]     
							FROM inserted;

							SELECT 
							@OldID_Currency        = ID_Currency,     
							@OldFull_name_rus      = Full_name_rus,   
							@OldFull_name_eng      = Full_name_eng,   
							@OldAbbreviation_rus   = Abbreviation_rus,
							@OldAbbreviation_eng   = Abbreviation_eng,
							@OldDescription        = [Description]    
                            FROM deleted;

                         
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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Currency_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Currency_Audit
                            ( 
                               ID_Currency       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Currency
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

							DECLARE @OldID_Currency_2         BIGINT
							DECLARE @OldFull_name_rus_2       NVARCHAR(300);
							DECLARE @OldFull_name_eng_2       NVARCHAR(300);
							DECLARE @OldAbbreviation_rus_2    NVARCHAR(15);
							DECLARE @OldAbbreviation_eng_2    NVARCHAR(15);
							DECLARE @OldDescription_2         NVARCHAR(4000);
                            
                            
                
                            
                            SELECT 
							@OldID_Currency_2        = ID_Currency,     
							@OldFull_name_rus_2      = Full_name_rus,   
                            @OldFull_name_eng_2      = Full_name_eng,   
                            @OldAbbreviation_rus_2   = Abbreviation_rus,
                            @OldAbbreviation_eng_2   = Abbreviation_eng,
                            @OldDescription_2        = [Description]   
							FROM deleted;

                            SET @ChangeDescription = 'Deleted: '
                                    + 'ID_Currency'      +' = "'+ ISNULL(CAST(@OldID_Currency_2 AS NVARCHAR(20)), '') + '", '
                                    + 'Full_name_rus'    +' = "'+ ISNULL(@OldFull_name_rus_2, '') + '", '
									+ 'Full_name_eng'    +' = "'+ ISNULL(@OldFull_name_eng_2, '') + '", '
                                    + 'Abbreviation_rus' +' = "'+ ISNULL(@OldAbbreviation_rus_2, '') + '", '
									+ 'Abbreviation_eng' +' = "'+ ISNULL(@OldAbbreviation_eng_2, '') + '", '
                                    + 'Description'      +' = "'+ ISNULL(@OldDescription_2, '') + '" ';
                          
						  IF LEN(@ChangeDescription) > 0
						      SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Currency_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Currency_Audit
                    ( 
                          ID_Currency  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Currency
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Currency_3 BIGINT;
                    SELECT @ID_Currency_3 = ID_Currency FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Currency = "' + CAST(@ID_Currency_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Currency_Audit i
					where @AuditID_3  = AuditID                

                    END

GO

CREATE TABLE Currency_Rate_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Currency_Rate       bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Currency_Rate_Audit ON Currency_Rate
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Currency_Rate_Audit
                            ( 
                               ID_Currency_Rate            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Currency_Rate
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
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
                         
							SELECT  
                                  @NewID_Currency_Rate         =  ID_Currency_Rate         ,
								  @NewID_Currency              =  ID_Currency              ,
								  @NewAmount_Rate              =  Amount_Rate              ,
								  @NewValid_from               =  Valid_from               ,
								  @NewValid_to                 =  Valid_to                 ,
								  @NewJSON_Currency_Rate_Data  =  JSON_Currency_Rate_Data  ,
								  @NewDescription              =  [Description]              
							FROM inserted;									 

							SELECT  
							      @OldID_Currency_Rate         =  ID_Currency_Rate         ,
								  @OldID_Currency              =  ID_Currency              ,
								  @OldAmount_Rate              =  Amount_Rate              ,
								  @OldValid_from               =  Valid_from               ,
								  @OldValid_to                 =  Valid_to                 ,
								  @OldJSON_Currency_Rate_Data  =  JSON_Currency_Rate_Data  ,
								  @OldDescription              =  [Description]              
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Currency_Rate_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Currency_Rate_Audit
                            ( 
                               ID_Currency_Rate       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Currency_Rate
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

							DECLARE @OldID_Currency_Rate_2        bigint          ;
							DECLARE @OldID_Currency_2             bigint       	  ;
							DECLARE @OldAmount_Rate_2             float        	  ;
							DECLARE @OldValid_from_2              datetime     	  ;
							DECLARE @OldValid_to_2                datetime     	  ;
							DECLARE @OldJSON_Currency_Rate_Data_2 nvarchar(max)	  ;
							DECLARE @OldDescription_2             nvarchar(4000)  ;

                            SELECT
							    @OldID_Currency_Rate_2        = ID_Currency_Rate       	 ,
								@OldID_Currency_2             = ID_Currency            	 ,
								@OldAmount_Rate_2             = Amount_Rate           	 ,
								@OldValid_from_2              = Valid_from             	 ,
								@OldValid_to_2                = Valid_to               	 ,
								@OldJSON_Currency_Rate_Data_2 = JSON_Currency_Rate_Data  ,
								@OldDescription_2             = [Description]            
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Currency_Rate_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Currency_Rate_Audit
                    ( 
                          ID_Currency_Rate  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Currency_Rate
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Currency_Rate_3 BIGINT;
                    SELECT @ID_Currency_Rate_3 = ID_Currency_Rate FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Currency_Rate = "' + CAST(@ID_Currency_Rate_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Currency_Rate_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Data_Orders_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Data_Orders         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group_2;


go

CREATE TRIGGER trg_Data_Orders_Audit ON Data_Orders
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Data_Orders_Audit
                            ( 
                               Id_Data_Orders            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.Id_Data_Orders
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
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
                         
							SELECT 
                                    @NewId_Data_Orders    =  Id_Data_Orders     ,
									@NewID_Employee       =  ID_Employee     	,
									@NewID_Orders         =  ID_Orders       	,
									@NewId_buyer          =  Id_buyer        	,
									@NewID_Exemplar       =  ID_Exemplar     	,
									@NewID_Transaction    =  ID_Transaction  	,
									@NewDate_Data_Orders  =  Date_Data_Orders	,
									@NewDescription       =  [Description]         	
							FROM inserted;									 

							SELECT 
                                    @OldId_Data_Orders     =  Id_Data_Orders     ,
									@OldID_Employee        =  ID_Employee     	 ,
									@OldID_Orders          =  ID_Orders       	 ,
									@OldId_buyer           =  Id_buyer        	 ,
									@OldID_Exemplar        =  ID_Exemplar     	 ,
									@OldID_Transaction     =  ID_Transaction  	 ,
									@OldDate_Data_Orders   =  Date_Data_Orders	 ,
									@OldDescription        =  [Description]        							
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Data_Orders_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Data_Orders_Audit
                            ( 
                               Id_Data_Orders       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.Id_Data_Orders
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

                           DECLARE @OldId_Data_Orders_2              bigint           ;
						   DECLARE @OldID_Employee_2                 bigint    		  ;
						   DECLARE @OldID_Orders_2                   bigint    		  ;
						   DECLARE @OldId_buyer_2                    bigint    		  ;
						   DECLARE @OldID_Exemplar_2                 bigint    		  ;
						   DECLARE @OldID_Transaction_2              bigint    		  ;
						   DECLARE @OldDate_Data_Orders_2            datetime  		  ;
	                       DECLARE @OldDescription_2                 nvarchar(4000)	  ;

                            SELECT 
							    @OldId_Data_Orders_2  	   = Id_Data_Orders    ,
								@OldID_Employee_2     	   = ID_Employee       ,
								@OldID_Orders_2       	   = ID_Orders         ,
								@OldId_buyer_2        	   = Id_buyer          ,
								@OldID_Exemplar_2     	   = ID_Exemplar       ,
								@OldID_Transaction_2  	   = ID_Transaction    ,
								@OldDate_Data_Orders_2     = Date_Data_Orders  ,
								@OldDescription_2          = [Description]        
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Data_Orders_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Data_Orders_Audit
                    ( 
                          Id_Data_Orders  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.Id_Data_Orders
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @Id_Data_Orders_3 BIGINT;
                    SELECT @Id_Data_Orders_3 = Id_Data_Orders FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Data_Orders = "' + CAST(@Id_Data_Orders_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Data_Orders_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Exemplar_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Exemplar               bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Exemplar_Audit ON Exemplar
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Exemplar_Audit
                            ( 
                               ID_Exemplar            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Exemplar
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
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

							SELECT 
							    @NewID_Exemplar             	= ID_Exemplar             , 
								@NewId_Item                 	= Id_Item                 ,
								@NewID_Currency             	= ID_Currency             ,
								@NewID_Storage_location     	= ID_Storage_location     ,
								@NewKeySource               	= KeySource               ,
								@NewSerial_number           	= Serial_number           ,
								@NewID_Condition_of_the_item	= ID_Condition_of_the_item,
								@NewOld_Price_no_NDS        	= Old_Price_no_NDS        ,
								@NewRefund                  	= Refund                  ,
								@NewDate_Refund             	= Date_Refund             ,
								@NewReturn_Note             	= Return_Note             ,
								@NewOld_Price_NDS           	= Old_Price_NDS           ,
								@NewJSON_Size_Volume        	= JSON_Size_Volume        ,
								@NewNew_Price_NDS           	= New_Price_NDS           ,
								@NewNew_Price_no_NDS        	= New_Price_no_NDS        ,
								@NewDate_Сreated                = Date_Сreated            ,
								@NewDescription                 = [Description]        	  
							FROM inserted;									 

							SELECT 
							    @OldID_Exemplar             	= ID_Exemplar             ,
								@OldId_Item                 	= Id_Item                 ,
								@OldID_Currency             	= ID_Currency             ,
								@OldID_Storage_location     	= ID_Storage_location     ,
								@OldKeySource               	= KeySource               ,
								@OldSerial_number           	= Serial_number           ,
								@OldID_Condition_of_the_item	= ID_Condition_of_the_item,
								@OldOld_Price_no_NDS        	= Old_Price_no_NDS        ,
								@OldRefund                  	= Refund                  ,
								@OldDate_Refund             	= Date_Refund             ,
								@OldReturn_Note             	= Return_Note             ,
								@OldOld_Price_NDS           	= Old_Price_NDS           ,
								@OldJSON_Size_Volume        	= JSON_Size_Volume        ,
								@OldNew_Price_NDS           	= New_Price_NDS           ,
								@OldNew_Price_no_NDS        	= New_Price_no_NDS        ,
								@OldDate_Сreated                = Date_Сreated            , 
								@OldDescription                 = [Description]        	  					
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Exemplar_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Exemplar_Audit
                            ( 
                               ID_Exemplar       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Exemplar
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

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

                            SELECT 
							    @OldID_Exemplar_2             	  = ID_Exemplar              ,
								@OldId_Item_2                 	  = Id_Item                  ,
								@OldID_Currency_2             	  = ID_Currency              ,
								@OldID_Storage_location_2     	  = ID_Storage_location      ,
								@OldKeySource_2               	  = KeySource                ,
								@OldSerial_number_2           	  = Serial_number            ,
								@OldID_Condition_of_the_item_2	  = ID_Condition_of_the_item ,
								@OldOld_Price_no_NDS_2        	  = Old_Price_no_NDS         ,
								@OldRefund_2                  	  = Refund                   ,
								@OldDate_Refund_2             	  = Date_Refund              ,
								@OldReturn_Note_2             	  = Return_Note              ,
								@OldOld_Price_NDS_2           	  = Old_Price_NDS            ,
								@OldJSON_Size_Volume_2        	  = JSON_Size_Volume         ,
								@OldNew_Price_NDS_2           	  = New_Price_NDS            ,
								@OldNew_Price_no_NDS_2        	  = New_Price_no_NDS         ,
								@OldDate_Сreated_2                = Date_Сreated             ,
								@OldDescription_2                 = [Description]        
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Exemplar_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Exemplar_Audit
                    ( 
                          ID_Exemplar  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Exemplar
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Exemplar_3 BIGINT;
                    SELECT @ID_Exemplar_3 = ID_Exemplar FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Exemplar = "' + CAST(@ID_Exemplar_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Exemplar_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Item_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    Id_Item                bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Item_Audit ON Item
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Item_Audit
                            ( 
                               Id_Item            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.Id_Item
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
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
						   
						   
						   
                         
							SELECT  
							        @NewId_Item                    =  Id_Item                ,
									@NewID_product_measurement	   =  ID_product_measurement ,
									@NewID_TypeItem           	   =  ID_TypeItem            ,
									@NewArticle_number        	   =  Article_number         ,
									@NewName_Item             	   =  Name_Item              ,
									@NewImage_Item            	   =  Image_Item             ,
									@NewManufacturer          	   =  Manufacturer           ,
									@NewCountry               	   =  Country                ,
									@NewCity                  	   =  City                   ,
									@NewAdress                	   =  Adress                 ,
									@NewMail                  	   =  Mail                   ,
									@NewPhone                 	   =  Phone                  ,
									@NewLogo                  	   =  Logo                   ,
									@NewDate_Сreated          	   =  Date_Сreated           ,
									@NewQuantity                   =  Quantity               ,
									@NewDescription                =  [Description]         	
							FROM inserted;									 

							SELECT 
							        @oldId_Item                    =  Id_Item                ,
									@oldID_product_measurement	   =  ID_product_measurement ,
									@oldID_TypeItem           	   =  ID_TypeItem            ,
									@oldArticle_number        	   =  Article_number         ,
									@oldName_Item             	   =  Name_Item              ,
									@oldImage_Item            	   =  Image_Item             ,
									@oldManufacturer          	   =  Manufacturer           ,
									@oldCountry               	   =  Country                ,
									@oldCity                  	   =  City                   ,
									@oldAdress                	   =  Adress                 ,
									@oldMail                  	   =  Mail                   ,
									@oldPhone                 	   =  Phone                  ,
									@oldLogo                  	   =  Logo                   ,
									@oldDate_Сreated          	   =  Date_Сreated           ,
									@oldQuantity                   =  Quantity               ,
									@OldDescription                =  [Description]         								
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Item_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Item_Audit
                            ( 
                               Id_Item       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.Id_Item
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

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

                            SELECT 
                                @OldId_Item_2                   = Id_Item               ,
								@OldID_product_measurement_2    = ID_product_measurement,
								@OldID_TypeItem_2               = ID_TypeItem           ,
								@OldArticle_number_2            = Article_number        ,
								@OldName_Item_2                 = Name_Item             ,
								@OldImage_Item_2                = Image_Item            ,
								@OldManufacturer_2              = Manufacturer          ,
								@OldCountry_2                   = Country               ,
								@OldCity_2                      = City                  ,
								@OldAdress_2                    = Adress                ,
								@OldMail_2                      = Mail                  ,
								@OldPhone_2                     = Phone                 ,
								@OldLogo_2                      = Logo                  ,
								@OldDate_Сreated_2              = Date_Сreated          ,
								@OldQuantity_2                  = Quantity              ,        
								@OldDescription_2               = [Description]        
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Item_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Item_Audit
                    ( 
                          Id_Item  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.Id_Item
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @Id_Item_3 BIGINT;
                    SELECT @Id_Item_3 = Id_Item FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Item = "' + CAST(@Id_Item_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Item_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Orders_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Orders              bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group_2;


go

CREATE TRIGGER trg_Orders_Audit ON Orders
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Orders_Audit
                            ( 
                               ID_Orders            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Orders
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                                          
	                       
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
						
                           
                           
                           

							SELECT 
                                   @NewID_Orders      =  ID_Orders      ,
								   @NewID_status      =  ID_status    	,
								   @NewID_TypeOrders  =  ID_TypeOrders	,
								   @NewID_Currency    =  ID_Currency  	,
								   @NewDate           =  Date           ,         --convert(datetime,Date,109),     
								   @NewPayment_Date   =  Payment_Date   ,         --convert(datetime,Payment_Date,109),
								   @NewAmount         =  Amount       	,
								   @NewAmountCurr     =  AmountCurr   	,
								   @NewAmountNDS      =  AmountNDS    	,
								   @NewAmountCurrNDS  =  AmountCurrNDS	,
								   @NewNum            =  Num          	,
								   @NewDescription    =  [Description]  
							FROM inserted;									 

							SELECT 
							       @OldID_Orders      =  ID_Orders      ,
								   @OldID_status      =  ID_status    	,
								   @OldID_TypeOrders  =  ID_TypeOrders	,
								   @OldID_Currency    =  ID_Currency  	,
								   @OldDate           =  Date           ,       --convert(datetime,Date,109),
								   @OldPayment_Date   =  Payment_Date   ,       --convert(datetime,Payment_Date,109),
								   @OldAmount         =  Amount       	,
								   @OldAmountCurr     =  AmountCurr   	,
								   @OldAmountNDS      =  AmountNDS    	,
								   @OldAmountCurrNDS  =  AmountCurrNDS	,
								   @OldNum            =  Num          	,
								   @OldDescription    =  [Description]  
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Orders_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Orders_Audit
                            ( 
                               ID_Orders       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Orders
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

                            DECLARE @OldID_Orders_2        bigint               ;
							DECLARE @OldID_status_2        bigint        		;
							DECLARE @OldID_TypeOrders_2    bigint        		;
							DECLARE @OldID_Currency_2      bigint        		;
							DECLARE @OldDate_2             datetime      		;
							DECLARE @OldPayment_Date_2     datetime      		;
							DECLARE @OldAmount_2           float         		;
							DECLARE @OldAmountCurr_2       float         		;
							DECLARE @OldAmountNDS_2        float         		;
							DECLARE @OldAmountCurrNDS_2    float         		;
							DECLARE @OldNum_2              nvarchar(50)  		;
							DECLARE @OldDescription_2      nvarchar(4000)		;


							SELECT 
							   @OldID_Orders_2       =  ID_Orders        ,
							   @OldID_status_2     	 =  ID_status    	 ,
							   @OldID_TypeOrders_2 	 =  ID_TypeOrders	 ,
							   @OldID_Currency_2   	 =  ID_Currency  	 ,
							   @OldDate_2          	 =  Date             ,    --convert(datetime,Date,109),         	 
							   @OldPayment_Date_2  	 =  Payment_Date     ,    --convert(datetime,Payment_Date,109), 	 
							   @OldAmount_2        	 =  Amount       	 ,
							   @OldAmountCurr_2    	 =  AmountCurr   	 ,
							   @OldAmountNDS_2     	 =  AmountNDS    	 ,
							   @OldAmountCurrNDS_2 	 =  AmountCurrNDS	 ,
							   @OldNum_2           	 =  Num          	 ,
							   @OldDescription_2   	 =  [Description]  	 
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Orders_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Orders_Audit
                    ( 
                          ID_Orders  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Orders
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Orders_3 BIGINT;
                    SELECT @ID_Orders_3 = ID_Orders FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Orders = "' + CAST(@ID_Orders_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Orders_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Orders_status_Audit
(
    AuditID              bigint IDENTITY(1,1)  not null,
    Id_Status            bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group_2;


go

CREATE TRIGGER trg_Orders_status_Audit ON Orders_status
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Orders_status_Audit
                            ( 
                               Id_Status            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.Id_Status
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                                               
	                       DECLARE @OldId_Status                  bigint        ;  
						   DECLARE @OldName                       nvarchar(300) ;
						   DECLARE @OldSysTypeOrderStatusName     nvarchar(300) ;
						   DECLARE @OldDescription                nvarchar(4000);

						   DECLARE @NewId_Status                  bigint        ;
						   DECLARE @NewName                       nvarchar(300) ;
						   DECLARE @NewSysTypeOrderStatusName     nvarchar(300) ;
						   DECLARE @NewDescription                nvarchar(4000);

							SELECT 
							       @NewId_Status              = Id_Status              ,    
							       @NewName                   = Name                   ,
							       @NewSysTypeOrderStatusName = SysTypeOrderStatusName ,
							       @NewDescription            = [Description]            
							FROM inserted;

							SELECT 
							       @OldId_Status              = Id_Status              ,
                                   @OldName                   = Name                   ,
                                   @OldSysTypeOrderStatusName = SysTypeOrderStatusName ,
                                   @OldDescription            = [Description]           
                            FROM deleted;

                         
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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Orders_status_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Orders_status_Audit
                            ( 
                               Id_Status       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.Id_Status
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

							DECLARE @OldId_Status_2                  bigint        ;  
                            DECLARE @OldName_2                       nvarchar(300) ;
                            DECLARE @OldSysTypeOrderStatusName_2     nvarchar(300) ;
                            DECLARE @OldDescription_2                nvarchar(4000);
                            
                            SELECT 
							       @OldId_Status_2               = Id_Status              ,
                                   @OldName_2                    = Name                   ,
                                   @OldSysTypeOrderStatusName_2  = SysTypeOrderStatusName ,
                                   @OldDescription_2             = [Description]           
                            FROM deleted;

                            SET @ChangeDescription = 'Deleted: '
                                  + 'Id_Status'              +' = "'+ isnull(CAST(@OldId_Status_2 AS NVARCHAR(20)),'') + '", '
                                  + 'Name'                   +' = "'+ ISNULL(@OldName_2, '') + '", '
                                  + 'SysTypeOrderStatusName' +' = "'+ ISNULL(@OldSysTypeOrderStatusName_2, '') + '", '
                                  + 'Description'            +' = "'+ ISNULL(@OldDescription_2, '') + '" ';

                          IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                          update u
						  set ChangeDescription = @ChangeDescription
						  from Orders_status_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Orders_status_Audit
                    ( 
                          Id_Status  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.Id_Status
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @Id_Status_3 BIGINT;
                    SELECT @Id_Status_3 = Id_Status FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_Status = "' + CAST(@Id_Status_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Orders_status_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Storage_location_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Storage_location       bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Storage_location_Audit ON Storage_location
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Storage_location_Audit
                            ( 
                               ID_Storage_location            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Storage_location
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
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
						   
							SELECT 
							    @NewID_Storage_location     	= ID_Storage_location     ,
								@NewID_Type_Storage_location	= ID_Type_Storage_location,
								@NewKeySource               	= KeySource               ,
								@NewName                    	= Name                    ,
								@NewCountry                 	= Country                 ,
								@NewCity                    	= City                    ,
								@NewAdress                  	= Adress                  ,
								@NewMail                    	= Mail                    ,
								@NewPhone                   	= Phone                   ,
								@NewDate_Сreated                = Date_Сreated            ,
								@NewDescription                 = [Description]        	  
							FROM inserted;									 

							SELECT 
							    @OldID_Storage_location     	= ID_Storage_location     ,
								@OldID_Type_Storage_location	= ID_Type_Storage_location,
								@OldKeySource               	= KeySource               ,
								@OldName                    	= Name                    ,
								@OldCountry                 	= Country                 ,
								@OldCity                    	= City                    ,
								@OldAdress                  	= Adress                  ,
								@OldMail                    	= Mail                    ,
								@OldPhone                   	= Phone                   ,
								@OldDate_Сreated                = Date_Сreated            ,
								@OldDescription                 = [Description]        	  					
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Storage_location_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Storage_location_Audit
                            ( 
                               ID_Storage_location       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Storage_location
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

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

                            SELECT 
							    @OldID_Storage_location_2         = ID_Storage_location     ,
								@OldID_Type_Storage_location_2	  = ID_Type_Storage_location,
								@OldKeySource_2               	  = KeySource               ,
								@OldName_2                    	  = Name                    ,
								@OldCountry_2                 	  = Country                 ,
								@OldCity_2                    	  = City                    ,
								@OldAdress_2                  	  = Adress                  ,
								@OldMail_2                    	  = Mail                    ,
								@OldPhone_2                   	  = Phone                   ,
								@OldDate_Сreated_2                = Date_Сreated            ,
								@OldDescription_2                 = [Description]        
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Storage_location_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Storage_location_Audit
                    ( 
                          ID_Storage_location  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Storage_location
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Storage_location_3 BIGINT;
                    SELECT @ID_Storage_location_3 = ID_Storage_location FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Storage_location = "' + CAST(@ID_Storage_location_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Storage_location_Audit i
					where @AuditID_3  = AuditID                

                    END

GO

CREATE TABLE TRANSACTION_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Transaction         bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Transaction_Audit ON [dbo].[Transaction]
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.TRANSACTION_Audit
                            ( 
                               ID_Transaction            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Transaction
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
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
                         
							SELECT  
                                  @NewID_Transaction          = ID_Transaction          ,
								  @NewID_Currency             = ID_Currency            	,
								  @NewID_Transaction_status   = ID_Transaction_status  	,
								  @NewID_Currency_Rate        = ID_Currency_Rate       	,
								  @NewTransaction_Date        = Transaction_Date       	,
								  @NewKeySource               = KeySource              	,
								  @NewTransaction_name_sender = Transaction_name_sender	,
								  @NewJSON_Transaction_sender = JSON_Transaction_sender	,
								  @NewTransaction_Amount      = Transaction_Amount     	,
								  @NewDescription             = [Description]                      
							FROM inserted;									 

							SELECT  
                                  @OldID_Transaction          = ID_Transaction          ,
								  @OldID_Currency             = ID_Currency            	,
								  @OldID_Transaction_status   = ID_Transaction_status  	,
								  @OldID_Currency_Rate        = ID_Currency_Rate       	,
								  @OldTransaction_Date        = Transaction_Date       	,
								  @OldKeySource               = KeySource              	,
								  @OldTransaction_name_sender = Transaction_name_sender	,
								  @OldJSON_Transaction_sender = JSON_Transaction_sender	,
								  @OldTransaction_Amount      = Transaction_Amount     	,
								  @OldDescription             = [Description]                           
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from TRANSACTION_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.TRANSACTION_Audit
                            ( 
                               ID_Transaction       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Transaction
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

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

                            SELECT
                                  @OldID_Transaction_2          = ID_Transaction          ,
								  @OldID_Currency_2             = ID_Currency             ,
								  @OldID_Transaction_status_2   = ID_Transaction_status   ,
								  @OldID_Currency_Rate_2        = ID_Currency_Rate        ,
								  @OldTransaction_Date_2        = Transaction_Date        ,
								  @OldKeySource_2               = KeySource               ,
								  @OldTransaction_name_sender_2 = Transaction_name_sender ,
								  @OldJSON_Transaction_sender_2 = JSON_Transaction_sender ,
								  @OldTransaction_Amount_2      = Transaction_Amount      ,
								  @OldDescription_2             = [Description]           
							FROM deleted;									 

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

                          update u
						  set ChangeDescription = @ChangeDescription
						  from TRANSACTION_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.TRANSACTION_Audit
                    ( 
                          ID_Transaction  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Transaction
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Transaction_3 BIGINT;
                    SELECT @ID_Transaction_3 = ID_Transaction FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Transaction = "' + CAST(@ID_Transaction_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from TRANSACTION_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Transaction_status_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_Transaction_status  bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Transaction_status_Audit ON Transaction_status
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Transaction_status_Audit
                            ( 
                               ID_Transaction_status            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Transaction_status
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
	                        DECLARE @OldID_Transaction_status      bigint           ;
						    DECLARE @OldTypeTransactionName        nvarchar(300)	;
						    DECLARE @OldSysTypeTransactionName     nvarchar(300)	;
	                        DECLARE @OldDescription                nvarchar(4000)	;

		                    DECLARE @NewID_Transaction_status      bigint           ;
							DECLARE @NewTypeTransactionName        nvarchar(300)	;
							DECLARE @NewSysTypeTransactionName     nvarchar(300)	;
							DECLARE @NewDescription                nvarchar(4000)	;
                         
							SELECT  
							     @NewID_Transaction_status    = ID_Transaction_status   , 
								 @NewTypeTransactionName      = TypeTransactionName    	,
								 @NewSysTypeTransactionName   = SysTypeTransactionName 	,
								 @NewDescription              = [Description]           
							FROM inserted;									 

							SELECT  
							     @OldID_Transaction_status    = ID_Transaction_status  ,
								 @OldTypeTransactionName      = TypeTransactionName    ,
								 @OldSysTypeTransactionName   = SysTypeTransactionName ,
								 @OldDescription              = [Description]          
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Transaction_status_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Transaction_status_Audit
                            ( 
                               ID_Transaction_status       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Transaction_status
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

							DECLARE @OldID_Transaction_status_2      bigint         ;
							DECLARE @OldTypeTransactionName_2        nvarchar(300)	;
							DECLARE @OldSysTypeTransactionName_2     nvarchar(300)	;
							DECLARE @OldDescription_2                nvarchar(4000)	;

                            SELECT 
							    @OldID_Transaction_status_2   = ID_Transaction_status  ,
								@OldTypeTransactionName_2     = TypeTransactionName    ,
								@OldSysTypeTransactionName_2  = SysTypeTransactionName ,
								@OldDescription_2             = [Description]        
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
							+ 'ID_Transaction_status'    +' = "'+  ISNULL(CAST(@OldID_Transaction_status_2 AS NVARCHAR(50)),'')     + '", '
							+ 'TypeTransactionName'      +' = "'+  ISNULL(@OldTypeTransactionName_2,'')+ '", '				
							+ 'SysTypeTransactionName'   +' = "'+  ISNULL(@OldSysTypeTransactionName_2,'')+ '", '
							+ 'Description'              +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '
						  

						  IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Transaction_status_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Transaction_status_Audit
                    ( 
                          ID_Transaction_status  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Transaction_status
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Transaction_status_3 BIGINT;
                    SELECT @ID_Transaction_status_3 = ID_Transaction_status FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Transaction_status = "' + CAST(@ID_Transaction_status_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Transaction_status_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Type_of_product_measurement_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_product_measurement bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Type_of_product_measurement_Audit ON Type_of_product_measurement
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Type_of_product_measurement_Audit
                            ( 
                               ID_product_measurement            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_product_measurement
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
						   DECLARE @OldID_product_measurement      bigint           ; 
						   DECLARE @OldProduct_measurement_Name    nvarchar(300)	;
						   DECLARE @OldSysProductMeasurementName   nvarchar(300)	;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

                           DECLARE @NewID_product_measurement      bigint           ;
						   DECLARE @NewProduct_measurement_Name    nvarchar(300)	;
						   DECLARE @NewSysProductMeasurementName   nvarchar(300)	;
						   DECLARE @NewDescription                 nvarchar(4000)	;
                         
							SELECT 
							        @NewID_product_measurement     =  ID_product_measurement   ,
									@NewProduct_measurement_Name   =  Product_measurement_Name ,
									@NewSysProductMeasurementName  =  SysProductMeasurementName,
									@NewDescription                =  [Description]         	
							FROM inserted;									 

							SELECT 
                                    @OldID_product_measurement     =  ID_product_measurement   ,
									@OldProduct_measurement_Name   =  Product_measurement_Name ,
									@OldSysProductMeasurementName  =  SysProductMeasurementName,
									@OldDescription                =  [Description]         								
							FROM Deleted;																		 

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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Type_of_product_measurement_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Type_of_product_measurement_Audit
                            ( 
                               ID_product_measurement       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_product_measurement
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

						   DECLARE @OldID_product_measurement_2      bigint         ; 
						   DECLARE @OldProduct_measurement_Name_2    nvarchar(300)	;
						   DECLARE @OldSysProductMeasurementName_2   nvarchar(300)	;
	                       DECLARE @OldDescription_2                 nvarchar(4000)	;

                            SELECT 
							    @OldID_product_measurement_2   	= ID_product_measurement    ,
								@OldProduct_measurement_Name_2 	= Product_measurement_Name  ,
								@OldSysProductMeasurementName_2 = SysProductMeasurementName ,            
								@OldDescription_2               = [Description]        
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
							+ 'ID_product_measurement'     +' = "'+  ISNULL(CAST(@OldID_product_measurement_2 AS NVARCHAR(20)),'')+ '", '
							+ 'Product_measurement_Name'   +' = "'+  ISNULL(@OldProduct_measurement_Name_2,'')+ '", '
							+ 'SysProductMeasurementName'  +' = "'+  ISNULL(@OldSysProductMeasurementName_2,'')+ '", '
							+ 'Description'                +' = "'+  ISNULL(@OldDescription_2  ,'')+ '"'

                          IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Type_of_product_measurement_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Type_of_product_measurement_Audit
                    ( 
                          ID_product_measurement  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_product_measurement
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_product_measurement_3 BIGINT;
                    SELECT @ID_product_measurement_3 = ID_product_measurement FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_product_measurement = "' + CAST(@ID_product_measurement_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Type_of_product_measurement_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE Type_Storage_location_Audit
(
    AuditID                   bigint IDENTITY(1,1)  not null,
    ID_Type_Storage_location  bigint                null,
 	ModifiedBy                nVARCHAR(128)         null,
    ModifiedDate              DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation                 CHAR(1)               null,
    ChangeDescription         nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_Type_Storage_location_Audit ON Type_Storage_location
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.Type_Storage_location_Audit
                            ( 
                               ID_Type_Storage_location            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_Type_Storage_location
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                           
						   DECLARE @OldID_Type_Storage_location    bigint           ;
						   DECLARE @OldName_Type_Storage_location  nvarchar(300)	;
						   DECLARE @OldSysNameTypeStoragelocation  nvarchar(300)	;
	                       DECLARE @OldDescription                 nvarchar(4000)	;

                           DECLARE @NewID_Type_Storage_location    bigint           ;
						   DECLARE @NewName_Type_Storage_location  nvarchar(300)	;
						   DECLARE @NewSysNameTypeStoragelocation  nvarchar(300)	;
						   DECLARE @NewDescription                 nvarchar(4000)	;
                     
                         
							SELECT 
							    @NewID_Type_Storage_location    = ID_Type_Storage_location  ,
								@NewName_Type_Storage_location	= Name_Type_Storage_location,
								@NewSysNameTypeStoragelocation  = SysNameTypeStoragelocation,            
								@NewDescription                 = [Description]        	
							FROM inserted;									 

							SELECT 
							    @OldID_Type_Storage_location    = ID_Type_Storage_location  ,
								@OldName_Type_Storage_location  = Name_Type_Storage_location,
								@OldSysNameTypeStoragelocation	= SysNameTypeStoragelocation,
								@OldDescription                 = [Description]        							
							FROM Deleted;																		 

                            
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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from Type_Storage_location_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.Type_Storage_location_Audit
                            ( 
                               ID_Type_Storage_location       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_Type_Storage_location
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

                           DECLARE @OldID_Type_Storage_location_2    bigint         ;
						   DECLARE @OldName_Type_Storage_location_2  nvarchar(300)	;
						   DECLARE @OldSysNameTypeStoragelocation_2  nvarchar(300)	;
	                       DECLARE @OldDescription_2                 nvarchar(4000)	;

                            SELECT 
							    @OldID_Type_Storage_location_2    = ID_Type_Storage_location   ,
								@OldName_Type_Storage_location_2  = Name_Type_Storage_location ,
								@OldSysNameTypeStoragelocation_2  = SysNameTypeStoragelocation ,
								@OldDescription_2                 = [Description]        
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
							+ 'ID_Type_Storage_location'   +' = "'+  ISNULL(CAST(@OldID_Type_Storage_location_2  AS NVARCHAR(50)),'')+ '", '
							+ 'Name_Type_Storage_location' +' = "'+  ISNULL(@OldName_Type_Storage_location_2,'')+ '", '
							+ 'SysNameTypeStoragelocation' +' = "'+  ISNULL(@OldSysNameTypeStoragelocation_2,'')+ '", '
							+ 'Description'                +' = "'+  ISNULL(@OldDescription_2  ,'') + '", '
                          
						   IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from Type_Storage_location_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.Type_Storage_location_Audit
                    ( 
                          ID_Type_Storage_location  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_Type_Storage_location
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_Type_Storage_location_3 BIGINT;
                    SELECT @ID_Type_Storage_location_3 = ID_Type_Storage_location FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_Type_Storage_location = "' + CAST(@ID_Type_Storage_location_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from Type_Storage_location_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE TypeItem_Audit
(
    AuditID              bigint IDENTITY(1,1)  not null,
    Id_TypeItem          bigint                null,
 	ModifiedBy           nVARCHAR(128)         null,
    ModifiedDate         DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation            CHAR(1)               null,
    ChangeDescription    nvarchar(4000)        null
 --   PRIMARY KEY CLUSTERED ( AuditID ) 
) on Products_Group_2;


go

CREATE TRIGGER trg_TypeItem_Audit ON TypeItem
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.TypeItem_Audit
                            ( 
                               Id_TypeItem            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.Id_TypeItem
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                            
                            DECLARE @OldId_TypeItem BIGINT;
                            DECLARE @OldTypeItemName NVARCHAR(300);
                            DECLARE @OldSysTypeItemName NVARCHAR(300);
                            DECLARE @OldDescription NVARCHAR(4000);	                    
	                       
							DECLARE @NewId_TypeItem BIGINT;
                            DECLARE @NewTypeItemName NVARCHAR(300);
                            DECLARE @NewSysTypeItemName NVARCHAR(300);
                            DECLARE @NewDescription NVARCHAR(4000);

							SELECT @NewId_TypeItem = Id_TypeItem,
							       @NewTypeItemName = TypeItemName, 
							       @NewSysTypeItemName = SysTypeItemName,
							       @NewDescription = [Description]
							FROM inserted;

							SELECT @OldId_TypeItem = Id_TypeItem, 
                                   @OldTypeItemName = TypeItemName, 
                                   @OldSysTypeItemName = SysTypeItemName,
                                   @OldDescription = [Description]
                            FROM deleted;

                         
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
                            SET @ChangeDescription = 'Updated: ' + ' TypeItem = "' +  isnull(cast(@OldId_TypeItem as nvarchar(20)),'')+ '" ' + @ChangeDescription
                             --Удаляем запятую на конце
                            IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from TypeItem_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.TypeItem_Audit
                            ( 
                               Id_TypeItem       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.Id_TypeItem
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

							DECLARE @OldId_TypeItem_2 BIGINT;
                            DECLARE @OldTypeItemName_2 NVARCHAR(300);
                            DECLARE @OldSysTypeItemName_2 NVARCHAR(300);
                            DECLARE @OldDescription_2 NVARCHAR(4000);
                            
                            SELECT @OldId_TypeItem_2 = Id_TypeItem, 
                                   @OldTypeItemName_2 = TypeItemName, 
                                   @OldSysTypeItemName_2 = SysTypeItemName,
                                   @OldDescription_2 = [Description]
                            FROM deleted;

                            SET @ChangeDescription = 'Deleted: '
                               + 'Id_TypeItem'    + ' = "' + isnull(CAST(@OldId_TypeItem_2 AS NVARCHAR(20)),'') + '", '
                               + 'TypeItemName'   + ' = "' + ISNULL(@OldTypeItemName_2, '') + '", '
                               + 'SysTypeItemName'+ ' = "' + ISNULL(@OldSysTypeItemName_2, '') + '", '
                               + 'Description'    + ' = "' + ISNULL(@OldDescription_2, '') + '" ';
                            
                          IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);

                          update u
						  set ChangeDescription = @ChangeDescription
						  from TypeItem_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.TypeItem_Audit
                    ( 
                          Id_TypeItem  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.Id_TypeItem
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @Id_TypeItem_3 BIGINT;
                    SELECT @Id_TypeItem_3 = Id_TypeItem FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'Id_TypeItem = "' + CAST(@Id_TypeItem_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from TypeItem_Audit i
					where @AuditID_3  = AuditID                

                    END

GO


CREATE TABLE TypeOrders_Audit
(
    AuditID                bigint IDENTITY(1,1)  not null,
    ID_TypeOrders          bigint                null,
 	ModifiedBy             nVARCHAR(128)         null,
    ModifiedDate           DATETIME              NOT NULL DEFAULT GETDATE(),
	Operation              CHAR(1)               null,
    ChangeDescription      nvarchar(4000)        null
--    PRIMARY KEY CLUSTERED ( AuditID ) 
) on Orders_Group_2;


go

CREATE TRIGGER trg_TypeOrders_Audit ON TypeOrders
AFTER INSERT, UPDATE, DELETE

AS
    DECLARE @login_name nVARCHAR(128) 
	DECLARE @ChangeDescription nvarchar(max);


    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT 0 FROM Deleted )
        BEGIN
            IF EXISTS ( SELECT 0 FROM Inserted )
                BEGIN
                    INSERT  INTO dbo.TypeOrders_Audit
                            ( 
                               ID_TypeOrders            
							   ,ModifiedBy             
                               ,ModifiedDate     
                               ,Operation                
                            )
                            SELECT  
							        d.ID_TypeOrders
                                    ,@login_name            
									,GETDATE()             
									,'U'               
                            FROM    Deleted D

				            declare @AuditID bigint
				            set @AuditID = (SELECT  SCOPE_IDENTITY())
                            
                            DECLARE @OldID_TypeOrders       bigint        ;
                            DECLARE @OldTypeOrdersName      nvarchar(300) ;
                            DECLARE @OldTypeOrdersSysName   nvarchar(300) ;
                            DECLARE @OldDescription         nvarchar(4000);                  
	                       
							DECLARE @NewID_TypeOrders       bigint        ;
                            DECLARE @NewTypeOrdersName      nvarchar(300) ;
                            DECLARE @NewTypeOrdersSysName   nvarchar(300) ;
                            DECLARE @NewDescription         nvarchar(4000); 

							SELECT 
							       @NewID_TypeOrders     = ID_TypeOrders     ,
							       @NewTypeOrdersName    = TypeOrdersName    ,
							       @NewTypeOrdersSysName = TypeOrdersSysName ,
							       @NewDescription       = [Description]      
							FROM inserted;									 

							SELECT 
                                   @OldID_TypeOrders     = ID_TypeOrders     ,
                                   @OldTypeOrdersName    = TypeOrdersName    ,
                                   @OldTypeOrdersSysName = TypeOrdersSysName ,
                                   @OldDescription       = [Description]      
							FROM Deleted;									 
                         
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
                            
                            
                            update y
							set ChangeDescription = @ChangeDescription
							from TypeOrders_Audit y
							where @AuditID  = AuditID    					
                END
            ELSE
                BEGIN
                    INSERT  INTO dbo.TypeOrders_Audit
                            ( 
                               ID_TypeOrders       
							   ,ModifiedBy       
							   ,ModifiedDate     
                               ,Operation                                                   
                            )
                            SELECT  
                                    d.ID_TypeOrders
									,@login_name 
									,GETDATE()   
                                    ,'D'                                                                     
                            FROM    Deleted D

							declare @AuditID_2 bigint
							set @AuditID_2 = (SELECT  SCOPE_IDENTITY())

							DECLARE @OldID_TypeOrders_2       bigint        ;
                            DECLARE @OldTypeOrdersName_2      nvarchar(300) ;
                            DECLARE @OldTypeOrdersSysName_2   nvarchar(300) ;
                            DECLARE @OldDescription_2         nvarchar(4000);     
                            


							SELECT 
							       @OldID_TypeOrders_2     = ID_TypeOrders     ,
							       @OldTypeOrdersName_2    = TypeOrdersName    ,
							       @OldTypeOrdersSysName_2 = TypeOrdersSysName ,
							       @OldDescription_2       = [Description]      
							FROM deleted;									 

                            SET @ChangeDescription = 'Deleted: '
                                + 'ID_TypeOrders'     +' = "'+ isnull(CAST(@OldID_TypeOrders_2 AS NVARCHAR(20)),'') + '", '
                                + 'TypeOrdersName'    +' = "'+ ISNULL(@OldTypeOrdersName_2, '') + '", '
                                + 'TypeOrdersSysName' +' = "'+ ISNULL(@OldTypeOrdersSysName_2, '') + '", '
                                + 'Description'       +' = "'+ ISNULL(@OldDescription_2, '') + '" ';


                          IF LEN(@ChangeDescription) > 0
                                SET @ChangeDescription = LEFT(@ChangeDescription, LEN(@ChangeDescription) - 1);
						  
                          update u
						  set ChangeDescription = @ChangeDescription
						  from TypeOrders_Audit u
						  where @AuditID_2  = AuditID                          
                END  
        END
    ELSE
        BEGIN
            INSERT  INTO dbo.TypeOrders_Audit
                    ( 
                          ID_TypeOrders  
						  ,ModifiedBy  
						  ,ModifiedDate
						  ,Operation				  
                            )
                            SELECT   
									I.ID_TypeOrders
									,@login_name 
									,GETDATE()   
                                    ,'I'                                                                                         
                    FROM    Inserted I

					declare @AuditID_3 bigint
					set @AuditID_3 = (SELECT  SCOPE_IDENTITY())

					DECLARE @ID_TypeOrders_3 BIGINT;
                    SELECT @ID_TypeOrders_3 = ID_TypeOrders FROM inserted;
		            
                    SET @ChangeDescription = 'Inserted: '
                                         + 'ID_TypeOrders = "' + CAST(@ID_TypeOrders_3 AS NVARCHAR(20)) + '" ';
                    
                    update i
					set ChangeDescription = @ChangeDescription
					from TypeOrders_Audit i
					where @AuditID_3  = AuditID                

                    END

GO

commit
--rolback