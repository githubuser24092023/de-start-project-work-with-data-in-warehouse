-- source1.craft_market_wide definition

-- Drop table

-- DROP TABLE source1.craft_market_wide;

CREATE TABLE source1.craft_market_wide (
	id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_name varchar NOT NULL,
	craftsman_address varchar NOT NULL,
	craftsman_birthday date NOT NULL,
	craftsman_email varchar NOT NULL,
	product_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	product_name varchar NOT NULL,
	product_description varchar NOT NULL,
	product_type varchar NOT NULL,
	product_price int8 NOT NULL,
	order_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	order_created_date date NULL,
	order_completion_date date NULL,
	order_status varchar NOT NULL,
	customer_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	customer_name varchar NULL,
	customer_address varchar NULL,
	customer_birthday date NULL,
	customer_email varchar NOT NULL,
	CONSTRAINT craft_market_wide_pk PRIMARY KEY (id)
);