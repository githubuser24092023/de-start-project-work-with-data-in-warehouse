-- dwh.d_craftsman definition

-- Drop table

-- DROP TABLE dwh.d_craftsman;

CREATE TABLE dwh.d_craftsman (
	craftsman_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_name varchar NOT NULL,
	craftsman_address varchar NOT NULL,
	craftsman_birthday date NOT NULL,
	craftsman_email varchar NOT NULL,
	load_dttm timestamp NOT NULL,
	CONSTRAINT craftsman_pk PRIMARY KEY (craftsman_id)
);