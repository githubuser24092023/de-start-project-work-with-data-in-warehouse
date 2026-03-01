-- dwh.d_customer definition

-- Drop table

-- DROP TABLE dwh.d_customer;

CREATE TABLE dwh.d_customer (
	customer_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	customer_name varchar NULL,
	customer_address varchar NULL,
	customer_birthday date NULL,
	customer_email varchar NOT NULL,
	load_dttm timestamp NOT NULL,
	CONSTRAINT customers_pk PRIMARY KEY (customer_id)
);