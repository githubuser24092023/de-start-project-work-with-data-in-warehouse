-- source3.craft_market_craftsmans definition

-- Drop table

-- DROP TABLE source3.craft_market_craftsmans;

CREATE TABLE source3.craft_market_craftsmans (
	craftsman_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_name varchar NOT NULL,
	craftsman_address varchar NOT NULL,
	craftsman_birthday date NOT NULL,
	craftsman_email varchar NOT NULL,
	CONSTRAINT craft_market_craftsmans_pk PRIMARY KEY (craftsman_id)
);