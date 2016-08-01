USE [jdbc_realm]
GO

/****** Object:  Table [dbo].[Roles]    Script Date: 5/19/2016 9:37:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Roles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](16) NOT NULL,
	[description] [varchar](64) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [jdbc_realm]
GO

/****** Object:  Table [dbo].[Users]    Script Date: 5/19/2016 9:37:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[email] [varchar](254) NOT NULL,
	[password] [varchar](128) NOT NULL,
	[enabled] [bit] NOT NULL CONSTRAINT [DF_Users_enabled]  DEFAULT ((1)),
	[created] [datetime] NOT NULL CONSTRAINT [DF_Users_created]  DEFAULT (getdate()),
	[modified] [timestamp] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [jdbc_realm]
GO

/****** Object:  Table [dbo].[UserRoles]    Script Date: 5/19/2016 9:37:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserRoles](
	[userId] [int] NOT NULL,
	[roleId] [int] NOT NULL,
	[modified] [timestamp] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[userId] ASC,
	[roleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Role] FOREIGN KEY([roleId])
REFERENCES [dbo].[Roles] ([id])
GO

ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Role]
GO

ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_User] FOREIGN KEY([userId])
REFERENCES [dbo].[Users] ([id])
GO

ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_User]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign Key to Role' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserRoles', @level2type=N'CONSTRAINT',@level2name=N'FK_UserRoles_Role'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign Key to User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserRoles', @level2type=N'CONSTRAINT',@level2name=N'FK_UserRoles_User'
GO


