USE [Common_items]
GO

/****** Object:  Table [dbo].[JT_MachType_STIGS]    Script Date: 6/26/2018 11:07:10 PM ******/
DROP TABLE [dbo].[JT_MachType_STIGS]
GO

/****** Object:  Table [dbo].[JT_MachType_STIGS]    Script Date: 6/26/2018 11:07:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[JT_MachType_STIGS](
	[JT_MachType_Stigs_PK] [int] IDENTITY(1,1) NOT NULL,
	[S_MachType_FK] [int] NOT NULL,
	[S_STIGS_FK] [int] NOT NULL
) ON [PRIMARY]
GO


/****** Object:  Index [UCX-JT_MachType_STIGS]    Script Date: 6/26/2018 11:04:51 PM ******/
CREATE UNIQUE CLUSTERED INDEX [UCX-JT_MachType_STIGS] ON [dbo].[JT_MachType_STIGS]
(
	[S_MachType_FK] ASC,
	[S_STIGS_FK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
