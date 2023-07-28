
---- INSERT TICKET NUMBER DATA FOR GAMES START ----
----delete from dbo.Feedbacks
----delete from dbo.PlaceWagers
----delete from dbo.Winners
----delete from dbo.Games
----delete from dbo.GameOrders
----delete from dbo.GameTickets
----DBCC CHECKIDENT ('Games', RESEED, 0);
----DBCC CHECKIDENT ('GameTickets', RESEED, 0);
----DBCC CHECKIDENT ('GameOrders', RESEED, 0);
----DBCC CHECKIDENT ('Feedbacks', RESEED, 0);
----DBCC CHECKIDENT ('PlaceWagers', RESEED, 0);
----DBCC CHECKIDENT ('Winners', RESEED, 0);
-- GAME 1 - 1 DIGIT GAME
---- Create the variables for the random number generation
DECLARE @Random1 INT, @Random2 INT, @Random3 INT, @Random4 INT;
DECLARE @Upper INT;
DECLARE @Lower INT
DECLARE @Maximum INT;
---- This will create a random number between 1 and 10
SET @Lower = 1 ---- The lowest random number
SET @Upper = 9 ---- The highest random number

SET @Maximum = 0
WHILE (@Maximum < 10)
BEGIN
	SELECT @Random1 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random2 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random3 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random4 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	INSERT INTO dbo.GameTickets(game_id,ticket_number)
	SELECT 1 game_id, ltrim(rtrim(@Random1)) + '-' + ltrim(rtrim(@Random2)) + '-' + ltrim(rtrim(@Random3)) + '-' + ltrim(rtrim(@Random4)) ticket_number
	SET @Maximum = @Maximum + 1;
END
PRINT 'DONE'

-- GAME 2 - 2 DIGIT GAME
---- Create the variables for the random number generation
DECLARE @Random1 INT, @Random2 INT, @Random3 INT, @Random4 INT;
DECLARE @Upper INT;
DECLARE @Lower INT
DECLARE @Maximum INT;
---- This will create a random number between 1 and 10
SET @Lower = 1 ---- The lowest random number
SET @Upper = 10 ---- The highest random number

SET @Maximum = 0
WHILE (@Maximum < 10)
BEGIN
	SELECT @Random1 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random2 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random3 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random4 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	INSERT INTO dbo.GameTickets(game_id,ticket_number)
	SELECT 2 game_id, RIGHT('0' + ltrim(rtrim(@Random1)),2) + '-' + RIGHT('0' + ltrim(rtrim(@Random2)),2) + '-' + RIGHT('0' + ltrim(rtrim(@Random3)),2) + '-' + RIGHT('0' + ltrim(rtrim(@Random4)),2) ticket_number
	SET @Maximum = @Maximum + 1;
END
PRINT 'DONE'

--GO
----GAME 3 - 3 DIGIT GAME
---- Create the variables for the random number generation
DECLARE @Random1 INT, @Random2 INT, @Random3 INT, @Random4 INT;
DECLARE @Upper INT;
DECLARE @Lower INT
DECLARE @Maximum INT;
---- This will create a random number between 1 and 10
SET @Lower = 1 ---- The lowest random number
SET @Upper = 999 ---- The highest random number

SET @Maximum = 0
WHILE (@Maximum < 10)
BEGIN
	SELECT @Random1 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random2 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random3 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random4 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	INSERT INTO dbo.GameTickets(game_id,ticket_number)
	SELECT 3 game_id, RIGHT('00' + ltrim(rtrim(@Random1)),3) + '-' + RIGHT('00' + ltrim(rtrim(@Random2)),3) + '-' + RIGHT('00' + ltrim(rtrim(@Random3)),3) + '-' + RIGHT('00' + ltrim(rtrim(@Random4)),3) ticket_number
	SET @Maximum = @Maximum + 1;
END
PRINT 'DONE'

----GAME 34 - 4 DIGIT GAME
---- Create the variables for the random number generation
DECLARE @Random1 INT, @Random2 INT, @Random3 INT, @Random4 INT;
DECLARE @Upper INT;
DECLARE @Lower INT
DECLARE @Maximum INT;
---- This will create a random number between 1 and 10
SET @Lower = 1 ---- The lowest random number
SET @Upper = 9999 ---- The highest random number

SET @Maximum = 0
WHILE (@Maximum < 10)
BEGIN
	SELECT @Random1 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random2 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random3 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random4 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	INSERT INTO dbo.GameTickets(game_id,ticket_number)
	SELECT 4 game_id, RIGHT('000' + ltrim(rtrim(@Random1)),4) + '-' + RIGHT('000' + ltrim(rtrim(@Random2)),4) + '-' + RIGHT('000' + ltrim(rtrim(@Random3)),4) + '-' + RIGHT('000' + ltrim(rtrim(@Random4)),4) ticket_number
	SET @Maximum = @Maximum + 1;
END
PRINT 'DONE'

---- INSERT TICKET NUMBER DATA FOR GAMES END ----
