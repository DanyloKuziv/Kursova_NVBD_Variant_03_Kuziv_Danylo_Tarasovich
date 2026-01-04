USE [ConferenceDB]
GO

/****** Object:  Trigger [dbo].[trg_CheckPresentationDate]    Script Date: 05.01.2026 1:37:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[trg_CheckPresentationDate]
ON [dbo].[Presentations]
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Sections s ON i.SectionID = s.SectionID
        JOIN Conferences c ON s.ConferenceID = c.ConferenceID
        WHERE i.PresentationDate < c.StartDate OR i.PresentationDate > c.EndDate
    )
    BEGIN
        RAISERROR ('Дата презентації виходить за межі дат конференції!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

ALTER TABLE [dbo].[Presentations] ENABLE TRIGGER [trg_CheckPresentationDate]
GO


