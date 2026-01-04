-- Скрипт для масової генерації тестових даних
-- Обсяг: понад 500,000 записів

USE ConferenceDB;
GO

DECLARE @i INT = 1;
DECLARE @TotalRecords INT = 500000;
DECLARE @StartDate DATE = '2016-01-01';
DECLARE @RandomDays INT;
DECLARE @RandomDuration INT;

PRINT 'Початок генерації даних...';

-- Вимикаємо індекси для прискорення (опціонально для великих обсягів)
-- ALTER INDEX ALL ON Presentations DISABLE;

WHILE @i <= @TotalRecords
BEGIN
    -- Генеруємо випадкову дату в межах 10 років
    SET @RandomDays = ABS(CHECKSUM(NEWID())) % 3650; 
    -- Генеруємо випадкову тривалість від 20 до 90 хвилин
    SET @RandomDuration = 20 + (ABS(CHECKSUM(NEWID())) % 71);

    INSERT INTO Presentations (Name, PresentationDate, Duration, SpeakerID, RoomID, SectionID)
    VALUES (
        'Scientific Topic #' + CAST(@i AS VARCHAR), 
        DATEADD(day, @RandomDays, @StartDate),
        @RandomDuration,
        (SELECT TOP 1 SpeakerID FROM Speakers ORDER BY NEWID()), -- Випадковий спікер
        (SELECT TOP 1 RoomID FROM Rooms ORDER BY NEWID()),       -- Випадкова кімната
        (SELECT TOP 1 SectionID FROM Sections ORDER BY NEWID())  -- Випадкова секція
    );

    -- Виводимо прогрес кожні 50 000 записів
    IF (@i % 50000 = 0)
    BEGIN
        PRINT 'Додано ' + CAST(@i AS VARCHAR) + ' записів...';
    END

    SET @i = @i + 1;
END

-- Вмикаємо індекси назад
-- ALTER INDEX ALL ON Presentations REBUILD;

PRINT 'Генерація завершена успішно!';
GO