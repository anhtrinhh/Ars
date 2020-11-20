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
	AdminId VARCHAR(20) PRIMARY KEY,
	AdminFirstName NVARCHAR(50) NOT NULL,
	AdminLastName NVARCHAR(50) NOT NULL,
	AdminPassword VARCHAR(200) NOT NULL,
	AdminAvatar NVARCHAR(100) NOT NULL DEFAULT 'admin_avatar.png',
	AdminBirthday DATE NOT NULL,
	AdminEmail VARCHAR(50) NOT NULL UNIQUE,
	AdminPhoneNumber VARCHAR(20) NOT NULL UNIQUE,
	AdminGender BIT NOT NULL,
	AdminRights INT NOT NULL,
	Salt VARCHAR(100) NOT NULL,
	CreatorId VARCHAR(20) NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_AdminAccount_CreatorId FOREIGN KEY(CreatorId) REFERENCES AdminAccount(AdminId)
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

CREATE PROC sp_getAdminBySignInInfo(@signin AS VARCHAR(50))
AS
SELECT * FROM AdminAccount WHERE AdminEmail = @signin OR AdminPhoneNumber = @signin
GO
CREATE PROC sp_insertAdmin(@adminId AS VARCHAR(20),@creatorId AS VARCHAR(20), @adminFirstName AS NVARCHAR(50), @adminLastName AS NVARCHAR(50), @adminEmail AS VARCHAR(50), 
@adminPhoneNumber AS VARCHAR(20), @adminPassword AS VARCHAR(200), @salt AS VARCHAR(100), @adminBirthday AS DATE, @adminGender AS BIT, 
@adminRights AS INT)
AS
INSERT INTO AdminAccount(AdminId, CreatorId, AdminFirstName, AdminLastName, AdminEmail,
AdminPhoneNumber, AdminPassword, Salt, AdminBirthday, AdminGender, AdminRights)
VALUES (@adminId, @creatorId, @adminFirstName, @adminLastName, @adminEmail, @adminPhoneNumber, @adminPassword, @salt, @adminBirthday, @adminGender, @adminRights)
GO

CREATE PROC sp_updateAdmin(@adminId AS VARCHAR(20), @adminFirstName AS NVARCHAR(50), @adminLastName AS NVARCHAR(50), @adminBirthday AS DATE,
@adminGender AS BIT, @adminRights AS INT)
AS 
UPDATE AdminAccount SET AdminFirstName = @adminFirstName, AdminLastName = @adminLastName, AdminBirthday = @adminBirthday, AdminGender = @adminGender,
AdminRights = @adminRights WHERE AdminId = @adminId

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

CREATE PROC sp_insertFlight(@flightId AS VARCHAR(20),@startPointId AS VARCHAR(10), @endPointId AS VARCHAR(10), 
@flightDate AS DATE, @startTime AS TIME, @endTime AS TIME, @flightNote AS NVARCHAR(200))
AS
INSERT INTO Flight(FlightId, StartPointId, EndPointId, FlightDate, StartTime, EndTime, FlightNote)
VALUES(@flightId, @startPointId, @endPointId, @flightDate, @startTime, @endTime, @flightNote)
GO

CREATE PROC sp_updateFlightStatus(@flightStatus AS BIT, @flightId AS VARCHAR(20))
AS
UPDATE Flight SET FlightStatus = @flightStatus WHERE FlightId = @flightId
GO

CREATE PROC sp_getTicketClassDetailsByFlightId(@flightId AS VARCHAR(20))
AS
SELECT * FROM TicketClassDetail WHERE FlightId = @flightId
GO

CREATE PROC sp_insertTicketClassDetail(@ticketClassId AS VARCHAR(10), @flightId AS VARCHAR(20), @adultTicketPrice AS FLOAT,
@childTicketPrice AS FLOAT, @infantTicketPrice AS FLOAT, @adultTex AS FLOAT, @childTex AS FLOAT, @infantTex AS FLOAT, @numberTicket AS INT)
AS
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, 
AdultTex, ChildTex, InfantTex, NumberTicket)
VALUES(@ticketClassId, @flightId, @adultTicketPrice, @childTicketPrice, @infantTicketPrice, @adultTex, @childTex, @infantTex, @numberTicket)
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

CREATE PROC sp_getTimeSlotByFlightDirection(@startPointId AS VARCHAR(10), @endPointId AS VARCHAR(10))
AS
BEGIN
 SELECT * FROM TimeSlot WHERE EndPointId = @endPointId AND StartPointId = @startPointId
END
GO

CREATE PROC sp_insertTimeSlot(@startTime AS TIME, @endTime AS TIME, @startPointId AS VARCHAR(10), @endPointId AS VARCHAR(10) )
AS
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId)
VALUES (@startTime, @endTime, @startPointId, @endPointId)
GO

CREATE PROC sp_updateTimeSlot(@timeSlotId AS INT, @startTime AS TIME, @endTime AS TIME, @startPointId AS VARCHAR(10), @endPointId AS VARCHAR(10))
AS
UPDATE TimeSlot SET StartTime = @startTime, EndTime = @endTime, StartPointId = @startPointId, EndPointId = @endPointId
WHERE TimeSlotId = @timeSlotId
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

INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('17:35', '18:40', 'BMV', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('17:55', '19:40', 'BMV', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:05', '13:50', 'BMV', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('17:35', '19:15', 'BMV', 'HPH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:00', '14:00', 'BMV', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:05', '13:30', 'BMV', 'VII')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:50', '14:15', 'BMV', 'VII')

--vca
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:25', '11:55', 'VCA', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:35', '12:45', 'VCA', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('21:00', '23:15', 'VCA', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:15', '17:25', 'VCA', 'HPH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:45', '12:05', 'VCA', 'UIH')
--Khh
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:25', '18:05', 'KHH', 'HAN')
--vcs
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:20', '16:55', 'VCS', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:45', '11:00', 'VCS', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('09:40', '12:00', 'VCS', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('14:35', '16:50', 'VCS', 'HPH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:50', '18:05', 'VCS', 'HPH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:00', '12:05', 'VCS', 'THD')
--dad
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:45', '16:50', 'DAD', 'BMV')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:45', '14:15', 'DAD', 'VCA')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('07:50', '09:30', 'DAD', 'VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('09:30', '10:30', 'DAD', 'DLI')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:45', '23:05', 'DAD', 'ICN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:30', '12:50', 'DAD', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('22:20', '23:40', 'DAD', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:10', '14:30', 'DAD', 'HAN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('18:30', '19:40', 'DAD', 'HPH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:15', '14:25', 'DAD', 'HPH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:45', '10:15', 'DAD', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('21:45', '23:10', 'DAD', 'SGN')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:45', '09:55', 'DAD', 'CXR')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:40', '10:25', 'DAD', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:15', '10:00', 'DAD', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('06:30', '08:15', 'DAD', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:20', '12:30', 'DAD', 'VII')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:15', '20:25', 'TPE', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('09:15', '12:45', 'TPE', 'HAN')




--HAN
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('09:30', '11:15', 'HAN', 'BMV')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('14:15', '16:00', 'HAN', 'BMV')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('07:25', '09:35', 'HAN', 'VCA')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:45', '19:00', 'HAN', 'VCA')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:20', '12:35', 'HAN', 'VCA')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:00', '15:30', 'HAN', 'KHH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:55', '15:25', 'HAN', 'KHH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:40', '15:10', 'HAN', 'KHH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:40', '13:55', 'HAN', 'VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:45', '15:05', 'HAN', 'VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('05:50', '08:10', 'HAN', 'VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('06:40', '09:00', 'HAN', 'VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('06:45', '09:45', 'HAN', 'VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('07:20', '09:10', 'HAN', 'DLI')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:10', '18:00', 'HAN', 'DLI')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('14:35', '16:25', 'HAN', 'DLI')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('09:25', '10:40', 'HAN', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:35', '14:55', 'HAN', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('19:55', '21:15', 'HAN', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('18:55', '20:15', 'HAN', 'DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:55', '17:15', 'HAN', 'TPE')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:05', '12:55', 'HAN', 'CXR')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('14:45', '16:35', 'HAN', 'CXR')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:05', '17:55', 'HAN', 'CXR')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('08:35', '10:45', 'HAN', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:55', '16:00', 'HAN', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('16:35', '18:45', 'HAN', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('07:50', '10:00', 'HAN', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('09:00', '11:10', 'HAN', 'PQC')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('13:40', '15:15', 'HAN', 'PXU')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('07:35', '09:15', 'HAN', 'UIH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('11:35', '13:15', 'HAN', 'UIH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('12:45', '14:25', 'HAN', 'UIH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('18:15', '19:55', 'HAN', 'UIH')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('18:45', '19:45', 'HAN', 'VII')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('19:10', '20:10', 'HAN', 'VII')
--hph
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:10', '16:50', 'HPH ','BMV')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('18:10', '20:20', 'HPH ','VCA')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('06:45', '09:00', 'HPH ','VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('10:00', '12:15', 'HPH ','VCS')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('15:20', '16:30', 'HPH ','DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('19:35', '20:50', 'HPH ','DAD')
INSERT INTO TimeSlot(StartTime, EndTime, StartPointId, EndPointId) VALUES ('20:00', '21:10', 'HPH ','DAD')

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

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR342', '17:35', '18:40', 'BMV', 'DAD', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR343', '17:35', '18:40', 'BMV', 'DAD', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR344', '17:35', '18:40', 'BMV', 'DAD', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR345', '17:35', '18:40', 'BMV', 'DAD', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR346', '17:35', '18:40', 'BMV', 'DAD', '2020-11-26', null)

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR347', '17:55', '19:40', 'BMV', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR348', '17:55', '19:40', 'BMV', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR349', '17:55', '19:40', 'BMV', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR350', '17:55', '19:40', 'BMV', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR351', '17:55', '19:40', 'BMV', 'HAN', '2020-11-26', null)

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR352', '12:05', '13:50', 'BMV', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR353', '12:05', '13:50', 'BMV', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR354', '12:05', '13:50', 'BMV', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR355', '12:05', '13:50', 'BMV', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR356', '12:05', '13:50', 'BMV', 'HAN', '2020-11-26', null)

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR357', '17:35', '19:15', 'BMV', 'HPH', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR358', '17:35', '19:15', 'BMV', 'HPH', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR359', '17:35', '19:15', 'BMV', 'HPH', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR360', '17:35', '19:15', 'BMV', 'HPH', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR361', '17:35', '19:15', 'BMV', 'HPH', '2020-11-26', null)

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR362', '13:00', '14:00', 'BMV', 'SGN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR363', '13:00', '14:00', 'BMV', 'SGN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR364', '13:00', '14:00', 'BMV', 'SGN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR365', '13:00', '14:00', 'BMV', 'SGN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR366', '13:00', '14:00', 'BMV', 'SGN', '2020-11-26', null)

INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR367', '12:05', '13:30', 'BMV', 'VII', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR368', '12:05', '13:30', 'BMV', 'VII', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR369', '12:05', '13:30', 'BMV', 'VII', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR370', '12:05', '13:30', 'BMV', 'VII', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR371', '12:05', '13:30', 'BMV', 'VII', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR372', '12:50', '14:15', 'BMV', 'VII', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR373', '12:50', '14:15', 'BMV', 'VII', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR374', '12:50', '14:15', 'BMV', 'VII', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR375', '12:50', '14:15', 'BMV', 'VII', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR376', '12:50', '14:15', 'BMV', 'VII', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR377', '10:25', '11:55', 'VCA', 'DAD', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR378', '10:25', '11:55', 'VCA', 'DAD', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR379', '10:25', '11:55', 'VCA', 'DAD', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR380', '10:25', '11:55', 'VCA', 'DAD', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR381', '10:25', '11:55', 'VCA', 'DAD', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR382', '10:35', '12:45', 'VCA', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR383', '10:35', '12:45', 'VCA', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR384', '10:35', '12:45', 'VCA', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR385', '10:35', '12:45', 'VCA', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR386', '10:35', '12:45', 'VCA', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR387', '21:00', '23:15', 'VCA', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR388', '21:00', '23:15', 'VCA', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR389', '21:00', '23:15', 'VCA', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR390', '21:00', '23:15', 'VCA', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR391', '21:00', '23:15', 'VCA', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR392', '15:15', '17:25', 'VCA', 'HPH', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR393', '15:15', '17:25', 'VCA', 'HPH', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR394', '15:15', '17:25', 'VCA', 'HPH', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR395', '15:15', '17:25', 'VCA', 'HPH', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR396', '15:15', '17:25', 'VCA', 'HPH', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR397', '16:25', '18:05', 'KHH', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR398', '16:25', '18:05', 'KHH', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR399', '16:25', '18:05', 'KHH', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR400', '16:25', '18:05', 'KHH', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR401', '16:25', '18:05', 'KHH', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR402', '15:20', '16:55', 'VCS', 'DAD', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR403', '15:20', '16:55', 'VCS', 'DAD', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR404', '15:20', '16:55', 'VCS', 'DAD', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR405', '15:20', '16:55', 'VCS', 'DAD', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR406', '15:20', '16:55', 'VCS', 'DAD', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR407', '08:45', '11:00', 'VCS', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR408', '08:45', '11:00', 'VCS', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR409', '08:45', '11:00', 'VCS', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR410', '08:45', '11:00', 'VCS', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR411', '08:45', '11:00', 'VCS', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR412', '09:40', '12:00', 'VCS', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR413', '09:40', '12:00', 'VCS', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR414', '09:40', '12:00', 'VCS', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR415', '09:40', '12:00', 'VCS', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR416', '09:40', '12:00', 'VCS', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR417', '14:35', '16:50', 'VCS', 'HPH', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR418', '14:35', '16:50', 'VCS', 'HPH', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR419', '14:35', '16:50', 'VCS', 'HPH', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR420', '14:35', '16:50', 'VCS', 'HPH', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR421', '14:35', '16:50', 'VCS', 'HPH', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR422', '15:50', '18:05', 'VCS', 'HPH', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR423', '15:50', '18:05', 'VCS', 'HPH', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR424', '15:50', '18:05', 'VCS', 'HPH', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR425', '15:50', '18:05', 'VCS', 'HPH', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR426', '15:50', '18:05', 'VCS', 'HPH', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR427', '15:45', '16:50', 'DAD', 'BMV', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR428', '15:45', '16:50', 'DAD', 'BMV', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR429', '15:45', '16:50', 'DAD', 'BMV', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR430', '15:45', '16:50', 'DAD', 'BMV', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR431', '15:45', '16:50', 'DAD', 'BMV', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR432', '12:45', '14:15', 'DAD', 'VCA', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR433', '12:45', '14:15', 'DAD', 'VCA', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR434', '12:45', '14:15', 'DAD', 'VCA', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR435', '12:45', '14:15', 'DAD', 'VCA', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR436', '12:45', '14:15', 'DAD', 'VCA', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR437', '07:50', '09:30', 'DAD', 'VCS', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR438', '07:50', '09:30', 'DAD', 'VCS', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR439', '07:50', '09:30', 'DAD', 'VCS', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR440', '07:50', '09:30', 'DAD', 'VCS', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR441', '07:50', '09:30', 'DAD', 'VCS', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR442', '09:30', '10:30', 'DAD', 'DLI', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR443', '09:30', '10:30', 'DAD', 'DLI', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR444', '09:30', '10:30', 'DAD', 'DLI', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR445', '09:30', '10:30', 'DAD', 'DLI', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR446', '09:30', '10:30', 'DAD', 'DLI', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR447', '16:45', '23:05', 'DAD', 'ICN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR448', '16:45', '23:05', 'DAD', 'ICN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR449', '16:45', '23:05', 'DAD', 'ICN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR450', '16:45', '23:05', 'DAD', 'ICN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR451', '16:45', '23:05', 'DAD', 'ICN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR452', '11:30', '12:50', 'DAD', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR453', '11:30', '12:50', 'DAD', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR454', '11:30', '12:50', 'DAD', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR455', '11:30', '12:50', 'DAD', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR456', '11:30', '12:50', 'DAD', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR457', '22:20', '23:40', 'DAD', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR458', '22:20', '23:40', 'DAD', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR459', '22:20', '23:40', 'DAD', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR460', '22:20', '23:40', 'DAD', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR461', '22:20', '23:40', 'DAD', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR462', '13:10', '14:30', 'DAD', 'HAN', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR463', '13:10', '14:30', 'DAD', 'HAN', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR464', '13:10', '14:30', 'DAD', 'HAN', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR465', '13:10', '14:30', 'DAD', 'HAN', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR466', '13:10', '14:30', 'DAD', 'HAN', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR467', '18:30', '19:40', 'DAD', 'HPH', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR468', '18:30', '19:40', 'DAD', 'HPH', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR469', '18:30', '19:40', 'DAD', 'HPH', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR470', '18:30', '19:40', 'DAD', 'HPH', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR471', '18:30', '19:40', 'DAD', 'HPH', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR472', '09:30', '11:15', 'HAN', 'BMV', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR473', '09:30', '11:15', 'HAN', 'BMV', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR474', '09:30', '11:15', 'HAN', 'BMV', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR475', '09:30', '11:15', 'HAN', 'BMV', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR476', '09:30', '11:15', 'HAN', 'BMV', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR477', '07:25', '09:35', 'HAN', 'VCA', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR478', '07:25', '09:35', 'HAN', 'VCA', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR479', '07:25', '09:35', 'HAN', 'VCA', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR480', '07:25', '09:35', 'HAN', 'VCA', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR481', '07:25', '09:35', 'HAN', 'VCA', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR482', '16:45', '19:00', 'HAN', 'VCA', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR483', '16:45', '19:00', 'HAN', 'VCA', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR484', '16:45', '19:00', 'HAN', 'VCA', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR485', '16:45', '19:00', 'HAN', 'VCA', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR486', '16:45', '19:00', 'HAN', 'VCA', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR487', '12:00', '15:30', 'HAN', 'KHH', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR488', '12:00', '15:30', 'HAN', 'KHH', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR489', '12:00', '15:30', 'HAN', 'KHH', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR490', '12:00', '15:30', 'HAN', 'KHH', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR491', '12:00', '15:30', 'HAN', 'KHH', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR492', '11:40', '13:55', 'HAN', 'VCS', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR493', '11:40', '13:55', 'HAN', 'VCS', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR494', '11:40', '13:55', 'HAN', 'VCS', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR495', '11:40', '13:55', 'HAN', 'VCS', '2020-11-25', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR496', '11:40', '13:55', 'HAN', 'VCS', '2020-11-26', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR497', '13:35', '14:55', 'HAN', 'DAD', '2020-11-22', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR498', '13:35', '14:55', 'HAN', 'DAD', '2020-11-23', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR499', '13:35', '14:55', 'HAN', 'DAD', '2020-11-24', null)
INSERT INTO Flight(FlightId, StartTime, EndTime, StartPointId, EndPointId, FlightDate, FlightNote) 
VALUES('AR500', '13:35', '14:55', 'HAN', 'DAD', '2020-11-25', null)


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

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR318', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR318', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR318', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR319', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR319', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR319', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR320', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR320', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR320', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR321', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR321', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR321', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR322', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR322', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR322', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR323', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR323', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR323', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR324', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR324', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR324', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR325', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR325', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR325', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR326', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR326', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR326', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR327', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR327', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR327', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR328', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR328', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR328', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR329', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR329', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR329', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR330', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR330', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR330', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR331', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR331', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR331', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR332', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR332', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR332', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR333', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR333', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR333', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR334', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR334', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR334', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR335', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR335', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR335', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR336', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR336', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR336', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR337', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR337', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR337', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR338', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR338', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR338', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR339', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR339', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR339', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR340', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR340', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR340', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR341', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR341', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR341', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR342', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR342', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR342', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR343', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR343', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR343', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR344', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR344', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR344', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR345', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR345', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR345', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR346', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR346', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR346', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR347', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR347', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR347', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR348', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR348', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR348', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR349', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR349', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR349', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR350', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR350', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR350', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR351', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR351', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR351', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR352', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR352', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR352', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR353', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR353', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR353', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR354', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR354', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR354', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR355', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR355', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR355', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR356', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR356', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR356', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR357', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR357', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR357', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR358', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR358', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR358', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR359', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR359', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR359', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR360', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR360', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR360', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR361', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR361', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR361', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR362', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR362', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR362', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR363', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR363', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR363', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR364', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR364', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR364', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR365', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR365', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR365', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR366', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR366', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR366', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR367', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR367', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR367', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR368', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR368', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR368', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR369', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR369', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR369', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR370', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR370', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR370', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR371', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR371', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR371', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR372', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR372', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR372', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR373', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR373', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR373', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR374', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR374', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR374', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR375', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR375', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR375', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR376', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR376', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR376', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR377', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR377', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR377', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR378', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR378', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR378', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR379', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR379', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR379', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR380', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR380', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR380', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR381', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR381', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR381', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR382', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR382', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR382', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR383', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR383', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR383', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR384', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR384', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR384', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR385', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR385', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR385', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR386', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR386', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR386', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR387', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR387', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR387', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR388', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR388', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR388', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR389', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR389', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR389', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR390', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR390', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR390', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR391', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR391', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR391', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR392', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR392', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR392', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR393', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR393', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR393', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR394', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR394', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR394', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR395', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR395', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR395', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR396', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR396', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR396', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR397', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR397', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR397', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR398', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR398', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR398', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR399', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR399', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR399', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR400', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR400', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR400', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR401', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR401', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR401', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR402', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR402', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR402', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR403', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR403', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR403', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR404', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR404', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR404', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR405', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR405', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR405', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR406', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR406', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR406', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR407', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR407', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR407', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR408', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR408', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR408', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR409', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR409', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR409', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR410', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR410', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR410', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR411', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR411', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR411', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR412', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR412', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR412', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR413', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR413', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR413', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR414', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR414', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR414', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR415', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR415', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR415', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR416', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR416', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR416', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR417', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR417', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR417', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR418', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR418', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR418', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR419', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR419', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR419', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR420', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR420', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR420', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR421', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR421', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR421', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR422', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR422', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR422', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR423', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR423', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR423', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR424', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR424', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR424', 50, 48, 5, 50, 45, 10, 12)



INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR425', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR425', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR425', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR426', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR426', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR426', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR427', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR427', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR427', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR428', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR428', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR428', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR429', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR429', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR429', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR430', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR430', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR430', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR431', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR431', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR431', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR432', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR432', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR432', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR433', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR433', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR433', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR434', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR434', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR434', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR435', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR435', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR435', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR436', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR436', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR436', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR437', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR437', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR437', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR438', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR438', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR438', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR439', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR439', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR439', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR440', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR440', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR440', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR441', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR441', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR441', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR442', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR442', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR442', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR443', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR443', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR443', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR444', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR444', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR444', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR445', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR445', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR445', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR446', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR446', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR446', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR447', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR447', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR447', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR448', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR448', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR448', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR449', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR449', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR449', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR450', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR450', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR450', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR451', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR451', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR451', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR452', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR452', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR452', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR453', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR453', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR453', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR454', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR454', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR454', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR455', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR455', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR455', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR456', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR456', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR456', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR457', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR457', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR457', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR458', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR458', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR458', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR459', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR459', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR459', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR460', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR460', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR460', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR461', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR461', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR461', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR462', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR462', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR462', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR463', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR463', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR463', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR464', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR464', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR464', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR465', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR465', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR465', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR466', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR466', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR466', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR467', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR467', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR467', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR468', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR468', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR468', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR469', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR469', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR469', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR470', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR470', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR470', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR471', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR471', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR471', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR472', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR472', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR472', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR473', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR473', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR473', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR474', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR474', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR474', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR475', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR475', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR475', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR476', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR476', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR476', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR477', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR477', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR477', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR478', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR478', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR478', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR479', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR479', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR479', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR480', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR480', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR480', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR481', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR481', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR481', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR482', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR482', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR482', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR483', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR483', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR483', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR484', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR484', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR484', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR485', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR485', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR485', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR486', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR486', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR486', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR487', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR487', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR487', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR488', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR488', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR488', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR489', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR489', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR489', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR490', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR490', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR490', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR491', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR491', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR491', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR492', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR492', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR492', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR493', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR493', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR493', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR494', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR494', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR494', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR495', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR495', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR495', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR496', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR496', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR496', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR497', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR497', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR497', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR498', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR498', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR498', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR499', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR499', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR499', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('ECO', 'AR500', 25, 22, 5, 40, 30, 10, 100)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('PRE', 'AR500', 35, 32, 5, 45, 35, 10, 30)
INSERT INTO TicketClassDetail(TicketClassId, FlightId, AdultTicketPrice, ChildTicketPrice, InfantTicketPrice, AdultTex, ChildTex,
InfantTex, NumberTicket)
VALUES('BUS', 'AR500', 50, 48, 5, 50, 45, 10, 12)

INSERT INTO AdminAccount(AdminId ,AdminFirstName, AdminLastName, AdminPassword, AdminBirthday, AdminEmail, AdminPhoneNumber, AdminGender, AdminRights, Salt, CreatorId)
VALUES('9999999999','Admin', 'Account', '1W3iLH6zn1kytETu5tqLBWL9zJM0qqqjoS86xeGLjdc=', '1999-09-09', 'arsadmin@gmail.com', '9999999999', 0, 0, 'wINBg2rrUCMgOohIEOeuGA==', '9999999999')

-- select * from AdminAccount
-- select * from CustomerAccount
-- select * from Booking
-- select * from TicketClassDetail
-- select * from Ticket
-- select * from Flight
-- select * from TimeSlot
-- delete from CustomerAccount
-- delete from Booking
-- delete from Ticket
-- delete from AdminAccount