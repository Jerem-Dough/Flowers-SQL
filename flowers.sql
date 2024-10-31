-- flowers database
-- created at: 07/06/2024
-- author: Jeremy Dougherty

-- database creation and use

    CREATE DATABASE flowers;

    \c flowers

-- tables creation satisfying all of the requirements

    CREATE TABLE Zones (
        id SMALLINT,
        lowerTemp SMALLINT NOT NULL,
        higherTemp SMALLINT NOT NULL,
        PRIMARY KEY (id)
    );

    CREATE TABLE Deliveries (
        id SMALLINT,
        categ CHAR(5),
        delSize NUMERIC(5,3),
        PRIMARY KEY (id)
    );

    CREATE TABLE FlowersInfo (
        id SMALLINT,
        comName CHAR(30),
        latName CHAR(35),
        cZone SMALLINT,
        FOREIGN KEY (cZone) REFERENCES Zones(id),
        hZone SMALLINT,
        FOREIGN KEY (hZone) REFERENCES Zones(id),
        deliver SMALLINT,
        FOREIGN KEY (deliver) REFERENCES Deliveries(id),
        sunNeeds CHAR(5),
        PRIMARY KEY (id)
    );

-- tables population

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (2,-50,-40);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (3,-40,-30);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (4,-30,-20);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (5,-20,-10);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (6,-10,0);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (7,0,10);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (7,0,10);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (8,10,20);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (9,20,30);

    INSERT INTO Zones (id,lowerTemp,higherTemp)
    VALUES (10,30,40);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (1,'pot',1.500);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (2,'pot',2.250);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (3,'pot',2.625);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (4,'pot',4.250);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (5,'plant',NULL);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (6,'bulb',NULL);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (7,'hedge',18.000);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (8,'shrub',24.000);

    INSERT INTO Deliveries (id,categ,delSize)
    VALUES (9,'tree',36.000);

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (101,'Lady Fern','Atbyrium filix-femina',2,9,5,'SH');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (102,'Pink Caladiums','C.x bortulanum',10,10,6,'PtoSH');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (103,'Lily-of-the-Valley','Convallaria majalis',2,8,5,'PtoSH');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (105,'Purple Liatris','Liatris spicata',3,9,6,'StoP');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (106,'Black Eyed Susan','Rudbeckia fulgida var. specios',4,10,2,'StoP');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (107,'Nikko Blue Hydrangea','Hydrangea macrophylla',5,9,4,'StoSH');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (108,'Variegated Weigela','W. florida Variegata',4,9,8,'StoP');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (110,'Lombardy Poplar','Populus nigra Italica',3,9,9,'S');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (111,'Purple Leaf Plum Hedge','Prunus x cistena',2,8,7,'S');

    INSERT INTO FlowersInfo (id,comName,latName,cZone,hZone,deliver,sunNeeds)
    VALUES (114,'Thorndale Ivy','Hedera belix Thorndale',3,9,1,'StoSH');

    SELECT * FROM Zones;
    SELECT * FROM Deliveries;
    SELECT * FROM FlowersInfo;

-- a) the total number of zones.

    SELECT COUNT(*) AS num_of_zones FROM Zones;

-- b) the number of flowers per cool zone.

    SELECT cZone, COUNT(*) AS flowers_per_cZone
    FROM FlowersInfo
    Group BY cZone;

-- c) common names of the plants that have delivery sizes less than 5.

    SELECT A.comName AS "Name", B.delSize AS "Delivery Size" FROM FlowersInfo A
    INNER JOIN Deliveries B 
    ON A.deliver = B.id
    WHERE B.delSize < 5;

-- d) common names of the plants that require full sun (i.e., sun needs contains ‘S’).

    SELECT comName
    FROM FlowersInfo
    WHERE sunNeeds = 'S';

-- e) all delivery category names order alphabetically (without repetition).

    SELECT DISTINCT categ
    FROM Deliveries
    ORDER BY categ ASC;

-- f) the exact output (see instructions)

    SELECT A.comName AS "Name", B.lowerTemp AS "Cool Zone (low)", B.higherTemp AS "Cool Zone (high)", C.categ AS "Delivery Category" 
    FROM FlowersInfo A
    INNER JOIN Zones B
    ON A.cZone = B.id
    INNER JOIN Deliveries C
    ON A.deliver = C.id
    ORDER BY A.comName;

-- g) plant names that have the same hot zone as “Pink Caladiums” (your solution MUST get the hot zone of “Pink Caladiums” using a subquery).

    SELECT comName AS "Name", hZone AS "Cool Zone (high)"
    FROM FlowersInfo
    WHERE hZone = (
        SELECT hZone
        FROM FlowersInfo
        WHERE comName = 'Pink Caladiums'
    );

-- h) the total number of plants, the minimum delivery size, the maximum delivery size, and the average size based on the plants that have delivery sizes (note that the average value should be rounded using two decimals).

    SELECT COUNT(A.id) AS "Number of Plants",
    MIN(B.delSize) AS "Min Delivery Size",
    MAX(B.delSize) AS "Max Delivery Size",
    ROUND(AVG(B.delSize),2) AS "Average Delivery Size"
    FROM FlowersInfo A
    INNER JOIN Deliveries B ON A.deliver = B.id;

-- i) the Latin name of the plant that has the word ‘Eyed’ in its name (you must use LIKE in this query to get full credit).  

    SELECT latName
    FROM FlowersInfo
    WHERE comName LIKE '%Eyed%';

-- j) the exact output (see instructions)

    SELECT B.categ AS "Category", A.comName AS "Name"
    FROM FlowersInfo A
    INNER JOIN Deliveries B ON A.deliver = B.id
    ORDER BY B.categ, A.comName;
