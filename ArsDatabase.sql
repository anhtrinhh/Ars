USE master

GO
-- Tạo DATABASE ArsDatabase
IF(EXISTS (SELECT name FROM sys.databases WHERE name = 'ArsDatabase'))
BEGIN
DROP DATABASE ArsDatabase
END
GO
CREATE DATABASE ArsDatabase
GO

CREATE LOGIN loginname1 WITH PASSWORD = 'Complex!PW@1433',
DEFAULT_DATABASE = ArsDatabase
GO

USE ArsDatabase
GO

CREATE USER User1 FOR LOGIN loginname1
GO

EXEC sp_addrolemember 'db_owner', 'User1'

------------------------------------------- TẠO CÁC TABLE --------------------------------------------

-- Tạo bảng TimeSlot(Khung giờ bay)
CREATE TABLE TimeSlot(
	TimeSlotId INT IDENTITY PRIMARY KEY,
	StartTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	StartPointId VARCHAR(10) NOT NULL,
	EndPointId VARCHAR(10) NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- Tạo bảng Guest(Hành khách)
CREATE TABLE CustomerAccount (
	CustomerNo VARCHAR(20) PRIMARY KEY,
	CustomerFirstName NVARCHAR(50) NOT NULL,
	CustomerLastName NVARCHAR(50) NOT NULL,
	CustomerGender BIT NOT NULL, -- 0: Nam, 1: Nữ
	CustomerBirthday DATE NOT NULL,
	CustomerPhoneNumber VARCHAR(15) NOT NULL UNIQUE,
	CustomerEmail VARCHAR(100) NOT NULL UNIQUE,
	CustomerPassword NVARCHAR(200),
	CustomerIdentification VARCHAR(50) NOT NULL UNIQUE,
	CustomerAvatar NVARCHAR(200) NOT NULL DEFAULT 'guest_avatar.png',
	CustomerAddress NVARCHAR(200) NOT NULL,
	Salt VARCHAR(100),
	EmailToken NVARCHAR(10),
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CHECK(CustomerBirthday < DATEADD(year, -18, GETDATE()))
)
GO

-- Tạo bảng Flight(Chuyến bay)
CREATE TABLE Flight(
	FlightId VARCHAR(20) PRIMARY KEY,
	StartTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	FlightStatus BIT NOT NULL DEFAULT 0,
	FlightDate DATE NOT NULL,
	FlightNote NVARCHAR(200),
	StartPointId VARCHAR(10) NOT NULL,
	EndPointId VARCHAR(10) NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- Tạo bảng Booking (Đặt vé)
CREATE TABLE Booking (
	BookingId VARCHAR(30) PRIMARY KEY,
	NumberAdults INT NOT NULL,
	NumberChildren INT NOT NULL,
	NumberInfants INT NOT NULL,
	TotalCustomer INT NOT NULL,
	TotalTex FLOAT NOT NULL,
	TotalTicketPrice FLOAT NOT NULL,
	TotalPrice FLOAT NOT NULL,
	CustomerNo VARCHAR(20) NOT NULL,
	FlightId VARCHAR(20) NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Booking_CustomerNo FOREIGN KEY(CustomerNo) REFERENCES CustomerAccount(CustomerNo),
	CONSTRAINT FK_Booking_FlightId FOREIGN KEY(FlightId) REFERENCES Flight(FlightId),
	CHECK(NumberAdults >= 0), CHECK(NumberChildren >= 0), CHECK(NumberInfants >= 0), CHECK(TotalCustomer >= 0),
	CHECK(TotalTex >= 0), CHECK(TotalTicketPrice >= 0), CHECK(TotalPrice >= 0)
)
GO

-- Tạo bảng hạng vé
CREATE TABLE TicketClass(
	TicketClassId VARCHAR(10) PRIMARY KEY,
	TicketClassName NVARCHAR(50) NOT NULL UNIQUE,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- Tạo bảng TicketClassDetail
CREATE TABLE TicketClassDetail(
	TicketClassDetailId INT IDENTITY PRIMARY KEY,
	TicketClassId VARCHAR(10) NOT NULL,
	FlightId VARCHAR(20) NOT NULL,
	AdultTicketPrice FLOAT NOT NULL,
	ChildTicketPrice FLOAT NOT NULL,
	InfantTicketPrice FLOAT NOT NULL,
	AdultTex FLOAT NOT NULL,
	ChildTex FLOAT NOT NULL,
	InfantTex FLOAT NOT NULL,
	NumberTicket INT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
	CONSTRAINT FK_TicketClassDetail_TicketClassId FOREIGN KEY(TicketClassId) REFERENCES TicketClass(TicketClassId),
	CONSTRAINT FK_TicketClassDetail_FlightId FOREIGN KEY(FlightId) REFERENCES Flight(FlightId),
	CHECK(AdultTicketPrice >= 0), CHECK(ChildTicketPrice >= 0), CHECK(InfantTicketPrice >= 0),
	CHECK(AdultTex >= 0), CHECK(ChildTex >= 0), CHECK(InfantTex >= 0), CHECK(NumberTicket >= 0)
)
GO

-- Tạo bảng Ticket(Vé)
CREATE TABLE Ticket(
	TicketId INT IDENTITY PRIMARY KEY,
	BookingId VARCHAR(30) NOT NULL,
	TicketClassDetailId INT NOT NULL,
	TicketClass NVARCHAR(50) NOT NULL,
	TicketPrice FLOAT NOT NULL,
	GuestFirstName NVARCHAR(50) NOT NULL,
	GuestLastName NVARCHAR(50) NOT NULL,
	GuestGender BIT NOT NULL,
	GuestBirthday DATETIME NOT NULL,
	TicketStatus BIT NOT NULL DEFAULT 1, 
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Ticket_BookingId FOREIGN KEY(BookingId) REFERENCES Booking(BookingId),
	CONSTRAINT FK_Ticket_TicketClassDetailId FOREIGN KEY(TicketClassDetailId) REFERENCES TicketClassDetail(TicketClassDetailId),
	CHECK(TicketPrice >= 0)
)
GO

-- Tạo bảng Admin(Dành cho quản trị)
CREATE TABLE AdminAccount(
	AdminId INT IDENTITY PRIMARY KEY,
	AdminFirstName NVARCHAR(50) NOT NULL,
	AdminLastName NVARCHAR(50) NOT NULL,
	AdminPassword VARCHAR(200) NOT NULL,
	AdminAvatar NVARCHAR(100) NOT NULL DEFAULT 'admin_avatar.png',
	AdminBirthday DATE NOT NULL,
	AdminEmail VARCHAR(50) NOT NULL UNIQUE,
	AdminPhoneNumber VARCHAR(20) NOT NULL UNIQUE,
	AdminGender BIT NOT NULL,
	Salt VARCHAR(100) NOT NULL,
	CreatorId INT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_AdminAccount_CreatorId FOREIGN KEY(CreatorId) REFERENCES AdminAccount(AdminId)
)
GO

-- Tạo bảng ArticleType
CREATE TABLE ArticleType(
	ArticleTypeId INT IDENTITY PRIMARY KEY,
	ArticleTypeName NVARCHAR(50) NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- Tạo bảng Article(Bài Viết)
CREATE TABLE Article(
	ArticleId INT IDENTITY PRIMARY KEY,
	ArticleTitle NVARCHAR(100) NOT NULL,
	ArticleContent NTEXT NOT NULL,
	ArticleTypeId INT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Article_ArticleTypeId FOREIGN KEY(ArticleTypeId) REFERENCES ArticleType(ArticleTypeId)
)
GO

-- Tạo bảng ArticleStaticFile
CREATE TABLE ArticleFile(
	ArticleFileId INT IDENTITY PRIMARY KEY,
	ArticleFileName NVARCHAR(50) NOT NULL,
	ArticleId INT NOT NULL,
	ArticleFileType BIT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_ArticleFile_ArticleId FOREIGN KEY(ArticleId) REFERENCES Article(ArticleId)
)
GO


------------------------------------------- Đánh dấu chỉ mục --------------------------------------------

CREATE INDEX ix_flight 
ON Flight(StartTime, EndTime, FlightDate, StartPointId, EndPointId, FlightStatus)
GO
CREATE INDEX ix_timeSlot 
ON TimeSlot(StartTime, EndTime, StartPointId, EndPointId)
GO

------------------------------------------- TẠO CÁC TRIGGER --------------------------------------------

CREATE TRIGGER tg_forInsertTimeSlot
ON TimeSlot
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @startTime AS TIME
	DECLARE @endTime AS TIME
	DECLARE @startPointId AS VARCHAR(10)
	DECLARE @endPointId AS VARCHAR(10)
	SELECT @startTime = StartTime, @endTime = EndTime, @startPointId = StartPointId, @endPointId = EndPointId
	FROM inserted
	IF EXISTS(SELECT StartTime 
	FROM TimeSlot 
	WHERE StartTime = @startTime AND EndTime = @endTime AND StartPointId = @startPointId AND EndPointId = @endPointId)
		BEGIN
			RAISERROR('TimeSlot already exists in the system!', 16, 1)
		END
	ELSE 
		BEGIN
			INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES(@startTime, @endTime, @startPointId, @endPointId)
		END
END
GO

CREATE TRIGGER tg_forInsertFlight
ON Flight
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @flightId AS VARCHAR(20)
	DECLARE @startTime AS TIME
	DECLARE @endTime AS TIME
	DECLARE @startPointId AS VARCHAR(10)
	DECLARE @endPointId AS VARCHAR(10)
	DECLARE @flightDate AS DATE
	DECLARE @flightNote AS NVARCHAR(200)
	SELECT @flightId = FlightId, @startTime=StartTime, @endTime=EndTime, @startPointId=StartPointId,
	@endPointId=EndPointId, @flightDate = FlightDate, @flightNote=FlightNote FROM inserted
	IF EXISTS(SELECT StartTime 
	FROM Flight
	WHERE StartTime = @startTime AND EndTime = @endTime AND FlightDate = @flightDate)
		BEGIN
			RAISERROR('This time slot was used on this day!', 16, 1)
		END
	ELSE 
		BEGIN
			INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote)
			VALUES(@flightId, @startTime, @endTime, @startPointId, @endPointId, @flightDate, @flightNote)
		END
END
GO

CREATE TRIGGER tg_insteadInsertBooking
ON Booking
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @bookingId AS VARCHAR(30)
	DECLARE @numberAdults AS INT
	DECLARE @numberChildren AS INT
	DECLARE @numberInfants AS INT
	DECLARE @totalTex AS FLOAT
	DECLARE @totalTicketPrice AS FLOAT
	DECLARE @customerNo AS VARCHAR(20)
	DECLARE @flightId AS VARCHAR(20)
	SELECT @bookingId = BookingId, @numberAdults = inserted.NumberAdults, @numberChildren = inserted.NumberChildren,
	@numberInfants = inserted.NumberInfants, @totalTex = inserted.TotalTex, @totalTicketPrice = inserted.TotalTicketPrice,
	@customerNo = inserted.CustomerNo, @flightId = inserted.FlightId
	FROM inserted
	INSERT INTO Booking(BookingId, NumberAdults, NumberChildren, NumberInfants, TotalCustomer, TotalTex, TotalTicketPrice, TotalPrice, CustomerNo, FlightId)
	VALUES (@bookingId, @numberAdults, @numberChildren, @numberInfants, @numberAdults + @numberChildren + @numberInfants, @totalTex, @totalTicketPrice,
	@totalTex + @totalTicketPrice, @customerNo, @flightId)
END
GO

CREATE TRIGGER tg_forInsertTicket
ON Ticket
FOR INSERT 
AS
BEGIN
	UPDATE TicketClassDetail SET NumberTicket = NumberTicket - 1 FROM inserted, TicketClassDetail 
	WHERE inserted.TicketClassDetailId = TicketClassDetail.TicketClassDetailId
END
GO

CREATE TRIGGER tg_forDeteleTicket
ON Ticket
FOR DELETE
AS
BEGIN
	UPDATE TicketClassDetail SET NumberTicket = NumberTicket + 1 FROM inserted, TicketClassDetail 
	WHERE inserted.TicketClassDetailId = TicketClassDetail.TicketClassDetailId
END
GO

CREATE TRIGGER tg_insteadDeleteBooking
ON Booking
INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM Ticket FROM deleted WHERE deleted.BookingId = Ticket.BookingId
	DELETE FROM Booking FROM deleted WHERE Booking.BookingId = deleted.BookingId
END
GO

------------------------------------------- TẠO CÁC PRODURE STORAGE --------------------------------------------

CREATE PROC sp_getAllCustomer
AS
SELECT * FROM CustomerAccount
GO

CREATE PROC sp_getCustomerBySignInInfo(@signin AS VARCHAR(50))
AS
SELECT * FROM CustomerAccount WHERE CustomerEmail = @signin OR CustomerNo = @signin OR CustomerPhoneNumber = @signin
GO

CREATE PROC sp_getCustomerByCustomerNo(@customerNo AS VARCHAR(20))
AS
SELECT * FROM CustomerAccount WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_getAllAdmin
AS
SELECT * FROM AdminAccount
GO

CREATE PROC sp_getAdminBySignInInfo(@email AS VARCHAR(50))
AS
SELECT * FROM AdminAccount WHERE AdminEmail = @email
GO

CREATE PROC sp_insertCustomer(@customerNo AS VARCHAR(20), @customerFirstName AS NVARCHAR(50), @customerLastName AS NVARCHAR(50), 
@customerEmail AS VARCHAR(50), @customerPhoneNumber AS VARCHAR(15), @customerGender AS BIT, @customerBirthday AS DATE,
@customerIdentification AS VARCHAR(50), @customerAddress AS NVARCHAR(200))
AS 
INSERT INTO CustomerAccount(CustomerNo, CustomerFirstName, CustomerLastName, CustomerEmail, CustomerPhoneNumber, 
CustomerGender, CustomerBirthday, CustomerIdentification, CustomerAddress)
VALUES(@customerNo, @customerFirstName, @customerLastName, @customerEmail, @customerPhoneNumber,
@customerGender, @customerBirthday, @customerIdentification, @customerAddress)
GO

CREATE PROC sp_updateCustomerAvatar(@customerNo AS VARCHAR(20), @customerAvatar AS NVARCHAR(200))
AS
UPDATE CustomerAccount SET CustomerAvatar = @customerAvatar, UpdatedAt = GETDATE() WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_updateCustomerEmailToken(@customerNo AS VARCHAR(20), @emailToken AS VARCHAR(10))
AS 
UPDATE CustomerAccount SET EmailToken = @emailToken, UpdatedAt = GETDATE() WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_updateCustomerPassword(@customerNo AS VARCHAR(20), @customerPassword AS NVARCHAR(200), @salt AS VARCHAR(100))
AS 
UPDATE CustomerAccount SET CustomerPassword = @customerPassword, Salt = @salt, UpdatedAt = GETDATE() WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_updateCustomerBasicInfo(@customerNo AS VARCHAR(20), @customerFirstName AS NVARCHAR(50), @customerLastName AS NVARCHAR(50),
@customerBirthday AS DATE, @customerGender AS BIT)
AS
UPDATE CustomerAccount SET CustomerFirstName = @customerFirstName, CustomerLastName = @customerLastName,
CustomerGender = @customerGender,CustomerBirthday = @customerBirthday, UpdatedAt = GETDATE() WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_updateCustomerContactInfo(@customerNo AS VARCHAR(20), @customerPhoneNumber AS VARCHAR(15),
@customerIdentification AS VARCHAR(50), @customerAddress AS NVARCHAR(200))
AS
UPDATE CustomerAccount SET CustomerPhoneNumber = @customerPhoneNumber,
CustomerIdentification = @customerIdentification, CustomerAddress = @customerAddress, UpdatedAt = GETDATE()
WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_deleteCustomer(@customerNo AS VARCHAR(20))
AS
DELETE FROM CustomerAccount WHERE CustomerNo = @customerNo
GO

CREATE PROC sp_searchFlights(@startPointId AS VARCHAR(10), @endPointId AS VARCHAR(10), @flightDate AS DATE)
AS
SELECT * FROM Flight WHERE StartPointId = @startPointId AND EndPointId = @endPointId AND FlightDate = @flightDate AND FlightStatus = 0
GO

CREATE PROC sp_getTicketClassDetailsByFlightId(@flightId AS VARCHAR(20))
AS
SELECT * FROM TicketClassDetail WHERE FlightId = @flightId
GO

CREATE PROC sp_insertBooking(@bookingId AS VARCHAR(20), @numberAdults AS INT, @numberChildren AS INT, @numberInfants AS INT, 
@totalTex AS FLOAT, @totalTicketPrice AS FLOAT, @customerNo AS VARCHAR(20), @flightId AS VARCHAR(20))
AS
INSERT INTO Booking(BookingId, NumberAdults, NumberChildren, NumberInfants, TotalTex, TotalTicketPrice, CustomerNo, FlightId)
VALUES (@bookingId, @numberAdults, @numberChildren, @numberInfants, @totalTex, @totalTicketPrice, @customerNo, @flightId)
GO

CREATE PROC sp_insertTicket(@bookingId AS VARCHAR(20), @ticketClassDetailId AS INT, @ticketClass AS NVARCHAR(50), @ticketPrice AS FLOAT, @guestFirstName AS NVARCHAR(50),
@guestLastName AS NVARCHAR(50), @guestGender AS BIT, @guestBirthday AS DATETIME)
AS 
INSERT INTO Ticket(BookingId, TicketClassDetailId, TicketClass, TicketPrice, 
GuestFirstName, GuestLastName, GuestGender, GuestBirthday)
VALUES (@bookingId, @ticketClassDetailId, @ticketClass, @ticketPrice, @guestFirstName, @guestLastName, @guestGender, @guestBirthday)
GO

------------------------------------------- THÊM DỮ LIỆU --------------------------------------------

-- Thêm Dữ Liệu
INSERT INTO TicketClass(TicketClassId, TicketClassName) VALUES
('ECO', 'Ars Economy'), ('PRE', 'Ars Premium'), ('BUS', 'Ars Bussiness')

INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('05:45', '07:55', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('07:05', '09:05', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:10', '10:30', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:40', '12:50', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:40', '15:35', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('17:45', '19:55', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('19:45', '21:55', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('20:15', '22:25', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('23:10', '01:15', 'SGN', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('06:55', '09:05', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:20', '10:55', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:45', '12:55', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('14:05', '16:15', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:40', '18:50', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('17:25', '19:30', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('19:50', '22:00', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('21:55', '23:55', 'HAN', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('23:05', '01:10', 'HAN', 'SGN')

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR300', '05:45', '07:55', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR301', '07:05', '09:05', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR302', '08:10', '10:30', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR303', '10:40', '12:50', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR304', '13:40', '15:35', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR305', '17:45', '19:55', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR306', '19:45', '21:55', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR307', '20:15', '22:25', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR308', '23:10', '01:15', 'SGN', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR309', '06:55', '09:05', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR310', '08:20', '10:55', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR311', '10:45', '12:55', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR312', '14:05', '16:15', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR313', '16:40', '18:50', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR314', '17:25', '19:30', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR315', '19:50', '22:00', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR316', '21:55', '23:55', 'HAN', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR317', '23:05', '01:10', 'HAN', 'SGN', '2020-11-25', null)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR300', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR300', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR300', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR301', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR301', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR301', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR302', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR302', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR302', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR303', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR303', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR303', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR304', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR304', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR304', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR305', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR305', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR305', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR306', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR306', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR306', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR307', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR307', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR307', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR308', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR308', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR308', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR309', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR309', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR309', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR310', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR310', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR310', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR311', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR311', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR311', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR312', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR312', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR312', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR313', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR313', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR313', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR314', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR314', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR314', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR315', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR315', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR315', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR316', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR316', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR316', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR317', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR317', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR317', 50, 48, 5, 50, 45, 10, 12)

-- select * from CustomerAccount
-- select * from Booking
-- select * from TicketClassDetail
-- select * from Ticket
-- delete from CustomerAccount
-- delete from Booking
-- delete from Ticket