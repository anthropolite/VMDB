USE [Common_items]
GO

/****** Object:  Table [dbo].[S_Machine_Types]    Script Date: 6/26/2018 10:44:45 PM ******/
DROP TABLE [dbo].[S_Machine_Types]
GO

/****** Object:  Table [dbo].[S_Machine_Types]    Script Date: 6/26/2018 10:44:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[S_Machine_Types](
	[Mach_Type_PK] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Responsability] [nvarchar](50) NULL
) ON [PRIMARY]
GO


/****** Object:  Index [UCX-Mach_Types]    Script Date: 6/26/2018 10:44:58 PM ******/
CREATE UNIQUE CLUSTERED INDEX [UCX-Mach_Types] ON [dbo].[S_Machine_Types]
(
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO