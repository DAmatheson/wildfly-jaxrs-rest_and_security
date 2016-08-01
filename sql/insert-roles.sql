USE [jdbc_realm]
GO

INSERT INTO [dbo].[Roles]
           ([name]
           ,[description])
     VALUES
           ('superadmin'
           ,'Can Do Everything')
GO

INSERT INTO [dbo].[Roles]
           ([name]
           ,[description])
     VALUES
           ('admin'
           ,'Can Do Most Things')
GO

INSERT INTO [dbo].[Roles]
           ([name]
           ,[description])
     VALUES
           ('eventmanager'
           ,'Can Manage Events')
GO

INSERT INTO [dbo].[Roles]
           ([name]
           ,[description])
     VALUES
           ('dataentry'
           ,'Can do data entry tasks')
GO


