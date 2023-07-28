USE [MyLotto]
GO
/****** Object:  Table [dbo].[GameTickets]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameTickets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[game_id] [int] NOT NULL,
	[ticket_number] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GameTickets] PRIMARY KEY CLUSTERED 
(
	[ticket_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameOrders]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameOrders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[game_id] [int] NULL,
	[ticket_number] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwGameTickets]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGameTickets]
AS 
SELECT * FROM GameTickets
WHERE ticket_number NOT IN (SELECT ticket_number FROM dbo.GameOrders)
GO
/****** Object:  Table [dbo].[PlaceWagers]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlaceWagers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[game_id] [int] NULL,
	[bet_number] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwGameBetTickets]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vwGameBetTickets]
AS 
SELECT * FROM GameTickets
WHERE ticket_number NOT IN (SELECT bet_number FROM dbo.PlaceWagers)
GO
/****** Object:  Table [dbo].[Games]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Games](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[gamename] [varchar](200) NULL,
	[gameimage] [varchar](200) NULL,
	[price] [int] NULL,
	[description] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwGameOrders]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGameOrders]
AS SELECT *, (select top 1 price from dbo.Games where id=game_id) price, (select top 1 gameimage from dbo.Games where id=game_id) gameimage FROM dbo.GameOrders
GO
/****** Object:  View [dbo].[vwGameBet]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGameBet]
AS SELECT *, (select top 1 gameimage from dbo.Games where id=game_id) gameimage FROM dbo.PlaceWagers
GO
/****** Object:  Table [dbo].[Winners]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Winners](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[game_id] [int] NULL,
	[winning_number] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwWinners]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwWinners]
AS SELECT *, (select top 1 gameimage from dbo.Games where id=game_id) gameimage, winning_number winning_number_search FROM dbo.Winners
GO
/****** Object:  Table [dbo].[Feedbacks]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedbacks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[game_id] [int] NULL,
	[Rating] [int] NULL,
	[Feedback] [varchar](2000) NULL,
	[feedback_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwFeedbacks]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFeedbacks]
AS SELECT *, (select top 1 gameimage from dbo.Games where id=game_id) gameimage FROM dbo.Feedbacks
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[email] [varchar](200) NOT NULL,
	[fullname] [varchar](200) NOT NULL,
	[password] [varchar](30) NOT NULL,
	[is_active] [bit] NOT NULL,
	[is_superuser] [bit] NULL,
	[datejoined] [datetime] NULL,
	[lastlogin] [datetime] NULL,
	[group_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwUsers]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwUsers]
AS SELECT [id]
      ,[username]
      ,[email]
      ,[fullname]
      ,[password]
      ,[is_active]
      ,[is_superuser]
      ,[group_id]
FROM [dbo].[Users]
GO
/****** Object:  View [dbo].[GamePurchase]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[GamePurchase] 
AS
----select 	GM.id, GM.gamename, GM.gameimage, GM.price, GM.[description], GORD.id orderid,GORD.userid,GORD.game_id,GORD.ticket_number  
----from dbo.Games GM
----inner join dbo.GameOrders GORD on GM.id = GORD.game_id
select * from dbo.GameOrders
GO
/****** Object:  Table [dbo].[EventLog]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[event_time] [datetime] NULL,
	[table_name] [varchar](200) NULL,
	[action] [varchar](50) NULL,
	[stage] [varchar](200) NULL,
	[Users_id] [int] NULL,
	[Users_username] [varchar](50) NULL,
	[Users_email] [varchar](200) NULL,
	[Users_fullname] [varchar](200) NULL,
	[Users_password] [varchar](30) NULL,
	[Users_is_active] [bit] NULL,
	[Users_is_superuser] [bit] NULL,
	[Users_datejoined] [datetime] NULL,
	[Users_lastlogin] [datetime] NULL,
	[Users_group_id] [int] NULL,
	[Games_id] [int] NULL,
	[Games_gamename] [varchar](200) NULL,
	[Games_gameimage] [varchar](200) NULL,
	[Games_price] [int] NULL,
	[Games_description] [varchar](200) NULL,
	[GameTickets_id] [int] NULL,
	[GameTickets_game_id] [int] NULL,
	[GameTickets_ticket_number] [varchar](50) NULL,
	[GameOrders_id] [int] NULL,
	[GameOrders_userid] [int] NULL,
	[GameOrders_game_id] [int] NULL,
	[GameOrders_ticket_number] [varchar](50) NULL,
	[PlaceWagers_id] [int] NULL,
	[PlaceWagers_userid] [int] NULL,
	[PlaceWagers_game_id] [int] NULL,
	[PlaceWagers_bet_number] [varchar](50) NULL,
	[Winners_id] [int] NULL,
	[Winners_userid] [int] NULL,
	[Winners_game_id] [int] NULL,
	[Winners_winning_number] [varchar](50) NULL,
	[Feedbacks_id] [int] NULL,
	[Feedbacks_userid] [int] NULL,
	[Feedbacks_game_id] [int] NULL,
	[Feedbacks_Rating] [int] NULL,
	[Feedbacks_Feedback] [varchar](2000) NULL,
	[Feedbacks_feedback_date] [datetime] NULL,
	[Remarks] [varchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupPermissions]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupPermissions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NULL,
	[permission_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[groupname] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permission]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[content_type_id] [int] NULL,
	[codename] [varchar](200) NULL,
	[permname] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rating]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rating](
	[id] [int] NOT NULL,
	[Rating] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recommendation]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recommendation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[game_recommendation] [varchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[test]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[test] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_test] PRIMARY KEY CLUSTERED 
(
	[test] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventLog] ADD  DEFAULT (getdate()) FOR [event_time]
GO
ALTER TABLE [dbo].[Feedbacks] ADD  DEFAULT (getdate()) FOR [feedback_date]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [is_active]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [is_superuser]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [datejoined]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_Feedbacks_Rating] FOREIGN KEY([Rating])
REFERENCES [dbo].[Rating] ([id])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_Feedbacks_Rating]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_Feedbacks_Users] FOREIGN KEY([game_id])
REFERENCES [dbo].[Games] ([id])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_Feedbacks_Users]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_Feedbacks_Users1] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_Feedbacks_Users1]
GO
ALTER TABLE [dbo].[GameOrders]  WITH CHECK ADD  CONSTRAINT [FK_GameOrders_Games] FOREIGN KEY([ticket_number])
REFERENCES [dbo].[GameTickets] ([ticket_number])
GO
ALTER TABLE [dbo].[GameOrders] CHECK CONSTRAINT [FK_GameOrders_Games]
GO
ALTER TABLE [dbo].[GameOrders]  WITH CHECK ADD  CONSTRAINT [FK_GameOrders_Games1] FOREIGN KEY([game_id])
REFERENCES [dbo].[Games] ([id])
GO
ALTER TABLE [dbo].[GameOrders] CHECK CONSTRAINT [FK_GameOrders_Games1]
GO
ALTER TABLE [dbo].[GameOrders]  WITH CHECK ADD  CONSTRAINT [FK_GameOrders_Users] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[GameOrders] CHECK CONSTRAINT [FK_GameOrders_Users]
GO
ALTER TABLE [dbo].[PlaceWagers]  WITH CHECK ADD  CONSTRAINT [FK_PlaceWagers_Games] FOREIGN KEY([game_id])
REFERENCES [dbo].[Games] ([id])
GO
ALTER TABLE [dbo].[PlaceWagers] CHECK CONSTRAINT [FK_PlaceWagers_Games]
GO
ALTER TABLE [dbo].[PlaceWagers]  WITH CHECK ADD  CONSTRAINT [FK_PlaceWagers_Users] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[PlaceWagers] CHECK CONSTRAINT [FK_PlaceWagers_Users]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Groups] FOREIGN KEY([group_id])
REFERENCES [dbo].[Groups] ([id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Groups]
GO
ALTER TABLE [dbo].[Winners]  WITH CHECK ADD  CONSTRAINT [FK_Winners_Games] FOREIGN KEY([game_id])
REFERENCES [dbo].[Games] ([id])
GO
ALTER TABLE [dbo].[Winners] CHECK CONSTRAINT [FK_Winners_Games]
GO
ALTER TABLE [dbo].[Winners]  WITH CHECK ADD  CONSTRAINT [FK_Winners_GameTickets] FOREIGN KEY([winning_number])
REFERENCES [dbo].[GameTickets] ([ticket_number])
GO
ALTER TABLE [dbo].[Winners] CHECK CONSTRAINT [FK_Winners_GameTickets]
GO
ALTER TABLE [dbo].[Winners]  WITH CHECK ADD  CONSTRAINT [FK_Winners_Users] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[Winners] CHECK CONSTRAINT [FK_Winners_Users]
GO
/****** Object:  StoredProcedure [dbo].[AddWinner]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddWinner]
(
	@userid int, @game_id int, @winning_number varchar(200)
)
AS
BEGIN
INSERT INTO [dbo].[Winners]
           ([userid]
           ,[game_id]
           ,[winning_number])
VALUES     (@userid
           ,@game_id
           ,@winning_number)
END
GO
/****** Object:  StoredProcedure [dbo].[GetTickets]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTickets]
(@Search varchar(200))
AS 
BEGIN
	SET @Search = '%' + @Search + '%'
	SELECT *, (select top 1 gameimage from dbo.Games where id=game_id) gameimage 
	FROM dbo.GameTickets
	WHERE ticket_number LIKE @Search
END
GO
/****** Object:  StoredProcedure [dbo].[GetWinners]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetWinners]
(@Search varchar(200))
AS 
BEGIN
	SET @Search = '%' + @Search + '%'
	SELECT *, (select top 1 gameimage from dbo.Games where id=game_id) gameimage, winning_number winning_number_search 
	FROM dbo.Winners
	WHERE winning_number LIKE @Search
END
GO
/****** Object:  Trigger [dbo].[trgAfterFeedbacks]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trgAfterFeedbacks] ON [dbo].[Feedbacks]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Feedbacks_id],[Feedbacks_userid],[Feedbacks_game_id],[Feedbacks_Rating],[Feedbacks_Feedback],[Feedbacks_feedback_date])
		SELECT 'Feedbacks', @Operation, 'before', [id],[userid],[game_id],[Rating],[Feedback],[feedback_date] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Feedbacks_id],[Feedbacks_userid],[Feedbacks_game_id],[Feedbacks_Rating],[Feedbacks_Feedback],[Feedbacks_feedback_date])
		SELECT 'Feedbacks', @Operation, 'after', [id],[userid],[game_id],[Rating],[Feedback],[feedback_date] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Feedbacks_id],[Feedbacks_userid],[Feedbacks_game_id],[Feedbacks_Rating],[Feedbacks_Feedback],[Feedbacks_feedback_date])
		SELECT 'Feedbacks', @Operation, 'after', [id],[userid],[game_id],[Rating],[Feedback],[feedback_date] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Feedbacks_id],[Feedbacks_userid],[Feedbacks_game_id],[Feedbacks_Rating],[Feedbacks_Feedback],[Feedbacks_feedback_date])
		SELECT 'Feedbacks', @Operation, 'before', [id],[userid],[game_id],[Rating],[Feedback],[feedback_date] from deleted
	END
END
GO
ALTER TABLE [dbo].[Feedbacks] ENABLE TRIGGER [trgAfterFeedbacks]
GO
/****** Object:  Trigger [dbo].[trgAfterGameOrders]    Script Date: 24-Jul-2023 19:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgAfterGameOrders] ON [dbo].[GameOrders]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameOrders_id],[GameOrders_userid],[GameOrders_game_id],[GameOrders_ticket_number])
		SELECT 'GameOrders', @Operation, 'before', [id],[userid],[game_id],[ticket_number] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameOrders_id],[GameOrders_userid],[GameOrders_game_id],[GameOrders_ticket_number])
		SELECT 'GameOrders', @Operation, 'after', [id],[userid],[game_id],[ticket_number] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameOrders_id],[GameOrders_userid],[GameOrders_game_id],[GameOrders_ticket_number])
		SELECT 'GameOrders', @Operation, 'after', [id],[userid],[game_id],[ticket_number] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameOrders_id],[GameOrders_userid],[GameOrders_game_id],[GameOrders_ticket_number])
		SELECT 'GameOrders', @Operation, 'before', [id],[userid],[game_id],[ticket_number] from deleted
	END
END
GO
ALTER TABLE [dbo].[GameOrders] ENABLE TRIGGER [trgAfterGameOrders]
GO
/****** Object:  Trigger [dbo].[trgAfterGames]    Script Date: 24-Jul-2023 19:40:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trgAfterGames] ON [dbo].[Games]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Games_id],[Games_gamename],[Games_gameimage],[Games_price],[Games_description])
		SELECT 'Games', @Operation, 'before', [id], gamename, gameimage, price, [description] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Games_id],[Games_gamename],[Games_gameimage],[Games_price],[Games_description])
		SELECT 'Games', @Operation, 'after', [id], gamename, gameimage, price, [description] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Games_id],[Games_gamename],[Games_gameimage],[Games_price],[Games_description])
		SELECT 'Games', @Operation, 'after', [id], gamename, gameimage, price, [description] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Games_id],[Games_gamename],[Games_gameimage],[Games_price],[Games_description])
		SELECT 'Games', @Operation, 'before', [id], gamename, gameimage, price, [description] from deleted
	END
END
GO
ALTER TABLE [dbo].[Games] ENABLE TRIGGER [trgAfterGames]
GO
/****** Object:  Trigger [dbo].[trgAfterGameTickets]    Script Date: 24-Jul-2023 19:40:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgAfterGameTickets] ON [dbo].[GameTickets]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameTickets_id],[GameTickets_game_id],[GameTickets_ticket_number])
		SELECT 'GameTickets', @Operation, 'before', [id],[game_id],[ticket_number] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameTickets_id],[GameTickets_game_id],[GameTickets_ticket_number])
		SELECT 'GameTickets', @Operation, 'after', [id],[game_id],[ticket_number] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameTickets_id],[GameTickets_game_id],[GameTickets_ticket_number])
		SELECT 'GameTickets', @Operation, 'after', [id],[game_id],[ticket_number] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[GameTickets_id],[GameTickets_game_id],[GameTickets_ticket_number])
		SELECT 'GameTickets', @Operation, 'before', [id],[game_id],[ticket_number] from deleted
	END
END
GO
ALTER TABLE [dbo].[GameTickets] ENABLE TRIGGER [trgAfterGameTickets]
GO
/****** Object:  Trigger [dbo].[trgAfterPlaceWagers]    Script Date: 24-Jul-2023 19:40:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgAfterPlaceWagers] ON [dbo].[PlaceWagers]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[PlaceWagers_id],[PlaceWagers_userid],[PlaceWagers_game_id],[PlaceWagers_bet_number])
		SELECT 'PlaceWagers', @Operation, 'before', [id],[userid],[game_id],[bet_number] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[PlaceWagers_id],[PlaceWagers_userid],[PlaceWagers_game_id],[PlaceWagers_bet_number])
		SELECT 'PlaceWagers', @Operation, 'after', [id],[userid],[game_id],[bet_number] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[PlaceWagers_id],[PlaceWagers_userid],[PlaceWagers_game_id],[PlaceWagers_bet_number])
		SELECT 'PlaceWagers', @Operation, 'after', [id],[userid],[game_id],[bet_number] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[PlaceWagers_id],[PlaceWagers_userid],[PlaceWagers_game_id],[PlaceWagers_bet_number])
		SELECT 'PlaceWagers', @Operation, 'before', [id],[userid],[game_id],[bet_number] from deleted
	END
END
GO
ALTER TABLE [dbo].[PlaceWagers] ENABLE TRIGGER [trgAfterPlaceWagers]
GO
/****** Object:  Trigger [dbo].[trgAfterUsers]    Script Date: 24-Jul-2023 19:40:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgAfterUsers] ON [dbo].[Users]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Users_id],[Users_username],[Users_email],[Users_fullname],[Users_password],[Users_is_active],[Users_is_superuser],[Users_datejoined],[Users_lastlogin],[Users_group_id])
		SELECT 'Users', @Operation, 'before', [id],[username],[email],[fullname],[password],[is_active],[is_superuser],[datejoined],[lastlogin],[group_id] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Users_id],[Users_username],[Users_email],[Users_fullname],[Users_password],[Users_is_active],[Users_is_superuser],[Users_datejoined],[Users_lastlogin],[Users_group_id])
		SELECT 'Users', @Operation, 'after', [id],[username],[email],[fullname],[password],[is_active],[is_superuser],[datejoined],[lastlogin],[group_id] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Users_id],[Users_username],[Users_email],[Users_fullname],[Users_password],[Users_is_active],[Users_is_superuser],[Users_datejoined],[Users_lastlogin],[Users_group_id])
		SELECT 'Users', @Operation, 'after', [id],[username],[email],[fullname],[password],[is_active],[is_superuser],[datejoined],[lastlogin],[group_id] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Users_id],[Users_username],[Users_email],[Users_fullname],[Users_password],[Users_is_active],[Users_is_superuser],[Users_datejoined],[Users_lastlogin],[Users_group_id])
		SELECT 'Users', @Operation, 'before', [id],[username],[email],[fullname],[password],[is_active],[is_superuser],[datejoined],[lastlogin],[group_id] from deleted
	END
END
GO
ALTER TABLE [dbo].[Users] ENABLE TRIGGER [trgAfterUsers]
GO
/****** Object:  Trigger [dbo].[trgAfterWinners]    Script Date: 24-Jul-2023 19:40:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgAfterWinners] ON [dbo].[Winners]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Operation varchar(7) = 
    CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) 
        THEN 'Update'
    WHEN EXISTS(SELECT * FROM inserted) 
        THEN 'Insert'
    WHEN EXISTS(SELECT * FROM deleted)
        THEN 'Delete'
    ELSE 
        NULL --Unknown
    END

	IF (@Operation = 'Update')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Winners_id],[Winners_userid],[Winners_game_id],[Winners_winning_number])
		SELECT 'Winners', @Operation, 'before', [id],[userid],[game_id],[winning_number] from deleted
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Winners_id],[Winners_userid],[Winners_game_id],[Winners_winning_number])
		SELECT 'Winners', @Operation, 'after', [id],[userid],[game_id],[winning_number] from inserted
	END

	IF (@Operation = 'Insert')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Winners_id],[Winners_userid],[Winners_game_id],[Winners_winning_number])
		SELECT 'Winners', @Operation, 'after', [id],[userid],[game_id],[winning_number] from inserted
	END

	IF (@Operation = 'Delete')
	BEGIN
		INSERT INTO [dbo].[EventLog]
		([table_name],[action],[stage],[Winners_id],[Winners_userid],[Winners_game_id],[Winners_winning_number])
		SELECT 'Winners', @Operation, 'before', [id],[userid],[game_id],[winning_number] from deleted
	END
END
GO
ALTER TABLE [dbo].[Winners] ENABLE TRIGGER [trgAfterWinners]
GO
