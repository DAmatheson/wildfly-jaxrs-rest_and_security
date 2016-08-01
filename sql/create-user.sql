USE [jdbc_realm]
GO

/****** Object:  User [jdbc_login]    Script Date: 5/19/2016 9:39:47 AM ******/
CREATE USER [jdbc_login] FOR LOGIN [jdbc_login] WITH DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE [db_owner] ADD MEMBER [jdbc_login]
GO


