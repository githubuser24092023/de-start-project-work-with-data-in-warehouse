-- dwh.d_product definition

-- Drop table

-- DROP TABLE dwh.d_product;

CREATE TABLE dwh.d_product (
	product_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	product_name varchar NOT NULL,
	product_description varchar NOT NULL,
	product_type varchar NOT NULL,
	product_price int8 NOT NULL,
	load_dttm timestamp NOT NULL,
	CONSTRAINT products_pk PRIMARY KEY (product_id)
);