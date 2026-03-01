-- source2.craft_market_masters_products definition

-- Drop table

-- DROP TABLE source2.craft_market_masters_products;

CREATE TABLE source2.craft_market_masters_products (
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
	CONSTRAINT craft_market_masters_products_pk PRIMARY KEY (craftsman_id)
);