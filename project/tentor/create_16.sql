CREATE TABLE Publishers (
name VARCHAR(50) PRIMARY KEY NOT NULL,
phone VARCHAR(15) UNIQUE NOT NULL,
city VARCHAR(50)
);
CREATE TABLE Journals (
publisher VARCHAR(50) REFERENCES Publishers(name) ON UPDATE CASCADE,
name VARCHAR(50) PRIMARY KEY
);
CREATE TABLE Editors (
id INT PRIMARY KEY,
name VARCHAR(50),
address VARCHAR(50)
);
CREATE TABLE Issues (
journal VARCHAR(50) REFERENCES Journals(name),
isbn VARCHAR(20) PRIMARY KEY,
number INT NOT NULL,
volume INT NOT NULL,
pubDate DATE,
editor INT REFERENCES Editors(id),
pages INT
);
CREATE TABLE Articles (
id CHAR(10) NOT NULL,
title VARCHAR(50) NOT NULL,
isbn VARCHAR(20),
page INT CHECK (page > 0),
length INT NOT NULL CHECK (length > 0),
PRIMARY KEY (id, isbn),
FOREIGN KEY (isbn) REFERENCES Issues(isbn)
);

CREATE TABLE Authors (
id CHAR(10) PRIMARY KEY,
name VARCHAR(50) NOT NULL
);

CREATE TABLE Authorship(
id CHAR(10) REFERENCES Authors(id),
article CHAR(10),
isbn VARCHAR(20) REFERENCES Issues(isbn),
namePosition INT (namePosition > 0),
PRIMARY KEY (id, article, isbn),
FOREIGN KEY (article, isbn) REFERENCES Articles(id, isbn)
DEFERRABLE INITALLY DEFERRED
);

CREATE TABLE Keywords(
keyword VARCHAR(20),
id CHAR(10),
isbn VARCHAR(20) REFERENCES Issues(isbn),
PRIMARY KEY (keyword, id, isbn),
FOREIGN KEY (id, isbn) REFERENCES Articles(id, isbn)
DEFERRABLE INITALLY DEFERRED);