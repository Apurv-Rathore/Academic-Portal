create ROLE student; 
create ROLE faculty WITH  CREATE ROLE "Faculty" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;

create ROLE faculty WITH  CREATE ROLE "Batch_Advisor" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;
    
create ROLE faculty WITH  CREATE ROLE "Dean_Academics_Office" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;,
