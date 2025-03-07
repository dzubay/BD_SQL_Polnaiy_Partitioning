use Magaz_DB_Poln
go


ALTER TABLE dbo.[Employees]
Add 
CONSTRAINT FK_Employees_ID_Department        Foreign key  (ID_Department)        references dbo.[Department](ID_Department)               on delete set null on Update cascade ,
CONSTRAINT FK_Employees_ID_Group             Foreign key  (ID_Group)             references dbo.[Group](ID_Group)                         on delete set null on Update cascade ,
CONSTRAINT FK_Employees_ID_The_Subgroup      Foreign key  (ID_The_Subgroup)      references dbo.[The_Subgroup](ID_The_Subgroup)           on delete set null on Update cascade ,
CONSTRAINT FK_Employees_ID_Passport          Foreign key  (ID_Passport)          references dbo.[Passport](ID_Passport)                   on delete cascade on Update cascade ,
CONSTRAINT FK_Employees_ID_Branch            Foreign key  (ID_Branch)            references dbo.[Branch](ID_Branch)                       on delete set null on Update cascade,
CONSTRAINT FK_Employees_ID_Post              Foreign key  (ID_Post)              references dbo.[Post](ID_Post)                           on delete set null on Update cascade,
CONSTRAINT FK_Employees_ID_Status_Employee   Foreign key  (ID_Status_Employee)   references dbo.[Status_Employee](ID_Status_Employee)     on delete set null on Update cascade,
CONSTRAINT FK_Employees_ID_Connection_String Foreign key  (ID_Connection_String) references dbo.[Connection_String](ID_Connection_String) on delete set null on Update cascade 
go
ALTER TABLE dbo.[Department]
Add 
CONSTRAINT FK_Department_ID_Head_Department      Foreign key  (ID_Head_Department)      references dbo.[Employees](ID_Employee),
CONSTRAINT FK_Department_ID_Vice_Head_Department Foreign key  (ID_Vice_Head_Department) references dbo.[Employees](ID_Employee),
CONSTRAINT FK_Department_ID_Branch               Foreign key  (ID_Vice_Head_Department) references dbo.[Branch](ID_Branch)  
go
ALTER TABLE dbo.[Group]
Add 
CONSTRAINT FK_Group_ID_Head_Group      Foreign key  (ID_Head_Group)      references dbo.[Employees](ID_Employee) ,
CONSTRAINT FK_Group_ID_Vice_Head_Group Foreign key  (ID_Vice_Head_Group) references dbo.[Employees](ID_Employee),
CONSTRAINT FK_Group_ID_Department      Foreign key  (ID_Department)      references dbo.[Department](ID_Department),
CONSTRAINT FK_Group_ID_Branch          Foreign key  (ID_Branch)          references dbo.[Branch](ID_Branch)
go
ALTER TABLE dbo.[The_Subgroup]
Add 
CONSTRAINT FK_The_Subgroup_ID_Head_The_Subgroup       Foreign key  (ID_Head_The_Subgroup)      references dbo.[Employees](ID_Employee),
CONSTRAINT FK_The_Subgroup_ID_Vice_Head_The_Subgroup  Foreign key  (ID_Vice_Head_The_Subgroup) references dbo.[Employees](ID_Employee),
CONSTRAINT FK_The_Subgroup_ID_Group                   Foreign key  (ID_Group)                  references dbo.[Group](ID_Group),
CONSTRAINT FK_The_Subgroup_ID_Branch                  Foreign key  (ID_Branch)                 references dbo.[Branch](ID_Branch)
go
ALTER TABLE dbo.[Post]
Add
CONSTRAINT FK_Post_ID_Department   Foreign key  (ID_Department)   references dbo.[Department](ID_Department),
CONSTRAINT FK_Post_ID_Group        Foreign key  (ID_Group)        references dbo.[Group](ID_Group),
CONSTRAINT FK_Post_ID_The_Subgroup Foreign key  (ID_The_Subgroup) references dbo.[The_Subgroup](ID_The_Subgroup)
go
ALTER TABLE dbo.[Branch]
Add
CONSTRAINT FK_Branch_Id_Country Foreign key  (Id_Country) references dbo.[Country](Id_Country)  on delete set null on Update cascade
go
ALTER TABLE dbo.[Orders]
ADD
constraint  FK_ID_Orders_status        foreign key (ID_status)            references [dbo].Orders_status      on delete NO ACTION,
constraint  FK_ID_TypeOrders           foreign key (ID_TypeOrders)        references [dbo].TypeOrders         on delete NO ACTION,
constraint  FK_ID_Currency_Orders      foreign key (ID_Currency  )        references [dbo].Currency           on delete NO ACTION,
constraint  FK_ID_OrderAssignment      foreign key (ID_OrderAssignment)   references [dbo].Order_Assignment   on delete NO ACTION,
constraint  FK_ID_OrderCategory        foreign key (ID_OrderCategory  )   references [dbo].Order_category     on delete NO ACTION
go
ALTER TABLE   dbo.[Buyer]
ADD 
constraint FK_ID_Connection_Buyer  foreign key (ID_Connection_Buyer)   references dbo.Connection_Buyer  on delete NO ACTION,
constraint FK_Id_Buyer_statuss     foreign key (Id_Status)             references dbo.Buyer_status      on delete NO ACTION,
constraint FK_Id_Buyer_Type        foreign key (Id_Buyer_Type)         references dbo.Buyer_Type      on delete NO ACTION
go
ALTER TABLE dbo.[Currency_Rate]
ADD
constraint      FK_ID_Currency_Rate     foreign key (ID_Currency)        references [dbo].Currency      on delete NO ACTION
go
ALTER TABLE [dbo].[TRANSACTION]
ADD
constraint FK_ID_Currency_Transaction            foreign key (ID_Currency)             references [dbo].Currency                on delete NO ACTION,
constraint FK_ID_Transaction_status              foreign key (ID_Transaction_status)   references [dbo].Transaction_status      on delete NO ACTION,
constraint FK_ID_Currency_Rate_ID_Transaction    foreign key (ID_Currency_Rate)        references [dbo].Currency_Rate           on delete NO ACTION
GO
ALTER TABLE  dbo.[Item]
ADD
constraint FK_ID_TypeItem                   foreign key (ID_TypeItem)              references [dbo].TypeItem                       on delete NO ACTION,
constraint FK_ID_product_measurement        foreign key (ID_product_measurement)   references [dbo].Type_of_product_measurement    on delete NO ACTION
GO
ALTER TABLE dbo.[Storage_location]
ADD
constraint FK_ID_Type_Storage_location     foreign key (ID_Type_Storage_location)        references [dbo].Type_Storage_location    on delete NO ACTION,
constraint FK_ID_Status_Storage_location   Foreign key(Id_Status)                        references  [dbo].Storage_location_status on delete no action 
GO
ALTER TABLE dbo.[Exemplar]
ADD
constraint FK_ID_Item                  foreign key (Id_Item)                  references [dbo].Item                    on delete NO ACTION,
constraint FK_ID_Currency_Exemplar     foreign key (ID_Currency)              references [dbo].Currency                on delete NO ACTION,
constraint FK_ID_Storage_location      foreign key (ID_Storage_location)      references [dbo].Storage_location        on delete NO ACTION,
constraint FK_ID_Condition_of_the_item foreign key (ID_Condition_of_the_item) references [dbo].Condition_of_the_item   on delete NO ACTION
GO
ALTER TABLE dbo.[Data_Orders]
ADD
constraint FK_ID_Employee                   foreign key (ID_Employee)       references [dbo].Employees       on delete NO ACTION, 
constraint FK_ID_Orders                     foreign key (ID_Orders)         references [dbo].Orders          on delete NO ACTION,
constraint FK_Id_buyer                      foreign key (Id_buyer)          references [dbo].buyer           on delete NO ACTION, 
constraint FK_ID_Transaction_Data_Orders    foreign key (ID_Transaction)    references [dbo].[Transaction]   on delete NO ACTION,
constraint FK_ID_Exemplar_Data_Orders       foreign key (ID_Exemplar)       references [dbo].Exemplar        on delete NO ACTION 
GO