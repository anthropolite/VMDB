USE [Common_items]
GO

/****** Object:  Table [dbo].[S_STIGS]    Script Date: 6/26/2018 10:41:24 PM ******/
DROP TABLE [dbo].[S_STIGS]
GO

/****** Object:  Table [dbo].[S_STIGS]    Script Date: 6/26/2018 10:41:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[S_STIGS](
	[STIG_PK] [int] IDENTITY(1,1) NOT NULL,
	[TITLE] [nvarchar](100) NOT NULL,
	[Short_Title_FK] [int] NULL,
	[Version] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Index [UCX-STIGS]    Script Date: 6/26/2018 10:42:16 PM ******/
CREATE UNIQUE CLUSTERED INDEX [UCX-STIGS] ON [dbo].[S_STIGS]
(
	[TITLE] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

