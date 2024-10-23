create table if NOT EXISTS UserData(
	UserId TEXT PRIMARY KEY NOT NULL UNIQUE,
	Password TEXT,
	IsActive INTEGER,
	RoleID TEXT,
	UserSince TEXT,
	LastLogin TEXT);

create table if NOT EXISTS Settings(
	InactivityTimeout INTEGER);

create table if NOT EXISTS SessionLogs(
	SessionId TEXT PRIMARY KEY NOT NULL UNIQUE,
	UserId TEXT,
	LoginTimeStamp INTEGER,
	LogoutTimeStamp INTEGER);

create table if NOT EXISTS ActivityLogs(
	Timestamp TEXT,
	UserId TEXT,
	Activity TEXT,
	Description TEXT);
		
INSERT into UserData(UserId,Password,IsActive,RoleID,UserSince,LastLogin) values('ADMIN','I90M3V2QqsfWn3nhcjtlpw==',0,'RID1','20240916114612','');
INSERT into Settings(InactivityTimeout) values(45);