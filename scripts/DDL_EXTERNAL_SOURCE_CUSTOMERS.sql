-- external_source.customers definition

-- Drop table

-- DROP TABLE external_source.customers;

CREATE TABLE external_source.customers (
	customer_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	customer_name varchar NULL,
	customer_address varchar NULL,
	customer_birthday date NULL,
	customer_email varchar NOT NULL,
	CONSTRAINT external_customers_pk PRIMARY KEY (customer_id)
);